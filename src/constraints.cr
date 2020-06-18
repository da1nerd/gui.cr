require "./constraints/constraint.cr"
require "kiwi"

module GUI
  class Constraints
    @x : GUI::Constraint
    @y : GUI::Constraint
    @width : GUI::Constraint
    @height : GUI::Constraint

    property x, y, width, height

    def initialize(@x : GUI::Constraint, @y : GUI::Constraint, @width : GUI::Constraint, @height : GUI::Constraint)
      # TRICKY: set the variable names here so it's easier to debug logs.
      @x.name = "x"
      @y.name = "y"
      @width.name = "width"
      @height.name = "height"
    end

    # Solves the constraints
    def constrain(solver : Kiwi::Solver, parent : GUI::Constraints)
      @x.constrain_x(solver, self, parent)
      @y.constrain_y(solver, self, parent)
      @width.constrain_width(solver, self, parent)
      @height.constrain_height(solver, self, parent)
    end
  end
end
