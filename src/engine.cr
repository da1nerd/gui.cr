require "prism"
require "./render_system.cr"
require "./ui_block.cr"
require "./ui_display.cr"

module PrismUI
  class Engine < Prism::Engine
    @[Override]
    def init
      # Register some default systems
      add_system Prism::Systems::InputSystem.new, 1
      add_system PrismUI::RenderSystem.new, 2

      entity = Prism::Entity.new
      entity.add UIDisplay.new
      add_entity entity
    end
  end
end
