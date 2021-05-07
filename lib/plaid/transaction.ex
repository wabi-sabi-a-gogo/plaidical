defmodule Plaid.Transaction do
  @derive Jason.Encoder
  defstruct account_id: nil,
            amount: nil,
            iso_currency_code: nil,
            unofficial_currency_code: nil,
            category: nil,
            category_id: nil,
            date: nil,
            datetime: nil,
            authorized_date: nil,
            authorized_datetime: nil,
            location: nil,
            name: nil,
            merchant_name: nil,
            payment_meta: nil,
            payment_channel: nil,
            pending: nil,
            pending_transaction_id: nil,
            account_owner: nil,
            transaction_id: nil,
            transaction_code: nil,
            transaction_type: nil

  @type t :: %__MODULE__{
          account_id: String.t(),
          amount: Decimal.t(),
          iso_currency_code: String.t(),
          unofficial_currency_code: String.t(),
          category: [String.t()],
          category_id: String.t(),
          date: String.t(),
          datetime: String.t(),
          authorized_date: String.t(),
          authorized_datetime: String.t(),
          location: Plaid.Location.t(),
          name: String.t(),
          merchant_name: String.t(),
          payment_meta: Plaid.PaymentMeta.t(),
          payment_channel: String.t(),
          pending: Boolean.t(),
          pending_transaction_id: String.t(),
          account_owner: String.t(),
          transaction_id: String.t(),
          transaction_code: String.t(),
          transaction_type: String.t()
  }
end

