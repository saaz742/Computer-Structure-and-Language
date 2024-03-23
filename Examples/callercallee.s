.text
	la $a0,msg1	# psuedo instruction
	addi $v0,$zero,4
	syscall
	
	addi $v0,$zero,5
	syscall
	add $s0,$v0,$zero	# first number
							
	la $t0,n1
#	lw $a0,0($t0)	# $a0=n1
	lw $a1,4($t0)	# $a1=n2
	lw $a2,8($t0)	# $a2=n3
	add $a0,$s0,$zero	# $a0=first number
	jal add3
	la $t0,sum
	sw $v0,0($t0)	# save result
	
	add $a0,$v0,$zero
	addi $v0,$zero,1
	syscall			# print result
	
	addi $v0,$zero,10
	syscall			# terminate

# adds a0,a1,a2
# result in v0
add3:	# caller
	
	sw $ra,-4($sp)
	addi $sp,$sp,-4		# push $ra
	jal add2		# $v0=n1+n2
	lw $ra,0($sp)
	addi $sp,$sp,4		# pop $ra
	
	sw $a0,-4($sp)		# push $a0
	sw $a1,-8($sp)		# push $a1
	sw $ra,-12($sp)		# push $ra
	addi $sp,$sp,-12	# update $sp
	add $a0,$v0,$zero	# $a0=n1+n2
	add $a1,$a2,$zero	# $a1=n3
	jal add2		# $v0=(n1+n2)+n3
	lw $ra,0($sp)		# pop $ra
	lw $a1,4($sp)
	lw $a0,8($sp)
	addi $sp,$sp,12		# update $sp
		
	jr $ra

# adds a0 and a1
# result in v0
add2:	# callee
	add $v0,$a0,$a1
	jr $ra

.data
msg1:	.asciiz "Please enter an integer: "
n1:	.word 12
n2:	.word 2
n3:	.word 3
sum:	.space 4	# allocate 4 bytes