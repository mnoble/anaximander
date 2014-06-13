require "socket"
require "net/http"
require "fakeout/safe"
require "anaximander"

RSpec.configure do |c|
  c.filter_run_excluding :endtoend

  c.before do
    Anaximander.logger = false
  end

  c.before :each, :endtoend do
    @port = obtain_port
    @pid  = Process.spawn({}, "rackup -p #{@port}", chdir: File.expand_path("../data/site", __FILE__), out: "/dev/null", err: "/dev/null")
    sleep 0.1 until server_running?
  end

  c.after :each, :endtoend do
    Process.kill("INT", @pid)
  end

  # TCPServer, given a port of 0, will ask the OS for a
  # random, available, port.
  #
  def obtain_port
    server = TCPServer.new("127.0.0.1", 0)
    port   = server.addr[1]
    server.close
    port
  end

  # Try to retrieve the homepage of the test site.
  #
  def server_running?
    http = Net::HTTP.new("localhost", @port)
    req  = Net::HTTP::Get.new("/index.html")
    http.request(req).is_a?(Net::HTTPOK)
  rescue Errno::ECONNREFUSED
    false
  end
end
