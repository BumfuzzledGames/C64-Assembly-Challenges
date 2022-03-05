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
   .fill NAME_LEN,0

start:
   PRINT(prompt)
   mov #1:read_string_check
   mov16 #alpha:read_string_check_chars
   mov #'*':read_string_echo_char
   INPUT(name, NAME_LEN-1)
   PRINT_NEWLINE()
   PRINT(hello)
   PRINT(name)
   rts
