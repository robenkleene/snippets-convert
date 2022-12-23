#!/usr/bin/env ruby

require 'json'

code_snippets_path = "#{Dir.home}/.config/Code/User/snippets"
unless File.directory?(code_snippets_path)
  STDERR.puts "Code snippets dir #{code_snippets_path} not found"
  exit 1
end

yasnippets_snippets_path = "#{Dir.home}/.config/Code/User/snippets"
unless File.directory?(yasnippets_snippets_path)
  STDERR.puts "YASnippets snippets dir #{yasnippets_snippets_path} not found"
  exit 1
end

Dir.glob("#{code_snippets_path}/*.json") do |filename|
  puts "filename = " + filename
  # JSON.parse(json_string)
end
