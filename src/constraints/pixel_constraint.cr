require "./constraint.cr"

module GUI
  class PixelConstraint < Constraint
    getter pixels

    def initialize(@pixels : Int32)
      super()
    end

    def value : Float32
      @var.value.to_f32
    end

    def constrain_x(solver : Kiwi::Solver, own_self : GUI::Constraints, parent : GUI::Constraints)
      solver.add_constraint @var == parent.x.var + @pixels
    end

    def constrain_y(solver : Kiwi::Solver, own_self : GUI::Constraints, parent : GUI::Constraints)
      solver.add_constraint @var == parent.y.var + @pixels
    end

    def constrain_width(solver : Kiwi::Solver, own_self : GUI::Constraints, parent : GUI::Constraints)
      solver.add_constraint @var == @pixels
    end

    def constrain_height(solver : Kiwi::Solver, own_self : GUI::Constraints, parent : GUI::Constraints)
      solver.add_constraint @var == @pixels
    end
  end
end
