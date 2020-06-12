require "./constraint.cr"
require "./constraints.cr"

module GUI::ConstraintFactory
  extend self

  def get_fill : GUI::Constraints
    x = GUI::Constraint.new
    y = GUI::Constraint.new
    width = GUI::Constraint.new
    height = GUI::Constraint.new
    GUI::Constraints.new(x, y, width, height)
  end
end
