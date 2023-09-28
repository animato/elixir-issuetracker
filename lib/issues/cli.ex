defmodule Issues.CLI do
  @default_count 4
  @moduledoc """
  명령줄 파싱을 수행한 뒤, 각종 함수를 호출해 깃허브 프로젝트의 최근 _n_개 이슈를 표 형식으로 만들어 출력한다.
  """
  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    OptionParser.parse(argv, switches: [ help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> args_to_internal_representation()
  end

  def args_to_internal_representation([ user, project, count ]) do
    { user, project, String.to_integer(count) }
  end

  def args_to_internal_representation([ user, project ]) do
    { user, project, @default_count }
  end

  def args_to_internal_representation(_) do
    :help
  end

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [ count | #{@default_count} ]
    """
    System.halt(0)
  end

  def process({ user, project, _count }) do
    Issues.GithubIssues.fetch(user, project)
  end
end
