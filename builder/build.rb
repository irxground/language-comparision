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
    }
  }
  Value = Struct.new(:codes)

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

  def template_path
    @_template_path ||= File.join(@root, 'builder', 'templates', 'page.html.slim')
  end

  def template
    @_template ||= Slim::Template.new template_path
  end

  def render(dst_path, value)
    File.open dst_path, 'w' do |f|
      f.write template.render value
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

  def build
    Dir.glob(File.join src_dir, '*') do |dir_path|
      generate dir_path
    end
  end
end

Builder.new(File.expand_path('../..', __FILE__)).build

