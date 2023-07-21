defmodule Uuid do
  @moduledoc """
  This module contains definitions useful for working with v4 UUIDs.
  """

  @typedoc """
  A 128-bit long bitstring.
  """
  @type t :: <<_::128>>

  @spec new :: t
  defdelegate new, to: :uuid, as: :get_v4

  @doc """
      iex> Uuid.to_string(<<228, 245, 200, 3, 21, 195, 70, 196, 134, 180, 100, 102, 41, 33, 200, 13>>)
      "e4f5c803-15c3-46c4-86b4-64662921c80d"
  """
  @spec to_string(t) :: String.t()
  def to_string(uuid), do: Kernel.to_string(:uuid.uuid_to_string(uuid))

  @doc """
      iex> from_string("e4f5c803-15c3-46c4-86b4-64662921c80d")
      {:ok, <<228, 245, 200, 3, 21, 195, 70, 196, 134, 180, 100, 102, 41, 33, 200, 13>>}

      iex> from_string("e4f5c803-15c3-36c4-86b4-64662921c80d")
      {:error, :invalid_uuid_version}

      iex> from_string("this-is-not-a-valid-uuid")
      {:error, :invalid_argument}
  """
  @spec from_string(String.t()) :: {:ok, t} | {:error, :invalid_argument} | {:error, :invalid_uuid_version}
  def from_string(string) do
    try do
      uuid = :uuid.string_to_uuid(string)

      if :uuid.is_v4(uuid) do
        {:ok, uuid}
      else
        {:error, :invalid_uuid_version}
      end
    catch
      :exit, :badarg -> {:error, :invalid_argument}
    end
  end

  @doc """
      iex> from_string!("e4f5c803-15c3-46c4-86b4-64662921c80d")
      <<228, 245, 200, 3, 21, 195, 70, 196, 134, 180, 100, 102, 41, 33, 200, 13>>

      iex> from_string!("e4f5c803-15c3-36c4-86b4-64662921c80d")
      ** (ArgumentError) the provided UUID is not version 4

      iex> from_string!("this-is-not-a-valid-uuid")
      ** (ArgumentError) the argument must be a UTF encoded string representing a UUID
  """
  @spec from_string!(String.t()) :: t
  def from_string!(string) do
    case from_string(string) do
      {:ok, uuid} ->
        uuid

      {:error, :invalid_uuid_version} ->
        raise ArgumentError, "the provided UUID is not version 4"

      {:error, :invalid_argument} ->
        raise ArgumentError, "the argument must be a UTF encoded string representing a UUID"
    end
  end
end
