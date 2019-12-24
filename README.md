[![Hex.pm Version](http://img.shields.io/hexpm/v/goldfish.svg)](https://hex.pm/packages/goldfish)[![License badge](https://img.shields.io/hexpm/l/goldfish.svg)](https://github.com/arghmeleg/goldfish/blob/master/LICENSE)

# Goldfish

Goldfish is a database session store that implements the Plug.Session.Store behavior.

## Installation

1. Goldfish can be installed by adding `goldfish` to your list of dependencies in `mix.exs`:

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
