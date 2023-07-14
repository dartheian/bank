defmodule Bank.Aggregates.BankAccount.Events.BankAccountOpened do
  @moduledoc false

  use Domo
  use TypedStruct

  typedstruct enforce: true do
    field :id, Uuid.t()
  end
end
