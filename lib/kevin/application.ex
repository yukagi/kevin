defmodule Kevin.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      KevinWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:kevin, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Kevin.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Kevin.Finch},
      # Start a worker by calling: Kevin.Worker.start_link(arg)
      # {Kevin.Worker, arg},
      # Start to serve requests, typically the last entry
      KevinWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Kevin.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KevinWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
