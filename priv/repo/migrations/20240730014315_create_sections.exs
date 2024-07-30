defmodule Agents.Repo.Migrations.CreateSections do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS vector"

    create table(:sections) do
      add :embedding, :vector, size: 384

      add :chunk, :text
      add :metadata, :map

      timestamps(type: :utc_datetime)
    end

    create index("sections", ["embedding vector_cosine_ops"], using: :hnsw)
  end
end
