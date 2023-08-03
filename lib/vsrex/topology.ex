defmodule Vsrex.Topology do
  @moduledoc """
  This module is responsible for managing the topology of the cluster.

  `Vsrex.Topology` is concerned with holding the configuration of the cluster
  that is shared across all replicas via libcluster. It is also serves as a source
  of truth for the `Vsrex.Replica` module when performing VSR operations.
  """
  alias Vsrex.Replica
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

    replicas =
      if Node.list() == [] do
        [Node.self()]
      else
        [Node.self() | Node.list()]
      end

    topology = Replica.Topology.init(confiuration, replicas)
    Logger.debug("[#{Node.self()}] initial replica set: #{inspect(topology.replicas)}")

    :net_kernel.monitor_nodes(true)
    {:ok, topology}
  end

  def handle_info({:nodeup, node}, state) do
    Logger.debug("[#{Node.self()}] replica joined: #{inspect(node)}")
    {:noreply, Replica.Topology.add_replica(state, node)}
  end

  def handle_info({:nodedown, node}, state) do
    Logger.debug("[#{Node.self()}] replica left: #{inspect(node)}")
    {:noreply, Replica.Topology.remove_replica(state, node)}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end
end
