require_relative 'hangman_save'

class Hangman
  def initialize
    @lives = 5
    @used_letters = []
    @board = []
    @correct_count = 0
    @used_letters = []
    @divider = '----------------------------------------'
  end

  def start
    introduction
    word_pick
    draw_board(@pc_word.length)
    puts @board.join('') + '  < This is your current board'
    round_prep
  end

  private

  def round_prep
    puts @divider
    puts 'Please enter your guess:'
    puts @divider
    @guess = gets.chomp.downcase
    valid?
    save?
    load?
    new_letter?
    round
    won?
    try_again
  end

  def word_pick
    valid_words = []
    File.foreach('../5desk.txt') do |word|
      valid_words.push word if (word.length >= 5) && (word.length <= 12)
    end
    @pc_word = valid_words[rand(0..valid_words.length)].downcase
    @pc_word = @pc_word.chomp.split('')
  end

  def valid?
    return unless @guess.length > 1

    puts @divider
    puts 'Invalid - Please try again.'
    puts @divider
    try_again
  end

  def try_again
    round_prep if lives_left? == true
  end

  def draw_board(int)
    @board = []
    int.times do
      @board.push '_'
    end
    @board.join('')
  end

  def round
    @used_letters.push @guess
    lives_lost unless @pc_word.include?(@guess)
    @pc_word.each_with_index do |letter, idx|
      if letter == @guess
        @board[idx] = @guess
        @correct_count += 1
      end
    end
    board_update(@correct_count)
  end

  def new_letter?
    return true unless @used_letters.include?(@guess)

    puts @divider
    puts 'Oops, you already guessed that letter. Please try again.'
    try_again
  end

  def lives_left?
    return true unless @lives.negative?

    game_over('loss')
  end

  def game_over(result)
    puts "GAME OVER - You died! The correct word was #{@pc_word.join('')}" if result == 'loss'
    puts "Congratulations! You guess the correct word with #{@lives} lives left." if result == 'win'
    exit
  end

  def won?
    game_over('win') unless @board.include?('_')
  end

  def board_update(count)
    if count.positive?
      puts @divider
      puts "Correct! There are #{count} #{@guess}'s."
      @correct_count = 0
    end
    puts @divider
    puts @board.join + '  < This is your current board'
  end

  def lives_lost
    puts @divider
    puts 'oof, that is incorrect!'
    @lives -= 1
    lives_left?
    puts "Total lives left: #{@lives}"
    puts 'Try another letter?'
    try_again
  end

  def save?
    if @guess == '1'
      puts @divider
      puts 'Please enter a name for your save file'
      puts @divider
      save_name = gets.chomp
      unique_file_name?(save_name)
      puts @divider
      puts "Game saved as '#{save_name}'"
      Save.new(save_name, @pc_word, @lives, @used_letters, @board)
      round_prep
    else
      false
    end
  end

  def load?
    return unless @guess == '2'

    begin
      puts @divider
      retrieve_files
      puts @divider
      user_save = gets.chomp
      save = File.read("../saves/#{user_save}.json")
    rescue StandardError
      puts @divider
      puts 'File not found. Going back to main menu.'
      round_prep
    end
    content = JSON.parse(save)
    load_save(content)
    puts "Game loaded! Here's a reminder of where you left off"
    puts "Current Board: #{@board.join}, Lives Left: #{@lives}, Used Letters: #{@used_letters}"
    round_prep
  end

  def retrieve_files
    saves = Dir.entries('../saves/')
    saves.each do |save_file|
      puts File.basename(save_file, '.json') unless save_file =~ /^..?$/
    end
    puts @divider
    puts 'Which one is the name of your save file?'
  end

  def unique_file_name?(save_name)
    @saves = Dir.entries('../saves/')
    @saves.each do |save|
      next unless save == save_name + '.json'

      puts 'File name already exists'
      puts 'Returning to game'
      puts round_prep
    end
  end

  def load_save(content)
    @pc_word = content['pc_word']
    @lives = content['lives']
    @used_letters = content['used_letters']
    @board = content['board']
  end

  def introduction
    puts @divider
    puts 'Welcome to my Hangman Game.'
    puts ''
    puts 'The rules are simple:'
    puts 'The PC will pick a secret word at random'
    puts 'Your job is to decipher what the secret word is by guessing each character one at a time.'
    puts 'If you guess incorrectly, you lose one of your 5 lives.'
    puts 'If you reveal the word without dying, you win!'
    puts 'Enter 1 at anytime to save your game, or press 2 to load a previously saved game'
    puts @divider
  end
end

player1 = Hangman.new

player1.start
