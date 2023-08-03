defmodule Vsrex.Mailroom do
  @moduledoc """
  Each replica has a Mailroom

  In a VSR system only the Primary replica handles the processing of messages.
  If the replica receiving the message is the primary it is simply
  sent to the `Replica` module for normal processing. If the replica
  receing the message is not the primary, it is forwarded to that
  replica in the cluster and processed normally.
  """
  use GenServer
  require Logger
  alias Vsrex.{Topology, Replica}

  def route(message), do: GenServer.cast(__MODULE__, {:route, message})

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    {:ok, %{}}
  end

  def handle_cast({:route, message}, state) do
    %{replicas: replicas} = Topology.state()
    replica_state = Replica.state()

    if Vsrex.is_primary?(replica_state) do
      Logger.debug(
        "[#{inspect(replica_state.replica)}] passing #{inspect(message)} to Replica.receive/1"
      )

      Replica.receive(message)
      {:noreply, state}
    else
      primary_replica =
        replica_state.view_number
        |> Vsrex.primary_index(replicas)
        |> Vsrex.primary_replica(replicas)

      Logger.debug("[#{inspect(replica_state.replica)}] rerouting to #{inspect(primary_replica)}")
      :ok = GenServer.cast({Vsrex.Mailroom, primary_replica}, {:route, message})
      {:noreply, state}
    end
  end
end
