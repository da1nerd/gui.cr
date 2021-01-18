require "./animator.cr"
require "./color.cr"
require "layout"
require "uuid"
require "annotations"
require "./eventable.cr"

module GUI
  class Component
    include Eventable
    @children : Array(Component)
    @block : ::Layout::Block
    @animator : GUI::Animator
    @color : GUI::Color

    getter animator
    property color, children

    delegate :x, :y, :left, :right, :top, :bottom, :center_x, :center_y, :height, :width, to: @block

    # Triggered when a mouse button is pressed down while positioned over the `Component`
    event :mouse_down, button : CrystGLFW::MouseButton, x : Float64, y : Float64
    # Triggered when a mouse button is released.
    event :mouse_up, x : Float64, y : Float64
    # Triggered while the mouse is positioned over the bounding box of the `Component`
    event :hover, x : Float64, y : Float64
    # Triggered when there is an input event.
    # All of the other events are triggered based on the input received here.
    event :input, tick : RenderLoop::Tick, input : RenderLoop::Input(CrystGLFW::Key, CrystGLFW::MouseButton)
    # Triggered when the mouse enters the bounding box of the `Component`
    event :mouse_in, x : Float64, y : Float64
    # Triggered when the mouse leaves the bounding box of the `Component`
    event :mouse_out, x : Float64, y : Float64

    def initialize
      initialize(UUID.random.to_s)
    end

    def initialize(label : String)
      @children = [] of Component
      @block = ::Layout::Block.new(label)
      @animator = GUI::Animator.new
      @color = GUI::Color::WHITE
    end

    # Enumerate over all `Component`s in this `Component`'s hierarchy.
    # This first yields the component itself, then it's children.
    def each(&block : Component ->)
      yield self
      @children.each do |child|
        child.each(&block)
      end
    end

    # Enumerate over all `Kiwi::Constraint`s in this `Component`'s hierarchy
    def each_constraint(&block : Kiwi::Constraint ->)
      @block.primitives.each do |p|
        p.constraints.each { |c| yield c }
      end

      @children.each do |child|
        child.each_constraint(&block)
      end
    end

    # Checks if the component intersects the point *x*, *y*
    def intersects_point?(x, y) : Bool
      left.value <= x && right.value >= x && top.value <= y && bottom.value >= y
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
