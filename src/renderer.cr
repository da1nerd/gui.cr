require "./shader.cr"
require "./display.cr"

module GUI
  class Renderer
    @shader : GUI::Shader
    @quad : Prism::Model

    def initialize
      @shader = GUI::Shader.new
      @quad = Prism::Model.load_2f([-1, 1, -1, -1, 1, 1, 1, -1] of Float32)
    end

    def create_transformation_matrix(translation : Vector2f, scale : Vector2f)
      translate_matrix = Matrix4f.new.init_translation(translation.x, translation.y, 0)
      scale_matrix = Matrix4f.new.init_scale(scale.x, scale.y, 1)
      return translate_matrix * scale_matrix
    end

    def render(ui_data : Array(GUI::RenderData))
      LibGL.front_face(LibGL::CCW)
      LibGL.enable(LibGL::BLEND)
      LibGL.blend_func(LibGL::SRC_ALPHA, LibGL::ONE_MINUS_SRC_ALPHA)
      LibGL.disable(LibGL::DEPTH_TEST)
      @shader.start
      @quad.bind
      ui_data.each do |ui|
        render_ui ui
      end
      LibGL.enable(LibGL::DEPTH_TEST)
      LibGL.disable(LibGL::BLEND)
      @quad.unbind
      @shader.stop
      LibGL.front_face(LibGL::CW)
    end

    def render_ui(ui : GUI::RenderData)
      # gui = entity.get(UIDisplay).as(UIDisplay)
      @shader.color = Prism::Maths::Vector3f.new(ui.color.red, ui.color.blue, ui.color.green)
      @shader.transformation_matrix = ui.transformation # create_transformation_matrix(gui.position, gui.scale)
      LibGL.draw_arrays(LibGL::TRIANGLE_STRIP, 0, @quad.vertex_count)
    end
  end
end
