defmodule GenTree.MixProject do
  use Mix.Project

  def project do
    [
      app: :gen_tree,
      version: "0.1.0",
      elixir: "~> 1.10",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  defp description do
    """
    Library for Tree data structure for BEAM in BEAM-way.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Dibyanshu Bhoi"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ghostdsb/gen_tree.git"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.18", only: :dev}
    ]
  end
end
