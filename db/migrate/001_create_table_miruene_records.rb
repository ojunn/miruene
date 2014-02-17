class CreateTableMirueneRecords < ActiveRecord::Migration
	def change
		create_table :miruene_records do |t|
			t.timestamp  :datetime
			t.integer    :energy
			t.timestamps
		end
	end
end

