defmodule Vsrex.ReplicaTopology do
  defstruct [:replicas, :configuration]

  alias Vsrex.{Vsr, ReplicaTopology}

  def init(configuration, replicas) do
    %__MODULE__{configuration: configuration, replicas: replicas}
  end

  def replica_number(%ReplicaTopology{} = topology, replica) do
    Vsr.replica_index(topology.configuration, replica)
  end

  def add_replica(%ReplicaTopology{} = topology, replica) do
    new_replicas = [replica | topology.replicas] |> Enum.uniq() |> Enum.sort()
    %ReplicaTopology{topology | replicas: new_replicas}
  end
end
