defmodule Hangman.GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "state does not change if game_sate is :won or :lost" do
    for state <- [:won, :lost] do
      game = %{Game.new_game() | game_state: state}
      assert {^game, _tally} = Game.make_move(game, "x")
    end
  end
end
