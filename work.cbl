       IDENTIFICATION DIVISION. 
       PROGRAM-ID. BANK-SYSTEM.
      * *************************************
      * AUTHOR: ZADQUIEL TARDIO
      * PURPOSE: SISTEMA BANCARIO PROFESIONAL 
      * *************************************

       ENVIRONMENT DIVISION. 
       INPUT-OUTPUT SECTION. 
       FILE-CONTROL. 
           SELECT CTA-FILE ASSIGN TO 'cuentas.dat'
           ORGANIZATION IS INDEXED
           ACCESS MODE IS DYNAMIC
           RECORD KEY IS USER-ID
           FILE STATUS IS WS-FS.
       
       DATA DIVISION.
       
       SCREEN SECTION.
       01  LIMPAR-ECRA.
           02 BLANK SCREEN.
       
       FILE SECTION.
       FD  CTA-FILE.
       01  REG-UTILIZADOR.
           05  USER-ID          PIC 9(6).      
           05  USER-PASS        PIC 9(4).
           05  USER-NOME        PIC X(20).
           05  USER-APELIDO     PIC X(20).
           05  USER-CIDADE      PIC X(15).
           05  USER-PAIS-NOME   PIC X(20).  
           05  USER-IBAN-FULL.
               10 IBAN-PREFIJO  PIC X(4).   
               10 IBAN-RESTO    PIC X(21).
           05  USER-SALDO       PIC 9(10)V99.   

       WORKING-STORAGE SECTION.
       01  WS-CONTROLES.
           05 WS-FS             PIC XX.
           05 WS-OPCAO          PIC 9.
              88 INICIAR-CTA    VALUE 1.
              88 CRIAR-CTA      VALUE 2.
              88 SAIR-SISTEMA   VALUE 3.
           05 WS-ENCONTRADO     PIC X VALUE "N".
       
       01  WS-AUXILIARES.
           05 I                 PIC 9(02).
           05 WS-DIGITO         PIC 9(01).
           05 WS-PAIS-AUX       PIC X(02).
           05 WS-AUX-MONEY       PIC 9(7)V99.

       01  USER-PASS-TEMP        PIC 9(4).
       01  USER-NOME-TEMP        PIC X(20).

       PROCEDURE DIVISION.
       0100-MAIN.
           PERFORM 0200-MENU UNTIL SAIR-SISTEMA
           STOP RUN.

       0200-MENU.
           DISPLAY LIMPAR-ECRA
           DISPLAY "========================================"
           DISPLAY "       BEM-VINDOS AO BANCO DIGITAL       "
           DISPLAY "========================================"
           DISPLAY "1) INICIAR SESSAO (LOGIN POR ID)"
           DISPLAY "2) CRIAR UMA NOVA CONTA"
           DISPLAY "3) SAIR"
           DISPLAY "----------------------------------------"
           DISPLAY "OPCAO: " WITH NO ADVANCING
           ACCEPT WS-OPCAO.

           EVALUATE TRUE
               WHEN INICIAR-CTA
                   PERFORM 0300-INICIAR-CTA
               WHEN CRIAR-CTA
                   PERFORM 0400-CRIAR-CTA
               WHEN SAIR-SISTEMA
                   DISPLAY "OBRIGADO POR USAR O BANCO DIGITAL!"
               WHEN OTHER
                   DISPLAY "OPCAO INVALIDA! ENTER PARA VOLTAR."
                   ACCEPT WS-PAIS-AUX
           END-EVALUATE.

       0300-INICIAR-CTA.
           DISPLAY LIMPAR-ECRA
           DISPLAY "--- LOGIN DO SISTEMA ---"
           DISPLAY "INSERIR O SEU ID (6 DIGITOS): " WITH NO ADVANCING
           ACCEPT USER-ID.

           OPEN I-O CTA-FILE.
           
           IF WS-FS = "35" 
               DISPLAY "ERRO: O ARQUIVO DE CONTAS NAO EXISTE!"
               CLOSE CTA-FILE
           ELSE
               READ CTA-FILE
                   INVALID KEY
                       DISPLAY "ID NAO ENCONTRADO!"
                       MOVE "N" TO WS-ENCONTRADO
                   NOT INVALID KEY
                       DISPLAY "PALAVRA-PASSE: " WITH NO ADVANCING
                       ACCEPT USER-PASS-TEMP WITH NO-ECHO
                       
                       IF USER-PASS-TEMP = USER-PASS
                           MOVE "S" TO WS-ENCONTRADO
                       ELSE
                           DISPLAY "PASSWORD INCORRETA!"
                           MOVE "N" TO WS-ENCONTRADO
                       END-IF
               END-READ
               CLOSE CTA-FILE
           END-IF.

           IF WS-ENCONTRADO = "S"
               PERFORM 0500-CTA
           ELSE
               DISPLAY "PRESSIONE ENTER PARA VOLTAR."
               ACCEPT WS-PAIS-AUX
           END-IF.

       0400-CRIAR-CTA.
           OPEN I-O CTA-FILE.
           
           IF WS-FS = "35"
               OPEN OUTPUT CTA-FILE
           END-IF.

           DISPLAY LIMPAR-ECRA
           DISPLAY "--- FORMULARIO DE NOVA CONTA ---"
           
           COMPUTE USER-ID = (FUNCTION RANDOM(FUNCTION 
                               CURRENT-DATE(13:4)) * 900000) + 100000.
           
           DISPLAY "ID ATRIBUIDO: " USER-ID
           DISPLAY "NOME: " WITH NO ADVANCING.
           ACCEPT USER-NOME.
           DISPLAY "APELIDO: " WITH NO ADVANCING.
           ACCEPT USER-APELIDO.
           DISPLAY "PAIS (PT / ES): " WITH NO ADVANCING.
           ACCEPT WS-PAIS-AUX.

           IF WS-PAIS-AUX = "PT" OR "pt"
               MOVE "PT50" TO IBAN-PREFIJO
           ELSE
               MOVE "ES91" TO IBAN-PREFIJO
           END-IF.

           PERFORM 0999-GERAR-IBAN-RANDOM.
           MOVE 0 TO USER-SALDO.

           DISPLAY "ESCOLHA UMA PASSWORD (4 DIGITOS): " 
                   WITH NO ADVANCING.
           ACCEPT USER-PASS WITH NO-ECHO.
           
           WRITE REG-UTILIZADOR
               INVALID KEY
                   DISPLAY "ERRO CRITICO: ID DUPLICADO!"
           END-WRITE.
           
           CLOSE CTA-FILE.
           
           DISPLAY "CONTA CRIADA COM SUCESSO!"
           DISPLAY "SEU IBAN: " USER-IBAN-FULL
           DISPLAY "PRESSIONE ENTER PARA VOLTAR."
           ACCEPT WS-PAIS-AUX.

       0500-CTA.
           DISPLAY LIMPAR-ECRA
           DISPLAY "========================================"
           DISPLAY "BEM-VINDO/A, " USER-NOME
           DISPLAY "IBAN:  " USER-IBAN-FULL
           DISPLAY "SALDO: " USER-SALDO " EUR"
           DISPLAY "========================================"
           DISPLAY "1) DEPOSITAR DINHEIRO"
           DISPLAY "2) LEVANTAR DINHEIRO"
           DISPLAY "3) CONFIGURAÇÕES DA CONTA"
           DISPLAY "4) SAIR"
           ACCEPT WS-OPCAO.

           EVALUATE TRUE
               WHEN WS-OPCAO = 1
                   DISPLAY "VALOR A DEPOSITAR: " WITH NO ADVANCING
                   ACCEPT WS-AUX-MONEY
                   ADD WS-AUX-MONEY TO USER-SALDO
                   
                   OPEN I-O CTA-FILE
                   REWRITE REG-UTILIZADOR
                   CLOSE CTA-FILE
                   
                   DISPLAY "SALDO ATUALIZADO!"
                   ACCEPT WS-PAIS-AUX
                   PERFORM 0500-CTA
              WHEN WS-OPCAO = 2
                   DISPLAY "VALOR A LEVANTAR: " WITH NO ADVANCING
                   ACCEPT WS-AUX-MONEY
                   IF WS-AUX-MONEY > USER-SALDO
                       DISPLAY "SALDO INSUFICIENTE!"
                       ACCEPT WS-PAIS-AUX 
                       PERFORM 0500-CTA
                   ELSE
                       SUBTRACT WS-AUX-MONEY FROM USER-SALDO

                   OPEN I-O CTA-FILE
                       REWRITE REG-UTILIZADOR
                   CLOSE CTA-FILE

                   DISPLAY "SALDO ATUALIZADO!"
                   ACCEPT WS-PAIS-AUX
                   PERFORM 0500-CTA
              WHEN WS-OPCAO = 3
                   DISPLAY "==============================="
                   DISPLAY "CONFIGURAÇÕES DA SUA CONTA"
                   DISPLAY "==============================="
                   DISPLAY "1) ALTERAR A SUA PALAVRA-PASSE"
                   DISPLAY "2) VOLTAR AO MENU"
                   ACCEPT WS-PAIS-AUX
                   
                   PERFORM 0600-CTA-CONFIG
              WHEN WS-OPCAO = 4
                   PERFORM 0200-MENU
           END-EVALUATE.
       
       0600-CTA-CONFIG.
           EVALUATE TRUE
              WHEN WS-PAIS-AUX = 1
                    DISPLAY "NOVA PALAVRA-PASSE (4 DIGITOS): " 
                            WITH NO ADVANCING
                    ACCEPT USER-PASS WITH NO-ECHO
      
                    OPEN I-O CTA-FILE
                        REWRITE REG-UTILIZADOR
                    CLOSE CTA-FILE
      
                    DISPLAY "PALAVRA-PASSE ATUALIZADA!"
                    ACCEPT WS-PAIS-AUX
      
                    PERFORM 0600-CTA-CONFIG
              WHEN WS-PAIS-AUX = 2
                    PERFORM 0500-CTA
              WHEN OTHER
                    DISPLAY WS-PAIS-AUX " NÃO É UMA OPÇÃO!"
            END-EVALUATE.

       0999-GERAR-IBAN-RANDOM.
           COMPUTE WS-DIGITO = FUNCTION RANDOM(FUNCTION 
                                        CURRENT-DATE(13:4)).
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 21
               COMPUTE WS-DIGITO = FUNCTION RANDOM * 10
               MOVE WS-DIGITO TO IBAN-RESTO(I:1)
           END-PERFORM.
