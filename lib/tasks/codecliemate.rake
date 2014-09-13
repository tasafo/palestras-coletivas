desc "Generate code climate report"
task :codeclimate do
  ENV["CODECLIMATE"] = "true"
  Rake::Task["spec"].invoke
end
