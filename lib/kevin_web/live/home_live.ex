defmodule KevinWeb.HomeLive do
  use KevinWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket), do: tick()
    socket = assign(socket, id: "kevin", percentage: 9.34)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="container text-center">
      <.percentage_component id="kevin" percentage={@percentage} />
    </div>
    """
  end

  def percentage_component(assigns) do
    ~H"""
    <div>
      <h1 class="text-9xl">No.</h1>
      <p>He is: <%= @percentage %>% of an engineer.</p>
      <p class="mt-12 text-slate-400">
        iskevinareal.dev is tuned into the specific brainwaves and thought patterns of Kevin and updates in real time in accordance to what he is thinking at that given moment.
      </p>
    </div>
    """
  end

  defp calculate_percentage do
    (:rand.uniform() * 10) |> Float.round(2)
  end

  def handle_info({:update_percentage, new_percentage}, socket) do
    tick()
    socket = assign(socket, percentage: new_percentage)
    {:noreply, socket}
  end

  defp tick do
    timeout = :rand.uniform(4000)
    Process.send_after(self(), {:update_percentage, calculate_percentage()}, timeout)
  end
end
