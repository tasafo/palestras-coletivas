desc "Generate spec coverage report"
task :coverage do
  ENV["COVERAGE"] = "true"
  Rake::Task["spec"].invoke
end
