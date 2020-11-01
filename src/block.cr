require "./component.cr"
require "./color.cr"

module Layout
  struct Block
    # inject some color into the layout block
    @color : GUI::Color = GUI::Color::WHITE

    property color, label

    # Add enumeration
    def each(&block : ::Layout::Block ->)
      yield self
      if @children.size > 0
        @children.each do |child|
          child.each(&block)
        end
      end
    end
  end
end

module GUI
  class BlockHolder
    @block : ::Layout::Block
    property block

    def initialize
      @block = ::Layout::Block.new
    end
  end

  class Block < GUI::Component
    # color : GUI::Color

    # property color

    def initialize(color : GUI::Color)
      super(color)
    end
  end
end
