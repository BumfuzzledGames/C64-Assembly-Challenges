/* Challenge 003: Login
 * Ask the user for a username and password
 * Valid login: admin/pass123
 * Display ACCESS DENIED on failure, and
 * ACCESS GRANTED on success.
 */

BasicUpstart2(start)
#import "kernal.inc"
#import "functions.asm"

prompt:     
   .text "SUPER SECRET LOGIN"
   .byte 0
prompt_username:              
   .text "USERNAME: "
   .byte 0
prompt_password:              
   .text "PASSWORD: "
   .byte 0
alphanum:   
   .text "abcdefghijklmnopqrstuvwxyz"
   .text "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
   .text "0123456789"
   .byte 0
login_username:               
   .text "ADMIN"
   .byte 0
login_password:               
   .text "PASS123"
   .byte 0
login_successful:             
   .text "WELCOME, YOU'VE GOT MAIL!"
   .byte 0
login_unsuccessful:           
   .text "ACCESS DENIED"
   .byte 0

.const USERNAME_LEN=16
username:
   .fill USERNAME_LEN,0
.const PASSWORD_LEN=16
password:   
   .fill PASSWORD_LEN,0


start:      
   PRINT(prompt)
   PRINT_NEWLINE()
   PRINT(prompt_username)
   mov #1:read_string_check
   mov16 #alphanum:read_string_check_chars
   mov #$ff:read_string_echo_char
   INPUT(username,USERNAME_LEN-1)
   PRINT_NEWLINE()
   PRINT(prompt_password)
   mov #0:read_string_check
   mov #'*':read_string_echo_char
   INPUT(password,PASSWORD_LEN-1)
   PRINT_NEWLINE()
   COMPARE_STRINGS(username, login_username)
   beq @denied
   COMPARE_STRINGS(password, login_password)
   beq @denied
@granted:       
   PRINT(login_successful)
   PRINT_NEWLINE()
   rts
@denied:        
   PRINT(login_unsuccessful)
   PRINT_NEWLINE()
   rts
