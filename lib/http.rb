require 'rubygems'
require 'lib/probe'
require 'net/ping/http'


class HTTP < NetworkProbe
	def build_probe
		Net::Ping::HTTP.new
	end	
end

