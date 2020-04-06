# frozen_string_literal: true

require_relative '../config_manager.rb'

module Toolchain
  ##
  # content_path
  # Returns path to content directory root.
  #
  def self.content_path
    content_dir_path = Dir.pwd
    content_dir_path = File.join(Dir.pwd, '..') if File.basename(Dir.pwd) == 'toolchain'
    if ENV.key?('TOOLCHAIN_TEST') || ENV.key?('GITHUB_ACTIONS')
      content_dir_path = ENV['GITHUB_WORKSPACE']
    end
    content_dir_path = ENV['CONTENT_PATH'] if ENV.key?('CONTENT_PATH')
    return content_dir_path
  end

  ##
  # document_root
  # Returns the root of content structure, i.e. where +index.adoc+ is located.
  #
  def self.document_root
    return File.join(content_path, 'content')
  end

  ##
  # toolchain_path
  # Returns path to toolchain root.
  #
  def self.toolchain_path
    toolchain_dir_path = File.join(Dir.pwd, 'toolchain')
    toolchain_dir_path = Dir.pwd unless File.exist?(toolchain_dir_path)
    toolchain_dir_path = ENV['TOOLCHAIN_PATH'] if ENV.key?('TOOLCHAIN_PATH')
    return toolchain_dir_path
  end

  ##
  # build_path
  # Returns path to toolchain build directory.
  #
  def self.build_path
    return ConfigManager.instance.get('build.dir')
  end

  ##
  # html_path
  # Returns path to generated html files.
  #
  def self.html_path
    return ConfigManager.instance.get('build.html.dir')
  end

  ##
  # custom_dir
  # Returns the custom/ directory, which holds custom extensions and processes
  # in the content repository.
  #
  def self.custom_dir
    return File.join(content_path,
      ConfigManager.instance.get('custom.dir') || '')
  end
end
