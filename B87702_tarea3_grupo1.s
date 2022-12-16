.data
	mensaje: .asciiz "\n\n\nEste programa calcula la la hipotenusa de un triangulo rectangulo, el angulo, el seno y coseno opuestos al cateto menor\n"
	a: .asciiz "\nDigite el valor de a: "
	b: .asciiz "\nDigite el valor de b: "
	sol1: .asciiz "\n El valor de la hipotenusa es: "
	sol2: .asciiz "\n El valor del sen^-1(b/c) es : "
	sol3: .asciiz "\n El valor del sen(angulo) es : "
	sol4: .asciiz "\n El valor del cos(angulo) es : "

	#El programa en el main inicializa las variables y hace un llamado de las funciones en orden, primero la hipotenusa donde calcula el valor de la suma de a^2 + b^2 y luego la raiz, por medio de la pila
	#Para el seno inverso se calcula b/c y luego se usan las formulas de taylor y se obtiene x^2n+1, 4^n, 2n! y n^2! por medio de la pila y va sumando los resultados hasta que el contador t6 sea 0
	#una vez hecho esto, hace lo mismo con el cos y el sen y al final devuelve el valor cada 1 al main y lo imprime.
.text 	


main: 	

	#Se inicializan las variables a usar en el programa
	sub.s $f14, $f14, $f14
	sub.s $f15, $f15, $f15
	sub.s $f11, $f11, $f11
	sub.s $f10, $f10, $f10
	sub.s $f13, $f13, $f13
	sub.s $f4, $f4, $f4
	sub.s $f9, $f9, $f9
	sub.s $f1, $f1, $f1
	sub.s $f2, $f2, $f2
	sub.s $f20, $f20, $f20
	sub.s $f21, $f21, $f21
	sub $t6, $t6, $t6
	sub $t8, $t8, $t8
	sub.s $f30, $f30, $f30 
	sub $t1, $t1, $t1
	sub $t2, $t2, $t2
	
	
#Imprime el mensaje de bienvenida
	ori $v0,$0, 4
	la $a0, mensaje
	syscall
#Lee el dato a

	ori $v0,$0, 4
	la $a0, a
	syscall

	li $v0, 6 #Lee un float 
	syscall	

	mov.s $f1, $f0 #pasa el valor de a, a $f1
	
#Lee el dato b

	ori $v0,$0, 4
	la $a0, b
	syscall

	li $v0, 6 #Lee un float 
	syscall	

	mov.s $f2, $f0 #pasa el valor de b, a $f2
	
	addi $t6, $t6, 5 #iteraciones de la suma de taylor
	
	#compara si los datos a y b son cero, si ambos lo son finaliza el programa, si no sigue el programa	
	c.eq.s $f1,$f25 
	bc1t p2
	
	p2:
		c.eq.s $f2,$f25
		bc1t finalizar
		j Hipotenusa 
	
	finalizar:
		li $v0, 10
   		syscall
	
		# funcion que obtiene la hipotenusa 
		Hipotenusa: 
			
			jal Parte1
			
			resultado1:
			#imprime el valor de la hipotenusa
			ori $v0,$0, 4
			la $a0, sol1
			syscall

			li $v0, 2
			syscall
				
		# funcion que obtiene el senoinverso	
		senoinverso: 
			
			jal Parte2
			
			resultado2:
			#imprime el valor del seno inverso
			ori $v0,$0, 4
			la $a0, sol2
			syscall

			li $v0, 2
			syscall
		# funcion que obtiene el seno	
		seno: 
			
			jal Parte3
			
			resultado3:
			#imprime el valor del seno 
			ori $v0,$0, 4
			la $a0, sol3
			syscall

			li $v0, 2
			syscall
		# funcion que obtiene el coseno		
		cos: 
			
			jal Parte4
			
			resultado4:
			#imprime el valor del coseno
			ori $v0,$0, 4
			la $a0, sol4
			syscall

			li $v0, 2
			syscall
				
			
			j main
		


Parte1:

#suma de raiz 

	addi $sp, $sp, -8 #agrega 8 espacio a la pila
	s.s $f1, 4($sp) #guarda f1 en la pila
	s.s $f2, 0($sp) #guarda f2 en la pila
	jal suma #se define que la función recibe los parámetros por la pila y por ahí devuelve el resultado
	l.s $f12, 0($sp) #carga el resultado de la pila en f12
	addi $sp, $sp, 8 #devuelve la pila

#saca la raiz de la suma
	
	addi $sp, $sp, -4 #agrega 4 espacio a la pila
	s.s $f12, 0($sp) #guarda f12 en la pila
	jal raiz #se define que la función recibe los parámetros por la pila y por ahí devuelve el resultado
	l.s $f12, 0($sp) #carga el resultado de la pila en f12
	addi $sp, $sp, 4#devuelve la pila

	j resultado1 #salta a la funcion hipotenusa para imprimir el resultado


Parte2:	
#division de b/c
	addi $sp, $sp, -8 
	s.s $f12, 0($sp) #guarda variables en la pila
	s.s $f2, 4($sp)
	jal division #se define que la función recibe los parámetros por la pila y por ahí devuelve el resultado
	l.s $f16, 0($sp) #carga el resultado de la pila en f16
	addi $sp, $sp, 8#devuelve la pila

#sen^-1(b/c)

#elevado x^2n+1
Inicio:		
	
	#se inicializan las variables que se usan para que a la hora de ir haciendo las sumas de taylor no se den errores
	sub.s $f14, $f14, $f14
	sub.s $f15, $f15, $f15
	sub.s $f11, $f11, $f11
	sub.s $f10, $f10, $f10
	sub.s $f13, $f13, $f13
	sub.s $f4, $f4, $f4
	sub.s $f9, $f9, $f9
		
	addi $t1, $0, 1	 #se hace el valor 2n+1
	addi $t2, $0, 2
	mul $t3, $t6, $t2
	mtc1 $t1, $f1
	mtc1 $t3, $f3
	cvt.s.w $f1, $f1  #Convierte 1 en flotante
	cvt.s.w $f3, $f3 #Convierte 2n en flotante			
	add.s $f4, $f3, $f1 #2n+1
	
	addi $sp, $sp, -16
	s.s $f16, 12($sp) #guarda variables en la pila 
	s.s $f4, 8($sp)  
	s.s $f1, 4($sp)       
	s.s $f5, 0($sp)  
	jal elevado1 #se define que la función recibe los parámetros por la pila y por ahí devuelve el resultado
	l.s $f9, 0($sp) #carga el resultado de la pila en f19
	addi $sp, $sp, 16 #devuelve la pila
	

#elevado 4^n
	sub $a0, $a0, $a0 #a0=0
	addi $sp, $sp, -12
	sw $v0, 8($sp)
	sw $t0, 4($sp)
	sw $a0, 0($sp) 
	jal elevado2 #se define que la función recibe los parámetros por la pila y por ahí devuelve el resultado
	lw $v0, 8($sp)
	addi $sp, $sp, 12
	addi $a0, $v0, 0 #a0=v0
	mtc1 $a0, $f10
	cvt.s.w $f10, $f10 #Convierte a0 en flotante y lo pasa a f10
	
#fact2n
	sub $a0, $a0, $a0 #a0=0
	mul $t8, $t6, 2 #2n
	addi $a0, $t8, 0 # a0=t8		
	jal fact
	mtc1 $v0, $f11 #se transfiere un valor de un registro entero a uno flotante
	cvt.s.w $f11, $f11  
	
#fact n^2	
	
	sub $a0, $a0, $a0 #a0=0
	addi $a0, $t6, 0  # a0=t6			
	jal fact
	mul $v0, $v0, $v0
	mtc1 $v0, $f13 #se transfiere un valor de un registro entero a uno flotante
	cvt.s.w $f13, $f13 
	
	
	
#calculo de sen^-1(b/c)

	mul.s $f14, $f11, $f9	
	mul.s $f15, $f10, $f13				
	mul.s $f15, $f15, $f4		
	div.s $f14, $f14, $f15							
	add.s $f29, $f29, $f14
	
	#el ciclo va restando a t6 1 y repite el el calculo de las variables y las suma para dar un resultado cuando t6<0
	ciclo:
	
		
		slti $t8, $t6, 1
		bne $t8, 0, end
		addi $t6, $t6, -1
		
		j Inicio
		
	
	end:
		
	sub.s $f12, $f12, $f12
	add.s $f12, $f12, $f29
	
	j resultado2 #devuelve el resultado a la función seninverso para imprimir el resultado 

#para la parte 3 y cuatro se hace casi lo mismo que la parte 2 
Parte3:

#sen(angulo)
	sub $t6, $t6, $t6
	addi $t6, $t6, 5
	sub $t8, $t8, $t8
	sub.s $f30, $f30, $f30 
	
#x^2n+1
Inicio2:		
	
	#inicializacion de variables
	sub.s $f14, $f14, $f14
	sub.s $f15, $f15, $f15
	sub.s $f11, $f11, $f11
	sub.s $f10, $f10, $f10
	sub.s $f13, $f13, $f13
	sub.s $f4, $f4, $f4
	sub.s $f9, $f9, $f9
	sub.s $f20, $f20, $f20
	sub.s $f21, $f21, $f21
	
	sub $t1, $t1, $t1
	sub $t3, $t3, $t3
	sub $t2, $t1, $t1
	sub.s $f16, $f16, $f16
	
	add.s $f16, $f16, $f29 #valor del angulo a f16
		
	addi $t1, $0, 1
	addi $t2, $0, 2
	mul $t3, $t6, $t2
	add $t9, $t1, $t3 #2n+1
	mtc1 $t1, $f1
	mtc1 $t3, $f3
	cvt.s.w $f1, $f1  #Convierte un valor entero en un registro punto flotante en un valor en punto flotante
	cvt.s.w $f3, $f3			
	add.s $f4, $f3, $f1
	
	addi $sp, $sp, -16
	s.s $f16, 12($sp)
	s.s $f4, 8($sp)  
	s.s $f1, 4($sp)       
	s.s $f5, 0($sp)  
	jal elevado1 #se define que la función recibe los parámetros por la pila y por ahí devuelve el resultado
	l.s $f9, 0($sp)
	addi $sp, $sp, 16
	
	
			
	
	
#(-1)^n

	sub $t1, $t1, $t1#t1=0
	sub $v0, $v0, $v0#v0=0
	addi $sp, $sp, -12
	sw $t6, 8($sp)
	sw $t0, 4($sp)
	sw $v0, 0($sp)
	jal menosmas
	lw $v0, 0($sp)
	mtc1 $v0, $f17 #se transfiere un valor de un registro entero a uno flotante
	cvt.s.w $f17, $f17 
	
	
	
#(2n+1)!

	sub $a0, $a0, $a0
	sub $t8, $t8, $t8
	mul $t8, $t6, 2
	addi $t8, $t8, 1
	addi $a0, $t8, 0		
	jal fact
	mtc1 $v0, $f14 #se transfiere un valor de un registro entero a uno flotante
	cvt.s.w $f14, $f14 
	
	
#calculo de sen(angulo)

	mul.s $f20, $f17, $f9			
	div.s $f21, $f20, $f14							
	add.s $f30, $f30, $f21	
	
	
	ciclo2:
	
		
		slti $t8, $t6, 1
		bne $t8, 0, end2
		addi $t6, $t6, -1
		
		j Inicio2
		
	
	end2:
	
	
	sub.s $f12, $f12, $f12
	add.s $f12, $f12, $f30
	
	j resultado3
	

	
Parte4:	
#cos(angulo)
	
	sub $t6, $t6, $t6
	addi $t6, $t6, 5
	sub $t8, $t8, $t8
	sub $t7, $t7, $t7
	sub.s $f22, $f22, $f22 
	sub.s $f20, $f20, $f20 	

#x^2n
Inicio3:		
	
	#inilizacion de variables
	sub.s $f14, $f14, $f14
	sub.s $f15, $f15, $f15
	sub.s $f11, $f11, $f11
	sub.s $f10, $f10, $f10
	sub.s $f13, $f13, $f13
	sub.s $f4, $f4, $f4
	sub.s $f9, $f9, $f9
	
	sub.s $f20, $f20, $f20	
	sub.s $f21, $f21, $f21
	
	sub $t1, $t1, $t1
	sub $t3, $t3, $t3
	sub $t2, $t1, $t1
	sub.s $f16, $f16, $f16
	
	add.s $f16, $f16, $f29 #pasa el valor del angulo a f16
		
	addi $t1, $0, 1 
	addi $t2, $0, 2	#2n
	mul $t3, $t6, $t2
	add $t9, $t1, $t3
	mtc1 $t1, $f1
	mtc1 $t3, $f3
	cvt.s.w $f1, $f1  #Convierte un valor entero en un registro punto flotante en un valor en punto flotante
	cvt.s.w $f3, $f3			
	add.s $f4, $f3, $f4
	addi $sp, $sp, -16
	s.s $f16, 12($sp)
	s.s $f4, 8($sp)  
	s.s $f1, 4($sp)       
	s.s $f5, 0($sp)  
	jal elevado1 #se define que la función recibe los parámetros por la pila y por ahí devuelve el resultado
	l.s $f9, 0($sp) #carga el valor del x^2n
	addi $sp, $sp, 16
	
	
#(-1)^n

	sub $t1, $t1, $t1
	sub $v0, $v0, $v0
	addi $sp, $sp, -12
	sw $t6, 8($sp)
	sw $t0, 4($sp)
	sw $v0, 0($sp)
	jal menosmas
	lw $v0, 0($sp)
	mtc1 $v0, $f17 #se transfiere un valor de un registro entero a uno flotante
	cvt.s.w $f17, $f17 
	
					
#(2n)!
	sub $a0, $a0, $a0
	sub $t8, $t8, $t8
	mul $t8, $t6, 2 #2n
	addi $a0, $t8, 0 #a0=2n		
	jal fact
	mtc1 $v0, $f14 #se transfiere un valor de un registro entero a uno flotante
	cvt.s.w $f14, $f14 			
	
	
	

#calculo de cos(angulo)

	mul.s $f20, $f17, $f9									
	div.s $f21, $f20, $f14
	
	add.s $f22, $f22, $f21
	
	ciclo3:
	
		
		slti $t7, $t6, 1
		bne $t7, 0, end3
		addi $t6, $t6, -1
		
		j Inicio3
		
	
	end3:
	
	sub.s $f12, $f12, $f12
	add.s $f12, $f12, $f22
	
	j resultado4
					
#########################################################
#Funciones de operaciòn

#-1
		
menosmas:

	addi $sp, $sp, -12 #12 espacios a la pila 
	sw $t6, 8($sp) #guarda las variables a usar 
	sw $t1, 4($sp)
	sw $v0, 0($sp)
	
	lw $v0, 12($sp)#carga las variables a usar 
	lw $t1, 16($sp)
	lw $t6, 20($sp)
	
	
	andi $t0, $t6, 1 #mascara para ver si t6 es impar o par
	
	bne $t0, 0, impar # t0 no es 0 salte a impar 
	
	addi $v0, $v0, 1 #v0+1
	
	j final4
	
	impar:
	
	addi $v0, $v0, 1 #v0+1
	
	mul $v0, $v0, -1 #v0*-1
	
	j final4
	
	final4:
	
	sw $v0, 12($sp) #guarda el resultado 
	lw $v0, 0($sp)	#carga los valores 
	lw $t1, 4($sp)
	lw $t6, 8($sp)
	addi $sp, $sp, 12 #devuelve la pila 
	
	jr $ra #salta a la funcion que lo llamo
	
																																																																	

																																																																																																																																																														

#x^2n+1
elevado1:

	addi $sp, $sp, -20 #20 espacios a la pila 
	s.s $f16, 16($sp) #guarda las variables a usar 
	s.s $f4, 12($sp)
	s.s $f1, 8($sp)    
	s.s $f5, 4($sp)  
	s.s $f2, 0($sp)
	
	l.s $f16, 32($sp) #carga las variables a usar 
	l.s $f4, 28($sp)
	l.s $f1, 24($sp)
	
	sub.s $f5, $f5, $f5 #inicializa variables en 0
        
        sub.s $f2, $f2, $f2
        
        add.s $f2, $f2, $f1 #f2=1
       
	againE: 
	
	c.eq.s $f5,$f4		   #si f5 es diferente a $f4 salte a final 
	bc1t final2
        mul.s $f2,$f2,$f16         # multiplica f2 con f16
        add.s $f5,$f5,$f1          # f5+1 
        
        j againE
        
	final2: 
	
	s.s $f2, 20($sp) 	#guarda el resultado 
	
	s.s $f16, 16($sp) 	#carga los valores 
	s.s $f4, 12($sp)
	s.s $f1, 8($sp)   
	s.s $f5, 4($sp)
	s.s $f2, 0($sp)
	
	
	addi $sp, $sp, 20 	#devuelve la pila 
	
	
	jr  $ra			#salta a la funcion que lo llamo

#4^n
elevado2:
	addi $sp, $sp, -8 #8 espacios a la pila 
	sw $t0, 4($sp)	#guarda las variables a usar
	sw $a0, 0($sp)
	
	
	add $t0, $0, $0   # initialize $t0 = 0, $t0 is used to record how many times we do the operations of multiplication
        addi $v0, $0, 1   # set initial value of $v0 = 1
    	addi $a0, $0, 4
    
    	again: 
    	beq $t0, $t6, final3   
        mul $v0, $v0, $a0         # multiple $v0 and $a0 into $v0 
        addi $t0, $t0, 1          # update the value of $t0   
        j again
	
	final3: 
	
	sw $v0, 16($sp) 	#guarda el resultado 
	lw $a0, 0($sp)		#carga los valores 
	lw $t0, 4($sp)
	addi $sp, $sp, 8 	#devuelve la pila 
	
	jr  $ra			#salta a la funcion que lo llamo


#factorial

fact:
	addi $sp, $sp, -8#8 espacios a la pila 	
	sw $ra, 4($sp)	#guarda la direcion de retorno 
	sw $a0, 0($sp)	#guarda n
	
	slti $t0, $a0, 1 # n<1
	beq $t0, $0, L1	#n>1 vaya a L1
	
	addi $v0, $0, 1 #v0+1
	addi $sp, $sp, 8 #devuelva la pila
	jr $ra	#salta a la funcion que lo llamo
	
	L1:
	addi $a0, $a0, -1 #n-1
	jal fact
	
	lw $a0, 0($sp) #carga los valores 
	lw $ra, 4($sp)
	addi $sp, $sp, 8 #devuelve la pila 
	
	mul $v0, $a0, $v0 #n*fact(n-1)
	
	jr $ra	#salta a la funcion que lo llamo


division:
	
	addi $sp, $sp, -12 #12 espacios a la pila 
	s.s $f0, 8($sp)	#guarda las variables a usar
	s.s $f12, 4($sp)
	s.s $f2, 0($sp)
	
	l.s $f1, 12($sp) #carga las variables a usar
	l.s $f2, 16($sp)
	
	div.s $f0, $f2, $f12 #divide 
	s.s $f0, 12($sp) #guarda el valor 
	l.s $f2, 0($sp) #carga las varaibles  
	l.s $f12, 4($sp)
	l.s $f0, 8($sp)
	addi $sp, $sp, 12 #devuelve la pila
	jr $ra #salta a la funcion que lo llamo
	
suma:
	addi $sp, $sp, -12 #12 espacios a la pila 
	s.s $f0, 8($sp) #guarda las variables a usar
	s.s $f1, 4($sp)
	s.s $f2, 0($sp)
	l.s $f1, 12($sp) #carga las variables a usar
	l.s $f2, 16($sp)
	mul.s $f1, $f1, $f1 #a^2
	mul.s $f2, $f2, $f2 #b^2
	add.s $f0, $f1, $f2 #a+b 
	s.s $f0, 12($sp) #guarda el valor
	l.s $f2, 0($sp) #carga las varaibles 
	l.s $f1, 4($sp)
	l.s $f0, 8($sp)
	addi $sp, $sp, 12 #devuelve la pila
	jr $ra  #salta a la funcion que lo llamo
	
raiz:
	addi $sp, $sp, -16 #16 espacios a la pila 
	s.s $f0, 12($sp) #guarda las variables a usar
	s.s $f1, 8($sp)
	s.s $f2, 4($sp)
	s.s $f3, 0($sp)

	l.s $f0, 16($sp) #$f0=N

	addi $t0, $0, 2
	mtc1 $t0, $f1 #se transfiere un valor de un registro entero a uno flotante
	cvt.s.w $f1, $f1  #f1=2 Convierte un valor entero en un registro punto flotante en un valor en punto flotante	

	div.s $f2, $f0, $f1 #$f2=x=N/2 valor inicial de la semilla

	addi $t0, $0, 20 #numero de iteraciones

iterRaiz:
	div.s $f3, $f0, $f2 #$f3=N/x
	add.s $f3, $f2, $f3 #$f3=x+N/x
	div.s $f2, $f3, $f1 ##$f2=(x+N/x)/2

	beq $t0, $0, retRaiz
	addi $t0, $t0, -1
	j iterRaiz

retRaiz:
	s.s $f2, 16($sp) #guarda el valor

	l.s $f3, 0($sp)	#carga las varaibles
	l.s $f2, 4($sp)
	l.s $f1, 8($sp)
	l.s $f0, 12($sp) 
	addi $sp, $sp, 16  #devuelve la pila
	jr $ra	 #salta a la funcion que lo llamo
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
