#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rexml/document'
require 'cgi'

# RSS to Substack Publisher
# Usage:
#   ruby publish_to_substack.rb monks-bowl     # publish specific post by slug
#   ruby publish_to_substack.rb --latest       # publish most recent post
#   ruby publish_to_substack.rb                # interactive mode (list posts)

class SubstackPublisher
  FEED_PATH = '_site/feed.xml'

  def initialize
    @posts = []
  end

  def run(arg = nil)
    check_feed_exists
    parse_feed

    post = if arg == '--latest'
             @posts.first
           elsif arg
             find_post_by_slug(arg)
           else
             interactive_select
           end

    return unless post

    content = prepare_for_substack(post)
    copy_to_clipboard(content)
    show_confirmation(post)
  end

  private

  def check_feed_exists
    return if File.exist?(FEED_PATH)

    puts "Error: RSS feed not found. Run 'bundle exec jekyll build' first."
    exit 1
  end

  def parse_feed
    doc = REXML::Document.new(File.read(FEED_PATH))

    doc.elements.each('feed/entry') do |entry|
      link = entry.elements['link'].attributes['href']
      # Extract slug from URL (e.g., "https://jonkap.com/monks-bowl.html" -> "monks-bowl")
      slug = link.split('/').last.sub(/\.html$/, '')

      @posts << {
        title: entry.elements['title'].text,
        link: link,
        slug: slug,
        content: entry.elements['content'].text
      }
    end

    if @posts.empty?
      puts "No posts found in RSS feed."
      exit 1
    end
  end

  def find_post_by_slug(slug)
    # Try exact match first
    post = @posts.find { |p| p[:slug] == slug }
    return post if post

    # Try partial match
    matches = @posts.select { |p| p[:slug].include?(slug) }

    if matches.empty?
      puts "No post found matching '#{slug}'"
      puts "\nAvailable posts:"
      @posts.each { |p| puts "  #{p[:slug]}" }
      exit 1
    elsif matches.length == 1
      matches.first
    else
      puts "Multiple matches for '#{slug}':"
      matches.each { |p| puts "  #{p[:slug]}" }
      exit 1
    end
  end

  def interactive_select
    puts "\nAvailable posts:"
    @posts.each_with_index do |post, i|
      puts "  #{i + 1}. #{post[:title]} (#{post[:slug]})"
    end

    print "\nSelect post number (or 'q' to quit): "
    selection = gets.chomp

    exit 0 if selection.downcase == 'q'

    post_num = selection.to_i
    if post_num >= 1 && post_num <= @posts.length
      @posts[post_num - 1]
    else
      puts "Invalid selection"
      exit 1
    end
  end

  def prepare_for_substack(post)
    content = CGI.unescapeHTML(post[:content])

    # Clean up HTML for Substack
    content = clean_html(content)

    # Convert footnotes to simpler format
    content = convert_footnotes(content)

    # Add canonical attribution
    content += "\n\n<hr>\n\n<p><em>Originally published at <a href=\"#{post[:link]}\">#{post[:link]}</a></em></p>"

    content
  end

  def clean_html(content)
    # Remove unnecessary attributes but keep essential ones
    content = content.gsub(/ id="[^"]*"/, '')
    content = content.gsub(/ role="[^"]*"/, '')
    content = content.gsub(/ class="(?!footnote)[^"]*"/, '') # Keep footnote class for processing

    # Clean up any remaining footnote classes after processing
    content
  end

  def convert_footnotes(content)
    # Convert footnote references: <sup...><a class="footnote"...>1</a></sup> -> [1]
    content = content.gsub(
      /<sup[^>]*><a[^>]*class="footnote"[^>]*>(\d+)<\/a><\/sup>/,
      '[\1]'
    )

    # Remove backlinks
    content = content.gsub(/<a[^>]*class="reversefootnote"[^>]*>[^<]*<\/a>/, '')

    # Convert footnotes div to simple Notes section
    content = content.gsub(
      /<div[^>]*class="footnotes"[^>]*>(.*?)<\/div>/m,
      '<hr><h3>Notes</h3>\1'
    )

    # Clean up remaining footnote classes
    content = content.gsub(/ class="footnote[^"]*"/, '')

    content
  end

  def copy_to_clipboard(content)
    IO.popen('pbcopy', 'w') { |io| io.write(content) }
  end

  def show_confirmation(post)
    puts "\n✓ Copied \"#{post[:title]}\" to clipboard"
    puts "\nCanonical URL (set in Substack post settings):"
    puts "  #{post[:link]}"
    puts "\nPaste into Substack editor and publish!"
  end
end

# Run
arg = ARGV[0]
SubstackPublisher.new.run(arg)
