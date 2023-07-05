defmodule Bank.Domain.Preconditions.Preconditions do
  @moduledoc """
  This module contains precondition useful for the whole application.
  """

  @doc """
      iex> is_non_negative_integer(1)
      true

      iex> is_non_negative_integer(0)
      true

      iex> is_non_negative_integer(-1)
      false

      iex> is_non_negative_integer(1.0)
      false

      iex> is_non_negative_integer("1")
      false
  """
  defguard is_non_negative_integer(value) when is_integer(value) and value >= 0
end
