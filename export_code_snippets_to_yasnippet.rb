#!/usr/bin/env ruby

require 'json'
JSON.parse(json_string)

code_snippets_path = "#{Dir.home}/.config/Code/User/snippets"
unless directory_exists?(code_snippets_path)
  STDERR.puts "Code snippets dir #{code_snippets_path} not found"
  exit 1
end

yasnippets_snippets_path = "#{Dir.home}/.config/Code/User/snippets"
unless directory_exists?(yasnippets_snippets_path)
  STDERR.puts "YASnippets snippets dir #{yasnippets_snippets_path} not found"
  exit 1
end

