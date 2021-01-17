# Adds tools to generate triggerable and capturable events.
#
module GUI::Eventable
  # The base for all `Component` input events.
  abstract class Event
    @propagate : Bool

    def initialize
      @propagate = true
    end

    # Checks if the event should continue to propagate down the `Component` tree.
    def propagate?
      @propagate
    end

    # Stops the event from propagating down the `Component` tree.
    def stop_propagation
      @propagate = false
    end
  end

  # Defines a new event handler.
  # This will create a new event type, event handler, and event trigger.
  macro event(event, *args)
    class {{event.id.camelcase}}Event < Event
      {% opts = args.map { |a| "@#{a}".id } %}
      getter {{*args}}
      def initialize({{*opts}})
        @propagate = true
      end
    end

    @{{event.id}}_event_handler : Proc({{event.id.camelcase}}Event, Nil)?

    # Executed on the "{{event.id}}" event.
    def on_{{event.id}}(event : {{event.id.camelcase}}Event)
      if callback = @{{event.id}}_event_handler
        callback.call(event)
      end
    end

    # Sets the callback to execute when the {{event.id}} event is received.
    # The block provided here will be executed within `#on_{{event.id}}`.
    def on_{{event.id}}(&block : {{event.id.camelcase}}Event->)
      @{{event.id}}_event_handler = block
    end
  end
end
