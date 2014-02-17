# coding: utf-8
require "rubygems"
require "active_record"
require "mechanize"

dbconfig = YAML.load_file("./config/database.yaml");
ActiveRecord::Base.establish_connection(dbconfig);

load "./db/MirueneRecord.rb"
load "./FetchMiruene.rb"


#p MirUeneRecord.find(100)

MirueneRecord.all.each do |data|
	t = Time.at(data.datetime)
	puts t.strftime("%Y-%m-%d")+"\t"+t.strftime("%H:%M")+"\t"+data.energy.to_s
end

