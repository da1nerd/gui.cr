require "kiwi"
require "./component.cr"

module GUI
  class Display < Component
    @solver : Kiwi::Solver

    def initialize
      super("display")
      @solver = Kiwi::Solver.new
      top.eq 0
      left.eq 0
      @solver.add_edit_variable(width.variable, Kiwi::Strength::STRONG)
      @solver.add_edit_variable(height.variable, Kiwi::Strength::STRONG)
    end

    # Changes the width of the display
    def width=(size)
      @solver.suggest_value(width.variable, size)
    end

    # Changes the height of the display
    def height=(size)
      @solver.suggest_value(height.variable, size)
    end

    # Loads all of the constraints into the solver
    def build
      self.each_constraint { |c| @solver.add_constraint(c) }
    end

    # Calculates the layout dimensions
    def solve
      @solver.update_variables
    end

    def add(block : Layout::Block)
      @children << block
    end
  end
end
