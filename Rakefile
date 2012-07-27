# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = 'easy_model'
  gem.homepage = 'http://github.com/techscore/easy_model'
  gem.license = 'BSD'
  gem.summary = 'データベースに依存しないモデルの基本クラスや, ActiveRecord と同じ型変換を行う属性定義メソッドを提供します.'
  gem.description = 'データベースに依存しないモデルの基本クラスや, ActiveRecord と同じ型変換を行う属性定義メソッドを提供します.'
  gem.email = 'info-techscore@synergy101.jp'
  gem.authors = ['SUZUKI Kei']
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

desc 'Run tests with simplecov'
task :simplecov do
  ENV['COVERAGE'] = 'true'
  Rake::Task['test'].execute
end

task :default => :test

# RDoc::Parser.binary? はマルチバイト文字を含むファイルを誤判定する場合があるので NKF.guess で判定するように置き換える.
require 'nkf'
require 'rdoc/task'
class << RDoc::Parser
  def binary?(file)
    NKF.guess(File.read(file)) == NKF::BINARY
  end
end

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ''

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "easy_model #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

