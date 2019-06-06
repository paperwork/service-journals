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

    @spec create(model :: __MODULE__.t) :: {:ok, %__MODULE__{}} | {:error, String.t}
    def create(%__MODULE__{} = model) do
        model
        |> collection_insert
        |> strip_privates
    end
end
