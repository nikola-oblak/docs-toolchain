# frozen_string_literal: true

require 'test/unit'
require_relative '../../stages/test/main_module.rb'
require_relative '../../stages/test/cli.rb'
require_relative './util.rb'

class TestParse < Test::Unit::TestCase
  def test_default
    args = Toolchain::CLI.parse_args([])
    assert_false(args.help)
    assert_false(args.debug)
    assert_false(args.file)
    assert_empty(args.files)
    assert_false(args.index)
    assert_nil(args.index_file)
  end

  def test_help
    args = Toolchain::CLI.parse_args(['--help'])
    assert_true(args.help)
    assert_false(args.debug)
    assert_false(args.file)
    assert_empty(args.files)
    assert_false(args.index)
    assert_nil(args.index_file)
  end

  def test_debug
    args = Toolchain::CLI.parse_args(['--debug'])
    assert_false(args.help)
    assert_true(args.debug)
    assert_false(args.file)
    assert_empty(args.files)
    assert_false(args.index)
    assert_nil(args.index_file)
  end

  def test_files
    args = Toolchain::CLI.parse_args(['--file', 'test.adoc', '--file', 'content.adoc'])
    assert_false(args.help)
    assert_false(args.debug)
    assert_true(args.file)
    assert_equal(['test.adoc', 'content.adoc'], args.files)
    assert_false(args.index)
    assert_nil(args.index_file)
  end

  def test_index
    args = Toolchain::CLI.parse_args(['--index', 'index.adoc'])
    assert_false(args.help)
    assert_false(args.debug)
    assert_false(args.file)
    assert_empty(args.files)
    assert_true(args.index)
    assert_equal('index.adoc', args.index_file)
  end
end

class TestCLI < Test::Unit::TestCase
  def test_help_cli
    output = with_captured_stdout do
      main(['--help'])
    end
    assert_true(output.start_with?('Usage:'))
  end
end
