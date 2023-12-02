defmodule Connector.Data do
  defstruct [:key, :cust_id, :vendor, :oauth2_url, :auth_token, :refresh_token, :expires_at, :updated]
  @type t :: %__MODULE__{
    key: String.t(),
    cust_id: String.t(),
    vendor: String.t() | Atom,
    oauth2_url: String.t(),
    auth_token: String.t(),
    refresh_token: String.t(),
    expires_at: DateTime.t(),
    updated: DateTime.t()
  }
end
