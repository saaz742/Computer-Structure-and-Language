
nextshort: 
  move $v0, $zero		#make @v0 = 0
  lw $t0, nextshort 		#load value address
  addi $t0, $t0, 1 		#value++
  sw $t0, nextshort 		#store new value
  jr $ra