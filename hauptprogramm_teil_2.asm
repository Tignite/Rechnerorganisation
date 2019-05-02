    .text
    .globl main
main:
    addiu $sp,  $sp, -4      # reserve stack space for 1 register
    sw    $ra,  0($sp)       # save return address on stack
    move  $fp,  $sp          # set $fp = $sp
    li    $a0,  62           # set $a0 = '>' (ASCII char)
    li    $v0,  11           # set $v0 = index of system call "print_char"
    syscall                  # print on console: '>'
    li    $v0,  5            # set $v0 = index of system call "read_int"
    syscall                  # read integer value n from console
    bgtz  $v0,  validn       # goto validn if n > 0
    li    $v0,  1            # enforce n > 0
validn:
    li    $t1,  4            # set $t1 = 4
    mul   $t1,  $t1, $v0     # set $t1 = 4 * n
    subu  $sp,  $sp, $t1     # reserve stack space for vector V
    move  $a0,  $v0          # set $a0 = n
    move  $a1,  $sp          # set $a1 = address of vector V
    jal   algorithm          # call algorithm(n, V)
    move  $t0,  $sp          # set $t0 = address of vector V
output:
    lw    $a0,  0($t0)       # set $a0 = value of current vector element
    li    $v0,  1            # set $v0 = index of system call "print_int"
    syscall                  # print on console: value of current vector element
    addiu $t0, $t0, 4        # set $t0 = $t0 + 4
    beq   $t0, $fp, endln    # goto "endln" if end of vector reached
    li    $a0,  44           # set $a0 = ',' (ASCII char)
    li    $v0,  11           # set $v0 = index of system call "print_char"
    syscall                  # print on console: ','
    j output                 # continue output
endln:
    li    $a0,  13           # set $a0 = CR (ASCII char)
    li    $v0,  11           # set $v0 = index of system call "print_char"
    syscall                  # print on console: CR
finish:                      # program execution finished
    lw    $ra,  0($fp)       # restore return address from stack
    addiu $sp,  $fp, 4       # release reserved stack space
    jr    $ra                # return to operating system
algorithm:
    ###############################################################################
	li    $t7,  4			 # const 4 für Anzahl bytes
	li    $t0,  0			 # hole 0
	li    $t1,  1			 # hole 1
	lw    $t9,  0($a1) 		 # hole Adresse vom ersten Element
init:
	sw    $t0,  0($t9)		 # initialisiere mit 0
	addi  $t9,  $t9,  4		 # erhoehe Adresse
	addi  $t1,  $t1,  1		 # erhoehe Laufvariable
	bne   $t1,  $a0,  init	 # durchlaufe alle Elemente solange Laufvariable ungleich Anzahl Elemente
	
	li    $t0,  1			 # setze i = 1
	li    $t1,  2			 ##setze t2 = 2
	div   $t1,  $a0,  $t1	 # setze m = $t1 = n / 2
	lw    $t9,  0($a1)		 ##adresse vom ersten elemente
	mul   $t8,  $t7,  $t1    ##offset von 4m = 4 * t1
	add  $t8,  $t8,  $t9	 ##addiere offset
    sw    $t0,  0($t8)		 # setze v_m = 1
schleife:
	move  $t3,  $t2			 # setze p = v_m
	move  $t4,  $t1			 # setze j = m
innere:
	sll   $t5,  $t0,  31     ##linksshift um 31
	sra   $t5,  $t5,  31	 ##rechtsshift um 31
	bgtz   $t5,  continue	 # überspringe falls ungrade
	addi  $t6,  $a0,  -1	 ##n - 1
	bge   $t4,  $t6,  increment	 # j >= n - 1 ja => uberpsringen
	mul   $t6,  $t4,  $t7	 ##offset von j
	add   $t5,  $6,  $t9	 ##adresse von v_j
	lw    $t4,  0($t5)       ##hole v_j
	lw    $t6,  4($t5)		 ##hole v_j++
	add   $t4,  $t4,  $t6    ##v_j + v_j++
	sw    $t4,  0($t5)		 # v_j = v_j + v_j++
	j	  increment
continue:
	mul   $t6,  $t7,  $t4    ##offset = 4 * j
	add   $t8,  $t9,  $t6	 ##addiere offset
	lw    $t7,  0($t8)       ##hole v_j
	add   $t3,  $t3,  $t7    # setze p = p + v_j
	sw    $t3,  0($t8)		 # v_j = p
	move  $t3,  $t7			 ##p = v_j	
increment:
	addi  $t0,  $t0,  1		 # i = i + 1
	addi  $t5,  $a0,  -1     # n - 1
	beq   $t0,  $t5,  endloop
	j     schleife

endloop:
	addi  $t4,  $t1,  -1     # j = m - 1 => j < m 
inner_endloop:
	addi  $t5,  $t4,  1		 # j + 1
	sub   $t5,  $a0,  $t5	 # n - (j + 1)
	mul   $t6,  $t7,  $t5	 # offset von n - j - 1
	add   $t6,  $t6,  $a1	 # adresse von v_(n - (j + 1))
	lw    $t6,  0($t6)		 # hole wert von v_(N - (j + 1))
	mul   $t0,  $t7,  $t4	 # offset von j
	add   $t0,  $t0,  $a1	 # adresse von v_j
	sw    $t6,  0($t0)		 # schreibe v_j = v_(n - (j + 1))
	addi  $t4,  $t4,  -1     # j = j - 1
	bgtz  $t4,  inner_endloop
	
ending:
    ###############################################################################
    jr    $ra                # return to main program