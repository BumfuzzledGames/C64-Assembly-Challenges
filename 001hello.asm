/* Challenge 001: Hello world
 * Print a message to the screen.
 */

BasicUpstart2(start)
#import "kernal.inc"
#import "functions.asm"

hello:
   .text "HELLO, WORLD!"
   .byte 0

start:
   PRINT(hello)
   rts
