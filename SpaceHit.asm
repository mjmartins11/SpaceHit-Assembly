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

; Coracao provisorio: S2 <3
jmp main

linha:	string "=================================="
StrPerdeu:	string "FIM! Voce perdeu!"
StrPressEnter:	string "Aperte ENTER para"
StrJogarNovmente:	string "jogar novamente!"
StrOuP:	string "Ou 'p' para"
StrFinalizar:	string "finalizar programa" 

pos:	var #30
char:	var #30
cont:	var #1	; usado para contar o numero de linhas entre cada letra que cai 
tecla:	var #1 
score:	var #1
estado:	var #1
derrota:	var #1 
velocidade:	var #1
posnave:	var #1

; Funcao que inicializa as variaveis do jogo
inicializa_variaveis_do_jogo:
	push r0
	push r1
	push r2
	
	loadn r0, #pos
	loadn r1, #30
	loadn r2, #40
	call setVetor ; VERIFICAR:::: SET VETOR POS PARA {40,40,40,..,40}
	
	loadn r0, #char
	loadn r1, #30
	loadn r2, #0
	call setVetor ; VERIFICAR:::: SET CHAR POS PARA {0,0,0,..,0}
	
	loadn r0, #0 
	store score, r0
	store derrota, r0
	store cont, r0
	store estado, r0
	
	loadn r0, #5	; posicao da nave
	store posnave, r0
	
	loadn r0, #255
	store tecla, r0
	
	loadn r0, #4000
	store velocidade, r0
	
	pop r2
	pop r1
	pop r0
	rts

rand : var #1
static rand, #53	; seed inicial
; funcao que gera numeros aleatorios de 0 a 255
; (SEED * a + c) % p

gera_rand:
	push r0
	push r1
	push r2
	push r3
	
	load r0, rand	; SEED
	loadn r1, #97	; a
	loadn r2, #133 	; c
	loadn r3, #256 	; p
	mul r0, r0, r1   	; SEED*a
	add r0, r0, r2   	;	SEED*a + c
	mod r0, r0, r3   	; (SEED*a + c) % p
	
	store rand, r0
	
	pop r3
	pop r2
	pop r1
	pop r0
	rts

; Inicio do Programa Principal

main:
	call inicializa_variaveis_do_jogo ; ou inicia, apenas zera tudo
	
	;  r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	call imprimeTelaIni
	call desenha_nave	; mudar para desenha_nave
	
	loadn r3, #1
	loadn r4, #29
	loadn r5, #40
	
	
loop_main:	
	call atualizaTela
	call atualizaScore
	
	load r0, velocidade

	call verificaDerrota	; e salva resposta em variavel global derrota
	load r0, derrota
	cmp r0, r3	; se derrota == 1
	jeq telaDeDerrota
	
	call wait_com_comando
	
	jmp loop_main
	
telaDeDerrota:
	; print DERROTA
	; PARA RECOMEÇAR CLICAR EM ENTER
	; CRIAR FUNC Q RESETA VARIAVEIS (???) nao entendi
	call imprimeTelaDerrota
	
	inchar r0
	loadn r1, #13  	; começa novo jogo se apertar 'Enter'
	loadn r2, #'p'	; finaliza jogo se apertar 'p'
	
	cmp r0, r2
	jeq fimPrograma
	
	cmp r0, r1
	jne telaDeDerrota
	
	call apagaTelaInteira
	jmp main
	
fimPrograma:	
	halt

;---- Fim do Programa Principal -----
	
	;passa por vetor apagando tela
	
	;shifta vetor
	
	;print vetor na tela
	
;---- Inicio das Subrotinas -----

imprimeTelaDerrota:
	push r0
	push r1
	push r2
	
	loadn r0, #534			; Posicao na tela onde a mensagem sera' escrita (VAMOS MUDAR PRO MEIO)
	loadn r1, #StrPerdeu	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #0			; Seleciona a COR da Mensagem
	call Imprimestr
	
	loadn r0, #620				; Posicao na tela onde a mensagem sera' escrita
	loadn r1, #StrPressEnter 	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #0				; Seleciona a COR da Mensagem
	call Imprimestr
	
	loadn r0, #661					; Posicao na tela onde a mensagem sera' escrita
	loadn r1, #StrJogarNovmente 	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #0					; Seleciona a COR da Mensagem
	call Imprimestr
	
	loadn r0, #703		; Posicao na tela onde a mensagem sera' escrita
	loadn r1, #StrOuP 	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #0		; Seleciona a COR da Mensagem
	call Imprimestr
	
	loadn r0, #740			; Posicao na tela onde a mensagem sera' escrita
	loadn r1, #StrFinalizar ; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #0			; Seleciona a COR da Mensagem
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
	
atualizaScore:
	push r0
	push r1
	push r2

	loadn r0, #pos
	loadn r1, #25
	add r0, r0, r1
	
	loadi r1, r0 		; r1 = pos do char na linha da bandeja
	load r2, posnave  ; r2 = pos da pessoa 
	dec r2
	
	; Faz tres comparações pois é o tamanho da bandeja(3 posiçoes)
	cmp r1, r2	; r1 == r2-1 ?
	jeq AtualizaHit
	
	inc r2
	cmp r1, r2 	; r1 == r2
	jeq AtualizaHit
	
	inc r2
	cmp r1, r2	; r1 == r2 +1
	jeq AtualizaHit

	; se chegar aqui significa que é um miss, nao atualiza
	jmp AtualizaMiss 

AtualizaHit:
	; outchar x se der hit??
	loadn r1, #40
	storei r0, r1 	; marca como invalido
	
	; call incScore
	load r0, score
	inc r0
	store score, r0
	loadn r1, #39
	call imprimeNum
	
AtualizaMiss:
	pop r2
	pop r1
	pop r0
	rts

verificaDerrota:
	push r0
	push r1
	push r2

	loadn r0, #pos
	loadn r1, #29
	add r0, r0, r1
	
	loadi r1, r0
	loadn r2, #40
	cmp r1, r2
	jeq fimVerificaDerrota
	
	loadn r1, #1
	store derrota, r1
	
fimVerificaDerrota:
	pop r2
	pop r1
	pop r0
	rts
	
executa_comando:
	push r0
	push r1

	load r0, tecla
	
	loadn r1, #'a'
	cmp r0, r1
	jne nao_executa_comando_1
	
	call move_esquerda
	
nao_executa_comando_1:
	loadn r1, #'d'
	cmp r0, r1
	jne nao_executa_comando_2
	
	call move_direita
	
nao_executa_comando_2:
	pop r1
	pop r0
	rts

wait_com_comando:
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	
	load r5, estado
	
	loadn r0, #0

	loadn r3, #255
	
	loadn r1, #100 	; na placa mudar para 10
	
wait_com_comando1:
	load r2, velocidade
	wait_com_comando2:
		inchar r4

		cmp r4, r3	; inchar == 255
		jne diff255
			
	loadn r5, #0
	jmp wait_com_dps

	diff255:
		cmp r5, r0
		jne wait_com_dps
		
	store tecla, r4	
	loadn r5, #1
	call executa_comando
	
	wait_com_dps:
		dec r2
		cmp r2, r0
		jne wait_com_comando2
			
	dec r1
	cmp r1, r0
	jne wait_com_comando1
	
	; VERIFICAR SE VALORES FAZEM SENTIDO AO PASSAR PRA PLACA
	load r2, velocidade
	loadn r1, #2010	; velocidade maxima vai ser 1990
	cmp r2, r1
	jle fim_wait_com_comando
	
	loadn r1, #10	; step do aumento
	sub r2, r2, r1
	store velocidade, r2
	
fim_wait_com_comando:
	store estado, r5
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts

move_direita:
	push r0
	push r1
	
	load r0, posnave
	
	loadn r1, #34
	; if(r0 == 38) nao move direita
	; else move
	
	cmp r0, r1
	jeq nao_move_direita
	
	inc r0
	call deleta_nave
	store posnave, r0
	call desenha_nave
	
	call atualizaScore	; permitir pegar a fruta enquanto anda pra cima dela
	
nao_move_direita:
	pop r1
	pop r0
	rts

move_esquerda:
	push r0
	push r1
	
	load r0, posnave
	
	loadn r1, #5
	
	; if(r0 == 1) nao move esquerda
	; else move
	
	cmp r0, r1
	jeq nao_move_esquerda
	
	dec r0
	call deleta_nave
	store posnave, r0
	call desenha_nave
	
	call atualizaScore	; permitir pegar a fruta enquanto anda pra cima dela
	
nao_move_esquerda:
	pop r1
	pop r0
	rts

;   /\ 
; _/--\_ 
;|_|..|_|
; * -- *
desenha_nave:
	push r0
	push r1
	push r2
	load r0, posnave
	
; ----- posicao da primeira linha da nave( /\ )
	loadn r1, #1003
	add r1, r1, r0
	
	loadn r2, #'/'
	outchar r2, r1
	inc r1
	nop
	loadn r2, #'\\'
	outchar r2, r1
	
; ------ posicao da segunda linha da nave ( _/--\_ )
	loadn r1, #1041
	add r1, r1, r0
	
	loadn r2, #'_'
	outchar r2, r1 
	loadn r2, #'/'
	inc r1
	outchar r2, r1 
	loadn r2, #'-'
	inc r1
	outchar r2, r1 
	inc r1
	outchar r2, r1
	loadn r2, #'\\'
	inc r1
	outchar r2, r1
	loadn r2, #'_'
	inc r1
	outchar r2, r1
	
; ----- posicao da terceira linha da nave ( |_|..|_| )
	loadn r1, #1080
	add r1, r1, r0
	
	loadn r2, #'|'
	outchar r2, r1
	loadn r2, #'_'
	inc r1
	outchar r2, r1
	loadn r2, #'|'
	inc r1
	outchar r2, r1
	loadn r2, #'.'
	inc r1
	outchar r2, r1
	inc r1
	outchar r2, r1
	loadn r2, #'|'
	inc r1
	outchar r2, r1
	loadn r2, #'_'
	inc r1
	outchar r2, r1
	loadn r2, #'|'
	inc r1
	outchar r2, r1
	 
; ----- posicao da quarta linha da nave ( * -- * )
	loadn r1, #1121
	add r1, r1, r0
	
	loadn r2, #'*'
	outchar r2, r1 
	                                     
	inc r1
	
	loadn r2, #'-'
	inc r1
	nop
	outchar r2, r1
	inc r1
	nop
	outchar r2, r1
	inc r1
	nop
	loadn r2, #'*'
	inc r1
	nop
	outchar r2, r1 

	pop r2
	pop r1
	pop r0
	rts
	
deleta_nave:
	push r0
	push r1
	push r2
	
	load r0, posnave
	
; ------ posoicao da primeira linha da nave
	loadn r1, #1003 
	add r1, r1, r0
	
	loadn r2, #' '
	outchar r2, r1
	inc r1
	nop
	outchar r2, r1
	
; ----- posicao da segunda linha nave
	loadn r1, #1041
	add r1, r1, r0
	
	outchar r2, r1 
	inc r1
	nop
	outchar r2, r1 
	inc r1
	nop
	outchar r2, r1
	inc r1
	nop
	outchar r2, r1 
	inc r1
	nop
	outchar r2, r1
	inc r1
	nop
	outchar r2, r1 
	inc r1
	nop
	outchar r2, r1 
	
; ----- posicao da terceira linha da nave
	loadn r1, #1080
	add r1, r1, r0
	
	outchar r2, r1 
	inc r1
	nop
	outchar r2, r1 
	inc r1
	nop
	outchar r2, r1
	inc r1
	nop
	outchar r2, r1 
	inc r1
	nop
	outchar r2, r1
	inc r1
	nop
	outchar r2, r1 
	inc r1
	nop
	outchar r2, r1
	inc r1
	nop
	outchar r2, r1 
	inc r1
	nop
	outchar r2, r1
	
; ----- posicao da quarta linha da nave
	loadn r1, #1121
	add r1, r1, r0
	
	outchar r2, r1 
	inc r1
	inc r1
	nop
	outchar r2, r1
	inc r1
	nop
	outchar r2, r1 
	inc r1
	inc r1
	nop
	outchar r2, r1  
	
	pop r2
	pop r1
	pop r0
	rts

wait:
	push r0
	push r1
	push r2
	
	loadn r0, #0
	loadn r1, #1000
	
wait1:
	loadn r2, #1000
	
	wait2:
		dec r2
		cmp r2, r0
		jne wait2
	
	dec r1
	cmp r1,r0
	jne wait1
	
	pop r2
	pop r1
	pop r0
	rts

atualizaTela:
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6
	push r7
	
	call apagaVetDaTela
	call deleta_nave
	call moveLetras
	
	loadn r1, #1
	load r6, cont
	add r7, r6, r1
	
	loadn r1, #8	; numero de linhas entre cada letra
	mod r7, r7, r1
	store cont, r7
	
	mov r2, r6
	
	loadn r6, #pos
	loadn r7, #char
	
	loadn r1, #40
	loadn r0, #0
	storei r6, r1
	storei r7, r0
	
	cmp r2,r0	; se cont != 0 nao escreve letra na tela
	jne pula_escrita_atualizaTela
	
	call gera_rand
	load r0, rand
	
	loadn r1, #26
	mod r0, r0, r1	; gera valor entre 0 e 25(cada um representa um caractere do alfabeto)
	
	loadn r1, #'a'
	add r0, r1, r0 	; transforma de [0 à 25] para [a à z]

	call gera_rand
	load r1, rand
	
	loadn r2, #30 ; largura da tela onde as letras surgem
	mod r1, r1, r2 ; r1 = r1 % 20
	loadn r2, #4
	add r1, r1, r2
	
	storei r6, r1
	storei r7, r0
	
pula_escrita_atualizaTela:	
	
	call vetNaTela
	call desenha_nave
	
	pop r7
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts

;--------------------------------------------------------------------------------------------------------

apagaVetDaTela:
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6
	push r7
	
	loadn r6, #pos
	loadn r7, #char
	
	loadn r0, #30
	loadn r1, #0 ; i=0

loop_ApagaVetDaTela:
	loadn r2, #40
	mul r3, r1, r2 	; r3 = linha atual
	loadi r4, r6 	; r4 = pos na linha
	loadn r5, #' ' 	; r5 = char da linha
	
	; if(r4 == 40)
	cmp r4, r2
	jeq naoPrintEspacoApaga
	
	add r4,r4,r3 ; r4 = pos na tela pra imprimir
	outchar r5, r4
	
	loadn r2, #29 ; marcador da linha do '='
	; if(r4 == 29) 
	cmp r1, r2
	jne naoPrintEspacoApaga
	
	loadn r5, #'=';
	outchar r5, r4
	
naoPrintEspacoApaga:
	inc r6
	inc r7
	inc r1
	cmp r1,r0
	jne loop_ApagaVetDaTela
	
	pop r7
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts

;---------------------------------------------------------------------------------------------------------
;Função que pega as informaçoes do vetor e printa na tela
;Nao apaga o que estava antes, so escreve por cima(chamar função pra limpar tela antes)
;
vetNaTela:
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6
	push r7
	
	loadn r6, #pos
	loadn r7, #char
	
	loadn r0, #30
	loadn r1, #0 ; i=0
	
	loadn r2, #40 ; marcador do tam da linha
	
loop_VetNaTela:
	mul r3, r1, r2 ;r3 = linha atual
	loadi r4, r6 ; r4 = pos na linha
	loadi r5, r7 ; r5 = char da linha
	
	;if(r4 == 40) goto naoPrintVetNaTela -- significa que nao foi inicializado ainda
	cmp r4, r2
	jeq naoPrintVetNaTela
	
	add r4, r4, r3 ; r4 = pos na tela pra imprimir
	outchar r5, r4
	
naoPrintVetNaTela:

	inc r6
	inc r7	
	inc r1
	cmp r1,r0
	jne loop_VetNaTela
	
	pop r7
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
;----------------------------------------------------------------------------------------------------------
;r0 - end inicial do vet de tam 30
;
moveLetras:
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6
	push r7
	
	loadn r6, #pos
	loadn r7, #char
	
	loadn r0,#28
	loadn r1,#0 ; i=0
		
	add r6,r6, r0; r6[final]
	add r7,r7, r0; r7[final]
	
	loadn r0,#29
	
loop_MoveLetras:
	loadi r4, r6 ; r4 = pos na linha
	loadi r5, r7 ; r5 = char da linha
	
	inc r6
	inc r7
	
	storei r6, r4
	storei r7, r5
	
	dec r6
	dec r6
	dec r7
	dec r7
	
	inc r1
	cmp r1,r0
	jne loop_MoveLetras
	
	pop r7
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
	
imprimeTelaIni:
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r2 na pilha para preservar seu valor
	push r3	; protege o r2 na pilha para preservar seu valor
	push r4
	push r5
	
	loadn r0, #1163		; Posicao na tela onde a mensagem sera' escrita
	loadn r1, #linha	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #0		; Seleciona a COR da Mensagem
	call Imprimestr
	
	load r0, score
	loadn r1, #39
	call imprimeNum
	
	loadn r5, #'|'
	loadn r0, #40
	loadn r1, #0
	loadn r2, #40
	
loop_ImprimeTelaIni:
	mul r3, r2, r1
	loadn r4, #3
	add r3, r3, r4
	outchar r5, r3
	loadn r4, #153
	add r3, r4, r3
	outchar r5, r3
	
	inc r1
	cmp r1, r0
	jne loop_ImprimeTelaIni
	
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts

Imprimestr:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	
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
	pop r4	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
;--------------------------------------------------------------------------------------------------------
; nao trata tamanho <= 0, da ruim -- NAO PASSAR COM TAM <= 0 SEUS LOUCOS, NEM FAZ SENTIDO
; r0 = end do vetor 
; r1 = tam do vetor
; r2 = valor a ser setado
setVetor:
	loadn r3, #0
	loop_setVetor:
		storei r0, r2
		inc r0
		dec r1
		cmp r1, r3
		jne loop_setVetor 
	rts


; IMPRIMENUMERO
; r0 = num
; r1 = pos na tela inicial(vai escrever da direita para a esquerda)
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
	
;Função para testar rodar os numeros rand
teste_rand:
	loadn r4, #30
	loadn r5, #40
	loadn r6, #4
	
	loadn r2, #4 	; i = 3
	
loop_TestRandOut:

	loadn r3, #0	; j = 0
	loop_TestRandIn:
		load r0, rand
		call gera_rand
		mul r1, r3, r5
		add r1, r1, r2
		call imprimeNum
		inc r3	; j++
		cmp r3, r4
		jne loop_TestRandIn
		
	add r2, r2, r6	; i += 3
	cmp r2, r5
	jle loop_TestRandOut	; if(i<40)

	rts