class KubectlRailsRunner
  attr_accessor :namespace
  attr_accessor :pod

  def initialize(namespace = "namespace", pod = "pod")
    @namespace = namespace
    @pod       = pod
  end

  def self.get_pods(namespace)
    pods       = `kubectl get pods --namespace=#{namespace}`
    pods_array = pods.split("\n").map do |s| 
      s.gsub(/\s+/m, ' ').strip.split(" ")
    end
    pods_array.shift
    pods_array
  
    pods_array = pods_array.map do |pod| 
      if pod[0].start_with? "frontend" and pod[2].eql? "Running"
        pod[0]
      end
    end

    pods_array.compact
  end

  def self.get_all_pods
    pods       = `kubectl get pods --all-namespaces`
    pods_array = pods.split("\n").map do |s| 
      s.gsub(/\s+/m, ' ').strip.split(" ")
    end
    pods_array.shift
    pods_array
  end

  def self.init(namespace, pod)
    return KubectlRailsRunner.new(namespace, pod)
  end

  def run_command(ruby_code)
    p `kubectl --namespace=#{self.namespace} exec -it #{self.pod} -c webapp -- rails runner '#{ruby_code}'`
  end
end
