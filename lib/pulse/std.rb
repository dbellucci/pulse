module Pulse
	class STDOUT
		def self.report(echo)
			$stdout.puts "pulse from #{echo[:host]} id:#{echo[:id]} rtt:#{echo[:rtt]}"
		end
	end

	class STDERR
		def self.fail(echo)
			$stderr.puts "missing pulse from #{echo[:host]} id:#{echo[:id]}"
		end
	end
end
