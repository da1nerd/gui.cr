require "./render_data.cr"
require "./component.cr"
require "./constraints.cr"
require "prism"

module GUI
  class GUI::Display < Crash::Component
    @ui_components : Hash(GUI::Component, GUI::Constraints)

    def initialize
      @ui_components = {} of GUI::Component => GUI::Constraints
    end

    def add(component : GUI::Component, constraints : GUI::Constraints)
      # TODO: the component needs to be connected to the constraints
      @ui_components[component] = constraints
    end

    def to_render_data : Array(GUI::RenderData)
      data = [] of GUI::RenderData

      # TODO: this block of code is duplicated in the `Component` class. We should abstract this.
      @ui_components.each do |component, constraints|
        x = constraints.x
        y = constraints.y
        width = constraints.width
        height = constraints.height
        # TODO: solve constraints
        data << GUI::RenderData.new(x.value, y.value, width.value, height.value, GUI::Color::GREY)
      end
      data
    end
  end
end
