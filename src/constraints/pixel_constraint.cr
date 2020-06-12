require "./constraint.cr"

module GUI
  class PixelConstraint < Constraint
    getter pixels

    def initialize(@pixels : Int32)
    end

    def value : Float32
        @pixels.to_f32
    end
  end
end
