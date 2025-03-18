
# Conclusion:
#    Status negation is in the order of 0.1µs (a tenth of a microsecond), so no
#    meaningful impact. No need to write inverted variants of validators.
#

_true()  { return 0; }
_false() { return 1; }

#bench baseline
@begin
_true
@end

#bench negation
@begin
! _false
@end
