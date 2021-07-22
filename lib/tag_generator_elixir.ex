defmodule TagGeneratorElixir do
  alias Git

  @moduledoc """
  Documentation for TagGeneratorElixir.
  """

  @repo %Git.Repository{
    path: "/Users/aldo.cid/Desktop/Sumuprojects/HackDayz/tag_generator_elixir"
  }

  def config() do
    # Git.re
  end

  @spec create_tag(%Git.Repository{}, String.t(), String.t()) :: IO.puts()
  def create_tag(repo, version, environment_number) do
    new_tag = "v#{version}-#{environment_number}"
    IO.puts("Creating tag #{new_tag}...\n")

    case Git.tag(repo, new_tag) do
      {:ok, _} -> IO.puts("Tag #{new_tag} created with success!")
      {:error, %Git.Error{message: message}} -> IO.puts(message)
    end
  end
end
