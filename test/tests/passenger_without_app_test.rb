require "minitest/autorun"
require "net/http"
require "uri"
require_relative "./helpers.rb"

describe "passenger without application" do
  before do
    wait_to_be_ready("http://passenger_without_app:10254/")
  end

  it "should return a comment with no metrics" do
    response = Net::HTTP.get(URI("http://passenger_without_app:10254/metrics"))
    assert_equal("# ERROR: No other application has been loaded yet", response)
  end
end
