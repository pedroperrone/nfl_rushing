defmodule NflRushingWeb.PlayerLive.Index do
  use NflRushingWeb, :live_view

  alias NflRushing.Statistics
  alias Phoenix.LiveView.Socket

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, sorting_order: :asc, sorting_field: :name)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    page = parse_page(params)

    {:noreply,
     socket
     |> assign(:page, page)
     |> assign_players_page()}
  end

  @impl true
  def handle_event(
        "apply_sort",
        %{"sorting" => %{"sorting_order" => sorting_order, "sorting_field" => sorting_field}},
        socket
      ) do
    {:noreply,
     socket
     |> assign(
       sorting_order: cast_sorting_attribute(sorting_order),
       sorting_field: cast_sorting_attribute(sorting_field)
     )
     |> assign_players_page()}
  end

  defp parse_page(params) do
    page = Map.get(params, "page", "1")

    case Integer.parse(page) do
      {page, _} -> page
      :error -> 1
    end
  end

  defp assign_players_page(%Socket{assigns: assigns} = socket) do
    assign(
      socket,
      :players_page,
      Statistics.list_players(
        assigns.sorting_field,
        assigns.sorting_order,
        assigns.page,
        20
      )
    )
  end

  defp cast_sorting_attribute("name"), do: :name
  defp cast_sorting_attribute("total_rushing_yards"), do: :total_rushing_yards
  defp cast_sorting_attribute("longest_rush_yards"), do: :longest_rush_yards
  defp cast_sorting_attribute("rushing_touchdowns"), do: :rushing_touchdowns

  defp cast_sorting_attribute("desc"), do: :desc
  defp cast_sorting_attribute("asc"), do: :asc

  defp pagination_link(socket, label, page, active?) do
    live_patch(label,
      to: Routes.player_index_path(socket, :index, page: page),
      id: "page-#{label}",
      class: if(active?, do: "pagination active", else: "pagination")
    )
  end
end
