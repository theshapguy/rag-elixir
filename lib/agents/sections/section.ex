defmodule Agents.Sections.Section do
  alias Agents.Repo
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  import Pgvector.Ecto.Query

  schema "sections" do
    field :chunk, :string
    field :metadata, :map
    field :embedding, Pgvector.Ecto.Vector

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(section, attrs) do
    section
    |> cast(attrs, [:embedding, :chunk, :metadata])
    |> validate_required([:embedding, :chunk])
  end

  def search_document_embedding(embedding) do
    from(s in __MODULE__,
      select: {s.id, s.chunk},
      # where: s.document_id == ^document_id,
      order_by: max_inner_product(s.embedding, ^embedding),
      limit: 20
    )
    |> Repo.all()
  end
end
