#26 to 31 repalce b with 11 to 16 a
.data
na: .word 64512      #11 to 16 bits = 1 
nb: .word 2113929216 #26 to 31 bits = 1
endl:	.asciiz"\n"
.text
	li $v0,5           #read a
	syscall
	move $a0,$v0       #$a0 = a
	
	li $v0,5           #read b
	syscall
	move $a1,$v0       #$a1=b
	
	move $s0,$a1       #$s0 = b
	la $s6,nb
	lw $s4,0($s6)      #$s4 = nb
	move $s0,$a0       #$s0 = a
	la $s6,na
	lw $s5,0($s6)      #$s6 = na
	and $s1,$s0,$s5    #get 11 to 16 bits of a	
	not $s3,$s4        #not of nb
	and $s2,$a1,$s3    #26 to 31 of b = 0
	addu $a1,$s2,$s1   #replace 

	move $a0,$a1   #print  b
	li $v0,1
	syscall
	
	
	
