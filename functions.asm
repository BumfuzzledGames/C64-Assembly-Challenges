//reads a string from the keyboard
//parameters:
//  a = max string length excluding nul
//  $fb = buffer
//  $fd = acceptable chars
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
   ldy #0                     //acceptable idx
@check:
   lda ($fd),y
   beq @getin                 //end of string
   cmp @char
   beq @checked
   iny
   jmp @check
@checked:
   ldy @idx                   //store char
   cpy @len
   beq @getin
   sta ($fb),y
   iny
   sty @idx
   jsr KERNAL_CHROUT
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
@char:      .byte 0
@len:       .byte 0
@idx:       .byte 0

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
