defmodule ElixstaticBlog do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(ElixstaticBlog.Worker, [arg1, arg2, arg3])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixstaticBlog.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def run do
    routes = [
      {"/:filename", ElixstaticBlog.Handler, []},
      {"/static/[...]", :cowboy_static, {:priv_dir, :elixstatic_blog, "static_files"}}
    ]

    dispatch = :cowboy_router.compile([{:_, routes}])

    options = [port: 8000]
    env = [dispatch: dispatch]

    {:ok, _pid} = :cowboy.start_http(:http, 100, options, [env: env])

  end
end
