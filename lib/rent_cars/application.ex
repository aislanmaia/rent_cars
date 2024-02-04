defmodule RentCars.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RentCarsWeb.Telemetry,
      RentCars.Repo,
      {DNSCluster, query: Application.get_env(:rent_cars, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: RentCars.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: RentCars.Finch},
      # Start a worker by calling: RentCars.Worker.start_link(arg)
      # {RentCars.Worker, arg},
      # Start to serve requests, typically the last entry
      RentCarsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RentCars.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RentCarsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
