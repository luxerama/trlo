require 'trello'

module Trlo
  class Client

    attr_accessor :config

    include Trello
    include Trello::Authorization

    def initialize(config)
      @config = config
      Trello::Authorization.const_set :AuthPolicy, OAuthPolicy
      OAuthPolicy.consumer_credential = OAuthCredential.new @config[:key], @config[:secret]
      OAuthPolicy.token = OAuthCredential.new @config[:token], nil
      @project = nil
    end

    def get_board(board_id)
      # Board.find(board_id)
    end

    def get_boards
      # Member.find(@config[:username]).boards
    end
  end
end
