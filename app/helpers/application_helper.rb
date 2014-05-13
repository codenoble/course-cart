module ApplicationHelper
  # Set class on active navigation items
  def nav_link(text, link)
      recognized = Rails.application.routes.recognize_path(link)
      if recognized[:controller] == params[:controller] && recognized[:action] == params[:action]
          content_tag(:li, :class => "active") do
              link_to( text, link)
          end
      else
          content_tag(:li) do
              link_to( text, link)
          end
      end
  end

  def breadcrumbs(*links)
    content_tag :ul, class: 'breadcrumb' do
      active_page = links.pop
      list_items = links.map do |link|
        content_tag :li do
          (link.is_a?(Array) ? link_to(link.last.to_s.titleize, link) : link_to(link.to_s.titleize, link))
        end
      end.join.html_safe +
      content_tag(:li, active_page.to_s.titleize, class: 'active')
    end
  end

  def show_environment
    unless Rails.env.match(/prod/i)
      content_tag :span, Rails.env, class: 'label label-danger'
    end
  end
end
