require "./component.cr"
require "./color.cr"

module Layout
  class Block
    # inject some color into the layout block
    @color : GUI::Color = GUI::Color::WHITE

    property color, label
  end
end