require "./animator.cr"
require "./color.cr"
require "layout"
require "uuid"

module GUI
  class Component < Layout::Block
    @animator : GUI::Animator
    @color : GUI::Color

    getter animator
    property color

    def initialize
      initialize(UUID.random.to_s)
    end

    def initialize(label : String)
      super(label)
      @animator = GUI::Animator.new
      @color = GUI::Color::WHITE
    end

    def children=(children)
      super(children.map &.as(::Layout::Block))
    end

    def children
      @children.map &.as(Component)
    end


    # Enumerate over all components in this component's hierarchy.
    def each(&block : Component ->)
      yield self
      children.each do |child|
        child.each(&block)
      end
    end
  end
end
