namespace :assets do
  desc 'Precompile assets'
  task :precompile do
	Rake::Task['clean'].invoke
    sh 'bundle exec jekyll build'
  end
end

desc 'Remove compiled files'
task :clean do
  sh "rm -rf #{File.join(__dir__, '_site', '*')}"
end

task default: 'assets:precompile'