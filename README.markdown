# 1-800-THE-QUIZ

## About

Best of Ruby Quiz, Chapter 13

Write a program that shows the user possible matches for a list of provided phone numbers. For example, if your program is fed the following number:

`873.7829`

one possible line of output (according to my dictionary) is this:

`USE-RUBY`

Your script should behave as a standard Unix filter, reading from files specified as command-line arguments or STDIN when no files are given. Each line of these files will contain a single phone number, **seven** digits in length.

For each phone number read, output all possible word replacements from a dictionary. Your script should try to replace every digit of the provided phone number with a letter from a dictionary word; however, if no match can be made, a single digit can be left between two words. No two consecutive digits can remain unchanged, and the program should skip over a number (producing no output) if a match cannot be made.

Your solution should allow the user to select a dictionary with the -d command-line option, but it’s fine to use a reasonable default for your system. The dictionary is expected to have one word per line.

All punctuation and whitespace should be ignored in both phone num- bers and the dictionary file. The program should not be case sensitive, letting "a" == "A". Output should be capital letters, and digits should be separated at word boundaries with a single hyphen (-), one possible encoding per line.

encoding: 

```
2 = ABC 
3 = DEF 
4 = GHI 
5 = JKL 
6 = MNO 
7 = PQRS 
8 = TUV 
9 = WXYZ
```

## Requirements

Ruby 2.2.2

## Notes

- dictionary.txt is a Scrabble dictionary. 

```
Usage: ./quiz.rb [options] [source.txt]
    -d, --dict DICTIONARY_FILE       A dictionary file. Defaults to /usr/share/dict/words
    -h                               Help
```

## Usage

run `bundle install`

## Understanding the Question

- We can discard all words that are longer than the number length.
- Best matches are those that leave no digit. 
- One possibility: start with the first digit, find all words that start with those letters (5=JKL, for example). Then, move on to the next digit and filter the word list down. If it contains no vowels, our selection becomes very small. 

- For every word possibility, create a new Lead.
- each round of the loop 'fixes' the next digit into a letter and removes the words that don't match the 3 letters. 
- Each word found is a branch that either gets extended or removed.
- When a word ends, start a completely new branch with the next letter, and a separate new branch from the letter following that. 

## Review

**Initial enhancement:**
- Make the dictionary set as small as possible on each loop by removing words that are too long and those that start with the wrong letter

**v1.0 possible enhancements**

- a new Regexp is built for each word in the dictionary on each `_find_words` call. Possible to remove this?
- might be possible using negative lookaheads / capture groups
- benchmark for `873.7829`: 
  - `17.460000   0.100000  17.560000 ( 17.622081)`
- use memoization because the same word set may already have been used
- unexpectedly, narrowing the dictionary set by using the first 2 characters was slower than matching just the first character. (about 30s)

**successful enhancements**

- using `=~` instead of `Regexp.new` to narrow the dictionary benchmarked: 
  - `9.150000   0.090000   9.240000 (  9.272512)`
- using `@dict_cache` to cache narrowed dictionary word lists by number sequences cuts the time to:
  - `7.500000   0.080000   7.580000 (  7.631965)`
- **Huge improvement!** Using `@regex_cache` to cache the Regex string by numbers and word length cuts the time to: 
  - `0.950000   0.030000   0.980000 (  0.991224)`

**reject answers with start and trailing digit**

- benchmark: 
  - `0.680000   0.030000   0.710000 (  0.700799)`

## Results

```
### 8737829 ###
TREST-AW
TREST-AX
TREST-AY
TREST-AY
TREST-BY
UP-ER-TAW
UP-ER-TAX
UP-ER-TAY
UP-ER-8-AW
UP-ER-8-AX
UP-ER-8-AY
UP-ER-8-AY
UP-ER-8-BY
UP-ES-TAW
UP-ES-TAX
UP-ES-TAY
UP-ES-8-AW
UP-ES-8-AX
UP-ES-8-AY
UP-ES-8-AY
UP-ES-8-BY
UP-3-PU-AW
UP-3-PU-AX
UP-3-PU-AY
UP-3-PU-AY
UP-3-PU-BY
UP-3-QUAW
UP-3-QUAY
UP-3-RUBY
UP-3-ST-AW
UP-3-ST-AX
UP-3-ST-AY
UP-3-ST-AY
UP-3-ST-BY
UP-3-STAW
UP-3-STAY
UR-ER-TAW
UR-ER-TAX
UR-ER-TAY
UR-ER-8-AW
UR-ER-8-AX
UR-ER-8-AY
UR-ER-8-AY
UR-ER-8-BY
UR-ES-TAW
UR-ES-TAX
UR-ES-TAY
UR-ES-8-AW
UR-ES-8-AX
UR-ES-8-AY
UR-ES-8-AY
UR-ES-8-BY
UR-3-PU-AW
UR-3-PU-AX
UR-3-PU-AY
UR-3-PU-AY
UR-3-PU-BY
UR-3-QUAW
UR-3-QUAY
UR-3-RUBY
UR-3-ST-AW
UR-3-ST-AX
UR-3-ST-AY
UR-3-ST-AY
UR-3-ST-BY
UR-3-STAW
UR-3-STAY
URD-PU-AW
URD-PU-AX
URD-PU-AY
URD-PU-AY
URD-PU-BY
URD-QUAW
URD-QUAY
URD-RUBY
URD-ST-AW
URD-ST-AX
URD-ST-AY
URD-ST-AY
URD-ST-BY
URD-STAW
URD-STAY
URD-7-TAW
URD-7-TAX
URD-7-TAY
URE-PU-AW
URE-PU-AX
URE-PU-AY
URE-PU-AY
URE-PU-BY
URE-QUAW
URE-QUAY
URE-RUBY
URE-ST-AW
URE-ST-AX
URE-ST-AY
URE-ST-AY
URE-ST-BY
URE-STAW
URE-STAY
URE-7-TAW
URE-7-TAX
URE-7-TAY
URF-PU-AW
URF-PU-AX
URF-PU-AY
URF-PU-AY
URF-PU-BY
URF-QUAW
URF-QUAY
URF-RUBY
URF-ST-AW
URF-ST-AX
URF-ST-AY
URF-ST-AY
URF-ST-BY
URF-STAW
URF-STAY
URF-7-TAW
URF-7-TAX
URF-7-TAY
US-ER-TAW
US-ER-TAX
US-ER-TAY
US-ER-8-AW
US-ER-8-AX
US-ER-8-AY
US-ER-8-AY
US-ER-8-BY
US-ES-TAW
US-ES-TAX
US-ES-TAY
US-ES-8-AW
US-ES-8-AX
US-ES-8-AY
US-ES-8-AY
US-ES-8-BY
US-3-PU-AW
US-3-PU-AX
US-3-PU-AY
US-3-PU-AY
US-3-PU-BY
US-3-QUAW
US-3-QUAY
US-3-RUBY
US-3-ST-AW
US-3-ST-AX
US-3-ST-AY
US-3-ST-AY
US-3-ST-BY
US-3-STAW
US-3-STAY
USE-PU-AW
USE-PU-AX
USE-PU-AY
USE-PU-AY
USE-PU-BY
USE-QUAW
USE-QUAY
USE-RUBY
USE-ST-AW
USE-ST-AX
USE-ST-AY
USE-ST-AY
USE-ST-BY
USE-STAW
USE-STAY
USE-7-TAW
USE-7-TAX
USE-7-TAY
USER-TAW
USER-TAX
USER-TAY
USER-8-AW
USER-8-AX
USER-8-AY
USER-8-AY
USER-8-BY
Total: 178
```

## License

This code is released under the [MIT License](http://www.opensource.org/licenses/MIT)


