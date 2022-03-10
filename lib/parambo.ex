defmodule Parambo do
  @moduledoc """
  Documentation for `Parambo`.
  """

  import Ecto.Changeset

  alias Ecto.Changeset

  @spec new(Keyword.t(), map()) :: Changeset.t()
  def new(schema, params \\ %{}) do
    fields_with_types =
      for {field, [type | _options]} <- schema,
          into: %{},
          do: {field, type}

    required_fields =
      for {field, [_type | opts]} when is_list(opts) <- schema,
          opts[:required],
          do: field

    defaults =
      for {field, [_type | opts]} when is_list(opts) <- schema,
          into: %{},
          do: {field, opts[:default]}

    {defaults, fields_with_types}
    |> cast(params, Map.keys(fields_with_types))
    |> validate_required(required_fields)
  end

  @spec validate(Changeset.t()) :: {:ok, map()} | {:error, Changeset.t()}
  def validate(%Changeset{} = changeset) do
    case apply_action(changeset, :insert) do
      {:ok, params} -> {:ok, params}
      {:error, error} -> {:error, error}
    end
  end
end
