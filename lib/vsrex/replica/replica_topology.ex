defmodule Vsrex.ReplicaTopology do
  defstruct [:replicas, :configuration]

  alias Vsrex.{Vsr, ReplicaTopology}

  def init(configuration, replicas) do
    %ReplicaTopology{
      configuration: configuration,
      replicas: organize_replicas(replicas)
    }
  end

  def replica_number(%ReplicaTopology{} = topology, replica) do
    Vsr.replica_index(topology.configuration, replica)
  end

  def add_replica(%ReplicaTopology{} = topology, replica) do
    new_replicas =
      [replica | topology.replicas]
      |> organize_replicas()

    %{topology | replicas: new_replicas}
  end

  def remove_replica(%ReplicaTopology{} = topology, replica) do
    new_replicas =
      topology.replicas
      |> Enum.reject(fn r -> r == replica end)
      |> organize_replicas()

    %{topology | replicas: new_replicas}
  end

  defp organize_replicas(replicas) do
    replicas
    |> Enum.uniq()
    |> Enum.sort()
  end
end
