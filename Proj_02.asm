TITLE DANIELA AKEMI HAYASHI                  RA:22001201
TITLE GIOVANA SALAZAR ALARCON                RA:22001138

.model small
.stack 100h

ALL_PUSH MACRO
;macro que faz todos os PUSH (salva o conteudo do registrador na pilha)
    PUSH CX
    PUSH DX
    PUSH AX
    PUSH BX
    PUSH SI
    PUSH DI
ENDM

ALL_POP MACRO
;macro que faz todos os POP (recupera o conteudo do registrador na pilha)
    POP DI
    POP SI
    POP BX
    POP AX
    POP DX
    POP CX
ENDM

CLEAR MACRO
;macro que faz a limpeza da tela
    MOV AX, 0003h                   ;funcao que limpa tela
    INT 10h                         ;int 10h - bios do sistema
ENDM

ESPACO MACRO
;macro que faz a impressao do espaco
    MOV AH,2                        ;
    MOV DL,' '                      ;imprime o espaco
    INT 21h                         ;
ENDM

PULA_LINHA MACRO
;macro que faz a impressao do pula linha
    MOV AH,2                       
    MOV DL,10                       
    INT 21h                         
ENDM

TAB MACRO
;macro que faz a impressao do TAB
    MOV AH,2
    MOV DL,9
    INT 21h
ENDM

LINHA_HORIZONTAL MACRO
LOCAL VOLTA                         ;label local VOLTA para nao ocorrer erro no .CODE ao utilizar a mesma variavel
;macro que faz a impressao das linhas horizontais da tabela
ALL_PUSH
    MOV CL,3
VOLTA:
    MOV AH,02
    MOV DX,205
    INT 21H
    LOOP VOLTA
ALL_POP
ENDM

LINHA_VERTICAL MACRO
;macro que faz a impressao das linhas verticais da tabela
    MOV AH,02
    MOV DX,186
    INT 21H
ENDM

LINHA_INICIAL MACRO
LOCAL VOLTA
;macro que faz a impressao da primeira linha da tabela sudoku
ALL_PUSH
    MOV CL,8
TAB
    MOV AH,02
    MOV DX,201
    INT 21H
VOLTA:
LINHA_HORIZONTAL
    MOV AH,02
    MOV DX,203
    INT 21H
    LOOP VOLTA

LINHA_HORIZONTAL
    MOV AH,02
    MOV DX,187
    INT 21H
ALL_POP
ENDM

LINHA_MEIO MACRO
LOCAL VOLTA
;macro que faz a impressao das linhas intermediarias da tabela sudoku
ALL_PUSH
    MOV CL,9

PULA_LINHA
TAB
    MOV AH,02
    MOV DX,204
    INT 21H
VOLTA:
LINHA_HORIZONTAL
    MOV AH,02
    MOV DX,206
    INT 21H
    LOOP VOLTA

PULA_LINHA 
ALL_POP
ENDM

LINHA_FINAL MACRO
LOCAL VOLTA
;macro que faz a impressao da ultima linha da tabela sudoku
ALL_PUSH
    MOV CL,8
TAB
    MOV AH,02
    MOV DX,200
    INT 21H
VOLTA:
LINHA_HORIZONTAL
    MOV AH,02
    MOV DX,202
    INT 21H
    LOOP VOLTA

LINHA_HORIZONTAL
    MOV AH,02
    MOV DX,188
    INT 21H
ALL_POP
ENDM

BOTAO_NIVEL MACRO NOME_NIVEL
LOCAL L1,L2,L3,L1_1,L2_1,L1_2,L2_2,L3_1
;macro que faz a impressao dos visuais botoes facil,medio e dificil da tela de niveis
ALL_PUSH
PULA_LINHA
    MOV CL,3
L1: TAB
    LOOP L1

    MOV CL,5
L2: ESPACO
    LOOP L2

    MOV AH,02
    MOV DX,201
    INT 21H

    MOV CL,5
L3: LINHA_HORIZONTAL
    LOOP L3

    MOV AH,02
    MOV DX,187
    INT 21H

PULA_LINHA
    MOV CL,3
L1_1: TAB
    LOOP L1_1

    MOV CL,5
L2_1: ESPACO
    LOOP L2_1

LINHA_VERTICAL
    MOV AH,09                       ;
    LEA DX,NOME_NIVEL               ;impressao da mensagem NOME_NIVEL
    INT 21H                         ;
LINHA_VERTICAL

PULA_LINHA
    MOV CL,3
L1_2: TAB
    LOOP L1_2

    MOV CL,5
L2_2: ESPACO
    LOOP L2_2

    MOV AH,02
    MOV DX,200
    INT 21H

    MOV CL,5
L3_1: LINHA_HORIZONTAL
    LOOP L3_1

    MOV AH,02
    MOV DX,188
    INT 21H

PULA_LINHA
PULA_LINHA
ALL_POP
ENDM

COPY_MAT_PARA_MATRIZ_Z MACRO MAT,LIN,COL
LOCAL REPETE, MOVE
;passa conteudo da matriz solicitada (MAT) para ser armazenada em MATRIZ_Z (salvando, assim, a matriz original sem edicao)
ALL_PUSH

    XOR DX, DX                      ;zera o conteudo do registrador
    XOR AX, AX                      ;
    XOR CX, CX                      ;            

    XOR BX, BX                      ;

    MOV CL,LIN                      ;contador CL recebe o tamanho da linha da matriz
REPETE:
    XOR SI, SI                      ;
    XOR DI, DI                      ;
    MOV CH,COL                      ;contador CH recebe o tamanho da coluna da matriz
MOVE:
    MOV DL, MAT[BX][SI]             ;move o conteudo de MAT para DL
    MOV MATRIZ_Z[BX][DI], DL        ;move o conteudo de DL para MATRIZ_Z
    
    INC SI                          ;incrementa o valor de SI que sera o proximo elemento da linha
    INC DI                          ;
    DEC CH                          ;decrementa CH para saber quando chegou ao final dos elementos da linha
    JNZ MOVE

    ADD BX, COL                     ;pula para a proxima linha quando acabar de imprimir os elementos da primeira linha
    DEC CL                          ;decrementa CL para saber quando chegou ao final dos elementos da matriz inteira
    JNZ REPETE

ALL_POP
ENDM

COPY_MATRIZ_Z_PARA_MAT MACRO MAT,LIN,COL
LOCAL REPETE, MOVE
;passa conteudo da MARIZ_Z de volta para a matriz solicitada (MAT) (restaurando, assim, a matriz original em MAT)
ALL_PUSH

    XOR DX, DX                      ;zera o conteudo do registrador
    XOR AX, AX                      ;
    XOR CX, CX                      ;            

    XOR BX, BX                      ;

    MOV CL,LIN                      ;contador CL recebe o tamanho da linha da matriz
REPETE:
    XOR SI, SI                      ;
    XOR DI, DI                      ;
    MOV CH,COL                      ;contador CH recebe o tamanho da coluna da matriz
MOVE:
    MOV DL, MATRIZ_Z[BX][DI]        ;move o conteudo de MATRIZ_Z para DL
    MOV MAT[BX][SI], DL             ;move o conteudo de DL para MAT
    
    INC SI                          ;incrementa o valor de SI que sera o proximo elemento da linha
    INC DI                          ;
    DEC CH                          ;decrementa CH para saber quando chegou ao final dos elementos da linha
    JNZ MOVE

    ADD BX, COL                     ;pula para a proxima linha quando acabar de imprimir os elementos da primeira linha
    DEC CL                          ;decrementa CL para saber quando chegou ao final dos elementos da matriz inteira
    JNZ REPETE

ALL_POP
ENDM

VALORES_ORIGINAIS MACRO
;reseta todos os valores originais
ALL_PUSH

    MOV SETA_LINHA, 02H    
    MOV SETA_COLUNA, 0AH

    MOV VAR_LINHA, 0000h
    MOV VAR_COLUNA, 0000h

    MOV LINHA_VIDA, 16H
    MOV COLUNA_VIDA, 06H

    MOV NIVEL_ESCOLHIDO, '?'

    MOV ACERTOS_FACIL, 52
    MOV ACERTOS_MEDIO, 53
    MOV ACERTOS_DIFICIL, 53

    MOV JOGAR_DN, '?'

ALL_POP
ENDM


.data

    TEXTO_CAPA DB 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
               DB 10,10,10,10,10,10,10,10,32,32,32,'Click ESPACO para INICIAR O JOGO $'

    TITULO DB '==============================================================================='
           DB 10,9,9,9,9,32,'S U D O K U'
           DB 10,'==============================================================================='
           DB 10,10,32,'CONTROLES: $'

    MOVE DB ' = MOVIMENTAR CURSOR $'
    EXIT DB ' = DESISTIR $'
    EXIT2 DB '  ENTER  $'

    REGRAS DB 10,32,'REGRAS: '
           DB 10,10,32,32,'- Deve-se completar todos os quadrados utilizando numeros de 1 a 9'
           DB 10,32,32,'- Nao podem haver numeros repetidos nas linhas horizontais e verticais'
           DB 10,32,32,'- Nao podem haver numeros repetidos dentro dos quadrados coloridos 3x3'
           DB 10,32,32,'- Existem no total de 3 vidas no jogo'
           DB 10,32,32,'- A cada erro uma carinha ( x _ x ) ira aparecer abaixo da tabela sudoku'
           DB 10,10,'==============================================================================='
           DB 10,10,32,32,' B O A  S O R T E ! -------------------------> Digite ENTER para continuar$'

    NIVEL DB '==============================================================================='
          DB 10,9,9,9,9,32,'N I V E L'
          DB 10,'==============================================================================='
          DB 10,10,32,'ESCOLHA O NIVEL: $'

    ESCOLHA_NIVEL DB 10,32,'- Digite o numero do nivel que deseja jogar (1, 2, 3): $'

    NIVEL1 DB '   1 - FACIL   $'
    NIVEL2 DB '   2 - MEDIO   $'
    NIVEL3 DB '  3 - DIFICIL  $'

    GAMEOVER DB 10,10,10,10,10,10,10,10,10,10,10
             DB 10,10,10,10,10,10,10,10,10,10,10,'Click ENTER para VER RESPOSTA ou ESPACO',10,'para JOGAR NOVAMENTE ou BACKSPACE para ',10,'EXIT $'

    JOG DB 10,10,10,10,10,10,10,10,10,10,10
        DB 10,10,10,10,10,10,10,10,10,10,10,10,'  Click ESPACO para JOGAR NOVAMENTE ou ',10,'  BACKSPACE para EXIT $'

    TEXTO_GAB DB 32,32,'=================================================='
              DB 10,9,9,32,32,32,32,'G A B A R I T O '
              DB 10,32,32,'==================================================$'

;tamanho da matriz
    LINHA EQU 9
    COLUNA EQU 9

;matriz do nivel FACIL

    GABARITO DB 6,4,3,5,9,7,8,2,1
             DB 1,2,8,6,4,3,5,7,9
             DB 7,5,9,2,1,8,4,6,3
             DB 4,6,2,7,5,1,3,9,8
             DB 9,3,1,8,6,4,2,5,7
             DB 5,8,7,3,2,9,1,4,6
             DB 3,7,5,4,8,6,9,1,2
             DB 8,9,4,1,7,2,6,3,5
             DB 2,1,6,9,3,5,7,8,4        

    MATRIZ  DB 0,0,0,0,9,0,8,2,0
            DB 0,2,0,0,0,0,5,0,9
            DB 7,0,9,0,1,0,0,0,0
            DB 0,6,2,7,0,1,0,9,0
            DB 0,0,0,0,6,0,0,0,0
            DB 0,8,0,3,0,9,1,4,0
            DB 0,0,0,0,8,0,9,0,2
            DB 8,0,4,0,0,0,0,3,0
            DB 0,1,6,0,3,0,0,0,0

;matriz do nivel MEDIO

    GABARITO2 DB 1,7,9,6,5,4,8,2,3
              DB 3,8,5,9,2,7,6,4,1
              DB 6,4,2,1,8,3,9,7,5
              DB 9,5,3,2,7,8,1,6,4
              DB 8,6,7,4,9,1,3,5,2
              DB 2,1,4,5,3,6,7,8,9
              DB 7,2,8,3,4,9,5,1,6
              DB 5,9,6,8,1,2,4,3,7
              DB 4,3,1,7,6,5,2,9,8

    MATRIZ2 DB 1,0,0,6,0,0,0,2,0
            DB 0,0,0,0,2,0,0,0,1
            DB 0,4,0,1,0,0,0,0,5
            DB 9,0,3,0,0,8,0,6,0
            DB 0,0,7,4,0,1,3,0,0
            DB 0,1,0,5,0,0,7,0,9
            DB 7,0,0,0,0,9,0,1,0
            DB 5,0,0,0,1,0,0,0,0
            DB 0,3,0,0,0,5,0,0,8

;matriz do nivel DIFICIL

    GABARITO3 DB 4,9,7,1,3,8,6,5,2
              DB 2,6,3,9,5,4,8,7,1
              DB 8,5,1,7,2,6,3,9,4
              DB 3,1,9,4,6,7,5,2,8
              DB 7,2,6,8,1,5,9,4,3
              DB 5,8,4,2,9,3,7,1,6
              DB 1,3,5,6,7,2,4,8,9
              DB 9,7,8,3,4,1,2,6,5
              DB 6,4,2,5,8,9,1,3,7

    MATRIZ3 DB 0,0,7,1,0,0,0,5,0
            DB 0,6,0,0,0,0,0,7,0
            DB 0,0,0,7,0,0,3,0,4
            DB 3,0,0,4,0,0,5,2,0
            DB 0,2,0,8,0,5,0,4,0
            DB 0,8,4,0,0,3,0,0,6
            DB 1,0,5,0,0,2,0,0,0
            DB 0,7,0,0,0,0,0,6,0
            DB 0,4,0,0,0,9,1,0,0

;matriz zerada que sera utilizada como ferramenta de salvas as matrizes originais antes de suas alteracoes
    MATRIZ_Z DB LINHA DUP (COLUNA DUP (0))

    VIDA DB '( x _ x ) $'

;seta a posicao do inicio da matriz 
    SETA_LINHA DB 02H    
    SETA_COLUNA DB 0AH

;variaveis utilizadas para saber a posicao das linhas e colunas da matriz ao mover o cursor de posicao
    VAR_LINHA DW 0000h
    VAR_COLUNA DW 0000h

;posicao para a impressao das vidas do jogo
    LINHA_VIDA DB 16H
    COLUNA_VIDA DB 06H

;variavel utilizada para ver qual nivel o jogador escolheu
    NIVEL_ESCOLHIDO DB '?'

;contagem dos acertos do jogo para ver se o jogador concluio ou nao o nivel selecionado
    ACERTOS_FACIL DB 52
    ACERTOS_MEDIO DB 53
    ACERTOS_DIFICIL DB 53

;variavel utilizada para saber se o jogador que jogar novamente o jogo
    JOGAR_DN DB '?'


.code
MAIN PROC
    MOV AX,@DATA                    ;inicializa DS (segmento de data)
    MOV DS,AX                       ;


JOGA:
VALORES_ORIGINAIS
CLEAR
    CALL CAPA                       ;faz a chamada dos procedimentos
    CALL TELA_INICIAL               ;
    CALL TELA_NIVEL                 ;
    CALL IMPRIME_MATRIZ             ;
    CALL EDIT_MATRIZ                ;
    CALL RESTAURA                   ;

    CMP JOGAR_DN, 1
    JE JOGA

    MOV AH,4CH                      ;exit
    INT 21H                         ;

MAIN ENDP

CAPA PROC
;faz a impressao da capa do jogo 
;ENTRADA:nao ha
;SAIDA: capa impressa

ALL_PUSH 
CLEAR
    
    MOV AH,00h                 ;seta o modo de video para 320x200 - mode 13h
    MOV AL,13h                 ;
    INT 10h                    ;

;imprime sudoku
;S
    MOV AH, 6
    MOV AL, 0
    MOV BH, 02h
    MOV DH, 8                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 8                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 8                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 5                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 

    MOV AH, 6
    MOV AL, 0
    MOV BH, 03H
    MOV DH, 9                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 4                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 9                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 4                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 10                 ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 7                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 10                 ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 5                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 11                 ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 8                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 11                 ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 8                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 02h
    MOV DH, 12                 ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 7                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 12                 ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 4                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 

;U
    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 11                 ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 10                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 8                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 10                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 12                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 12                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 12                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 11                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 11                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 13                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 8                   ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 13                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h
;D
    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 12                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 15                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 8                   ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 15                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 8                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 17                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 8                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 15                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 12                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 17                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 12                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 15                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 11                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 18                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 9                   ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 18                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 

;O
    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 11                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 20                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 9                   ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 20                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h     

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 8                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 22                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 8                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 21                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 11                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 23                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 9                   ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 23                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h     

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 12                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 22                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 12                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 21                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h

;k
    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 12                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 25                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 8                   ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 25                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H 
    MOV DH, 8                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 28                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 8                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 28                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 10                 ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 26                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 10                 ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 26                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 9                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 27                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 9                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 27                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 11                 ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 27                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 11                 ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 27                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 12                 ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 28                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 12                 ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 28                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h
;U
    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 11                 ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 30                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 8                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 30                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 12                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 32                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 12                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 31                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 11                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 33                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 8                   ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 33                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h

    MOV AH,09                       ;
    LEA DX,TEXTO_CAPA               ;impressao da mensagem TEXTO_CAPA
    INT 21H                         ;

VOLTA1:
    MOV AH,00h                      ;leitura de um characher (sem echo)
    INT 16h                         ;

    CMP AL,' '                      ;compara se o character digitado e um ESPACO
    JE EXIT_2                       ;

    JMP VOLTA1                      ;faz a repeticao ate a pessoa clicar no ESPACO

EXIT_2:
ALL_POP
    RET

CAPA ENDP 

TELA_INICIAL PROC
;faz a impressao das teclas utilizadas no jogo e as regras
;ENTRADA:nao ha
;SAIDA: controles impressos e regras

ALL_PUSH

    MOV AH,00h                      ;seta o modo de video para texto novamente - mode 03h
    MOV AL,03h                      ;
    INT 10h                         ;

    MOV AH,05                       ;comando para criacao de uma pagina nova
    MOV AL,0                        ;numero da pagina criada
    INT 10H                         ;

PULA_LINHA
    MOV AH,09                       ;
    LEA DX,TITULO                   ;impressao do titulo
    INT 21H                         ;

;impressao das imagens dos controles que serao utilizados no jogo

;impressao do controle seta
PULA_LINHA
PULA_LINHA
TAB
    MOV AH,02
    MOV DX,201
    INT 21H
LINHA_HORIZONTAL
    MOV AH,02
    MOV DX,187
    INT 21H
PULA_LINHA
TAB
LINHA_VERTICAL
ESPACO
    MOV AH,02
    MOV DL,'W'
    INT 21H
ESPACO
LINHA_VERTICAL

;impressao do controle exit
TAB
TAB
TAB
TAB
TAB

    MOV AH,02
    MOV DX,201
    INT 21H

LINHA_HORIZONTAL
LINHA_HORIZONTAL
LINHA_HORIZONTAL

    MOV AH,02
    MOV DX,187
    INT 21H

;impressao do controle seta
PULA_LINHA
ESPACO
ESPACO
ESPACO
ESPACO
    MOV AH,02
    MOV DX,201
    INT 21H
LINHA_HORIZONTAL
    MOV AH,02
    MOV DX,206
    INT 21H
LINHA_HORIZONTAL
    MOV AH,02
    MOV DX,206
    INT 21H
LINHA_HORIZONTAL
    MOV AH,02
    MOV DX,187
    INT 21H

    MOV AH,09                       ;
    LEA DX,MOVE                     ;impressao da mensagem MOVE
    INT 21H                         ;

;impressao do controle exit
TAB
TAB
LINHA_VERTICAL
    MOV AH,09                       ;
    LEA DX,EXIT2                    ;impressao da mensagem EXIT2
    INT 21H                         ;
LINHA_VERTICAL
ESPACO
    MOV AH,09                       ;
    LEA DX,EXIT                     ;impressao da mensagem EXIT
    INT 21H                         ;

;impressao do controle seta
PULA_LINHA
ESPACO
ESPACO
ESPACO
ESPACO
LINHA_VERTICAL
ESPACO
    MOV AH,02
    MOV DL,'A'
    INT 21H
ESPACO
LINHA_VERTICAL
ESPACO
    MOV AH,02
    MOV DL,'S'
    INT 21H
ESPACO
LINHA_VERTICAL
ESPACO
    MOV AH,02
    MOV DL,'D'
    INT 21H
ESPACO
LINHA_VERTICAL

;impressao do controle exit
TAB
TAB
TAB
TAB
    MOV AH,02
    MOV DX,200
    INT 21H

LINHA_HORIZONTAL
LINHA_HORIZONTAL
LINHA_HORIZONTAL

    MOV AH,02
    MOV DX,188
    INT 21H


;impressao do controle seta
PULA_LINHA
ESPACO
ESPACO
ESPACO
ESPACO
    MOV AH,02
    MOV DX,200
    INT 21H
LINHA_HORIZONTAL
    MOV AH,02
    MOV DX,202
    INT 21H
LINHA_HORIZONTAL
    MOV AH,02
    MOV DX,202
    INT 21H
LINHA_HORIZONTAL
    MOV AH,02
    MOV DX,188
    INT 21H
ESPACO
PULA_LINHA

    MOV AH,09                       ;
    LEA DX,REGRAS                   ;impressao daS REGRAS
    INT 21H                         ;

;comando para ir para a proxima tela do jogo
NAO_CONTNUA:

    MOV AH,00H                      ;leitura do character digitado (sem echo)
    INT 16h                         ;

    CMP AL,0DH                      ;compara se AL e igual a ENTER
    JNZ NAO_CONTNUA

ALL_POP
    RET

TELA_INICIAL ENDP

TELA_NIVEL PROC
;faz a impressao das teclas utilizadas no jogo 
;ENTRADA:nao ha
;SAIDA: controles impressos

ALL_PUSH

    MOV AH,05                       ;comando para criacao de uma pagina nova
    MOV AL,1                        ;numero da pagina criada
    INT 10H                         ;

PULA_LINHA
    MOV AH,09                       ;
    LEA DX,NIVEL                    ;impressao do NIVEL
    INT 21H                         ;

;impressao da opcao de jogo facil
BOTAO_NIVEL NIVEL1

;impressao da opcao de jogo medio
BOTAO_NIVEL NIVEL2

;impressao da opcao de jogo dificil
BOTAO_NIVEL NIVEL3

PULA_LINHA
    MOV AH,09                       ;
    LEA DX,ESCOLHA_NIVEL            ;impressao do ESCOLHA_NIVEL
    INT 21H                         ;

;comando para ir para a proxima tela do jogo
DIGITE_NOVAMENTE:

    MOV AH,00H                      ;leitura do character digitado (sem echo)
    INT 16h                         ;

    CMP AL,'1'                      ;compara se AL e igual a 1 (nivel facil)
    JE N1

    CMP AL,'2'                      ;compara se AL e igual a 2 (nivel medio)
    JE N2

    CMP AL,'3'                      ;compara se AL e igual a 3 (nivel dificil)
    JE N3

    JMP DIGITE_NOVAMENTE

N1:
    MOV NIVEL_ESCOLHIDO, AL         ;salva o valor de AL no NIVEL_ESCOLHIDO que depois sera utilizado para comparacao
    CALL COPY
    JMP FIM_S2
N2:
    MOV NIVEL_ESCOLHIDO, AL         ;
    CALL COPY
    JMP FIM_S2
N3:
    MOV NIVEL_ESCOLHIDO, AL         ;
    CALL COPY

FIM_S2:

ALL_POP
    RET

TELA_NIVEL ENDP

COPY PROC
;faz uma copia da matriz original para que possa ser recuperada posterirmente
;ENTRADA:nao ha
;SAIDA: matriz copiada

ALL_PUSH

    CMP NIVEL_ESCOLHIDO, '1'         ;compara se o NIVEL_ESCOLHIDO e igual a 1
    JE C_N1

    CMP NIVEL_ESCOLHIDO, '2'         ;
    JE C_N2

    JMP C_N3

C_N1:
    COPY_MAT_PARA_MATRIZ_Z MATRIZ,LINHA,COLUNA       ;faz uma copia da matriz original
    JMP FIM_3

C_N2:
    COPY_MAT_PARA_MATRIZ_Z MATRIZ2,LINHA,COLUNA      ;
    JMP FIM_3

C_N3:
    COPY_MAT_PARA_MATRIZ_Z MATRIZ3,LINHA,COLUNA      ;

FIM_3:

ALL_POP
    RET

COPY ENDP

RESTAURA PROC
;faz a restauracao da matriz original
;ENTRADA:nao ha
;SAIDA: matriz original

ALL_PUSH

    CMP NIVEL_ESCOLHIDO, '1'         ;compara se o NIVEL_ESCOLHIDO e igual a 1
    JE R_N1

    CMP NIVEL_ESCOLHIDO, '2'         ;
    JE R_N2

    JMP R_N3

R_N1:
    COPY_MATRIZ_Z_PARA_MAT MATRIZ,LINHA,COLUNA       ;faz uma copia da matriz original
    JMP FIM_4

R_N2:
    COPY_MATRIZ_Z_PARA_MAT MATRIZ2,LINHA,COLUNA      ;
    JMP FIM_4

R_N3:
    COPY_MATRIZ_Z_PARA_MAT MATRIZ3,LINHA,COLUNA      ;

FIM_4:

ALL_POP
    RET

RESTAURA ENDP

IMPRIME_MATRIZ PROC
;faz a impressao da matriz
;ENTRADA: nao ha
;SAIDA: matriz impressa

ALL_PUSH

    MOV AH,05                       ;comando para criacao de uma pagina nova
    MOV AL,2                        ;numero da pagina criada
    INT 10H                         ;

;impressao dos retangulos do fundo da tela
    MOV AH,06                       ;funcao para printar um retangulo na tela
    MOV AL,00                       ;full screen
    MOV BH,01001B                   ;cor
    MOV CH,01                       ;coordenadas do topo
    MOV CL,08                       ;
    MOV DH,07                       ;coordenadas da base
    MOV DL,20                       ;
    INT 10H

    MOV AH,06                       ;funcao para printar um retangulo na tela
    MOV AL,00                       ;full screen
    MOV BH,01100B                   ;cor
    MOV CH,07                       ;coordenadas do topo
    MOV CL,08                       ;
    MOV DH,13                       ;coordenadas da base
    MOV DL,20                       ;
    INT 10H

    MOV AH,06                       ;funcao para printar um retangulo na tela
    MOV AL,00                       ;full screen
    MOV BH,01101B                   ;cor
    MOV CH,13                       ;coordenadas do topo
    MOV CL,08                       ;
    MOV DH,19                       ;coordenadas da base
    MOV DL,20                       ;
    INT 10H

    MOV AH,06                       ;funcao para printar um retangulo na tela
    MOV AL,00                       ;full screen
    MOV BH,01110B                   ;cor
    MOV CH,01                       ;coordenadas do topo
    MOV CL,21                       ;
    MOV DH,07                       ;coordenadas da base
    MOV DL,32                       ;
    INT 10H

    MOV AH,06                       ;funcao para printar um retangulo na tela
    MOV AL,00                       ;full screen
    MOV BH,01111B                   ;cor
    MOV CH,07                       ;coordenadas do topo
    MOV CL,21                       ;
    MOV DH,13                       ;coordenadas da base
    MOV DL,32                       ;
    INT 10H

    MOV AH,06                       ;funcao para printar um retangulo na tela
    MOV AL,00                       ;full screen
    MOV BH,01011B                   ;cor
    MOV CH,13                       ;coordenadas do topo
    MOV CL,21                       ;
    MOV DH,19                       ;coordenadas da base
    MOV DL,32                       ;
    INT 10H

    MOV AH,06                       ;funcao para printar um retangulo na tela
    MOV AL,00                       ;full screen
    MOV BH,00011B                   ;cor
    MOV CH,01                       ;coordenadas do topo
    MOV CL,33                       ;
    MOV DH,07                       ;coordenadas da base
    MOV DL,44                       ;
    INT 10H

    MOV AH,06                       ;funcao para printar um retangulo na tela
    MOV AL,00                       ;full screen
    MOV BH,01010B                   ;cor
    MOV CH,07                       ;coordenadas do topo
    MOV CL,33                       ;
    MOV DH,13                       ;coordenadas da base
    MOV DL,44                       ;
    INT 10H

    MOV AH,06                       ;funcao para printar um retangulo na tela
    MOV AL,00                       ;full screen
    MOV BH,00111B                   ;cor
    MOV CH,13                       ;coordenadas do topo
    MOV CL,33                       ;
    MOV DH,19                       ;coordenadas da base
    MOV DL,44                       ;
    INT 10H


;impressao da matriz do sudoku
PULA_LINHA

    XOR BX,BX                       ;zera o conteudo do registrador BX
    XOR AX,AX                       ;
    XOR CX,CX                       ;
    XOR DX,DX                       ;

LINHA_INICIAL

PULA_LINHA
    MOV AH,02                       ;faz a impressao do character
    MOV CL,LINHA                    ;contador CL recebe o tamanho da linha da matriz
    JMP INICIO
REPETE:
LINHA_MEIO
INICIO:
TAB
LINHA_VERTICAL
    XOR SI,SI                       ;zera o conteudo do registrador SI
    MOV CH,COLUNA                   ;contador CH recebe o tamanho da coluna da matriz

REPETE2:
ESPACO
    CMP NIVEL_ESCOLHIDO,'2'         ;compara se o nivel escolhido e o MEDIO
    JE MEDIO

    CMP NIVEL_ESCOLHIDO,'3'         ;compara se o nivel escolhido e o DIFICIL
    JE DIFICIL

    MOV DL,MATRIZ[BX][SI]           ;DL recebe o valor de MATRIZ (na posicao BX = LINHA e SI = COLUNA)
    JMP FACIL
DIFICIL:
    MOV DL,MATRIZ3[BX][SI]          ;DL recebe o valor de MATRIZ (na posicao BX = LINHA e SI = COLUNA)
    JMP FACIL
MEDIO:
    MOV DL,MATRIZ2[BX][SI]          ;DL recebe o valor de MATRIZ (na posicao BX = LINHA e SI = COLUNA)
FACIL:
    OR DL,30H                       ;transforma o numero (decimal) de volta a um character (hexadecimal)
    INT 21H                         ;

    INC SI                          ;incrementa em 1 o conteudo de SI (COLUNA)
    DEC CH                          ;decrementa em 1 o valor de CH (nesse caso seria o contador com o valor da COLUNA)
ESPACO
LINHA_VERTICAL
    JNZ REPETE2                     ;faz o salto enquanto CH (contador COLUNA) nao for igual a zero

    ADD BX,COLUNA                   ;faz a adicao de BX (LINHA) com a quantidade da COLUNA
    DEC CL                          ;decrementa em 1 o valor de CL (nesse caso seria o contador com o valor da LINHA)
    JZ FINALIZADO                   ;faz o salto enquanto CL (contador LINHA) nao for igual a zero
    JMP REPETE

FINALIZADO:

PULA_LINHA
LINHA_FINAL
ALL_POP
    RET

IMPRIME_MATRIZ ENDP

EDIT_MATRIZ PROC
;faz a impressao da matriz
;ENTRADA: nao ha
;SAIDA: matriz alterada

ALL_PUSH

    MOV DI,3                        ;move 3 para DI que sera utilizado como contador de vida

RETORNO:
    MOV AH,02h                      ;funcao que seta cursor 
    MOV BH,02h                      ;pagina em que o cursor sera setado 
    MOV DH,SETA_LINHA               ;fileira em que sera setado
    MOV DL,SETA_COLUNA              ;coluna em que sera setado
    INT 10h                         ;ira ser setado na parte da insercao da operacao
 
    MOV AH,00h                      ;leitura de um characher (sem echo)
    INT 16h                         ;

    CMP AL,'d'                      ;compara se AL e igual a d
    JE DIREITA

    CMP AL,'a'                      ;compara se AL e igual a a
    JE ESQUERDA

    CMP AL,'s'                      ;compara se AL e igual a s
    JE BAIXO

    CMP AL,'w'                      ;compara se AL e igual a w
    JE CIMA

    CMP AL,0DH                      ;compara se AL e igual a enter
    JE NUMERO

    CMP AL,30H                      ;compara se AL e menor ou igual zero
    JBE RETORNO                     ;

    CMP AL,39H                      ;compara se AL e maior que nove
    JA RETORNO                      ;

    JMP NUMERO
    
DIREITA:
    CMP SETA_COLUNA,2AH             ;compara se o cursor chegou ao final da coluna da matriz
    JAE RETORNO
    ADD SETA_COLUNA,04H             ;seta o cursor uma casa para a direita
    ADD VAR_COLUNA,0001H            ;seta o valor da posicao coluna da matriz na posicao locomovida
    JMP RETORNO

ESQUERDA:
    CMP SETA_COLUNA,0AH             ;compara se o cursor chegou ao inicio da coluna da matriz
    JBE RETORNO
    SUB SETA_COLUNA,04H             ;seta o cursor uma casa para a esquerda
    SUB VAR_COLUNA,0001H            ;seta o valor da posicao coluna da matriz na posicao locomovida
    JMP RETORNO
    
BAIXO:
    CMP SETA_LINHA,12H              ;compara se o cursor chegou ao final da linha da matriz
    JAE RETORNO
    ADD SETA_LINHA,02H              ;seta o cursor uma casa para baixo
    ADD VAR_LINHA,0009H             ;seta o valor da posicao linha da matriz na posicao locomovida
    JMP RETORNO

CIMA:
    CMP SETA_LINHA,02H              ;compara se o cursor chegou ao inicio da linha da matriz
    JBE RETORNO
    SUB SETA_LINHA,02H              ;seta o cursor uma casa para cima
    SUB VAR_LINHA,0009H             ;seta o valor da posicao linha da matriz na posicao locomovida
    JMP RETORNO

NUMERO:
    CMP AL,0DH                      ;compara se AL e igual a enter
    JE FIM

    MOV CL,AL                       ;move o conteudo de AL para CL
    AND CL,0FH                      ;transforma o character (hexadecimal) em numero (decimal)

    MOV BX,VAR_LINHA                ;move o conteudo de VAR_LINHA para o registrador BX
    MOV SI,VAR_COLUNA               ;move o conteudo de VAR_COLUNA para o registrador SI

    CMP NIVEL_ESCOLHIDO,'2'         ;compara se o nivel escolhido e o 2 (medio)
    JE MEDIO2

    CMP NIVEL_ESCOLHIDO,'3'         ;compara se o nivel escolhido e o 3 (dificil)
    JE DIFICIL2

    JMP FACIL2                      ;caso nao seja nenhum dos dois anteriores, faz um jump para 1 (facil)

DIFICIL2:
    CMP MATRIZ3 [BX][SI], 0         ;compara se a posicao BX x SI e igual a 0
    JNZ SALTO3

    CMP CL, GABARITO3 [BX][SI]      ;compara se o numero digitado esta correto
    JNZ SALTO2

    MOV MATRIZ3 [BX][SI], CL        ;substitui o valor da posicao BX x SI da matriz pelo valor contido em CL
    DEC ACERTOS_DIFICIL             ;faz a contagens dos acertos para posteriormente se imprimir a mensagem de parabens caso a pessoa acerte tudo
    JNZ SALTO3
    CALL PARABENS                   ;chama o procedimento PARABENS 
    JMP FIM3

SALTO3:
    XOR DL,DL
    MOV DL, MATRIZ3 [BX][SI]        ;imprime o valores editados na matriz
    JMP IMPRESSAO

MEDIO2:
    CMP MATRIZ2 [BX][SI], 0         ;compara se a posicao BX x SI e igual a 0
    JNZ SALTO4

    CMP CL, GABARITO2 [BX][SI]      ;compara se o numero digitado esta correto
    JNZ SALTO2

    MOV MATRIZ2 [BX][SI], CL        ;substitui o valor da posicao BX x SI da matriz pelo valor contido em CL
    DEC ACERTOS_MEDIO               ;faz a contagens dos acertos para posteriormente se imprimir a mensagem de parabens caso a pessoa acerte tudo
    JNZ SALTO4
    CALL PARABENS                   ;chama o procedimento PARABENS 
    JMP FIM3

SALTO4:
    XOR DL,DL
    MOV DL, MATRIZ2 [BX][SI]        ;imprime o valores editados na matriz
    JMP IMPRESSAO

FIM:
    CMP AL,0DH                      ;compara se AL e igual a enter
    JE FIM2

FACIL2:
    CMP MATRIZ [BX][SI], 0          ;compara se a posicao BX x SI e igual a 0
    JNZ SALTO

    CMP CL, GABARITO [BX][SI]       ;compara se o numero digitado esta correto
    JNZ SALTO2

    MOV MATRIZ [BX][SI], CL         ;substitui o valor da posicao BX x SI da matriz pelo valor contido em CL
    DEC ACERTOS_FACIL               ;faz a contagens dos acertos para posteriormente se imprimir a mensagem de parabens caso a pessoa acerte tudo
    JNZ SALTO
    CALL PARABENS                   ;chama o procedimento PARABENS
    JMP FIM3 

SALTO:
    XOR DL,DL
    MOV DL, MATRIZ [BX][SI]         ;imprime o valores editados na matriz

IMPRESSAO:
    OR DL,30H                       ;
    MOV AH,02                       ;
    INT 21H                         ;

    JMP RETORNO

SALTO2:
    MOV AH,02h                      ;funcao que seta cursor 
    MOV BH,02h                      ;pagina em que o cursor sera setado 
    MOV DH,LINHA_VIDA               ;fileira em que sera setado
    MOV DL,COLUNA_VIDA              ;coluna em que sera setado
    INT 10h                         ;ira ser setado na parte da insercao da operacao

    MOV AH,09                       ;
    LEA DX,VIDA                     ;impressao da vida do jogo
    INT 21H                         ;

    ADD COLUNA_VIDA,10H
    DEC DI                          ;decrementa o numero de vidas do jogador
    CMP DI,0                        ;comparacao para ver se o jogador ja acabou com todas as vidas
    JZ FIM2

    CMP NIVEL_ESCOLHIDO,'2'         ;compara se o nivel que se esta jogando e o 2 (medio)
    JE SALTO4

    CMP NIVEL_ESCOLHIDO,'1'         ;compara se o nivel que se esta jogando e o 1 (facil)
    JE SALTO

    JMP SALTO3                      ;caso nao seja nenhum dos dois anteriores, faz um jump para 3 (dificil)

FIM2:
    CALL GAME_OVER                  ;chama o procedimento GAME_OVER 
FIM3:
ALL_POP
    RET

EDIT_MATRIZ ENDP

GAME_OVER PROC
;faz a impressao da mensagem game over
;ENTRADA: nao ha
;SAIDA: mensagem de fim de jogo

ALL_PUSH
CLEAR

    MOV AH,00h                 ;seta o modo de video para 320x200 - mode 13h
    MOV AL,13h                 ;
    INT 10h                    ;
    
    MOV AH,6
    MOV AL,0
    MOV BH,00h
    MOV CH,0
    MOV CL,0
    MOV DH,50
    MOV DL,50
    INT 10h

;MENSAGEM DE GAME OVER
;G
    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 8                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 4                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 3                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 4                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h      
    
    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 2                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 9                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 2                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 5                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 
    
    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 9                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 9                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 9                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 5                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 9                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 9                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 5                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 9                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 5                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 9                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 5                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 7                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

;A
    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 9                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 11                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 3                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 11                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h   

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 2                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 13                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 2                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 12                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10H

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 9                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 14                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 3                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 14                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 5                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 14                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 5                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 12                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

;M
    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 9                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 16                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 2                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 16                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h     

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 3                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 17                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 3                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 17                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 4                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 18                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 4                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 18                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 5                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 19                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 5                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 19                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 3                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 21                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 3                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 21                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 4                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 20                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 4                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 20                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  


    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 9                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 22                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 2                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 22                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h    

;E 
    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 9                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 24                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 2                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 24                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h      
    
    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 2                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 27                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 2                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 24                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 
    
    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 5                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 27                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 5                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 24                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h    

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 9                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 27                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 9                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 24                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 

;O
    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 19                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 11                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 14                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 11                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h     

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 13                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 16                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 13                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 12                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 20                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 16                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 20                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 12                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 19                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 17                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 14                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 17                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

;V
    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 18                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 19                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 13                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 19                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 19                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 20                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 19                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 20                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 20                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 21                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 20                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 21                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 19                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 22                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 19                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 22                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 18                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 23                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 13                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 23                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 
;E
    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 20                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 25                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 13                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 25                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h      
    
    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 13                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 28                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 13                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 25                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 
    
    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 16                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 28                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 16                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 25                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h    

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 20                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 28                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 20                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 25                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 
;R
    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 20                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 30                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 13                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 30                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h      

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 13                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 34                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 13                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 30                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  
    
    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 17                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 34                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 17                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 30                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 18                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 32                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 18                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 32                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 
    
    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 19                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 33                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 19                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 33                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h    

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 20                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 34                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 20                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 34                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 04H
    MOV DH, 16                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 34                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 13                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 34                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 

    MOV AH,09                       ;
    LEA DX,GAMEOVER                 ;impressao da mensagem GAMEOVER
    INT 21H                         ;

VOLTA:
    MOV AH,00h                      ;leitura de um characher (sem echo)
    INT 16h                         ;

    CMP AL,0DH                      ;compara se o character digitado e igual a ENTER
    JE GAB                          ;

    CMP AL,' '                      ;compara se o character digitado e igual a ESPACO
    JE JOGAR_DENOVO2                ;

    CMP AL,08                       ;compara se o character digitado e igual a BACKSPACE
    JE EXIT_1                       ;

    JMP VOLTA                       ;faz a repeticao ate que um dos charateres citados acima sejam digitados

GAB:
    CALL IMPRIME_GABARITO           ;chama a funcao para a impressao do gabarito
    JMP EXIT_1

JOGAR_DENOVO2:
    MOV JOGAR_DN, 1

EXIT_1:
ALL_POP
    RET

GAME_OVER ENDP

IMPRIME_GABARITO PROC
;faz a impressao da matriz gabarito
;ENTRADA: nao ha
;SAIDA: matriz impressa

ALL_PUSH

    MOV AH,00h                      ;seta o modo de video para texto novamente - mode 03h
    MOV AL,03h                      ;
    INT 10h                         ;

    MOV AH,05                       ;comando para criacao de uma pagina nova
    MOV AL,3                        ;numero da pagina criada
    INT 10H                         ;

;impressao dos retangulos do fundo da tela
    MOV AH,06                       ;funcao para printar um retangulo na tela
    MOV AL,00                       ;full screen
    MOV BH,01001B                   ;cor
    MOV CH,01                       ;coordenadas do topo
    MOV CL,08                       ;
    MOV DH,07                       ;coordenadas da base
    MOV DL,20                       ;
    INT 10H

    MOV AH,06                       ;funcao para printar um retangulo na tela
    MOV AL,00                       ;full screen
    MOV BH,01100B                   ;cor
    MOV CH,07                       ;coordenadas do topo
    MOV CL,08                       ;
    MOV DH,13                       ;coordenadas da base
    MOV DL,20                       ;
    INT 10H

    MOV AH,06                       ;funcao para printar um retangulo na tela
    MOV AL,00                       ;full screen
    MOV BH,01101B                   ;cor
    MOV CH,13                       ;coordenadas do topo
    MOV CL,08                       ;
    MOV DH,19                       ;coordenadas da base
    MOV DL,20                       ;
    INT 10H

    MOV AH,06                       ;funcao para printar um retangulo na tela
    MOV AL,00                       ;full screen
    MOV BH,01110B                   ;cor
    MOV CH,01                       ;coordenadas do topo
    MOV CL,21                       ;
    MOV DH,07                       ;coordenadas da base
    MOV DL,32                       ;
    INT 10H

    MOV AH,06                       ;funcao para printar um retangulo na tela
    MOV AL,00                       ;full screen
    MOV BH,01111B                   ;cor
    MOV CH,07                       ;coordenadas do topo
    MOV CL,21                       ;
    MOV DH,13                       ;coordenadas da base
    MOV DL,32                       ;
    INT 10H

    MOV AH,06                       ;funcao para printar um retangulo na tela
    MOV AL,00                       ;full screen
    MOV BH,01011B                   ;cor
    MOV CH,13                       ;coordenadas do topo
    MOV CL,21                       ;
    MOV DH,19                       ;coordenadas da base
    MOV DL,32                       ;
    INT 10H

    MOV AH,06                       ;funcao para printar um retangulo na tela
    MOV AL,00                       ;full screen
    MOV BH,00011B                   ;cor
    MOV CH,01                       ;coordenadas do topo
    MOV CL,33                       ;
    MOV DH,07                       ;coordenadas da base
    MOV DL,44                       ;
    INT 10H

    MOV AH,06                       ;funcao para printar um retangulo na tela
    MOV AL,00                       ;full screen
    MOV BH,01010B                   ;cor
    MOV CH,07                       ;coordenadas do topo
    MOV CL,33                       ;
    MOV DH,13                       ;coordenadas da base
    MOV DL,44                       ;
    INT 10H

    MOV AH,06                       ;funcao para printar um retangulo na tela
    MOV AL,00                       ;full screen
    MOV BH,00111B                   ;cor
    MOV CH,13                       ;coordenadas do topo
    MOV CL,33                       ;
    MOV DH,19                       ;coordenadas da base
    MOV DL,44                       ;
    INT 10H


;impressao da matriz do sudoku
PULA_LINHA

    XOR BX,BX                       ;zera o conteudo do registrador BX
    XOR AX,AX                       ;
    XOR CX,CX                       ;
    XOR DX,DX                       ;

LINHA_INICIAL

PULA_LINHA
    MOV AH,02                       ;faz a impressao do character
    MOV CL,LINHA                    ;contador CL recebe o tamanho da linha da matriz
    JMP INICIO0
REPETE0:
LINHA_MEIO
INICIO0:
TAB
LINHA_VERTICAL
    XOR SI,SI                       ;zera o conteudo do registrador SI
    MOV CH,COLUNA                   ;contador CH recebe o tamanho da coluna da matriz

REPETE20:
ESPACO
    CMP NIVEL_ESCOLHIDO,'2'         ;compara se o nivel escolhido e o MEDIO
    JE MEDIO0

    CMP NIVEL_ESCOLHIDO,'3'         ;compara se o nivel escolhido e o DIFICIL
    JE DIFICIL0

    MOV DL,GABARITO[BX][SI]         ;DL recebe o valor de MATRIZ (na posicao BX = LINHA e SI = COLUNA)
    JMP FACIL0
DIFICIL0:
    MOV DL,GABARITO3[BX][SI]        ;DL recebe o valor de MATRIZ (na posicao BX = LINHA e SI = COLUNA)
    JMP FACIL0
MEDIO0:
    MOV DL,GABARITO2[BX][SI]        ;DL recebe o valor de MATRIZ (na posicao BX = LINHA e SI = COLUNA)
FACIL0:
    OR DL,30H                       ;transforma o numero (decimal) de volta a um character (hexadecimal)
    INT 21H                         ;

    INC SI                          ;incrementa em 1 o conteudo de SI (COLUNA)
    DEC CH                          ;decrementa em 1 o valor de CH (nesse caso seria o contador com o valor da COLUNA)
ESPACO
LINHA_VERTICAL
    JNZ REPETE20                    ;faz o salto enquanto CH (contador COLUNA) nao for igual a zero

    ADD BX,COLUNA                   ;faz a adicao de BX (LINHA) com a quantidade da COLUNA
    DEC CL                          ;decrementa em 1 o valor de CL (nesse caso seria o contador com o valor da LINHA)
    JZ FINALIZADO0                  ;faz o salto enquanto CL (contador LINHA) nao for igual a zero
    JMP REPETE0

FINALIZADO0:

PULA_LINHA
LINHA_FINAL
PULA_LINHA
    MOV AH,09                       ;
    LEA DX,TEXTO_GAB                ;impressao do TEXTO_GAB
    INT 21H                         ;

ALL_POP
    RET

IMPRIME_GABARITO ENDP

PARABENS PROC
;faz a impressao da mensagem parabens do jogo 
;ENTRADA:nao ha
;SAIDA: mensagem parabens

ALL_PUSH
CLEAR

    MOV AH,00h                 ;seta o modo de video para 320x200 - mode 13h
    MOV AL,13h                 ;
    INT 10h                    ;

    MOV AX, 0600H
    MOV BH, 0eh
    MOV DX, 1015H
    MOV CH, 12
    MOV CL, 15
    INT 10h      
;MENSAGEM DE PARABENS
;P
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 6                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 1                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 2                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 1                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h      

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 3                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 3                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 3                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 3                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  
    
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 2                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 3                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 2                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 1                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 
    
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 4                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 3                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 4                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 1                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h     
;A
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 6                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 5                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 3                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 5                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h   

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 2                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 6                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 2                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 6                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10H

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 6                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 7                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 3                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 7                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 4                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 7                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 4                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 5                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  
;R
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 6                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 9                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 2                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 9                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h      

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 3                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 11                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 3                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 11                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  
    
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 2                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 11                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 2                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 9                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 
    
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 4                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 11                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 4                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 9                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h    

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 5                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 10                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 5                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 10                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 6                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 11                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 6                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 11                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

;A
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 6                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 13                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 3                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 13                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h   

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 2                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 14                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 2                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 14                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10H

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 6                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 15                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 3                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 15                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 4                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 15                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 4                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 13                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 

;B
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 6                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 17                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 2                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 17                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h      

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 3                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 19                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 3                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 19                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  
    
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 2                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 19                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 2                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 17                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 
    
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 4                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 19                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 4                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 17                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h   
    
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 5                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 19                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 5                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 19                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 6                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 19                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 6                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 17                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

;E 
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 6                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 21                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 2                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 21                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h      
    
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 2                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 23                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 2                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 21                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 
    
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 4                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 23                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 4                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 21                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h    

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 6                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 23                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 6                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 21                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 

;N
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 6                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 25                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 2                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 25                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h     

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 3                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 26                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 3                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 26                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 4                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 27                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 4                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 27                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 5                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 28                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 5                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 28                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 6                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 29                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 2                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 29                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h    

;S 
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 2                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 35                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 2                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 32                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 3                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 31                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 3                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 31                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 4                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 34                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 4                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 32                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 5                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 35                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 5                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 35                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 6                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 34                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 6                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 31                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h 

;!
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 4                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 37                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 2                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 37                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h  

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001011b
    MOV DH, 6                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 37                 ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 6                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 37                 ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h       
    
;TROFEU  
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001110b
    MOV DH, 13                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 23                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 13                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 13                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h      
    
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001110b
    MOV DH, 15                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 22                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 15                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 14                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h      
 
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001110b
    MOV DH, 14                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 13                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 14                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 13                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h      

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001110b
    MOV DH, 14                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 23                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 14                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 23                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h      
    
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001110b
    MOV DH, 17                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 20                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 16                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 16                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h      
    
    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001110b
    MOV DH, 20                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 19                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 16                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 17                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h      

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001110b
    MOV DH, 20                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 20                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 20                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 16                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h

    MOV AH, 6
    MOV AL, 0
    MOV BH, 00001110b
    MOV DH, 21                  ;QUANTO MAIOR MAIS PARA BAIXO VAI, AUMENTA PARA BAIXO
    MOV DL, 21                  ;QUANTO MENOR MAIS A ESQUERDA VAI, DIMIDUI O LADO DIREITO
    MOV CH, 21                  ;QUANTO MENOR, MAIS VAI PARA CIMA, AUMENTA PARA CIMA
    MOV CL, 15                  ;QUANTO MAIOR MAIS A DIREITA VAI, OU SEJA DESENGROSSA
    INT 10h

    MOV AH,09                       ;
    LEA DX,JOG                      ;impressao da mensagem JOG
    INT 21H                         ;

VOLTA3:
    MOV AH,00h                      ;leitura de um characher (sem echo)
    INT 16h                         ;

    CMP AL,' '                      ;compara se o character digitado e igual a ESPACO
    JE JOGARNOV                     ;

    CMP AL,08                       ;compara se o character digitado e igual a BACKSPACE
    JE SAIR                         ;

    JMP VOLTA3                      ;faz a repeticao ate que um dos charateres citados acima sejam digitados

JOGARNOV:
    MOV JOGAR_DN, 1

SAIR:
ALL_POP
    RET

PARABENS ENDP

END MAIN
