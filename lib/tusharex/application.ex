defmodule Tusharex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Tsex.Worker.start_link(arg)
      # {Tusharex.Worker, arg},

      %{
        id: Tusharex.Counter,
        start: {Tusharex.Counter, :start_link, []}
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tusharex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
