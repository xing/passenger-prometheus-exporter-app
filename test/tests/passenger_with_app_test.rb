require "minitest/autorun"
require "net/http"
require "uri"
require_relative "./helpers.rb"

describe "passenger with application" do
  before do
    wait_to_be_ready("http://passenger_with_app:10254/")
  end

  it "should return metrics" do
    response = Net::HTTP.get(URI("http://passenger_with_app:10254/metrics"))
    assert_includes(response, "passenger_capacity")
    assert_includes(response, "passenger_wait_list_size")
    assert_includes(response, "passenger_processes_active")
  end

  it "should have the right labels" do
    response = Net::HTTP.get(URI("http://passenger_with_app:10254/metrics"))
    assert_includes(response, "passenger_capacity{supergroup_name=\"/app (development)\",group_name=\"/app (development)\",hostname=\"passenger_with_app\"}")
  end

  it "should have the right values" do
    response = Net::HTTP.get(URI("http://passenger_with_app:10254/metrics"))
    assert_includes(response, "passenger_capacity{supergroup_name=\"/app (development)\",group_name=\"/app (development)\",hostname=\"passenger_with_app\"} 1")
  end
end
