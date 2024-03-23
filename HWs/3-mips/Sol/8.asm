.text
#m
#n 
main:
again:			
	li $v0,5		#get n
	syscall 		
	
	add $s0,$v0,$zero	# $v0 =n 
	li $v0,5		# get m
	syscall 
	move $t5,$v0            #t5 = m

	slt	$t0,$s0,$zero	#if n < zero 
	beq	$t0,1,again	#get another number

	slti	$t0,$s0,2	#if n < 2, => n is the answer
	beq 	$t0,0,Continue1	#countinue
		
	li	$v0,1		#print the answer
	add 	$a0,$s0,$zero	
	syscall 		
	jal	terminate	#terminate

Continue1:
	addi	$t0,$zero,2	#$t0= n
	addi	$t1,$zero,1    #f1=1
	addi	$t2,$zero,1    #f2=1
	add	$t2,$t2,$t5	#f2 += m
check:
	addi	$t0,$t0,1	#$t0++
	mul     $t4,$t1,$t5    #mf(n-1)
	add	$t3,$t2,$t4	# f(n-2 )+ mf(n-1)
	add	$t1,$zero,$t2	#shift the number in register
	add	$t2,$zero,$t3	#shift the number in register
	bne	$t0,$s0,check	#if t0 = n or not
	
	li	$v0,1		#print a0
	add 	$a0,$t2,$zero	
	syscall 		

terminate:
   	li	$v0,10		#terminate
	syscall			

