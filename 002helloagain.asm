/* Challenge 002: Hello again
 * Ask the user for their name and greet them.
 */

BasicUpstart2(start)
#import "kernal.inc"
#import "functions.asm"

prompt:
   .text "WHAT IS YOUR NAME? "
   .byte 0
hello:
   .text "HELLO, "
   .byte 0
alpha:		
   .text "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "
   .byte 0
.const NAME_LEN=32
name:		
   .fill NAME_LEN, 0

start:
   lda #<prompt				  //print the prompt
   sta $fb
   lda #>prompt
   sta $fc
   jsr print_string
   lda #<name				  //input name
   sta $fb
   lda #>name
   sta $fc
   lda #<alpha
   sta $fd
   lda #>alpha
   sta $fe
   lda #NAME_LEN-1
   jsr read_string
   lda #$0d					  //print newline
   jsr KERNAL_CHROUT
   lda #<hello				  //print hello
   sta $fb
   lda #>hello
   sta $fc
   jsr print_string
   lda #<name				  //print name
   sta $fb
   lda #>name
   sta $fc
   jsr print_string
   rts
