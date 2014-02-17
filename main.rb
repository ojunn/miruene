# coding: utf-8
require "rubygems"
require "active_record"
require "mechanize"

dbconfig = YAML.load_file("./config/database.yaml");
ActiveRecord::Base.establish_connection(dbconfig);

load "./db/MirueneRecord.rb"
load "./FetchMiruene.rb"

f = FetchMiruene.new
for year in 2013..2014        
  for month in 1..12
    puts year.to_s+" "+ month.to_s
    next if year == 2013 && month < 8
    next if year == 2014 && month > 2
    time = Time.local(year, month, 1, 0, 0, 0)
    #p time
    while time.month == month
      print time.day.to_s+" "
      values = f.fetchDay(time.year, time.month, time.day)
      values.each_with_index do |energy, hour|
        record = MirueneRecord.new
        record.datetime = time.to_i + hour*3600
        record.energy = energy
        record.save
      end
      time += 24*60*60
    end
    puts ""
    sleep 1
  end
end

