defmodule Goldfish.Store do
  # @moduledoc """
  # Stores the session in a Mnesia table.
  # The store itself does not create the Mnesia table. It expects an existing
  # table to be passed as an argument. You can create it yourself following the
  # *Storage* section or use the helpers provided with this application (see
  # `PlugSessionMnesia` for more information).
  # Since this store uses Mnesia, the session can persist upon restarts and be
  # shared between nodes, depending on your configuration.
  # ## Options
  #   * `:table` - Mnesia table name (required if not set in the application
  #     environment).
  # ## Example
  #     # If you want to create the Mnesia table yourself
  #     :mnesia.create_schema([node()])
  #     :mnesia.create_table(:session, [attributes: [:sid, :data, :timestamp], disc_copies: [node()]])
  #     :mnesia.add_table_index(:session, :timestamp)
  #     plug Plug.Session,
  #       key: "_app_key",
  #       store: PlugSessionMnesia.Store,
  #       table: :session   # This table must exist.
  # ## Storage
  # The data is stored in Mnesia in the following format, where `timestamp` is the
  # OS UNIX time in the `:native` unit:
  #     {sid :: String.t(), data :: map(), timestamp :: integer()}
  # The timestamp is updated on access to the session and is used by
  # `PlugSessionMnesia.Cleaner` to check if the session is still active. If you
  # want to delete a session on a fixed amount of time after its creation,
  # regardless its activity, you can disable the timestamp update by configuring
  # the application:
  #     config :plug_session_mnesia, timestamp: :fixed
  # """

  @behaviour Plug.Session.Store

  alias Goldfish.Session

  # alias PlugSessionMnesia.TableNotDefined
  # alias PlugSessionMnesia.TableNotExists

  # @max_tries 500

  @impl true
  def init(opts) do
    IO.puts("_________________________")
    IO.inspect(opts)
    IO.puts("_________________________")
    #  with :error <- Keyword.fetch(opts, :table),
    #       :error <- Application.fetch_env(:plug_session_mnesia, :table) do
    #    raise TableNotDefined
    #  else
    #    {:ok, table} -> table
    #  end
    max_age = Keyword.get(opts, :max_age, 3600)

    %{max_age: max_age}
  end

  @impl true
  def get(_conn, cookie, _opts) when cookie == "" when cookie == nil do
    {nil, %{}}
  end

  def get(_conn, cookie, opts) do
    session = Session.get(cookie) |> IO.inspect()
    get_for_session(cookie, session, opts)
  end

  # def get(_conn, cookie, opts) do
  #   session = Session.get(cookie)
  #   get_for_session(cookie, session, opts)
  # end

  defp get_for_session(_cookie, nil, _opts), do: {nil, %{}}

  defp get_for_session(cookie, session, opts) do
    now = DateTime.utc_now() |> DateTime.to_unix()
    expires_at = DateTime.to_unix(session.updated_at) + opts[:max_age]

    IO.puts("tttttttttttttttttttttt")
    IO.inspect(now)
    IO.inspect(expires_at)
    IO.inspect(now < expires_at)
    IO.puts("tttttttttttttttttttttt")

    if now < expires_at do
      IO.puts("|||||||||||||||||| RETURNING DATA!")
      {cookie, session.data}
    else
      {nil, %{}}
    end
  end

  # def get(_conn, sid, table) do
  #   case lookup_session!(table, sid) do
  #     [{^table, ^sid, data, _timestamp}] ->
  #       unless Application.get_env(:plug_session_mnesia, :timestamp) == :fixed,
  #         do: put_session!(table, sid, data, System.os_time())
  #
  #       {sid, data}
  #
  #     _ ->
  #       {nil, %{}}
  #   end
  # end

  @impl true
  def put(conn, cookie, terms, opts) do
    IO.puts("-----------------------------")
    IO.inspect(opts)
    IO.puts("-----------------------------")

    IO.inspect(terms)
    IO.puts("-----------------------------")

    IO.inspect(cookie)
    IO.puts("-----------------------------")

    # user_id = term["user_id"]

    if cookie == nil do
      # %{max_age: max_age} = opts

      # valid_from = DateTime.utc_now()
      # valid_to = DateTime.from_unix!(DateTime.to_unix(valid_from) + max_age)

      new_cookie = :crypto.strong_rand_bytes(64) |> Base.encode64()

      # Session.create!(%{
      #   session_cookie: new_cookie,
      #   valid_from: valid_from,
      #   valid_to: valid_to,
      #   user_id: user_id
      # })
      Session.create!(new_cookie, terms)

      IO.puts("new cook: #{new_cookie}")

      new_cookie
    else
      Session.update!(cookie, terms)

      cookie
    end
  end

  # def put(_conn, nil, data, table), do: put_new(table, data)

  # def put(_conn, sid, data, table) do
  #   timestamp =
  #     if Application.get_env(:plug_session_mnesia, :timestamp) == :fixed,
  #       do: table |> lookup_session!(sid) |> Enum.at(0) |> elem(3),
  #       else: System.os_time()

  #   put_session!(table, sid, data, timestamp)
  #   sid
  # end

  @impl true
  # def delete(_conn, sid, table) do
  #   t = fn ->
  #     :mnesia.delete({table, sid})
  #   end

  #   case :mnesia.transaction(t) do
  #     {:atomic, :ok} -> :ok
  #     {:aborted, {:no_exists, _}} -> raise TableNotExists
  #   end
  # end
  def delete(_conn, cookie, _opts) when cookie == "" when cookie == nil do
    :ok
  end

  def delete(_conn, cookie, _opts) do
    Session.delete!(cookie)
    :ok
  end

  # @spec lookup_session!(atom(), String.t()) :: [
  #         {atom(), String.t(), map(), integer()}
  #       ]

  # defp lookup_session!(table, sid) do
  #   t = fn ->
  #     :mnesia.read({table, sid})
  #   end

  #   case :mnesia.transaction(t) do
  #     {:atomic, session} -> session
  #     {:aborted, {:no_exists, _}} -> raise TableNotExists
  #   end
  # end

  # @spec put_session!(atom(), String.t(), map(), integer()) :: nil
  # defp put_session!(table, sid, data, timestamp) do
  #   t = fn ->
  #     :mnesia.write({table, sid, data, timestamp})
  #   end

  #   case :mnesia.transaction(t) do
  #     {:atomic, :ok} -> nil
  #     {:aborted, {:no_exists, _}} -> raise TableNotExists
  #   end
  # end

  # @spec put_new(atom(), map()) :: String.t()
  # @spec put_new(atom(), map(), non_neg_integer()) :: String.t()
  # defp put_new(table, data, counter \\ 0) when counter < @max_tries do
  #   sid = Base.encode64(:crypto.strong_rand_bytes(96))

  #   if lookup_session!(table, sid) == [] do
  #     put_session!(table, sid, data, System.os_time())
  #     sid
  #   else
  #     put_new(table, data, counter + 1)
  #   end
  # end
end
