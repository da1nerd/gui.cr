require "crash"
require "annotation"
require "./renderer.cr"

module GUI
  # A default system for rendering `Prism::Entity`s.
  class RenderSystem < Crash::System
    # RGB
    BACKGROND_COLOR = Prism::Maths::Vector3f.new(0.80, 0.80, 0.80)
    @guis : Array(Crash::Entity)
    @ui_renderer : GUI::Renderer

    def initialize
      @ui_renderer = GUI::Renderer.new
      @guis = [] of Crash::Entity
    end

    @[Override]
    def add_to_engine(engine : Crash::Engine)
      @guis = engine.get_entities GUI::Display
    end

    # Handles the rendering.
    @[Override]
    def render
      # start shading
      prepare
      # NOTE: We won't use the entity system to add displays
      #  So eventually we'll just have a single display here
      @guis.each do |e|
        @ui_renderer.render(e.get(GUI::Display).as(GUI::Display).to_render_data)
      end
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
