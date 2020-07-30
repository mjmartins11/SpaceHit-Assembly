; Laboratorio de Organização e Arquitetura de Computadores

; --------------------
; 	Jogo - Space Hit
; --------------------

; Isadora Carolina Siebert  NUSP: 11345580
; Marlon José Martins 		NUSP: 10249010

jmp main

superficie:	 string "========================================"
strApagar: 	 string "         "
strScore:	 string "SCORE:"

strFim1: 	 string "S E U  S C O R E  F O I: "
strFim2: 	 string "Quer jogar novamente? <s/n>"

strNave1: 	 string "   /\\"
strNave2:	 string " _/--\\_"
strNave3:	 string "|_|..|_|"
strNave4: 	 string " * -- *"

strInimigo1: string "  /..\\"
strInimigo2: string " /:..:\\"   
strInimigo3: string "(:)\\/(:)"
strInimigo4: string "|/    \\|"

letra:			var #1	; letra que sera' digitada na tela inicial do jogo
score:			var #1	; pontuação do jogador

posNave:		var #1	
posAntNave:		var #1

velInimigo:		var #1	; velocidade do inimigo
posInimigo:		var #1
posAntInimigo:	var #1
flagInimigo:	var #1	; utilizada para verificar se existe um inimigo

posTiro: 		var #1
posAntTiro:		var #1
flagTiro:		var #1	; utilizada para verificar se a nave esta atirando

; ------- Funcao principal do jogo -------
main:
	call apagaTelaInteira			; apaga toda tela	
	loadn r1, #telaInicioLinha0		; posicao inicial da tela
	loadn r2, #2816					; cor amarela
	call ImprimeTela				; chama a funcao que imprime a tela de inicio
	
loopInicio:
	call DigLetra			; chama a funcao que vai receber a letra digitada pelo usuario	
	loadn r0, #' '			; quando a tecla espaco for acionada, comeca o jogo
	load r1, letra
	cmp r0, r1
	jne loopInicio			; loop ate a tecla de espaco ser pressionada
	
	call apagaTelaInteira	
	call imprimirTelaInicio
	
	loadn r0, #1016			; posição inicial da nave na tela (1016)
	store posNave, r0		
	store posAntNave, r0
	
	; zera variaveis do tiro
	loadn r0, #0	
	store flagTiro, r0		
	store posTiro, r0		
	store posAntTiro, r0
	
	loadn r1, #5
	store velInimigo, r1		; velocidade inicial do inimigo = 5	
	store flagInimigo, r0
	store posInimigo, r0		
	store posAntInimigo, r0
	
	
	loadn r2, #0			; Para verificar se (mod(c/10) == 0)	
	
Loop:
	loadn r1, #1
	mod r1, r0, r1
	cmp r1, r2		; if (mod(c/2) == 0)
	ceq MoveNave	; chama rotina de movimentacao da nave

	load r1, velInimigo
	mod r1, r0, r1
	cmp r1, r2		; if (mod(c/velInimigo) == 0)
	ceq MoveInimigo	; chama rotina de movimentacao do inimigo

	loadn r1, #1
	mod r1, r0, r1
	cmp r1, r2		; if (mod(c/1) == 0)
	ceq MoveTiro	; chama rotina de movimentacao do tiro

	call Delay
	inc r0 			;c++
	jmp Loop

DigLetra:						; espera que uma tecla seja digitada e salva na variavel global Letra
	push r0
	push r1
	loadn r1, #255

DigLetra_Loop:
	inchar r0					; le o teclado, se nada for digitado = 255
	cmp r0, r1					; compara r0 com 255
	jeq DigLetra_Loop			; fica lendo ate que o jogador digite uma tecla valida

	store letra, r0				; salva a tecla na variavel global "Letra"

	pop r1
	pop r0
	rts

; Parâmetros:
;  r1 = endereco onde comeca a primeira linha do Cenario
;  r2 = cor do Cenario para ser impresso	
ImprimeTela: 						;  Rotina de impresao do cenario na tela
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5

	loadn r0, #0  					; Posicao inicial
	loadn r3, #40  					; Incremento da posicao da tela
	loadn r4, #41  					; Incremento do ponteiro das linhas da tela
	loadn r5, #1200 				; Limite da tela
	
   ImprimeTela_Loop:
		call Imprimestr
		add r0, r0, r3  			; Incrementa posicao para a segunda linha na tela
		add r1, r1, r4  			; Incrementa o ponteiro para o comeco da proxima linha na memoria
		cmp r0, r5					; Compara r0 com 1200
		jne ImprimeTela_Loop		; Enquanto r0 < 1200

	pop r5							
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
;------------- Nave --------------
MoveNave:
	push r0
	push r1
	call MoveNave_RecalculaPos		; recalcula Posicao da Nave

	load r0, posNave
	load r1, posAntNave
	cmp r0, r1						; compara as posicoes anterior e atual da nave para verificar se ela se moveu
	jeq MoveNave_Skip				

	call ApagarNave				
	call DesenharNave

MoveNave_Skip:
	pop r1
	pop r0
	rts
	
MoveNave_RecalculaPos:		; Recalcula posicao da Nave em funcao das Teclas pressionadas
	push r0
	push r1
	push r2
	push r3

	load r0, posNave
	
	inchar r1				; lê teclado para controlar a Nave
	loadn r2, #'a'
	cmp r1, r2
	jeq MoveNave_RecalculaPos_A
	
	loadn r2, #'d'
	cmp r1, r2
	jeq MoveNave_RecalculaPos_D
	
	loadn r2, #' '
	cmp r1, r2
	jeq MoveNave_RecalculaPos_Tiro
	
MoveNave_RecalculaPos_Fim:	; se nao for nenhuma tecla valida, vai embora
	store posNave, r0
	pop r3
	pop r2
	pop r1
	pop r0
	rts

MoveNave_RecalculaPos_A:	; move nave para esquerda
	loadn r1, #1000
	cmp r1, r0
	jeq MoveNave_RecalculaPos_Fim
	dec r0	; pos = pos -1
	jmp MoveNave_RecalculaPos_Fim
		
MoveNave_RecalculaPos_D:	; move nave para direita	
	loadn r1, #1032
	cmp r1, r0
	jeq MoveNave_RecalculaPos_Fim
	inc r0	; pos = pos + 1
	jmp MoveNave_RecalculaPos_Fim

MoveNave_RecalculaPos_Tiro:	
	call ApagarTiro
	loadn r1, #1			; se atirou:
	store flagTiro, r1		; FlagTiro = 1
	loadn r1, #36
	sub r0, r0, r1
	store posTiro, r0		; posTiro = posNave
	add r0, r0, r1
	jmp MoveNave_RecalculaPos_Fim	

DesenharNave:	
	push r0
	push r1
	push r2
	push r3
	
	load r3, posNave
	
; ----- posicao da primeira linha da nave( /\ )
	loadn r0, #0
	add r0, r0, r3
	
	loadn r1, #strNave1		; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #512			; Seleciona a COR
	call Imprimestr
	
; ------ posicao da segunda linha da nave ( _/--\_ )
	loadn r0, #40
	add r0, r0, r3
	
	loadn r1, #strNave2		; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #512			; Seleciona a COR 
	call Imprimestr
	 
; ----- posicao da terceira linha da nave ( |_|..|_| )
	loadn r0, #80
	add r0, r0, r3
	
	loadn r1, #strNave3		; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #512			; Seleciona a COR 
	call Imprimestr
	 
; ----- posicao da quarta linha da nave ( * -- * )
	loadn r0, #120
	add r0, r0, r3
	
	loadn r1, #strNave4		; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #512			; Seleciona a COR 
	call Imprimestr

	store posAntNave, r3

	pop r3
	pop r2
	pop r1
	pop r0
	rts
		
ApagarNave:		
	push r0
	push r1
	push r2
	push r3
	
	load r3, posAntNave
	
; ----- posicao da primeira linha da nave( /\ )
	loadn r0, #0
	add r0, r0, r3
	
	loadn r1, #strApagar	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #0			; Seleciona a COR da Mensagem
	call Imprimestr
	
; ------ posicao da segunda linha da nave ( _/--\_ )
	loadn r0, #40
	add r0, r0, r3
	
	loadn r1, #strApagar	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #0			; Seleciona a COR da Mensagem
	call Imprimestr
	 
; ----- posicao da terceira linha da nave ( |_|..|_| )
	loadn r0, #80
	add r0, r0, r3
	
	loadn r1, #strApagar	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #0			; Seleciona a COR da Mensagem
	call Imprimestr
	 
; ----- posicao da quarta linha da nave ( * -- * )
	loadn r0, #120
	add r0, r0, r3
	
	loadn r1, #strApagar	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #0			; Seleciona a COR da Mensagem
	call Imprimestr
	
	pop r3
	pop r2
	pop r1
	pop r0
	rts

;-------- Inimigo ---------
MoveInimigo:
	push r0
	push r1
	push r2
	
	load r1, flagInimigo 	; verficando se inimigo já existe
	loadn r2, #1
	cmp r1, r2				; se flagInimigo == 0 então cria um inimigo
	jeq MoveInimigo_Skip
	
	; se o inimigo não existe então gera um posição aleatória para ele começar
	call gerarRand
	load r0, rand
	
	loadn r1, #32	; 32 = largura da tela
	mod r0, r0, r1 	; r0 = r0 % 32
	loadn r2, #40
	add r0, r0, r2
	
	loadn r2, #1
	store posInimigo, r0
	store posAntInimigo, r0
	store flagInimigo, r2
	
MoveInimigo_Skip:
	call movimentaInimigo
	pop r2
	pop r1
	pop r0
	rts
	
movimentaInimigo:
	push r0
	push r1
	push r2

	load r0, posInimigo
	loadn r1, #963
	
	; if(r0 > 963) chegou na linha da nave
	cmp r0, r1
	jgr fimJogo
	
	loadn r2, #40
	add r0, r0, r2
	
	store posInimigo, r0
	call ApagarInimigo
	call DesenharInimigo
	
	pop r2
	pop r1
	pop r0
	rts
	
;  /""\   
; /:..:\
;(:)\/(:)
;|/    \|
DesenharInimigo:
	push r0
	push r1
	push r2
	push r3
	
	load r3, posInimigo
; ----- posicao da primeira linha do inimigo /""\ 
	loadn r0, #0
	add r0, r0, r3
	loadn r1, #strInimigo1	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #3072		; verde
	call Imprimestr
	
; ------ posicao da segunda linha do inimigo /:..:\
	loadn r0, #40
	add r0, r0, r3
	
	loadn r1, #strInimigo2	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #3072			; verde
	call Imprimestr
	 
; ----- posicao da terceira linha do inimigo (:)\/(:)
	loadn r0, #80
	add r0, r0, r3
	
	loadn r1, #strInimigo3	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #3072			; verde
	call Imprimestr
	 
; ----- posicao da quarta linha do inimigo |/    \|
	loadn r0, #120
	add r0, r0, r3
	
	loadn r1, #strInimigo4	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #3072			; verde
	call Imprimestr
	
	store posAntInimigo, r3
	
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
ApagarInimigo:
	push r0
	push r1
	push r2
	push r3
	
	load r3, posAntInimigo
	
; ----- posicao da primeira linha da nave( /\ )
	loadn r0, #0
	add r0, r0, r3
	
	loadn r1, #strApagar	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #3328			; Seleciona a COR 
	call Imprimestr
	
; ------ posicao da segunda linha da nave ( _/--\_ )
	loadn r0, #40
	add r0, r0, r3
	
	loadn r1, #strApagar	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #3328			; Seleciona a COR 
	call Imprimestr
	 
; ----- posicao da terceira linha da nave ( |_|..|_| )
	loadn r0, #80
	add r0, r0, r3
	
	loadn r1, #strApagar	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #3328			; Seleciona a COR 
	call Imprimestr
	 
; ----- posicao da quarta linha da nave ( * -- * )
	loadn r0, #120
	add r0, r0, r3
	
	loadn r1, #strApagar	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #3328			; Seleciona a COR 
	call Imprimestr
	
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
;-------- Tiro ---------------
MoveTiro:
	push r0
	push r1
	
	call ApagarTiro
	call MoveTiro_RecalculaPos
	call DesenharTiro
 
	pop r1
	pop r0
	rts
		
MoveTiro_RecalculaPos:
	push r0
	push r1
	push r2
	push r3
	
	load r1, flagTiro	; se atirou, movimenta o tiro
	loadn r2, #1
	cmp r1, r2			; if FlagTiro == 1  movimenta o tiro
	jne MoveTiro_RecalculaPos_Fim2	; se nao vai embora
	
	load r0, posTiro	; testa se o tiro pegou no inimigo
	load r1, posInimigo
	loadn r3, #80
	add r1, r1, r3		; parte da frente do inimigo (parte dele mais inferior na tela)
	cmp r0, r1			; IF posTiro == posInimigo  -> BOOM
	jle MoveTiro_RecalculaPos_Skip
	
	loadn r3, #8
	add r1, r1, r3
	cmp r0, r1
	jle MoveTiro_RecalculaPos_Boom
	
MoveTiro_RecalculaPos_Skip:
	loadn r1, #80		; testa condicoes de contorno (se a posicao do tiro for > 40) 	
	cmp r0, r1			; se tiro chegou na ultima linha
	jgr MoveTiro_RecalculaPos_Fim
	
	loadn r0, #0
	store flagTiro, r0	; zera FlagTiro
	store posTiro, r0
	jmp MoveTiro_RecalculaPos_Fim2	

MoveTiro_RecalculaPos_Boom:
 	call ApagarInimigo
 	call ApagarTiro
 	
 	; atualiza a pontuação
 	load r0, score
	inc r0
	store score, r0
	
	loadn r1, #38	; posição da pontuação na tela
	call imprimeNum
	
	loadn r2, #5
 	loadn r1, #0
	mod r2, r2, r0
	cmp r1, r2 				; if mod(score/5) == 0
	ceq aumenta_velInimigo	; aumenta a velocidade do inimigo
	
 	loadn r0, #0
 	store flagTiro, r0		; o tiro some
 	store flagInimigo, r0	; o inimigo também some então flag == 0
 	
 	store posTiro, r0
 	store posAntTiro, r0
 	
 	store posInimigo, r0
 	store posAntInimigo, r0
 	
 	jmp MoveTiro_RecalculaPos_Fim2
 
MoveTiro_RecalculaPos_Fim:
	loadn r1, #40 
	sub r0, r0, r1
	store posTiro, r0
	
MoveTiro_RecalculaPos_Fim2:	
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
aumenta_velInimigo:
	push r0
	push r1
	
	; se a velocidade do inimigo for 2, não diminui mais (inversamente proporcional)
	load r0, velInimigo
	loadn r1, #1
	cmp r0, r1
	jeq aumenta_velInimigo_Skip
	
	; senão a velocidade diminui 3
	loadn r1, #1
	sub r0, r0, r1
	store velInimigo, r0

aumenta_velInimigo_Skip:
	pop r1
	pop r0
	rts
	
DesenharTiro:
	push r0
	push r1
	push r2
	
	load r0, posTiro
	loadn r1, #'!'	; Tiro
	loadn r2, #2304
	
	add r1, r2, r1
	outchar r1, r0
	
	pop r2
	pop r1
	pop r0
	rts
	
ApagarTiro:
	push r0
	push r1
	
	load r0, posTiro
	loadn r1, #' '
	outchar r1, r0
	
	pop r1
	pop r0
	rts

; ------- RAND -------
rand: var #1
static rand, #53 ; seed inicial

; gera numeros aleatorios de 0 a 255
; (SEED * a + c) % p
gerarRand:
	push r0
	push r1
	push r2
	push r3
	
	load r0, rand	; SEED
	loadn r1, #97	; a
	loadn r2, #133 	; c
	loadn r3, #256 	; p
	mul r0, r0, r1  ; SEED * a
	add r0, r0, r2  ; SEED * a + c
	mod r0, r0, r3  ; (SEED * a + c) % p
	
	store rand, r0
	
	pop r3
	pop r2
	pop r1
	pop r0
	rts

;------------- Delay -----------------	
Delay:
	push r0
	push r1
	
	loadn r1, #50  ; a
	
Delay_volta2:				; quebrou o contador acima em duas partes (dois loops de decremento)
	loadn r0, #3000	; b
	
Delay_volta: 
	dec r0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	jnz Delay_volta
		
	dec r1
	jnz Delay_volta2
	
	pop r1
	pop r0
	
	rts
;----------------- Imprimir Telas --------------------------

fimJogo:
	call imprimirFimJogo
	
	inchar r1
	loadn r0, #'n'
	cmp r0, r1				; tecla == 'n' ?
	jeq fimPrograma			; encerra o programa
	
	loadn r0, #'s'
	cmp r0, r1				; tecla == 's' ?
	jne fimJogo				; se não for s volta para tela fimJogo

	; se a tecla for s então recomeça o jogo
	call apagaTelaInteira
	jmp main
	
fimPrograma:
	call apagaTelaInteira	
	halt
	
imprimirFimJogo:
	push r0
	push r1
	push r2
	
	loadn r0, #525			; Posicao na tela onde a mensagem sera' escrita
	loadn r1, #strFim1		; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #0			; Seleciona a COR da Mensagem
	call Imprimestr
	
	load r0, score
	loadn r1, #551
	call imprimeNum
	
	loadn r0, #605
	loadn r1, #strFim2
	loadn r2, #0
	call Imprimestr
		
	pop r2
	pop r1
	pop r0
	rts

apagaTelaInteira:
	loadn r0, #1200
	loadn r1, #0
	loadn r2, #' '

loop_apagaTelaInteira:
	outchar r2, r1
	inc r1
	cmp r1, r0
	jne loop_apagaTelaInteira
	
	rts
	
imprimirTelaInicio:
	push r0	
	push r1
	push r2
	push r3
	
	loadn r0, #1160		    ; Posicao na tela onde a mensagem sera' escrita
	loadn r1, #superficie	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #0			; Seleciona a COR da Mensagem
	call Imprimestr
	
	loadn r0, #30
	loadn r1, #strScore
	loadn r2, #0
	call Imprimestr
	
	loadn r3, #0
	store score, r3
	nop
	nop
	nop
	load r0, score
	loadn r1, #38
	call imprimeNum
	
	pop r3
	pop r2
	pop r1
	pop r0
	rts

; --------------- Rotina de Impressao de Mensagens ----------------    
; r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso
; r1 = endereco onde comeca a mensagem
; r2 = cor da mensagem
Imprimestr:	
	push r0
	push r1
	push r2
	push r3
	push r4
	
	loadn r3, #'\0'	; criterio de parada

loop_Imprimestr:	
	loadi r4, r1
	cmp r4, r3
	jeq ImprimestrSai
	
	add r4, r2, r4
	outchar r4, r0
	inc r0
	inc r1
	jmp loop_Imprimestr
	
ImprimestrSai:	
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
; r0 = num
; r1 = posição na tela inicial (vai escrever da direita para a esquerda)
imprimeNum:
	push r0
	push r1
	push r3
	push r4
	push r5
	
	loadn r5, #'0'
	
loop_ImprimeNum:
	loadn r4, #10
	
	mod r3, r0, r4; r3 = num % 10
	add r3, r3, r5; r3 = r3 + '0';
	
	outchar r3, r1
	
	dec r1
	div r0, r0, r4
	
	loadn r4, #0
	cmp r0, r4
	jne loop_ImprimeNum

	pop r5
	pop r4
	pop r3
	pop r1
	pop r0
	rts
	

; -------------------------- TELA DE INICIO ----------------------------------
telaInicioLinha0 : string "                                        "
telaInicioLinha1 : string "                                        "
telaInicioLinha2  : string "                                        "
telaInicioLinha3  : string "                                        "
telaInicioLinha4  : string "                                        "
telaInicioLinha5  : string "                                        "
telaInicioLinha6  : string "      ____                              "
telaInicioLinha7 : string "     / ___|  ___   __ _  ___ ___        "                  
telaInicioLinha8 : string "     \\___ \\ | _ \\ / _` |/ __/ _ \\      "                  
telaInicioLinha9 : string "       ___) |||_)|| (_| ||(_|  __/      "
telaInicioLinha10 : string "      |____/ | __/ \\__,_|\\___\\___|     "                   
telaInicioLinha11 : string "              |_|                       "                  
telaInicioLinha12  : string "               _   _                    "
telaInicioLinha13  : string "              | | | | _  ___           "
telaInicioLinha14  : string "               | |_| || ||   |          "
telaInicioLinha15  : string "               |  _  || | | |           "
telaInicioLinha16  : string "               |_| |_||_| |_|        "           
telaInicioLinha17 : string "                                        "
telaInicioLinha18 : string "                                        "
telaInicioLinha19 : string "                                        "
telaInicioLinha20 : string "                                        "
telaInicioLinha21 : string "           PRESSIONE ESPACO PARA INICIAR"
telaInicioLinha22 : string "                                        "
telaInicioLinha23 : string "                                        "
telaInicioLinha24 : string "                                        "
telaInicioLinha25 : string "                                        "
telaInicioLinha26 : string "                                        "
telaInicioLinha27 : string "                                        "
telaInicioLinha28 : string "                                        "
telaInicioLinha29 : string "                                        "