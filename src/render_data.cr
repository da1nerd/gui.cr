require "./color.cr"

module GUI
  class RenderData
    getter color

    def initialize(@x : Float32, @y : Float32, @width : Float32, @height : Float32, @color : GUI::Color)
      # TODO: transform
    end

    def transformation
      translate_matrix = Matrix4f.new.init_translation(@x, @y, 0f32)
      scale_matrix = Matrix4f.new.init_scale(@width, @height, 1f32)
      translate_matrix * scale_matrix
    end
  end
end
