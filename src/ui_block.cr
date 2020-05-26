module PrismUI
  struct UIColor
    WHITE = {1f32, 1f32, 1f32}
    GREY  = {0.5f32, 5f32, 5f32}
    BLACK = {0f32, 0f32, 0f32}
  end

  class UIConstraint
  end

  class UIRenderData
  end

  class UIConstraints
    @x : UIConstraint
    @y : UIConstraint
    @width : UIConstraint
    @height : UIConstraint

    property x, y, width, height

    def initialize(@x : UIConstraint, @y : UIConstraint, @width : UIConstraint, @height : UIConstraint)
    end
  end

  class UIAnimator
  end

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

  class UIBlock < UIComponent
    @color : Float32

    property color

    def initialize(@color : Float32)
      super()
    end
  end
end
