#!/usr/bin/env ksh

str=aaaaabbbbb && while [ "${str:+x}" ]; do
    tmp=${str#?}
    ch=${str%%"$tmp"}
    typeset -p str tmp ch
    if [ ${#ch} -ne 1 ]; then echo '^ BUG!!!!!!!!!!!'; fi
    echo
    str=$tmp
done
