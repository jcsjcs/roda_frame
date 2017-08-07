namespace :db do
  desc "Run migrations"
  task :migrate, [:version] do |t, args|
    require "sequel"
    Sequel.extension :migration
    db = Sequel.connect(ENV.fetch("DATABASE_URL"))
    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(db, "db/migrations", target: args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(db, "db/migrations")
    end
  end

  desc "Create a new, timestamped migration file. Use NAME env var for file name suffix."
  task :new_migration do
    nm = ENV['NAME']
    fail "\nSupply a filename (to create \"#{Time.now.strftime('%Y%m%d%H%M_create_a_table.rb')}\"):\n\n  rake #{Rake.application.top_level_tasks.last} NAME=create_a_table\n\n" if nm.nil?
    # puts "GOT: #{nm}"
    touch File.join('db/migrations', Time.now.strftime("%Y%m%d%H%M_#{nm}.rb"))
  end
end

# file 'migration_new_file' do
#   # touch "db/migrate/#{Time.now.strftime('')}_mig.rb'
#   touch File.join('db/migrations', Time.now.strftime('%Y%m%d%H%M_new_migration.rb'))
# end
