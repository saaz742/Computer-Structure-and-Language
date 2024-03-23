#x = string => number.
#

.data 
x: .space 30

.text 
	li $v0,5            		#read a
	syscall
	move $a2,$v0        		# $a2 = a
	
	li $v0,5          	 	 #read b
	syscall
	move $a3,$v0           		# $a3 = b 
	
	li $v0,8            		 #read x
	la $a0,x
	li $a1,31         	  	 
	syscall
	
	li $t0,0 			#size
	la $t3,x 			# $t3 = x address	
		
push:
	lbu $a0,0($t3) 			#byte of x
	jal toNum 			#string to number
	
	addi $sp,$sp,-1 		#push
	sb $v0,0($sp)			#store byte
	addi $t0,$t0,1 			#characters++
	addi $t3,$t3,1 			#next byte
	lbu $a0,0($t3)			#load byte
	beq $a0,10,base 		
	j push         		

toNum:
	li $t2,58				
	slt $t1,$a0,$t2 		#if  0 < char < 9
	beq $t1,$zero,alphabet 	  	#else alphabet
	subi $v0,$a0,48            	#char - 48 = digit 
	jr $ra	
						
alphabet:
	li $t2,65			#A = 65
	slt $t1,$a0,$t2			 #if capital
	beq $t1,$zero,small
	subi $v0,$a0,55     		#to digit
	jr $ra	

small:
	subi $v0,$a0,87			#to digit
	jr $ra	
			
base:
	li $t3,1 			#base

pop:
	lbu $a0,0($sp) 			#pop
	addi $sp,$sp,1 			#byte++
	mul $t1,$a0,$t3			# $t1 = char * 10 ^i
	add $s2,$s2,$t1			# $t1 + last digits 
	mul $t3,$t3,$a2			 #new base
	subi $t0,$t0,1			#counter--
	beqz $t0,newbase
	j pop
	
newbase:
	divu $s2,$a3 			#decimal / b
	mfhi $a0 			#remainder
	mflo $s2 			#quatient
	jal newStr 			
	
	addi $s3,$s3,1 			#digit nember++
	addi $sp,$sp,-1 		#push
	sb $v0,0($sp)			#store byte
	beqz $s2,print
	j newbase	
																							
newStr:
	li $t2,10
	slt $t3,$a0,$t2 		#if 0 < char < 9
	bnez $t3,char
	addi $v0,$a0,87 		#alphabet + 87 = char
	jr $ra

char:
	addi $v0,$a0,48 		#make char (digit + 48 = char)
	jr $ra

print:		
	lbu $a0,0($sp)  		#get chars
	addi $sp,$sp,1			#digit number++
	li $v0,11 			#print chars
	syscall	
	
	ble  $s3,1,terminate
	j print
		
terminate:
	li $v0,10
	syscall	