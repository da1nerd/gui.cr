require "./animator.cr"
require "./render_data.cr"

module GUI
  class Component
    @animator : GUI::Animator

    getter animator

    def initialize
      @animator = GUI::Animator.new
    end

    def add(component : GUI::Component, constraints : GUI::Constraints)
    end

    def to_render_data : GUI::RenderData
      # TODO: convert component and constraints to render data
      data = GUI::RenderData.new(0, 0, 0, 0, GUI::Color::GREY)
    end

    protected def init
    end

    protected def update
    end
  end
end
