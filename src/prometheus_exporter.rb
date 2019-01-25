require 'nokogiri'
require 'sinatra/base'

# PrometheusExporterApp is a small Sinatra application that exports Passenger
# metrics in a Prometheus format
class PrometheusExporterApp < Sinatra::Base

  # Path to the monitor application
  SELF_GROUP_NAME = "Prometheus exporter"

  # Labels to add on each metric
  COMMON_LABELS = {"hostname" => ENV["HOSTNAME"]}

  # Endpoint return the metrics in a Prometheus format
  get '/metrics' do
    content_type 'text/plain'
    passenger_prometheus_metrics
  end

  # Return passenger-status metrics in a Prometheus format
  def passenger_prometheus_metrics
    supergroups = passenger_status.xpath("info/supergroups/supergroup")
    return "# ERROR: No other application has been loaded yet" if supergroups.length == 1

    metrics = []
    for supergroup in hide_ourselves(supergroups) do
      for group in supergroup.xpath("group") do
        labels = {"supergroup_name" => supergroup.xpath("name").text, "group_name" => group.xpath("name").text}
        active_processes = group.xpath("processes/process/busyness").reject{|x| x.text == "0"}.length
        metrics.concat(prometheus_metric("passenger_processes_active", "Active processes", "gauge", labels, active_processes))
        metrics.concat(prometheus_metric("passenger_capacity", "Capacity used", "gauge", labels, group.xpath("capacity_used").text))
        metrics.concat(prometheus_metric("passenger_wait_list_size", "Requests in the queue", "gauge", labels, group.xpath("get_wait_list_size").text))
      end
    end

    return metrics.map{ |line| "#{line}\n"}
  end

  # Return lines describing one single Prometheus metric
  def prometheus_metric(name, help, type, labels, value)
    labels_str = labels.merge(COMMON_LABELS).map{|x,y| "#{x}=\"#{y}\""}.join(",")
    metric = []
    metric << "# HELP #{name} #{help}"
    metric << "# TYPE #{name} #{type}"
    metric << "#{name}{#{labels_str}} #{value}"
    metric
  end

  # Hide the Prometheus exporter from the output
  def hide_ourselves(supergroups)
    supergroups.reject{ |s| s.xpath("name").text ==  SELF_GROUP_NAME }
  end

  # Execute passenger-status and return the result as XML
  def passenger_status
    # The official Phusion image has a Ruby wrapper that prepend script outputs with
    # the path of the Ruby version being used

    # This breaks XML parsing, and that's why we explicitly execute Ruby to avoid
    # using the Shebang of passenger-status that has this broken wrapper
    raw_xml = `ruby \`which passenger-status\` -v --show=xml 2>/dev/null`
    Nokogiri::XML(raw_xml) { |config| config.strict }
  end
end
