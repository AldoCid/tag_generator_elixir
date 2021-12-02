defmodule Tagger do
  alias Git

  @moduledoc """
  Module that offers helper methods for tag.
  """

  @spec create_tag(%Git.Repository{}, String.t()) :: IO.puts()
  def create_tag(tag_name, repo) do
    IO.puts("Creating tag #{tag_name}...\n")

    case Git.tag(repo, tag_name) do
      {:ok, _} -> tag_name
      {:error, %{message: message}} -> IO.puts(message)
    end
  end

  def push_tag(tag_name, repo) do
    IO.puts("Pushing tag...\n")

    case Git.push(repo, ~w(origin #{tag_name})) do
      {:ok, _} -> tag_name
      {:error, %{message: message}} -> IO.puts(message)
    end
  end

  def fetch_repo(repo) do
    IO.puts("Fetching repository...\n")

    case Git.fetch(repo) do
      {:ok, _} -> :ok
      {:error, %{message: message}} -> IO.puts(message)
    end
  end

  def fetch_latest_tag(env, repo) do
    case Git.tag(repo) do
      {:ok, tags} ->
        do_fetch_latest_tag(tags, env)

      {:error, %{message: message}} ->
        IO.puts(message)
    end
  end

  @spec increment_env_tag(binary, binary) :: :ok
  def increment_env_tag(tag, environment) when environment in ["dev", "rc"] do
    tag_and_environment = String.split(tag, environment)

    incremented_tag =
      tag_and_environment
      |> Enum.count()
      |> case do
        1 ->
          Enum.at(tag_and_environment, 0) <> "-" <> environment <> "0"

        _ ->
          [version, env_number] = tag_and_environment
          next_env_number = String.to_integer(env_number) + 1
          version <> environment <> "#{next_env_number}"
      end

    incremented_tag
  end

  defp do_fetch_latest_tag(tags, "prod") do
    String.split(tags, "\n")
    |> Enum.filter(fn tag -> not String.contains?(tag, ["dev", "rc"]) end)
    |> Enum.max()
  end

  defp do_fetch_latest_tag(tags, env) do
    chunked_tags =
      tags
      |> String.split("\n")

    latest_version = get_max_version_semantic(chunked_tags)

    latest_version_with_envs =
      chunked_tags
      |> Enum.filter(fn tag -> String.contains?(tag, "#{latest_version}-#{env}") end)

    get_latest_env_tag(latest_version_with_envs, latest_version, env)
  end

  defp get_latest_env_tag(latest_env_versions, latest_version_semantic, env) do
    latest_env_versions
    |> Enum.count()
    |> case do
      0 ->
        "v" <> latest_version_semantic

      _ ->
        "v" <>
          latest_version_semantic <>
          "-" <> env <> "#{get_latest_env_number(latest_env_versions, env)}"
    end
  end

  defp get_latest_env_number(env_versions, env) do
    env_versions
    |> Enum.map(fn tag -> String.split(tag, env) |> Enum.at(1) |> String.to_integer() end)
    |> Enum.max()
  end

  defp get_max_version_semantic(tags) do
    tags
    |> Enum.filter(fn tag ->
      not String.contains?(tag, ["dev", "rc"]) and
        String.starts_with?(tag, "v")
    end)
    |> Enum.map(fn tag -> String.slice(tag, 1..-1) |> String.split(".") end)
    |> Enum.map(fn tag -> Enum.map(tag, fn n -> String.to_integer(n) end) end)
    |> Enum.max()
    |> Enum.join(".")
  end

  # defp increment_env_tag(tag, version_semantic) when tag == "prod" do
  #   next_semantic_number = calc_next_semantic(tag, version_semantic.index())
  #   Tagger.create_tag(@repo, next_semantic_number)
  # end

  # defp calc_next_semantic(tag, semantic_index) do
  #   tag_semantics =
  #     tag
  #     |> String.split("v")
  #     |> Enum.at(1)
  #     |> String.split(".")

  #   next_semantic =
  #     tag_semantics
  #     |> Enum.with_index()
  #     |> Enum.map(fn {element, index} ->
  #       case index == semantic_index do
  #         true -> String.to_integer(element) + 1
  #         false -> element
  #       end
  #     end)
  #     |> Enum.join(".")

  #   "v" <> next_semantic
  # end
end
