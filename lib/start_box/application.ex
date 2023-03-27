defmodule StartBox.Application do
  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      {StartBox.Printer, name: StartBox.Printer},
      {StartBox.Button, name: StartBox.Button},
      {StartBox.Timer, name: StartBox.Timer},
      {StartBox.Signal.Sound, name: StartBox.Signal.Sound},
      {StartBox.Signal.Visual, name: StartBox.Signal.Visual},
      {StartBox.Racer, name: StartBox.Racer}
    ]

    opts = [strategy: :one_for_all, name: StartBox.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
