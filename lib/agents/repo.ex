defmodule Agents.Repo do
  use Ecto.Repo,
    otp_app: :agents,
    adapter: Ecto.Adapters.Postgres
end
