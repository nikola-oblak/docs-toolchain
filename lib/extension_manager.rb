# frozen_string_literal: true

require 'singleton'

module Toolchain
  # ExtensionManager
  # used to register extensions based on base_extension,
  # which are run on every file.
  class ExtensionManager
    include Singleton

    class << self
      ##
      # Creates an error, consisting of the following fields:
      # [id]       continuous ID to identify order of errors
      # [type]     type of error, defaults to the name of the extension
      # [msg]      the error message
      # [location] location of the error, described by +Location+
      # [extras]   for future use, unused right now
      #
      # Only a subset of the keys can be passed to the function:
      # * +msg+
      # * +type+
      # * +location+
      # * +extras+
      #
      # Returns the error as Hash.
      #
      def create_error(msg:, type:, location: nil, extras: nil)
        return {
          id: instance.next_id,
          type: type,
          msg: msg,
          location: location,
          extras: extras
        }
      end
    end

    ##
    # Register an extension +ext+ with the +ExtensionManager+.
    #
    # Returns nothing.
    #
    def register(ext)
      @extensions << ext
    end

    ##
    # Return the list of registered extensions.
    #
    def get
      return @extensions
    end

    ##
    # Return the next id.
    def next_id
      return @id += 1
    end

    ##
    # Clear the internal state, reset to default state.
    # Returns nothing.
    def clear
      @extensions.clear
      @id = 0
    end

    private

    def initialize
      @extensions = []
      @id = 0
    end
  end
end
