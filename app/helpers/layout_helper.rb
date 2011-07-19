# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title, show_title = true)
    @show_title = show_title
    @content_for_title = page_title.to_s
  end

  def show_title?
    @show_title
  end

  def hide_top_menu
    @hide_top_menu = true
  end

  def hide_top_menu?
    @hide_top_menu
  end

  def hide_quick_auth
    @hide_quick_auth = true
  end

  def hide_quick_auth?
    @hide_quick_auth || current_user
  end

  def home_page
    @is_home_page = true
  end

  def home_page?
    @is_home_page
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
end

