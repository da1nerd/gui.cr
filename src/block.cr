require "./component.cr"
require "./color.cr"

module GUI
  class Block < GUI::Component
    @color : GUI::Color

    property color

    def initialize(@color : GUI::Color)
      super()
    end
  end
end
