defmodule Vsrex.Replica do
  use GenServer
  alias Vsrex.{ReplicaState, Topology}

  require Logger

  def state() do
    GenServer.call(__MODULE__, :state)
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    {:ok, %ReplicaState{}, {:continue, :init_state}}
  end

  def handle_continue(:init_state, state) do
    %{configuration: configuration} = Topology.state()
    replica_state = ReplicaState.init(state, configuration)
    {:noreply, replica_state}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end
end
