defmodule Chatdemo.Chat.Comment do
  require IEx
  use Ecto.Schema
  import Ecto.Changeset
  alias Chatdemo.Chat.Comment

  @derive {Poison.Encoder, only: [:id, :text, :username]}

  schema "comments" do
    field :text, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:username, :text])
    |> validate_required([:username, :text])
  end


end
