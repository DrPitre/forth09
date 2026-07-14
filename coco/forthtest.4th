1 2 + .
10 3 - .
6 7 * .
20 4 / .
10 3 MOD .
10 3 /MOD . .
-5 .
4 5 3 */ .
7 3 2 */MOD . .
1 2 SWAP . .
5 DUP . .
1 2 OVER . . .
1 2 3 ROT . . .
1 2 DROP .
1 2 3 4 2SWAP . . . .
1 2 2DUP . . . .
1 2 3 4 2OVER . . . . . .
1 2 3 4 2DROP . .
5 ?DUP . .
0 ?DUP .
3 3 = .
2 3 = .
2 3 < .
3 2 > .
0 0= .
-1 0< .
1 0> .
-1 NOT .
0 NOT .
1 0 AND .
0 -1 OR .
3 1+ .
3 1- .
3 2+ .
3 2- .
3 2* .
4 2/ .
-5 ABS .
5 NEGATE .
3 4 MIN .
3 4 MAX .
." HELLO WORLD"
65 EMIT
1 . CR 2 .
5 3 U.R
5 >R 10 R> . .
5 0 DO I . LOOP
2 0 DO 3 0 DO J . I . LOOP LOOP
-1 IF 111 . ELSE 222 . THEN
0 IF 111 . ELSE 222 . THEN
10 0 DO I . LOOP
10 0 DO I . 2 +LOOP
5 BEGIN DUP . 1 - DUP 0= UNTIL DROP
1 BEGIN DUP 5 < WHILE DUP . 1+ REPEAT DROP
: SQUARE DUP * ;
5 SQUARE .
: COUNTUP 5 0 DO I . LOOP ;
COUNTUP
.
FROBNICATE
-1 ABORT" should abort" 999 .
0 ABORT" should not abort" 999 .
