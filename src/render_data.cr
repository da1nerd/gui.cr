require "./color.cr"

module GUI
  class RenderData
    def initialize(@x : Float32, @y : Float32, @width : Float32, @height : Float32, @color : GUI::Color)
      # transform
    end
  end
end
