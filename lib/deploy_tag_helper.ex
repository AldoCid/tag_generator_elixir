defmodule DeployTagHelper do
  alias Tagger

  @repo %Git.Repository{
    path: "/Users/aldo.cid/Desktop/Sumuprojects/HackDayz/tag_generator_elixir"
  }

  @spec create_new_dev_tag :: :ok
  def create_new_dev_tag() do
    case Tagger.fetch_latest_tag(@repo, "dev") do
      tag -> increment_env_tag(tag, "dev")
    end
  end

  def create_new_stage_tag() do
    case Tagger.fetch_latest_tag(@repo, "rc") do
      tag -> increment_env_tag(tag, "rc")
    end
  end

  def increment_env_tag(tag, environment) do
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

    Tagger.create_tag(@repo, incremented_tag)
  end
end
