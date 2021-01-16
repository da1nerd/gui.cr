module GUI::Eventable
  abstract class Event
    @propagate : Bool

    def initialize
      @propagate = true
    end

    def propagate?
      @propagate
    end

    def stop_propagation
      @propagate = false
    end
  end

  # Defines a new event handler.
  macro event(event, *args)
    @{{event.id}}_event_handler : Proc({{event.id.camelcase}}Event, Nil)?


    class {{event.id.camelcase}}Event < Event
      {% opts = args.map { |a| "@#{a}".id } %}
      getter {{*args}}
      def initialize({{*opts}})
        @propagate = true
      end
    end

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
