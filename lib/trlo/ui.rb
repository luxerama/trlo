require 'yaml'
require 'colored'
require 'highline'

module Trlo
  class UI
    GLOBAL_CONFIG_PATH = "#{ENV['HOME']}/.trlo"
    LOCAL_CONFIG_PATH = "#{Dir.pwd}/.trlo"

    def initialize(args)
      # require 'trlo/debugger' if ARGV.delete('--debug')
      @io = HighLine.new
      @global_config = load_global_config
      @client = Trlo::Client.new(@global_config)
      @local_config = load_local_config
      @board = @client.get_board(@local_config[:board_id])
      # command = args[0].to_sym rescue :my_work
      # @params = args[1..-1]
      # commands.include?(command.to_sym) ? send(command.to_sym) : help
    end

    def load_global_config
      config = YAML.load(File.read(GLOBAL_CONFIG_PATH)) rescue {}
      # if config.empty?
      #   message "I can't find info about your Trello account in #{GLOBAL_CONFIG_PATH}."
      #   # while !config[:api_key] do
      #   #   config[:email] = ask "What is your email?"
      #   #   password = ask_secret "And your password? (won't be displayed on screen)"
      #   #   begin
      #   #     # config[:api_number] = Trlo::Client.get_api_token(config[:email], password)
      #   #   rescue PT::InputError => e
      #   #     error e.message + " Please try again."
      #   #   end
      #   # end
      #   congrats "Thanks!",
      #     "Your API key is " + config[:api_key],
      #     "I'm saving it in #{GLOBAL_CONFIG_PATH} so you don't have to log in again."
      #   save_config(config, GLOBAL_CONFIG_PATH)
      # end
      config
    end

    def load_local_config
      check_local_config_path
      config = YAML.load(File.read(LOCAL_CONFIG_PATH)) rescue {}
      if config.empty?
        message "I can't find info about this project in #{LOCAL_CONFIG_PATH}"
        boards = Trlo::BoardTable.new(@client.get_boards)
        board = select("Please select the board for the current directory", boards)
        config[:board_id], config[:board_name] = board.id, board.name
        project = @client.get_board(board.id)
        # membership = @client.get_membership(project, @global_config[:email])
        # config[:user_name], config[:user_id], config[:user_initials] = membership.name, membership.id, membership.initials
        congrats "Thanks! I'm saving this project's info",
          "in #{LOCAL_CONFIG_PATH}: remember to .gitignore it!"
        save_config(config, LOCAL_CONFIG_PATH)
      end
      config
    end

    def check_local_config_path
      if GLOBAL_CONFIG_PATH == LOCAL_CONFIG_PATH
        error("Please execute .trlo inside your project directory and not in your home.")
        exit
      end
    end

    def save_config(config, path)
      File.new(path, 'w') unless File.exists?(path)
      File.open(path, 'w') {|f| f.write(config.to_yaml) }
    end
    # I/O

    def split_lines(text)
      text.respond_to?(:join) ? text.join("\n") : text
    end

    def title(*msg)
      puts "\n#{split_lines(msg)}".bold
    end

    def congrats(*msg)
      puts "\n#{split_lines(msg).green.bold}"
    end

    def message(*msg)
      puts "\n#{split_lines(msg)}"
    end

    def error(*msg)
      puts "\n#{split_lines(msg).red.bold}"
    end

    def select(msg, table)
      if table.length > 0
        begin
          table.print @global_config
          row = ask "#{msg} (1-#{table.length}, 'q' to exit)"
          quit if row == 'q'
          selected = table[row]
          error "Invalid selection, try again:" unless selected
        end until selected
        selected
      else
        table.print @global_config
        message "Sorry, there are no options to select."
        quit
      end
    end

    def ask(msg)
      @io.ask("#{msg.bold}")
    end
  end
end
