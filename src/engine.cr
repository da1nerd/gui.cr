require "prism"
require "./render_system.cr"
require "./ui_block.cr"
require "./ui_display.cr"
require "./ui_color.cr"

module PrismUI
  class Engine < Prism::Engine
    @[Override]
    def init
      # Register some default systems
      add_system Prism::Systems::InputSystem.new, 1
      add_system PrismUI::RenderSystem.new, 2

      display = UIDisplay.new
      # adds a full grey background to the screen (because it has not constraints)
      display.add UIBlock.new UIColor::GREY

      # TODO: The UI should not use entitites to enter the rendering system.
      #  we should simply add a display to the render system on init
      entity = Prism::Entity.new
      entity.add display
      add_entity entity
    end
  end
end
