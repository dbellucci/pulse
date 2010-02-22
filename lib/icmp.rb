require 'lib/probe'
require 'net/ping/icmp'


class ICMP < NetworkProbe
	attr_reader :duration	
	
      	def ping(target)
      		@duration = nil
      		
      		icmp = Net::Ping::ICMP.new
      		
      		if icmp.ping? target then
      			@duration = icmp.duration
      			bool = true
      		end
      		
      		bool
	end
end

