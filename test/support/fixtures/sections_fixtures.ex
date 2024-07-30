defmodule Agents.SectionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Agents.Sections` context.
  """

  @doc """
  Generate a section.
  """
  def section_fixture(attrs \\ %{}) do
    {:ok, section} =
      attrs
      |> Enum.into(%{
        chunk: "some chunk",
        embeddings: "some embeddings",
        metadata: %{}
      })
      |> Agents.Sections.create_section()

    section
  end
end
