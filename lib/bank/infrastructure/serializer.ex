defmodule Bank.Infrastructure.Serializer do
  @moduledoc false

  alias Bank.Aggregates.BankAccount.Events.BankAccountClosed
  alias Bank.Aggregates.BankAccount.Events.BankAccountOpened
  alias Commanded.Serialization.JsonDecoder

  defimpl Jason.Encoder, for: BankAccountOpened do
    def encode(%BankAccountOpened{} = event, opts),
      do: Jason.Encode.map(update_in(event.id, &Uuid.to_string/1), opts)
  end

  defimpl Jason.Encoder, for: BankAccountClosed do
    def encode(%BankAccountClosed{} = event, opts),
      do: Jason.Encode.map(update_in(event.id, &Uuid.to_string/1), opts)
  end

  defimpl JsonDecoder, for: BankAccountOpened do
    def decode(%BankAccountOpened{} = event),
      do: update_in(event.id, &Uuid.from_string!/1)
  end

  defimpl JsonDecoder, for: BankAccountClosed do
    def decode(%BankAccountClosed{} = event),
      do: update_in(event.id, &Uuid.from_string!/1)
  end
end
