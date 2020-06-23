require "./animator.cr"
require "./render_data.cr"

module GUI
  class Component
    @animator : GUI::Animator
    @children : Hash(GUI::Component, GUI::Constraints)
    @color : GUI::Color

    getter animator, color

    def initialize
      initialize(GUI::Color::RED)
    end

    def initialize(@color : GUI::Color)
      @children = {} of GUI::Component => GUI::Constraints
      @animator = GUI::Animator.new
    end

    def add(component : GUI::Component, constraints : GUI::Constraints)
      @children[component] = constraints
    end

    # Compiles the constraints so the solver can determine values
    def constrain(solver : Kiwi::Solver, parent_constraints : GUI::Constraints, my_constraints : GUI::Constraints)
      # constraint self
      my_constraints.constrain(solver, parent_constraints)

      # constrain children
      @children.each do |component, child_constraints|
        component.constrain(solver, my_constraints, child_constraints)
      end
    end

    # Converts this component and it's children to `RenderData`
    def to_render_data(vh : Float32, vw : Float32, my_constraints : GUI::Constraints) : Array(GUI::RenderData)
      data = [] of GUI::RenderData
      data << GUI::RenderData.new(
        x: my_constraints.x.value,
        y: my_constraints.y.value,
        width: my_constraints.width.value,
        height: my_constraints.height.value,
        vh: vh,
        vw: vw,
        color: @color
      )
      data + children_to_render_data(vh, vw)
    end

    # Converts the constrained components to an array of `RenderData`.
    # You must `#constrain` this component and `Kiwi::Solver#update_variables` first.
    def children_to_render_data(vh : Float32, vw : Float32) : Array(GUI::RenderData)
      data = [] of GUI::RenderData
      @children.each do |component, constraints|
        data += component.to_render_data(vh, vw, constraints)
      end
      return data
    end

    protected def init
    end

    protected def update
    end
  end
end
