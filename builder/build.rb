require 'rubygems'
require 'bundler/setup'
require 'slim'

class Builder
  EXT = {
    'Ruby' => {
      ext:  '.rb',
      exec: 'ruby "%s"'
    },
    'Python' => {
      ext: '.py',
      exec: 'python "%s"'
    },
    'Perl' => {
      ext: '.pl',
      exec: 'perl "%s"'
    },
    'PHP' => {
      ext: '.php',
      exec: 'php "%s"'
    }
  }
  Value = Struct.new(:codes)
  Index = Struct.new(:pages)

  def initialize(dir)
    @root = dir
  end

  def src_dir
    @_src_dir ||= File.join(@root, 'src')
  end

  def html_dir
    @_html_dir ||= begin
      f = File.join(@root, 'html')
      FileUtils.mkdir_p f unless Dir.exist? f
      f
    end
  end

  def layout_engine
    @_layout_engine ||= Slim::Template.new(
      File.join(@root, 'builder', 'templates', 'layout.html.slim')
    )
  end

  def page_engine
    @_page_engine ||= Slim::Template.new(
      File.join(@root, 'builder', 'templates', 'page.html.slim')
    )
  end

  def index_engine
    @_index_engine ||= Slim::Template.new(
      File.join(@root, 'builder', 'templates', 'index.html.slim')
    )
  end

  def render(dst_path, value)
    File.open dst_path, 'w' do |f|
      output = layout_engine.render do
        page_engine.render value
      end
      f.write output
    end
  end

  def generate(dir_path)
    codes = {}
    EXT.each do |name, opt|
      ary = codes[name] = []
      Dir[File.join dir_path, '*' + opt.fetch(:ext)].each do |file|
        src = File.read(file)
        out = `#{opt.fetch(:exec) % file}`
        ary << [src, out]
      end
    end
    dir_name = dir_path.sub(src_dir, '')
    dist_path = File.join(html_dir, dir_name + '.html')
    render dist_path, Value.new(codes)
  end

  def render_index(dst_path, value)
    File.open dst_path, 'w' do |f|
      output = layout_engine.render do
        index_engine.render value
      end
      f.write output
    end
  end

  def build
    pages = []
    Dir.glob(File.join src_dir, '*') do |dir_path|
      generate dir_path
      pages << dir_path.sub(src_dir + '/', '')
    end
    render_index File.join(html_dir, 'index.html'), Index.new(pages)
  end
end

Builder.new(File.expand_path('../..', __FILE__)).build

