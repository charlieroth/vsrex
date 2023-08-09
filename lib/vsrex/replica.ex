defmodule Vsrex.Replica do
  use GenServer
  alias Vsrex.Replica.State
  alias Vsrex.Messages

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
    state = handle_message(message, state)
    {:noreply, state}
  end

  defp handle_message(%Messages.Request{} = _message, state) do
    # TODO(charlieroth)

    # (1) Message Received
    # Client sends a {"REQUEST", operation, client_id, request_number} message

    # (2) Request Number Comparison
    # - If request_number < client_table.request_number, request is dropped
    # - If request_number == client_table.request_number, re-send response
    # - Else, request is processed

    # (3) Processing Message
    # - Primary advances op_number
    # - Primary appends request to log
    # - Primary updates client_table with new request_number
    # - Primary sends PREPARE message to all replicas

    state
  end

  defp handle_message(%Messages.Prepare{} = _message, state) do
    # TODO(charlieroth)

    # (4) Process "PREPARE" Messages
    # - Backup won't accept PREPARE messages with op_number until it has
    #   entries for all earlier requests in its log
    #   - Backup performs state transfer to update itself THEN processes PREPARE messages
    # - Backup advances op_number
    # - Backup appends request to log
    # - Backup updates client_table with new request_number
    # - Backup sends PREPARE_OK to primary to indicate good operation state

    state
  end

  defp handle_message(%Messages.PrepareOk{} = _message, state) do
    # TODO(charlieroth)

    # (5) Processing PREPARE_OK Messages
    # - Primary waits for F PREPARE_OK messages from backups to consider request committed
    # - Primary executes operation up-call
    # - Primary advances commit_number
    # - Primary sends REPLY message to client

    state
  end

  defp handle_message(%Messages.Commit{} = _message, state) do
    # TODO(charlieroth)

    # (6) Primary Informs Backups of Commit
    # - If Primary does not receive new client request in timely manner, it sends
    #   a COMMIT message to backups to inform them of the latest commit

    # (7) Processing COMMIT Messages
    # - When Backup receives COMMIT message, it must first ensure that it has all
    #   earlier requests in its log, and if not, perform state transfer
    # - Backup executes operation up-call
    # - Backup advances commit_number
    # - Backup updates client_table
    # - Backup does not send reply to client
    state
  end

  defp handle_message(message, state) do
    Logger.debug("[#{inspect(state.replica)}] message #{inspect(message.type)} not implemented!!")

    state
  end
end
