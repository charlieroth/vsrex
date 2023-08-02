defmodule Vsrex.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {
        Cluster.Supervisor,
        [
          Application.get_env(:libcluster, :topologies),
          [name: Vsrex.ClusterSupervisor]
        ]
      },
      Vsrex.Topology,
      Vsrex.Replica
    ]

    opts = [strategy: :one_for_one, name: Vsrex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
