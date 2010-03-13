require 'rubygems'
require 'sqlite3'

module Pulse
	class DB
		def self.fail(echo)
			return if @db_handle.nil?
			@db_handle.execute("INSERT INTO sample(pulse_id, pulse_rtt) VALUES (#{echo[:id]}, null)")
		end
	
		def self.report(echo)
			return if @db_handle.nil?
			@db_handle.execute("INSERT INTO sample(pulse_id, pulse_rtt) VALUES (#{echo[:id]}, #{echo[:rtt]})")
		end
	
		def self.open(name)
			@db_handle = SQLite3::Database.new(name)
		
			at_exit { 
				self.close 
			}
		
			@db_handle.execute("CREATE TABLE sample (id INTEGER PRIMARY KEY, pulse_id INTEGER, pulse_rtt FLOAT, timestamp DEFAULT CURRENT_TIMESTAMP)")
		end

		def self.close	
			@db_handle.close
		end
	end
end

