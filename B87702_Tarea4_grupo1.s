.data
	mensaje: .asciiz "\n\n\nEste programa es una calculadora polaca que calcula restas sumas multiplicaciones y divisiones\n"
	numero: .asciiz "\nDigite el valor de un nùmero o signo: "
	err: .asciiz "Error en el programa"	
	num: .asciiz "El valor del numchar del numero es:"
	resultado: .asciiz "El Resutaldo es (si presionó espacio es el último valor apilado de la pila):"
	myb: .word 0 
	res: .asciiz "Reset completado"
.text 	


#Estre progrma lo que hace es recibir un numero como array y usar la formula vista en el documento de la tarea para recorrer el array de derecha a izquierda multiplicando por decenas, centenas, miles etc
#sumando cada string del array entre si, tiene un sistema de detencion de simbolos incorrectos el cual recorre el array y determina si lo ingresado es un numero valido o no, cuando se tiene el numero
# se almacena en la pila y se vuelve a ingresar mas numeros o operaciones donde este funciona como una calculadora inversa RPN.
main: 	


#Imprime el mensaje de bienvenida
	ori $v0,$0, 4
	la $a0, mensaje
	syscall
	

	sub $t1, $t1, $t1 #numchar
	sub $t0, $t0, $t0 #inicializa los valores a usar en 0
	sub $t2, $t2, $t2
	sub $t3, $t3, $t3
	sub $t4, $t4, $t4
	sub $t6, $t6, $t6     
	sub $t7, $t7, $t7
	sub $t8, $t8, $t8 
	sub $t9, $t9, $t9
	sub $v0, $v0, $v0
	sub $s0, $s0, $s0
	ori $t9, $0, 0x0a #Null
	
menu:
	
	sub $t0, $t0, $t0 #inicializa los valores a usar en 0
	sub $t2, $t2, $t2
	sub $t3, $t3, $t3
	sub $t4, $t4, $t4  
	sub $t7, $t7, $t7
	sub $t1, $t1, $t1 #numchar
	
	ori $v0,$0, 4 #carga mensaje 
	la $a0, numero
	syscall
	
	la $a0, myb #carga el numero ingresado 
	li $a1, 0x7fffffff
	li $v0, 8 #$a0=buffer
	syscall
	
	lh $t0, 0($a0) #carga la mitad de la palabra 
	beq $t0, 0x0a2b, suma #salta a suma si se introduce el simbolo suma
	beq $t0, 0x0a2d, resta #salta a resta si se introduce el simbolo resta
	beq $t0, 0x0a2a, Multi #salta a multiplicacion si se introduce el simbolo multiplicacion
	beq $t0, 0x0a2f, division #salta a division si se introduce el simbolo de division
	beq $t0, 0x0a20, print  #salta a print si se introduce el simbolo espacio
	beq $t0, 0x0a63, reset #salta a reset si se introduce C
       	beq $t0, 0x0a43, reset #salta a reset si se introduce c
		
				
	sub $t0, $t0, $t0
	add $t0, $t0, $a0 #guarda a0 en t0
	
	jal verificar
	
	ori $v0,$0, 4 
	la $a0, num
	syscall
	
	addi $a0, $t1, 0 #imprime numchar
	ori $v0, $0, 1
	syscall
	
	move $a0, $t0 #mueve t0 a a0
	
	jal numchar
	
j menu

reset:

beq $s0, 0, finalizar  #si s0 es 0 salta a finalizar
		
addi $sp, $sp, 40#devuelve la pila
	
addi $s0, $s0, -1#s0-1
	
j reset

finalizar:

	ori $v0,$0, 4 
	la $a0, res
	syscall

j main


verificar:

	addi $sp, $sp, -16 #agrega 16 espacios a la pila 
	sw $t7, 12($sp) #guarda las variables a usar en la pila
	sw $t3, 8($sp)
	sw $t4, 4($sp)
	sw $a0, 0($sp)
	
	
	addi $t3, $0, 0x39 #carga el nueve 
	
		ciclo1:	
		
		lbu $t4, 0($a0) #carga el primer numero del string
		
		beq $t4, $t9, final2 #si ese numero es null termina
		
		beq $t4, 0x2d, menos #si el string es menos salta a menos
		
		sltiu $t7, $t4, 0x30  # si el string es menor a 0 t7=0
		bne $t7, $0, error #salte a error si t7=0
		sltu $t7, $t3, $t4  # si el string es mayor a 9 t7=0
		bne $t7, $0, error #salte a error si t7=0
		
		addi $a0, $a0, 1 #pasa al proximo numero del string
		addi $t1, $t1, 1 #t1+1(numchar)
		
		j ciclo1
			
	menos:
		
		addi $t1, $t1, 1#t1+1 (numchar)
		addi $a0, $a0, 1#pasa al proximo numero del string
		
			j ciclo1
	final2: 
		lw $a0, 0($sp) #carga las variables usadas de la pila 
		lw $t4, 4($sp)
		lw $t3, 8($sp)
		lw $t7, 12($sp)
	
		addi $sp, $sp, 16 #devuelve la pila 
	
		addi $t1, $t1, 1 #t1+1(numchar)
	
		jr $ra

	error:
		lw $a0, 0($sp)  #carga las variables usadas de la pila 
		lw $t4, 4($sp)
		lw $t3, 8($sp)
		lw $t7, 12($sp)
		addi $sp, $sp, 16  #devuelve la pila 
	
	
		li $v0, 4 #carga mensaje de error
		la $a0, err
		syscall
	
		li $v0, 10 #termina el programa
		syscall

numchar:

	sub $t3, $t3, $t3 #inicializa valores 
	sub $t0, $t0, $t0
	addi $t3, $0, -2
	add $t8, $0, $0
	
		addi $sp, $sp, -40 #agregar 40 espacios a la pila
		sw $t6, 36($sp) #guarda estas variables en cada espacio de la pila 
		sw $t7, 32($sp)
		sw $t8, 28($sp)
		sw $t0, 24($sp)
		sw $t4, 20($sp)
		sw $t1, 16($sp)
		sw $t2, 12($sp)
		sw $t3, 8($sp)
		sw $t5, 4($sp)
		sw $a0, 0($sp)
	
		
		add $t6, $0, $0 #t6=0
	ciclo2:
		
		lw $a0, 0($sp) #carga el string
		
		add $t4, $t1, $t3 #numchar-2
		
		add $a0, $a0, $t4 #numchar-2+a0
		
		lbu $t2, 0($a0)#carga el ultimo string del array 
		
		beq $t2, 0x2d, menos2 #si es menos salta a menos
		
		sub $t2, $t2, 48 #t2-0
		#apartado de potencia de 10 donde hace que si se recibe 20 se multipleque por la potencia de 10 la decena, igual lo hace con decenas centenas y mas.
		
		add $t5,$0,$0   # initialize $t0 = 0, $t0 is used to record how many times we do the operations of multiplication
        	addi $v0,$0,1          # set initial value of $v0 = 1
		addi $a0, $0, 10
	
		again: 
			beq $t5, $t8, final3   
       			mul $v0,$v0,$a0         # multiple $v0 and $a0 into $v0 
        		addi $t5,$t5,1          # update the value of $t0   
        		j again
	
		final3:
			mul $t7, $t2, $v0 #potencia de 10 por su respectivo string
			add $t6, $t6, $t7 #va sumando las string del array
		
			beq $t4, $0, final4
			addi $t3, $t3, -1 #-2-1
			addi $t8, $t8, 1#t8+1
		
		j ciclo2
	
	
		casomenos:
	
			mul $t6, $t6, $t0 #numero*-1
				
		j final4
	menos2:
		addi $t0, $t0, -1 #t0*-1
		
		j casomenos
		
	final4: 
		addi $s0, $s0, 1 #contador de numeros ingresados
		jr $ra

suma:
      
       sub $v0, $v0, $v0
       addi $t0, $0, 1 # contador
       
	cir1:
	
        	add $v0,$v0,$t6#suma de los numeros
            
        	beq $t0,$0,final5#Si $t1=0 salta a final5
            
       		lw $t6, 36($sp)#lee el valor de la pila 36 y lo guarda en t6
            
                addi $sp,$sp,40#devuelve la pila
            
                addi $t0,$t0,-1 #t1-1
            
	j cir1 #salta a cir1
            



resta:

	sub $v0, $v0, $v0
	addi $t0, $0, 1 # contador

	ci2:

		sub $v0, $t6, $v0  #resta de los numeros

		beq $t0, $0, final5 #Si $t1=0 salta a final5

		lw $t6, 36($sp) #lee el valor de la pila 36 y lo guarda en t6

		addi $sp, $sp, 40#devuelve la pila

		addi $t0, $t0, -1#t1-1
	
	j ci2

division:

	sub $v0, $v0, $v0
	
	addi $v0, $v0, 1
	
	addi $t0, $0, 1 # contador	
		
	ci3:

		div $v0, $t6, $v0  #division de los numeros
			
		beq $t0, $0, final6 #Si $t1=0 salta a final6
			
		lw $t6, 36($sp) #lee el valor de la pila 36 y lo guarda en t6

		addi $sp, $sp, 40 #devuelve la pila

		addi $t0, $t0, -1 #t1-1

	j ci3


Multi:

	sub $v0, $v0, $v0

	addi $v0, $v0, 1
	
	addi $t0, $0, 1 # contador
	
	ci4:
	
		mul $v0, $v0, $t6  #multiplica los numeros

		beq $t0, $0, final6 #Si $t1=0 salta a final5
 
		lw $t6, 36($sp) #lee el valor de la pila 36 y lo guarda en t6

		addi $sp, $sp, 40 #devuelve la pila

		addi $t0, $t0, -1 #t1-1

	j ci4


final5:
	
	move $t6, $v0 #mueve t6 a v0
	
	j print#salta a imprimir

final6:
	mflo $t6 #mueve la parte baja de la multiplicacion y division a $t6

	move $t6, $v0#mueve t6 a v0
	
	j print#salta a imprimir

print:	
		
	ori $v0,$0, 4
	la $a0, resultado #imprime el string resultado
	syscall

	addi $a0, $t6, 0 #imprime t6 
	ori $v0, $0, 1
	syscall
	
	move $v0, $t6 #mueve v0 a t6
	 
	j menu #salta a menu



