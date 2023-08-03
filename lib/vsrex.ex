defmodule Vsrex do
  @moduledoc """
  Common VSR operations
  """
  alias Vsrex.Replica
  alias Vsrex.Topology

  @spec is_view_change?(replica_state :: %Replica.State{}) :: boolean()
  def is_view_change?(%Replica.State{} = _state), do: false

  @spec is_backup?(replica_state :: %Replica.State{}) :: boolean()
  def is_backup?(%Replica.State{} = replica_state), do: not is_primary?(replica_state)

  @spec is_primary?(replica_state :: %Replica.State{}) :: boolean()
  def is_primary?(%Replica.State{} = replica_state) do
    %{replicas: replicas} = Topology.state()

    replica_index(replicas, replica_state.replica) ==
      primary_index(replica_state.view_number, replicas)
  end

  @spec primary_replica(primary_index :: integer(), replicas :: [atom()]) :: atom()
  def primary_replica(primary_index, replicas), do: Enum.at(replicas, primary_index)

  @spec primary_index(view_number :: integer(), replicas :: [atom()]) :: integer()
  def primary_index(view_number, replicas) do
    Integer.mod(view_number, length(replicas))
  end

  @spec replica_index(replicas :: [atom()], replica_name :: atom()) :: non_neg_integer() | nil
  def replica_index(replicas, replica_name) do
    Enum.find_index(replicas, fn replica -> replica == replica_name end)
  end
end
