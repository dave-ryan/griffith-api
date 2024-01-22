namespace :db do
  task :seed_test => :environment do
    Rake::Task["db:seed"].invoke
  end
end
