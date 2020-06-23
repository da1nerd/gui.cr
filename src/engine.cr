require "prism"
require "annotation"
require "./render_system.cr"
require "./block.cr"
require "./display.cr"
require "./color.cr"
require "./constraint_factory.cr"

module GUI
  class Engine < Prism::Engine
    include EventHandler
    @display = GUI::Display.new

    @[Override]
    def init
      # Register some default systems
      add_system Prism::Systems::InputSystem.new, 1
      add_system GUI::RenderSystem.new, 2
      # TODO: The UI should not use entitites to enter the rendering system.
      #  we should simply add a display to the render system on init
      entity = Prism::Entity.new
      entity.add @display
      add_entity entity

      draw_stuff
    end

    def draw_stuff
      # adds a full grey background to the screen (because it has no constraints)
      # @display.add GUI::Block.new(GUI::Color::GREY), GUI::ConstraintFactory.get_fill

      add_line
    end

    @[Override]
    def tick(tick : RenderLoop::Tick, input : RenderLoop::Input)
      @display.size = input.framebuffer_size
    end

    @[Override]
    def flush
      LibGL.viewport(0, 0, @display.size[:width], @display.size[:height])
      LibGL.flush
    end

    def add_line
      constraints = GUI::ConstraintFactory.get_default
      constraints.x = GUI::PixelConstraint.new(20)
      constraints.y = GUI::CenterConstraint.new
      constraints.width = GUI::RelativeConstraint.new(1)
      constraints.height = GUI::PixelConstraint.new(20)
      @display.add GUI::Block.new(GUI::Color::WHITE), constraints
    end
  end
end
