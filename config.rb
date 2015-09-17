###
# Compass
###

require './lib/helpers.rb'

def collect_files(path)
  Dir.entries(path)
    .select {|f| !(/^\./ =~ f) }  # exclude vim swp files and . .. directories
    .sort {|a, b| (File.stat("#{path}#{a}").mtime <=> File.stat("#{path}#{b}").mtime) * -1}
end

scripts = collect_files('./source/javascripts/canvas/')
  .map { |f| Canvas.new(f) }

arts = collect_files('./source/javascripts/art/')
  .map { |f| Art.new(f) }

set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true, :smartypants => true

data.posts.each do |slug, post|
  proxy "/#{permalink(slug)}", "/notes/single.html", locals: { post: post , slug: slug}, ignore: true, layout: :post
end

data.labs.each do |slug, post|
  proxy "/labs/#{permalink(slug)}", "/labs/single.html", locals: { post: post, slug: slug }, ignore: true, layout: :labs
end

data.quotes.each do |slug, quote|
  proxy "/quotes/#{permalink(slug)}", "/quotes/show.html", locals: { quote: quote, title: quote.title }, ignore: true, layout: :full
end

data.talks.each do |talk|
  proxy talk.href, "/talks/show.html", locals: { talk: talk }, ignore: true, layout: :talk
end

# Dynamic canvas labs
#
proxy "/canvas/index.html", "/canvas/list.html", ignore: true, locals: {pages: scripts}, layout: :full
proxy "/art/index.html", "/art/list.html", ignore: true, locals: {pages: arts}, layout: :full

scripts.each do |script|
  proxy script.permalink, "/canvas/single.html", locals: { script: script }, ignore: true, layout: :canvas
end

arts.each do |script|
  proxy script.permalink, "/art/single.html", locals: { script: script, title: script.friendly }, ignore: true, layout: :full
end

page '/books/*', layout: :books
page '/sitemap.xml', layout: false

configure :build do
  ignore 'labs/data/*.html'
  ignore 'talks/talks/*'
  ignore 'stylesheets/theme/**'
  activate :minify_css
  activate :asset_hash
end
