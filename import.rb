# coding: utf-8
require "rubygems"
require "active_record"
require "mechanize"

dbconfig = YAML.load_file("./config/database.yaml");
ActiveRecord::Base.establish_connection(dbconfig);

load "./db/MirueneRecord.rb"
load "./FetchMiruene.rb"

year  = ARGV[0].to_i
month = ARGV[1].to_i
day   = ARGV[2] ? ARGV[2].to_i : 1

f = FetchMiruene.new
time = Time.local(year, month, day, 0, 0, 0)
p time
while time.month == month
  values = f.fetchDay(time.year, time.month, time.day)
  values.each_with_index do |energy, hour|
    print energy.to_s+" "
    record = MirueneRecord.new
    record.datetime = Time.at(time.to_i + hour*3600).iso8601
    record.energy = energy
    record.save
  end
  time += 24*60*60
  puts ""
end
puts ""

