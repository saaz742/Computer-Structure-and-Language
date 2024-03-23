.data
firstStr: .space 100
secondStr: .space 20
noMatch: .ascii "no match found"
.text
        li	$v0,8			#read string
        la	$a0, firstStr		
        li	$a1, 101		#maximum number of input char
	syscall				
	move	$s0,$a0  		#$s0 = first of string addres 

	li	$v0,8			#read sub
        la	$a0, secondStr		
        li	$a1, 21			
	syscall				
	move	$s1,$a0		        #$s0 = first of string addres
	
	move	$a2,$s0              
	move	$a3,$s1	
	jal	load			#call subroutine
	
	move	$a0,$v0			#$a0 = result
	li	$v0,1			#print
	syscall
	
	li	$v0,10			#terminate
	syscall				
		
load:
	move	$t9,$ra			#$t9 = $ra
	move	$t0,$a2			#$t0 = address of first string  
	move	$s2,$zero		#string lenght

strLenghth:
	lb	$a0,($t0)		#first str
	beq	$a0,10,finstr		#if enter 
	beq	$a0,0,finstr		#if noting
	addi	$t0,$t0,1		#next char
	addi	$s2,$s2,1		#counter++
	jal	strLenghth			

finstr:
	move $a0,$zero			#reset
	move $t0,$zero			#reset
	move $t0,$a3			#second string address
	move $s3,$zero			#string lenght

subLenght:
	lb	$a0,($t0)		#second str
	beq	$a0,10,finsub		#if enter
	beq	$a0,0,finsub		#if noting
	addi	$t0,$t0,1		#next char
	addi	$s3,$s3,1		#counter++
	jal	subLenght			

finsub:
	move $a0,$zero			#reset
	move $t0,$zero			#reset
	
start:
	move	$t2,$s2
	move	$t1,$s3
	sub	$t2,$t2,$t1     		 #str lenght - substr lenght
	move	$t1,$t2
	add	$t1,$t1,1
	add	$t0,$zero,-1			#first time we add it one more time

searchStr:
	add	$t0,$t0,1			#first str
	beq	$t0,$t1,notEqual		#if end Of sub
	move	$t2,$zero			#t2 is count of same char
	move	$t3,$zero			#t3 sub
	
SearchSub:	
	beq	$t3,$s3,endSearchSub		#if end of sub
	add	$t4,$a3,$t3			#index of sub	
	add	$t5,$a2,$t0                    #index t0+t3 of Str
	add	$t5,$t5,$t3
	lb	$a0,($t4)			#char of sub
	lb	$a1,($t5)			#char of str
	bne	$a0,$a1,resume			#if two char is equal
	addi	$t2,$t2,1			#counter++

resume:	
	addi	$t3,$t3,1                       #next str
	jal	SearchSub

endSearchSub:	
	bne	$t2,$s3,searchStr
	move	$v0,$t0				#pos in $v0
	move	$ra,$t9				
	jr	$ra				#return
		
notEqual:
	la $a0, noMatch				#print no match
	li $v0, 4
	syscall

li	$v0,10			#terminate
	syscall	
