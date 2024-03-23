#word m(m-1)^(n-1)
.text
main:
    li $v0,5
    syscall

    move $t0,$v0
    li $v0,5
    syscall
    
    move $a0,$t0    #$a0=m
    move $a1,$v0     #$a1=n  
   
    move $a2,$a0      #store m
    addi $a1,$a1,-1  #n-1
    addi $a3,$a3,1    #power result
    addi $a0,$a0,-1	#m-1
    jal Power

cal:
    move $s0,$a3   
    move $a0,$s0
    mul $a0,$a0,$a2  #m*(power)
    li $v0,1    #print
    syscall
   
    
    li $v0,10  #terminate
    syscall

Power: 
      addi $a1,$a1,-1   #n--
      mul $a3,$a3,$a0  #m*power(m)
      bgt $a1,0,Power  
       jr $ra