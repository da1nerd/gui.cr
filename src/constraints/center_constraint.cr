require "./constraint.cr"

module GUI
  class CenterConstraint < Constraint
    def value : Float32
      @var.value.to_f32
    end

    def constrain_x(solver : Kiwi::Solver, own_self : GUI::Constraints, parent : GUI::Constraints)
      solver.add_constraint @var == parent.width.var * 0.5 - own_self.height.var * 0.5
    end

    def constrain_y(solver : Kiwi::Solver, own_self : GUI::Constraints, parent : GUI::Constraints)
      solver.add_constraint @var == parent.y.var + (parent.height.var * 0.5) - (own_self.height.var * 0.5)
    end

    def constrain_width(solver : Kiwi::Solver, own_self : GUI::Constraints, parent : GUI::Constraints)
    end

    def constrain_height(solver : Kiwi::Solver, own_self : GUI::Constraints, parent : GUI::Constraints)
    end
  end
end
