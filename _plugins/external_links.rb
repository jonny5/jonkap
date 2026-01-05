# frozen_string_literal: true

require 'uri'

# Adds target="_blank" and rel="noopener noreferrer" to external links in posts
Jekyll::Hooks.register [:posts, :pages], :post_render do |doc|
  next unless doc.output_ext == '.html'

  site_url = doc.site.config['url'] || ''
  site_host = site_url.empty? ? '' : URI.parse(site_url).host

  doc.output = doc.output.gsub(/<a\s+([^>]*href=["']https?:\/\/[^"']+["'][^>]*)>/) do |match|
    attrs = Regexp.last_match(1)

    # Skip if already has target attribute
    next match if attrs.include?('target=')

    # Extract the href to check if it's external
    href_match = attrs.match(/href=["'](https?:\/\/[^"']+)["']/)
    next match unless href_match

    link_host = URI.parse(href_match[1]).host rescue nil
    next match unless link_host

    # Skip internal links
    next match if site_host && link_host == site_host

    # Add target and rel attributes
    new_attrs = "#{attrs} target=\"_blank\" rel=\"noopener noreferrer\""
    "<a #{new_attrs}>"
  end
end
