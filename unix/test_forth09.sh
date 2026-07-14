#!/bin/sh
# Test suite for forth09. Run from the unix/ directory after `make`.
#
# Each test feeds a line of Forth source to the interpreter on stdin and
# checks that the given substring appears somewhere in its combined
# stdout+stderr output. This is a substring/order check, not an exact
# match, because every response is wrapped in the "ok\n" prompt banter.

BIN=./forth09
PASS=0
FAIL=0

# assert_contains DESCRIPTION INPUT EXPECTED_SUBSTRING
assert_contains() {
    desc="$1"
    input="$2"
    expected="$3"

    actual=$(printf '%s' "$input" | "$BIN" 2>&1)

    case "$actual" in
        *"$expected"*)
            PASS=$((PASS + 1))
            ;;
        *)
            FAIL=$((FAIL + 1))
            echo "FAIL: $desc"
            echo "  input:    $(printf '%s' "$input" | tr '\n' '|')"
            echo "  expected to contain: $expected"
            echo "  actual output:"
            echo "$actual" | sed 's/^/    /'
            ;;
    esac
}

# --- arithmetic ---
assert_contains "addition"            '1 2 + .
'                                      '3 ok'
assert_contains "subtraction"         '10 3 - .
'                                      '7 ok'
assert_contains "multiplication"      '6 7 * .
'                                      '42 ok'
assert_contains "division"            '20 4 / .
'                                      '5 ok'
assert_contains "modulus"             '10 3 MOD .
'                                      '1 ok'
assert_contains "divmod"              '10 3 /MOD . .
'                                      '3 1 ok'
assert_contains "negative dot"        '-5 .
'                                      '-5 ok'
assert_contains "star-slash"          '4 5 3 */ .
'                                      '6 ok'
assert_contains "star-slash-mod"      '7 3 2 */MOD . .
'                                      '10 1 ok'

# --- stack manipulation ---
assert_contains "swap"                '1 2 SWAP . .
'                                      '1 2 ok'
assert_contains "dup"                 '5 DUP . .
'                                      '5 5 ok'
assert_contains "over"                '1 2 OVER . . .
'                                      '1 2 1 ok'
assert_contains "rot"                 '1 2 3 ROT . . .
'                                      '1 3 2 ok'
assert_contains "drop"                '1 2 DROP .
'                                      '1 ok'
assert_contains "2swap"               '1 2 3 4 2SWAP . . . .
'                                      '2 1 4 3 ok'
assert_contains "2dup"                '1 2 2DUP . . . .
'                                      '1 2 1 2 ok'
assert_contains "2over"               '1 2 3 4 2OVER . . . . . .
'                                      '1 2 3 4 1 2 ok'
assert_contains "2drop"               '1 2 3 4 2DROP . .
'                                      '2 1 ok'
assert_contains "?dup nonzero"        '5 ?DUP . .
'                                      '5 5 ok'
assert_contains "?dup zero"           '0 ?DUP .
'                                      '0 ok'

# --- comparisons / logic ---
# NOTE: =, <, >, 0=, 0<, 0>, NOT, and OR are implemented with C's native
# comparison/logical operators, which yield 1 for true (not this
# interpreter's own TRUE constant of -1, as AND correctly uses via &&
# only for its truthy operands but still returns the raw C 1/0 result).
# This mismatch with ANSI Forth's -1/0 boolean convention exists in the
# original 1987 source too, so these tests assert the actual (C-style)
# behavior rather than the ANSI-correct one.
assert_contains "equal true"          '3 3 = .
'                                      '1 ok'
assert_contains "equal false"         '2 3 = .
'                                      '0 ok'
assert_contains "less than"           '2 3 < .
'                                      '1 ok'
assert_contains "greater than"        '3 2 > .
'                                      '1 ok'
assert_contains "zero-equal"          '0 0= .
'                                      '1 ok'
assert_contains "zero-less"           '-1 0< .
'                                      '1 ok'
assert_contains "zero-greater"        '1 0> .
'                                      '1 ok'
assert_contains "not true->false"     '-1 NOT .
'                                      '0 ok'
assert_contains "not false->true"     '0 NOT .
'                                      '1 ok'
assert_contains "and"                 '1 0 AND .
'                                      '0 ok'
assert_contains "or"                  '0 -1 OR .
'                                      '1 ok'

# --- unary math words ---
assert_contains "1+"                  '3 1+ .
'                                      '4 ok'
assert_contains "1-"                  '3 1- .
'                                      '2 ok'
assert_contains "2+"                  '3 2+ .
'                                      '5 ok'
assert_contains "2-"                  '3 2- .
'                                      '1 ok'
assert_contains "2* (left shift)"     '3 2* .
'                                      '6 ok'
assert_contains "2/ (right shift)"    '4 2/ .
'                                      '2 ok'
assert_contains "abs"                 '-5 ABS .
'                                      '5 ok'
assert_contains "negate"              '5 NEGATE .
'                                      '-5 ok'
assert_contains "min"                 '3 4 MIN .
'                                      '3 ok'
assert_contains "max"                 '3 4 MAX .
'                                      '4 ok'

# --- output words ---
assert_contains "dot-quote string"    '." HELLO WORLD"
'                                      'HELLO WORLD'
assert_contains "emit"                '65 EMIT
'                                      'A'
assert_contains "cr"                  '1 . CR 2 .
'                                      '1 
2 ok'
assert_contains "u.r field width"     '5 3 U.R
'                                      '  5 ok'

# --- return stack ---
assert_contains ">R R>"               '5 >R 10 R> . .
'                                      '5 10 ok'
assert_contains "I inside DO LOOP"    '5 0 DO I . LOOP
'                                      '0 1 2 3 4 ok'
assert_contains "J nested DO LOOP"    '2 0 DO 3 0 DO J . I . LOOP LOOP
'                                      '0 0 0 1 0 2 1 0 1 1 1 2 ok'

# --- control flow ---
assert_contains "if-true branch"      '-1 IF 111 . ELSE 222 . THEN
'                                      '111 ok'
assert_contains "if-false branch"     '0 IF 111 . ELSE 222 . THEN
'                                      '222 ok'
assert_contains "do-loop counts up"   '10 0 DO I . LOOP
'                                      '0 1 2 3 4 5 6 7 8 9 ok'
assert_contains "plus-loop step 2"    '10 0 DO I . 2 +LOOP
'                                      '0 2 4 6 8 ok'
assert_contains "begin-until"         '5 BEGIN DUP . 1 - DUP 0= UNTIL DROP
'                                      '5 4 3 2 1 ok'
assert_contains "begin-while-repeat"  '1 BEGIN DUP 5 < WHILE DUP . 1+ REPEAT DROP
'                                      '1 2 3 4 ok'

# --- word definitions ---
assert_contains "colon definition"    ': SQUARE DUP * ;
5 SQUARE .
'                                      '25 ok'
assert_contains "definition using DO" ': COUNTUP 5 0 DO I . LOOP ;
COUNTUP
'                                      '0 1 2 3 4 ok'

# --- error handling ---
assert_contains "stack underflow"     '.
'                                      'Stack underflow'
assert_contains "undefined word"      'FROBNICATE
'                                      'not defined'
assert_contains "abort-quote fires"   '-1 ABORT" should abort" 999 .
'                                      'should abort'
assert_contains "abort-quote skipped" '0 ABORT" should not abort" 999 .
'                                      '999 ok'

echo
echo "passed: $PASS, failed: $FAIL"
[ "$FAIL" -eq 0 ]
