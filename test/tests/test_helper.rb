require "minitest/autorun"
require "net/http"
require "uri"

def wait_to_be_ready(uri, max_retries: 5, delay: 3)
  retries ||= 0
  return Net::HTTP.get(URI(uri))
rescue Errno::ECONNREFUSED
 sleep delay
 retry if (retries += 1) < max_retries
 raise
end
