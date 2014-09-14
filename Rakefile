desc 'Precompile assets'
task :build do
sh 'bundle exec jekyll build'
end

desc 'Remove compiled files'
task :clean do
  sh "rm -rf #{File.join(__dir__, '_site', '*')}"
end

task default: 'build'