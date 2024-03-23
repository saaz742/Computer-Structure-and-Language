.data
A: .space 64
B: .space 324

.text
    la     $t0,A 		#$t0 stores first address
    addi   $t1,$t0,64 		#$t1(49 * 4)
    addi   $t2,$zero,0         # number in each
    addi   $t3,$t3,-1		# number in each
    
makeA:
     sw   $t2,0($t0)		#inser first
     addi $t0,$t0,4		#go next
     sw   $t3,0($t0) 		#insert next num
     addi $t0,$t0,4 		#go next
     blt  $t0,$t1,makeA
                        
    la     $t3,B 		#$t0 stores first address
    addi   $t4,$t3,324 		#size
    addi   $t5,$t5,0		#number in each
    
makeB:
     sw  $t5,0($t3)		#insert 
     addi $t3,$t3,4		#go next
     blt  $t3,$t4,makeB
     jal reset         


	la $s0,A		#load
	la $s1,B
	add $t4,$t4,5		#counter

exchange:
	add $t4,$t4,-1 		#counter--
	la $s0,A		#load string address
	la $s1,B
       move $a1,$t4            #power
       move $a3,$zero		#clear
       move $a0,$zero   
       add $a3,$a3,2		#number to power (2)
       add $a0,$a0,2
       jal power
       
       move $t0,$a3    		# $t0 = 2^i
       addi $t0,$t0,-1		#(2^i)-1	
       move $a1,$t4		#power
       move $a3,$zero		#clear
       move $a0,$zero      
       add $a3,$a3,3		#number to power (3)
       add $a0,$a0,3
	jal power
	move $t1,$a3   		# $t1 = 3^i
	addi $t1,$t1,-1		#(3^i)-1
	mul $t0,$t0,4		#array * 4 for size
	mul $t1,$t1,4		#array * 4 for size
	add $s0,$s0,$t0 	#adsress of a
	lw $t2,($s0)		#value of a
	add $s1,$s1,$t1		#address of b 
	sw $t2,($s1)		#insert b
	bgt $t4,0,exchange

fin:
	la $s0,A		#load string address
	la $s1,B
	
	addi $s0,$s0,4	 	#adsress of a
	lw $t2,($s0)		#value of a
	addi $s1,$s1,8		#address of b 
	sw $t2,($s1)	
         j terminate
   
power: 
      addi $a1,$a1,-1   #n--
      mul $a3,$a3,$a0  #m*power(m)
      bgt $a1,0,power  
       jr $ra

reset:
      move $t0,$zero
      move $t1,$zero
      move $t2,$zero
      move $t3,$zero
      move $t4,$zero
 
      jr $ra
       
terminate: 
     li $v0,10
     syscall                    
        
