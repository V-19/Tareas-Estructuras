#Vincer Mauricio Solìs Hernàndez B87702
#Explicacion corta
#El codigo recibe un array A y por cada numeo del array ve si es postivo o negativo, si es positivo ve si es par o impar con una mascara and, hace esto hasta que se llegue al final del array 
#donde esta el valor de null, cada vez que se obtiene un numero par el programa suma a un contador y almacena el dato en el array B, al final el programa imprime el valor del numero de pares 
#en el array B
.data 
	A: .word 1,2,3,4,5,6,-8,-5,-2,-9,-6,-3, 0 #Array1
	B: .space 500 #Array2, se define una cantidad de espacio para guardar algo
	string: .asciiz "\n Número de pares en B es de: "
	
.text 
	main:
		
		la $t0, A # carga dir A
		la $t1, B # carga dir B
		
		add $t2,$0,$0	#contador i
		add $t3,$0,$0	#contador de B	
		add $s0,$0,$0	#variable para almacenar B
		
		jal Funcion

		# Print String
		li $v0, 4
		la $a0, string # load adress
		syscall
    
		# Print B
 
		li $v0, 1
		add $a0, $t3, $zero
		syscall

		li $v0, 10
   		syscall
    		
    	Funcion:
    		sll $t4, $t2, 2  # i+4
		add $t4, $t4, $t0 # A[i]*4
		lw $t5, 0($t4) #cargar A
		beq $t5, $0, end # si A[i]=0 ir a end
		slti $t6, $t5, 0 # t6=1 si t5<0 
		beq $t6, 1, negativo # si t6=1 ir negativo
		andi $t7, $t5, 1 #mascara obtener bit menos significativo
		beq $t7, 0, par # si t7=0 ir a par 
		addi $t2,$t2,1 #i++
		j Funcion
		
	negativo:	
		addi $t2,$t2,1 #i++
		j Funcion
	par:
		# Método para guardar Arrays: https://www.youtube.com/watch?v=BfHcogmKM20
		sw $s1, B($s0)# guarda valor en B
		addi $s0,$s0,4 # Salta 4 posiciones  
		addi $t3,$t3,1 #B++
		addi $t2,$t2,1 #i++ 
		j Funcion	
		
	end:
		jr $ra
		
		
		
		
		
		
		
		
		
		
		
		
		
		  
		      
  
  
