; Laboratorio de Organização e Arquitetura de Computadores
 
; --------------------
; 	Jogo - SpaceHit
; --------------------
  
; Isadora Carolina Siebert  NUSP: 11345580
; Marlon José Martins 		NUSP: 10249010

; ------- TABELA DE CORES -------
; adicione ao caracter para Selecionar a cor correspondente

; 0 branco							0000 0000
; 256 marrom						0001 0000
; 512 verde							0010 0000
; 768 oliva							0011 0000
; 1024 azul marinho					0100 0000
; 1280 roxo							0101 0000
; 1536 teal							0110 0000
; 1792 prata						0111 0000
; 2048 cinza						1000 0000
; 2304 vermelho						1001 0000
; 2560 lima							1010 0000
; 2816 amarelo						1011 0000
; 3072 azul							1100 0000
; 3328 rosa							1101 0000
; 3584 aqua							1110 0000
; 3840 branco						1111 0000

jmp main

superficie:			string "========================================"

StrPerdeu:			string "FIM!"
StrPressEnter:		string "Aperte ENTER para"
StrJogarNovmente:	string "jogar novamente!"
StrOuP:				string "Ou 'p' para"
StrFinalizar:		string "finalizar programa" 
StrApagar: 			string "         "

msgFim1: string "S E U  S C O R E  F O I: "
msgFim2: string "Quer jogar novamente? <s/n>"

strNave1: 	 string "   /\\"
strNave2:	 string " _/--\\_"
strNave3:	 string "|_|..|_|"
strNave4: 	 string " * -- *"

strInimigo1: string "  /..\\"
strInimigo2: string " /:..:\\"   
strInimigo3: string "(:)\\/(:)"
strInimigo4: string "|/    \\|"

score:			var #1	; pontuação do jogador

posNave:		var #1
posAntNave:		var #1

velInimigo:		var #1
posInimigo:		var #1
posAntInimigo:	var #1
flagInimigo:	var #1	; utilizada para verificar se existe um inimigo

posTiro: 		var #1
posAntTiro:		var #1
flagTiro:		var #1

; ------- Funcao principal do jogo -------
main:
	call apagaTelaInteira
	call imprimirTelaInicio
	
	loadn r0, #1016			; posição inicial da nave na tela (1016)
	store posNave, r0		; posicao Atual da Nave
	store posAntNave, r0
	
	loadn r0, #0	
	store flagTiro, r0		; Zera o Flag para marcar que ainda nao Atirou!
	store posTiro, r0		; Zera Posicao Atual do Tiro
	store posAntTiro, r0
	
	loadn r1, #5
	store velInimigo, r1	
	store flagInimigo, r0
	store posInimigo, r0		; Zera Posicao Atual do Inimigo
	store posAntInimigo, r0
	
	
	loadn r2, #0			; Para verificar se (mod(c/10)==0	
	
Loop:
	loadn r1, #1
	mod r1, r0, r1
	cmp r1, r2		; if (mod(c/2)==0
	ceq MoveNave	; Chama Rotina de movimentacao da Nave

	load r1, velInimigo
	mod r1, r0, r1
	cmp r1, r2		; if (mod(c/velInimigo)==0
	ceq MoveAlien	; Chama Rotina de movimentacao do Inimigo

	loadn r1, #1
	mod r1, r0, r1
	cmp r1, r2		; if (mod(c/1)==0
	ceq MoveTiro	; Chama Rotina de movimentacao do Tiro

	call Delay
	inc r0 			;c++
	jmp Loop

;---------------------------------------
MoveNave:
	push r0
	push r1
	call MoveNave_RecalculaPos		; Recalcula Posicao da Nave

	load r0, posNave
	load r1, posAntNave
	cmp r0, r1
	jeq MoveNave_Skip

	call MoveNave_Apaga
	call MoveNave_Desenha

MoveNave_Skip:
	pop r1
	pop r0
	rts
	
MoveNave_Apaga:		; Apaga a Nave
	push r0
	push r1
	push r2
	push r3
	
	load r3, posAntNave
	
; ----- posicao da primeira linha da nave( /\ )
	loadn r0, #0
	add r0, r0, r3
	
	loadn r1, #StrApagar	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #3328			; Seleciona a COR da Mensagem
	call Imprimestr
	
; ------ posicao da segunda linha da nave ( _/--\_ )
	loadn r0, #40
	add r0, r0, r3
	
	loadn r1, #StrApagar	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #3328			; Seleciona a COR da Mensagem
	call Imprimestr
	 
; ----- posicao da terceira linha da nave ( |_|..|_| )
	loadn r0, #80
	add r0, r0, r3
	
	loadn r1, #StrApagar	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #3328			; Seleciona a COR da Mensagem
	call Imprimestr
	 
; ----- posicao da quarta linha da nave ( * -- * )
	loadn r0, #120
	add r0, r0, r3
	
	loadn r1, #StrApagar	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #3328			; Seleciona a COR da Mensagem
	call Imprimestr
	
	pop r3
	pop r2
	pop r1
	pop r0
	rts
;----------------------------------	
	
MoveNave_RecalculaPos:		; Recalcula posicao da Nave em funcao das Teclas pressionadas
	push r0
	push r1
	push r2
	push r3

	load r0, posNave
	
	inchar r1				; Le Teclado para controlar a Nave
	loadn r2, #'a'
	cmp r1, r2
	jeq MoveNave_RecalculaPos_A
	
	loadn r2, #'d'
	cmp r1, r2
	jeq MoveNave_RecalculaPos_D
	
	loadn r2, #' '
	cmp r1, r2
	jeq MoveNave_RecalculaPos_Tiro
	
MoveNave_RecalculaPos_Fim:	; Se nao for nenhuma tecla valida, vai embora
	store posNave, r0
	pop r3
	pop r2
	pop r1
	pop r0
	rts

MoveNave_RecalculaPos_A:	; Move Nave para Esquerda
	loadn r1, #1000
	cmp r1, r0
	jeq MoveNave_RecalculaPos_Fim
	dec r0	; pos = pos -1
	jmp MoveNave_RecalculaPos_Fim
		
MoveNave_RecalculaPos_D:	; Move Nave para Direita	
	loadn r1, #1032
	cmp r1, r0
	jeq MoveNave_RecalculaPos_Fim
	inc r0	; pos = pos + 1
	jmp MoveNave_RecalculaPos_Fim

MoveNave_RecalculaPos_Tiro:	
	call MoveTiro_Apaga
	loadn r1, #1			; Se Atirou:
	store flagTiro, r1		; FlagTiro = 1
	loadn r1, #36
	sub r0, r0, r1
	store posTiro, r0		; posTiro = posNave
	add r0, r0, r1
	jmp MoveNave_RecalculaPos_Fim	
;----------------------------------
MoveNave_Desenha:	; Desenha caractere da Nave
	push r0
	push r1
	push r2
	push r3
	
	load r3, posNave
	
; ----- posicao da primeira linha da nave( /\ )
	loadn r0, #0
	add r0, r0, r3
	
	loadn r1, #strNave1		; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #3328			; Seleciona a COR da Mensagem
	call Imprimestr
	
; ------ posicao da segunda linha da nave ( _/--\_ )
	loadn r0, #40
	add r0, r0, r3
	
	loadn r1, #strNave2	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #3328			; Seleciona a COR da Mensagem
	call Imprimestr
	 
; ----- posicao da terceira linha da nave ( |_|..|_| )
	loadn r0, #80
	add r0, r0, r3
	
	loadn r1, #strNave3	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #3328			; Seleciona a COR da Mensagem
	call Imprimestr
	 
; ----- posicao da quarta linha da nave ( * -- * )
	loadn r0, #120
	add r0, r0, r3
	
	loadn r1, #strNave4		; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #3328			; Seleciona a COR da Mensagem
	call Imprimestr

	store posAntNave, r3

	pop r3
	pop r2
	pop r1
	pop r0
	rts
;-------- Inimigo ---------
MoveAlien:
	push r0
	push r1
	push r2
	
	;load r0, posInimigo
	;load r1, posAntInimigo
	;cmp r0, r1
	;jeq MoveAlien_Skip
	
	load r1, flagInimigo 	; verficando se inimigo já existe
	loadn r2, #1
	cmp r1, r2				; se flagInimigo == 0 então cria um inimigo
	jeq MoveAlien_Skip
	
	; se o inimigo não existe então gera um posição aleatória para ele começar
	call gerarRand
	load r0, rand
	
	loadn r1, #32	; 32 = largura da tela
	mod r0, r0, r1 	; r0 = r0 % 32
	
	loadn r2, #1
	store posInimigo, r0
	store posAntInimigo, r0
	store flagInimigo, r2
	
MoveAlien_Skip:
	call moveInimigo
	pop r2
	pop r1
	pop r0
	rts
	
moveInimigo:
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
	call deletarInimigo
	call desenharInimigo
	
	pop r2
	pop r1
	pop r0
	rts
	
;  /""\   
; /:..:\
;(:)\/(:)
;|/    \|
desenharInimigo:
	push r0
	push r1
	push r2
	push r3
	
	load r3, posInimigo
; ----- posicao da primeira linha do inimigo /""\ 
	loadn r0, #0
	add r0, r0, r3
	loadn r1, #strInimigo1	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #512		; verde
	call Imprimestr
	
; ------ posicao da segunda linha do inimigo /:..:\
	loadn r0, #40
	add r0, r0, r3
	
	loadn r1, #strInimigo2	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #1024			; azul
	call Imprimestr
	 
; ----- posicao da terceira linha do inimigo (:)\/(:)
	loadn r0, #80
	add r0, r0, r3
	
	loadn r1, #strInimigo3	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #1280			; roxo
	call Imprimestr
	 
; ----- posicao da quarta linha do inimigo |/    \|
	loadn r0, #120
	add r0, r0, r3
	
	loadn r1, #strInimigo4	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #3328			; rosa
	call Imprimestr
	
	store posAntInimigo, r3
	
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
deletarInimigo:
	push r0
	push r1
	push r2
	push r3
	
	load r3, posAntInimigo
	
; ----- posicao da primeira linha da nave( /\ )
	loadn r0, #0
	add r0, r0, r3
	
	loadn r1, #StrApagar	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #3328			; Seleciona a COR da Mensagem
	call Imprimestr
	
; ------ posicao da segunda linha da nave ( _/--\_ )
	loadn r0, #40
	add r0, r0, r3
	
	loadn r1, #StrApagar	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #3328			; Seleciona a COR da Mensagem
	call Imprimestr
	 
; ----- posicao da terceira linha da nave ( |_|..|_| )
	loadn r0, #80
	add r0, r0, r3
	
	loadn r1, #StrApagar	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #3328			; Seleciona a COR da Mensagem
	call Imprimestr
	 
; ----- posicao da quarta linha da nave ( * -- * )
	loadn r0, #120
	add r0, r0, r3
	
	loadn r1, #StrApagar	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #3328			; Seleciona a COR da Mensagem
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
	
	call MoveTiro_Apaga
	call MoveTiro_RecalculaPos
	call MoveTiro_Desenha
 
	pop r1
	pop r0
	rts

MoveTiro_Apaga:
	push r0
	push r1
	
	load r0, posTiro
	loadn r1, #' '
	outchar r1, r0
	
	pop r1
	pop r0
	rts
		
MoveTiro_RecalculaPos:
	push r0
	push r1
	push r2
	push r3
	
	load r1, flagTiro	; Se Atirou, movimenta o tiro!
	loadn r2, #1
	cmp r1, r2			; If FlagTiro == 1  Movimenta o Tiro
	jne MoveTiro_RecalculaPos_Fim2	; Se nao vai embora!
	
	load r0, posTiro	; Testa se o Tiro Pegou no Alien
	load r1, posInimigo
	loadn r3, #80
	add r1, r1, r3		; parte da frente do inimigo (parte dele mais inferior na tela)
	cmp r0, r1			; IF posTiro == posInimigo  BOOM!!
	jle MoveTiro_RecalculaPos_Skip
	
	loadn r3, #8
	add r1, r1, r3
	cmp r0, r1
	jle MoveTiro_RecalculaPos_Boom
	
MoveTiro_RecalculaPos_Skip:
	loadn r1, #40		; Testa condicoes de Contorno (se a posicao do tiro for > 40) 	
	cmp r0, r1			; Se tiro chegou na ultima linha
	jgr MoveTiro_RecalculaPos_Fim
	
	loadn r0, #0
	store flagTiro, r0	; Zera FlagTiro
	store posTiro, r0
	jmp MoveTiro_RecalculaPos_Fim2	

MoveTiro_RecalculaPos_Boom:
 	call deletarInimigo
 	call MoveTiro_Apaga
 	
 	; --- atualizando a pontuação ---
 	load r0, score
	inc r0
	store score, r0
	
	loadn r1, #38	; posição da pontuação na tela
	call imprimeNum
	;--------------------------------
	
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
	
	; se a velocidade do inimigo for 2 então não diminui mais (inversamente proporcional)
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

	;imprime Voce Venceu !!!
	;loadn r0, #526
	;loadn r1, #Msn0
;	loadn r2, #0
;	call ImprimeStr
	
	;imprime quer jogar novamente
;	loadn r0, #605
;	loadn r1, #Msn1
;	loadn r2, #0
;	call ImprimeStr

;	MoveTiro_RecalculaPos_Boom_Loop:	
;	call DigLetra
;	loadn r0, #'n'
;	load r1, Letra
;	cmp r0, r1				; tecla == 'n' ?
;	jeq MoveTiro_RecalculaPos_Boom_FimJogo	; tecla e' 'n'
	
;	loadn r0, #'s'
;	cmp r0, r1				; tecla == 's' ?
;	jne MoveTiro_RecalculaPos_Boom_Loop	; tecla nao e' 's'
	
	
	
	; Se quiser jogar novamente...
;	call ApagaTela
	
;	pop r2
;	pop r1
;	pop r0

;	pop r0	; Da um Pop a mais para acertar o ponteiro da pilha, pois nao vai dar o RTS !!
;	jmp main

 ;MoveTiro_RecalculaPos_Boom_FimJogo:
;	call ApagaTela
;	halt

;----------------------------------
MoveTiro_Desenha:
	push r0
	push r1
	
	loadn r1, #'!'	; Tiro
	load r0, posTiro
	outchar r1, r0
	
	pop r1
	pop r0
	rts
; ------- Funcao que gera numero aleatorio-------


rand: var #1
static rand, #53	; seed inicial

; funcao que gera numeros aleatorios de 0 a 255
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
	mul r0, r0, r1   	; SEED * a
	add r0, r0, r2   	; SEED * a + c
	mod r0, r0, r3   	; (SEED * a + c) % p
	
	store rand, r0
	
	pop r3
	pop r2
	pop r1
	pop r0
	rts

;------------- Delay -----------------	
Delay:
	;Utiliza Push e Pop para nao afetar os Registradores do programa principal
	push r0
	push r1
	
	loadn r1, #50  ; a
	
Delay_volta2:				;Quebrou o contador acima em duas partes (dois loops de decremento)
	loadn r0, #3000	; b
	
Delay_volta: 
	dec r0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	jnz Delay_volta
		
	dec r1
	jnz Delay_volta2
	
	pop r1
	pop r0
	
	rts
;-------------------------------------------------------

		
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

;---- Fim do Programa Principal -----
	
	;passa por vetor apagando tela
	
	;shifta vetor
	
	;print vetor na tela
	
;---- Inicio das Subrotinas -----

imprimirFimJogo:
	push r0
	push r1
	push r2
	
	loadn r0, #525			; Posicao na tela onde a mensagem sera' escrita (VAMOS MUDAR PRO MEIO)
	loadn r1, #msgFim1	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #0			; Seleciona a COR da Mensagem
	call Imprimestr
	
	load r0, score
	loadn r1, #551
	call imprimeNum
	
	loadn r0, #605
	loadn r1, #msgFim2
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
	
aumentarScore:
	push r0
	push r1
	
	load r0, score
	inc r0
	store score, r0
	
	loadn r1, #38	; posição da pontuação na tela
	call imprimeNum
	
	pop r1
	pop r0
	rts
	
imprimirTelaInicio:
	; guarda r0...5 na pilha para preservar seu valor
	push r0	
	push r1
	push r2
	push r3
	
	loadn r0, #1160		; Posicao na tela onde a mensagem sera' escrita
	loadn r1, #superficie	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #0		; Seleciona a COR da Mensagem
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

; Rotina de Impresao de Mensagens:    
; r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso
; r1 = endereco onde comeca a mensagem
; r2 = cor da mensagem.   
; Obs: a mensagem sera' impressa ate' encontrar "/0"
Imprimestr:	
	; guarda r0...5 na pilha para preservar seu valor
	push r0
	push r1
	push r2
	push r3
	push r4
	
	loadn r3, #'\0'	; Criterio de parada

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
	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	

; IMPRIMENUMERO
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