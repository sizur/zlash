#
###############################################################################
#
# This bench is perf testing POSIX methods for function temp vars.
#

# $ shellbench -c -s zsh,ksh93,bash,dash assign_vs_set.sh
# -----------------------------------------------------------------------------
# name                                     zsh      ksh93       bash       dash
# -----------------------------------------------------------------------------
# assign_vs_set.sh: set                 26,819     12,094     10,998     21,898
# assign_vs_set.sh: eval assign         30,984    177,120     17,171     39,483
# assign_vs_set.sh: assign              46,895    341,651     21,491     55,427
# -----------------------------------------------------------------------------
# * count: number of executions per second

text='
Pellentesque dapibus suscipit ligula. Donec posuere augue in quam. Etiam vel
tortor sodales tellus ultricies commodo. Suspendisse potenti. Aenean in sem ac
leo mollis blandit. Donec neque quam, dignissim in, mollis nec, sagittis eu,
wisi. Phasellus lacus. Etiam laoreet quam sed arcu. Phasellus at dui in ligula
mollis ultricies. Integer placerat tristique nisl. Praesent augue. Fusce
commodo. Vestibulum convallis, lorem a tempus semper, dui dui euismod elit,
vitae placerat urna tortor vitae lacus. Nullam libero mauris, consequat quis,
varius et, dictum id, arcu. Mauris mollis tincidunt felis. Aliquam feugiat
tellus ut neque. Nulla facilisis, risus a rhoncus fermentum, tellus tellus
lacinia purus, et dictum nunc justo sit amet elit. Pellentesque dapibus suscipit
ligula. Donec posuere augue in quam. Etiam vel tortor sodales tellus ultricies
commodo. Suspendisse potenti. Aenean in sem ac leo mollis blandit. Donec neque
quam, dignissim in, mollis nec, sagittis eu, wisi. Phasellus lacus. Etiam
laoreet quam sed arcu. Phasellus at dui in ligula mollis ultricies. Integer
placerat tristique nisl. Praesent augue. Fusce commodo. Vestibulum convallis,
lorem a tempus semper, dui dui euismod elit, vitae placerat urna tortor vitae
lacus. Nullam libero mauris, consequat quis, varius et, dictum id, arcu. Mauris
mollis tincidunt felis. Aliquam feugiat tellus ut neque. Nulla facilisis, risus
a rhoncus fermentum, tellus tellus lacinia purus, et dictum nunc justo sit amet
elit. Pellentesque dapibus suscipit ligula. Donec posuere augue in quam. Etiam
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

#bench "set"
f() {
    set -- "$text"   &&\
    set -- "$text 2" && \
    set -- "$text 3"
}
@begin
f
@end

#bench "eval assign"
f() {
    test=                &&\
    eval test=\$text     && \
    eval 'test=$text\ 2' &&  \
    eval 'test=$text\ 3' &&   \
    unset -v test
}
@begin
f
@end

#bench "assign"
f() {
    test=         &&\
    test=$text    && \
    test=$text\ 2 &&  \
    test=$text\ 3 &&   \
    unset -v test
}
@begin
f
@end
