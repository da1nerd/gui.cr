require "./animator.cr"
require "./render_data.cr"

module GUI
  class Component
    @animator : GUI::Animator
    @children : Hash(GUI::Component, GUI::Constraints)

    getter animator

    def initialize
      @children = {} of GUI::Component => GUI::Constraints
      @animator = GUI::Animator.new
    end

    def add(component : GUI::Component, constraints : GUI::Constraints)
      @children[component] = constraints
    end

    def to_render_data : Array(GUI::RenderData)
      data = [] of GUI::RenderData
      @children.each do |component, constraints|
        x = constraints.x
        y = constraints.y
        width = constraints.width
        height = constraints.height
        # TODO: solve constraints
        data << GUI::RenderData.new(x.value, y.value, width.value, height.value, GUI::Color::GREY)
      end
      return data
    end

    protected def init
    end

    protected def update
    end
  end
end
