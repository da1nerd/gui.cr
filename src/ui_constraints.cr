require "./ui_constraint.cr"

module PrismUI
  class UIConstraints
    @x : UIConstraint
    @y : UIConstraint
    @width : UIConstraint
    @height : UIConstraint

    property x, y, width, height

    def initialize(@x : UIConstraint, @y : UIConstraint, @width : UIConstraint, @height : UIConstraint)
    end
  end
end
