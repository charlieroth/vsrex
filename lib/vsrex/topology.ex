defmodule Vsrex.Topology do
  alias Vsrex.ReplicaTopology
  use GenServer

  require Logger

  def state() do
    GenServer.call(__MODULE__, :state)
  end

  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    topologies = Application.get_env(:libcluster, :topologies)
    vsrex_topology = Keyword.fetch!(topologies, :vsrex)
    vsrex_topology_config = Keyword.fetch!(vsrex_topology, :config)
    confiuration = Keyword.fetch!(vsrex_topology_config, :hosts)
    topology = ReplicaTopology.init(confiuration, [Node.self()])
    :net_kernel.monitor_nodes(true)

    {:ok, topology}
  end

  def handle_info({:nodeup, node}, state) do
    Logger.info("node up: #{inspect(node)}")
    {:noreply, ReplicaTopology.add_replica(state, node)}
  end

  def handle_info({:nodedown, node}, state) do
    Logger.info("node down: #{inspect(node)}")
    {:noreply, state}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end
end
