require "active_record"
require "yaml"

task :default => :migrate

desc "Migrate database"
task :migrate => :environment do
	ActiveRecord::Migrator.migrate('db/migrate', ENV['VERSION'] ? ENV['VERSION'] .to_i : nil)
end

task :environment do
	dbconfig = YAML.load_file('config/database.yaml')
	ActiveRecord::Base.establish_connection(dbconfig)
	ActiveRecord::Base.logger = Logger.new(File.open('db/database.log', 'a'))
end



