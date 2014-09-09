desc "Generate spec coverage report"
task :coverage do
  ENV["COVERAGE"] = "true"
  ENV["CODECLIMATE"] = "true"
  Rake::Task["spec"].invoke
end
