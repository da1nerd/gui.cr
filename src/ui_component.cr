require "./ui_animator.cr"

module PrismUI
  class UIComponent
    @animator : UIAnimator

    getter animator

    def initialize
      @animator = UIAnimator.new
    end

    def add(component : UIComponent, constraints : UIConstraints)
    end

    protected def init
    end

    protected def update
    end
  end
end
