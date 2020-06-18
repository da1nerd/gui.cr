require "./constraints/*"
require "./constraints.cr"

module GUI::ConstraintFactory
  extend self

  # Creates a constraint that will fill the available space
  def get_fill : GUI::Constraints
    # TODO: right now this will fill the screen
    x = GUI::RelativeConstraint.new(0)
    y = GUI::RelativeConstraint.new(0)
    width = GUI::RelativeConstraint.new(1)
    height = GUI::RelativeConstraint.new(1)
    GUI::Constraints.new(x: x, y: y, width: width, height: height)
  end

  def get_default : GUI::Constraints
    x = GUI::RelativeConstraint.new(0)
    y = GUI::RelativeConstraint.new(0)
    width = GUI::RelativeConstraint.new(1)
    height = GUI::RelativeConstraint.new(1)
    GUI::Constraints.new(x: x, y: y, width: width, height: height)
  end
end
