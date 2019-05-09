  .text
    .globl main
main:
    addiu 	$sp, $sp, -12       # Stack-Pointer-12
    sw    	$ra, 8($sp)         # $sp+8=$ra merkt sich ra an letzter stelle
	sw      $fp, 4($sp)		    # $sp+4=fp (frame pointer), merkt sich fp an vorletzter stelle
	sw    	$v0, 0($sp)         # Oberste stelle v0
    addiu 	$fp, $sp, 8         # fp=letzt stelle
    la		$a0, text_1		    # "Rechnerorganisation Aufgabe:\n"
	jal 	routine_1           
    la		$a0, text_3         # "Geben Sie eine natuerliche Zahl zwischen 1 und 10 ein: "
    jal 	routine_1	
	jal 	routine_3	        # speichert eingegebene Zahl in v0
	move	$a3, $v0		    # kopiert a3 in s0
	jal     algorithm           # ruft UPG auf 	   
	la		$a0, text_4         # "Ergebnis = "
	jal 	routine_1	
	move	$a0, $v1 		    # nimmt ergebnis aus v1 in a0
	jal		routine_2           # Ergbniss wird ausgegeben
    la		$a0, text_2         # "\nEnde!\n"
	jal 	routine_1 
    lw    	$ra, 8($sp)         # ra = letzter platz mit altem sp
	lw      $fp, 4($sp)	        # fp = letzter platz-1
	lw      $v0, 0($sp)         #
    addiu 	$sp, $sp, 12    
    jr   	$ra             

routine_1:
    li    $v0, 4                #Funktionsergebnis v0=4           
    syscall                     #Betriebssystemfunktionen:Die mit Chr 0 terminierte
                                #Zeichenkette, die an der Stelle ($a0) beginnt, wird ausgegeben
    jr    $ra                   #Sprung nach $ra (Ruecksprungadresse), also zumletzten Ort des Sprunges +4

routine_2:
    li    $v0, 1                #Funktionsergebnis v0=1    
    syscall                     #Wert in $a0 wird dezimal ausgegeben
    jr    $ra                   #sptingt zurück+4

routine_3:
    li    $v0, 5                #Funktionsergebnis v0=5
    syscall                     #Die auf der Konsole dezimal eingegebene ganze Zahl in $v0
    jr    $ra                   #sptingt zurück+4

algorithm:
	li		$v1, 0	            #t1=0
	blez	$a3, jump_2         #springt a3<1 ist, also a3= 0,-1,-2...
	addi  	$t0, $a3, -10       #t0= = a3-10
	bgtz    $t0, jump_2	        #springt a3-10>0 ist, also a3= 11,12,13...
    
#hier wenn das 0<a3<11 ist
jump_1: 	
	add 	$v1, $a3, $v1       #v1=a3
	addi    $a3, $a3, -1        #a0'=a3-1
	bgtz	$a3, jump_1         #springt a3-1>0, also springt nicht wenn a3=1 war
	j		jump_3	            
	
#hier wenn a3<0 || a3>10 ist    
jump_2:  
    li		$v1, -1             #t1=-1 schreibt in Save rigister
    la		$a0, text_5         #"falsche Eingabe!\n"
	j 	    routine_1           #Ausgabe des Tesxtes
	

	
jump_3:         # a3=1 also a3'=0
    jr      $ra
	
	.data
text_1: .asciiz "Rechnerorganisation Aufgabe:\n"
text_2: .asciiz "\nEnde!\n"
text_3: .asciiz "Geben Sie eine natuerliche Zahl zwischen 1 und 10 ein: "

text_4: .asciiz "Ergebnis = "
text_5: .asciiz "falsche Eingabe!\n"
