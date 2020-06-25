require "./color.cr"

module GUI
  class RenderData
    @_width : Float32
    @_height : Float32
    @_x : Float32
    @_y : Float32
    getter color

    def initialize(@x : Float32, @y : Float32, @width : Float32, @height : Float32, @vh : Float32, @vw : Float32, @color : GUI::Color)
      # normalize 0,0 coordinate to top left corner
      @_width = @width# / @vw
      @_height = @height# / @vh
      # move object origin to top left corner
      @y += @height / 2
      @x += @width / 2

      # scale coordinates to -1..1
      @_x = rescale_x(@x)#(@x / @vw) - 1 + (@_width / 2)
      @_y = rescale_y(@y)#-((@y / @vh) - 1 + (@_height / 2))
    end

    def transformation
      
      puts "x#{@_x}, y#{@_y}:#{@y}, w#{@_width}, h#{@_height}, vw#{@vw}, vh#{@vh}"
      translate_matrix = Matrix4f.new.init_translation(@_x, @_y, 0f32)
      scale_matrix = Matrix4f.new.init_scale(@_width / @vw, @_height / @vh, 1f32)
      translate_matrix * scale_matrix
    end

    def rescale_x(x : Float32)
      # convert to range of 0..2
      x_scale = 2 / (@vw - 1)
      # convert to a range of -1..1
      x * x_scale - 1
    end

    def rescale_y(y : Float32)
      # convert to range of 0..2
      y_scale = 2 / (@vh - 1)
      # convert to a range of -1..1
      y * y_scale - 1
    end
  end
end
