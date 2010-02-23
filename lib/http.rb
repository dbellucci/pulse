require 'net/http'
require 'uri'
require 'lib/probe'


class HTTP < NetworkProbe
	attr_reader :duration

	def grep(pattern)
		@grep_regexp = Regexp.new(pattern)
	end
		
      	def ping(target)

         	response = nil
         	
		@duration = nil
		@response = nil
		@error    = nil

         	start_time = Time.now

         	begin
            		Timeout.timeout(3) {
            			response = Net::HTTP.get_response(URI.parse(target))
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
	
	def initialize(host, opts={})
		@grep_regexp = nil
		
		super(host, opts)
	end
	
end

