defmodule ChatdemoWeb.CommentController do
  use ChatdemoWeb, :controller

  alias Chatdemo.Chat
  alias Chatdemo.Chat.Comment

  def index(conn, _params) do
    comments = Chat.list_comments()
    render(conn, "index.html", comments: comments)
  end

  def new(conn, _params) do
    changeset = Chat.change_comment(%Comment{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"comment" => comment_params}) do
    case Chat.create_comment(comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: comment_path(conn, :show, comment))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Chat.get_comment!(id)
    render(conn, "show.html", comment: comment)
  end

  def edit(conn, %{"id" => id}) do
    comment = Chat.get_comment!(id)
    changeset = Chat.change_comment(comment)
    render(conn, "edit.html", comment: comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Chat.get_comment!(id)

    case Chat.update_comment(comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: comment_path(conn, :show, comment))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", comment: comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Chat.get_comment!(id)
    {:ok, _comment} = Chat.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: comment_path(conn, :index))
  end
end
