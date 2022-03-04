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
   lda #<hello
   sta $fb
   lda #>hello
   sta $fc
   jsr print_string
   rts
