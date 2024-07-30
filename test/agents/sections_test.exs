defmodule Agents.SectionsTest do
  use Agents.DataCase

  alias Agents.Sections

  describe "sections" do
    alias Agents.Sections.Section

    import Agents.SectionsFixtures

    @invalid_attrs %{chunk: nil, metadata: nil, embeddings: nil}

    test "list_sections/0 returns all sections" do
      section = section_fixture()
      assert Sections.list_sections() == [section]
    end

    test "get_section!/1 returns the section with given id" do
      section = section_fixture()
      assert Sections.get_section!(section.id) == section
    end

    test "create_section/1 with valid data creates a section" do
      valid_attrs = %{chunk: "some chunk", metadata: %{}, embeddings: "some embeddings"}

      assert {:ok, %Section{} = section} = Sections.create_section(valid_attrs)
      assert section.chunk == "some chunk"
      assert section.metadata == %{}
      assert section.embeddings == "some embeddings"
    end

    test "create_section/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sections.create_section(@invalid_attrs)
    end

    test "update_section/2 with valid data updates the section" do
      section = section_fixture()
      update_attrs = %{chunk: "some updated chunk", metadata: %{}, embeddings: "some updated embeddings"}

      assert {:ok, %Section{} = section} = Sections.update_section(section, update_attrs)
      assert section.chunk == "some updated chunk"
      assert section.metadata == %{}
      assert section.embeddings == "some updated embeddings"
    end

    test "update_section/2 with invalid data returns error changeset" do
      section = section_fixture()
      assert {:error, %Ecto.Changeset{}} = Sections.update_section(section, @invalid_attrs)
      assert section == Sections.get_section!(section.id)
    end

    test "delete_section/1 deletes the section" do
      section = section_fixture()
      assert {:ok, %Section{}} = Sections.delete_section(section)
      assert_raise Ecto.NoResultsError, fn -> Sections.get_section!(section.id) end
    end

    test "change_section/1 returns a section changeset" do
      section = section_fixture()
      assert %Ecto.Changeset{} = Sections.change_section(section)
    end
  end
end
