require "./constraints/constraint.cr"
require "kiwi"

module GUI
  class Constraints
    @x : GUI::Constraint
    @y : GUI::Constraint
    @width : GUI::Constraint
    @height : GUI::Constraint

    getter x, y, width, height

    def initialize(x : GUI::Constraint, y : GUI::Constraint, width : GUI::Constraint, height : GUI::Constraint)
      @x = x
      @y = y
      @width = width
      @height = height
    end

    {% begin %}
      {% types = [:x, :y, :width, :height] %}
      {% for t in types %}
        # Sets the constraint for "{{t}}".
        def {{t.id}}=(@{{t.id}} : GUI::Constraint)
          # TRICKY: set the variable names here so it's easier to debug logs.
          @{{t.id}}.name = "{{t.id}}"
        end
      {% end %}
    {% end %}

    # TODO: set the constraint names when the properties are updated as well.

    # Solves the constraints
    def constrain(solver : Kiwi::Solver, parent : GUI::Constraints)
      @x.constrain_x(solver, self, parent)
      @y.constrain_y(solver, self, parent)
      @width.constrain_width(solver, self, parent)
      @height.constrain_height(solver, self, parent)
    end
  end
end
