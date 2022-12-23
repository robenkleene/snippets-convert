#!/usr/bin/env ruby

require 'json'
require 'pathname'

filename_to_mode = { "objective-c" => "objc" }

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

Dir.glob("#{code_snippets_path}/*.json") do |file_path|
  contents = File.read(file_path)
  json = JSON.parse(contents)
  filename = File.basename(file_path, File.extname(file_path))
  mode = filename_to_mode[filename].nil? ? filename : filename_to_mode[filename]
  dest_dir = File.join(yasnippets_snippets_path, "#{filename}-mode")

  json.each do | key, hash |
    prefix = hash['prefix']
    body = hash['body']
    template = "# key: #{prefix}
# name: #{prefix}
# --
#{body}"
    # puts "#{template}\n\n"
    dest_path = File.join(dest_dir, prefix)
    puts dest_path
  end
end
