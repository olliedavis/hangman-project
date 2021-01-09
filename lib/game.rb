class Hangman

  def initialize
    @guess_count = 0
    @board = []
  end

  def round
    pc_guess = word_pick.split("")
    draw_board(pc_guess.length)
    guess = gets.chomp.downcase.strip
    valid?(guess)

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

  def try_again
    #placeholder
  end

  def draw_board(int)
    int.times do 
      @board.push "_"
    end
    puts @board.join("")
  end

end

round = Hangman.new

round.game