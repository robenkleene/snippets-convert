#!/usr/bin/env ruby

require 'json'
require 'pathname'
require 'optparse'

filename_to_mode = {
  'objective-c' => 'objc',
  'shellscript' => 'sh',
  'javascript' => 'js',
  'zsh' => nil
}

options = { force: false, overwrite: false }
OptionParser.new do |opts|
  opts.banner = 'Usage: ./export_code_snippets_to_yasnippet.rb [options]'
  opts.on('-f', '--force', 'Force') do
    options[:force] = true
  end
  opts.on('-o', '--overwrite', 'Overwrite') do
    options[:overwrite] = true
  end
  opts.on('-v', '--verbose', 'Verbose') do
    options[:verbose] = true
  end
end.parse!

code_snippets_path = "#{Dir.home}/.config/Code/User/snippets"
unless File.directory?(code_snippets_path)
  warn "Code snippets dir #{code_snippets_path} not found"
  exit 1
end

yasnippets_snippets_path = "#{Dir.home}/.emacs.d/snippets"
unless File.directory?(yasnippets_snippets_path)
  warn "YASnippets snippets dir #{yasnippets_snippets_path} not found"
  exit 1
end

Dir.glob("#{code_snippets_path}/*.json") do |file_path|
  contents = File.read(file_path)
  json = JSON.parse(contents)
  filename = File.basename(file_path, File.extname(file_path))
  # Skip `package.json` which just defines file type to snippet file mappings
  next if filename == 'package'

  if filename_to_mode.key?(filename) && filename_to_mode[filename].nil?
    puts "Skipping #{filename} because it's mode key is nil"
    next
  end
  mode = filename_to_mode[filename].nil? ? filename : filename_to_mode[filename]
  dest_dir = File.join(yasnippets_snippets_path, "#{mode}-mode")

  json.each do |_, hash|
    prefix = hash['prefix']
    body = hash['body']
    template = "# -*- mode: snippet -*-
# key: #{prefix}
# name: #{prefix}
# --
#{body}"
    dest_path = File.join(dest_dir, prefix)
    unless options[:force]
      puts dest_path
      puts "#{template}\n\n" if options[:verbose]
    else
      Dir.mkdir(dest_dir) unless File.exist?(dest_dir)
      unless File.directory?(dest_dir)
        warn "Failed to create dir #{dest_dir}"
        exit 1
      end
      if !File.exist?(dest_path) || options[:overwrite]
        File.write(dest_path, template)
      else
        puts "Ignoring #{dest_path} because it exists"
      end
    end
  end
end
