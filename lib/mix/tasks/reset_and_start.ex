defmodule Mix.Tasks.ResetAndStart do
  use Mix.Task

  @shortdoc "Resets the database and starts the Phoenix server"

  def run(_) do
    # Drop the database
    Mix.Task.run("ecto.drop")

    # Create the database
    Mix.Task.run("ecto.create")

    # Run migrations
    Mix.Task.run("ecto.migrate")

    # Start the Phoenix server
    Mix.Task.run("phx.server")
  end
end
