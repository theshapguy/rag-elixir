defmodule Agents.Hello do
  alias Agents.Sections

  # This code is in alpha stage

  # Sections are not attached to documents, so if you change the input document link
  # Make sure you remove all sections from the db so only correct chunks are stored

  # This is barebones code

  # Phoenix is use rather than a barebone Elixir App as I want to expand on the code
  # further, ålso allowing file uploads

  # Everything being run in is currently syncronous, need to use GenServer and Tasks to take
  # it into the background. This is for learning for syncronous code works better.
  def html_input() do
    # Or Read From File
    {:ok, response} = HTTPoison.get("https://gist.githubusercontent.com/theshapguy/d8633451460dac8a6cf6f0cf75a00f74/raw/a796d8af1452caa5d6857e67d40041a2ccaa3b14/RedditS1_RAG.txt")
    _contents = response.body
  end

  # Chunk Documents
  def chunk_document(content \\ html_input()) do
    TextChunker.split(content)
    |> Enum.map(& &1.text)
    |> Enum.map(&embed_chunks/1)
  end

  def embed_chunks(chunk) do
    %{embedding: embedding} =
      Nx.Serving.batched_run(SentenceTransformer, chunk |> String.trim())

    # Insert Embeddings Into database
    Sections.create_section(
      %{"chunk" => chunk |> String.trim(), "embedding" => embedding}
      )
  end

  def prompt(question) do
    # Query
    data =
      Nx.Serving.batched_run(SentenceTransformer, question)
      |> then(& &1.embedding)
      |> Agents.Sections.Section.search_document_embedding()
      |> Enum.take(10)

    # Cross Encoder Ranking
    context =
      Nx.Serving.batched_run(
        CrossEncoder,
        data |> Enum.map(fn {_id, text} -> {question, text} end)
      )
      |> then(& &1.results)
      |> Enum.zip(data)
      |> Enum.sort(fn x, y -> elem(x, 0) > elem(y, 0) end)
      |> Enum.take(3)
      |> Enum.map(fn {_score, {_id, chunk}} -> chunk end)
      |> Enum.join("\n")


    prompt = """
    [INST] <<SYS>>
    You are an assistant for question-answering tasks. Use the following pieces of retrieved context to answer the question.
    If you do not know the answer, just say that you don't know. Use two sentences maximum and keep the answer concise.
    <</SYS>>
    Question: #{question}
    Context: #{context}[/INST]
    """

    client = Ollama.init()

    Ollama.completion(client,
      model: "llama3.1",
      prompt: prompt
    )
  end

end
