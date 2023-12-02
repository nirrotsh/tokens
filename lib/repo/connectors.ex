defmodule Repo.Connectors do
  @callback push(GenServer.server(), Connector.Data.t()) :: :ok | {:error, term}
  @callback get(GenServer.server(), String.t()) :: {:ok, Connector.Data.t()} | {:error, term}
end
