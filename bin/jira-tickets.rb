#!/usr/bin/env ruby

#
# Create Jira tickets from a delimited file describing tickets
#

require "pp"
require 'jira'

def default_configuration
  {
    "JIRA_INSTANCE" => "https://tickets.puppetlabs.com",
    "JIRA_USER"     => nil,
    "JIRA_PASSWORD" => nil,
  }
end

def validate_configuration
  return @configuration if @configuration
  @configuration = {}
  default_configuration.each_pair do |key, value|
    @configuration[key] = value
    @configuration[key] = ENV[key] if ENV[key] and ENV[key] != ""
    raise "No setting for required configuration setting '#{key}'\n#{usage}" unless @configuration[key]
  end
  @configuration
end

def fetch_global_settings_from_header(header)
  results = {}
  header.chomp.split("|").map do |assignment|
    key, value = assignment.split("=")
    results[key.to_sym] = value
  end
  results
end

def fetch_labels_from_header(header)
  header.chomp.split("|").map {|key| key.to_sym }
end

def read_ticket_file(ticket_file)
  puts "reading ticket data from #{ticket_file}"
  lines = File.readlines(ticket_file).delete_if {|line| line =~ %r{^#|^\s*$} }

  # fetch global settings
  globals = fetch_global_settings_from_header lines.shift

  # fetch label definitions
  labels = fetch_labels_from_header lines.shift

  # process each line, returning a hash of labeled values
  results = []
  lines.each do |line|
    result = globals.dup
    line.chomp.split("|").each_with_index do |value, offset|
      result[labels[offset]] = value.gsub('\n', "\n") || ""
    end
    results << result
  end

  results
end

def client(config)
  return @client if @client
  @client = JIRA::Client.new \
    :site     => config["JIRA_INSTANCE"],
    :username => config["JIRA_USER"],
    :password => config["JIRA_PASSWORD"]
end

def usage
  "#{$0} <datafile>\n  Required settings: #{default_configuration.keys.join(", ")}\n"
end

# set configuration, get datafile, bail on errors
config = validate_configuration
ticket_file = ARGV.shift or raise "Datafile not specified\n#{usage}"

# pull in data for all requested tickets
ticket_data = read_ticket_file(ticket_file)

require "pp"
pp config
pp ticket_data

# create the requested tickets
pp client(config)
