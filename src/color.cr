require "prism"

module GUI
  struct Color
    WHITE   = Color.new(1, 1, 1)
    GREY    = Color.new(0.5, 0.5, 0.5)
    BLACK   = Color.new(0, 0, 0)
    RED     = Color.new(1, 0, 0)
    BLUE    = Color.new(0, 1, 0)
    GREEN   = Color.new(0, 0, 1)
    GRAY900 = Color.new(55/255.to_f32, 65/255.to_f32, 81/255.to_f32)
    GRAY500 = Color.new(75/255.to_f32, 85/255.to_f32, 99/255.to_f32)
    GRAY100 = Color.new(244/255.to_f32, 245/255.to_f32, 247/255.to_f32)

    getter red, blue, green

    def initialize(@red : Float32, @blue : Float32, @green : Float32)
    end
  end

  macro define_color(name, r, g, b)
    module GUI
      struct Color
        {{name.id.capitalize}} = Color.new(r, g, b)
      end
    end
  end
end
