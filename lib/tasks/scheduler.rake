namespace :scheduled_tasks do
  desc "Clean and seed database"
  task :update_data => :environment do
    DatabaseCleaner.allow_production = true
    DatabaseCleaner.allow_remote_database_url = true
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
    Rake::Task["db:seed"].invoke
  end

end
