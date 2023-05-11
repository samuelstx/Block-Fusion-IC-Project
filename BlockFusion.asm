 ;CODIGO FUENTE BLOCK FUSIO IC PROJECT BY SAMUEL SOTO PAREDES - 2023.
 ; samuelsotodev@gmail.com 
 
 
 ; EQUIVALENCIAS USADAS PARA LA ESTRUCTURA DE MATRIZ
 FILSJUEGO     EQU 7
 COLSJUEGO     EQU 5
 TOTALCELDAS   EQU FILSJUEGO*COLSJUEGO 

 ;EQUIVALENCIAS DE COORDENADAS PARA PINTAR EN PANTALLA (FIL, COL)  
 FILMSJMODO    EQU 20  ; posicion msj modo inicial (DEMO o Juego) 
 COLMSJMODO    EQU 5 

 FILMSJPOT     EQU 22   ; posicion msj numero tope con el que jugar
 COLMSJPOT     EQU 5 

 FILENTPOT     EQU FILMSJPOT   ; posicion para pedir el numero tope con el que jugar
 COLENTPOT     EQU COLMSJPOT+60 

 FILPANTALLAJ  EQU 1   ; posicion para imprimir pantTablero
 COLPANTALLAJ  EQU 0

 FILINICIOTAB  EQU 3   ; posicion contenido 1ra celda del tablero
 COLINICIOTAB  EQU 5   
  
 FILMSJGNRAL   EQU 20  ; posicion msjs introduce un comando, ganar, perder y salir 
 COLMSJGNRAL   EQU 43    
 
 FILCOMANDO    EQU FILMSJGNRAL  ; posicion introducir comando
 COLCOMANDO    EQU COLMSJGNRAL+10 
  

data segment        
   comando   db 22 dup ('$')  ;contendra el comando de entrada
   
   ;La estructura que almacena el tablero de juego 
   TableroJuego      dw TOTALCELDAS dup(?) ;contiene los datos del tablero en el momento actual
   TableroJuegoDebug dw 0,0,0,0,0,0,4,2,8,2,0,8,4,2,2,0,2,2,2,2,0,8,2,8,8,0,512,512,128,128,0,4,4,2,16  ;matriz con datos precargados
   
   fil       db ? ; para ColocarCursor
   col       db ? 

   colMatriz db ? ; para VectorAMatriz y MatrizAVector
   filMatriz db ?            
   posMatriz dw ? 
   
   tope      dw ? ; valor maximo hasta el que se jugara 
      
   ;**************************CADENAS ********************************
   cad       db 5 dup(?)  ;para almacenar el numero de una celda tras convertirlo a cadena
   cadVacia  db "     $"  ;para borrar el numero de una celda
   cadTope db 7 dup ('$')    
         
   ;Mensajes de Interfaz                      
   msjModo    db "Entrar al juego en modo Debug - tablero precargado - (S/N)? $"  
   msjIntPot  db "Introduce un valor potencia de 2, entre 16 y 2048 (incls.): $"  

   msgBlancoLargo db 19 dup (' '),'$'   ;para borrar comandos incorrectos
    
   msjPartidaGanada      db "Has ganado la partida!  ;-)  $" 
   msjPartidaPerdida     db "Has perdido! ;-(  $"

   PantallaInicio        db 10, 13, 10  
db " _______   ___        ______    ______   __   ___",10,13 
db "|   _   \ |   |      /      \  /  _   \ |  | /   )",10,13
db "(. |_)  :)||  |     // ____  \(: ( \___)(: |/   /",10,13  
db "|:     \/ |:  |    /  /    ) :)\/ \     |    __/",10,13   
db "(|  _  \\  \  |___(: (____/ // //  \ _  (// _  \",10,13   
db "|: |_)  :)( \_|:  \\        / (:   _) \ |: | \  \",10,13  
db "(_______/  \_______)\ _____/   \_______)(__|  \__)",10,10,13
db "            _______  ____  ____   ________  __      ______    _____  ___",10,13
db "           /       |(   _||_   | /        )|  \    /      \  (\    \|   \",10,13
db "          (: ______)|   (  ) : |(:   \___/ ||  |  // ____  \ |.\\   \    |",10,13
db "           \/    |  (:  |  | . ) \___  \   |:  | /  /    ) :)|: \.   \\  |",10,13
db "           // ___)   \\ \__/ //   __/  \\  |.  |(: (____/ // |.  \    \. |",10,13
db "          (:  (      /\\ __ //\  /  \   :) /\  |\\        /  |    \    \ |",10,13
db "           \__/     (__________)(_______/ (__\_|_)\______/    \___|\____\)",10,13,'$' 

  
   pantTablero db "    |__1__|__2__|__3__|__4__|__5__|     -= COMANDOS =-",10,13
               db "    |     |     |     |     |     |" ,10,13
               db "   A|     |     |     |     |     |" ,10,13         
               db "    |_____|_____|_____|_____|_____|     Introduce 1ro una fila y columna de" ,10,13
               db "    |     |     |     |     |     |     origen, deja un espacio y luego usa" ,10,13
               db "   B|     |     |     |     |     |     las siguientes letras hasta llegar" ,10,13         
               db "    |_____|_____|_____|_____|_____|     al bloque de destino" ,10,13     
               db "    |     |     |     |     |     |" ,10,13
               db "   C|     |     |     |     |     |" ,10,13
               db "    |_____|_____|_____|_____|_____|     Dcha  :D           Pasar       :P",10,13     
               db "    |     |     |     |     |     |" ,10,13
               db "   D|     |     |     |     |     |     Izq   :A",10,13
               db "    |_____|_____|_____|_____|_____|" ,10,13         
               db "    |     |     |     |     |     |     Abjo  :S           Nuevo Juego :N",10,13
               db "   E|     |     |     |     |     |" ,10,13
               db "    |_____|_____|_____|_____|_____|     Arrb  :W           Salir       :E",10,13           
               db "    |     |     |     |     |     |" ,10,13
               db "   F|     |     |     |     |     |" ,10,13
               db "    |_____|_____|_____|_____|_____|" ,10,13          
               db "    |     |     |     |     |     |        Comando>>" ,10,13
               db "   G|     |     |     |     |     |" ,10,13
               db "    |_____|_____|_____|_____|_____|",'$'
data ends


code segment
  include "PROCS_std.inc"  
  include "PROCS_clase.inc"

;*************************************************************************************                                                                                                                        
;*************************     procedimientos de IU    *******************************
;*************************************************************************************  

;F:Dibuja la pantalla de inicio y pide Debug o Juego Normal y pide un numero tope para jugar entre 16 y 2048
  ; Si es modo Debug utiliza un tablero con valores iniciales
  ; Si es modo juego el usuario juega partiendo de cero contablero vacio
  ;S:TableroJuego actualizado segun Modo 
  InicioEntornoBloques PROC
    push ax
    push cx
    push dx
    push bx
    
    mov fil, 0
    mov col, 0
    
    call ColocarCursor
    
    call BorrarPantalla
    
    mov fil, 0
    mov col, 0
    
    call ColocarCursor
    
    lea dx, PantallaInicio
    call ImprimirCadena 
    
    mov fil, FILMSJMODO
    mov col, COLMSJMODO
    
    call ColocarCursor 
    lea dx, msjModo 
    
    call ImprimirCadena
    
     
    
    preguntarDebug:
 
        call LeerTeclaSinEco
        
        cmp al, 'N'
        je respuetaNoPreguntarDebug
        
        
        cmp al, 'S'
        je respuetaSiPreguntarDebug
        
        jmp preguntarDebug
        
    respuetaSiPreguntarDebug:
        
        mov bx, 1
        
        jmp finPreguntarDebug
    
    respuetaNoPreguntarDebug:
        
        mov bx, 0

    
    finPreguntarDebug:
        
        mov fil, FILMSJPOT
        mov col, COLMSJPOT
        
        call ColocarCursor 
        lea dx, msjIntPot 
        
        call ImprimirCadena
        
    
    preguntarTope:
        
        mov cadTope[0], 5
        
        lea dx, cadTope
        call LeerCadena

        lea dx, cadTope[2]
        call CadenaANumero 
                    
        mov cx, ax
        
        dec ax
        
        test cx,ax
        jne preguntarTope
        cmp cx, 16
        jl preguntarTope
        cmp cx, 4096
        jnl preguntarTope
        mov tope, cx
        
        cmp bx, 0
        je generarMatrizNo  
        
    
    generarMatrizSi:
        
        lea si, TableroJuegoDebug
        lea di, tableroJuego
        mov cx, TOTALCELDAS
        
        call CopiarVector
        
        jmp finInicioEntornoBloques
    
    generarMatrizNo:
        
        lea si, tableroJuego
        add si, TOTALCELDAS*2-COLSJUEGO*2
        mov cx, COLSJUEGO
        call GenerarVectorAleatorios
         
    finInicioEntornoBloques:
        
        call BorrarPantalla
    
    pop bx
    pop ax
    pop cx
    pop dx
    
    ret
  InicioEntornoBloques ENDP  
  
  ;F: Lee un comandos hasta que correponda con un formato de salida permitido y devuelve la acción que habrá que realizar:
  ;    formato A (cadenas que solo pueden contener un carácter):             
  ;    "P$" -> paso (seguir jugando sin mover bloque)     ; S: AH=0 
  ;    "N$" -> nuevo juego                                ; S: AH=1 
  ;    "E$" -> salir del juego                            ; S: AH=2

  ;    formato B: una cadena de longitud variable, de hasta 19 caracteres sin incluir el ENTER
  ;    FILCOL XXXXX donde FILCOL representan la posicion de un bloque a mover, siendo FIL un valor de fila entre 'A' y 'G', y COL la columna entre '1' y '5'
  ;    tras el espacio en blanco, XXXXX representa una combinación de caracteres que indican
  ;    'D' desplazar a la derecha
  ;    'A' desplazar a la izquierda         
  ;    'S' desplazar hacia abajo
  ;    'W' desplazar arriba                                
  ;    la salida del formato B es                         ; S: AH=3
  ;S: DI contiene la direccion de memoria de bloque origen
  ;S: SI contiene la direccion de memoria de bloque destino
  
  ComandoEntrada proc  
        
    mov fil, FILCOMANDO
    mov col, COLCOMANDO
    call ColocarCursor
    
    push dx
        lea dx, comando
        mov comando[0], 19
        call LeerCadena  
        cmp comando[3], 13
    pop dx
    
    jne formatoB
    
    formatoA:
        cmp comando[2],'P'
        je comandoP
        cmp comando[2],'N'
        je comandoN             
        cmp comando[2],'E'
        je comandoE
        
        jmp finComandoError
        
        comandoP:
        mov ah, 0
        jmp finComando
        
        comandoN:
        mov ah, 1
        jmp finComando
        
        comandoE:
        mov ah, 2
        jmp finComando
                                             
    
    formatoB:
        cmp comando[2], 'A'
        jl finComandoError
        cmp comando[2], 'H'
        jnl finComandoError
        cmp comando[3], '1'
        jl finComandoError
        cmp comando[3], '6'
        jnl finComandoError
        
        ;La entrada es valida, se almacena el comando
        mov cl, comando[2] ; FILA
        sub cl, 'A'
        mov bl, comando[3] ; COLUMNA
        sub bl, '1'
        mov filMatriz, cl
        mov colMatriz, bl
        call MatrizAVector
        mov dx, posMatriz
        mov di, 0
        add posMatriz, dx
        add di, posMatriz
        mov bp, 5
        
        recorrerCombinacion:
            
            cmp comando[bp], 'W'
            je comandoW
            cmp comando[bp], 'D'
            je comandoD
            cmp comando[bp], 'A'
            je comandoA
            cmp comando[bp], 'S'
            je comandoS
            cmp comando[bp], 13
            je finComandoMovimiento
            
            jmp finComandoError
               
            continuaComando:
                
                mov si, 0
                
                mov filMatriz, cl
                mov colMatriz, bl
                
                call MatrizAVector
                
                push dx
                
                mov dx, posMatriz
                add posMatriz, dx
                
                
                add si, posMatriz
                
                pop dx
                
                inc bp
                
                cmp TableroJuego[si], 0
                jne finComandoMovimiento
                
                jmp recorrerCombinacion
            
                    
            comandoW:
                dec cl
                cmp cl, FILSJUEGO
                jnl finComandoError
                cmp cl, 0
                jl finComandoError
                jmp continuaComando
                   
            comandoD:
                inc bl
                cmp bl, COLSJUEGO
                jnl finComandoError
                cmp bl, 0
                jl finComandoError
                jmp continuaComando
                
                
            comandoA:
                dec bl
                cmp bl, 0
                jl finComandoError
                cmp bl, COLSJUEGO
                jnl finComando
                jmp continuaComando
            
            comandoS:
                inc cl
                cmp cl, 0
                jl finComandoError
                cmp cl, FILSJUEGO
                jnl finComandoError
                jmp continuaComando
                
             finComandoMovimiento:
                
                cmp comando[bp], 13
                jne finComandoError
                
                push dx
                    mov dx, TableroJuego[di]
                    cmp TableroJuego[si], dx
                pop dx
               
                jne finComandoError
                mov ah, 3
                jmp finComando
                
    finComandoError:
        mov ah, 20                
    
    finComando:
    
    push dx
        mov fil, FILCOMANDO
        mov col, COLCOMANDO
        call ColocarCursor
        lea dx, msgBlancoLargo
        call ImprimirCadena
    pop dx
    
    ret
  ComandoEntrada endp
   
  ;F: Los bloques que estaban por encima del bloque origen (Bloque sobre el que comienza el camino) son desplazados
  ;   hacia abajo hasta que encima de ellos se encuentre un 0 o en su defecto el bloque mas alto en el desplazamiento
  ;   coincide con la ultima fila, escribe un 0 simulando que todo lo que esta por fuera de la matriz son 0 para no 
  ;   caer en una condicion de bucle infinito o escriba valores de otro bloque de memoria diferente a TableroJuego
  ;E: DI contiene la direccion de origen del dato
  CaerBloque proc
    push di
    push dx
    push si
    push ax
    
    mov si, 0
    
    desplazarBloquePorCaida:
        
        sub di, COLSJUEGO*2
        cmp di, si
        jnl noSobrePasaLaMatriz
        add di, COLSJUEGO*2
        mov TableroJuego[di], word ptr 0
        jmp finDesplazarBloque
        
    noSobrePasaLaMatriz:
    
        cmp TableroJuego[di], 0
        je finDesplazarBloque
        mov dx, TableroJuego[di]
        add di, COLSJUEGO*2
        mov TableroJuego[di], dx
        sub di, COLSJUEGO*2
        mov TableroJuego[di], word ptr 0 
        jmp desplazarBloquePorCaida
        
    finDesplazarBloque:    
    
    pop ax
    pop si
    pop dx
    pop di
    
    ret
  CaerBloque endp
  
  ;F: Este procedimiento realiza el recorrido si el camino introducido en forma de comando por el usuario es correcto
  ;   Si la combinacion es correcta incrementa el valor del bloque y llama al procedimiento CaerBloque
  ;E: SI contiene la direccion de memoria de bloque destino
  ;E: DI contiene la direccion de memoria de bloque origen
  ;S: DI mantiene la direccion de memoria de bloque origen
  RealizarRecorrido proc
    push ax   
        mov ax, posMatriz
        sub ax, dx
        cmp dx, ax
                    
    ;pop ax
                    
        je finComando
                   
        mov di, 0
                   
    ;push ax
                    
        mov ax, 2
                    
        mul dx
                    
        mov dx, ax
                    
    ;pop ax
                    
        add di, dx
                    
        mov dx, TableroJuego[di]
                    
        cmp TableroJuego[si], dx
        jne finRecorrido
        shl TableroJuego[di], 1
        mov dx, TableroJuego[di]
        mov TableroJuego[si], dx
        mov TableroJuego[di], word ptr 0
        call CaerBloque
        call PintarTableroJuego
        
        finRecorrido:
    pop ax    
    ret
  RealizarRecorrido endp
  
;*************************************************************************************                                                                                                                        
;**********************    procedimientos de funcionlidad    *************************
;*************************************************************************************    
  
  ;F: Genera un vector de CX valores aleatorios potencia de 2 entre 2^1 y 2^4  
  ;E: CX, dirección del vector donde almacenar cada dato
  ;    SI, número de valores aleatorios a generar y almacenar
  ;S: El vector contiene los valores aleatorios
  
  GenerarVectorAleatorios proc
    push cx 
    push dx
    push si
    push ax
    
    mov bx, 0 
    mov bl, 4
    
    
    potencia:
       
      call NumAleatorio
      mov dx, 2
      push cx ; Almacenamos el indice del bucle
          mov cl, ah
          shl dx, cl
      pop cx ; Recuperamos el indice del bucle
	  mov [si], dx 
	  add si,2
    loop potencia
    
    pop ax
    pop si 
    pop dx
    pop cx 
    ret   
  GenerarVectorAleatorios endp
  
  ;F: Este procedimiento sube los elementos una fila hacia arriba para generar un espacio
  ;   en blanco justo debajo de dicha fila y llama al procedimiento generar vector aleatorio para
  ;   rellenar dicha fila en blanco con elementos aleatorios comprendidos ente 2^1 y 2^4
  SubirElementosFila proc
    push cx 
    push di
    push si
    push di

    lea si, TableroJuego
    lea di, TableroJuego
    
    mov cx, TOTALCELDAS-COLSJUEGO        
    
    add si, COLSJUEGO*2
        
    call CopiarVector                                      
                        
    lea si, TableroJuego
    
    add si, TOTALCELDAS*2-COLSJUEGO*2
    
    mov cx, COLSJUEGO
    
    call GenerarVectorAleatorios
             
    pop di
    pop si
    pop di     
    pop cx
    ret

  SubirElementosFila endp
  
  ;F: Comprueba si se dan las condiciones de fin de juego por haber elementos en la fila superior
  ;   Si el tablero tiene algún bloque en la primera fila, se ha perdido
  ;E: TableroJuego, SI
  ;    COLSJUEGO  
  ;S: DX=0 si no es fin de juego y el juego debe continuar
  ;   DX=1 si el juego debe terminar
  ;   imprime mensaje de partida perdida en la posición FILMSJGNRAL, COLMSJGNRAL de pantalla, si es el caso
  comprobarFinJuegoFila proc
    push ax
    push si
    
    mov si, 0
    
    mov cx, COLSJUEGO
    comprobarFinJuegoPerdido:
        mov ax, TableroJuego[si]
        cmp ax, 0
        jne finJuegoTopePerdido
        add si, 2
    loop comprobarFinJuegoPerdido
                 
    mov dx, 0
    jmp continuarJuegoTopePerdido
    
    finJuegoTopePerdido:
        mov dx, 1 
        
    continuarJuegoTopePerdido:
    
    pop si
    pop ax
    ret
  comprobarFinJuegoFila endp
  
  
  ;F: Comprueba si se dan las condiciones de fin de juego. Si hay una celda con valor tope (DW) se ha ganado
  ;E: tablero de juego numero de celdas del tablero tope, variable DW
  ;S: DX=0 si no es fin de juego y el juego debe continuar
  ;    DX=1 si es fin de juego y el juego debe terminar (se puede crear algún estado más si se considera oportuno)
  ;    mensajes de partida ganada en la posición FILMSJGNRAL, COLMSJGNRAL de pantalla, si es el caso
  comprobarFinJuegoTope proc
    push ax
    push si
    push cx
    
    mov si, 0
    mov cx, TOTALCELDAS
    comprobarFinJuego:
        mov ax, TableroJuego[si]
        cmp ax, tope
        je finJuegoTope
        add si, 2
    loop comprobarFinJuego
                 
    mov dx, 0
    jmp continuarJuegoTope
    
    finJuegoTope:
        mov dx, 1 
        
    continuarJuegoTope:
    
    pop cx
    pop si
    pop ax
    ret  
  comprobarFinJuegoTope endp
;************************ PROGRAMA PRINCIPAL ***************
principal:
    mov ax, data
    mov ds, ax      
    
    ;------------------------------------------- 
    ; Se ejecuta siempre al incio si el usuario intoduce
    ; el comando 'N'
    menuInicial: 
    
        call InicioEntornoBloques
        
        mov fil, FILPANTALLAJ
        mov col, COLPANTALLAJ
        call ColocarCursor
    
        lea dx, pantTablero
        call ImprimirCadena
        
        
    rellenarTableroPantalla:
    
        call PintarTableroJuego
        
    ;------------------------------------------- 
    ; Llama al procedimiento que solicita al usuario
    ; un comando que puede tener dos formatos, aqui
    ; se controla que salida ha tenido ese procedimiento
    ; y salta condicionalmente a la etiqueta que este
    ; relacionada con dicha salida, si ninguna salida
    ; corresponde con ninguna etiqueta, se vuelve a solicitar
    ; un comando ya que se identifica como no valido
    solicitarComando:
        
        call ComandoEntrada
        cmp ah, 0
        je subirFilaBloques
        cmp ah, 1
        je nuevoJuego
        cmp ah, 2
        je finJuego
        cmp ah, 3
        je comprobarJuegoPorTope
        
        jmp solicitarComando 
        
    ;------------------------------------------- 
    ; Si el usuario invoco el comando 'N'
    nuevoJuego:
    
        call BorrarPantalla
        lea di, TableroJuego
        mov cx, TOTALCELDAS
        call BorrarVector
        jmp menuInicial
        
    ;------------------------------------------- 
    ; Si el usuario invoco el comando 'P'
    subirFilaBloques:       
        
        call comprobarFinJuegoFila
        cmp dx, 0
        jne finJuegoPerdido
        call SubirElementosFila
        call PintarTableroJuego
        jmp solicitarComando
        
    ;------------------------------------------- 
    ; Comprueba si una celda contiene el elemento tope
    ; esto solo puede darse si el camino es correcto y
    ; se han fusionado dos bloques
    comprobarJuegoPorTope:    
        
        call RealizarRecorrido 
        call comprobarFinJuegoTope
        cmp dx, 0
        je solicitarComando
        jmp finJuegoGanado
        
    ;------------------------------------------- 
    ; Si la fila superior contenia elementos y el usuario invoco el comando 'P'
    finJuegoPerdido:         
        mov fil, FILMSJGNRAL
        mov col, COLMSJGNRAL   
        call ColocarCursor
        lea dx, msjPartidaPerdida
        call ImprimirCadena
        jmp finJuego
        
    ;------------------------------------------- 
    ; Si tras comprobar alguna celda contiene el valor tope
    finJuegoGanado:
        mov fil, FILMSJGNRAL
        mov col, COLMSJGNRAL   
        call ColocarCursor
        lea dx, msjPartidaGanada
        call ImprimirCadena
    
    ;------------------------------------------- 
    ; Retorna el control al sistema si el juego se detuvo ya sea por perder, ganar
    ; invocar al comando 'E'
    finJuego:
      
    mov ah, 4ch
    int 21h        
 ends 
end principal   
     