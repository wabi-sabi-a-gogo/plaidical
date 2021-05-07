defmodule Plaid.PaymentMeta do
  defstruct reference_number: nil,
            ppd_id: nil,
            payee: nil,
            by_order_of: nil,
            payer: nil,
            payment_method: nil,
            payment_processor: nil,
            reason: nil

  @type t :: %__MODULE__{
          reference_number: String.t(),
          ppd_id: String.t(),
          payee: String.t(),
          by_order_of: String.t(),
          payer: String.t(),
          payment_method: String.t(),
          payment_processor: String.t(),
          reason: String.t()
  }
end

