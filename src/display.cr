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

    def initialize
      @root = GUI::Component.new
      @solver = Kiwi::Solver.new
      @size = {width: 0, height: 0}
    end

    def add(component : GUI::Component, constraints : GUI::Constraints)
      @root.add component, constraints
    end

    def resize(@size : RenderLoop::Size)
    end

    def to_render_data : Array(GUI::RenderData)
      # TODO: eventually we want to reuse this.
      @solver = Kiwi::Solver.new

      vw = GUI::PixelConstraint.new(0)
      vh = GUI::PixelConstraint.new(0)
      vx = GUI::PixelConstraint.new(0)
      vy = GUI::PixelConstraint.new(0)
      display_constraints = GUI::Constraints.new(vx, vy, vw, vh)

      @solver.add_constraint vw.var == @size[:width]
      @solver.add_constraint vh.var == @size[:height]
      @solver.add_constraint vx.var == 0
      @solver.add_constraint vy.var == 0

      @root.constrain(@solver, display_constraints, GUI::ConstraintFactory.get_fill)
      @solver.update_variables
      data = @root.to_render_data(vh.value, vw.value)
      pp data
      exit # testing
      data
    end
  end
end
