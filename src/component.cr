require "./animator.cr"
require "./color.cr"
require "layout"
require "uuid"
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

    def children=(children)
      super(children.map &.as(::Layout::Block))
    end

    def children
      @children.map &.as(Component)
    end

    # Enumerate over all components in this component's hierarchy.
    def each(&block : Component ->)
      yield self
      children.each do |child|
        child.each(&block)
      end
    end

    def intersects_point?(x, y) : Bool
      @left.value <= x && @right.value >= x && @top.value <= y && @bottom.value >= y
    end
  end
end
