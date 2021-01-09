require "kiwi"
require "./component.cr"
require "annotation"

module GUI
  class Display < Component
    @solver : Kiwi::Solver
    @last_mouse_pos : {x: Float64, y: Float64}
    @mouse_down_pos : {x: Float64, y: Float64}?

    def initialize
      super("display")
      @solver = Kiwi::Solver.new
      @last_mouse_pos = {x: 0f64, y: 0f64}
      top.eq 0
      left.eq 0
      @solver.add_edit_variable(width.variable, Kiwi::Strength::STRONG)
      @solver.add_edit_variable(height.variable, Kiwi::Strength::STRONG)
    end

    # Changes the width of the display
    def width=(size)
      @solver.suggest_value(width.variable, size)
    end

    # Changes the height of the display
    def height=(size)
      @solver.suggest_value(height.variable, size)
    end

    # Loads all of the constraints into the solver
    def build
      self.each_constraint { |c| @solver.add_constraint(c) }
    end

    # Calculates the layout dimensions
    def solve
      @solver.update_variables
    end

    def add(block : Layout::Block)
      @children << block
    end

    def trigger_input(tick : RenderLoop::Tick, input : RenderLoop::Input)
      event = InputEvent.new(tick, input)
      self.each do |component|
        next unless event.propagate?
        component.on_input(event)
      end
    end

    @[Override]
    def on_input(event : InputEvent)
      super(event)
      self.width = event.input.framebuffer_size[:width].to_f64
      self.height = event.input.framebuffer_size[:height].to_f64
      process_mouse_down event.input
      process_mouse_up event.input
      process_hover event.input
      process_mouse_in event.input
      process_mouse_out event.input
      @last_mouse_pos = event.input.get_mouse_position
    end

    private def capture(&block : RenderLoop::Input(CrystGLFW::Key, CrystGLFW::MouseButton), Component -> Nil)
      block
    end

    private def process_mouse_down(input : RenderLoop::Input)
      mouse_pos = input.get_mouse_position
      left_pressed = input.get_mouse_pressed(CrystGLFW::MouseButton::Left)

      if left_pressed
        @mouse_down_pos = mouse_pos
      end

      event = MouseDownEvent.new(**mouse_pos)
      self.each do |component|
        next unless event.propagate?
        if left_pressed && component.intersects_point?(**mouse_pos)
          component.on_mouse_down(event)
        end
      end
    end

    private def process_mouse_up(input : RenderLoop::Input)
      mouse_pos = input.get_mouse_position
      left_released = input.get_mouse_released(CrystGLFW::MouseButton::Left)

      if down_pos = @mouse_down_pos
        event = MouseUpEvent.new(**mouse_pos)
        self.each do |component|
          next unless event.propagate?
          if left_released && component.intersects_point?(**down_pos.not_nil!)
            component.on_mouse_up(event)
          end
        end
      end
    end

    private def process_hover(input : RenderLoop::Input)
      mouse_pos = input.get_mouse_position

      event = HoverEvent.new(**mouse_pos)
      self.each do |component|
        next unless event.propagate?
        if component.intersects_point?(**mouse_pos)
          component.on_hover(event)
        end
      end
    end

    private def process_mouse_in(input : RenderLoop::Input)
      mouse_pos = input.get_mouse_position

      event = MouseInEvent.new(**mouse_pos)
      self.each do |component|
        next unless event.propagate?
        if component.intersects_point?(**mouse_pos) && !component.intersects_point?(**@last_mouse_pos)
          component.on_mouse_in(event)
        end
      end
    end

    private def process_mouse_out(input : RenderLoop::Input)
      mouse_pos = input.get_mouse_position

      event = MouseOutEvent.new(**mouse_pos)
      self.each do |component|
        next unless event.propagate?
        if component.intersects_point?(**@last_mouse_pos) && !component.intersects_point?(**mouse_pos)
          component.on_mouse_out(event)
        end
      end
    end
  end
end
