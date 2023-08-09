defmodule Vsrex.Replica.Topology do
  defstruct [:replicas, :configuration]

  alias Vsrex.Replica.Topology

  @spec init(configuration :: [atom()], replicas :: [atom()]) :: %Topology{}
  def init(configuration, replicas) do
    %Topology{
      configuration: configuration,
      replicas: organize_replicas(replicas)
    }
  end

  @spec replica_number(topology :: %Topology{}, replica :: atom()) :: non_neg_integer()
  def replica_number(%Topology{} = topology, replica) do
    Vsrex.replica_index(topology.configuration, replica)
  end

  @spec add_replica(topology :: %Topology{}, replica :: atom()) :: %Topology{}
  def add_replica(%Topology{} = topology, replica) do
    new_replicas =
      [replica | topology.replicas]
      |> organize_replicas()

    %{topology | replicas: new_replicas}
  end

  @spec remove_replica(topology :: %Topology{}, replica :: atom()) :: %Topology{}
  def remove_replica(%Topology{} = topology, replica) do
    new_replicas =
      topology.replicas
      |> Enum.reject(fn r -> r == replica end)
      |> organize_replicas()

    %{topology | replicas: new_replicas}
  end

  @spec organize_replicas(replicas :: [atom()]) :: [atom()]
  defp organize_replicas(replicas) do
    replicas
    |> Enum.uniq()
    |> Enum.sort()
  end
end
