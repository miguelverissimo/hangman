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
      assert ^game = Game.make_move(game, "x")
    end
  end

  test "first occurrence of letter is not already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurrence of letter is already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
    game = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("bazoooka")
    game = Game.make_move(game, "b")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a word is recognized" do
    moves = [
      {"b", :good_guess},
      {"a", :good_guess},
      {"z", :good_guess},
      {"o", :good_guess},
      {"k", :won}
    ]

    game = Game.new_game("bazoooka")

    Enum.reduce(moves, game, fn {guess, state}, game ->
      game = Game.make_move(game, guess)
      assert game.game_state == state
      assert game.turns_left == 7
      game
    end)
  end

  test "a bad guess is recognized" do
    game = Game.new_game("bazoooka")
    game = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "lost game is recognized" do
    moves = [
      {"x", :bad_guess, 6},
      {"y", :bad_guess, 5},
      {"a", :bad_guess, 4},
      {"b", :bad_guess, 3},
      {"i", :bad_guess, 2},
      {"n", :bad_guess, 1},
      {"k", :lost, 0}
    ]

    game = Game.new_game("foo")

    Enum.reduce(moves, game, fn {guess, state, turns_left}, game ->
      game = Game.make_move(game, guess)
      assert game.game_state == state
      assert game.turns_left == turns_left
      game
    end)
  end

  test "tally" do
    moves = [
      {"b", :good_guess, 7, ["b", "_", "_", "_", "_", "_", "_", "_"]},
      {"s", :bad_guess, 6, ["b", "_", "_", "_", "_", "_", "_", "_"]},
      {"a", :good_guess, 6, ["b", "a", "_", "_", "_", "_", "_", "a"]},
      {"a", :already_used, 6, ["b", "a", "_", "_", "_", "_", "_", "a"]},
      {"z", :good_guess, 6, ["b", "a", "z", "_", "_", "_", "_", "a"]},
      {"p", :bad_guess, 5, ["b", "a", "z", "_", "_", "_", "_", "a"]},
      {"t", :bad_guess, 4, ["b", "a", "z", "_", "_", "_", "_", "a"]},
      {"o", :good_guess, 4, ["b", "a", "z", "o", "o", "o", "_", "a"]},
      {"v", :bad_guess, 3, ["b", "a", "z", "o", "o", "o", "_", "a"]},
      {"q", :bad_guess, 2, ["b", "a", "z", "o", "o", "o", "_", "a"]},
      {"v", :already_used, 2, ["b", "a", "z", "o", "o", "o", "_", "a"]},
      {"k", :won, 2, ["b", "a", "z", "o", "o", "o", "k", "a"]}
    ]

    game = Game.new_game("bazoooka")

    Enum.reduce(moves, game, fn {guess, state, turns_left, letters}, game ->
      game = Game.make_move(game, guess)
      tally = Game.tally(game)
      assert tally.game_state == state
      assert tally.turns_left == turns_left
      assert tally.letters == letters
      game
    end)
  end
end
