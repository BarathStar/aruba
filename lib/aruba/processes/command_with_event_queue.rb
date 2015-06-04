module Aruba
  module Processes
    class CommandWithEventQueue < SimpleDelegator
      attr_reader :event_queue
      private :event_queue

      def initialize(obj, event_queue)
        @event_queue = event_queue
        super(obj)
      end

      def stop(*)
        event_queue.notify :command_stopped, self.commandline
        super
      end

      def terminate(*)
        event_queue.notify :command_stopped, self.commandline
        super
      end

      def start
        event_queue.notify :command_started, self.commandline
        super
      end
      alias_method :run!, :start
    end
  end
end
