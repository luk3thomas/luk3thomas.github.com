def date str, format = "%b %d, %Y"
  date = Date.strptime(str.to_s.slice(0,10), '%Y-%m-%d')
  date.strftime format
end

def permalink str
  "#{str.gsub(/^([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/, '\4-\1\2\3')}.html"
end

def lab_permalink str
  "/labs/#{permalink(str)}"
end

def blog_path
  "/notes/"
end

class Posts
  def initialize posts
    @posts ||= posts
  end

  def categories
    @posts.map{|k,d| d.category }.flatten.uniq.sort
  end

  def tags category
    find_by_category(category).map{|k,d| d.tag}.flatten.uniq.sort
  end

  def find_by_category category
    @posts.select{|k,d| d.category === category}
  end

  def find_by_tag tag
    @posts.select{|k,d| d.tag === tag}
  end
end

def render_lab filename
  File.read("./source/labs/data/#{filename}/index.html")
end

class Canvas
  attr_accessor :filename

  def initialize filename
    @filename = filename
  end

  def name
    @filename.gsub(/\.[^\.]+$/, '')
  end

  def friendly
    name.gsub(/-/, ' ')
  end

  def permalink
    "/canvas/#{name}.html"
  end

  def url
    "http://localhost:4568/javascripts/canvas/#{name}.js"
  end

  def path
    "./source/javascripts/canvas/#{@filename}"
  end

  def coffee?
    /\.coffee$/ =~ @filename
  end
end
