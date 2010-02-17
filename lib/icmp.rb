require 'rubygems'
require 'net/ping/icmp'
require 'lib/probe.rb'


class ICMP < NetworkProbe
	def run(host, opts)
		icmp = Net::Ping::ICMP.new
		
		opts[:count]      ||= 5
		opts[:frequency]  ||= 10
		opts[:round_trip] ||= 0.05
		opts[:name]       ||= 'ICMP'
		
		loop do
			opts[:count].times do 
				if icmp.ping(host) then
					report(opts[:name], icmp.duration)
				end				

				sleep opts[:round_trip]
			end
			
			sleep opts[:frequency]
		end
	end	
end



