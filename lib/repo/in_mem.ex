defmodule Repo.InMem do
  @behaviour Repo.Connectors
  use GenServer

  # Client
  def start_link(data\\%{}) when is_map(data) do
    GenServer.start_link(__MODULE__, data)
  end

  @impl Repo.Connectors
  def push(server, %Connector.Data{} = data) do
    GenServer.cast(server, {:push, data})
    :ok
  end

  @impl Repo.Connectors
  def get(server, key) do
    GenServer.call(server, {:get, key})
  end

  # Server
  @impl GenServer
  def init(data) when is_map(data) do
    {:ok, data}
  end

  @impl GenServer
  def handle_cast({:push,  %Connector.Data{} = connector}, state) do
    {:noreply, Map.put(state, connector.key, connector)}
  end

  @impl GenServer
  def handle_call({:get, key}, _from, state) do
    case Map.fetch(state, key) do
      {:ok, c} -> {:reply, {:ok, c}, state}
      _ ->  {:reply, {:error, :not_found}, state}
    end
  end
end
