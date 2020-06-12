require "prism"
require "./render_system.cr"
require "./block.cr"
require "./display.cr"
require "./color.cr"
require "./constraint_factory.cr"

module GUI
  class Engine < Prism::Engine
    @[Override]
    def init
      # Register some default systems
      add_system Prism::Systems::InputSystem.new, 1
      add_system GUI::RenderSystem.new, 2

      display = GUI::Display.new
      # adds a full grey background to the screen (because it has no constraints)
      display.add GUI::Block.new(GUI::Color::GREY), GUI::ConstraintFactory.get_fill

      # TODO: The UI should not use entitites to enter the rendering system.
      #  we should simply add a display to the render system on init
      entity = Prism::Entity.new
      entity.add display
      add_entity entity
    end
  end
end
