module SearchHelper
  def link_to_param(title, param, value = true, options = {})
    link_to title, params.merge(param => (params[param] == value.to_s ? nil : value), page: nil), options
  end

  def nav_list_link(title, param, value = true, options = {})
    css_class = (params[param] == value.to_s ? 'active' : nil)

    content_tag(:li, class: css_class) do
      link_to_param title, param, value, options
    end
  end

  def blank_nav_list_link(title, param, value = true, options = {})
    css_class = (params[param] ? nil : 'active')

    content_tag(:li, class: css_class) do
      link_to_param title, param, value, options
    end
  end

  def link_to_multi_select_param(title, param, value = true)
    param_value = if Array(params[param]).include?(value.to_s)
      Array(params[param]) - [value]
    else
      Array(params[param]) + [value]
    end
    link_to title, params.merge(param => param_value, page: nil)
  end

  def multi_select_nav_list_link(title, param, value = true)
    css_class = (Array(params[param]).include?(value.to_s) ? 'active' : nil)

    content_tag(:li, class: css_class) do
      link_to_multi_select_param title, param, value
    end
  end

  def nav_list_header(title, param)
    close_link =  if params[param]
      link_to('&times;'.html_safe, params.merge(param => nil), class: 'close pull-right')
    end

    content_tag(:li, class: 'nav-header') do
      title.html_safe + close_link.to_s
    end
  end
end
