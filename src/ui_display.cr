require "./ui_block.cr"
require "prism"

module PrismUI
  class UIDisplay < Crash::Component
    def to_render_data : Array(UIRenderData)
      [] of UIRenderData
    end
  end
end
