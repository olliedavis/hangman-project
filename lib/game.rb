class Hangman
  def initialize
    @lives = 5
    @used_letters = []
    @board = []
    @correct_count = 0
  end

  def start
    introduction
    word_pick
    draw_board(@pc_word.length)
    puts @board.join('')
    round_prep
  end

  def round_prep
    @guess = gets.chomp.downcase
    early_guess?
    valid?
    new_letter?
    round
  end

  def word_pick
    valid_words = []
    File.foreach('../5desk.txt') do |word|
      valid_words.push word if (word.length >= 5) && (word.length <= 12)
    end
    @pc_word = valid_words[rand(0..valid_words.length)].downcase
    @pc_word = @pc_word.split('')
    puts @pc_word
  end

  def valid?
    if @guess.length > 1 && @guess != 'answermode'
      puts 'Invalid - Please try again.'
      try_again
    end
  end

  def guess_mode
    puts "Early guess mode! What do you think the word is? If this was a mistake, please type 'EXIT EARLY MODE'"
    early_guess = gets.chomp.strip.downcase
    if early_guess != 'exit early mode'
      if early_guess == @pc_word.join('')
        game_over(@pc_word, 'win')
      else
        lives_lost
      end
    else
      puts 'Exiting early mode..'
      puts 'Please enter your next guess'
      try_again
    end
  end

  def try_again
    round_prep if lives_left? == true
  end

  def draw_board(int)
    @board = []
    (int - 1).times do
      @board.push '_'
    end
    @board.join('')
  end

  def introduction
    puts ''
    puts 'Welcome to my Hangman Game.'
    puts ''
    puts 'The rules are simple:'
    puts ''
    puts 'The PC will pick a secret word at random'
    puts 'Your job is to decipher what the secret word is by guessing each character one at a time.'
    puts 'If you guess incorrectly, you lose one of your 5 lives.'
    puts "If you know want to take a guess at the word, just type 'ANSWER MODE' to enter early answer guessing mode."
    puts 'If you reveal the word without dying, you win!'
    puts ''
    puts 'Please enter your first letter guess:'
  end

  def round
    @used_letters.push @guess
    if @pc_word.include?(@guess)
      @pc_word.each_with_index do |letter, idx|
        if letter == @guess
          @board[idx] = @guess
          @correct_count += 1
        end
      end
    else
      lives_lost
    end
    board_update(@correct_count)
    won?
    try_again
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
    if @lives < 0
      game_over('loss')
    else
      true
    end
  end

  def game_over(result)
    puts "GAME OVER - You died! The correct word was #{@pc_word.join("")}" if result == 'loss'
    puts "Congratulations! You guess the correct word with #{@lives} lives left." if result == 'win'
    exit
  end

  def early_guess?
    if @guess == 'answer mode'
      guess_mode
    end
  end

  def won?
    game_over('win') unless @board.include?('_')
  end

  def board_update(count)
    if count > 0
      puts "Correct! There are #{count} #{@guess}'s."
      @correct_count = 0
    end
    puts @board.join
  end

  def lives_lost
    puts "oof, that's incorrect!"
    @lives -= 1
    puts "Total lives left: #{@lives}"
    puts 'Please try again'
    try_again
  end
end

player1 = Hangman.new

player1.start
