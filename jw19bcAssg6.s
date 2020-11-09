# ##################################################################
# Name:  Jonathan Wright                                           #
# Class: CDA3100                                                   #
# Assignment: 5                                                    #
# Description: This program will prompt the user to enter a list   #
# of integer values, one per line, and will stop once the user has #
# entered in a negative value. The negative value is a stop flag,  #
# not apart of any calculations. This program will print  print    # 
# the (1) sum, (2) minimum value, (3) maximum value, (4) mean, and #
# (5) variance.                                                    #
# ##################################################################


    .data
BOARD:  .word      0, 0, 0, 1, 1, 1, 2, 2, 2
WELCOMEUSER:    .asciiz     "Welcome to Tic-Tac-Toe\nI'll go first!\n"
ASKFORINPUT:    .asciiz     "Enter a position between 1 and 9\n"
EOL:    .byte       '\n'
    .text
    .globl main
main:

###### GET USER VALUES
li      $v0,4               #Ready the printer
la      $a0,WELCOMEUSER     #Load the welcome message
syscall                     #Print the welcome message


addiu   $sp,$sp,-4
sw      $ra,0($sp)
jal     PRINTBOARD
lw      $ra,0($sp)
addiu   $sp,$sp,4


addiu   $sp,$sp,-4
sw      $ra,0($sp)
jal     GETINPUT ### Saving input to $s0
lw      $ra,0($sp)
addiu   $sp,$sp,4

li  $v0,1                  # Print the input from the print input function
move  $a0,$s0
syscall

move $s3,$s0

addiu   $sp,$sp,-4
sw      $ra,0($sp)
jal     GETVALFROMPOSITION ### Passing position in $s3
lw      $ra,0($sp)
addiu   $sp,$sp,4

li  $v0,1                  # Print the input from the print input function
move  $a0,$s3
syscall
################ This block is just here for testing

 #li      $v0,4               #Ready the printer    
# la      $a0,WELCOMEUSER     #Load the welcome message
#syscall                     #Print the welcome message
jr		$ra					# Exit game

#### Input saved in $s0
GETINPUT:
addiu   $sp,$sp,-4
sw      $ra,0($sp)
jal     EVALUATEINPUT  # Jump to the validate input method
lw      $ra,0($sp)
addiu   $sp,$sp,4

jr		$ra				# jump out to $t0

EVALUATEINPUT:
li      $v0,4           # Ready the printer
la      $a0,ASKFORINPUT # Load ask user for input message
syscall                 # Ask the user for input
li  $v0,5               # Ready the integer reader
syscall                 # Read the integer
slt $a0,$v0,$zero        #if $v0 < $zero store a 1 in $a0
bne $a0,$zero,EVALUATEINPUT #if invalid input prompt again
li  $a1,9               #Store the upper bounds non inclusive
slt $a0,$v0,$a1         # if $v0 < 9 store a 1 in $a0
beq $a0,$zero,EVALUATEINPUT #if v0 > 9 go ask for new input
move $s0, $v0		    # Save the valid user input into $s0
jr		$ra					# jump to $ra

### PRINTS THE CURRENT GAMEBOARD TO THE CONSOLE
PRINTBOARD:
la $t0,BOARD
li $t1, 3           # range for inner and outer loops
li $t2,0            # outer loop counter


OuterLoop:
beq $t2,$t1, EXPRINTBOARD    #exit printboard after done printing
li $t3,0            # inner loop counter
addiu $t2,1         # increment outer loop counter

lb  $a0,EOL         # Print a new line
li  $v0,11          
syscall

InnerLoop:

beq $t3,$t1,OuterLoop #jump out to outer when done
addiu   $t3, 1      # incrememnt inner loop counter

li  $v0,1           # Print the data
lw  $a0, 0($t0)
syscall
addiu $t0,4         # increment address of t0 for the next print
j InnerLoop        

EXPRINTBOARD:
lb  $a0,EOL         # Print a new line
li  $v0,11          
syscall
jr  $ra


### DETERMINES IF LOCATION IS AVAILABLE
CHECKAVAILABLITY: 

### INSERTS THE VALUE INTO THE BOARD
UPDATEBOARD:


### CHECKS IF BOARD IS FULL
ISBOARDFULL:

### DETERMINES IF WIN, LOSS OR DRAW
GETSCORE:

### CHECKS IF ROW AT POSITION IS WON
ROWISWON:

### CHECKS IF COL AT POSITION IS WON
COLISWON:

### CHECKS IF DIAGNOL AT POSITION IS WON
DIAGNOLISWON:

### Takes the position 1 - 9, uses modulo and division 
### to get the row and col
### Assumes position is stored in $s3
GETVALFROMPOSITION:
la $t0,BOARD
addi $s3, -1    #decrement position by one because zero indexing is awesome
li   $a0, 3
div  $s3,$a0     #modulo is in Hi quot in Lo
mfhi $a1        #modulo now in $a1
mflo $a2        #quot now in $a2
mult $a0,$a2    #zero indexed row now stored in $lo
mflo $a0        # move back into $a0
add  $a0,$a0, $a1   #the column offset now added to $a0
li $a1, 4       # byte offset size
mult $a0, $a1   #mult by the byte offset size
mflo $a0        #move total offset into $a0
add  $t0,$t0,$a0 #t0 now indexed at the correct POSITION
lw  $s3, 0($t0)  # return the value back via $s3
jr  $ra


SETVALFROMPOSITION:

FINDHUMANMOVE:

FINDCOMPUTERMOVE:

IMMEDIATEHUMANWIN:

IMMEDIATECOMPUTERWIN:

RESTART:

INITIALIZE:
