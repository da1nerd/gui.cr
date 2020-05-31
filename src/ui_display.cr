require "./render_data.cr"
require "./ui_component.cr"
require "prism"

module PrismUI
  class UIDisplay < Crash::Component
    def add(component : UIComponent)
      # TODO: implement
    end

    def to_render_data : Array(UIRenderData)
      # TODO: implement
      [] of UIRenderData
    end
  end
end
