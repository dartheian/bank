defmodule Bank.Aggregates.BankAccount.Lifespan do
  @moduledoc false

  @behaviour Commanded.Aggregates.AggregateLifespan

  alias Bank.Aggregates.BankAccount.Events.BankAccountClosed
  alias Bank.Commands.CloseBankAccount

  def after_event(%BankAccountClosed{}), do: :stop
  def after_event(_), do: :infinity

  def after_command(%CloseBankAccount{}), do: :stop
  def after_command(_), do: :infinity

  def after_error(_), do: :infinity
end
