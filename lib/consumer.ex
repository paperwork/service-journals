defmodule Paperwork.Journals.Consumer do
    require Logger

    def consume(payload, tag, was_redelivered) do
        Logger.debug("Consuming: #{inspect tag} #{inspect was_redelivered}")

        new_journal_entry =
            Jason.decode!(payload)

        {:ok, _} =
            %Paperwork.Collections.Journal{
                trigger: new_journal_entry["trigger"]
                    |> Paperwork.Helpers.Journal.validate_trigger!(),
                trigger_id: new_journal_entry["trigger_id"]
                    |> Paperwork.Helpers.Journal.validate_trigger_id!()
                    |> Paperwork.Id.maybe_id_to_objectid(),
                trigger_system_id: new_journal_entry["trigger_system_id"]
                    |> Paperwork.Helpers.Journal.validate_trigger_system_id!()
                    |> Paperwork.Id.maybe_id_to_objectid(),
                action: new_journal_entry["action"]
                    |> Paperwork.Helpers.Journal.validate_action!(),
                resource: new_journal_entry["resource"]
                    |> Paperwork.Helpers.Journal.validate_resource!(),
                resource_id: new_journal_entry["resource_id"]
                    |> Paperwork.Helpers.Journal.validate_resource_id!()
                    |> Paperwork.Id.maybe_id_to_objectid(),
                resource_system_id: new_journal_entry["resource_system_id"]
                    |> Paperwork.Helpers.Journal.validate_resource_system_id!()
                    |> Paperwork.Id.maybe_id_to_objectid(),
                relevant_to: new_journal_entry["relevant_to"]
                    |> Paperwork.Helpers.Journal.validate_relevant_to!()
                    |> Enum.map(fn relevance_entry ->
                            %{
                                id: relevance_entry["id"]
                                    |> Paperwork.Id.maybe_id_to_objectid(),
                                system_id: relevance_entry["system_id"]
                                    |> Paperwork.Id.maybe_id_to_objectid()
                            }
                        end),
                content: new_journal_entry["content"]
                    |> Paperwork.Helpers.Journal.validate_content!()
            }
            |> Paperwork.Collections.Journal.create()

        {:ok, tag}
    rescue
        exception ->
            Logger.error("#{inspect exception}")
            case was_redelivered do
                true -> {:error, tag}
                false -> {:retry, tag}
            end
    end
end
