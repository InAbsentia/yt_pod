defmodule YTPod.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      YTPodWeb.Telemetry,
      YTPod.Repo,
      {DNSCluster, query: Application.get_env(:yt_pod, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: YTPod.PubSub},
      # Start a worker by calling: YTPod.Worker.start_link(arg)
      # {YTPod.Worker, arg},
      # Start to serve requests, typically the last entry
      YTPodWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :yt_pod]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: YTPod.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl Application
  def config_change(changed, _new, removed) do
    YTPodWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
