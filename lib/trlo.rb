require "trlo/version"
require "rubygems"

module Trlo
  class InputError < StandardError; end
end

require 'trlo/client'
require 'trlo/data-row'
require 'trlo/data-table'
require 'trlo/ui'
