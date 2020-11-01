require "crash"
require "annotation"
require "./renderer.cr"
require "layout"

module GUI
  class LayoutRenderSystem < Crash::System
    # RGB
    BACKGROND_COLOR = Prism::Maths::Vector3f.new(0.80, 0.80, 0.80)
    @display : BlockHolder
    @shader : GUI::Shader
    @quad : Prism::Model
    @solver : Kiwi::Solver

    def initialize(@display : BlockHolder)
      # TODO: we would need to solve for any changes.
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
      ::Layout.solve(@display.block, @solver)
      @display.block.each do |ui|
        puts ui.label
        puts "x:#{ui.x.value}, y:#{ui.y.value}, h:#{ui.height.value}, w:#{ui.width.value}"
        data = RenderData.new(ui.x.value.to_f32, ui.y.value.to_f32, ui.width.value.to_f32, ui.height.value.to_f32, @display.block.height.value.to_f32, @display.block.width.value.to_f32, ui.color)
        @shader.color = Prism::Maths::Vector3f.new(data.color.red, data.color.green, data.color.blue)
        @shader.transformation_matrix = data.transformation
        LibGL.draw_arrays(LibGL::TRIANGLE_STRIP, 0, @quad.vertex_count)
      end
      #   @display.to_render_data.each do |ui|
      #     @shader.color = Prism::Maths::Vector3f.new(ui.color.red, ui.color.green, ui.color.blue)
      #     @shader.transformation_matrix = ui.transformation
      #     LibGL.draw_arrays(LibGL::TRIANGLE_STRIP, 0, @quad.vertex_count)
      #   end
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
