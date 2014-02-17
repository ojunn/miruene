class ChangeMirueneRecordsDatetimeUnique < ActiveRecord::Migration
	def change
		add_index :miruene_records, :datetime, :unique => true
	end
end

