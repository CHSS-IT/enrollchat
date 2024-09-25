desc "Run precompile assets before running all tests. Clobber them afterwards."
namespace :run_tests do
  include Rake::DSL

  task :all do
    system("rails assets:precompile")
    system("rails test:all")
    system("rails assets:clobber")
  end
end