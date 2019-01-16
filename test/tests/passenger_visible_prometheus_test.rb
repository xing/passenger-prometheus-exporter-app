require "minitest/autorun"
require "net/http"
require "uri"
require_relative "./helpers.rb"

describe "passenger with visible Prometheus application" do
  before do
    wait_to_be_ready("http://passenger_with_visible_prometheus:10254/")
  end

  it "should return metrics" do
    response = Net::HTTP.get(URI("http://passenger_with_visible_prometheus:10254/metrics"))
    assert_includes(response, "passenger_capacity")
    assert_includes(response, "passenger_wait_list_size")
    assert_includes(response, "passenger_processes_active")
  end

  it "should have both application listen" do
    response = Net::HTTP.get(URI("http://passenger_with_visible_prometheus:10254/metrics"))
    assert_includes(response, "passenger_capacity{supergroup_name=\"/app (development)\",group_name=\"/app (development)\",hostname=\"passenger_with_visible_prometheus\"} 1")
    assert_includes(response, "passenger_capacity{supergroup_name=\"/monitor (production)\",group_name=\"/monitor (production)\",hostname=\"passenger_with_visible_prometheus\"} 1")
  end
end
