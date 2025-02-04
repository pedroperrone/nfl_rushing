# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :nfl_rushing,
  ecto_repos: [NflRushing.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :nfl_rushing, NflRushingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9bb4Vm4Fw38JpnH4Qzs06AsNv438bC/vclS776Hund2f+pW08WI6DKG3v2lw8qKP",
  render_errors: [view: NflRushingWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: NflRushing.PubSub,
  live_view: [signing_salt: "O4NTAIyy"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
