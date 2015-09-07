defmodule ElixstaticBlog.Handler do
	def init({:tcp, :http}, req, opts) do
		# headers = [{"content-type", "text-plain"}]
		# body = "Hello Program!"
		# {:ok, resp} = :cowboy_req.reply(200, headers, body, req)
		{:ok, req, opts}
	end

	def handle(req, state) do
		{method, req} = :cowboy_req.method(req)
		{param, req} = :cowboy_req.binding(:filename, req)
		IO.inspect param
		{:ok, req} = get_file(method, param, req)
		{:ok, req, state}
	end

	def get_file("GET", :undefined, req) do
		headers = [{"content-type", "text-plain"}]
		body = "Page Not Found"
		{:ok, resp} = :cowboy_req.reply(404, headers, body, req)
	end

	def get_file("GET", param, req) do
		headers = [{"content-type", "text/html"}]
		{:ok, file} = File.read "priv/contents/filename.md"
		body = Earmark.to_html(file)
		{:ok, resp} = :cowboy_req.reply(200, headers, body, req)
	end

	def terminate(_reason, _req, _state) do
		:ok
	end
end