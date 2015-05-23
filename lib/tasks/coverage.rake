desc "Generate spec coverage report"
namespace :spec do
  task :coverage do
    ENV["COVERAGE"] = "true"
    Rake::Task["spec"].invoke
  end
end
