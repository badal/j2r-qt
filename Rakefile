require 'rubygems/package_task'
require 'rdoc/task'
require 'yard'
require 'yard/rake/yardoc_task'

require 'rake/testtask'

require_relative 'lib/j2r/qt/version.rb'

desc 'build gem file'
task :build_gem do
  system 'gem build j2r-qt.gemspec'
  FileUtils.mv(Dir.glob('*.gem'), ENV['LOCAL_GEMS'])
end

# noinspection RubyArgCount
RDoc::Task.new do |rdoc|
  files = %w(README.md TODO.md HISTORY.md LICENSE lib/**/*.rb)
  rdoc.rdoc_files.add(files)
  rdoc.main = 'README.md' # page to start on
  rdoc.title = 'Smf Docs'
  rdoc.rdoc_dir = 'doc/rdoc' # rdoc output folder
  rdoc.options << '--line-numbers'
end

YARD::Rake::YardocTask.new do |t|
  t.options += ['--title', "JacintheReports #{JacintheReports::VERSION} Documentation"]
  t.options += %w(--files LICENSE)
  t.options += %w(--files HISTORY.md)
  t.options += %w(--files TODO.md)
  t.options += %w(--verbose)
end

desc 'show not documented'
task :yard_not_documented do
  system 'yard stat --list-undoc'
end

Rake::TestTask.new do |t|
  t.libs.push 'lib'
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

desc 'build Manifest'
task :manifest do
  system ' mast -x .rubocop.yml -x metrics -x doc -x bat -x help -x coverage -x pkg -x "documentation v1" -x demo * > MANIFEST'
end

import('metrics.rake')
