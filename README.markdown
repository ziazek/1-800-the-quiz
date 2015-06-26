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

## Results

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
## License

This code is released under the [MIT License](http://www.opensource.org/licenses/MIT)


