require "prism"
require "./render_system.cr"

module PrismUI
  class Engine < Prism::Engine
    @[Override]
    def init
      # Register some default systems
      add_system Prism::Systems::InputSystem.new, 1
      add_system PrismUI::RenderSystem.new, 2
    end
  end
end
