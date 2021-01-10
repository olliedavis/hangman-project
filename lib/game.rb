class Hangman

  def initialize
    @lives = 5
  end

  def round_prep
    pc_word = word_pick.split("")
    draw_board(pc_word.length)
    guess = gets.chomp.downcase.strip
    early_guess?(guess)
    valid?(guess)
    new_letter?(guess)
  end


  private

  def word_pick
    valid_words = []
    File.foreach("../5desk.txt") do |word|
      if word.length >= 5 and word.length <= 12
        valid_words.push word
      end
    end 
    valid_words[rand(0..valid_words.length)]
  end

  def valid?(guess)
    if guess.length > 1 and guess != "ANSWER"
      puts "Invalid - Please try again."
      try_again
    else true
    end
  end

  def guess_mode
    puts "Early guess mode! What do you think the word is? If this was a mistake, please type 'EXIT'"
    early_guess = gets.chomp.strip
    if early_guess != "EXIT"
      if early_guess == pc_word
        game_over(pc_word, "win")
      else
        puts "oof, that's incorrect!"
        @lives -= 1
        puts "Total lives left: #{@lives}"
        puts "Please try again"
        try_again
      end
    else
      try_again
    end
  end

  def try_again
    #placeholder
  end

  def draw_board(int)
    board = Array.new
    int.times do 
      board.push "_"
    end
    board.join("")
  end

  def introduction
    puts ""
    puts "Welcome to my Hangman Game."
    puts ""
    puts "The rules are simple:"
    puts ""
    puts "The PC will pick a secret word at random"
    puts "Your job is to decipher what the secret word is by guessing each character one at a time."
    puts "If you guess incorrectly, you lose one of your 5 lives."
    puts "If you know want to take a guess at the word, just type 'ANSWER' to enter guessing mode."
    puts "If you reveal the word without dying, you win!"
  end

end


def round(guess)
  used_letters = Array.new
  used_letters.push guess
  if pc_word.includes?(guess) do
    pc_word.each_with_index do |letter, idx|
      if letter == guess
        board[idx] = guess
        next
      end
    end
  else
    puts "Oh no, the letter doesn't contain #{guess}"
    @lives -= 1
    puts "Total lives left: #{@lives}"
    puts "Please try again"
    try_again
  end
  end
end

def new_letter?(guess)
  if !used_letter.includes?(guess)
    return true
  else 
    puts "Oops, you already guessed that letter. Please try again."
    try_again
  end
end

def lives_left?
  if @lives < 0
    game_over
  else
    return true
  end
end

def game_over(answer, result)
  if result == "loss"
    puts "GAME OVER - You died! The correct word was #{answer}!"
  end
  
  if result == "win"
    puts "Congratulations! You guess the correct word with #{@lives} lives left."
  end

  puts "Would you like to play again? Press 1 for yes, or press 2 to exit"
  response = gets.chomp.strip.to_i
  if response == 1
    Hangman.play
  else
    exit
  end
end

def early_guess?
  if guess == "ANSWER"
    guess_mode
  end
end



