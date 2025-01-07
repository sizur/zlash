#!/bin/sh

#bench "single-quoted format"
Write_Out_Q ()
{
    local IFS=' ' && builtin printf '%s\n' "$*"
}
@begin
Write_Out_Q '-n'
@end

#bench "c-quoted format"
Write_Out_C ()
{
    local IFS=' ' && builtin printf $'%s\n' "$*"
}
@begin
Write_Out_C '-n'
@end

#bench "slice cond IFS isolation"
Write_Out_S ()
{
    [[ "${IFS:0:1}" == ' ' ]] || local IFS=' '; builtin printf '%s\n' "$*"
}
@begin
Write_Out_S '-n'
@end

#bench "pat cond IFS isolation"
Write_Out_P ()
{
    [[ "$IFS" == ' '* ]] || local IFS=' '; builtin printf '%s\n' "$*"
}
@begin
Write_Out_P '-n'
@end

#bench "posix pat cond IFS isolation"
Write_Out_X ()
{
    case "$IFS" in
        ' '*) builtin printf '%s\n' "$*" ;;
        *) local IFS=' ' && builtin printf '%s\n' "$*" ;;
    esac
}
@begin
Write_Out_X '-n'
@end

#bench "inline"
@begin
IFS=' ' && builtin printf '%s\n' '-n'; IFS=$' \t\n'
@end

#bench "inline, no logic"
@begin
IFS=' '; builtin printf '%s\n' '-n'; IFS=$' \t\n'
@end

#bench "inline, no builtin isolation"
@begin
IFS=' ' && printf '%s\n' '-n'; IFS=$' \t\n'
@end

#bench "inline, no IFS isolation"
@begin
builtin printf '%s\n' '-n'
@end

#bench "inline, no IFS,builtin isolation"
@begin
printf '%s\n' '-n'
@end

#bench "plain echo"
@begin
echo -- '-n'
@end
