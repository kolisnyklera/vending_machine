# frozen_string_literal: true

module States
  class BaseState
    attr_reader :context

    def initialize(context)
      @context = context
    end

    def handle
      raise NotImplementedError, "Define method in subclasses!"
    end
  end
end
