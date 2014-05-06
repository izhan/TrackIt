module ApplicationHelper
  def custom_css_page?
    return controller.controller_name == "static_pages" && (controller.action_name == "home" || controller.action_name == "help")
  end
end
