# encoding: utf-8

# usage: ruby jira-arrows.rb inputfile.csv  output.html
# This script expects a CSV of two columns: from and to

inputfilename = ARGV[0]
outputfilename = ARGV[1]

unless inputfilename
  puts "Usage: jira-arrows.rb path/to/inputfile.csv  path/to/output.html"
  exit 1
end

require 'csv'
require File.expand_path('../lib/jira-arrows/graph', File.dirname(__FILE__))


raw_data = CSV.read(inputfilename)
raw_data.delete_at(0)

graph = JiraArrows::Graph.new(raw_data)

require 'haml'
renderer = Haml::Engine.new(File.read( File.expand_path('../templates/template.html.haml', File.dirname(__FILE__)) ))

version = Gem::Specification::load(File.expand_path('../jira-arrows.gemspec', File.dirname(__FILE__))).version

html_output = renderer.to_html(nil, { all_connections: raw_data, graph: graph, version: version, template_dir: File.expand_path('../templates', File.dirname(__FILE__))} )
temp_file = File.new(outputfilename, "w+")
temp_file.puts(html_output)
temp_file.close
temp_file

__END__