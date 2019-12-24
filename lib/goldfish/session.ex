defmodule Goldfish.Session do
  @moduledoc """
  This module represents the database model which stores user sessions.
  It is responsible for getting, updating, and deleting sessions.
  """

  use Ecto.Schema

  @timestamps_opts [type: :utc_datetime]

  @type t :: %__MODULE__{}

  schema "goldfish_sessions" do
    field(:data, :map)
    field(:cookie, :string)

    timestamps()
  end

  def get(cookie) do
    case repo().get_by(__MODULE__, cookie: cookie) do
      %__MODULE__{} = session -> session
      _no_session -> nil
    end
  end

  def create!(cookie, data) do
    repo().insert!(%__MODULE__{
      cookie: cookie,
      data: data
    })
  end

  def update!(cookie, data) do
    session = get(cookie)
    new_data = Map.merge(session.data, data)

    session
    |> Ecto.Changeset.change(data: new_data)
    |> repo().update!()
  end

  def delete!(cookie) do
    case repo().get_by(__MODULE__, cookie: cookie) do
      {:ok, %__MODULE__{} = session} -> repo().delete!(session)
      _error -> :error
    end
  end

  defp repo() do
    repo = Application.get_env(:goldfish, :repo)
    if is_nil(repo), do: raise("A repo must be configure for Goldfish")
    repo
  end
end
