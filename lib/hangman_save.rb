require 'json'

class Save
  def initialize(save_name, pc_word, lives, used_letters, board)
    @save_name = save_name
    @pc_word = pc_word
    @lives = lives
    @used_letters = used_letters
    @board = board
    save_game(@save_name)
  end

  def save_game(save_name)
    self_json = {
      pc_word: @pc_word,
      lives: @lives,
      used_letters: @used_letters,
      board: @board
    }.to_json
    open("../saves/#{save_name}.json", 'a') do |file|
      file.puts self_json
    end
  end
end




