require "./constraint.cr"

module GUI
  class RelativeConstraint < Constraint
    def initialize(@ratio : Float32)
      super()
    end

    def value : Float32
      @var.value.to_f32
    end

    protected def constrain_x(solver : Kiwi::Solver, own_self : GUI::Constraints, parent : GUI::Constraints)
      solver.add_constraint @var == parent.x.var + parent.width.var * @ratio
    end

    protected def constrain_y(solver : Kiwi::Solver, own_self : GUI::Constraints, parent : GUI::Constraints)
      solver.add_constraint @var == parent.y.var + parent.height.var * @ratio
    end

    protected def constrain_width(solver : Kiwi::Solver, own_self : GUI::Constraints, parent : GUI::Constraints)
      pp (@var == parent.width.var * @ratio).to_s
      solver.add_constraint @var == parent.width.var * @ratio
    end

    protected def constrain_height(solver : Kiwi::Solver, own_self : GUI::Constraints, parent : GUI::Constraints)
      solver.add_constraint @var == parent.height.var * @ratio
    end
  end
end
