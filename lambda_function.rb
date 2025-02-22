# frozen_string_literal: true

require 'bundler/setup'
require 'lamby'
require_relative 'config/environment' # Adjust the path as necessary to load your Rails app

def handler(event:, context:)
  Lamby.handler(event, context)
end
