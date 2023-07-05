defmodule Bank.Domain.Aggregates.BankAccount do
  @moduledoc false

  use TypedStruct
  use Domo, gen_constructor_name: :_new

  alias Bank.Domain.ValueObjects.Money

  typedstruct enforce: true do
    field :id, Uniq.UUID.t()
    field :balances, %{optional(Money.currency()) => Money.amount()}
  end

  def new, do: _new(id: Uniq.UUID.uuid4(:raw), balances: %{})
  def new!, do: _new!(id: Uniq.UUID.uuid4(:raw), balances: %{})

  @spec deposit!(t, Money.t()) :: t | no_return()
  def deposit!(%__MODULE__{} = account, %Money{} = money) do
    update_in(account.balances[money.currency], fn
      nil -> money.amount
      amount -> amount + money.amount
    end)
  end

  @spec withdraw(t, Money.t()) :: t | {:error, :unavailable_currency} | {:error, :insufficient_balance}
  def withdraw(%__MODULE__{} = account, %Money{} = money) do
    case account.balances[money.currency] do
      nil -> {:error, :unavailable_currency}
      amount when amount < money.amount -> {:error, :insufficient_balance}
      _ -> {:ok, update_in(account.balances[money.currency], &(&1 - money.amount))}
    end
  end
end
