defmodule Vsrex.Replica do
  use GenServer
  alias Vsrex.Replica.State

  require Logger

  @spec state() :: %State{}
  def state() do
    GenServer.call(__MODULE__, :state)
  end

  @spec receive(message :: any()) :: :ok
  def receive(message) do
    GenServer.cast(__MODULE__, {:receive, message})
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    {:ok, %State{}, {:continue, :init_state}}
  end

  def handle_continue(:init_state, state) do
    replica_state = State.init(state)
    {:noreply, replica_state}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:receive, message}, state) do
    Logger.debug("[#{inspect(state.replica)}] received #{inspect(message)}")
    {:noreply, state}
  end
end
