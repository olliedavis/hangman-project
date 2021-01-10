class Hangman
  def initialize
    @lives = 5
    @used_letters = Array.new
    @board = Array.new
    
  end
  def self.start
    introduction
    word_pick
    draw_board(@pc_word.length)
    puts @board.join("")
    round_prep
  end

  def self.round_prep
    @guess = gets.chomp.downcase.strip
    early_guess?
    valid?
    new_letter?
    round
  end

  def self.word_pick
    valid_words = []
    File.foreach('5desk.txt') do |word|
      valid_words.push word if (word.length >= 5) && (word.length <= 12)
    end
    @pc_word = valid_words[rand(0..valid_words.length)]
  end

  def self.valid?
    if @guess.length > 1
      puts 'Invalid - Please try again.'
      try_again
    end
  end

  def self.guess_mode
    puts "Early guess mode! What do you think the word is? If this was a mistake, please type 'EXIT'"
    early_guess = gets.chomp.strip
    if early_guess != 'EXIT'
      if early_guess == @pc_word.join('')
        game_over(@pc_word, 'win')
      else
        puts "oof, that's incorrect!"
        @lives -= 1
        puts "Total lives left: #{@lives}"
        puts 'Please try again'
        try_again
      end
    else
      try_again
    end
  end

  def self.try_again
    round_prep if lives_left? == true
  end

  def self.draw_board(int)
    @board = []
    int.times do
      @board.push '_'
    end
    @board.join('')
  end

  def self.introduction
    puts ''
    puts 'Welcome to my Hangman Game.'
    puts ''
    puts 'The rules are simple:'
    puts ''
    puts 'The PC will pick a secret word at random'
    puts 'Your job is to decipher what the secret word is by guessing each character one at a time.'
    puts 'If you guess incorrectly, you lose one of your 5 lives.'
    puts "If you know want to take a guess at the word, just type 'ANSWER' to enter guessing mode."
    puts 'If you reveal the word without dying, you win!'
    puts ''
    puts 'Please enter your first letter guess:'
  end

  def self.round
    @used_letters.push @guess
    if @pc_word.include?(@guess)
      @pc_word.each_with_index do |letter, idx|
        @board[idx] = @guess if letter == @guess
      end
    else
      puts "Oh no, the letter doesn't contain #{@guess}"
      @lives -= 1
      puts "Total lives left: #{@lives}"
      puts 'Please try again'
      try_again
    end
  end

  def self.new_letter?
    if @used_letters.include?(@guess)
      puts 'Oops, you already guessed that letter. Please try again.'
      try_again
    else
      true
    end
  end

  def self.lives_left?
    if @lives.negative?
      game_over
    else
      true
    end
  end

  def self.game_over(answer, result)
    puts "GAME OVER - You died! The correct word was #{answer}!" if result == 'loss'

    puts "Congratulations! You guess the correct word with #{@lives} lives left." if result == 'win'

    puts 'Would you like to play again? Press 1 yes, or press 2 to exit'
    response = gets.chomp.strip.to_i
    if response == 1
      Hangman.play
    else
      exit
    end
  end

  def self.early_guess?
    if @guess == 'ANSWER'
      guess_mode
    end
  end
end

Hangman.start