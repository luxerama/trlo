require "trlo/version"
require "rubygems"

module Trlo
  class InputError < StandardError; end
end

require 'trlo/client'
require 'trlo/data_row'
require 'trlo/data_table'
require 'trlo/ui'
