.globl __start

.data
list: .space 1000
listsz: .word 250
endl:	.asciiz"\n"
.text			

__start:
	li $v0, 5		#get n
	syscall			
		
	lw $s0,listsz          #loat list
	la $s1,list						
	move $t0, $v0		#t0 =n
	move $t2, $0		#t2 =0 counter	
	jal loop		

        move $t4,$t2         #counte
        lw $s0,listsz        #loat list
	la $s1,list	
        jal var
	li $v0, 10		#syscall to terminate program
	syscall
	
	
loop: 	
        add $t2,$t2,1		#t2++
	li $v0, 5		#get numbers
	syscall
	
	sw $v0,($s1)           #save data in array
	addi $s1,$s1,4          #go to next
	add $t1,$t1, $v0	#get sum t1 += v0 (new input)
	sub $t0,$t0,1		#t0-- (n)
	bgt $t0,0,loop		#if n<=0 continue
				
avg:	div $t3,$t1,$t2		#$t3 =( $t1 (sum) / $t2 (num of integers))
	move $a0, $t3		#$a0 =$t3
	li $v0, 1		#prints integer
	syscall
	
	la $a0, endl		#print new line
	li $v0, 4
	syscall
	jr $ra			#return to address

var:     #var = (x1- av)^2+(x2-av)^2+...  
        lw $t5,($s1)          #get input from array (numbers)
        sub $t5,$t5,$t3       #number - average
        mul $t5,$t5,$t5       #$t5 =(number - average)^2
       	add $t6,$t6,$t5       # var += $t5 
       	addi $s1,$s1,4        #next home of array
       	addi $t4,$t4,-1       #counter--
        bgt $t4,0,var
cal:
        div $t6,$t6,$t2       #var / n
        move $a0,$t6
        li $v0,1             #print
        syscall   
        jr $ra