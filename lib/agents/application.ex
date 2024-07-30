defmodule Agents.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AgentsWeb.Telemetry,
      {Nx.Serving, serving: serving(), name: SentenceTransformer},
      {Nx.Serving, serving: cross(), name: CrossEncoder},
      Agents.Repo,
      {DNSCluster, query: Application.get_env(:agents, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Agents.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Agents.Finch},
      # Start a worker by calling: Agents.Worker.start_link(arg)
      # {Agents.Worker, arg},
      # Start to serve requests, typically the last entry
      AgentsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Agents.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AgentsWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def serving() do
    repo = "BAAI/bge-small-en-v1.5"
    {:ok, model_info} = Bumblebee.load_model({:hf, repo})
    {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, repo})

    Bumblebee.Text.TextEmbedding.text_embedding(model_info, tokenizer,
      output_pool: :mean_pooling,
      output_attribute: :hidden_state,
      embedding_processor: :l2_norm,
      compile: [batch_size: 32, sequence_length: [32]],
      defn_options: [compiler: EXLA]
    )
  end

  def cross() do
    repo = "cross-encoder/ms-marco-MiniLM-L-6-v2"
    {:ok, model_info} = Bumblebee.load_model({:hf, repo})
    {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, "google-bert/bert-base-uncased"})

    Agents.Encoder.cross_encoder(model_info, tokenizer,
      compile: [batch_size: 32, sequence_length: [512]],
      defn_options: [compiler: EXLA]
    )
  end
end
