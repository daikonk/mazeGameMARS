.data
frameBuffer: 	.space 0x80000

grid:
	.ascii "# # # # # # # # # # # # # # # # # # # #\n"
	.ascii "# 0                         #         #\n"
	.ascii "#   # # # # # # # # #   #   #   #     #\n"
	.ascii "#         #             #   # # #   # #\n"
	.ascii "# # # #   #   # # # # # #   #         #\n"
	.ascii "#         #   #   #         #   # #   #\n"
	.ascii "#   # #   #   #   #   # # # #   #     #\n"
	.ascii "#     #           #             #   # #\n"
	.ascii "# #   # # # # #   # # # #   # # #     #\n"
	.ascii "#     #       #   #         #   # # # #\n"
	.ascii "#   # #   #   #   # # # #   #         #\n"
	.ascii "#         #   #   #         #   # #   #\n"
	.ascii "# # # # # #   #   #   # # # #   #     #\n"
	.ascii "#   #         #   #     #       #   # #\n"
	.ascii "#       #   # #   # #   #   # # #     #\n"
	.ascii "#   # # #   #           #   #   # #   #\n"
	.ascii "#   #       # # # # # # #   #         #\n"
	.ascii "#   # # # # #   #       #   #   # # # #\n"
	.ascii "#                   #       #     Y X #\n"
	.ascii "# # # # # # # # # # # # # # # # # # # #\n"


#test1:		.asciiz "LOOP2\n"			178	
#test2:		.asciiz "LOOP1\n"

wasdToMove: 	.asciiz "\n\n\nINPUT WASD TO MOVE: "
userPos: 	.asciiz "\nPOS : "
keyInventory: 	.asciiz "\nKEYS IN INVENTORY : "
xTrue: 		.asciiz "X  "
yTrue: 		.asciiz "Y"
space: 		.asciiz " "
lineBreak:	.asciiz "\n"
beginSplashScreen:	.ascii "Collect keys in order to open the doors at the end of the maze. The keys are a light green and \n"
			.ascii "purple while the doors are a dark green and purple. Collect the keys to open the door and reach\n"
			.ascii "the end of the maze. \n\n\n"
			.ascii "USE WASD TO MOVE + M FOR MENU SELECTION\n\n"
			.asciiz "Press any key to continue: "

xLoc:		.word 0
yLoc:		.word 0
deadVal:	.word 0
pos: 		.word 1, 1
newPos:		.word 0, 0
keyVal: 	.word 0, 0
doMove:		.word 0
lastPos:	.word 0x10090360
menuArray:	.word 0, 0, 0
gameComplete:	.asciiz "YOU WIN!"

.text	
main:

	la $a0, beginSplashScreen
	li $v0, 4
	syscall

	li $v0, 12
	syscall

	jal initGrid
	
	while:						#  MAIN LOOP FOR THE GAME
		beq $s1, 'q', gameWon			#  this was the quit condition before Menu function was added
		beq $s2, 1, gameWon			#  $s2 is a boolean as to whether the player piece has reached the end point 
		
		la $a0, grid				# $s0 becomes global reg for grid address
		# li $v0, 4
		# syscall
		move $s0, $a0
		
		# la $a0, wasdToMove	
		# li $v0, 4
		# syscall
		li $v0, 12				# checks for key press, wasd and m
		syscall
		move $s1, $v0
		
		jal Move
		
		jal updateGrid
		
		# la $a0, userPos			# all this commented code I left in, this was my inital UI for the game
		# li $v0, 4
		# syscall

		# la $t0, pos		
		# li $v0, 1		
		# lw $a0, ($t0)		
		# syscall
		# la $a0, space
		# li $v0, 4
		# syscall
		# li $v0, 1
		# lw $a0, 4($t0)
		# syscall
		
		# la $a0, keyInventory 	
		# li $v0, 4
		# syscall
		
		# la $t0, keyVal
		# lw $t1, ($t0)
		# lw $t2, 4($t0)
		
		# blt $t1, 1, xSkip	
		# la $a0, xTrue
		# li $v0, 4
		# syscall
		# xSkip:
		
		# blt $t2, 1, ySkip	
		# la $a0, yTrue
		# syscall
		# ySkip:
		
		# la $a0, lineBreak
		# li $v0, 4
		# syscall
		# li $v0, 4
		# syscall
		
		la $t0, pos				# checks the position of the player to see if they have gotten to the end
		lw $t1, ($t0)
		lw $t2, 4($t0)
		bne $t1, 18, noWin	
		bne $t2, 18, noWin
		addi $s2, $zero, 1
		noWin:
		
		j while
		
		
Move:
	la $t0, doMove					# intiallizes the doMove boolean with false
	sw $zero, ($t0)
	
	la $t0, newPos
	lw $t1, ($t0)
	lw $t2, 4($t0)
	la $t3, pos
	lw $t4, ($t3)
	lw $t5, 4($t3)
	
	bne $s1, 'w', wSkip				# The following branch statements make up a switch statement to test the	
	addi $t1, $t4, 0				# user input. We test whether the input was to move the character or not
	subi $t2, $t5, 1				# i.e, m would not result in a movement in the player
	lw $t6, doMove
	addi $t6, $zero, 1
	sw $t6, doMove
	wSkip:
	
	bne $s1, 'a', aSkip
	subi $t1, $t4, 1
	addi $t2, $t5, 0
	lw $t6, doMove
	addi $t6, $zero, 1
	sw $t6, doMove
	aSkip:
	
	bne $s1, 's', sSkip
	addi $t1, $t4, 0
	addi $t2, $t5, 1
	lw $t6, doMove
	addi $t6, $zero, 1
	sw $t6, doMove
	sSkip:
	
	bne $s1, 'd', dSkip
	addi $t1, $t4, 1
	addi $t2, $t5, 0
	lw $t6, doMove
	addi $t6, $zero, 1
	sw $t6, doMove
	dSkip:
	
	bne $s1, 'm', mSkip				# deals with stack pointer and saves important variables and $ra address
	addi $sp, $sp, -4				# to the stack, then unpacks it after the embedded function executes
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	addi $sp, $sp, -4
	sw $t2, 0($sp)
	addi $sp, $sp, -4
	sw $t3, 0($sp)
	addi $sp, $sp, -4
	sw $t4, 0($sp)
	addi $sp, $sp, -4
	sw $t5, 0($sp)
	jal Menu
	lw $t5, 0($sp)
	addi $sp, $sp, 4
	lw $t4, 0($sp)
	addi $sp, $sp, 4
	lw $t3, 0($sp)
	addi $sp, $sp, 4
	lw $t2, 0($sp)
	addi $sp, $sp, 4
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	mSkip:
	
	addi $t6, $zero, 0
	move $s6, $t1
	move $s7, $t2
	
	sll $t1, $t1, 1					# gets char at newPos in grid and stores to $t6
	mul $t2, $t2, 40				# $t1 stores newPos in grid address
	add $t1, $t1, $t2
	add $t1, $t1, $s0
	lb $t6, ($t1)
	
	sll $t4, $t4, 1					# gets char at pos in grid and stores to $t7
	mul $t5, $t5, 40				# $t4 stores pos in grid address
	add $t4, $t4, $t5
	add $t4, $t4, $s0
	lb $t7, ($t4)
	
	li $t9, 1
	la $t8, keyVal
	lw $s3, ($t8)
	lw $s4, 4($t8)
	bne $t6, 'x', xxSkip
	sw $t9, ($t8)
	j moveOn
	xxSkip:
	bne $t6, 'X', XSkip
	bne $s3, 1, XSkip
	sw $zero, ($t8)
	j moveOn
	XSkip:
	bne $t6, 'y', yySkip
	sw $t9, 4($t8)
	j moveOn
	yySkip:
	bne $t6, 'Y', YSkip
	bne $s4, 1, YSkip
	sw $zero, 4($t8)
	j moveOn
	YSkip:
	bne $t6, ' ', switch2exit			# if char at newPos is ' ', set newPos to player and pos to ' '
	moveOn:
	li $t8, ' '
	sb $t8, ($t4)
	sb $t7, ($t1)
	la $t0, pos
	sw $s6, ($t0)
	sw $s7, 4($t0)
	switch2exit:
	
	
	addi $t0, $zero, 0
	addi $t1, $zero, 0
	addi $t2, $zero, 0
	addi $t3, $zero, 0
	addi $t4, $zero, 0
	addi $t5, $zero, 0
	addi $t6, $zero, 0
	addi $t7, $zero, 0
	addi $t8, $zero, 0
	addi $t9, $zero, 0
	addi $s3, $zero, 0
	addi $s4, $zero, 0
	addi $s6, $zero, 0
	addi $s7, $zero, 0
	
	jr $ra
	
Menu:

	la $t1, menuArray
	li $t2, 1
	sw $t2, 0($t1)
	lOop:
	
		addi $sp, $sp, -4			# the first thing that needs to be updated when the menu is selected	
		sw $ra, 0($sp)				# is the menu buttons, so initGrid is executed
		addi $sp, $sp, -4
		sw $t1, 0($sp)
		jal updateGrid
		lw $t1, 0($sp)
		addi $sp, $sp, 4
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		la $t3, menuArray			# Here I did not need to use characters or anything except a simple
		li $v0, 12				# array to represent my data, as this feature was added after I started
		syscall					# implementing the bitmap display. Basic inputs for menu select
		move $t0, $v0
		
		bne $t0, 'a', notA
		lw $t2, 0($t3)
		beq $t2, 1, notA
		lw $t4, 0($t1)
		addi $t4, $zero, 0
		sw $t4, 0($t1)
		addi $t1, $t1, -4
		lw $t4, 0($t1)
		addi $t4, $zero, 1
		sw $t4, 0($t1)
		notA:
		
		bne $t0, 'd', notD
		lw $t2, 8($t3)
		beq $t2, 1, notD
		lw $t4, 0($t1)
		addi $t4, $zero, 0
		sw $t4, 0($t1)
		addi $t1, $t1, 4
		lw $t4, 0($t1)
		addi $t4, $zero, 1
		sw $t4, 0($t1)
		notD:
		
		bne $t0, 'e', notE			# if e is the input, this excerpt will execute a command based on what
		bne $t1, $t3, notFirst			# option is highlighted. (or is a "1" in menuArray).
		j exitlOop
		notFirst:
		
		addi $t3, $t3, 4
		bne $t1, $t3, notSecond
		j reset
		notSecond:
		
		addi $t3, $t3, 4
		bne $t1, $t3, notThird
		j exit
		notThird:
		
		notE:
		
		# li $v0, 1				# more test code to see what my array was looking like, a short
		# lw $a0, 0($t3)			# and easy text based representation before I started on bitmap
		# syscall
		# lw $a0, 4($t3)
		# syscall
		# lw $a0, 8($t3)
		# syscall
		
		
		j lOop
		
	exitlOop:
	li $t2, 0
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	
	jr $ra
	
updateGrid:

	lw $t0, lastPos
	li $t1, 0x00000000
	sw $t1, 0($t0)
	
	la $t0, frameBuffer
	la $t1, grid
	li $t2, 20
	loOp1:
		li $t3, 20
		loOp2:
			lb $t4, 0($t1)
			bne $t4, '0', NOTPLAYER
			li $t5, 0x00f44336
			sw $t5, 0($t0)
			sw $t0, lastPos
			NOTPLAYER:
			addi $t1, $t1, 2
			addi $t0, $t0, 4
			addi $t3, $t3, -1
			bnez $t3, loOp2
		
		addi $t2, $t2, -1
		addi $t0, $t0, 48
		bnez $t2, loOp1
		
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal testIfKeysAquired
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	la $t0, menuArray
	lw $t1, 0($t0)
	lw $t2, 4($t0)
	lw $t3, 8($t0)
	
	
	
	beqz $t1, mContinue				# highlights the button that is currently being selected using menuArray
	la $t4, frameBuffer
	li $t5, 0x0000ff00
	li $t6, 3088
	add $t4, $t4, $t6
	sw $t5, 132($t4)
	sw $t5, 136($t4)
	sw $t5, 260($t4)
	sw $t5, 264($t4)
	la $t4, frameBuffer
	li $t5, 0x00a9a9a9
	li $t6, 3128
	add $t4, $t4, $t6
	sw $t5, 128($t4)
	sw $t5, 132($t4)
	sw $t5, 136($t4)
	sw $t5, 140($t4)
	sw $t5, 256($t4)
	sw $t5, 260($t4)
	sw $t5, 264($t4)
	sw $t5, 268($t4)
	mContinue:
	
	beqz $t2, mReset
	la $t4, frameBuffer
	li $t5, 0x00ffff00
	li $t6, 3128
	add $t4, $t4, $t6
	sw $t5, 128($t4)
	sw $t5, 132($t4)
	sw $t5, 136($t4)
	sw $t5, 140($t4)
	sw $t5, 256($t4)
	sw $t5, 260($t4)
	sw $t5, 264($t4)
	sw $t5, 268($t4)
	la $t4, frameBuffer
	li $t5, 0x00a9a9a9
	li $t6, 3088
	add $t4, $t4, $t6
	sw $t5, 132($t4)
	sw $t5, 136($t4)
	sw $t5, 260($t4)
	sw $t5, 264($t4)
	la $t4, frameBuffer
	li $t5, 0x00a9a9a9
	li $t6, 3168
	add $t4, $t4, $t6
	sw $t5, 132($t4)
	sw $t5, 136($t4)
	sw $t5, 260($t4)
	sw $t5, 264($t4)
	mReset:
	
	beqz $t3, mExit
	la $t4, frameBuffer
	li $t5, 0x00ff0000
	li $t6, 3168
	add $t4, $t4, $t6
	sw $t5, 132($t4)
	sw $t5, 136($t4)
	sw $t5, 260($t4)
	sw $t5, 264($t4)
	la $t4, frameBuffer
	li $t5, 0x00a9a9a9
	li $t6, 3128
	add $t4, $t4, $t6
	sw $t5, 128($t4)
	sw $t5, 132($t4)
	sw $t5, 136($t4)
	sw $t5, 140($t4)
	sw $t5, 256($t4)
	sw $t5, 260($t4)
	sw $t5, 264($t4)
	sw $t5, 268($t4)
	mExit:
	
	bnez $t1, Cont
	bnez $t2, Cont
	bnez $t3, Cont
	la $t4, frameBuffer
	li $t5, 0x00a9a9a9
	li $t6, 3088
	add $t4, $t4, $t6
	sw $t5, 132($t4)
	sw $t5, 136($t4)
	sw $t5, 260($t4)
	sw $t5, 264($t4)
	Cont:
	
	
	jr $ra
	
initGrid:

	li $t3, -1					# This code randomly places the keys into the 2d ascii array
	li $t4, 1
	whilE2:
	li $v0, 42
	li $a1, 177
	beq $t4, 1, ignoreMe
	addi $a1, $a1, -1
	ignoreMe:
	syscall
	
	li $t2, 0
	la $t0, grid
	whilE:
	lb $t1, 0($t0)
	bne $t1, ' ', skip
	addi $t2, $t2, 1
	bne $t2, $a0, skip
	bne $t4, 1, setY
	li $t5, 'x'
	sb $t5, 0($t0)
	sw $t0, xLoc
	addi $t4, $t4, 1
	j whilE2
	setY:
	li $t5, 'y'
	sb $t5, 0($t0)
	sw $t0, yLoc
	j exitLooP
	skip:
	addi $t0, $t0, 2
	j whilE
	exitLooP:


	la $t0, frameBuffer
	la $t3, grid
	li $t4, 400
	
	loop2:
	
		li $t5, 20
		loop1:
		
			lb $a0, 0($t3)			# prints different colors for things that are not empty spaces in the grid
			bne $a0, '#', notWall
			li $t2, 0x00d3d3d3
			sw $t2, 0($t0)
			notWall:
			bne $a0, '0', notPlayer
			li $t2, 0x00f44336
			sw $t2, 0($t0)
			sw $t0, lastPos
			notPlayer:
			bne $a0, 'x', notXKey
			li $t2, 0x0093c47d
			sw $t2, 0($t0)
			notXKey:
			bne $a0, 'y', notYKey
			li $t2, 0x008e7cc3
			sw $t2, 0($t0)
			notYKey:
			bne $a0, 'X', notXDoor
			li $t2, 0x0038761d
			sw $t2, 0($t0)
			notXDoor:
			bne $a0, 'Y', notYDoor
			li $t2, 0x00351c75
			sw $t2, 0($t0)
			notYDoor:
			addi $t3, $t3, 2
			addi $t0, $t0, 4
			addi $t4, $t4, -1
			addi $t5, $t5, -1
			bnez $t5,  loop1
			
		li $t2, 0x00a9a9a9			# this part (and loop 3) fills the space to the right outside of the actual game area with grey
		li $t6, 12
		
		loop3:
		sw $t2, 0($t0)
		addi $t0, $t0, 4
		addi $t6, $t6, -1
		bnez $t6, loop3
		
	bnez $t4, loop2
	
	li $t6, 384
	loop4:						# continues to fill the rest of the board with grey (everything below the game area)
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	addi $t6, $t6, -1
	bnez $t6, loop4
	
	la $t0, frameBuffer				# prints all objects to bitmap, buttons and key displays
	li $t1, 0x0038761d
	li $t2, 608
	add $t0, $t0, $t2
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 128($t0)
	sw $t1, 140($t0)
	sw $t1, 256($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 384($t0)
	sw $t1, 388($t0)
	sw $t1, 392($t0)
	
	la $t0, frameBuffer
	li $t1, 0x00351c75
	li $t2, 1760
	add $t0, $t0, $t2
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 128($t0)
	sw $t1, 132($t0)
	sw $t1, 140($t0)
	sw $t1, 256($t0)
	sw $t1, 268($t0)
	sw $t1, 384($t0)
	sw $t1, 388($t0)
	sw $t1, 392($t0)
	sw $t1, 396($t0)
	
	la $t0, frameBuffer
	li $t1, 0x00d3d3d3
	li $t2, 3128
	add $t0, $t0, $t2
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 124($t0)
	sw $t1, 144($t0)
	sw $t1, 252($t0)
	sw $t1, 272($t0)
	sw $t1, 384($t0)
	sw $t1, 388($t0)
	sw $t1, 392($t0)
	sw $t1, 396($t0)
	
	la $t0, frameBuffer
	li $t1, 0x00d3d3d3
	li $t2, 3088
	add $t0, $t0, $t2
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 128($t0)
	sw $t1, 140($t0)
	sw $t1, 256($t0)
	sw $t1, 268($t0)
	sw $t1, 388($t0)
	sw $t1, 392($t0)
	
	la $t0, frameBuffer
	li $t1, 0x00d3d3d3
	li $t2, 3168
	add $t0, $t0, $t2
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 128($t0)
	sw $t1, 140($t0)
	sw $t1, 256($t0)
	sw $t1, 268($t0)
	sw $t1, 388($t0)
	sw $t1, 392($t0)

	jr $ra
	
testIfKeysAquired:

	la $t0, keyVal					# fills in the key slots if the keys are in the player's inventory
	lw $t3, 0($t0)
	lw $t4, 4($t0)

	beqz $t3, skiP
	la $t0, frameBuffer
	li $t1, 0x0093c47d
	li $t2, 740
	add $t0, $t0, $t2
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 128($t0)
	j dontFill
	skiP:
	la $t0, frameBuffer
	li $t1, 0x00a9a9a9
	li $t2, 740
	add $t0, $t0, $t2
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 128($t0)
	
	dontFill:
	beqz $t4, skIp
	la $t0, frameBuffer
	li $t1,0x008e7cc3
	li $t2, 1896
	add $t0, $t0, $t2
	sw $t1, 0($t0)
	sw $t1, 124($t0)
	sw $t1, 128($t0)
	j DontFill
	skIp:
	la $t0, frameBuffer
	li $t1,0x00a9a9a9
	li $t2, 1896
	add $t0, $t0, $t2
	sw $t1, 0($t0)
	sw $t1, 124($t0)
	sw $t1, 128($t0)
	
	DontFill:

	jr $ra

reset:
	la $t0, pos
	lw $t1, 0($t0)
	lw $t2, 4($t0)
	sll $t1, $t1, 1
	mul $t2, $t2, 40
	add $t1, $t1, $t2
	la $t0, grid
	add $t0, $t0, $t1
	li $t1, ' '
	sb $t1, 0($t0)

	li $t1, '0'					# when the player selects the reset button, the following resets the grid
	sb $t1, 42($s0)					# data to its initial state
	li $t1, 'Y'
	sb $t1, 1552($s0)
	li $t1, 'X'
	sb $t1, 1556($s0)
	li $t1, ' '
	lw $t0, xLoc
	sb $t1, 0($t0)
	lw $t0, yLoc
	sb $t1, 0($t0)
	
	
	li $t1, 0
	li $t2, 1
	
	la $t0, pos
	sw $t2, 0($t0)
	sw $t2, 4($t0)
	
	la $t0, newPos
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	la $t0, keyVal	
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	la $t0, doMove
	sw $t1, 0($t0)

	
	la $t0, menuArray
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	
	li $t1,	0x10090360
	la $t0, lastPos 
	sw $t1, 0($t0)
	
	addi $sp, $sp, 28
	
	li $t1, 1024				
	la $t0, frameBuffer
	li $t2, 0x00000000
	
	resetLoop:
	
		sw $t2, 0($t0)
		addi $t1, $t1, -1
		addi $t0, $t0, 4
		
	bnez $t1, resetLoop
	
	la $a0, lineBreak
	li $v0, 4
	syscall
	syscall
	
	j main

gameWon:						# game end screen (if won)

	li $t1, 1024				
	la $t0, frameBuffer
	li $t2, 0x008b0000
	
	endUILoop:
	
		sw $t2, 0($t0)
		addi $t1, $t1, -1
		addi $t0, $t0, 4
		
	bnez $t1, endUILoop
	
	la $t0, frameBuffer				# trophy creation (THIS TOOK ALOT OF MATH AND TIME)
	li $t2, 0x00c78c00
	li $t1, 780
	mul $t1, $t1, 4
	add $t0, $t0, $t1
	sw $t2, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t2, 12($t0)
	sw $t2, 16($t0)
	sw $t2, 20($t0)
	sw $t2, 24($t0)
	sw $t2, 28($t0)
	
	la $t0, frameBuffer
	li $t2, 0x00dfa803
	li $t1, 275
	mul $t1, $t1, 4
	add $t0, $t0, $t1
	sw $t2, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 84($t0)
	sw $t2, 88($t0)
	sw $t2, 92($t0)
	sw $t2, 208($t0)
	sw $t2, 336($t0)
	sw $t2, 468($t0)
	sw $t2, 600($t0)
	sw $t2, 604($t0)
	sw $t2, 128($t0)
	sw $t2, 132($t0)
	sw $t2, 136($t0)
	sw $t2, 140($t0)
	sw $t2, 144($t0)
	sw $t2, 148($t0)
	sw $t2, 256($t0)
	sw $t2, 260($t0)
	sw $t2, 276($t0)
	sw $t2, 380($t0)
	sw $t2, 384($t0)
	sw $t2, 388($t0)
	sw $t2, 404($t0)
	sw $t2, 504($t0)
	sw $t2, 508($t0)
	sw $t2, 512($t0)
	sw $t2, 516($t0)
	sw $t2, 528($t0)
	sw $t2, 628($t0)
	sw $t2, 632($t0)
	sw $t2, 636($t0)
	sw $t2, 640($t0)
	sw $t2, 644($t0)
	sw $t2, 648($t0)
	sw $t2, 652($t0)
	sw $t2, 652($t0)
	sw $t2, 752($t0)
	sw $t2, 756($t0)
	sw $t2, 760($t0)
	sw $t2, 764($t0)
	sw $t2, 876($t0)
	sw $t2, 880($t0)
	sw $t2, 884($t0)
	sw $t2, 888($t0)
	sw $t2, 1008($t0)
	sw $t2, 1012($t0)
	sw $t2, 1136($t0)
	sw $t2, 1140($t0)
	sw $t2, 1264($t0)
	sw $t2, 1268($t0)
	sw $t2, 1392($t0)
	sw $t2, 1396($t0)
	sw $t2, 1520($t0)
	sw $t2, 1524($t0)
	sw $t2, 1648($t0)
	sw $t2, 1652($t0)
	sw $t2, 1776($t0)
	sw $t2, 1780($t0)
	sw $t2, 1904($t0)
	sw $t2, 1908($t0)
	
	la $t0, frameBuffer
	li $t2, 0x00faebd7
	li $t1, 267
	mul $t1, $t1, 4
	add $t0, $t0, $t1
	sw $t2, 0($t0)
	sw $t2, 112($t0)
	sw $t2, 136($t0)
	sw $t2, 140($t0)
	sw $t2, 144($t0)
	sw $t2, 260($t0)
	sw $t2, 264($t0)
	sw $t2, 388($t0)
	sw $t2, 516($t0)
	
	la $t0, frameBuffer
	li $t2, 0x00f7bd02
	li $t1, 268
	mul $t1, $t1, 4
	add $t0, $t0, $t1
	sw $t2, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t2, 12($t0)
	sw $t2, 16($t0)
	sw $t2, 20($t0)
	sw $t2, 24($t0)
	sw $t2, 124($t0)
	sw $t2, 128($t0)
	sw $t2, 144($t0)
	sw $t2, 148($t0)
	sw $t2, 152($t0)
	sw $t2, 252($t0)
	sw $t2, 264($t0)
	sw $t2, 268($t0)
	sw $t2, 272($t0)
	sw $t2, 276($t0)
	sw $t2, 280($t0)
	sw $t2, 380($t0)
	sw $t2, 388($t0)
	sw $t2, 392($t0)
	sw $t2, 396($t0)
	sw $t2, 400($t0)
	sw $t2, 404($t0)
	sw $t2, 508($t0)
	sw $t2, 516($t0)
	sw $t2, 520($t0)
	sw $t2, 524($t0)
	sw $t2, 528($t0)
	sw $t2, 636($t0)
	sw $t2, 640($t0)
	sw $t2, 644($t0)
	sw $t2, 648($t0)
	sw $t2, 652($t0)
	sw $t2, 772($t0)
	sw $t2, 776($t0)
	
	la $a0, lineBreak
	li $v0, 4
	syscall
	
	la $a0, gameComplete
	syscall
	
	la $a0, lineBreak
	syscall
	
	li $v0, 12
	syscall
	
	j exit

exit:							# end screen if the player quit

	li $t1, 1024				
	la $t0, frameBuffer
	li $t2, 0x00000000

	endUILoop2:
	
		sw $t2, 0($t0)
		addi $t1, $t1, -1
		addi $t0, $t0, 4
		
	bnez $t1, endUILoop2
	
	li $v0, 10
	syscall
