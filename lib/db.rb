require 'rubygems'
require 'sqlite3'

module DB
	def report(value)
		@db_handle.execute("INSERT INTO sample(sample) VALUES ('#{value.to_s}')")
	end
	
	def open(name)
		@db_handle = SQLite3::Database.new(name)
		
		at_exit { 
			DB::close 
		}
		
		@db_handle.execute("CREATE TABLE sample (id INTEGER PRIMARY KEY, sample TEXT, timestamp DEFAULT CURRENT_TIMESTAMP)")
	end

	def close
		@db_handle.close
	end
end

