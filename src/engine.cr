require "prism"
require "annotation"
require "./render_system.cr"
require "./component.cr"
require "./display.cr"
require "./color.cr"

module GUI
  class Engine < Prism::Engine
    include EventHandler
    @display = Display.new

    @[Override]
    def init
      # Register some default systems
      add_system GUI::RenderSystem.new(@display), 1
      draw_window
    end

    def draw_window
      @display.color = GUI::Color::BLUE

      drawer = Component.new("drawer")
      drawer.color = GUI::Color::GREEN
      drawer.height.eq @display.height
      drawer.width.eq 200
      drawer.left.eq 0, :MEDIUM

      content = Component.new("content")
      content.color = GUI::Color::RED
      content.height.eq @display.height
      content.width.gte 300
      content.width.eq @display.width, :WEAK
      content.left.eq drawer.right
      content.left.lte @display.width - content.width

      header = Component.new("header")
      header.color = GUI::Color::GRAY900
      header.height.eq 50
      header.width.eq content.width
      header.left.eq content.left
      header.top.eq @display.top
      content.top.eq header.bottom

      title = Component.new("title")
      title.color = GUI::Color::BLUE
      title.height.eq 20
      title.width.eq 200
      title.top.eq content.top + 50
      title.center_x.eq content.center_x
      title.on_mouse_in do |event|
        title.color = GUI::Color::GREEN
      end
      title.on_mouse_out do |event|
        title.color = GUI::Color::BLUE
      end

      short_card = Component.new("short_card")
      short_card.color = GUI::Color::BLUE
      short_card.height.eq 200
      short_card.width.eq content.width - 100
      short_card.top.eq title.bottom + 50
      short_card.left.eq content.left + 50
      short_card.on_mouse_down do |event|
        short_card.color = GUI::Color::GREEN
      end
      short_card.on_mouse_up do |event|
        short_card.color = GUI::Color::BLUE
      end

      tall_card = Component.new("tall_card")
      tall_card.color = GUI::Color::BLUE
      tall_card.height.eq 600
      tall_card.width.eq short_card.width
      tall_card.top.eq short_card.bottom + 50
      tall_card.left.eq short_card.left

      @display.children = [
        drawer,
        content,
        header,
        title,
        short_card,
        tall_card,
      ]
      @display.build
    end

    @[Override]
    def tick(tick : RenderLoop::Tick, input : RenderLoop::Input)
      @display.trigger_input(tick: tick, input: input)
    end

    @[Override]
    def flush
      LibGL.viewport(0, 0, @display.width.value, @display.height.value)
      LibGL.flush
    end
  end
end
