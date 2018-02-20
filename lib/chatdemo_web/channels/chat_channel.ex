defmodule ChatdemoWeb.ChatChannel do
   use Phoenix.Channel
   alias Chatdemo.Chat
   alias ChatdemoWeb.Presence
   require IEx
   def join("chat:lobby", _message, socket) do
    send(self(), :after_join)
    {:ok, %{comments: Chat.list_comments}, assign(socket,:user_id,Enum.random(1..1000))}
  end

  def join("chat:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_msg", %{"text" => text, "username"=> username}, socket) do
    case Chat.create_comment(%{text: text,username: username}) do
      {:ok, comment} ->
        broadcast! socket, "new_msg", %{comment: comment}
        {:noreply, socket}
      {:error, changeset} ->
        IO.inspect(changeset)
    end

  end

  def terminate(msg, socket) do
    Presence.untrack(socket, socket.assigns.user_id)
    broadcast_from socket, "presence_state", %{presence_list: Presence.list(socket)}
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    IO.inspect("++")
    IO.inspect(Presence.list(socket))
    IO.inspect("++")
    IO.inspect(socket.assigns.user_id)
    IO.inspect("++")
    {:ok, _socket} = Presence.track(socket, socket.assigns.user_id, %{
      online_at: inspect(System.system_time(:seconds))
    })
    broadcast socket, "presence_state", %{presence_list: Presence.list(socket)}
    {:noreply, socket}
  end

end
