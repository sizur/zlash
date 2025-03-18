

###############################################################################
#
# This bench is perf testing methods of getting ASCII value of the first
# character in a string.
#

# $ shellbench -c -s zsh,ksh93,bash,dash ./str_first_ascii.sh
# -----------------------------------------------------------------------------
# name                                        zsh     ksh93      bash      dash
# -----------------------------------------------------------------------------
# str_fst_byte.sh: %c      char             1,089    10,860       974     1,490
# str_fst_byte.sh: ${%}    char             6,717        10        29     2,463
# str_fst_byte.sh: ${%%}   char            11,578    18,762     2,651     9,983
# str_fst_byte.sh: ${:0:1} char           183,422    37,285    23,117     error
# str_fst_byte.sh: -v %c   char            25,837   753,097    10,910     error
# str_fst_byte.sh: %d            ascii      1,097     error       950     1,528
# str_fst_byte.sh: %c      %d    ascii        561     9,624       483       730
# str_fst_byte.sh: ${%%}   %d    ascii        961    14,583       695     1,363
# str_fst_byte.sh: ${%%}    byte2dec       10,024    16,391     2,240     7,525
# str_fst_byte.sh: ${%%}    byte2dec_2      9,527     4,525     2,337     7,430
# str_fst_byte.sh: ${:0:1} %d    ascii      1,010    26,129       981     error
# str_fst_byte.sh: ${%%}   -v %d ascii     11,003    18,009     2,556     error
# str_fst_byte.sh: -v %c   -v %d ascii     23,712   411,753    10,595     error
# str_fst_byte.sh: ${:0:1} -v %d ascii    111,383   795,255    18,691     error
# str_fst_byte.sh: ${:0:1}  byte2dec       57,087   151,888     9,314     error
# str_fst_byte.sh: ${:0:1}  byte2dec_2     40,904     5,708    11,181     error
# -----------------------------------------------------------------------------
# * count: number of executions per second

txt='Pellentesque dapibus suscipit ligula. Donec posuere augue in quam. Etiam
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
txt=$txt$txt$txt
txt=$txt$txt$txt

byte2dec() {
    tmp=${map%%"$1"*} && dec=$((${#tmp}+1))
}
byte2dec_2() {
    tmp=${map2%"$1"*} && dec=${#tmp}
}

byte2dec_init() {
    map=''
    i=0
    while [ "$i" -lt 255 ]; do
        i=$((i+1))                    &&\
        oct=$(printf %03o\\n "$i")    && \
        byte=$(printf \\"$oct"x\\n)   &&  \
        byte=${byte%x}                &&   \
        map=$map$byte                 || return 1
    done
}
byte2dec_init &&\
map2=\ $map

#bench "%c      char"
@begin
first=$(printf '%cx\n' "$txt") &&\
first=${first%x}               && \
[ "$first" = 'P' ]
@end

#bench "\${%}    char"
@begin
first=${txt%"${txt#?}"} &&\
[ "$first" = 'P' ]
@end

#bench "\${%%}   char"
@begin
first=${txt%%"${txt#?}"} &&\
[ "$first" = 'P' ]
@end

#bench "\${:0:1} char"
@begin
first=${txt:0:1} &&\
[ "$first" = 'P' ]
@end

#bench "-v %c   char"
@begin
first=                      &&\
printf -v first '%c' "$txt" && \
[ "$first" = 'P' ]
@end

#bench "%d            ascii"
@begin
ascii=$(printf '%d\n' "'$txt") &&\
[ "$ascii" = '80' ]
@end

# NOTE: This is the slower one of the two portable builtins.
#bench "%c      %d    ascii"
@begin
first=$(printf '%cx\n' "$txt")   &&\
first=${first%x}                 && \
ascii=$(printf '%d\n' "'$first") &&  \
[ "$ascii" = '80' ]
@end

# NOTE: This is the faster one of the two portable builtins.
#bench "\${%%}   %d    ascii"
@begin
first=${txt%%"${txt#?}"}         &&\
ascii=$(printf '%d\n' "'$first") && \
[ "$ascii" = '80' ]
@end

# NOTE: Our portable idx lookup function.
#bench "\${%%}    byte2dec  "
@begin
dec=                          &&\
byte2dec "${txt%%"${txt#?}"}" && \
[ "$dec" = '80' ]
@end

#bench "\${%%}    byte2dec_2"
@begin
dec=                            &&\
byte2dec_2 "${txt%%"${txt#?}"}" && \
[ "$dec" = '80' ]
@end

#bench "\${:0:1} %d    ascii"
@begin
ascii=$(printf '%d\n' "'${txt:0:1}") &&\
[ "$ascii" = '80' ]
@end

#bench "\${%%}   -v %d ascii"
@begin
ascii=                         &&\
first=${txt%%"${txt#?}"}       && \
printf -v ascii '%d' "'$first" &&  \
[ "$ascii" = '80' ]
@end

#bench "-v %c   -v %d ascii"
@begin
ascii=                         &&\
first=                         && \
printf -v first '%c'  "$txt"   &&  \
printf -v ascii '%d' "'$first" &&   \
[ "$ascii" = '80' ]
@end

#bench "\${:0:1} -v %d ascii"
@begin
ascii=                             &&\
printf -v ascii '%d' "'${txt:0:1}" && \
[ "$ascii" = '80' ]
@end

#bench "\${:0:1}  byte2dec  "
@begin
dec=                  &&\
byte2dec "${txt:0:1}" && \
[ "$dec" = '80' ]
@end

#bench "\${:0:1}  byte2dec_2"
@begin
dec=                    &&\
byte2dec_2 "${txt:0:1}" && \
[ "$dec" = '80' ]
@end
