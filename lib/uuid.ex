defmodule Uuid do
  @moduledoc """
  This module contains definitions useful for working with UUIDs.
  """

  @typedoc """
  A 128-bit long bitstring.
  """
  @type t :: <<_::128>>

  @spec new :: t
  defdelegate new, to: :uuid, as: :get_v4

  @doc """
      iex> Uuid.to_string(<<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>>)
      "00000000-0000-0000-0000-000000000000"
  """
  @spec to_string(t) :: String.t() | no_return()
  def to_string(uuid), do: Kernel.to_string(:uuid.uuid_to_string(uuid))

  @doc """
      iex> from_string!("00000000-0000-0000-0000-000000000000")
      <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>>
  """
  @spec from_string!(String.t()) :: t | no_return()
  defdelegate from_string!(string), to: :uuid, as: :string_to_uuid
end
