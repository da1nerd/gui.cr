require "prism"

module GUI
  struct Color
    WHITE = Color.new(1, 1, 1)
    GREY  = Color.new(0.5, 0.5, 0.5)
    BLACK = Color.new(0, 0, 0)
    RED   = Color.new(1, 0, 0)
    BLUE   = Color.new(0, 1, 0)
    GREEN   = Color.new(0, 0, 1)

    getter red, blue, green

    def initialize(@red : Float32, @blue : Float32, @green : Float32)
    end
  end
end
