.data
fileRead: .asciiz "input.txt" 
fileWrie: .asciiz "output.txt" 
textSpace: .space 1050     #space to store strings
firstStr: .space 100
secondStr: .space 20

.text
  main:
         li	$v0,8			#read string
        la	$a0, firstStr		
        li	$a1, 101		#maximum number of input char
	syscall				
	move	$t0,$a0  		

	li	$v0,8			#read sub
        la	$a0, secondStr		
        li	$a1, 101			
	syscall				
	move	$t1,$a0		        

openfileread:
	li	$v0, 13			#open  file
	li	$a1, 0			# file flag (read)
	la	$a0, fileRead		# load file name
	add	$a2, $zero, $zero    	# file mode (unused)
	syscall
	add	$s0,$zero,$v0		
	
	move	$a0, $v0		# load file descriptor
	li	$v0, 14			#read from file	
	la	$a1, textSpace		
	li	$a2, 1050		# number of bytes
	syscall  
	
closefile:	
	add	$a0,$zero,$s0		#Store  file descriptor
	li	$v0,16			#close file
	syscall

	la	$s0,textSpace		#textSpace
	
	
	lb	$a0,($s0)		#check if file is empty or not
	beq	$a0,$zero,end	
	move	$a2,$s0              
	move	$a3,$s1	
	
	lb	$a0,($s0)		#load file
	lb	$t4,($t0)		#load string
	move 	$t3,$zero		#position of same char

search:	
	sub 	$t2,$a0,$t4		#compare chars
	move 	$t5,$s0
	beq	$t2,$zero,flag
	bgt 	$t3,$zero,change
	beq	$a0,0,end
	move 	$s0,$t5
	addi	$s0,$s0,1		#next char
	lb	$a0,($s0)
	jal 	search
	
flag:	
	add $t3,$t3,$s0			#change flag
	add $t0,$t0,1			#next char
#	add $t9,$t9,1
	lb $t4,($t0)
	jal replace

change:
	#move	$s0,$zero
	sub	$s0,$s0,$t2		
	sub	$s0,$s0,1
	move	$t9,$zero

replace:			
	lb	$t6,($t1)		#load string
	sb	$t6,($s0)		#save string
	add	$s0,$s0,1		#next char
	add	$t1,$t1,1		#next char of str
	lb	$t6,($t1)		#load to compare
	bne	$t6,0,replace	
#	jal replace
																																																										
end:	
opensecondfile:
	li	$v0, 13		#open a file
	la	$a0, fileWrie   # load file name
	li	$a1, 1		# file flag (write)
	li	$a2, 0    
	syscall
	add	$s0,$zero,$v0	#save the ($vo)
	
write: 
        move	$a0, $v0
        li	$v0,15 		#write in file	
	la 	$a1,textSpace
	li 	$a2,1050
	syscall
	
clossecondefile:
	add	$a0,$zero,$s0	#Store  file 
	li	$v0,16		#close file
	syscall

	li	$v0,10		
	syscall			#exit


