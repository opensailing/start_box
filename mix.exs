defmodule StartBox.MixProject do
  use Mix.Project

  @app :start_box
  @version "0.1.0"
  @all_targets [:rpi, :rpi0, :rpi2, :rpi3, :rpi3a, :rpi4, :bbb, :osd32mp1, :x86_64, :grisp2]

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {StartBox.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.10", runtime: false},
      {:shoehorn, "~> 0.9.1"},
      {:ring_logger, "~> 0.9.0"},
      {:toolshed, "~> 0.3.0"},
      {:circuits_gpio, "~> 1.1"},

      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.13.0", targets: @all_targets},
      {:nerves_pack, "~> 0.7.0", targets: @all_targets},
      {:ssh_subsystem_fwup, "~> 0.6"},
      {:oled, path: "../oled"},

      # Dependencies for specific targets
      # NOTE: It's generally low risk and recommended to follow minor version
      # bumps to Nerves systems. Since these include Linux kernel and Erlang
      # version updates, please review their release notes in case
      # changes to your application are needed.
      # {:nerves_system_rpi, "~> 1.19", runtime: false, targets: :rpi},
      {:nerves_system_rpi0, "~> 1.19", runtime: false, targets: :rpi0},
      {:nerves_system_rpi2, "~> 1.19", runtime: false, targets: :rpi2},
      # {:nerves_system_rpi3, "~> 1.19", runtime: false, targets: :rpi3},
      # {:nerves_system_rpi3a, "~> 1.19", runtime: false, targets: :rpi3a},
      # {:nerves_system_rpi4, "~> 1.19", runtime: false, targets: :rpi4},
      # {:nerves_system_bbb, "~> 2.14", runtime: false, targets: :bbb},
      # {:nerves_system_osd32mp1, "~> 0.10", runtime: false, targets: :osd32mp1},
      # {:nerves_system_x86_64, "~> 1.19", runtime: false, targets: :x86_64},
      # {:nerves_system_grisp2, "~> 0.3", runtime: false, targets: :grisp2}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  def release do
    [
      overwrite: true,
      # Erlang distribution is not started automatically.
      # See https://hexdocs.pm/nerves_pack/readme.html#erlang-distribution
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod or [keep: ["Docs"]]
    ]
  end
end
