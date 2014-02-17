# coding: utf-8

require "rubygems"
require "mechanize"

class FetchMiruene

	def initialize
		@config = YAML.load_file("./config/miruene.yaml")
		@agent = Mechanize.new
		login()
	end

	def login
		login = @agent.get(@config["url"]["login"])
		form = login.forms[0]
		form.userId   = @config["userId"]
		form.password = @config["password"]
		@agent.submit(form)
	end

	def fetchMonth(year, month)
		
	end

	def fetchDay(year, month, day)
		#date  = year.to_s+"年"+month.to_s+"月"+day.to_s+"日"
		#p date
		page = @agent.get(@config["url"]["data"])
		form = page.forms[0]
		form.month = month
		form.day   = day
		form.hiddenMonth = month
		form.hiddenDay   = day
		form.action = "/eipc/pcd_time.do"
		page = @agent.submit(form)
		#p page.search('//*[@id="PCD100Form"]/table[2]/tr/td[2]/table[1]/tr[2]/td').text.strip

		days = page.search('//*[@id="PCD100Form"]/table[2]/tr/td[2]/table[1]/tr[4]/td/table/tr[2]/td/table/tr/td/table[2]/tr/td').size

		data = []	

		for i in 1..days
			page.search('//*[@id="PCD100Form"]/table[2]/tr/td[2]/table[1]/tr[4]/td/table/tr[2]/td/table/tr/td/table[2]/tr/td['+ i.to_s + ']/img').each do |elem|
				value = elem.attribute("title").to_s
				if value.index("当日") == 0
					values = value.scan(/当日(\S+)時　(\S+)kWh/) 
					hour   = values[0][0].to_i
					energy =  values[0][1].to_f
					data[hour] = energy
				end
			end
		end

		return data
	end

end

f = FetchMiruene.new
for month in 1..2
	time = Time.local(2014, month, 1, 0, 0, 0)
	while time.month == month
		data = f.fetchDay(time.year, time.month, time.day)
		data.each_with_index do |energy, hour|
			p time + hour*3600
			p energy
		end
		time += 24*60*60
	end
end


