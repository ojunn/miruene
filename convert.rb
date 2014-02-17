# coding: utf-8
require "rubygems"
require "active_record"

dbconfig = YAML.load_file("./config/database.yaml");
ActiveRecord::Base.establish_connection(dbconfig);

load "./db/MirueneRecord.rb"

MirueneRecord.all.each do |data|
	data.datetime = Time.at(data.datetime).iso8601
	data.save
end

