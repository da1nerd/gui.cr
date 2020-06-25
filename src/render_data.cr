require "./color.cr"

module GUI
  class RenderData
    @height : Float32
    @width : Float32
    @y : Float32
    @x : Float32

    getter color

    def initialize(x : Float32, y : Float32, width : Float32, height : Float32, vh : Float32, vw : Float32, @color : GUI::Color)
      # move object origin to top left corner then,
      # scale coordinates to -1..1
      @x = rescale(x + width / 2, vw)
      # TRICKY: the y-axis needs to be flipped
      @y = -rescale(y + height / 2, vh)

      # scale dimensions down
      @height = height / vh
      @width = width / vw
    end

    def transformation
      translate_matrix = Matrix4f.new.init_translation(@x, @y, 0f32)
      scale_matrix = Matrix4f.new.init_scale(@width, @height, 1f32)
      translate_matrix * scale_matrix
    end

    # Scales a *value* from a range of 0..*max* to fit within a range of -1..1
    def rescale(value : Float32, max : Float32)
      # convert to range of 0..2
      scale = 2 / (max - 1)
      # convert to a range of -1..1
      value * scale - 1
    end
  end
end
