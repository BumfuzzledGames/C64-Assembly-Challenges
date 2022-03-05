.pseudocommand mov arg1:arg2 {
   lda arg1
   sta arg2
}

.pseudocommand mov16 src:tar {
  lda src
  sta tar
  lda _16bit_nextArgument(src)
  sta _16bit_nextArgument(tar)
}

.function _16bit_nextArgument(arg) {
  .if (arg.getType()==AT_IMMEDIATE) .return CmdArgument(arg.getType(),>arg.getValue())
  .return CmdArgument(arg.getType(),arg.getValue()+1)
}

.macro PRINT(string_addr) {
    lda #<string_addr
    sta $fb
    lda #>string_addr
    sta $fc
    jsr print_string
}

.macro PRINT_NEWLINE() {
   lda #$0d
   jsr KERNAL_CHROUT
}

.macro INPUT(buffer, len) {
   lda #<buffer
   sta $fb
   lda #>buffer
   sta $fc
   lda #len
   jsr read_string
}

.macro COMPARE_STRINGS(a,b) {
   mov16 #a:compare_strings_a
   mov16 #b:compare_strings_b
   jsr compare_strings
}                         
   

//reads a string from the keyboard
//parameters:
//  a = max string length excluding nul
//  $fb = buffer
//returns:
//  y = length
//clobbers: a,x,y
read_string:
   sta @len                   //initialize @len
   lda #0                     //and @idx
   sta @idx
@getin:
   jsr KERNAL_GETIN
   beq @getin
   sta @char
   cmp #$14                   //delete
   beq @delete
   cmp #$0d                   //return
   beq @done
   lda read_string_check:#00  //skip check?
   beq @checked
   ldy #0                     //acceptable idx
@check:
   lda read_string_check_chars:$0000,y
   beq @getin                 //end of acceptable string
   cmp @char
   beq @checked               //char was acceptable
   iny
   jmp @check
@checked:
   ldy @idx                   //store char
   cpy @len
   beq @getin
   lda @char
   sta ($fb),y
   iny
   sty @idx
@echo:
   ldx read_string_echo_char:#$ff
   beq @getin                 //no echo
   cpx #$ff                   //echo read char
   beq !+
   txa                        //echo predefined char
!: jsr KERNAL_CHROUT
   jmp @getin
@delete:
   ldy @idx
   beq @getin
   lda #$14
   jsr KERNAL_CHROUT
   dey
   lda #0                     //erase character
   sta ($fb),y
   sty @idx
   jmp @getin
@done:
   ldy @idx                   //terminate string
   lda #0
   sta ($fb),y
   rts
.const READ_STRING_ECHO_NONE=$00
.const READ_STRING_ECHO_READ=$ff
@char:      .byte 0
@len:       .byte 0
@idx:       .byte 0


//compares two strings
//parameters:
// compare_strings_a = string a
// compare_strings_b = string b
//returns:
// a = strings equal if a != 0
//clobbers: a,x
compare_strings:
   ldx #0
@loop:		
   lda compare_strings_a:$ffff,x
   cmp compare_strings_b:$ffff,x
   bne @unequal
   cmp #0					  //end of string?
   beq @equal
   inx
   jmp @loop
@equal:		
   lda #1
   rts
@unequal:	
   lda #0
   rts

//prints a string to the screen
//parameters:
//  $fb = nul-terminated string
//returns: nothing
//clobbers: a,y
print_string:
   ldy #0
!: lda ($fb),y
   beq !+
   jsr KERNAL_CHROUT
   iny
   jmp !-
!: rts

//fills screen with character
//parameters:
//  a = character
//returns: nothing
//clobbers: x
fill_screen:
   ldx #250
!: sta 1023,x          
   sta 1023+250,x
   sta 1023+500,x
   sta 1023+750,x
   dex
   bne !-
   rts
