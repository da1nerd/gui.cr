require "./constraint.cr"

module GUI
  class RelativeConstraint < Constraint
    def initialize(@ratio : Float32)
    end

    def value : Float32
        @ratio.to_f32
    end
  end
end
