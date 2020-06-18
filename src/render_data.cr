require "./color.cr"

module GUI
  class RenderData
    getter color

    def initialize(@x : Float32, @y : Float32, @width : Float32, @height : Float32, @vh : Float32, @vw : Float32, @color : GUI::Color)
      # TODO: transform
    end

    def transformation
      translate_matrix = Matrix4f.new.init_translation(@x / @vw , @y / @vh, 0f32)
      scale_matrix = Matrix4f.new.init_scale(@width / @vw, @height / @vh, 1f32)
      scale_matrix * translate_matrix
    end

    def to_s(io : IO)
      io << "x : #{@x} (#{@x / @vw}), y : #{@y} (#{@y / @vh}), width : #{@width} (#{@width / @vw}), height : #{@height} (#{@height / @vh}), vw : #{@vw}, vh : #{@vh}, color: #{@color}"
    end
  end
end
