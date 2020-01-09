# frozen_string_literal: true

require 'singleton'

module Toolchain
  # ExtensionManager
  # used to register extensions based on base_extension,
  # which are run on every file.
  class ExtensionManager
    include Singleton
    @instance = nil

    def instance
      @instance = ExtensionManager.new if @instance.nil?
      return @instance
    end

    def register(ext)
      @extensions << ext
    end

    def get
      return @extensions
    end

    def next_id
      @id += 1
      return @id
    end

    private

    def initialize
      @extensions = []
      @id = 0
    end
  end
end
