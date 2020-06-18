require "kiwi"

module GUI
  # Constrains a single variable.
  abstract class Constraint
    @var : Kiwi::Variable

    getter var

    def initialize
      @var = Kiwi::Variable.new("var")
    end

    def name : String
      @var.name
    end

    def name=(name : String)
      @var.name = name
    end

    abstract def value : Float32

    {% begin %}
      {% types = [:x, :y, :width, :height] %}
      {% for t in types %}
        # Builds constraints for "{{t}}"
        abstract def constrain_{{t.id}}(solver : Kiwi::Solver, own_self : GUI::Constraints, parent : GUI::Constraints)
      {% end %}
    {% end %}
  end
end
