require "crash"
require "annotation"
require "./display.cr"
require "./shader.cr"

module GUI
  # Renders the `Component`s on the screen.
  class RenderSystem < Crash::System
    BACKGROND_COLOR = Prism::Maths::Vector3f.new(0.80, 0.80, 0.80)
    @display : Display
    @shader : GUI::Shader
    @quad : Prism::Model
    @solver : Kiwi::Solver

    def initialize(@display : Display)
      @solver = Kiwi::Solver.new
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
      @display.solve
      @display.each do |ui|
        @shader.color = Prism::Maths::Vector3f.new(ui.color.red, ui.color.green, ui.color.blue)
        @shader.transformation_matrix = ui.transformation(@display.height.value, @display.width.value)
        LibGL.draw_arrays(LibGL::TRIANGLE_STRIP, 0, @quad.vertex_count)
      end
      @quad.unbind
      @shader.stop
    end

    def prepare
      LibGL.clear(LibGL::COLOR_BUFFER_BIT | LibGL::DEPTH_BUFFER_BIT)
      LibGL.clear_color(BACKGROND_COLOR.x, BACKGROND_COLOR.y, BACKGROND_COLOR.z, 1f32)
      LibGL.front_face(LibGL::CCW)
      LibGL.cull_face(LibGL::BACK)
      LibGL.enable(LibGL::CULL_FACE)
    end
  end
end
