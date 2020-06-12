require "./constraints/*"
require "./constraints.cr"

module GUI::ConstraintFactory
  extend self

  def get_fill : GUI::Constraints
    x = GUI::RelativeConstraint.new(0)
    y = GUI::RelativeConstraint.new(0)
    width = GUI::RelativeConstraint.new(1)
    height = GUI::RelativeConstraint.new(1)
    GUI::Constraints.new(x, y, width, height)
  end

  def get_relative
  end
end
