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
		data = {}
		time = Time.local(year, month, 1, 0, 0, 0)
		while time.month == month
			values = f.fetchDay(time.year, time.month, time.day)
			values.each_with_index do |energy, hour|
				data[time + hour*3600] = energy
			end
			time += 24*60*60
		end
	end

	def fetchDay(year, month, day)
		page = @agent.get(@config["url"]["data"])
		form = page.forms[0]
		form.year  = year
		form.month = month
		form.day   = day
		form.hiddenMonth = month
		form.hiddenDay   = day
		form.action = @config["url"]["time"]
		page = @agent.submit(form)
		p page.search('//*[@id="PCD100Form"]/table[2]/tr/td[2]/table[1]/tr[2]/td').text.strip

		days = page.search('//*[@id="PCD100Form"]/table[2]/tr/td[2]/table[1]/tr[4]/td/table/tr[2]/td/table/tr/td/table[2]/tr/td').size

		data = []	

		for i in 1..days
			page.search('//*[@id="PCD100Form"]/table[2]/tr/td[2]/table[1]/tr[4]/td/table/tr[2]/td/table/tr/td/table[2]/tr/td['+ i.to_s + ']/img').each do |elem|
				value = elem.attribute("title").to_s
				if value.index("当日") == 0
					values = value.scan(/当日(\S+)時　(\S+)kWh/) 
					hour   = values[0][0].to_i
					energy = values[0][1].to_f
					energy *= 1000
					data[hour] = energy.to_i
				end
			end
		end

		return data
	end

end


