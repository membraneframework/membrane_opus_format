defmodule Membrane.Opus.Format.Mixfile do
  use Mix.Project

  @version "0.3.1"
  @github_url "https://github.com/membraneframework/membrane_opus_format"

  def project do
    [
      app: :membrane_opus_format,
      version: @version,
      elixir: "~> 1.10",
      deps: deps(),
      dialyzer: dialyzer(),

      # hex
      description: "Membrane Multimedia Framework (Opus Audio Format Description)",
      package: package(),

      # docs
      name: "Membrane: Opus Format",
      source_url: @github_url,
      homepage_url: "https://membraneframework.org",
      docs: docs(),
      aliases: [docs: ["docs", &prepend_llms_links/1]]
    ]
  end

  def application do
    [
      extra_applications: []
    ]
  end

  defp deps do
    [
      {:credo, ">= 0.0.0", runtime: false},
      {:ex_doc, "~> 0.40", only: :dev, runtime: false},
      {:dialyxir, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp dialyzer() do
    opts = [
      flags: [:error_handling]
    ]

    if System.get_env("CI") == "true" do
      # Store PLTs in cacheable directory for CI
      File.mkdir_p!(Path.join([__DIR__, "priv", "plts"]))
      [plt_local_path: "priv/plts", plt_core_path: "priv/plts"] ++ opts
    else
      opts
    end
  end

  defp package do
    [
      maintainers: ["Membrane Team"],
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @github_url,
        "Membrane Framework Homepage" => "https://membraneframework.org"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md", "LICENSE"],
      source_ref: "v#{@version}",
      nest_modules_by_prefix: [Membrane.Opus]
    ]
  end

  defp prepend_llms_links(_) do
    output_dir = docs()[:output] || "doc"
    path = Path.join(output_dir, "llms.txt")

    if File.exists?(path) do
      existing = File.read!(path)

      footer = """


      ## See Also

      - [Membrane Framework AI Skill](https://hexdocs.pm/membrane_core/skill.md)
      - [Membrane Core](https://hexdocs.pm/membrane_core/llms.txt)
      """

      File.write!(path, String.trim_trailing(existing) <> footer)
    else
      IO.warn("#{path} not found — llms.txt was not generated, check your ex_doc configuration")
    end
  end
end
