require 'rubygems'
require 'sqlite3'

module PulseDB
	def db_report(value)
		@db_handle.execute("INSERT INTO sample(sample) VALUES (#{value})")
	end
	
	def db_open(name)
		@db_handle = SQLite3::Database.new(name)
		
		at_exit { 
			db_close 
		}
		
		@db_handle.execute("CREATE TABLE sample (id INTEGER PRIMARY KEY, sample FLOAT, timestamp DEFAULT CURRENT_TIMESTAMP)")
	end

	def db_close	
		@db_handle.close
	end
end

