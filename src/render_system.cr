require "crash"
require "annotation"
require "./renderer.cr"

lib LibGL
  MATRIX_MODE = 0x0BA0_u32
  MODELVIEW = 0x1700_u32
  PROJECTION = 0x1701_u32
  fun matrix_mode = glMatrixMode(mode : Enum) : Void
  fun load_identity = glLoadIdentity() : Void
end

module GUI
  # A default system for rendering `Prism::Entity`s.
  # TODO: rename this to GUISystem
  class RenderSystem < Crash::System
    # RGB
    BACKGROND_COLOR = Prism::Maths::Vector3f.new(0.80, 0.80, 0.80)
    @display : GUI::Display
    @shader : GUI::Shader
    @quad : Prism::Model

    def initialize(@display : GUI::Display)
      @shader = GUI::Shader.new
      @quad = Prism::Model.load_2f([-1, 1, -1, -1, 1, 1, 1, -1] of Float32)
    end

    def create_transformation_matrix(translation : Vector2f, scale : Vector2f)
      translate_matrix = Matrix4f.new.init_translation(translation.x, translation.y, 0)
      scale_matrix = Matrix4f.new.init_scale(scale.x, scale.y, 1)
      return translate_matrix * scale_matrix
    end

    # Handles the rendering.
    @[Override]
    def render
      prepare
      @shader.start
      @quad.bind
      puts "start"
      @display.to_render_data.each do |ui|
      # ui = RenderData.new(
      #   x: 0f32,
      #   y: 0f32,
      #   width: 50f32,
      #   height: 50f32,
      #   vh: @display.height.to_f32,
      #   vw: @display.width.to_f32,
      #   color: Color::RED
      # )
      @shader.color = Prism::Maths::Vector3f.new(ui.color.red, ui.color.green, ui.color.blue)
      @shader.transformation_matrix = ui.transformation
      LibGL.draw_arrays(LibGL::TRIANGLE_STRIP, 0, @quad.vertex_count)
      end
      @quad.unbind
      @shader.stop
    end

    def prepare
      LibGL.clear(LibGL::COLOR_BUFFER_BIT | LibGL::DEPTH_BUFFER_BIT)
      LibGL.clear_color(BACKGROND_COLOR.x, BACKGROND_COLOR.y, BACKGROND_COLOR.z, 1f32)
      LibGL.front_face(LibGL::CW)
      LibGL.cull_face(LibGL::BACK)
      # LibGL.enable(LibGL::CULL_FACE)
      # LibGL.enable(LibGL::DEPTH_TEST)
      # LibGL.enable(LibGL::DEPTH_CLAMP)
      # LibGL.enable(LibGL::TEXTURE_2D)

      LibGL.matrix_mode(LibGL::PROJECTION)
      LibGL.load_identity
      LibGL.ortho(0, @display.width, 0, @display.height, 0, 1)
      LibGL.matrix_mode(LibGL::MODELVIEW)
      LibGL.load_identity
    end
  end
end
