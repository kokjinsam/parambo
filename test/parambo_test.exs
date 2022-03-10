defmodule ParamboTest do
  @moduledoc false

  use ExUnit.Case

  import Ecto.Changeset

  alias Ecto.Changeset

  describe "new/2" do
    test "returns a changeset" do
      params = [
        name: [:string, required: true],
        age: [:integer],
        fav_animal: [:string, default: "cat"]
      ]

      input = %{
        name: "John Smith"
      }

      assert %Changeset{} = Parambo.new(params, input)
    end
  end

  describe "validate/1" do
    test "return {:ok, data} if changeset is valid." do
      params = [
        name: [:string, required: true],
        age: [:integer],
        fav_animal: [:string, default: "cat"]
      ]

      input = %{
        name: "John Smith"
      }

      assert {:ok, data} =
               Parambo.new(params, input)
               |> Parambo.validate()

      assert data.name == "John Smith"
      assert is_nil(data.age)
      assert data.fav_animal == "cat"
    end

    test "throws {:error, changeset} if changeset is invalid." do
      params = [
        name: [:string, required: true],
        age: [:integer],
        fav_animal: [:string, default: "cat"]
      ]

      input = %{}

      assert {:error, %Changeset{} = changeset} =
               Parambo.new(params, input)
               |> Parambo.validate()

      errors =
        traverse_errors(changeset, fn {msg, opts} ->
          Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
            opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
          end)
        end)

      assert Enum.member?(errors.name, "can't be blank")
    end
  end
end
