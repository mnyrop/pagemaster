# frozen_string_literal: true

module Pagemaster
  module Error
    #
    #
    class RainbowError < StandardError
      def initialize(msg = '')
        super(Rainbow(msg).magenta)
      end
    end

    #
    #
    class InvalidConfig < RainbowError; end

    #
    #
    class MissingArgs < RainbowError; end

    #
    #
    class InvalidCollection < RainbowError; end

    #
    #
    class InvalidArgument < RainbowError; end

    #
    #
    class InvalidSource < RainbowError; end
  end
end
