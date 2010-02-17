require 'rubygems'
require 'lib/probe'
require 'net/ping/http'


class HTTP < NetworkProbe
	def run(url, opts)
		http = Net::Ping::HTTP.new
		
		opts[:count]      ||= 5
		opts[:frequency]  ||= 10
		opts[:round_trip] ||= 0.05
		
		loop do
			opts[:count].times do 
				if http.ping? url then
					report(http.duration)
				else
					puts "#{url} is dead!"
					report(0)
				end				

				sleep opts[:round_trip]
			end
			
			sleep opts[:frequency]
		end
	end	
end

