abstract class StartpageLayout
  include Lucky::HTMLPage

  abstract def content
  abstract def page_title

  # MainLayout defines a default 'page_title'.
  #
  # Add a 'page_title' method to your indivual pages to customize each page's
  # title.
  #
  # Or, if you want to require every page to set a title, change the
  # 'page_title' method in this layout to:
  #
  #    abstract def page_title : String
  #
  # This will force pages to define their own 'page_title' method.
  def page_title
    "Welcome"
  end

  def render
    render_template "layouts/startpage_layout"
  end
end
