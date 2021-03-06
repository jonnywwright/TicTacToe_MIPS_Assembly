# ##################################################################
# Name:  Jonathan Wright                                           #
# Class: CDA3100                                                   #
# Assignment: 6                                                    #
# Description: This is a Tic-Tac-Toe game that uses the minmax     #
# algorithm to play Tic-Tac-Toe perfectly.                         #
# Source of Algorithm: Mark Weiss Data Structures and Analysis     #
# ##################################################################


    .data

BOARD:  .word     0, 0, 0, 0, 0, 0, 0, 0, 0
WELCOMEUSER:    .asciiz     "Welcome to Tic-Tac-Toe\nI'm X and you're O.\nI'll go first!\n"
ASKFORINPUT:    .asciiz     "Choose an empty position between 1 and 9\n"
PLAYAGAIN:       .asciiz     "To play again, enter 0"
GAP:            .asciiz     " "
LOSE:           .asciiz     "Sorry! You lose"
DRAW:           .asciiz     "Well done, you didn't lose. You didn't win either!"
X:      .byte       'X'
O:      .byte       'O'
EOL:    .byte       '\n'
    .text
    .globl main
main:


LOADGAME:
la      $t0,BOARD
li      $t1,1                   # initial computer val
sw      $t1,0($t0)              # set the initial position
li      $s7,1                   # Set up an initial val for best move
li      $v0,4               	# Ready the printer
la      $a0,WELCOMEUSER     	# Load the welcome message
syscall                     	# Print the welcome message


GAMELOOP:
addi    $t0,1                   # increment turn counter
beq     $t0,$t1,ENDGAME         #when turns are up end game

addiu   $sp,$sp,-12
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
jal     PRINTBOARD
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
addiu   $sp,$sp,12

addiu   $sp,$sp,-12
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
jal     IMMEDIATECOMPUTERWIN
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
addiu   $sp,$sp,12

blt     $zero,$s3,PRINTLOSS

addiu   $sp,$sp,-12
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
jal     ISBOARDFULL
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
addiu   $sp,$sp,12

blt     $zero,$s3,PRINTDRAW

addiu   $sp,$sp,-12
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
jal     GETINPUT
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
addiu   $sp,$sp,12

move    $s3,$s0         # move the validated position to $s3
li      $s4,2           # player value
addiu   $sp,$sp,-12
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
jal     SETVALFROMPOSITION
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
addiu   $sp,$sp,12

addiu   $sp,$sp,-12
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
jal     PRINTBOARD
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
addiu   $sp,$sp,12

addiu   $sp,$sp,-12
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
jal     IMMEDIATECOMPUTERWIN
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
addiu   $sp,$sp,12

blt     $zero,$s3,PRINTLOSS

addiu   $sp,$sp,-12
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
jal     ISBOARDFULL
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
addiu   $sp,$sp,12

blt     $zero,$s3,PRINTDRAW

addiu   $sp,$sp,-12
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
jal     FINDBESTCOMPUTERMOVE
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
addiu   $sp,$sp,12


lb  	$a0,EOL         	# Print a new line
li  	$v0,11          
syscall
move    $a0,$s7
li      $v0,1
syscall
lb  	$a0,EOL         	# Print a new line
li  	$v0,11          
syscall

move    $s3,$s7         # move the computer position to $s3
li      $s4,1           # computer player value
addiu   $sp,$sp,-12
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
jal     SETVALFROMPOSITION
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
addiu   $sp,$sp,12



j       GAMELOOP

ENDGAME:
li  $v0,4       
la  $a0,PLAYAGAIN
syscall
li  	$v0,5               # Ready the integer reader
syscall                 	# Read the integer
beq $zero,$v0,RESETBOARD
jr	$ra			# Exit game

PRINTDRAW:
li  $v0,4
la  $a0,DRAW
syscall
j ENDGAME

PRINTLOSS:
li  $v0,4
la  $a0,LOSE
syscall
j ENDGAME

RESETBOARD:
la      $t0,BOARD
li      $t1,9
li      $t2,0          # counter
RESETTOP:
beq     $t1,$t2,LOADGAME
sw  	$zero,0($t0)
addi    $t0,4          # byte size
addi    $t2,1          # increment counter
j		RESETTOP				# jump to target

################################################################################
################################################################################
################################################################################
FINDBESTCOMPUTERMOVE:
##### check if board is full, if it is return draw
addiu   $sp,$sp,-4
sw      $ra,0($sp)
jal     ISBOARDFULL             # if boardfull $s3 = 1, else $s3=0
lw      $ra,0($sp)
addiu   $sp,$sp,4
blt     $zero,$s3,RETURNDRAW   	# if full RETURNDRAW
##### check if immediate comp win, return if true
addiu   $sp,$sp,-4
sw      $ra,0($sp)
jal     IMMEDIATECOMPUTERWIN    # if immediatecompwin $s3 = 1, else $s3 = 0
lw      $ra,0($sp)
addiu   $sp,$sp,4
blt     $zero,$s3,RETURNCOMPWIN # if immiediatecompwin RETURNCOMPWIN


#li      $s7, 1          	# assert best move = 1 
li      $t0, 9               	# max range not inclusive
li      $t1, 0               	# counter and position
li      $t2,-10         	# store COMPLOSS in $t2
FBCMLOOPTOP:       
beq     $t0,$t1,RETURNVALUE     # exit loop and return value             
addi    $t1,1              	# increment, now it has correct indexing
move    $s3,$t1            	# save position in $s3 for arg passing
addiu   $sp,$sp,-16             
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
sw      $t2,12($sp)
jal     GETVALFROMPOSITION
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
lw      $t2,12($sp)
addiu   $sp,$sp,16
move    $a0,$s3                 # save the return val to $a0
move    $s3,$t1                 # move position back into $s3 for arg passing 
beq     $zero,$a0,VISITPOSITION # If position is empty visit, else top of loop
j	FBCMLOOPTOP


VISITPOSITION:
li      $s4,1                   # store computer value $s4
addiu   $sp,$sp,-16
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
sw      $t2,12($sp)
jal     SETVALFROMPOSITION      # THIS IS THE SET
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
lw      $t2,12($sp)
addiu   $sp,$sp,16


# FIND HUMAN RESPONSE VALUE 
# li      $s4,1                   #     WHY IS THIS HERE?
addiu   $sp,$sp,-20
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
sw      $t2,12($sp)
sw      $s7,16($sp)             ### since the findbesthumanmove takes a dc arg
jal     FINDBESTHUMANMOVE      # 
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
lw      $t2,12($sp)
lw      $s7,16($sp) 
addiu   $sp,$sp,20
move    $t3,$s6                # save return val from FINDBESTHUMANMOVE

move    $s3,$t1                 # save position into $s3
li      $s4,0                   # save value into $s4
addiu   $sp,$sp,-20
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
sw      $t2,12($sp)
sw      $t3,16($sp)             # need extra space for responsevalue
jal     SETVALFROMPOSITION      # THIS IS THE UNSET
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
lw      $t2,12($sp)
sw      $t3,16($sp)
addiu   $sp,$sp,20

blt     $t2,$t3,UPDATECOMPVALUES
jr      FBCMLOOPTOP
# If responsevalue > value, val = responsevalue, bestmove = i


RETURNDRAW:
li 	$s6,0        		# s6 holds the DRAW val
jr  	$ra         		# return out

RETURNCOMPWIN:
li 	$s6,10        		# s6 holds the COMPWIN val
jr  	$ra         		# return out
RETURNVALUE:
move    $s6,$t2
jr      $ra                     # whatever in value $s6 return it


UPDATECOMPVALUES:
move    $t2,$t3                 # value = response value
move    $s7,$t1                 # bestmove = i
jr      FBCMLOOPTOP             # back to top of loop


################################################################################
################################################################################
################################################################################

################################################################################
################################################################################
################################################################################
FINDBESTHUMANMOVE:
##### check if board is full, if it is return draw
addiu   $sp,$sp,-4
sw      $ra,0($sp)
jal     ISBOARDFULL             # if boardfull $s3 = 1, else $s3=0
lw      $ra,0($sp)
addiu   $sp,$sp,4
blt     $zero,$s3,RETURNDRAW   	# if full RETURNDRAW
##### check if immediate comp win, return if true
addiu   $sp,$sp,-4
sw      $ra,0($sp)
jal     IMMEDIATEHUMANWIN    # if immediatecompwin $s3 = 1, else $s3 = 0
lw      $ra,0($sp)
addiu   $sp,$sp,4
blt     $zero,$s3,RETURNHUMANWIN # if IMMEDIATEHUMANWIN RETURNHUMANWIN


#li      $s7,1           	# assert best move = 1 
li      $t0,9               	# max range not inclusive
li      $t1,0               	# counter and position
li      $t2,10         	        # store HUMANLOSS in $t2
FBHMLOOPTOP:       



beq     $t0,$t1,RETURNVALUE     # exit loop and return value           
addi    $t1,1              	# increment, now it has correct indexing
move    $s3,$t1            	# save position in $s3 for arg passing
addiu   $sp,$sp,-16             
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
sw      $t2,12($sp)
jal     GETVALFROMPOSITION
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
lw      $t2,12($sp)
addiu   $sp,$sp,16
move    $a0,$s3                 # save the return val to $a0
move    $s3,$t1                 # move position back into $s3 for arg passing 
beq     $zero,$a0,VISITPOSITIONH # If position is empty visit, else top of loop
j	FBHMLOOPTOP


VISITPOSITIONH:
li      $s4,2                   # store HUMAN value $s4
addiu   $sp,$sp,-16
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
sw      $t2,12($sp)
jal     SETVALFROMPOSITION      # THIS IS THE SET
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
lw      $t2,12($sp)
addiu   $sp,$sp,16


# FIND COMPUTER RESPONSE VALUE 
#li      $s4,1                   # WHY IS THIS HERE?
addiu   $sp,$sp,-20
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
sw      $t2,12($sp)
sw      $s7,16($sp)
jal     FINDBESTCOMPUTERMOVE      # 
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
lw      $t2,12($sp)
lw      $s7,16($sp)
addiu   $sp,$sp,20
move    $t3,$s6                # save return val from FINDBESTCOMPUTERMOVE

move    $s3,$t1                 # save position into $s3
li      $s4,0                   # save value into $s4
addiu   $sp,$sp,-20
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
sw      $t2,12($sp)
sw      $t3,16($sp)             # need extra space for responsevalue
jal     SETVALFROMPOSITION      # THIS IS THE UNSET
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
lw      $t2,12($sp)
sw      $t3,16($sp)
addiu   $sp,$sp,20

blt     $t3,$t2,UPDATEHUMANVALUES
jr      FBHMLOOPTOP
# If responsevalue > value, val = responsevalue, bestmove = i


RETURNHUMANWIN:
li 	$s6,-10        		# s6 holds the COMPWIN val
jr  	$ra         		# return out

UPDATEHUMANVALUES:
move    $t2,$t3                 # value = response value
move    $s7,$t1                 # bestmove = i
jr      FBHMLOOPTOP             # back to top of loop

################################################################################
################################################################################
################################################################################

#### Input saved in $s0
GETINPUT:
addiu   $sp,$sp,-4
sw      $ra,0($sp)
jal     EVALUATEINPUT  		# Jump to the validate input method
lw      $ra,0($sp)
addiu   $sp,$sp,4

jr	$ra			# jump out to $t0

EVALUATEINPUT:
li      $v0,4           	# Ready the printer
la      $a0,ASKFORINPUT 	# Load ask user for input message
syscall                 	# Ask the user for input
li  	$v0,5               	# Ready the integer reader
syscall                 	# Read the integer
li      $a1,1                   # Min val
slt 	$a0,$v0,$a1        	# if $v0 < $zero store a 1 in $a0
bne 	$a0,$zero,EVALUATEINPUT # if invalid input prompt again
li  	$a1,10               	# Store the upper bounds non inclusive
slt 	$a0,$v0,$a1         	# if $v0 < 9 store a 1 in $a0
beq 	$a0,$zero,EVALUATEINPUT # if v0 > 9 go ask for new input

move    $t0,$v0             # now we check if the position is taken
move    $s3,$v0             # move to s3 to pass arg
addiu   $sp,$sp,-8
sw      $ra,0($sp)
sw      $t0,4($sp)
jal     GETVALFROMPOSITION		# Jump to the validate input method
lw      $ra,0($sp)
lw      $t0,4($sp)
addiu   $sp,$sp,8
bne     $s3,$zero,EVALUATEINPUT

move 	$s0, $t0		    # Save the valid user input into $s0
jr	$ra				

### PRINTS THE CURRENT GAMEBOARD TO THE CONSOLE
PRINTBOARD:
la 	$t0,BOARD
li 	$t1, 3           	# range for inner and outer loops
li 	$t2,0            	# outer loop counter
li  $t4,0               # position counter for printing
li  $t5,1               # for branching 

OuterLoop:

beq 	$t2,$t1,EXPRINTBOARD    # exit printboard after done printing
li 	$t3,0            	# inner loop counter
addiu 	$t2,1         		# increment outer loop counter
lb  	$a0,EOL         	# Print a new line
li  	$v0,11          
syscall


InnerLoop:
beq 	$t3,$t1,OuterLoop 	# jump out to outer when done
addiu   $t3,1      		# incrememnt inner loop counter
addi    $t4,1           # increment the position counter


lw  	$a0, 0($t0)
beq     $a0,$zero,PRINTPOS     # if position empty print pos
beq     $a0,$t5,PRINTX          # if a one print X for computer pos
j		PRINTO				    # else jump to PRINTO


PRINTEND:
addiu 	$t0,4         		# increment address of t0 for the next print
j 	InnerLoop        

PRINTX:
lb  $a0,X
li  $v0,11
syscall
li  $v0,4
la  $a0,GAP
syscall

j PRINTEND

PRINTO:
lb  $a0,O
li  $v0,11
syscall
li  $v0,4
la  $a0,GAP
syscall

j PRINTEND

PRINTPOS:
move  $a0,$t4
li  $v0,1
syscall
li  $v0,4
la  $a0,GAP
syscall

j PRINTEND

EXPRINTBOARD:
lb  	$a0,EOL         	# Print a new line
li  	$v0,11          
syscall
jr  	$ra

### CHECKS IF BOARD IS FULL
### Places a 0 in $s3 if not full
### Places a 1 in $s3 if it is full
### A board is full if it has no zeroes
ISBOARDFULL:
li 	$t0,0        		# counter
li 	$t1,9        		# max range not inclusive
li 	$t2,1        		# position
ISBOARDFULLLOOP:
beq     $t0,$t1,FULLEXIT            
addiu   $sp,$sp,-16         	# Save all these temp variables b4 jumping
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
sw      $t2,12($sp)
move    $s3,$t2             	# pass the position in $s3
jal     GETVALFROMPOSITION  	# jump to this
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
lw      $t2,12($sp)
addiu   $sp,$sp,16
### the value is now stored in $s3, lets check it
beq 	$s3,$zero,NOTFULLEXIT
addi 	$t0,1      		# increment counter
addi 	$t2,1      		# increment position

j   	ISBOARDFULLLOOP 	# jump to top of the loop

FULLEXIT:
li  	$s3,1  			# the board is full
jr  	$ra

NOTFULLEXIT:
li  	$s3,0  			# the board is not full
jr  	$ra

### DETERMINES IF WIN, LOSS OR DRAW
GETSCORE:

### CHECKS IF ROW AT POSITION IS WON BY ANY PLAYER
### Position is passed in via $s3
ROWISWON:
la 	$t0,BOARD
addi 	$s3,-1    		# decrement position for zero indexing
li   	$a0,3
div  	$s3,$a0    		# quot in Lo
mflo 	$a2        		# quot now in $a2
mult	$a0,$a2     		# zero indexed row now stored in $lo
mflo 	$a0        		# move back into $a0
li 	$a1,4       		# byte offset size
mult 	$a0,$a1   		# mult by the byte offset size
mflo 	$a0        		# move total offset into $a0
add  	$t0,$t0,$a0 		# t0 now indexed at the start of row

lw  	$t1,0($t0)  		# first position is now $t1
lw  	$t2,4($t0)  		# second position is now $t2
lw  	$t3,8($t0)  		# third position is now $t3
bne 	$t1,$t2,NOTWONROWEXIT
bne 	$t1,$t3,NOTWONROWEXIT
li  	$s3,1    		# 1 means the row is won
jr  	$ra

NOTWONROWEXIT:
li 	$s3,0
jr  	$ra

### CHECKS IF COL AT POSITION IS WON BY ANY PLAYER
COLISWON:
la   	$t0,BOARD
addi 	$s3,-1    		# decrement position for zero indexing
li 	$a0,3
div  	$s3,$a0    		# mod in Hi
mfhi 	$a0        		# mod now in $a2
li      $a1,4       		# byte offset size
mult 	$a0,$a1   		# mult by the byte offset size
mflo 	$a0        		# move total offset into $a0
add  	$t0,$t0,$a0 		# t0 now indexed at the start of row

lw  	$t1,0($t0)  		# first position is now $t1
lw  	$t2,12($t0)  		# second position is now $t2
lw  	$t3,24($t0)  		# third position is now $t3

bne 	$t1,$t2,NOTWONCOLEXIT
bne 	$t1,$t3,NOTWONCOLEXIT
li  	$s3,1    		# row is won
jr  	$ra

NOTWONCOLEXIT:
li 	$s3,0			# row not won
jr  	$ra


### CHECKS IF DIAGNOL AT POSITION IS WON BY ANY PLAYER
### position passed in via $s3
DIAGNOLISWON:
# 2, 4, 6, 8 are all not compatible with diagnols, all r even
# if even number kick out to not win exit
move    $t1,$s3         # save position in $t1
li 	    $t0,2   		# store 2 in $t0
div 	$s3,$t0
mfhi 	$a0    			# put the remainder in $a0
beq 	$zero,$a0,RDIAGNOWINEXIT
la   	$t0,BOARD

addiu   $sp,$sp,-12        
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
jal     GETVALFROMPOSITION      ### GOTTA MAKE SURE IT'S NOT ZERO
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
addiu   $sp,$sp,12

beq 	$zero,$s3,RDIAGNOWINEXIT
move    $s3,$t1                 # restore $s3 

li 	$a0,1
beq 	$a0,$s3, LEFTDIAGNOL
addi 	$a0,5
beq 	$a0,$s3, LEFTDIAGNOL     #center position tricky tricky
addi 	$a0,4
beq 	$a0,$s3, LEFTDIAGNOL

li 	$a0,3
beq 	$a0,$s3, RIGHTDIAGNOL
addi 	$a0,4
beq 	$a0,$s3, RIGHTDIAGNOL



LEFTDIAGNOL:
lw  	$t1,16($t0)  		# middle position is now in $t1
lw  	$t2,0($t0)  		# second position is now $t2
lw  	$t3,32($t0)  		# third position is now $t3
bne 	$t1,$t2,LDIAGNOWINEXIT
bne 	$t1,$t3,LDIAGNOWINEXIT
li 	$s3,1
jr 	$ra

RIGHTDIAGNOL:
lw  	$t1,16($t0)  		# middle position is now in $t1
lw  	$t2,8($t0)  		# second position is now $t2
lw  	$t3,24($t0)  		# third position is now $t3
bne 	$t1,$t2,RDIAGNOWINEXIT
bne 	$t1,$t3,RDIAGNOWINEXIT
li 	$s3,1
jr 	$ra

LDIAGNOWINEXIT:
li 	$a0,5
beq 	$s3,$a0,RIGHTDIAGNOL  	# In case middle position try right diagnol
li 	$s3,0
jr 	$ra

RDIAGNOWINEXIT:
li 	$s3,0
jr 	$ra


### Takes the position 1 - 9, uses modulo and division 
### to get the row and col
### Assumes position is stored in $s3
### Obviosly this could be much shorter since this is not
### a real 2d array like C++ but this is to show I can
GETVALFROMPOSITION:
la $t0,BOARD
addi 	$s3,-1    		# decrement position for zero indexing
li   	$a0,3				
div  	$s3,$a0     		# modulo is in Hi quot in Lo
mfhi 	$a1        		# modulo now in $a1
mflo 	$a2        		# quot now in $a2
mult 	$a0,$a2    		# zero indexed row now stored in $lo
mflo 	$a0        		# move back into $a0
add  	$a0,$a0, $a1   		# the column offset now added to $a0
li 	$a1,4       		# byte offset size
mult 	$a0, $a1   		# mult by the byte offset size
mflo 	$a0        		# move total offset into $a0
add  	$t0,$t0,$a0 		# t0 now indexed at the correct POSITION
lw  	$s3,0($t0)  		# return the value back via $s3
jr  	$ra


SETVALFROMPOSITION:
### Assume position is passed in via $s3, value $s4
### Takes the position 1 - 9, subtracts 1 and mult by 4 for the 
### index. This doesn't treat BOARD as a 2D array. For that please
### see GETVALUEFROMPOSITION
la 	$t0,BOARD
addi 	$s3,-1     		# decrement position for zero-indexing
li 	$t1,4        		# load byte size into $t1
mult 	$t1,$s3    		# mult the zero-indexed by byte size for correct offset
mflo 	$t1        		# store the product into $t1
add 	$t0,$t0,$t1		# add the offset to $t0
sw  	$s4,0($t0) 		# update the value in the array
jr 	$ra          		# jump back

### Loop through all positions, if the position is 2/Human,
### check if the row, col, or diag is a winner. If Winner return
### true
IMMEDIATEHUMANWIN:
la 	$t0,BOARD
li 	$t1,9
li 	$t2,0               	# counter / position
li 	$t3,2               	#  Human value
IHWLOOPTOP:
addi 	$t2,1              	# increment counter
beq  	$t2,$t1,NOWINEXIT
addiu   $sp,$sp,-20         	# Save all these temp variables b4 jumping
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
sw      $t2,12($sp)
sw      $t3,16($sp)
move    $s3,$t2             	# pass the position in $s3
jal     GETVALFROMPOSITION  	# jump to this
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
lw      $t2,12($sp)
lw      $t3,16($sp)
addiu   $sp,$sp,20

move    $t4,$s3         	# store the value from $s3 into $t4
move    $s3,$t2         	# store position back into $s3
beq     $t4,$t3,CHECKIFWINNERHUMAN # if the position is human jump out
j	IHWLOOPTOP      	# check the next position

##### Check if the position is a winner
CHECKIFWINNERHUMAN:         
addiu   $sp,$sp,-20         	# Save all these temp variables b4 jumping
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
sw      $t2,12($sp)
sw      $t3,16($sp)
jal     ROWISWON  		# jump to this
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
lw      $t2,12($sp)
lw      $t3,16($sp)
addiu   $sp,$sp,20
blt     $zero,$s3,WINNEREXIT    # If row is won $s3 == 1, else 0

move 	$s3,$t2        		# load position back into $s3

addiu   $sp,$sp,-20         	# Save all these temp variables b4 jumping
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
sw      $t2,12($sp)
sw      $t3,16($sp)
jal     COLISWON  		# jump to this
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
lw      $t2,12($sp)
lw      $t3,16($sp)
addiu   $sp,$sp,20
blt     $zero,$s3,WINNEREXIT 	# If row is won $s3 == 1, else 0

move 	$s3,$t2        		# load position back into $s3

addiu   $sp,$sp,-20         	# Save all these temp variables b4 jumping
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
sw      $t2,12($sp)
sw      $t3,16($sp)
jal     DIAGNOLISWON  # jump to this
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
lw      $t2,12($sp)
lw      $t3,16($sp)
addiu   $sp,$sp,20
blt     $zero,$s3,WINNEREXIT 	# If row is won $s3 == 1, else 0
j	IHWLOOPTOP  		# If none of these were valid jump to top

WINNEREXIT:
li      $s3,1   		# should already be a 1 in $s3 but whatever
jr      $ra

NOWINEXIT:
li      $s3,0
jr      $ra

### Loop through all positions, if the position is 1/Computer,
### check if the row, col, or diag is a winner. If Winner return
### true
IMMEDIATECOMPUTERWIN:
la 	$t0,BOARD
li 	$t1,9
li 	$t2,0               	# counter / position
li 	$t3,1               	# COMPUTER value
ICWLOOPTOP:
addi 	$t2,1              	# increment counter
beq  	$t2,$t1,NOWINEXIT
addiu   $sp,$sp,-20         	# Save all these temp variables b4 jumping
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
sw      $t2,12($sp)
sw      $t3,16($sp)
move    $s3,$t2             	# pass the position in $s3
jal     GETVALFROMPOSITION  	# jump to this
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
lw      $t2,12($sp)
lw      $t3,16($sp)
addiu   $sp,$sp,20

move    $t4,$s3         	# store the value from $s3 into $t4
move    $s3,$t2         	# store position back into $s3
beq     $t4,$t3,CHECKIFWINNERCOMP # if the position is human jump out
j	ICWLOOPTOP      	# check the next position


CHECKIFWINNERCOMP:         
addiu   $sp,$sp,-20         	# Save all these temp variables b4 jumping
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
sw      $t2,12($sp)
sw      $t3,16($sp)
jal     ROWISWON  # jump to this
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
lw      $t2,12($sp)
lw      $t3,16($sp)
addiu   $sp,$sp,20
blt     $zero,$s3,WINNEREXIT    # If row is won $s3 == 1, else 0

move 	$s3,$t2        		# load position back into $s3

addiu   $sp,$sp,-20        	# Save all these temp variables b4 jumping
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
sw      $t2,12($sp)
sw      $t3,16($sp)
jal     COLISWON  		# jump to this
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
lw      $t2,12($sp)
lw      $t3,16($sp)
addiu   $sp,$sp,20
blt     $zero,$s3,WINNEREXIT 	# If row is won $s3 == 1, else 0

move 	$s3,$t2        		# load position back into $s3

addiu   $sp,$sp,-20         	# Save all these temp variables b4 jumping
sw      $ra,0($sp)
sw      $t0,4($sp)
sw      $t1,8($sp)
sw      $t2,12($sp)
sw      $t3,16($sp)
jal     DIAGNOLISWON  		# jump to this
lw      $ra,0($sp)
lw      $t0,4($sp)
lw      $t1,8($sp)
lw      $t2,12($sp)
lw      $t3,16($sp)
addiu   $sp,$sp,20
blt     $zero,$s3,WINNEREXIT 	# If row is won $s3 == 1, else 0
j	ICWLOOPTOP  		# If none of these were valid jump to top
