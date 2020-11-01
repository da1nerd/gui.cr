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
  class Engine < Prism::Engine
    include EventHandler
    @display = BlockHolder.new

    @[Override]
    def init
      # Register some default systems
      add_system Prism::Systems::InputSystem.new, 1
      add_system GUI::LayoutRenderSystem.new(@display), 2
      draw_stuff
    end

    def draw_stuff
      page = ::Layout::Block.new
      page.label = "display"
      page.x = 0f64
      page.y = 0f64

      header = ::Layout::Block.new
      header.label = "header"
      header.height = 10f64
      header.color = GUI::Color::RED
      body = ::Layout::Block.new
      body.label = "body"
      ancestors = ::Layout::Block.new
      ancestors.color = GUI::Color::BLUE
      ancestors.label = "ancestors"
      ancestors.height = 10f64
      body_content = ::Layout::Block.new(::Layout::Direction::ROW)
      body_content.label = "body content"
      leader_groups = ::Layout::Block.new
      leader_groups.color = GUI::Color::GREEN
      leader_groups.label = "leader groups"
      leader_groups.width = 30f64
      generations = ::Layout::Block.new
      generations.color = GUI::Color::RED
      generations.label = "generations"
      generations.width = 10f64
      graph = ::Layout::Block.new
      graph.color = GUI::Color::GREEN
      graph.label = "graph"
      body_content.children = [
        leader_groups,
        generations,
        graph,
      ]
      body.children = [
        ancestors,
        body_content,
      ]
      metrics = ::Layout::Block.new
      metrics.color = GUI::Color::BLUE
      metrics.label = "metrics"
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
      @display.block.width = input.framebuffer_size[:width].to_f64
      @display.block.height = input.framebuffer_size[:height].to_f64
    end

    @[Override]
    def flush
      LibGL.viewport(0, 0, @display.block.width.value, @display.block.height.value)
      LibGL.flush
    end
  end
end
