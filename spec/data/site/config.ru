use Rack::Static, root: "public"
run lambda { |env|
  page = env["PATH_INFO"].empty? ? "index.html" : env["PATH_INFO"]
  file = File.open("public/#{page}", File::RDONLY)
  [200, {"Content-Type" => "text/html"}, file]
}
