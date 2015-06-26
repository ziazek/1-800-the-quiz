#!/usr/bin/env ruby

require 'pry-byebug'
require 'benchmark'
require 'optparse'

MIN_WORD_LENGTH = 2

class WordMaker
  def initialize(numbers)
    @numbers = numbers.gsub(/[\D]+/, '')
    raise "#{numbers} must be 7 digits long" unless @numbers.length == 7
    @dict = $words
    @answers = []
    find_words({words: [], numbers: @numbers})
  end

  def render
    puts
    puts "### #{@numbers} ###"
    @answers.each do |ans|
      puts ans[:words].join('-').upcase
    end
    puts "Total: #{@answers.length}"
  end

  private

  def find_words(word_hash)
    # calls _find_words for the wordling and the next skipped number
    _find_words(word_hash)
    # try skipping one number
    if word_hash[:numbers].length > 1
      sk = {words: word_hash[:words].clone, numbers: word_hash[:numbers].clone}
      sk[:words] << sk[:numbers][0]
      sk[:numbers][0] = ''
      _find_words(sk)
    end
  end

  def _find_words(word_hash)
    puts "processing: (#{word_hash})"
    filtered_dict(word_hash[:numbers]).each do |word|
      # check whether the first n digits match the word
      regex_for(word_hash[:numbers], word).match(word) do |m|
        # block is called if the word matches a length of numbers at the start of the string
        # do nothing otherwise (skip)
        # word_hash should not be modified here, only duplicated
        new_word = {words: word_hash[:words].clone, numbers: word_hash[:numbers].clone}
        # add the match to the words array
        new_word[:words] << word 
        # and delete the same length of digits from the start of the numbers string
        new_word[:numbers][0...word.length] = ''
        if new_word[:numbers].length < MIN_WORD_LENGTH
          if new_word[:numbers].length == 1
            new_word[:words] << new_word[:numbers]
            new_word[:numbers] = ''
          end
          @answers << new_word
          next
        end
        find_words(new_word)
      end
    end

  end

  def regex_for(numbers, word)
    # makes the regex as long as the word
    # puts "regex_for #{numbers[0...word.length]}"
    @regex_cache ||= {}
    @regex_cache.fetch(numbers[0...word.length]) do
      chars = numbers[0...word.length].chars.collect do |num|
        encoding_for(num)
      end
      # puts "creating cache for #{numbers[0...word.length]}, #{Regexp.new("^#{chars.join}", Regexp::IGNORECASE)}"
      @regex_cache[numbers[0...word.length]] = Regexp.new("^#{chars.join}", Regexp::IGNORECASE)
    end
    # "^#{chars.join}"
  end

  def filtered_dict(numbers)
    # select words that are shorter or equal to the number of digits left, and start with the same letter as the first digit's encoding
    @dict_cache ||= {}
    @dict_cache.fetch(numbers) do
      @dict_cache[numbers] = @dict.select do |w|
        w.length <= numbers.length && w[0].downcase =~ /#{encoding_for(numbers[0])}/
      end
    end
  end

  def encoding_for(num)
    case num.to_i
      when 2 then "[abc]"
      when 3 then "[def]"
      when 4 then "[ghi]"
      when 5 then "[jkl]"
      when 6 then "[mno]"
      when 7 then "[pqrs]"
      when 8 then "[tuv]"
      when 9 then "[wxyz]"
      else "[\\d]" # ensure no match
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
File.readlines($dictionary).each { |line| $words << line.chomp if line.chomp.length <= 7 && line.chomp.length >= MIN_WORD_LENGTH }

if ARGV.length > 0
  ARGV.each do |file|
    puts Benchmark.measure {
      wm = WordMaker.new(File.readlines(file).first.chomp)
      wm.render
    }
  end
else
  loop do
    puts "Enter a 7 digit number or type 'exit'" 
    print "> "
    number = $stdin.gets.chomp
    exit if number == "exit"
    puts Benchmark.measure {
      wm = WordMaker.new(number)
      wm.render
    }
  end
end