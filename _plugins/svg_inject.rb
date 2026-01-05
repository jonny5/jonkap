# frozen_string_literal: true

# Generic SVG injection plugin
# Replaces element content with SVG files based on configuration in _config.yml
#
# Configuration example:
#   svg_inject:
#     - selector: ".reversefootnote"
#       svg: "arrow-up"
#       replace: "content"
#
# SVG files should be stored in _includes/svg/

Jekyll::Hooks.register [:posts, :pages], :post_render do |doc|
  next unless doc.output_ext == '.html'

  config = doc.site.config['svg_inject']
  next unless config.is_a?(Array)

  config.each do |rule|
    selector = rule['selector']
    svg_name = rule['svg']
    replace_mode = rule['replace'] || 'content'

    next unless selector && svg_name

    # Load SVG file
    svg_path = File.join(doc.site.source, '_includes', 'svg', "#{svg_name}.svg")
    next unless File.exist?(svg_path)

    svg_content = File.read(svg_path).strip

    # Convert CSS class selector to regex pattern
    # Supports: .classname, #id, or element.classname
    pattern = selector_to_pattern(selector, replace_mode)
    next unless pattern

    doc.output = doc.output.gsub(pattern) do |match|
      if replace_mode == 'content'
        # Replace inner content, keep the wrapper element
        match.sub(/>.*<\//, ">#{svg_content}</")
      else
        # Replace entire element
        svg_content
      end
    end
  end
end

def selector_to_pattern(selector, replace_mode)
  if selector.start_with?('.')
    # Class selector: .classname
    class_name = selector[1..]
    if replace_mode == 'content'
      # Match opening tag with class, content, and closing tag
      /<([a-z]+)\s+[^>]*class="[^"]*\b#{Regexp.escape(class_name)}\b[^"]*"[^>]*>.*?<\/\1>/m
    else
      /<([a-z]+)\s+[^>]*class="[^"]*\b#{Regexp.escape(class_name)}\b[^"]*"[^>]*>.*?<\/\1>/m
    end
  elsif selector.start_with?('#')
    # ID selector: #id
    id = selector[1..]
    /<([a-z]+)\s+[^>]*id="#{Regexp.escape(id)}"[^>]*>.*?<\/\1>/m
  else
    # Element selector or element.class
    nil
  end
end
