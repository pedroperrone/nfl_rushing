defmodule NflRushingWeb.PlayerLive.Index do
  use NflRushingWeb, :live_view

  alias NflRushing.Statistics
  alias NflRushing.Statistics.Player
  alias NflRushingWeb.Params.PlayerFilter.{SortingField, SortingOrder}
  alias Phoenix.LiveView.Socket

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, sorting_order: :asc, sorting_field: :name, name_filter: nil)}
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
       sorting_order: cast_sorting_order(sorting_order),
       sorting_field: cast_sorting_field(sorting_field)
     )
     |> assign_players_page()}
  end

  def handle_event(
        "apply_name_filter",
        %{"name_filter" => %{"name_filter" => name_filter}},
        socket
      ) do
    {:noreply,
     socket
     |> assign(:name_filter, name_filter)
     |> push_patch(to: Routes.player_index_path(socket, :index, page: 1))}
  end

  @spec parse_page(map()) :: integer()
  defp parse_page(params) do
    page = Map.get(params, "page", "1")

    case Integer.parse(page) do
      {page, _} -> page
      :error -> 1
    end
  end

  @spec assign_players_page(Socket.t()) :: Socket.t()
  defp assign_players_page(%Socket{assigns: assigns} = socket) do
    assign(
      socket,
      :players_page,
      Statistics.list_players(
        assigns.sorting_field,
        assigns.sorting_order,
        assigns.page,
        20,
        assigns.name_filter
      )
    )
  end

  @spec cast_sorting_field(binary()) :: atom()
  def cast_sorting_field(sorting_field) do
    case SortingField.cast(sorting_field) do
      {:ok, sorting_field} -> sorting_field
      _ -> :name
    end
  end

  @spec cast_sorting_order(binary()) :: atom()
  def cast_sorting_order(sorting_order) do
    case SortingOrder.cast(sorting_order) do
      {:ok, sorting_order} -> sorting_order
      _ -> :asc
    end
  end

  @spec pagination_link(Socket.t(), binary() | integer(), integer(), boolean()) :: any()
  defp pagination_link(socket, label, page, active?) do
    live_patch(label,
      to: Routes.player_index_path(socket, :index, page: page),
      id: "page-#{label}",
      class: if(active?, do: "pagination active", else: "pagination")
    )
  end
end
