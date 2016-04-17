require 'webrick'

root = File.expand_path '.'
server = WEBrick::HTTPServer.new :Port => 8000, :DocumentRoot => root, MimeTypes: { 'rhtml' => 'text/html', 'jpg' => 'image/jpeg' }

WEBrick::HTTPServlet::ERBHandler.new(server, root)

trap 'INT' do server.shutdown end

server.start

