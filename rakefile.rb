task :default => %w(build:html build:res)

namespace :build do
  task :html do
    sh "ruby builder/build.rb"
  end
  task :res do
    src = 'builder/templates/style.css.scss'
    dst = 'html/style.css'
    sh "bundle exec scss #{src} > #{dst}"
  end
end
