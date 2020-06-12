require "./color.cr"

module GUI
  class RenderData
    getter color

    def initialize(@x : Float32, @y : Float32, @width : Float32, @height : Float32, @color : GUI::Color)
      # TODO: transform
    end

    def transformation
      translate_matrix = Matrix4f.new.init_translation(@x, @y, 0f32)
      # TODO: the scale will need to be calculated and passed in.
      scale_x = 0.5f32
      scale_y = 0.5f32
      scale_matrix = Matrix4f.new.init_scale(scale_x, scale_y, 1f32)
      translate_matrix * scale_matrix
    end
  end
end
