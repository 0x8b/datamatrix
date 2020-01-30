use Mix.Config

if Mix.env() != :prod do
  config :git_hooks,
    verbose: true,
    hooks: [
      pre_commit: [
        tasks: [
          "mix clean",
          "mix compile --warnings-as-errors",
          "mix xref deprecated --abort-if-any",
          "mix xref unreachable --abort-if-any",
          "mix format --check-formatted",
          "mix credo --strict",
          "mix doctor --summary",
          "mix test"
        ]
      ]
    ]
end
