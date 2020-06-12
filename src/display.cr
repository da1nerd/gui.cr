require "./render_data.cr"
require "./component.cr"
require "./constraints.cr"
require "prism"

module GUI
  class GUI::Display < Crash::Component
    @ui_components : Array(GUI::Component)

    def initialize
      @ui_components = [] of GUI::Component
    end

    def add(component : GUI::Component, constraints : GUI::Constraints)
      # TODO: the component needs to be connected to the constraints
      @ui_components << component
    end

    def to_render_data : Array(GUI::RenderData)
      data = [] of GUI::RenderData

      @ui_components.each do |c|
        data << c.to_render_data
      end
      data
    end
  end
end
