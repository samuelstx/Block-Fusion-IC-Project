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
   TableroJuegoDebug dw 0,0,0,0,0,0,4,2,8,2,0,8,4,2,2,0,2,2,2,2,0,8,2,8,8,0,2,2,8,2,0,8,4,2,16  ;matriz con datos precargados
   
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
    
    mov fil, 0
    mov col, 0
    
    call ColocarCursor
    
    lea dx, PantallaInicio
    call ImprimirCadena 
    
    mov fil, 20
    mov col, 5
    
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
        
        lea si, tableroJuegoDebug
        lea di, tableroJuego
        mov cx, TOTALCELDAS
        
        call CopiarVector
        
        jmp finPreguntarDebug
    
    respuetaNoPreguntarDebug:
        
        lea si, tableroJuego
        add si, TOTALCELDAS*2-COLSJUEGO*2
        mov cx, COLSJUEGO
        call GenerarVectorAleatorios

    
    finPreguntarDebug:
        call BorrarPantalla
    pop ax
    pop cx
    pop dx
    
    ret
  InicioEntornoBloques ENDP
  
  ;F: Pinta en la pantalla TableroJuego   
  ;E: FILINICIOTAB, COLINICIOTAB (EQU) posicíon donde imprimir el tablero  
  ;E: tableroJuego (vector DB) y sus dimensiones como matriz FILJUEGO y COLJUEGO (EQU)
  ;E: fil y col para usar ColocarCursor
  ;E: cad y cadVacia (cadenas DB) para usar con ImprimirCadena
  ;S: pantalla
  PintarTableroJuego  PROC
    push ax
    push bx
    push cx
    push dx
    push si

    lea si, tableroJuego
      
    mov fil, FILINICIOTAB ;primera fila de la pantalla de juego
    xor bx, bx  
    mov cx, FILSJUEGO
     
   sigueFil:
    push cx
    mov col, COLINICIOTAB ; primera columna de la pantalla de juego 
    mov cx, COLSJUEGO 
 
   sigueCol:
    call ColocarCursor
    lea dx, cadVacia
    call ImprimirCadena
    call ColocarCursor 

    mov ax, [si+bx] 
    cmp ax, 0
    je siguecelda 
       
    lea dx, cad
    call NumeroACadena
    call imprimirCadena
      
   siguecelda:
    add bx, 2  
    add col, 6    ; se mueve por la misma fila
    loop sigueCol

    pop cx
    mov col, COLINICIOTAB 
    add fil, 3    ; cambia a la fila siguiente
  
    loop sigueFil
    
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret 
  PintarTableroJuego ENDP    
  
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
  ComandoEntrada proc  
    push dx
    push si
    push bx
    push cx
    
    mov fil, FILCOMANDO
    mov col, COLCOMANDO
    call ColocarCursor
    
    lea dx, comando
    mov comando[0], 19
    call LeerCadena  
    cmp comando[3], 13
    jne formatoB
    
    formatoA:
        cmp comando[2],'P'
        je comandoP
        cmp comando[2],'N'
        je comandoN             
        cmp comando[2],'E'
        je comandoE
        
        jmp finComando
        
        comandoP:
        call SubirElementosFila
        call PintarTableroJuego
        mov ah, 0
        jmp finComando
        
        comandoN:
        mov ah, 1
        call BorrarPantalla
        mov cx, TOTALCELDAS
        call BorrarVector
        jmp finComando
        
        comandoE:
        mov ah, 2
        jmp finComando
         
    
    formatoB:
        cmp comando[2], 65
        jl finComando
        cmp comando[2], 71
        jnl finComando
        cmp comando[3], 49
        jl finComando
        cmp comando[3], 53
        jnl finComando
        
        ;La entrada es valida, se almacena el comando
        mov ch, 0
        mov cl, comando[2] ; Columna 
        mov bh, 0
        mov bl, comando[3] ; Fila
        
        mov si, 5
        
        recorrerCombinacion:
            
            cmp comando[si], 'W'
            je comandoW
            cmp comando[si], 'D'
            je comandoD
            cmp comando[si], 'A'
            je comandoA
            cmp comando[si], 'S'
            je comandoS
            cmp comando[si], 13
            jne finComando
               
            continuaComando:
                inc si
                cmp si, 9
                jne recorrerCombinacion
                mov ah, 3
                jmp finComando
                
            comandoW:
                inc bl
                cmp bl, 53
                jnl finComando
                jmp continuaComando
                   
            comandoD:
                inc cl
                cmp cl, 71
                jnl finComando
                jmp continuaComando
                
                
            comandoA:
                dec cl
                cmp cl, 65
                jl finComando
                jmp continuaComando
            
            comandoS:
                dec bl
                cmp bl, 49
                jl finComando
                jmp continuaComando
                    
    
    finComando:
    
    pop cx
    pop bx    
    pop si
    pop dx
    ret
  ComandoEntrada endp
  
  ;F: Genera un vector de CX valores aleatorios potencia de 2 entre 2^1 y 2^4  
  ;E: CX, dirección del vector donde almacenar cada dato
  ;    SI, número de valores aleatorios a generar y almacenar
  ;S: El vector contiene los valores aleatorios
  GenerarVectorAleatorios proc
    push cx ;loop
    push dx
    push si
    
    potencia:
      mov bl, 4
      call NumAleatorio
      mov dx, 2
      push cx
      mov cl, ah
      shl dx, cl
      pop cx
	  mov [si], dx; no es suficiente mov [di],0 , que solo pone la parte baja a 0
	  add si,2
    loop potencia

    pop si 
    pop dx
    pop cx 
    ret   
  GenerarVectorAleatorios endp
  
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
  
  ;F: Comprueba si se dan las condiciones de fin de juego. Si hay una celda con valor tope (DW) se ha ganado
  ;E: tablero de juego numero de celdas del tablero tope, variable DW
  ;S: DX=0 si no es fin de juego y el juego debe continuar
  ;    DX=1 si es fin de juego y el juego debe terminar (se puede crear algún estado más si se considera oportuno)
  ;    mensajes de partida ganada en la posición FILMSJGNRAL, COLMSJGNRAL de pantalla, si es el caso
  comprobarFinJuegoTope proc
    push ax
    push si
    push cx
    
    mov cx, TOTALCELDAS
    comprobarFinJuego:
        mov ax, [si]
        cmp ax, tope
        je finJuegoTope
        add si, 2
    loop comprobarFinJuego
                 
    mov dx, 0
    jmp continuarJuegoTope
    
    finJuegoTope:
        mov dx, 1
        mov fil, FILMSJGNRAL
        mov col, COLMSJGNRAL   
        call ColocarCursor
        lea dx, msjPartidaGanada
        call ImprimirCadena 
        
    continuarJuegoTope:
    
    pop cx
    pop si
    pop ax
    ret  
  comprobarFinJuegoTope endp
  
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
    
    lea si, TableroJuego
    
    mov cx, COLSJUEGO
    comprobarFinJuegoPerdido:
        mov ax, [si]
        cmp ax, 0
        jne finJuegoTopePerdido
        add si, 2
    loop comprobarFinJuegoPerdido
                 
    mov dx, 0
    jmp continuarJuegoTopePerdido
    
    finJuegoTopePerdido:
        mov dx, 1
        mov fil, FILMSJGNRAL
        mov col, COLMSJGNRAL   
        call ColocarCursor
        lea dx, msjPartidaPerdida
        call ImprimirCadena 
        
    continuarJuegoTopePerdido:
    
    pop si
    pop ax
    ret
  comprobarFinJuegoFila endp
  
  
  
;*************************************************************************************                                                                                                                        
;**********************    procedimientos de funcionlidad    *************************
;*************************************************************************************    
  

;************************ PROGRAMA PRINCIPAL ***************
principal:
    mov ax, data
    mov ds, ax
    
    mov tope, 32         

    menuInicial: 
    
        call InicioEntornoBloques
        
        mov fil, FILPANTALLAJ
        mov col, COLPANTALLAJ
        call ColocarCursor
    
        lea dx, pantTablero
        call ImprimirCadena
                 
        
    rellenarTableroPantalla:
        
        call PintarTableroJuego
     
    solicitarComando:
        
        call ComandoEntrada
        cmp ah, 0
        je comprobarJuegoLimite
        cmp ah, 1
        je menuInicial
        cmp ah, 2
        je finJuego
        cmp ah, 3
        je comprobarFinJuegoTope
        
    ; Comprobar final de juego por valor tope
    comprobarJuegoLimite:       
        
        call comprobarFinJuegoTope
        cmp dx, 0
        je solicitarComando
        jmp finJuego
        
        ;-------------------------------------------
    
    ; Comprobar final de juego por tablero lleno    
    comprobarJuegoPorTope:    
         
        call comprobarFinJuegoFila
        cmp dx, 0
        je solicitarComando
        
        ;------------------------------------------- 
    
    finJuego:
      
    mov ah, 4ch
    int 21h        
 ends 
end principal   
     