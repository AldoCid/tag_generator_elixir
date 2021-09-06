defmodule Tagger do
  alias Git

  @moduledoc """
  Module that offers helper methods for tag.
  """

  @spec create_tag(%Git.Repository{}, String.t()) :: IO.puts()
  def create_tag(repo, name) do
    IO.puts("Creating tag #{name}...\n")

    case Git.tag(repo, name) do
      {:ok, _} -> IO.puts("Tag #{name} created with success!")
      {:error, %{message: message}} -> IO.puts(message)
    end
  end

  def push_tag(repo, tag_name) do
    case Git.push(repo, ~w(origin #{tag_name})) do
      {:ok, _} -> IO.puts("Pushed #{tag_name} with success!")
      {:error, %{message: message}} -> IO.puts(message)
    end
  end

  def fetch_latest_tag(repo, env) do
    case Git.tag(repo) do
      {:ok, tags} ->
        do_fetch_latest_tag(tags, env)

      {:error, %{message: message}} ->
        IO.puts(message)
    end
  end

  def fetch_latest_tag(repo) do
    case Git.tag(repo) do
      {:ok, tags} ->
        do_fetch_latest_tag(tags)

      {:error, %{message: message}} ->
        IO.puts(message)
    end
  end

  defp do_fetch_latest_tag(tags, env) do
    chunked_tags =
      tags
      |> String.split("\n")

    latest_version =
      chunked_tags
      |> Enum.filter(fn tag -> not String.contains?(tag, ["dev", "rc"]) end)
      |> Enum.max()

    env_versions =
      chunked_tags
      |> Enum.filter(fn tag -> String.contains?(tag, "#{latest_version}-#{env}") end)

    env_versions
    |> Enum.count()
    |> case do
      0 ->
        latest_version

      _ ->
        latest_version <> "-" <> env <> "#{get_latest_env_version(env_versions, env)}"
    end
  end

  defp do_fetch_latest_tag(tags) do
    String.split(tags, "\n")
    |> Enum.filter(fn tag -> not String.contains?(tag, ["dev", "rc"]) end)
    |> Enum.max()
  end

  defp get_latest_env_version(env_versions, env) do
    env_versions
    |> Enum.map(fn tag -> String.split(tag, env) |> Enum.at(1) |> String.to_integer() end)
    |> Enum.max()
  end
end
