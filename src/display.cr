require "./render_data.cr"
require "./component.cr"
require "./constraints.cr"
require "prism"
require "kiwi"

module GUI
  class GUI::Display < Crash::Component
    @root : GUI::Component
    @solver : Kiwi::Solver
    @size : RenderLoop::Size

    property size

    def initialize
      @root = GUI::Component.new
      @solver = Kiwi::Solver.new
      @size = {width: 0, height: 0}
    end

    def add(component : GUI::Component, constraints : GUI::Constraints)
      @root.add component, constraints
    end

    def to_render_data : Array(GUI::RenderData)
      # TODO: eventually we want to reuse this.
      @solver = Kiwi::Solver.new

      vw = GUI::PixelConstraint.new(@size[:width])
      vh = GUI::PixelConstraint.new(@size[:height])
      vx = GUI::PixelConstraint.new(0)
      vy = GUI::PixelConstraint.new(0)
      display_constraints = GUI::Constraints.new(x: vx, y: vy, width: vw, height: vh)

      @solver.add_constraint vw.var == @size[:width]
      @solver.add_constraint vh.var == @size[:height]
      @solver.add_constraint vx.var == 0
      @solver.add_constraint vy.var == 0

      root_contraints = GUI::ConstraintFactory.get_fill
      @root.constrain(@solver, display_constraints, root_contraints)
      @solver.update_variables
      # TODO: we don't actually need to use these. This should be refactored.
      @root.to_render_data(vh.value, vw.value, root_contraints)
    end
  end
end
