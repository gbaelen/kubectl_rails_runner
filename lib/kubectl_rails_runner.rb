class KubectlRailsRunner
  attr_accessor :namespace
  attr_accessor :pod

  def initialize(namespace = "namespace", pod = "pod")
    @namespace = namespace
    @pod       = pod
  end

  def self.get_pods
    pods       = `kubectl get pods --all-namespaces`
    pods_array = pods.split("\n").map do |s| 
      s.gsub(/\s+/m, ' ').strip.split(" ")
    end
    pods_array.shift
    pods_array
  end

  def self.run_command
    p `kubectl --namespace=webrtc exec -it frontend-1765095596-dt5lf -c webapp -- rails runner 'p StudentSession.last'`
  end
end
