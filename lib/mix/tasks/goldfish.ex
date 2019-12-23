defmodule Mix.Tasks.Goldfish do
  use Mix.Task

  @migration "  def change do
    create table(\"goldfish_sessions\") do
      add :cookie, :string
      add :data, :map

      timestamps()
    end

    create index(\"goldfish_sessions\", [\"cookie\"])"

  def run(_) do
    [migration_filename] = Mix.Tasks.Ecto.Gen.Migration.run(["goldfish_sessions"])

    file_contents =
      migration_filename
      |> File.read!()
      |> String.replace("  def change do", @migration)

    File.write(migration_filename, file_contents)
  end
end
