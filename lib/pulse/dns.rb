require 'pulse/probe'
require 'resolv'
require 'uri'

module Pulse
	class DNS < NetworkProbe
		attr_reader :duration

		def grep(pattern)
			@grep = pattern
		end
		
	      	def ping(target)
			@duration = nil

			response  = nil
			match     = false
			
		 	start_time = Time.now

		 	begin
				Resolv::DNS::open( :nameserver => target) do |dns|
					Timeout.timeout(3) {
						response = dns.getaddresses(@query) 
					}

					if @grep.nil? then
						match = response.any?
					else
						response.each do |addr|
							if addr.to_s.eql? @grep
								match = true
								break
							end
						end
					end
				end

			end_time = Time.now
						
		 	rescue Exception => err
				false
		 	else
		 		if match then 
					@duration = end_time - start_time
				end
				
				match
	      		end
		end
	
		def initialize(opts={})
			@query       = opts[:host]
			@grep        = nil
			super(opts)
		end
	end
end

