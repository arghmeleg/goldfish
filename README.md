# Goldfish

**TODO: Add description**

## Installation

1. If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `goldfish` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:goldfish, "~> 0.1.0"}
  ]
end
```
2. Edit your endpoint file (for example `lib/my_app_web/endpoint.ex`) and change `store` to use `Goldfish.Store`

```elixir
plug Plug.Session,
  store: Goldfish.Store,
  key: "_my_app_key"
```

3. Configure Goldfish (for example in `config/config.exs`) to use your repo of choice to store your user sessions

```elixir
config :goldfish,
  repo: MyApp.Repo
```

4. Generate the migration to create your session table and migrate your databse


```bash
mix goldfish
```

You should see this output
```bash
* creating priv/repo/migrations/20191224004432_goldfish_sessions.exs
```

Then migrate your database to create the table
```bash
mix ecto.migrate
```

That's it! You're ready to start using Goldfish to store your user sessions.

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/goldfish](https://hexdocs.pm/goldfish).