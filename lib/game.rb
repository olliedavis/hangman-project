require_relative 'hangman_save'

class Hangman
  def initialize
    @lives = 5
    @used_letters = []
    @board = []
    @correct_count = 0
    @used_letters = []
  end

  def start
    introduction
    word_pick
    draw_board(@pc_word.length)
    puts @board.join('')
    round_prep
  end

  private

  def round_prep
    puts 'Please enter your guess:'
    @guess = gets.chomp.downcase
    valid?
    save?
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
    if @guess.length > 1
      puts 'Invalid - Please try again.'
      try_again
    end
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

  def introduction
    puts 'Welcome to my Hangman Game.'
    puts ''
    puts 'The rules are simple:'
    puts 'The PC will pick a secret word at random'
    puts 'Your job is to decipher what the secret word is by guessing each character one at a time.'
    puts 'If you guess incorrectly, you lose one of your 5 lives.'
    puts 'If you reveal the word without dying, you win!'
    puts ''
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
    if @used_letters.include?(@guess)
      puts 'Oops, you already guessed that letter. Please try again.'
      try_again
    else
      true
    end
  end

  def lives_left?
    if @lives.negative?
      game_over('loss')
      exit
    else
      true
    end
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
      puts "Correct! There are #{count} #{@guess}'s."
      @correct_count = 0
    end
    puts @board.join
  end

  def lives_lost
    puts 'oof, that is incorrect!'
    puts ''
    @lives -= 1
    puts "Total lives left: #{@lives}"
    puts ''
    puts 'Try another letter?'
    try_again
  end

  def save?
    if @guess == '1'
      puts 'Please enter a name for your save file'
      save_name = gets.chomp
      puts "Game saved as '#{save_name}'"
      Save.new(save_name, @pc_word, @lives, @used_letters, @board)
      round_prep
    else
      false
    end
  end
end

player1 = Hangman.new

player1.start
