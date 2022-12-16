.data
	prueba: .asciiz "hola amigo mio " 
	userInput:  .space 10
	mensaje: .asciiz "\n Casos del programa \n\n 0. Leer una frase \n 1. Primera Letra De Cada Palabra En Mayúscula Las Demás En Minúscula\n 2. Primera letra en mayúscula y todas las demás en minúscula\n 3. CAMBIAR TODO A MAYÚSCULAS \n 4. cambiar todo a minúsculas \n\n"
	espacio: .asciiz " "
	caso:     .asciiz "\n Por favor seleccione un caso:"
.text 

main:
		
	#texto de prueba	
	la $a0, prueba
	sub $t0, $t0, $t0 #t0
	sub $t1, $t1, $t1 #t1
	sub $t6, $t6, $t6 #t6
	sub $t7, $t7, $t7 #t7
	sub $t5, $t5, $t5 #t5
	sub $t4, $t4, $t4 #t4
	sub $t3, $t3, $t3 #t3
	sub $t2, $t2, $t2 #t2
	programa:
	move $t7, $a0 #guarda el string original
	j menu
	
	numero: #Recibe la nueva palabra cuando se usa la opcion 0
 	
 		move $t6, $a0 #guarda el string nuevo
 	
 	menu:
		#despliega mensaje de bienvenida
		ori $v0,$0, 4
		la $a0, mensaje
		syscall
	
		ori $v0,$0, 4
		la $a0, caso
		syscall
	
		#guarda el numero inngresado y lo mueve a t0
		ori $v0,$0, 5
		syscall
		move $t0, $v0
	
		# Hace un primer blucle donde siempre que sea la primera iteracion salte a loop1 para usar la palabra orignal
		beq $t5, 0, loop1 # si t5=0 salte a loop1
		addi $t5, $t5, 1 # t5+1
		j loop2 
	
	loop1: #guarda en a0 el string original 
		move $a0, $t7
		addi $t5, $t5, 1 #t5+1
		j if
	
	loop2:#Cuando $t5 es diferente de 0 salta a loop2 donde se compara la opcion que se ingreso donde si no es 0 se sigue usando el string original 
		beq $t4, 0, nocero #t4=0 salte a nocero
		addi $t4, $t4, 1 #t4+1
		beq $t0, $0, nocero #t0=0 salte nocero
	
		move $a0, $t7 #guarda t7 en a0
		addi $t4, $t4, 1 #t4+1
	
		j if
	
	nocero: # guarda el nuevo string en a0
		move $a0, $t6
	
	if: #comparador de casos dependiendo de la entrada del usuario
		beq $t0,0,caso1
		beq $t0,1,caso2
		beq $t0,2,caso3
		beq $t0,3,caso4	
		beq $t0,4,caso5	
	

		caso1: #cuando la entrada es 0 carga un nuevo string y salta a numero
			
			ori $a1, $0, 0x7fffffff
			la $a0, userInput
			ori $v0, $0, 8 #$a0=buffer
			syscall
			
			
			j numero
			
		caso2:	#cuando la entrada es 1 hace la func1 y luego imprime el string y salta al programa
			jal func1
			
			move $v0, $t2
			ori $v0,$0, 4
			syscall
			
			j programa

		caso3: #cuando la entrada es 2 hace la func2 y luego imprime el string y salta al programa
			jal func2
			move $v0, $t2
			ori $v0,$0, 4
			syscall
			j programa

		caso4: #cuando la entrada es 3 hace la func3 y luego imprime el string y salta al programa

			jal func3
			
			move $v0, $t2
			ori $v0,$0, 4
			syscall
			
			j programa

		caso5: #cuando la entrada es 4 hace la func4 y luego imprime el string y salta al programa
			jal func4
			move $v0, $t2
			ori $v0,$0, 4
			syscall	
			j programa
	
func1:
		#Recibe la primera letra del string y lo hace mayuscula, luego hace lo demas minuscula excepto si hay un espacio donde si hay, salta al siguiente string y lo convierte en mayuscula
		addi $t0, $0, 'z' # guarda z en t0
		addi $t1, $a0, 0 #t1 =a0
		addi $t4, $0, 'Z' # guarda Z en t4
		addi $t7, $0, ' ' # guarda espacio en t7	
		
		lbu $t2, 0($t1) #carga t1
		sltiu $t3, $t2, 'a' #compara el string[i] con a
		bne $t3, $0, imas4 #si t3 es diferente  de 0 salta imas4
		sltu $t3, $t0, $t2  #compara el string[i] con z
		bne $t3, $0, imas4  #si t3 es diferente  de 0 salta imas4
		andi $t2, $t2, 0xDF #mascara con DF para hacer mayuscula
		sb $t2, 0($t1) #guarda el string 
		j imas4
		
	comp1:
		
		lbu $t2, 0($t1) #carga t1
		beq $t2, $t7, mayus  #si string[i] es igual a espacio salte mayus
		beq $t2, $0, final4 #t2=0 salta final4
		sltiu $t3, $t2, 'A' #compara el string[i] con A
		bne $t3, $0, imas4  #si t3 es diferente  de 0 salta imas4
		sltu $t3, $t4, $t2  #compara el string[i] con Z
		bne $t3, $0, imas4  #si t3 es diferente  de 0 salta imas4
		ori $t2, $t2, 0x20 #mascara con 20 para hacer minuscula
		sb $t2, 0($t1) #guarda el string 
		j comp1
		 
	mayus:
		
		addi $t1, $t1, 1 #t1+1
		lbu $t2, 0($t1) #carga t1
		beq $t2, $0, final4  #t2=0 salta final4
		sltiu $t3, $t2, 'a' #compara el string[i] con a
		bne $t3, $0, imas4 #si t3 es diferente  de 0 salta imas4
		sltu $t3, $t0, $t2 #compara el string[i] con z
		bne $t3, $0, imas4 #si t3 es diferente  de 0 salta imas4
		andi $t2, $t2, 0xDF #mascara con DF para hacer mayuscula
		sb $t2, 0($t1) #guarda el string 
		j imas4
		

	imas4:
		addi $t1, $t1, 1 #t1
		j comp1
			
	final4:

		jr $ra 

func2:
		#Recibe la prime letra de una frase o palabra y la vuelve mayuscula mientras que el resto lo deja en minuscula, esto mientras recorre la palabra
		addi $t0, $0, 'z'  # guarda z en t0
		addi $t1, $a0, 0 #t1 =a0
		addi $t4, $0, 'Z'  # guarda Z en t4
		#Mayuscula primera letra
		lbu $t2, 0($t1) #carga t1
		sltiu $t3, $t2, 'a' #compara el string[i] con a
		bne $t3, $0, imas3  #si t3 es diferente  de 0 salta imas4
		sltu $t3, $t0, $t2 #compara el string[i] con z
		bne $t3, $0, imas3 #si t3 es diferente  de 0 salta imas4
		andi $t2, $t2, 0xDF#mascara con DF para hacer mayuscula
		sb $t2, 0($t1) #guarda el string 
		j minuscula
		#Minuscula resto de palabras
	minuscula:
		lbu $t2, 0($t1) #carga t1
		beq $t2, $0, final3 #t2=0 salta final4
		sltiu $t3, $t2, 'A' #compara el string[i] con A
		bne $t3, $0, imas3 #si t3 es diferente  de 0 salta imas4
		sltu $t3, $t4, $t2  #compara el string[i] con Z
		bne $t3, $0, imas3 #si t3 es diferente  de 0 salta imas4
		ori $t2, $t2, 0x20 #mascara con 20 para hacer minuscula
		sb $t2, 0($t1) #guarda el string 
	
	imas3:
		addi $t1, $t1, 1 #t1+1
		j minuscula
	final3:
	
		jr $ra	



func3:
		#El codigo recorre un string donde mientras este en el rango de z y a, los convierte a las letras a mayuscula
		addi $t0, $0, 'z'  # guarda z en t0
		addi $t1, $a0, 0 #t1 =a0
	
	ciclo1:
		lbu $t2, 0($t1)  #carga t1
		beq $t2, $0, final #t2=0 salta final
		sltiu $t3, $t2, 'a' #compara el string[i] con a
		bne $t3, $0, imas #si t3 es diferente  de 0 salta imas
		sltu $t3, $t0, $t2  #compara el string[i] con z
		bne $t3, $0, imas #si t3 es diferente  de 0 salta imas
		andi $t2, $t2, 0xDF #mascara con DF para hacer mayuscula
		sb $t2, 0($t1) #guarda el string
	imas:
		addi $t1, $t1, 1  #t1+1
		j ciclo1
			
	final:
	
		jr $ra

func4:
		#El codigo recorre un string donde mientras este en el rango de Z y A, los convierte a las letras a minuscula
		addi $t0, $0, 'Z'  # guarda Z en t0
		addi $t1, $a0, 0 #t1 =a0
	
	ciclo2:
		lbu $t2, 0($t1) #carga t1
		beq $t2, $0, final2 #t2=0 salta final2
		sltiu $t3, $t2, 'A'  #compara el string[i] con A
		bne $t3, $0, imas2 #si t3 es diferente  de 0 salta imas2
		sltu $t3, $t0, $t2  #compara el string[i] con Z
		bne $t3, $0, imas2 #si t3 es diferente  de 0 salta imas2
		ori $t2, $t2, 0x20  #mascara con 20 para hacer minuscula
		sb $t2, 0($t1) #guarda el string
	imas2:
		addi $t1, $t1, 1 #t1+1
		j ciclo2
			
	final2:
	
		jr $ra	

			
