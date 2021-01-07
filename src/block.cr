require "./component.cr"
require "./color.cr"

module Layout
  class Block
    # inject some color into the layout block
    @color : GUI::Color = GUI::Color::WHITE

    property color, label
  end
end

module GUI
  class BlockHolder
    @block : ::Layout::Block
    @solver : Kiwi::Solver
    getter block

    def initialize
      @solver = Kiwi::Solver.new
      @block = ::Layout::Block.new("display")
      @block.x.eq 0
      @block.y.eq 0
      @solver.add_edit_variable(@block.width.variable, Kiwi::Strength::STRONG)
      @solver.add_edit_variable(@block.height.variable, Kiwi::Strength::STRONG)
    end

    # Sets the width of the display
    def width=(size)
      @solver.suggest_value(@block.width.variable, size)
    end

    # Sets the width of the display
    def height=(size)
      @solver.suggest_value(@block.height.variable, size)
    end

    # Loads all of the constraints into the solver
    def load
      ::Layout.solve(@block, @solver)
    end

    # Updates the variables
    def solve
      @solver.update_variables
    end
  end
end
