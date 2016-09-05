#
# More ksh-like extended globbing tests, cribbed from zsh-3.1.5
#
shopt -s extglob

failed=0
while read res str pat; do
  [[ $res = '#' ]] && continue
  [[ $str = ${pat} ]]
  ts=$?
  [[ $1 = -q ]] || echo "$ts:  [[ $str = $pat ]]"
  if [[ ( $ts -gt 0 && $res = t) || ($ts -eq 0 && $res = f) ]]; then
    echo "Test failed:  [[ $str = $pat ]]"
    (( failed += 1 ))
  fi
done <<EOT

f a.js           **/*.js
t a/a.js         **/*.js
t a/a/b.js       **/*.js

f a/b/z.js       a/b/**/*.js
t a/b/c/z.js     a/b/**/*.js

f foo.md         **/*.md
t foo/bar.md     **/*.md

f foo/bar        foo/**/bar
t foo/bar        foo/**bar

t ab/a/d         **/*
t ab/b           **/*
t a/b/c/d/a.js   **/*
t a/b/c.js       **/*
t a/b/c.txt      **/*
t a/b/.js/c.txt  **/*
f a.js           **/*
f za.js          **/*
f ab             **/*
f a.b            **/*

f foo/               foo/**/
f foo/bar            foo/**/
f foo/bazbar         foo/**/
f foo/barbar         foo/**/
f foo/bar/baz/qux    foo/**/
t foo/bar/baz/qux/   foo/**/

EOT
echo ""
echo "$failed tests failed."
