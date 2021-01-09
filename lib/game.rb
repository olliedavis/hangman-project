class Hangman
  def  self.introduction
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
end

Hangman.introduction