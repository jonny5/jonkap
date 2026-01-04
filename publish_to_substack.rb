#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rexml/document'
require 'cgi'
require 'date'

# RSS to Substack Publisher
# Reads your Jekyll RSS feed and prepares posts for Substack publishing.

class SubstackPublisher
  def initialize(feed_path = '_site/feed.xml')
    @feed_path = feed_path
    @posts = []
  end

  def run
    unless File.exist?(@feed_path)
      puts "Error: RSS feed not found at #{@feed_path}"
      puts "Please run 'bundle exec jekyll build' first to generate the feed."
      exit 1
    end

    parse_feed
    display_posts
    selected_post = get_user_selection
    substack_post = prepare_for_substack(selected_post)
    save_to_file(substack_post)
    show_next_steps(substack_post)
  end

  private

  def parse_feed
    puts "Reading RSS feed..."
    file = File.read(@feed_path)
    doc = REXML::Document.new(file)

    doc.elements.each('feed/entry') do |entry|
      post = {
        title: entry.elements['title'].text,
        link: entry.elements['link'].attributes['href'],
        published: entry.elements['published'].text,
        content: entry.elements['content'].text,
        summary: entry.elements['summary']&.text || '',
        categories: []
      }

      entry.elements.each('category') do |cat|
        post[:categories] << cat.attributes['term']
      end

      @posts << post
    end

    if @posts.empty?
      puts "No posts found in RSS feed."
      exit 1
    end
  end

  def display_posts
    puts "\n" + "=" * 80
    puts "Available Posts from RSS Feed"
    puts "=" * 80 + "\n"

    @posts.each_with_index do |post, i|
      pub_date = DateTime.parse(post[:published])
      puts "#{i + 1}. #{post[:title]}"
      puts "   Published: #{pub_date.strftime('%Y-%m-%d')}"
      puts "   Link: #{post[:link]}"
      puts "   Categories: #{post[:categories].join(', ')}" unless post[:categories].empty?
      puts
    end
  end

  def get_user_selection
    loop do
      print "Select post number (or 'q' to quit): "
      selection = gets.chomp

      exit 0 if selection.downcase == 'q'

      if selection.match?(/^\d+$/)
        post_num = selection.to_i
        if post_num >= 1 && post_num <= @posts.length
          return @posts[post_num - 1]
        else
          puts "Please enter a number between 1 and #{@posts.length}"
        end
      else
        puts "Please enter a valid number or 'q' to quit"
      end
    end
  end

  def convert_footnotes(content)
    # Convert footnote references to simple brackets
    # Pattern: <sup id="fnref:1" role="doc-noteref"><a href="#fn:1" class="footnote" rel="footnote">1</a></sup>
    content = content.gsub(
      /<sup id="fnref:\d+" role="doc-noteref"><a href="#fn:\d+" class="footnote" rel="footnote">(\d+)<\/a><\/sup>/,
      '[\1]'
    )

    # Clean up footnotes section
    content = content.gsub(
      /<a href="#fnref:\d+" class="reversefootnote" role="doc-backlink">&#8617;<\/a>/,
      ''
    )

    # Replace footnotes div with cleaner section
    content = content.gsub(
      /<div class="footnotes" role="doc-endnotes">(.*?)<\/div>/m,
      '<hr><h3>Notes</h3>\1'
    )

    content
  end

  def prepare_for_substack(post)
    puts "\nPreparing: #{post[:title]}"

    # Unescape HTML entities
    content = CGI.unescapeHTML(post[:content])

    # Convert footnotes
    content = convert_footnotes(content)

    # Add canonical link
    canonical_note = "\n\n<hr>\n\n<p><em>Originally published at <a href=\"#{post[:link]}\">#{post[:link]}</a></em></p>"

    {
      title: post[:title],
      content: content + canonical_note,
      original_link: post[:link],
      published: post[:published],
      categories: post[:categories],
      summary: post[:summary]
    }
  end

  def save_to_file(post_data)
    # Generate output filename
    title_slug = post_data[:title]
                 .downcase
                 .gsub(/[^\w\s-]/, '')
                 .gsub(/[-\s]+/, '-')

    output_file = "substack_#{title_slug}.html"

    File.open(output_file, 'w') do |f|
      f.puts "TITLE: #{post_data[:title]}"
      f.puts "ORIGINAL LINK: #{post_data[:original_link]}"
      f.puts "PUBLISHED: #{post_data[:published]}"
      f.puts "CATEGORIES: #{post_data[:categories].join(', ')}" unless post_data[:categories].empty?
      f.puts "\n" + "=" * 80 + "\n"
      f.puts "CONTENT (HTML - Copy this into Substack):\n\n"
      f.puts post_data[:content]
      f.puts "\n\n" + "=" * 80
    end

    @output_file = output_file
    puts "\n✓ Post prepared and saved to: #{output_file}"
  end

  def show_next_steps(post_data)
    puts "\n" + "=" * 80
    puts "NEXT STEPS:"
    puts "=" * 80
    puts "1. Open #{@output_file}"
    puts "2. Copy the HTML content section"
    puts "3. Go to Substack > New Post"
    puts "4. Paste the content into Substack's editor"
    puts "5. In Substack settings, set 'Canonical URL' to:"
    puts "   #{post_data[:original_link]}"
    puts "\nThis tells search engines your personal site is the original source."
    puts "=" * 80 + "\n"
  end
end

# Run the script
SubstackPublisher.new.run
