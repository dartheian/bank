defmodule Bank.Domain.ValueObjects.Uuid do
  @moduledoc """
  This module contains the definitions to work with UUIDs.
  """

  @type t :: <<_::128>>

  defdelegate new, to: :uuid, as: :get_v4
  defdelegate to_string(uuid), to: :uuid, as: :uuid_to_string
  defdelegate from_string(string), to: :uuid, as: :string_to_uuid
end
