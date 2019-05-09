# Hauptprogramm
	.text
    .globl main
main:
    addi  $sp,  $sp, -4      # save stack space for registers
    sw    $ra,  0($sp)       # speicher rücksprung Adresse
    
    move    $fp,    $sp      #  beginn merken
    addiu   $sp,    ,-40   #  für 10 Elemente speichen
    
    move    $a0,    $fp      #  Beginn dem UNP zugänglich machen
    
    
    jal   readValues         # leinlesen
    

    
    jal   sortValues
    jal   printValues        # to screen
    lw    $ra,  0($sp)       # restore return address
    addi  $sp,  $sp, 4       # restore stack pointer
    jr    $ra
	 
# Routinen fÃ¼r Ein- und Ausgabe	 
printString:
    li    $v0, 4             # print a string
    syscall
    jr    $ra                # return to calling routine

printInt:       #printet a0
    li    $v0, 1             # print an integer
    syscall
    jr    $ra                # return to calling routine

readInt:        #speichet v0
    li    $v0, 5             # read an integer 
    syscall
    jr    $ra    

##########################################################################################################
##########################################################################################################
readValues:
    move    $t9,    $ra      # rückadresse speichen
    li      $t0,     10      # Zählvariabele
loop_1:
    beqz    $t0,    end_read # springt wenn t0=0 ist
    jal     readInt          # Wert in v0 speichen
    sw  $v0, ($a0)           # $v0 liegt auf dem erste freien Platz
    addiu    $a0,    -4      # fp' dekrementieren
    addi    $t0,    -1       # t0--
    j       loop_1
end_read:
    addi    $a0,    +40      # fp' dekrementieren
    jr      $t9              # Springe ins Hp
###########################################################################################################
###########################################################################################################
sortValues:
    move    $t9,    $ra      # rückadresse speichen
    li      $t0,     9      # Zählvariabele
    move    $t8,    $a0      # kopier beginn
    
    ######im schlächtesten fall 9 durch gehen#####
loop_9:
    beqz    $t0,    end_sort    # springt wenn t0=0 ist
    move    $t8,    $a0         # kopier beginn    
            ###durch sontieren###
            ###für eimal durch gehen 9 vergleiche####
            li      $t1,     9      # Zählvariabele
loop_99:    beqz    $t1,    end_99    # springt wenn t1=0 ist
            ###vergleiche###
                lb      $t4,    $t8   # kleineres Element
                addiu   $t8,    -4    # nächst kleineren Adresse
                lb      $t5,    $t8   # größeres Element
                sub     $t6,    $t5,    $t4 #Differens >0 reienfolge stimmt
                
                bgtz    $t6,    vorend99_
                sw      $t4,    $t8   # größeres Wort in kleinere Adressen
                addiu   $t8,    +4    # nächst größeren Adresse
                sw      $t5,    $t8   # kleiners Wort in kleinere Adressen
                addiu   $t8,    -4    # nächst kleineren Adresse
                
                
vorend99_:              
            ###vergleiche###
            addi    $t1,    -1          # t1--
            j       loop_99
end99:
            ###für eimal durch gehen 9 vergleiche####      
            ###durch sontieren###       
    addi    $t0,    -1          # t0--
    j       loop_9
    
    
    
    ######im schlächtesten fall 9 durch gehen#####
end_sort:
    addi    $a0,    +40      # fp' dekrementieren
    jr      $t9              # Springe ins Hp

##########################################################################################################
##########################################################################################################
printValues:
    move    $t9,    $ra      # rückadresse speichen
    li      $t0,     10      # Zählvariabele
    move    $t8,    $a0      # beginn merken

loop_3:
    beqz    $t0,    end_read # springt wenn t0=0 ist
    lb      $a0,    $t8      # läde aktuelles Int in a0
    jal     printValues      # gibt Wert in a0 wieder
           
    addi    $t8,    -4       # fp' dekrementieren
    addi    $t0,    -1       # t0--
    j       loop_3    


end_print:
    addiu    $t8,    +40      # fp' dekrementieren
    move    $a0,    $t8      # schreibt beginn zurück
    jr      $t9              # Springe ins Hp
