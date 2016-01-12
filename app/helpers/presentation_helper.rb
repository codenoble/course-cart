module PresentationHelper
  def content_or(content, options = {})
    options[:or] ||= 'N/A'

    content.presence || content_tag(:span, options[:or], class: 'text-muted')
  end
end
