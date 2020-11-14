with {:error, error} <- NflRushing.Statistics.insert_players_from_file("rushing.json") do
  IO.inspect(error)
end
