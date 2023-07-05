defmodule Bank.Domain.ValueObjects.Money do
  @moduledoc """
      iex> new!(amount: 10, currency: :eur)
      %Money{amount: 10, currency: :eur}

      iex> new(amount: 10, currency: :eur)
      {:ok, %Money{amount: 10, currency: :eur}}
  """
  require Bank.Domain.Preconditions.Preconditions, as: Preconditions

  alias Bank.Domain.ValueObjects.Currency

  use TypedStruct
  use Domo

  @type amount :: integer
  precond amount: &Preconditions.is_non_negative_integer/1

  @type currency :: Currency.t()

  typedstruct enforce: true do
    field :amount, amount
    field :currency, currency
  end

  @doc """
      iex> sum(new!(amount: 10, currency: :eur), new!(amount: 10, currency: :eur))
      {:ok, %Money{amount: 20, currency: :eur}}

      iex> sum(new!(amount: 10, currency: :eur), new!(amount: 10, currency: :usd))
      {:error, :incompatible_currencies}
  """
  @spec sum(t, t) :: {:ok, t} | {:error, :incompatible_currencies} | no_return
  def sum(%__MODULE__{currency: currency} = left, %__MODULE__{currency: currency} = right),
    do: {:ok, %{left | amount: left.amount + right.amount}}

  def sum(%__MODULE__{currency: _left_currency}, %__MODULE__{currency: _right_currency}),
    do: {:error, :incompatible_currencies}

  @doc """
      iex> subtract(new!(amount: 10, currency: :eur), new!(amount: 10, currency: :eur))
      {:ok, %Money{amount: 0, currency: :eur}}

      iex> subtract(new!(amount: 10, currency: :eur), new!(amount: 20, currency: :eur))
      {:error, :insufficient_amount}

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
