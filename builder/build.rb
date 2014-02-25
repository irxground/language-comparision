require 'rubygems'
require 'yaml'
require 'bundler/setup'
require 'slim'

class Builder
  Value = Struct.new(:codes)
  Index = Struct.new(:pages)

  def initialize(dir)
    @root = dir
  end

  def config
    @_config ||= YAML.load(File.read(File.join(@root, 'builder', 'config.yml')))
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
    config.fetch('languages').each do |name, opt|
      exec = opt.fetch 'exec'
      ext = opt.fetch 'ext'
      file_pattern = '*' + (Array === ext ? "{#{ext.join(',')}}" : ext)
      ary = []
      Dir[File.join dir_path, file_pattern].each do |file|
        src = File.read(file)
        out = `#{exec % file}`
        if $? != 0
          puts out
          exit $?
        end
        ary << [src, out]
      end
      codes[name] = ary unless ary.empty?
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
    FileUtils.cd src_dir do
      Dir.glob(File.join src_dir, '*') do |dir_path|
        generate dir_path
        pages << dir_path.sub(src_dir + '/', '')
      end
    end
    render_index File.join(html_dir, 'index.html'), Index.new(pages)
  end
end

Builder.new(File.expand_path('../..', __FILE__)).build

