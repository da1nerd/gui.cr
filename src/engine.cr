require "prism"
require "annotation"
require "./layout_render_system.cr"
require "./block.cr"
require "./display.cr"
require "./color.cr"
require "./constraint_factory.cr"
require "./slider.cr"
require "layout"

module GUI
  include Layout

  class Engine < Prism::Engine
    include EventHandler
    @display = BlockHolder.new

    @[Override]
    def init
      # Register some default systems
      add_system Prism::Systems::InputSystem.new, 1
      add_system GUI::LayoutRenderSystem.new(@display), 2
      draw_window
    end

    def draw_window
      @display.block.color = GUI::Color::BLUE

      drawer = Block.new("drawer")
      drawer.color = GUI::Color::GREEN
      drawer.height.eq @display.block.height
      drawer.width.eq 200
      drawer.left.eq 0, Kiwi::Strength::MEDIUM

      content = Block.new("content")
      content.color = GUI::Color::RED
      content.height.eq @display.block.height
      content.width.gte 300
      content.width.eq @display.block.width, Kiwi::Strength::WEAK
      content.left.eq drawer.right
      content.left.lte @display.block.width - content.width

      header = Block.new("header")
      header.color = GUI::Color::GRAY900
      header.height.eq 50
      header.width.eq content.width
      header.left.eq content.left
      header.top.eq @display.block.top
      content.top.eq header.bottom

      title = Block.new("title")
      title.color = GUI::Color::BLUE
      title.height.eq 20
      title.width.eq 200
      title.top.eq content.top + 50
      title.center_x.eq content.center_x

      short_card = Block.new("short_card")
      short_card.color = GUI::Color::BLUE
      short_card.height.eq 200
      short_card.width.eq content.width - 100
      short_card.top.eq title.bottom + 50
      short_card.left.eq content.left + 50

      tall_card = Block.new("tall_card")
      tall_card.color = GUI::Color::BLUE
      tall_card.height.eq 600
      tall_card.width.eq short_card.width
      tall_card.top.eq short_card.bottom + 50
      tall_card.left.eq short_card.left

      @display.block.children = [
        drawer,
        content,
        header,
        title,
        short_card,
        tall_card
      ]
      @display.load
    end

    def draw_stuff
      page = ::Layout::Block.new("page")
      page.x = 0f64
      page.y = 0f64

      header = ::Layout::Block.new("header")
      header.height = 10f64
      header.color = GUI::Color::RED
      body = ::Layout::Block.new("body")
      ancestors = ::Layout::Block.new("ancestors")
      ancestors.color = GUI::Color::BLUE
      ancestors.height = 10f64
      body_content = ::Layout::Block.new(::Layout::Direction::ROW, "body_content")
      leader_groups = ::Layout::Block.new("leader_groups")
      leader_groups.color = GUI::Color::GREEN
      leader_groups.width = 30f64
      generations = ::Layout::Block.new("generations")
      generations.color = GUI::Color::RED
      generations.width = 10f64
      graph = ::Layout::Block.new("graph")
      graph.color = GUI::Color::GREEN
      body_content.children = [
        leader_groups,
        generations,
        graph,
      ]
      body.children = [
        ancestors,
        body_content,
      ]
      metrics = ::Layout::Block.new("metrics")
      metrics.color = GUI::Color::BLUE
      metrics.height = 50f64
      page.children = [
        header,
        body,
        metrics,
      ]
      @display.block = page
    end

    @[Override]
    def tick(tick : RenderLoop::Tick, input : RenderLoop::Input)
      # TODO: this needs to update the variables in the system
      @display.width = input.framebuffer_size[:width].to_f64
      @display.height = input.framebuffer_size[:height].to_f64
    end

    @[Override]
    def flush
      LibGL.viewport(0, 0, @display.block.width.value, @display.block.height.value)
      LibGL.flush
    end
  end
end
