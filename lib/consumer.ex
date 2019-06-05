defmodule Paperwork.Journals.Consumer do
    require Logger

    def consume(payload, tag, was_redelivered) do
        Logger.debug("Consuming: #{inspect tag} #{inspect was_redelivered} #{inspect payload}")

        {:ok, tag}
        # {:error, tag}
        # {:retry, tag}
    end
end
