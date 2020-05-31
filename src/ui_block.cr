require "./ui_component.cr"
require "./ui_color.cr"

module PrismUI
  class UIBlock < UIComponent
    @color : UIColor

    property color

    def initialize(@color : UIColor)
      super()
    end
  end
end
