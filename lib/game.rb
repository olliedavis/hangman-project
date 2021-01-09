class Hangman
  private
  def word_pick
    valid_words = []
    File.foreach("../5desk.txt") do |word|
      if word.length >= 5 and word.length <= 12
        valid_words.push word
      end
    end
    word_choice = valid_words[rand(0..valid_words.length)]
  end
end
