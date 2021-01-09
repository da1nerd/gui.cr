require "crash"
require "annotation"
require "./renderer.cr"
require "./render_data.cr"

module GUI
  class LayoutRenderSystem < Crash::System
    # RGB
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
      # TODO: pass in the solver so we can reuse prior calculations
      @display.solve
      @display.each do |ui|
        puts ui.label
        puts "x:#{ui.x.value}, y:#{ui.y.value}, h:#{ui.height.value}, w:#{ui.width.value}"
        data = RenderData.new(ui.x.value.to_f32, ui.y.value.to_f32, ui.width.value.to_f32, ui.height.value.to_f32, @display.height.value.to_f32, @display.width.value.to_f32, ui.color)
        @shader.color = Prism::Maths::Vector3f.new(data.color.red, data.color.green, data.color.blue)
        @shader.transformation_matrix = data.transformation
        LibGL.draw_arrays(LibGL::TRIANGLE_STRIP, 0, @quad.vertex_count)
      end
      @quad.unbind
      @shader.stop
      # rescue err
      # puts err.message
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
