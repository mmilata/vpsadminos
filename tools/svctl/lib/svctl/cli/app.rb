require 'gli'

module SvCtl::Cli
  class App
    include GLI::App

    def self.run
      cli = new
      cli.setup
      exit(cli.run(ARGV))
    end

    def setup
      program_desc 'List and manage runit services and runlevels'
      version SvCtl::VERSION
      subcommand_option_handling :normal
      preserve_argv true
      arguments :strict
      hide_commands_without_desc true

      command 'list-all' do |c|
        c.action &Command.run(:list_all)
      end

      desc 'List enabled services'
      arg_name '-a | [runlevel]'
      command 'list-services' do |c|
        c.desc 'Show services from all runlevels'
        c.switch %w(a all), negatable: false
        c.action &Command.run(:list_services)
      end

      desc 'Enable service'
      arg_name '<service> [runlevel]'
      command 'enable' do |c|
        c.action &Command.run(:enable)
      end

      desc 'Disable service'
      arg_name '<service> [runlevel]'
      command 'disable' do |c|
        c.action &Command.run(:disable)
      end

      desc 'List available runlevels'
      command 'list-runlevels' do |c|
        c.action &Command.run(:list_runlevels)
      end

      desc 'Get current runlevel'
      command 'runlevel' do |c|
        c.action &Command.run(:runlevel)
      end

      desc 'Switch runlevel'
      arg_name '<runlevel>'
      command 'switch' do |c|
        c.action &Command.run(:switch)
      end

      default_command 'list-all'
    end
  end
end
