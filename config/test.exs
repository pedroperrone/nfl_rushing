use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :nfl_rushing, NflRushing.Repo,
  username: System.get_env("DATABASE_USERNAME", "postgres"),
  password: System.get_env("DATABASE_PASSWORD", "postgres"),
  database:
    "#{System.get_env("DATABASE_NAME", "nfl_rushing_test")}#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: System.get_env("DATABASE_HOST", "localhost"),
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :nfl_rushing, NflRushingWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
