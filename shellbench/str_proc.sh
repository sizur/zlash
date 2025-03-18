
text2='asdfasfgsdfgasdf'
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
lacinia purus, et dictum nunc justo sit amet elit.
'

#bench "direct"
@begin
test=$text
while [ "${test:+x}" ]; do
    ascii=$(printf '%d\n' "'$test")
    test=${test#?}
done
@end

#bench "chopped non-eager"
@begin
test=$text
while [ "${test:+x}" ]; do
    head=${test%%"${test#?}"}
    ascii=$(printf '%d\n' "'$head")
    test=${test#?}
done
@end

#bench "chopped eager"
@begin
test=$text
while [ "${test:+x}" ]; do
    head=${test%"${test#?}"}
    ascii=$(printf '%d\n' "'$head")
    test=${test#?}
done
@end

#bench "direct printf -v"
@begin
test=$text
while [ "${test:+x}" ]; do
    printf -v ascii '%d\n' "'$test"
    test=${test#?}
done
@end

#bench "chopped eager printf -v"
@begin
test=$text
while [ "${test:+x}" ]; do
    head=${test%"${test#?}"}
    printf -v ascii '%d\n' "'$head"
    test=${test#?}
done
@end

#bench "index"
@begin
test=$text
while [ "${test:+x}" ]; do
    head=${test:0}  # zsh is 1-indexed, but doesn't matter for bench
    ascii=$(printf '%d\n' "'$head")
    test=${test#?}
done
@end

#bench "index printf -v"
@begin
test=$text
while [ "${test:+x}" ]; do
    head=${test:0}  # zsh is 1-indexed, but doesn't matter for bench
    printf -v ascii '%d\n' "'$head"
    test=${test#?}
done
@end
