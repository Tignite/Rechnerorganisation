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
	li    $t2,  4			 # const 4
	blez  $a0,  ending
	
    addi  $t0,  $a0, -1		 # set i = $t0 = number of input values - 1
	lw    $t5,  0($a1) 		 # hole Adresse des ersten Elements
	lw    $t3,  0($a0)		 # hole n
naturals:
	sub   $t1,  $t3,  $t0	 # $t1 = n - i
	sw    $t1,  0($t3)		 # lege Ergebnis ab in Array 	
	beqz  $t0,  ending		 # i = 0 ? wenn ja beenden
	addi  $t0,  $t0, -1		 # i = i - 1
	add   $t5,  $t5,  $t2	 # erhöhe adresse
	j     naturals

	
ending:
    ###############################################################################
    jr    $ra                # return to main program