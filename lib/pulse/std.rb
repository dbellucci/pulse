module Pulse
	class STDOUT
		def self.report(echo)
			$stdout.puts "pulse from host:#{echo[:host]} id:#{echo[:id]} rtt:#{echo[:rtt]}"
		end
	end

	class STDERR
		def self.report(echo)
			$stderr.puts "missing pulse id:#{echo[:id]} from #{echo[:host]} "
		end
	end
end
