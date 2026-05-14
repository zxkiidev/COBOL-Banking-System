# 🏦 Bank System - Projeto Profissional em COBOL

Este é um sistema bancário robusto desenvolvido em **COBOL**, desenhado para demonstrar competências em programação estruturada, gestão de ficheiros indexados e lógica de negócio financeira. O projeto simula as operações principais de um banco digital moderno, otimizado para o compilador **GnuCOBOL**.

## 🚀 Principais Funcionalidades

*   **Persistência de Dados:** Utiliza ficheiros indexados (`ORGANIZATION IS INDEXED`) para armazenar registos de utilizadores num ficheiro `.dat`, permitindo pesquisas e atualizações rápidas através de um `USER-ID` único.
*   **Geração Dinâmica de Dados:** 
    *   Atribuição de IDs de utilizador aleatórios de 6 dígitos.
    *   Geração automática de **IBAN** personalizado de acordo com o país de residência (suporte para Portugal e Espanha).
*   **Segurança no Terminal:** Sistema de login por ID e palavra-passe com ocultação de caracteres (`WITH NO-ECHO`).
*   **Módulo Financeiro:** 
    *   Depósitos e levantamentos com validação de saldo insuficiente.
    *   Gestão de saldo com precisão decimal (`PIC 9(10)V99`).
*   **Configuração de Perfil:** Submenu dedicado para alterar a palavra-passe, entre outros em tempo real, atualizando automaticamente o registo no disco.

---

## 🛠️ Tecnologias e Normas

*   **Linguagem:** COBOL (Dialeto GnuCOBOL).
*   **Interface:** `SCREEN SECTION` para uma experiência de utilizador limpa e gestão de ecrã completo (`BLANK SCREEN`).
*   **Estruturas Avançadas:** 
    *   Uso de níveis `88` (Nomes de condição) para um fluxo de controlo elegante.
    *   Sentenças `EVALUATE` para a gestão de menus.
    *   Controlo de estados de ficheiro através de `FILE STATUS`.

---

## 📂 Estrutura do Código

O programa está organizado de forma modular para facilitar a leitura e escalabilidade:

| Parágrafo | Função |
| :--- | :--- |
| `0100-MAIN` | Controlo do ciclo de vida do programa. |
| `0200-MENU` | Interface do menu principal. |
| `0300-INICIAR-CTA` | Processo de login e leitura do ficheiro indexado. |
| `0400-CRIAR-CTA` | Registo de novos utilizadores e escrita no ficheiro. |
| `0500-CTA` | Dashboard do utilizador (Saldo, Depósitos, Levantamentos). |
| `0600-CTA-CONFIG` | Gestão de definições de conta (Password/etc). |
| `0999-GERAR-IBAN-RANDOM` | Algoritmo para a criação de IBANs aleatórios. |

---

## 💻 Compilação e Execução

Para correr este projeto, necessitas de ter o **GnuCOBOL** instalado.

1.  **Compilar:**
    ```bash
    cobc -x BANK-SYSTEM.cbl
    
2. Executar:
    ```Bash
    ./BANK-SYSTEM

---

## 📄 Licença

Este projeto está licenciado sob a **Licença MIT** - consulte o ficheiro [LICENSE](LICENSE) para mais detalhes.

---

## 📝 Autor

*   **Zadquiel Tardío** - *Estudante de Informática e apaixonado por sistemas Mainframe.*
*   Comunidade: **[COBOL DEVS ES](https://discord.gg/3E76RVMdZK)** (Mainframe & COBOL Enthusiasts).

---

### 💡 Nota sobre o Desenvolvimento
Este projeto foi desenvolvido com foco na lógica de ficheiros indexados, simulando a forma como um sistema real geriria milhares de contas de forma eficiente. Utiliza a `SCREEN SECTION` do GnuCOBOL para proporcionar uma interface visual interativa e profissional a partir do terminal.