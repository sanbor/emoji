#!/usr/bin/env bash

../emoji.sh test.txt > test-emoji-output.txt
cat test-emoji-output.txt | cut -c3- > test-emoji-output-cut.txt
diff test.txt test-emoji-output-cut.txt
ret=$?

if [[ $ret -eq 0 ]]; then
    echo "passed tests"
else
    echo "failed tests"
fi
