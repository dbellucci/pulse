require 'pulse/probe'
require 'rubygems'
require 'net/ping/icmp'

module Pulse
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
end

