# Emoji

Adds an emoji to the beginning of each line in a file. Cross-platform version
of [teemoji](https://github.com/willswire/teemoji).

Requires [ollama](https://ollama.com/) installed. By default uses model
[llama3.2:3b](https://ollama.com/library/llama3.2).
A different model can be specified in `MODEL_NAME` environment variable.

Example usage:

```
time ./emoji.sh tests/test.txt
🚫 ---
📝 title: CommonMark Spec
📚 author: John MacFarlane
📦 version: '0.31.2'
📆 date: '2024-01-28'
🔒 license: '[CC-BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)'
❓ ...
🗿
📚 # Introduction
🗿
📝 ## What is Markdown?
🗿
📝 Markdown is a plain text format for writing structured documents,
📧 based on conventions for indicating formatting in email
📰 and usenet posts.  It was developed by John Gruber (with
🤝 help from Aaron Swartz) and released in 2004 in the form of a
📝 [syntax description](https://daringfireball.net/projects/markdown/syntax)
📝 and a Perl script (`Markdown.pl`) for converting Markdown to
📊 HTML.  In the next decade, dozens of implementations were
🌎 developed in many languages.  Some extended the original
📚 Markdown syntax with conventions for footnotes, tables, and
📝 other document elements.  Some allowed Markdown documents to be
📺 rendered in formats other than HTML.  Websites like Reddit,
🤖 StackOverflow, and GitHub had millions of people using Markdown.
📚 And Markdown started to be used beyond the web, to author books,
📄 articles, slide shows, letters, and lecture notes.
🗿
📝 What distinguishes Markdown from many other lightweight markup
📝 syntaxes, which are often easier to write, is its readability.
📝 As Gruber writes:
🗿
> > The overriding design goal for Markdown's formatting syntax is
> > to make it as readable as possible. The idea is that a
📄 > Markdown-formatted document should be publishable as-is, as
> > plain text, without looking like it's been marked up with tags
💸 > or formatting instructions.
📝 > (<https://daringfireball.net/projects/markdown/>)
🗿

real    0m7.658s
user    0m0.682s
sys     0m0.780s
```

If you want to save it to a file, you can do `./emoji.sh tests/test.txt | tee > output.txt`

