require "rubygems"
require "active_record"
require "mechanize"

dbconfig = YAML.load_file("./config/database.yaml");
ActiveRecord::Base.establish_connection(dbconfig);

load "./db/MirueneRecord.rb"


p MirueneRecord.all
