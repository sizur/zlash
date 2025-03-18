
###############################################################################
#
# This bench is perf testing methods of testing if var is empty or not.
#

# $ shellbench -c -s zsh,ksh93,bash,dash not_empty.sh
# ------------------------------------------------------------------------------
# name                                      zsh      ksh93       bash       dash
# ------------------------------------------------------------------------------
# not_empty.sh: test plain               29,204  2,004,752     16,600     29,400
# not_empty.sh: test-                    29,095  2,111,986     16,092     30,013
# not_empty.sh: test:+x                  93,116  2,000,301     55,424     75,542
# not_empty.sh: test -n                  27,865  1,831,866     16,015     30,227
# not_empty.sh: test:+x -n               92,585  1,739,579     49,336     77,255
# not_empty.sh: num test len             50,843  1,241,315     49,770     71,531
# not_empty.sh: str test len             52,182  1,685,341     50,644     71,004
# not_empty.sh: case function            12,840     33,010     10,703     23,573
# not_empty.sh: case func ref            30,708    129,798     28,056     31,848
# not_empty.sh: func ref eval case       13,354     25,151     14,285     32,854
# not_empty.sh: func ref eval test:+x    32,299    125,421     22,186     36,186
# not_empty.sh: new test match           27,360     39,369     42,517      error
# not_empty.sh: new test -n              56,141  4,488,778     48,654      error
# ------------------------------------------------------------------------------
# * count: number of executions per second

text='Pellentesque dapibus suscipit ligula. Donec posuere augue in quam. Etiam
vel tortor sodales tellus ultricies commodo. Suspendisse potenti. Aenean in sem
ac leo mollis blandit. Donec neque quam, dignissim in, mollis nec, sagittis eu,
wisi. Phasellus lacus. Etiam laoreet quam sed arcu. Phasellus at dui in ligula
mollis ultricies. Integer placerat tristique nisl. Praesent augue. Fusce
commodo. Vestibulum convallis, lorem a tempus semper, dui dui euismod elit,
vitae placerat urna tortor vitae lacus. Nullam libero mauris, consequat quis,
varius et, dictum id, arcu. Mauris mollis tincidunt felis. Aliquam feugiat
tellus ut neque. Nulla facilisis, risus a rhoncus fermentum, tellus tellus
lacinia purus, et dictum nunc justo sit amet elit.
'
text=$text$text$text
empt=

#bench "test plain"
@begin
[ "$text" ] ||:
[ "$empt" ] ||:
[ "$text" ] ||:
@end

#bench "test-"
@begin
[ "${text-}" ] ||:
[ "${empt-}" ] ||:
[ "${text-}" ] ||:
@end

#bench "test:+x"
@begin
[ "${text:+x}" ] ||:
[ "${empt:+x}" ] ||:
[ "${text:+x}" ] ||:
@end

#bench "test -n"
@begin
[ -n "$text" ] ||:
[ -n "$empt" ] ||:
[ -n "$text" ] ||:
@end

#bench "test:+x -n"
@begin
[ -n "${text:+x}" ] ||:
[ -n "${empt:+x}" ] ||:
[ -n "${text:+x}" ] ||:
@end

#bench "num test len"
@begin
[ ${#text} -ne 0 ] ||:
[ ${#empt} -ne 0 ] ||:
[ ${#text} -ne 0 ] ||:
@end

#bench "str test len"
@begin
[ ${#text} != 0 ] ||:
[ ${#empt} != 0 ] ||:
[ ${#text} != 0 ] ||:
@end

#bench "case function"
f() {
    case $1 in
        ?*) return 0;;
        *)  return 1;;
    esac
}
@begin
f "$text" ||:
f "$empt" ||:
f "$text" ||:
@end

#bench "case func ref"
f() {
    eval tmp=\$1
    case $tmp in
        ?*) return 0;;
        *)  return 1;;
    esac
}
@begin
f text ||:
f empt ||:
f text ||:
@end

#bench "func ref eval case"
f() {
    eval "case \$$1 in
        ?*) return 0;;
        *)  return 1;;
    esac"
}
@begin
f text ||:
f empt ||:
f text ||:
@end

#bench "func ref eval test:+x"
f() {
    eval "[ \"\${$1:+x}\" ]"
}
@begin
f text ||:
f empt ||:
f text ||:
@end

#bench "new test match"
@begin
[[ $text = ?* ]] ||:
[[ $empt = ?* ]] ||:
[[ $text = ?* ]] ||:
@end

#bench "new test -n"
@begin
[[ -n $text ]] ||:
[[ -n $empt ]] ||:
[[ -n $text ]] ||:
@end
