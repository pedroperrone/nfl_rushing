# NflRushing

This repository contains the implementation of an application that exhibits football data. It was built with the language Elixir and the framework Phoenix, along with the Phoenix LiveView library.

## Dependencies

To run the project and its tests, the following dependencies are required:
* Elixir 1.11
* Postgres 11+
* Node 12.3+

## Running the project

To run the project, first export the following environment variables regarding your database configuration:
* `DATABASE_USERNAME` - Defaults to `postgres`
* `DATABASE_PASSWORD` - Defaults to `postgres`
* `DATABASE_NAME` - Defaults to `nfl_rushing_dev` on `dev` environment and `nfl_rushing_test` for `test` environment
* `DATABASE_HOST` - Defaults to `localhost`

Then, navigate to the cloned repository and run the following commands:
```shell
mix deps.get
mix ecto.setup
mix phx.server
```

The command `mix ecto.setup` will automatically create the database, run the migrations and insert the data from the `rushing.json` file. If it is desired to separate the steps, `mix ecto.setup` can be replaced by
```shell
mix ecto.create
mix ecto.migrate
mix run priv/repo/seeds.exs
```

After the execution of `mix phx.server`, the application will be available on `localhost:4000`.

## Running unit tests

The library used to build unit tests was `ExUnit`. In assistance to it, `ExMachina` was used to build factories.

To run the tests, first export the database credentials and name and then use the command `mix test`.

## Static code analysis

Three tools were set in the project: `Credo`, which is focused on code consistency and refactor opportunities, `Dialyzer`, which is focused on identifying software discrepancies, such as definite type errors, code that has become dead or unreachable because of programming error, and Elixir's formatter, which checks for conventioned formatting. To run them, use the commands
```shell
mix credo
mix dialyzer
mix format --check-formatted
```

## CI

The repository uses CircleCI as a CI service. It runs the unit tests and the static code analysis.
