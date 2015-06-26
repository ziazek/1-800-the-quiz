#!/usr/bin/env ruby

require 'pry-byebug'
require 'optparse'

Wordling = Struct.new(:words, :numbers)

class WordMaker
  def initialize(numbers)
    @numbers = numbers.gsub(/[\D]+/, '')
    @dict = $words
    @answers = []
    find_words(Wordling.new([], @numbers))
  end

  def render
    
  end

  def find_words(wordling)
    # calls _find_words for the wordling and the next skipped number
    # reject wordling if there are 2 consecutive single letter matches.
    return if wordling.words.length >= 2 and /[\w]{2}/ === wordling.words.pop(2)
    new_wordlings = [wordling]
    if wordling.numbers.length > 1
      new_wl = Wordling.new([], '')
      new_wl.words = wordling.words.dup << wordling.numbers[0]
      new_wl.numbers = wordling.numbers[1..-1]
      new_wordlings << new_wl
    end
    print 'wl', wordling
    puts
    _find_words(new_wordlings)
  end

  def _find_words(wordlings)
    puts "_find_words(#{wordlings})"
    # return false
    wordlings.each do |wordling|
      smaller_dict = remove_impossible_matches(@dict, wordling)
      smaller_dict.each do |word|
        regex_for(wordling.numbers, word).match(word) do |m|
          # block is called if the word matches a length of numbers at the start of the string
          # wordling should not be modified here, only duplicated
          new_wl = Wordling.new([], '')
          new_wl.words = wordling.words.dup << word
          binding.pry if wordling.words.size == 0
          print 'new_wl words', new_wl.words
          new_wl.numbers = wordling.numbers[word.length..-1]
          print wordling, ' ', new_wl
          puts
          if new_wl.numbers.nil? || new_wl.numbers.length <= 1
            print 'is nil', new_wl
            puts
            @answers << new_wl
            next
          end
          # print 'not nil', new_wl
          # puts
          find_words(new_wl)
        end
      end
    end
  end

  def regex_for(numbers, word)
    # print numbers, word
    # puts
    # binding.pry if numbers.empty?
    chars = numbers[0...word.length].chars.collect do |num|
      case num.to_i
      when 2 then "[abc]"
      when 3 then "[def]"
      when 4 then "[ghi]"
      when 5 then "[jkl]"
      when 6 then "[mno]"
      when 7 then "[pqrs]"
      when 8 then "[tuv]"
      when 9 then "[wxyz]"
      else "[\\d]" # will not match
      end
    end
    # print numbers, word, chars
    Regexp.new("^#{chars.join}", Regexp::IGNORECASE)
  end

  def remove_impossible_matches(dict, wordling)
    num = wordling.numbers[0]
    chars = case num.to_i
      when 2 then "[abc]"
      when 3 then "[def]"
      when 4 then "[ghi]"
      when 5 then "[jkl]"
      when 6 then "[mno]"
      when 7 then "[pqrs]"
      when 8 then "[tuv]"
      when 9 then "[wxyz]"
      else "[\\d]" # will not match
    end
    dict.select do |w|
      w.length <= wordling.numbers.length && Regexp.new("^#{chars}", Regexp::IGNORECASE) === w[0]
    end
  end
end

$dictionary = '/usr/share/dict/words'
OptionParser.new do |o|
  o.banner = "Usage: #{$PROGRAM_NAME} [options] [source.txt]"
  o.on('-d', '--dict DICTIONARY_FILE', 'A dictionary file. Defaults to /usr/share/dict/words') do |arg| 
    $dictionary = arg
  end
  o.on('-h', 'Help') { puts o; exit }
  o.parse!
end

$words = []
File.readlines($dictionary).each { |line| $words << line.chomp if line.chomp.length <= 7 && line.chomp.length > 1 }
# puts $words.length

if ARGV.length > 0
  ARGV.each do |file|
    wm = WordMaker.new(File.readlines(file).first.chomp)
    wm.render
  end
else
  loop do
    puts "Enter a 7 digit number or type 'exit'" 
    print "> "
    wm = WordMaker.new($stdin.gets.chomp)
    wm.render
    exit if number == "exit"
  end
end