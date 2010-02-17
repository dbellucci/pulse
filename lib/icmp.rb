require 'rubygems'
require 'net/ping/icmp'
require 'lib/probe.rb'


class ICMP < NetworkProbe
	def build_probe
		Net::Ping::ICMP.new
	end	
end


