# Agents


To start a embedding process on a new document after the link or reader has been changed run

```
mix reset_and_start
```

To prompt on the same document & embedding, just run

```
iex -S mix

# To start the embedding process (this is syncronous)
Agents.Hello.chunk_document()

# After the above is done prompting can be done
Agents.Hello.prompt("what are the risks of reddit?")

# Make sure to run the chuck document step otherwise you'll get an error

# Everything related to this project is located at
# lib/agents/hello.ex
# chunking, embedding, querying, prompting

# Using this phoenix project so that I can expand on this later
```




To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
