#======================
# Hello, my name is Thao (Nguyen Thi Phuong Thao)
# This is my mips program of some matrices operations (For Computer Architecture Class)
# Content
# 1. Add 2 matrices (1 and 2)
# 2. Sub 2 matrices (1 and 2)
# 3. Mul 2 matrices (1 and 2)
# 4. Transpose (matrix 1)
# 5. Display (1, 2 or 3)
# Wish you have a beautiful day!!

### NOTE !!! All matrices here are SQUARE MATRICES
#======================

.data
	endl: .asciiz "\n"
	tab: .asciiz "\t"
	menu: .asciiz "Welcome!\n Menu:\n1 - Add [matrix 1+2];\n2 - Sub [matrix 1-2];\n3 - Mul [matrix 1x2];\n4 - Transpose [matrix 1];\n5 - Display [matrix 1, 2, 3];\n"
	menu2: .asciiz "What matrix do you want to display? \n1 - Matrix 1;\n2 - Matrix 2;\n3 - Matrix 3;\n"
	msg: .asciiz "Chuong trinh ket thuc!"

	dimension: .word 4 # Dimension of 3 matrices. You can change it to n !!

	matriz1: .word 1 2 3 4 5 6 7 8 9 1 2 3 4 5 6 7 # matrix 1
	matriz2: .word 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 # matrix ID
	matriz3: .word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 # zero-matrix

.text

#===========
# Matrix 1 2 3 save in $s0, $s1, $s2
# $t0: dimension
#===========

main:
	la $s0, matriz1 
	la $s1, matriz2
	la $s2, matriz3
	la $t0, dimension
	lw $s3, 0($t0) #load word of dim

	la $a0, menu 
	li $v0, 4 # Load immedialy
	syscall

	li $v0, 5
	syscall
	
	beq $v0,1,sum
	beq $v0,2,subtract
	beq $v0,3,multiplica
	beq $v0,4,transpose
	beq $v0,5,print

	li $v0, 10
	syscall
#=====================================
read_cel:
	move $t0, $a0
	move $t1, $a1

	mul $t0, $t0, $s3 

	add $t0, $t0, $t1
	sll $t0, $t0, 2

	add $t0, $t0, $a3 

	lw $v0, 0($t0) 

	jr $ra

#======================================

write_cel: # (lin, col, val)
	move $t0, $a0
	move $t1, $a1

	mul $t0, $t0, $s3 

	add $t0, $t0, $t1 
	sll $t0, $t0, 2 

	add $t0, $t0, $a3 

	sw $a2, 0($t0) 

	jr $ra

#==========================================
sum: 

	li $s4, 0 # i = j = 0
	li $s5, 0

sum_while_1:
	slt $t3, $s4, $s3  # Set less than: if $s4 < $s3 then $t3=1; If not $t3=0
	beq $t3, 0, sum_fim

sum_while_2:
	slt $t3, $s5, $s3 
	beq $t3, 0, sum_fim_linha

	move $a0, $s4 
	move $a1, $s5
	move $a3, $s0

	jal read_cel 

	move $t4, $v0 

	move $a3, $s1 

	jal read_cel

	move $t5, $v0 

	add $t4, $t4, $t5 # A[i,j]+B[i,j]

	move $a2, $t4 
	move $a3, $s2 

	jal write_cel

	addi $s5, $s5, 1 # j++

	j sum_while_2

sum_fim_linha:
	addi $s4, $s4, 1 # i++
	li $s5, 0 # j = 0

	j sum_while_1

sum_fim:
	move $a3, $s2

	j print_matriz

#==========================================
subtract: 
	li $s4, 0 # i = j = 0
	li $s5, 0

subtract_while_1:
	slt $t3, $s4, $s3
	beq $t3, 0, subtract_fim

subtract_while_2:
	slt $t3, $s5, $s3
	beq $t3, 0, subtract_fim_linha

	move $a0, $s4 
	move $a1, $s5
	move $a3, $s0

	jal read_cel

	move $t4, $v0 

	move $a3, $s1 

	jal read_cel

	move $t5, $v0

	sub $t4, $t4, $t5 # A[i,j]- B[i,j]

	move $a2, $t4 
	move $a3, $s2 

	jal write_cel

	addi $s5, $s5, 1 # j++

	j subtract_while_2

subtract_fim_linha:
	addi $s4, $s4, 1 # i++
	li $s5, 0 # j = 0

	j subtract_while_1

subtract_fim:
	move $a3, $s2

	j print_matriz

#==========================
transpose:

	li $s4, 0 # i = j = 0
	li $s5, 0

transpose_while_1:
	slt $t3, $s4, $s3 # Set less than: neu $s4 < $s3 thi $t3=1; If not $t3=0
	beq $t3, 0, transpose_fim # Branch if equal: If $t3=0, go to transpose_fim

transpose_while_2:
	slt $t3, $s5, $s3 # Set less than: neu $s5 < $s3 thi $t3=1; If not $t3=0
	beq $t3, 0, transpose_fim_linha # Branch if equal: If $t3=0, go to transpose_fim_linha

	move $a0, $s4 
	move $a1, $s5 
	move $a3, $s0

	jal read_cel 

	move $t5, $v0 

	move $a2, $t5
	move $a3, $s2

	move $t5, $s4 
	move $s4, $s5
	move $s5, $t5

	move $a0, $s4 
	move $a1, $s5

	jal write_cel

	move $t5, $s5 
	move $s5, $s4
	move $s4, $t5

	addi $s5, $s5, 1 # j++
	j transpose_while_2

transpose_fim_linha:
	addi $s4, $s4, 1 # i++
	li $s5, 0 # j = 0

	j transpose_while_1

transpose_fim:
	move $a3, $s2
	j print_matriz

#===========================
# Print function
print:
	la $a0, menu2
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	beq $v0,1,matriz_1
	beq $v0,2,matriz_2
	beq $v0,3,matriz_3

matriz_1:
	move $a3, $s0
	j print_matriz
	
matriz_2:
	move $a3, $s1
	j print_matriz

matriz_3:
	move $a3, $s2
	j print_matriz

print_matriz:
	li $s4, 0 # i = j = 0
	li $s5, 0

print_while_1:
	slt $t3, $s4, $s3
	beq $t3, 0, print_fim

print_while_2:
	slt $t3, $s5, $s3
	beq $t3, 0, print_fim_linha

	move $a0, $s4 
	move $a1, $s5
	jal read_cel
	
	move $a0, $v0 
	li $v0, 1
	syscall

	li $v0, 4
	la $a0, tab
	syscall

	addi $s5, $s5, 1 # j++

	j print_while_2

print_fim_linha:

	addi $s4, $s4, 1 # i++
	li $s5, 0 # j = 0

	li $v0, 4
	la $a0, endl
	syscall

	j print_while_1

print_fim:

	la $a0, msg
	li $v0, 4
	syscall

	li $v0, 10
	syscall

#=========================================
multiplica:
	li $s4, 0 # i = j = k = 0
	li $s5, 0
	li $s6, 0

multiplica_while_1: 
	slt $t3, $s4, $s3 
	beq $t3, 0, multiplica_fim

multiplica_while_2: 
	slt $t3, $s5, $s3 
	beq $t3, 0, multiplica_fim_linha

multiplica_while_3:
	slt $t3, $s6, $s3
	beq $t3, 0, multiplica_fim_k

	move $a0, $s4
	move $a1, $s6
	move $a3, $s0
	jal read_cel

	move $t8, $v0

	move $a3, $s1 
	move $a0, $s6
	move $a1, $s5
	jal read_cel

	move $t9, $v0


	mul $t8, $t8, $t9 # t8=t8*t9 *Thuc hien nhan

	add $t7, $t7, $t8 #t7 = t7+t8 

	addi $s6, $s6, 1 # k++ 
	
	j multiplica_while_3

multiplica_fim_k:
	move $a0, $s4
	move $a1, $s5
	move $a2, $t7
	move $a3, $s2
	jal write_cel

	addi $s5, $s5, 1 # j++
	li $s6, 0 # k=0 

	li $t7, 0 
	j multiplica_while_2

multiplica_fim_linha:
	addi $s4, $s4, 1 # i++
	li $s5, 0 # j = 0
	li $t7, 0
	j multiplica_while_1

multiplica_fim:
	move $a3, $s2
	j print_matriz
#=======================================
# The end
# Thank you
