defmodule Bank.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: Bank.Supervisor]
    Supervisor.start_link([Bank.CommandedApplication], opts)
  end
end
