defmodule Hangman.Game do
  alias Hangman.Game

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: []
  )

  def new_game() do
    %Game{
      letters:
        Dictionary.get_random_word()
        |> String.codepoints()
    }
  end

  def make_move(game = %Game{game_state: state}, _guess) when state in [:won, :lost] do
    {game, tally(game)}
  end

  def tally(%Game{} = game), do: 123
end
