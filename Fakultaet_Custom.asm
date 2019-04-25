.text
.globl main
main:
     addi    $sp, $sp, -16  # save space of stack for reg.
     sw      $v0, 0($sp)    # save $v0 on stack
     sw      $s0, 4($sp)    # save $s0 on stack
     sw      $s1, 8($sp)    # save $s1 on stack
     sw      $ra, 12($sp)   # save return address
     li      $v0, 4         # system call no. 4: print asciiz
     la      $a0, text1     # load address of text1
     syscall
     li      $v0, 4         # system call no. 4: print asciiz
     la      $a0, inptxt    # load address of inptxt
     syscall
     li      $v0, 5         # system call no. 5: console input
     syscall
     move    $s0, $v0       # move value N into $s0 register

     ##########################
	 # Insert your code here! #
	 ##########################
	 
	 add	 $t0, $zero, $zero		# const 0
	 addi	 $t1, $zero, 1		# const 1
	 slti	 $s1, $s0, 0		# Eingabe < 1  ?
	 beq	 $s1, $t1, negativ	# negativ -> setze -1 und beende
	 slti	 $s1, $s0, 13		# Eingabe < 13 ?
	 beq	 $s1, $t0, subtract # s1 = 0, subtrahiere 1 und beende
	 add 	 $t2, $t2, $s0		# Hole Eingabe zum dekrementieren
wiederholung:
	 mul 	 $s1, $s1, $t2 		# 
	 sub 	 $t2, $t2, $t1		# verringere t2 um 1
	 beq	 $t2, $t1, ende		# t2 = 1 ? wenn ja beende, sonst wiederhole
	 j 		 wiederholung
	 
	 
	 
negativ:
	 addi 	 $t1, $t1, 1		# const 1 zu 2
subtract:
	 sub     $s1, $s1, $t1		# setze auf -1
	 
ende:
     ##########################
	 # Insert your code here! #
	 ##########################
	 
	 
     li      $v0, 4         # system call no. 4: print asciiz
     la      $a0, end1      # load address of end1
     syscall
     li      $v0, 1         # system call no. 1: print integer
     move    $a0, $s0       # register $s0 has value N
     syscall	
     li      $v0, 4         # system call no. 4: print asciiz
     la      $a0, nline
     syscall
     li      $v0, 4         # system call no. 4: print asciiz
     la      $a0, end2      # load address of end1
     syscall
     li      $v0, 1         # system call no. 1: print integer
     move    $a0, $s1       # register $s1 has value N!
     syscall	
     li      $v0, 4         # system call no. 4: print asciiz
     la      $a0, nline
     syscall
     lw      $ra, 12($sp)   # restore return address
     lw      $s1, 8($sp)    # restore $s1 from stack
     lw      $s0, 4($sp)    # restore $s0 from stack
     lw      $v0, 0($sp)    # restore $v0 from stack
     addiu   $sp, $sp, 16   # restore stack pointer
     jr      $ra            # return to main program

       .data
text1: .asciiz "\nFakultaetsberechnung\n"
inptxt: .asciiz "Geben Sie eine natuerliche Zahl zwischen 1 und 12 ein: "
end1:  .asciiz "\nN  = "
end2:  .asciiz "N! = "
nline: .asciiz "\n"
