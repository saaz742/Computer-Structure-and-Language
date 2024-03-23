# 1+x+x^2+ ...
.data
    on: .float 1.0
.text
main:
    li $v0,6  #read float (x)
    syscall

    li $v0,5  #read n
    syscall
    
    #move $f0,$t0    #$f0=x
    move $a1,$v0     #$a1=n 
    move $t1,$a1     # n in t1
 
    la $t6, on
    l.s $f4, ($t6)  #power result = 1
    l.s $f2, ($t6) #final result = 1
    jal loop	
   
loop:   
    jal Power
    add.s $f2,$f2,$f4  # final result += power result
    addi $t1,$t1,-1   #power--
    move $a1,$t1      #store new n
    la $t6, on         #f6 =1
    l.s $f4, ($t6)     #f4 = 1
    bgt $t1,0,loop     #jump if n =0

cal:     
    mov.s $f12,$f2   #move to print
    li $v0,2    #print
    syscall
       
    li $v0,10    #terminate
    syscall


Power: 
      addi $a1,$a1,-1 #n--
      mul.s $f4,$f4,$f0 #x*powerx 
      bgt $a1,0,Power  #jump if n=0
      jr $ra            #return