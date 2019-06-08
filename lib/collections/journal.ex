require Logger

defmodule Paperwork.Collections.Journal do
    @collection "journals"
    @privates []
    @enforce_keys []
    @type t :: %__MODULE__{
        id: BSON.ObjectId.t() | nil,
        trigger: String.t(),
        trigger_id: BSON.ObjectId.t() | nil,
        trigger_system_id: String.t(),
        action: String.t(),
        resource: String.t(),
        resource_id: BSON.ObjectId.t() | nil,
        resource_system_id: String.t(),
        relevant_to: List.t(),
        content: Map.t()
    }
    defstruct \
        id: nil,
        trigger: "",
        trigger_id: nil,
        trigger_system_id: nil,
        action: "",
        resource: "",
        resource_id: nil,
        resource_system_id: nil,
        relevant_to: [],
        content: %{}

    use Paperwork.Collections

    @spec show(id :: BSON.ObjectId.t) :: {:ok, %__MODULE__{}} | {:notfound, nil}
    def show(%BSON.ObjectId{} = id) do
        show(%__MODULE__{:id => id})
    end

    @spec show(model :: __MODULE__.t) :: {:ok, %__MODULE__{}} | {:notfound, nil}
    def show(%__MODULE__{:id => _} = model) do
        collection_find(model, :id)
        |> strip_privates
    end

    @spec list() :: {:ok, [%__MODULE__{}]} | {:notfound, nil}
    def list() do
        %{}
        |> collection_find(true)
        |> strip_privates
    end

    @spec list(query :: Map.t) :: {:ok, [%__MODULE__{}]} | {:notfound, nil}
    def list(%{} = query) when is_map(query) do
        query
        |> collection_find(true)
        |> strip_privates
    end

    @spec create(model :: __MODULE__.t) :: {:ok, %__MODULE__{}} | {:error, String.t}
    def create(%__MODULE__{} = model) do
        model
        |> collection_insert
        |> strip_privates
    end

    def query_resource(%{} = query, resource) when is_binary(resource) do
        query
        |> Map.put(
            :resource,
            resource
        )
    end

    def query_resource(%{} = query, nil) do
        query
    end

    def query_relevant_to(%{} = query, %Paperwork.Id{} = relevant_to) do
        query
        |> Map.put(
            :relevant_to,
            %{
                id: relevant_to.id |> Paperwork.Id.maybe_id_to_objectid(),
                system_id: relevant_to.system_id |> Paperwork.Id.maybe_id_to_objectid()
            }
        )
    end

    def query_relevant_to(%{} = query, nil) do
        query
    end

    def query_newer_than_id(%{} = query, %Paperwork.Id{} = id) do
        query
        |> Map.put(
            :_id,
            %{
                "$gt": id |> Paperwork.Id.to_objectid(:id)
            }
        )
    end

    def query_newer_than_id(%{} = query, nil) do
        query
    end
end
