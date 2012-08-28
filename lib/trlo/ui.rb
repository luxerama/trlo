module Trlo
  class UI
    GLOBAL_CONFIG_PATH = "#{ENV['HOME']}/.tr"
    LOCAL_CONFIG_PATH = "#{Dir.pwd}/.tr"

    def initialize(args)
      # require 'trlo/debugger' if ARGV.delete('--debug')
      @io = HighLine.new
      @global_config = load_global_config
      @client = Trlo::Client.new(@global_config[:api_key])
      @local_config = load_local_config
      @board = @client.get_project(@local_config[:board_id])
      command = args[0].to_sym rescue :my_work
      @params = args[1..-1]
      commands.include?(command.to_sym) ? send(command.to_sym) : help
    end

  end
end
