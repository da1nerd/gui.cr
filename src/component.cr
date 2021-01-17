require "./animator.cr"
require "./color.cr"
require "layout"
require "uuid"
require "annotations"
require "./eventable.cr"

module GUI
  class Component < Layout::Block
    include Eventable
    @animator : GUI::Animator
    @color : GUI::Color

    getter animator
    property color

    event :mouse_down, x : Float64, y : Float64
    event :mouse_up, x : Float64, y : Float64
    event :hover, x : Float64, y : Float64
    event :input, tick : RenderLoop::Tick, input : RenderLoop::Input(CrystGLFW::Key, CrystGLFW::MouseButton)
    event :mouse_in, x : Float64, y : Float64
    event :mouse_out, x : Float64, y : Float64

    def initialize
      initialize(UUID.random.to_s)
    end

    def initialize(label : String)
      super(label)
      @animator = GUI::Animator.new
      @color = GUI::Color::WHITE
    end

    @[Override]
    def children=(children)
      super(children.map &.as(::Layout::Block))
    end

    @[Override]
    def children
      @children.map &.as(Component)
    end

    # Enumerate over all components in this component's hierarchy.
    @[Override]
    def each(&block : Component ->)
      yield self
      children.each do |child|
        child.each(&block)
      end
    end

    # Checks if the component intersects the point *x*, *y*
    def intersects_point?(x, y) : Bool
      @left.value <= x && @right.value >= x && @top.value <= y && @bottom.value >= y
    end

    # Generates the matrix transformation used for drawing the component within the viewpoint.
    def transformation(viewport_height vh, viewport_width vw)
      # move component origin to the top left corner, then scale the coordinates.
      scaled_x = scale_to_1(x.value + width.value / 2, vw)
      # TRICKY: the y-axis needs to be flipped
      scaled_y = -scale_to_1(y.value + height.value / 2, vh)

      # scale dimensions
      scaled_height = height.value / vh
      scaled_width = width.value / vw

      translate_matrix = Matrix4f.new.init_translation(scaled_x.to_f32, scaled_y.to_f32, 0f32)
      scale_matrix = Matrix4f.new.init_scale(scaled_width.to_f32, scaled_height.to_f32, 1f32)
      translate_matrix * scale_matrix
    end

    # Scales a *value* from a range of 0..*max* to fit within a range of -1..1
    private def scale_to_1(value, max)
      # convert to range of 0..2
      scale = 2 / (max - 1)
      # convert to a range of -1..1
      value * scale - 1
    end
  end
end
