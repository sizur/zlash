#!/bin/sh

#bench "math expr comparison"
declare -A assoc=(one 1 two 2)
@begin
(( assoc[two] == 2 ))
@end

#bench "test math expr comparison"
declare -A assoc=(one 1 two 2)
@begin
[[ (( ${assoc[two]} == 2 )) ]]
@end

#bench "test numeric comparison"
declare -A assoc=(one 1 two 2)
@begin
[[ assoc[two] -eq 2 ]]
@end

#bench "test numeric math expr comparison"
declare -A assoc=(one 1 two 2)
@begin
[[ $(( assoc[two] == 2 )) -eq 1 ]]
@end
