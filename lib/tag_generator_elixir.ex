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

  def create_tag(repo, version, environment) do
    Git.tag(@repo, "v{version}-environment")
  end
end
