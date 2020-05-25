require "crash"
require "annotation"
require "./gui_renderer.cr"

module PrismUI
  # A default system for rendering `Prism::Entity`s.
  class RenderSystem < Crash::System
    # RGB
    BACKGROND_COLOR = Vector3f.new(0.80, 0.80, 0.80)
    @guis : Array(Crash::Entity)
    @gui_renderer : Prism::Systems::GUIRenderer = Prism::Systems::GUIRenderer.new

    def initialize
      @guis = [] of Crash::Entity
    end

    @[Override]
    def add_to_engine(engine : Crash::Engine)
      @guis = engine.get_entities Prism::GUIElement
    end

    # Handles the rendering.
    @[Override]
    def render
      # start shading
      prepare
      @gui_renderer.render(@guis)
    end

    @[Override]
    def remove_from_engine(engine : Crash::Engine)
      @guis.clear
    end

    def prepare
      LibGL.clear(LibGL::COLOR_BUFFER_BIT | LibGL::DEPTH_BUFFER_BIT)
      LibGL.clear_color(BACKGROND_COLOR.x, BACKGROND_COLOR.y, BACKGROND_COLOR.z, 1f32)
      LibGL.front_face(LibGL::CW)
      LibGL.cull_face(LibGL::BACK)
      LibGL.enable(LibGL::CULL_FACE)
      LibGL.enable(LibGL::DEPTH_TEST)
      LibGL.enable(LibGL::DEPTH_CLAMP)
      LibGL.enable(LibGL::TEXTURE_2D)
    end
  end
end
