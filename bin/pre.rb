#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/cli.rb'
require_relative '../lib/process_manager.rb'
require_relative '../lib/log/log.rb'

# require processes
Dir[
  File.join(__dir__, '../', 'lib', 'pre.d', '*.rb')
].each { |file| require file }
Dir[
  File.join(::Toolchain.custom_dir, 'pre.d', '*.rb')
].each { |file| require file }


# MAIN
def main(argv = ARGV)
  args, opt_parser = Toolchain::Process::CLI.parse_args(argv)
  if args.help
    puts opt_parser
    exit 0
  end

  if args.list || args.debug
    log('PRE-PROCESSING', 'loaded processes:')
    Toolchain::PreProcessManager.instance.get.each do |proc|
      log('PROC', proc.class.name)
    end
    exit 0 if args.list
  end

  stage_log(:pre, 'Starting pre-processing stage')
  ret = Toolchain::PreProcessManager.instance.run
  exit ret
end

main
