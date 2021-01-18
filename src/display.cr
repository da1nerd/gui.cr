require "kiwi"
require "./component.cr"
require "annotation"

module GUI
  # The top-most `Component` in the component hierarchy.
  # The display manages input events, and solves the layout constraints.
  class Display < Component
    alias Point = {x: Float64, y: Float64}

    @solver : Kiwi::Solver
    @last_mouse_pos : {x: Float64, y: Float64}
    @mouse_down_pos : Hash(CrystGLFW::MouseButton, Point)

    def initialize
      super("display")
      @solver = Kiwi::Solver.new
      @last_mouse_pos = {x: 0f64, y: 0f64}
      @mouse_down_pos = {} of CrystGLFW::MouseButton => Point
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

    # Loads all of the constraints from every component in this hierarchy into the solver.
    # This should only be ran once.
    def build
      self.each_constraint { |c| @solver.add_constraint(c) }
    end

    # Calculates the layout dimensions.
    # This runs each time the screen is rendered
    def solve
      @solver.update_variables
    end

    # Adds a component to the hierarchy
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
      process_key_down event.input
      process_key_up event.input
      @last_mouse_pos = event.input.get_mouse_position
    end

    private def process_key_down(input : RenderLoop::Input)
      if key = input.keys.find { |k| input.get_key_pressed(k) }
        event = KeyDownEvent.new(key)
        self.each do |component|
          component.on_key_down(event)
        end
      end
    end

    private def process_key_up(input : RenderLoop::Input)
      if key = input.keys.find { |k| input.get_key_released(k) }
        event = KeyUpEvent.new(key)
        self.each do |component|
          component.on_key_up(event)
        end
      end
    end

    private def process_mouse_down(input : RenderLoop::Input)
      mouse_pos = input.get_mouse_position
      if button = input.mouse_buttons.find { |b| input.get_mouse_pressed(b) }
        @mouse_down_pos[button] = mouse_pos
        event = MouseDownEvent.new(button, **mouse_pos)
        self.each do |component|
          next unless event.propagate?
          if component.intersects_point?(**mouse_pos)
            component.on_mouse_down(event)
          end
        end
      end
    end

    private def process_mouse_up(input : RenderLoop::Input)
      mouse_pos = input.get_mouse_position
      if button = input.mouse_buttons.find { |b| input.get_mouse_released(b) }
        if @mouse_down_pos.has_key?(button)
          down_pos = @mouse_down_pos[button]
          @mouse_down_pos.delete(button)
          event = MouseUpEvent.new(CrystGLFW::MouseButton::Left, **mouse_pos)
          self.each do |component|
            next unless event.propagate?
            # TRICKY: also send mouse up events to the component that was clicked.
            if component.intersects_point?(**mouse_pos) || component.intersects_point?(**down_pos)
              component.on_mouse_up(event)
            end
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
