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

## License

This code is released under the [MIT License](http://www.opensource.org/licenses/MIT)


