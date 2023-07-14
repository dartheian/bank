defmodule Bank.Domain.ValueObjects.Money do
  @moduledoc """
  This module contains definitions useful for working with money.

  ## Examples

      iex> new!(amount: 10, currency: :eur)
      %Money{amount: 10, currency: :eur}

      iex> new(amount: 10, currency: :eur)
      {:ok, %Money{amount: 10, currency: :eur}}

      iex> new!(amount: 10, currency: :eur)
      ...> |> sum(new!(amount: 5, currency: :eur))
      {:ok, %Money{amount: 15, currency: :eur}}

      iex> new!(amount: 10, currency: :eur)
      ...> |> subtract(new!(amount: 5, currency: :eur))
      {:ok, %Money{amount: 5, currency: :eur}}
  """

  alias Bank.Domain.ValueObjects.Currency

  use TypedStruct
  use Domo

  @type amount :: pos_integer()
  @type currency :: Currency.t()

  typedstruct enforce: true do
    field :amount, amount
    field :currency, currency
  end

  @doc """
  ## Examples

  Sum money of the same currency:

      iex> sum(new!(amount: 10, currency: :eur), new!(amount: 10, currency: :eur))
      {:ok, %Money{amount: 20, currency: :eur}}

  Raises an error if the currencies are different:

      iex> sum(new!(amount: 10, currency: :eur), new!(amount: 10, currency: :usd))
      {:error, :incompatible_currencies}
  """
  @spec sum(t, t) :: {:ok, t} | {:error, :incompatible_currencies} | no_return
  def sum(%__MODULE__{currency: currency} = left, %__MODULE__{currency: currency} = right),
    do: {:ok, %{left | amount: left.amount + right.amount}}

  def sum(%__MODULE__{currency: _left_currency}, %__MODULE__{currency: _right_currency}),
    do: {:error, :incompatible_currencies}

  @doc """
  ## Examples

      iex> subtract(new!(amount: 10, currency: :eur), new!(amount: 10, currency: :eur))
      {:ok, %Money{amount: 0, currency: :eur}}

  Raises an error if there is not enough money:

      iex> subtract(new!(amount: 10, currency: :eur), new!(amount: 20, currency: :eur))
      {:error, :insufficient_amount}

  Raises an error if the currencies are different:

      iex> subtract(new!(amount: 10, currency: :eur), new!(amount: 10, currency: :usd))
      {:error, :incompatible_currencies}
  """
  @spec subtract(t, t) :: {:ok, t} | {:error, any}
  def subtract(%__MODULE__{currency: currency} = left, %__MODULE__{currency: currency} = right)
      when left.amount >= right.amount,
      do: {:ok, %{left | amount: left.amount - right.amount}}

  def subtract(%__MODULE__{currency: currency} = left, %__MODULE__{currency: currency} = right)
      when left.amount < right.amount,
      do: {:error, :insufficient_amount}

  def subtract(%__MODULE__{currency: _left_currency}, %__MODULE__{currency: _right_currency}),
    do: {:error, :incompatible_currencies}
end
