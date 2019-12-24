defmodule Goldfish.Store do
  @moduledoc """
  This module implements the Plug.Session.Store behavior.
  """

  @behaviour Plug.Session.Store

  alias Goldfish.Session

  @impl true
  def init(opts) do
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

  defp get_for_session(_cookie, nil, _opts), do: {nil, %{}}

  defp get_for_session(cookie, session, opts) do
    now = DateTime.utc_now() |> DateTime.to_unix()
    expires_at = DateTime.to_unix(session.updated_at) + opts[:max_age]

    if now < expires_at do
      {cookie, session.data}
    else
      {nil, %{}}
    end
  end

  @impl true
  def put(conn, cookie, terms, opts) do
    if cookie == nil do
      new_cookie = :crypto.strong_rand_bytes(64) |> Base.encode64()

      Session.create!(new_cookie, terms)

      new_cookie
    else
      Session.update!(cookie, terms)

      cookie
    end
  end

  @impl true
  def delete(_conn, cookie, _opts) when cookie == "" when cookie == nil do
    :ok
  end

  def delete(_conn, cookie, _opts) do
    Session.delete!(cookie)
    :ok
  end
end
