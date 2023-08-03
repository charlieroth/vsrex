defmodule Vsrex.Replica.Topology do
  defstruct [:replicas, :configuration]

  alias Vsrex.Replica.Topology

  def init(configuration, replicas) do
    %Topology{
      configuration: configuration,
      replicas: organize_replicas(replicas)
    }
  end

  def replica_number(%Topology{} = topology, replica) do
    Vsrex.replica_index(topology.configuration, replica)
  end

  def add_replica(%Topology{} = topology, replica) do
    new_replicas =
      [replica | topology.replicas]
      |> organize_replicas()

    %{topology | replicas: new_replicas}
  end

  def remove_replica(%Topology{} = topology, replica) do
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
