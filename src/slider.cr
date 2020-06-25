require "./component.cr"
require "./color.cr"
require "./constraint_factory.cr"
require "./block.cr"

module GUI
  class Slider < GUI::Component
    LINE_THICKNESS   =  5i32
    MARKER_THICKNESS = 20i32

    def initialize
      super(GUI::Color::RED)
      init_line
      init_marker
    end

    def init_line
      constraints = GUI::ConstraintFactory.get_default
      constraints.name = "Slider.Line"
      constraints.x = GUI::RelativeConstraint.new(0)
      constraints.y = GUI::CenterConstraint.new
      constraints.width = GUI::RelativeConstraint.new(1)
      constraints.height = GUI::PixelConstraint.new(LINE_THICKNESS)
      add GUI::Block.new(GUI::Color::GREEN), constraints
    end

    def init_marker
      constraints = GUI::ConstraintFactory.get_default
      constraints.name = "Slider.Marker"
      constraints.x = GUI::RelativeConstraint.new(0)
      constraints.y = GUI::CenterConstraint.new
      constraints.width = GUI::PixelConstraint.new(MARKER_THICKNESS)
      constraints.height = GUI::RelativeConstraint.new(1)
      add GUI::Block.new(GUI::Color::BLUE), constraints
    end
  end
end
