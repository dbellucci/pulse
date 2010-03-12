require 'pulse/probe'
require 'net/http'
require 'net/https'
require 'uri'

module Pulse
	class HTTP < NetworkProbe
		attr_reader :duration

		def grep(pattern)
			@grep_regexp = Regexp.new(pattern)
		end
		
	      	def ping(target)
			response  = nil
		 	@duration = nil
			@response = nil
			@error    = nil


		 	start_time = Time.now

		 	begin
		 		u = URI.parse(target)
		 		
		 		http = Net::HTTP.new(u.host, u.port)
		 		
		 		if u.scheme.eql? 'https' then 
		 			http.use_ssl = true
		 			http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		 		end
		 		
		    		Timeout.timeout(3) {
		    			http.start() do |h|
		    				req      = Net::HTTP::Get.new((u.path.empty?)? '/': u.path)
		    				response = h.request(req)
		    			end
		    			
		  		}
		 	rescue Exception => err
				false
		 	else
				end_time = Time.now
			
		    		if response.is_a?(Net::HTTPSuccess)
		    			unless @grep_regexp.nil?	
						match = false
					
						response.read_body.each_line do |line|
							if line =~ @grep_regexp then
								match = true
								break
							end
						end
					
						return false unless match
					end
					@duration = end_time - start_time
					true
		    		else
		    			false
		    		end
	      		end
		end
	
		def initialize(opts={})
			@grep_regexp = nil
			super(opts)
		end
	
	end
end

