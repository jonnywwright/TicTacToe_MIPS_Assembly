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
ARRAY:  .space      36
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
jal     GETINPUT
lw      $ra,0($sp)
addiu   $sp,$sp,4

li  $v0,1
move  $a0,$s0
syscall

# li      $v0,4               #Ready the printer
# la      $a0,WELCOMEUSER     #Load the welcome message
# syscall                     #Print the welcome message
jr		$ra					# Exit game


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



