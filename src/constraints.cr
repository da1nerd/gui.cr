require "./constraint.cr"

module GUI
  class Constraints
    @x : GUI::Constraint
    @y : GUI::Constraint
    @width : GUI::Constraint
    @height : GUI::Constraint

    property x, y, width, height

    def initialize(@x : GUI::Constraint, @y : GUI::Constraint, @width : GUI::Constraint, @height : GUI::Constraint)
    end
  end
end
