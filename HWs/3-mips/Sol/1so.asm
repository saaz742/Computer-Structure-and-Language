#y ^((x^y)&(x<y)) 
#y -((x-y)*(X<y))
#bigger
.text
	li $v0, 5     #read first
	syscall
	move $a0,$v0  #put in a0
	
	li $v0,5       #read second
	syscall
	move $a1,$v0   #put in a1
	
	slt $a2,$a1,$a0 #(x<y)
	sub $a3,$a1,$a0 #(x^y)
	mul $t0,$a2,$a3 #(x^y)&(x<y)
	sub $t2,$a1,$t0 #y ^((x^y)&(x<y))
	
	move $a0,$t2    #print result
	li $v0,1
	syscall
	
	