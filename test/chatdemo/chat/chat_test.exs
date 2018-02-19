defmodule Chatdemo.ChatTest do
  use Chatdemo.DataCase

  alias Chatdemo.Chat

  describe "comments" do
    alias Chatdemo.Chat.Comment

    @valid_attrs %{text: "some text", username: "some username"}
    @update_attrs %{text: "some updated text", username: "some updated username"}
    @invalid_attrs %{text: nil, username: nil}

    def comment_fixture(attrs \\ %{}) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chat.create_comment()

      comment
    end

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Chat.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Chat.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = Chat.create_comment(@valid_attrs)
      assert comment.text == "some text"
      assert comment.username == "some username"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chat.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, comment} = Chat.update_comment(comment, @update_attrs)
      assert %Comment{} = comment
      assert comment.text == "some updated text"
      assert comment.username == "some updated username"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Chat.update_comment(comment, @invalid_attrs)
      assert comment == Chat.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Chat.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Chat.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Chat.change_comment(comment)
    end
  end
end
