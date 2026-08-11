#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<cstdlib>     // Necessário para usar a função system() PING SERVIDOR
#include<windows.h> // Necessário para usar a função Sleep()
#include <time.h> // Biblioteca obrigatória para manipulação de tempo

#define IP "192.168.0.101"
#define IP_SERVIDOR "192.168.0.101"

#define HISTORY 999
#define MAX 9998 //Quantidade do estoque
#define USUARIOS 5
#define PERMISSAO 10
			

//=================================================================================== data e hora =======================================================================================================================
void data_hora(char data[20], char hora[20]) 
{
    FILE *stream;

    // 1. Pegando a DATA do sistema
    stream = popen("echo %date%", "r");
    if (stream != NULL) {
        if (fgets(data, 20, stream) != NULL) {
            for(int i = 0; i < 20; i++) {
                if(data[i] == '\n' || data[i] == '\r') {
                    data[i] = '\0';
                    break;
                }
            }
        }
        pclose(stream); 
    }

    // 2. Pegando a HORA do sistema
    stream = popen("echo %time%", "r");
    if (stream != NULL) {
        if (fgets(hora, 20, stream) != NULL) {
            // Remove a quebra de linha inicial para evitar bugs
            for(int i = 0; i < 20; i++) {
                if(hora[i] == '\n' || hora[i] == '\r') {
                    hora[i] = '\0';
                    break;
                }
            }
            //  Corta a string após os minutos (mantém apenas HH:MM)
            // Se a hora começar com espaço (ex: " 9:57"), removemos o espaço primeiro
            if (hora[0] == ' ') {
                hora[5] = '\0'; // Corta em " 9:57" horas[8] 9:57:22
            } else {
                hora[5] = '\0'; // Corta em "21:57" horas[8] 21:57:22
            }
        }
        pclose(stream); 
    }

    // 3. Exibindo as variáveis salvas no seu programa
   // printf("\n\t[SUCESSO] Dados capturados do sistema!\n");
   // printf("\tData guardada na variavel: %s\n", data);
    //printf("\tHora guardada na variavel: %s\n\n", hora);
}
 

//================================================================================================================================================================================
void manutencao()
{
    system("cls");
     
    printf ("") ;
    printf ("\n\t\t\t\033[1;32m=====================================================\033[1;32m\n") ;
    printf( "\t\t\t\t         \033[1;33mAVISO DO SISTEMA\033[0m                     \n");
    printf ("\t\t\t\033[1;32m=====================================================\033[1;32m\n") ;
    printf (" \n\t\t\t\t [!] PAGINA EM MANUTENCAO [!]\n\n ") ;
    printf ("\t\t\t\tEstamos trabalhando para melhorar. \n") ;
    printf (" \t\t\t\tPor favor, tente novamente mais tarde.\n\n") ;
    printf ("\t\t\t\033[1;32m=====================================================\033[1;32m\n") ;
    Sleep(2000);
}
//======================================================================= ping ===================================================================================================
void ping() 
{
       
    char comando[100];
    int status;
    
	sprintf(comando, " ping -n 1 %s > nul", IP_SERVIDOR); //ping -n 1' envia apenas 1 pacote.
   
    printf("\n\n\n\n\t\t Verificando conexao com o servidor [%s]... \n\n", IP_SERVIDOR);
       
    status = system(comando);// Executa o comando. Se o servidor responder, o retorno é 0.
        
    if (status == 0) 
    {
        printf("\n\t\t\033[1;32m[ONLINE] O servidor esta respondendo normalmente!\n");
        printf("\t        Pode carregar ou salvar os arquivos com seguranca.\033[1;32m\n");
    } 
    else 
    {
        printf("\n\t\t\033[1;31m[OFFLINE] Erro! Nao foi possivel alcancar o servidor.\n");
        printf("\t        Verifique os cabos, o IP ou se o Samba esta rodando.\n");
    }
    
}


//===================================================================== CARREGAR (DADOS BANCARIOS  ARQUIVO .TXT)===============================================================================================
void carregar_cofre(float *cofre, float *saldo_caixa, int *qt_deposito,int conta[HISTORY], int agencia[HISTORY], float historico_valor_deposito[HISTORY], char data_deposito[HISTORY][20], char hora_deposito[HISTORY][20], char historico_user_login[HISTORY][30])
{
	//FILE *arquivo_leitura = fopen("dados.txt", "w");
    FILE *arquivo_leitura = fopen("\\\\192.168.0.101\\dados\\depositos.txt", "r");
    
    if (arquivo_leitura != NULL) 
    {
        
        fscanf(arquivo_leitura, "%f\n", saldo_caixa); 
        fscanf(arquivo_leitura, "%f\n", cofre);
        fscanf(arquivo_leitura, "%d\n", qt_deposito); 
        
       
        for (int i = 1; i < *qt_deposito; i++) 
        {
           
            fscanf(arquivo_leitura, "%f %s %s %d %d %s\n", 
                    &historico_valor_deposito[i], 
                    data_deposito[i], 
                    hora_deposito[i],
                    &conta[i],
                    &agencia[i], 
                    historico_user_login[i]);
        }
        
        fclose(arquivo_leitura);
        printf("\n\n\t\t\033[1;32m    [SUCESSO] Dados do cofre carregados com sucesso!\n");
        Sleep(2500);
    } 
    else // Se o arquivo não existir (primeira execução), inicia as variáveis zeradas
    {
        *saldo_caixa = 0.0;
        *cofre = 0.0;
        *qt_deposito = 1;
        printf("\n\n\t\t\033[1;34m    [AVISO] Arquivo nao encontrado. Inicializando saldos zerados.\n");
        Sleep(2500);
    }
}
//====================================================================== SALVAR (DADOS BANCARIOS  ARQUIVO .TXT)==================================================================================================
void salvar_cofre(float *cofre, float *saldo_caixa, int *qt_deposito,int conta[HISTORY], int agencia[HISTORY], float historico_valor_deposito[HISTORY], char data_deposito[HISTORY][20], char hora_deposito[HISTORY][20], char historico_user_login[HISTORY][30])
{
    
    //FILE *arquivo_escrita = fopen("depositos.txt", "r");
	FILE *arquivo_escrita = fopen("\\\\192.168.0.101\\dados\\depositos.txt", "w");
    
    if (arquivo_escrita != NULL) 
    {
       
        fprintf(arquivo_escrita, "%f\n", *saldo_caixa);
        fprintf(arquivo_escrita, "%f\n", *cofre);
        fprintf(arquivo_escrita, "%d\n", *qt_deposito); 
        
        
        for (int i = 1; i < *qt_deposito; i++) 
        {
            
            fprintf(arquivo_escrita, "%.2f %s %s %d %d %s\n", 
                    historico_valor_deposito[i], 
                    data_deposito[i], 
                    hora_deposito[i],
					conta[i],
					agencia[i], 
                    historico_user_login[i]);
        }
        
        fclose(arquivo_escrita);
        printf("\a"); 
        printf("\n\n\t\t\033[1;32m    [SUCESSO] Dados salvos no servidor com sucesso!\n");
        Sleep(2500);
    } 
    else
    {
        printf("\n\n\t\t\033[1;34m    [ERRO] Sem permissao de escrita ou servidor offline!\n\n\n\n\n\n\n");
        Sleep(2500);
    }
}


//====================================================================== CARREGAR (PRODUTOS DO ARQUIVO .TXT====================================================================================================
void carregar(int *total_produtos, int codigo[MAX], char nome_produto[MAX][30], float preco[MAX], int qt_estoque[MAX], float *saldo_caixa, float *cofre)
{
   
    int largura_barra = 45,blocos_preenchidos;
	
	
	//FILE *arquivo_leitura = fopen("dados.txt", "r");//CARREGAR O ARQUIVO DO PC LOCAL
	FILE *arquivo_leitura = fopen("\\\\192.168.0.101\\dados\\dados.txt", "r");
    
    if (arquivo_leitura != NULL) 
    {
        if (fscanf(arquivo_leitura, "%d\n", total_produtos) != EOF) 
            
        {
            for (int i = 1; i < *total_produtos; i++) 
            {
                fscanf(arquivo_leitura, "%d %29s %f %d\n", &codigo[i], &nome_produto[i], &preco[i], &qt_estoque[i]);
            }
        }
        fclose(arquivo_leitura);
       
    //================BARRA DE PORCENTAGEM===================
            
		printf("\n\n\n");
	    for (int porcentagem = 0; porcentagem <= 100; porcentagem++) 
		{
            blocos_preenchidos = (porcentagem * largura_barra) / 100;   
            
			printf("\t\033[1;32mCarregando: \033[0m [");        
       
        	for (int i = 0; i < largura_barra; i++) 
			{
            	if (i < blocos_preenchidos) 
				{
                	printf("\033[1;34m°\033[0m"); 
            	} 
				else 
				{
                	printf(" "); 
            	}
        	}	
             
        	printf("] \033[1;m \033[1;32m%d%% \033[0m \r", porcentagem);// Mostra a porcentagem numérica ao lado da barra
                
        	fflush(stdout); // Descarrega o texto acumulado imediatamente para a tela
       
        	if (porcentagem < 20) // Controla a velocidade da animação (tempo em milissegundos)  Menor o número = Mais rápido. Maior = Mais lento.
			{
            	Sleep(4);  
        	} 
			else if (porcentagem >= 20 && porcentagem < 70) 
			{
            	Sleep(8);  
        	}	 
			else if (porcentagem >= 70 && porcentagem < 90) 
			{
            	Sleep(7); 
        	} 
			else 
			{
            	Sleep(1);  
        	}		
       	}
   	}
	else
	{
        printf("\n\t\t[AVISO] Nao foi possivel conectar ao servidor ou o arquivo nao existe.\n");
        Sleep(2000);
    }
}

//============================================================== SALVAR (PRODUTOS NO ARQUIVO .TXT ===================================================================================================
void salvar(int *total_produtos, int codigo[MAX], char nome_produto[MAX][30], float preco[MAX], int qt_estoque[MAX], float *saldo_caixa, float *cofre)
{
   
   int largura_barra = 45,blocos_preenchidos;
    printf("\n\t\t\tSalvando informacoes no servidor...\n");
    
    //FILE *arquivo_escrita = fopen("dados.txt", "w");//SALVA O ARQUIVO NO PC LOCAL
    FILE *arquivo_escrita = fopen("\\\\192.168.0.101\\dados\\dados.txt", "w");
    
    if (arquivo_escrita != NULL) 
    {
        
		fprintf(arquivo_escrita, "%d\n", *total_produtos); 
        
        for (int i = 1; i < *total_produtos; i++) 
        {
            fprintf(arquivo_escrita, "%d %s %.2f %d\n", codigo[i], nome_produto[i], preco[i], qt_estoque[i]);
        }
        
        fclose(arquivo_escrita);
        
    //================BARRA DE PORCENTAGEM===================
        	    
		printf("\n\n\n");
	    for (int porcentagem = 0; porcentagem <= 100; porcentagem++) 
		{
            blocos_preenchidos = (porcentagem * largura_barra) / 100;   
            
			printf("\t\033[1;32m   Salvando: \033[0m[");        
       
        	for (int i = 0; i < largura_barra; i++) 
			{
            	if (i < blocos_preenchidos) 
				{
                	printf("\033[1;34m°\033[0m"); 
            	}	 
				else 
				{
                	printf(" "); 
            	}
        	}
             
            printf("] \033[1;m \033[1;32m%d%% \033[0m \r", porcentagem);// Mostra a porcentagem numérica ao lado da barra
                
        	fflush(stdout); // Descarrega o texto acumulado imediatamente para a tela
       
        	if (porcentagem < 20) // Controla a velocidade da animação (tempo em milissegundos)  Menor o número = Mais rápido. Maior = Mais lento.
			{
            	Sleep(4);  
       
	    	} 
			else if (porcentagem >= 20 && porcentagem < 70) 
			{
            	Sleep(8);  
       
	    	}	 
			else if (porcentagem >= 70 && porcentagem < 90) 
			{
            	Sleep(9); 
        	}	 
			else 
			{
        	    Sleep(3);  
        	}
    	}
    }
	else
	{
        printf("\n\t\t[AVISO] Nao foi possivel conectar ao servidor ou o arquivo nao existe.\n");
        Sleep(2000);
    }
}
//======================================================================= SALVAR RAPIDO (PRODUTOS NO ARQUIVO .TXT ===================================================================================================
void salvar_rapido(int *total_produtos, int codigo[MAX], char nome_produto[MAX][30], float preco[MAX], int qt_estoque[MAX], float *saldo_caixa, float *cofre)
{
          
	//FILE *arquivo_escrita = fopen("dados.txt", "w");//SALVA O ARQUIVO NO PC LOCAL
    FILE *arquivo_escrita = fopen("\\\\192.168.0.101\\dados\\dados.txt", "w");
    
    if (arquivo_escrita != NULL) 
    {
        
		fprintf(arquivo_escrita, "%d\n", *total_produtos); 
        
        for (int i = 1; i < *total_produtos; i++) 
        {
            fprintf(arquivo_escrita, "%d %s %.2f %d\n", codigo[i], nome_produto[i], preco[i], qt_estoque[i]);
        }
        
        fclose(arquivo_escrita);
        printf("\a");
        
    } 
    else
    {
        printf("\n\t\t[ERRO] Sem permissao de escrita ou servidor offline!\n\n\n\n\n\n\n");
        Sleep(2000);
    }
}

//============================================================== CARREGAR USUARIOS DO ARQUIVO .TXT ===================================================================================
void carregar_user(int *cont, char user[USUARIOS][30], int senha[USUARIOS], int ID[USUARIOS], int permissao[USUARIOS][PERMISSAO]) 
{ 	 	 
    // FILE *arquivo_leitura = fopen("LOGIN.txt", "r");
    FILE *arquivo_leitura = fopen("\\\\192.168.0.101\\dados\\LOGIN.txt", "r");
    
    if (arquivo_leitura != NULL) 
    {
        if (fscanf(arquivo_leitura, "%d", cont) != EOF) 
        {
            for (int i = 0; i < *cont; i++) 
            {
                fscanf(arquivo_leitura, "%d %29s %d", &ID[i], user[i], &senha[i]);
            
                for (int j = 0; j < PERMISSAO; j++)
                {
                    fscanf(arquivo_leitura, "%d", &permissao[i][j]);
                }
            }
        }
        fclose(arquivo_leitura);
    }
    else
    {
        // IMPLEMENTAÇÃO: Se o arquivo não existe, cria o usuário 'root' 
        printf("\n\n\t\t\033[1;32m[INFO]     Criando novo banco de dados LOGIN.txt...\n");
        printf("\t\t\033[1;32m[INFO]     User ... :\033[1;34m root    \033[1;32m Senha ... :\033[1;34m 3585 \033[0m \n\n");
        
        ID[0] = 1000;                  // ID do root
        strcpy(user[0], "root");    // Nome do root 
        senha[0] = 3585;            // Senha do root
        
       
        for (int j = 0; j < PERMISSAO; j++) // Atribui todas as permissões como ativas (1) para o administrador root
        {
            permissao[0][j] = 1;
        }
        
        *cont = 1; //sistema sabe que existe 1 usuário cadastrado (o root)
        
        system("pause > nul");
    }
}

//============================================================== SALVAR USUARIOS NO ARQUIVO .TXT ==========================================================================================
void salvar_user(int *cont, char user[USUARIOS][30], int senha[USUARIOS], int ID[USUARIOS], int permissao[USUARIOS][PERMISSAO]) 
{
    // FILE *arquivo_escrita = fopen("LOGIN.txt", "w");
    FILE *arquivo_escrita = fopen("\\\\192.168.0.101\\dados\\LOGIN.txt", "w");
    
    if (arquivo_escrita != NULL) 
    {
        
        fprintf(arquivo_escrita, "%d\n", *cont); 
        
        
        for (int i = 0; i < *cont; i++) 
        {
            fprintf(arquivo_escrita, "%d %s %d ", ID[i], user[i], senha[i]);
            
            for (int j = 0; j < PERMISSAO; j++)
            {
                fprintf(arquivo_escrita, "%d ", permissao[i][j]);
            }
            fprintf(arquivo_escrita, "\n");
        }
        
        fclose(arquivo_escrita);
        printf("\a"); // Emite o sinal sonoro de sucesso
    } 
    else
    {
        printf("\n\t\t[ERRO] Sem permissao de escrita ou servidor offline!\n\n\n\n\n\n\n");
        Sleep(2000);
    }
}
//================================================================= TELA DE LOGIN ======================================================================================
void login(int *cont, char user[USUARIOS][30], int senha[USUARIOS], int ID[USUARIOS], int permissao[USUARIOS][PERMISSAO], char user_login[30], int *ID_login)
{ 
    
    char usuario_digitado[30]; 
    int senha_digitada;
    int login_sucesso = 0; // Variável de controle (0 = falso, 1 = verdadeiro)
    int indice_usuario = -1;

    system("cls"); 
    printf("\t\033[1;34m==================================================\n"); 
    printf("\t\033[1;33m             AUTENTICACAO DE ACESSO               \n"); 
    printf("\t\033[1;34m==================================================\033[0m\n\n"); 
    
    printf("\t\033[1;36m USUARIO ... : \033[1;32m "); 
    scanf("%29s", usuario_digitado); 
    
    printf("\t\033[1;36m SENHA ..... : \033[0m"); 
	printf("\033[30m"); // Ativa a cor preta para ocultar a digitação no fundo preto
	scanf("%d", &senha_digitada); 
	printf("\033[0m");  
         
    
    printf("\n\t\033[1;34m--------------------------------------------------\033[0m\n"); 
   
      
	for(int i = 0; i < *cont; i++) 
	{ 
        
        if ((strcmp(usuario_digitado, user[i]) == 0) && (senha_digitada == senha[i]))
		{ 
            login_sucesso = 1; 
            indice_usuario = i; // Guarda a posição do usuário logado
            *ID_login = i;
			break; 
        } 
    } 
    
    if (login_sucesso) {
        printf("\n\t\033[1;32m[SUCESSO] Acesso concedido! Bem-vindo, %s.\n\n", user[indice_usuario]);
        printf("\t\033[1;34m==================================================\033[0m\n\n"); 
		Sleep(2000);
        strcpy(user_login, user[indice_usuario]); 
        
    } 
	else 
	{
        printf("\n\t\033[1;31m[ERRO] Usuario ou senha incorretos. Tente novamente.\n\n");
    	printf("\t\033[1;34m==================================================\033[0m\n\n"); 
		Sleep(2000);
		login(cont, user, senha, ID, permissao,user_login,ID_login);
  	}
}
//=============================================================== CASE 1: CADASTRAR PRODUTO ===========================================================================
void cadastro(int *total_produtos, int codigo[MAX], char nome_produto[MAX][30], float preco[MAX], int qt_estoque[MAX]) 
{
    int menu = 2; // Começa em 2 (Não) por padrão

    do 
    {
        // Verifica se o estoque já está cheio antes de tentar cadastrar
        if (*total_produtos >= MAX) 
        {
            system("cls");
            printf("\n\n\n\n\n\n");
            printf("\033[1;31m      ================================================================================\033[0m\n");
            printf("\033[1;31m                [AVISO]\033[0m \033[1;32mLimite de armazenamento atingido\033[0m \033[1;34m(%d produtos)! \033[0m\n", MAX);
            printf("\033[1;31m      ================================================================================\033[0m\n\n");
            Sleep(2000);
            
            return; // Sai da função imediatamente
        }

        system("cls");
        printf("\n\033[1;31m  ===================================\033[0m\033[1;34m CADASTRAR PRODUTOS \033[0m\033[1;31m==============================\033[0m\n");
        
        printf("\n\n\t \033[1;32mCODIGO GERADO ........... : \033[1;44m # %d \033[0m   \n", *total_produtos);
       
        printf("\033[1;32m   \n");
        
        printf("\t NOME DO PRODUTO ......... : ");    
        scanf("%29s", nome_produto[*total_produtos]); 
        
        printf("\t PRECO DO PRODUTO (R$) ... : ");    
        scanf("%f", &preco[*total_produtos]);
        
        printf("\t QUANTIDADE EM ESTOQUE ... : ");    
        scanf("%d", &qt_estoque[*total_produtos]);
        
        codigo[*total_produtos] = *total_produtos;
        (*total_produtos)++; 

       
        if (*total_produtos < MAX)  // Se ainda houver espaço, pergunta se deseja continuar
        {
            printf("\n\t\033[1;31mCADASTRAR OUTRO PRODUTO? [1-SIM / 2-NAO] -> \033[0m");
            scanf("%d", &menu);        
        }
        else 
        {
           
        system("cls");
        printf("\n\n\n\n\n\n");
        printf("\033[1;31m      ================================================================================\033[0m\n");
        printf("\033[1;31m                [AVISO]\033[0m \033[1;32mLimite de armazenamento atingido\033[0m \033[1;34m(%d produtos)! \033[0m\n", MAX);
        printf("\033[1;31m      ================================================================================\033[0m\n\n");
        printf("\t\033[1;33m              Pressione ENTER para voltar ao menu...\033[0m");
		system("pause > nul");
        menu = 2; // Força a saída do loop se atingiu o MAX após este cadastro
		}

    } while (menu == 1);

	
}


//============================================================== CASE 2: VENDAS =========================================================================================================
void venda(int *total_produtos, int codigo[MAX], char nome_produto[MAX][30], float preco[MAX], int qt_estoque[MAX], float *saldo_caixa)
{
    system("cls");
    
    int cod_pesquisa, qt_venda, achou = 0;
    float total_venda = 0;
    float total_acumulado = 0;

    // VARIÁVEIS NOVAS: Histórico local da compra atual do cliente
    char historico_nome[MAX][30];
    int historico_qtd[MAX];
    float historico_subtotal[MAX];
    int total_itens_comprados = 1; // Contador de quantos produtos diferentes ele comprou nesta sessão

    do
    {
        achou = 0; 
        
        system("cls");
        printf("\n\033[1;31m ================================================================================\033[0m\n");
        printf("\033[1;31m                              \033[0m\033[1;34mSISTEMA DE VENDAS\033[0m                                \033[1;31m\033[0m\n");
        printf("\033[1;31m ================================================================================\033[0m\n");
        printf("  \033[1;33m[!] DIGITE 0 NO CODIGO PARA FINALIZAR A COMPRA E VER O CUPOM\033[0m\n");
        printf("\033[1;31m ================================================================================\033[0m\n\n");
        printf("\033[1;32m CODIGO DO PRODUTO ... : ");    
        scanf("%d", &cod_pesquisa);    

        if(cod_pesquisa == 0) break; 
        
        system("cls");
    
        for(int i = 1; i < *total_produtos; i++)
        {    
            if((cod_pesquisa == codigo[i]) && (codigo[i] > 0)) 
            {    
                achou = 1; 
                printf("\n\033[1;31m ================================================================================\033[0m\n");
            	printf("\033[1;31m                               \033[0m\033[1;34mPRODUTO ENCONTRADO \033[0m                              \033[1;31m\033[0m\n");
            	printf("\033[1;31m ================================================================================\033[0m\n");
            	printf("\033[1;32m\t%-20s \t%-10s \t%-12s \t%-10s\033[0m\n", "NOME DO PRODUTO", "CODIGO", "PRECO", "ESTOQUE");     
            	printf("\033[1;33m --------------------------------------------------------------------------------\033[0m\n");
            	printf("\t%-20s \t#%03d      \tR$ %-10.2f \t%d Un\n", nome_produto[i], codigo[i], preco[i], qt_estoque[i]);    
            	printf("\033[1;31m ================================================================================\033[0m\n");
                printf("\n\n\033[1;32m DIGITE A QUANTIDADE PARA VENDA ... : ");   
                scanf("%d", &qt_venda);
                    
                if(qt_venda > 0 && qt_venda <= qt_estoque[i]) 
                {
                    qt_estoque[i] -= qt_venda; 
                    total_venda = qt_venda * preco[i];
                    total_acumulado += total_venda;    
                	strcpy (historico_nome[total_itens_comprados], nome_produto[cod_pesquisa]);
					historico_qtd[total_itens_comprados] = qt_venda;				
                	historico_subtotal[total_itens_comprados] = total_venda;
                    
                    system("cls");
					printf("\n\n\n\n\n\n");
					printf("\033[1;31m      ================================================================================\033[0m\n");
                    printf("  \033[1;32m                      [SUCESSO] Item adicionado ao carrinho!\033[0m\n\a");
                    printf("\033[1;31m      ================================================================================\033[0m\n\n");
					Sleep(2000);
                    
					total_itens_comprados++; 
                }
                else
                {
                    system("cls");
					printf("\n\n\n\n\n\n");
					printf("\033[1;31m      ================================================================================\033[0m\n");
                    printf("\033[1;32m         [ERRO] Estoque insuficiente ou quantidade invalida! Operacao cancelada.\033[0m\n");
                    printf("\033[1;31m      ================================================================================\033[0m\n\n");
					Sleep(2000);
					
                }
                
                break; 
            }
        
		}
		                     
    
        if(achou == 0) 
        {
            printf("\n\n\n\n\n\n");
			printf("\033[1;31m              ================================================================================\033[0m\n");
            printf("\033[1;32m                           [AVISO] PRODUTO NAO ENCONTRADO NO SISTEMA!\033[0m\n"); 
            printf("\033[1;31m              ================================================================================\033[0m\n");
            Sleep(2000); 
        }

    }         
    while(cod_pesquisa != 0);

    // ==================== TELA DO CUPOM FISCAL / DETALHAMENTO ====================
    system("cls");
    printf("\n\033[1;31m ================================================================================\033[0m\n");
    printf("\033[1;31m                              \033[0m\033[1;34m    CUPOM FISCAL\033[0m                            \033[1;31m\033[0m\n");
    printf("\033[1;31m ================================================================================\033[0m\n");
    
    if (total_itens_comprados == 0) 
    {
        printf("\n\t\033[1;33m[!] NENHUM PRODUTO FOI COMPRADO NESSA SESSÃO.\033[0m\n\n");
    } 
    else 
    {
        printf("\033[1;32m   %-20s   %-12s   %20s  \033[0m\n", "PRODUTO COMPRADO", "QTD VENDIDA", "SUBTOTAL (R$)");
        printf("\033[1;31m --------------------------------------------------------------------------------\033[0m\n");
        
        // Loop correto para exibir o histórico gerado de forma sequencial
        for(int i = 1; i < total_itens_comprados; i++)
        {
            printf("\t\033[1;33m%-20s   %-12d      R$ %-1.2f \n\033[0m", historico_nome[i], historico_qtd[i],historico_subtotal[i] );
            printf("\033[1;31m --------------------------------------------------------------------------------\033[0m\n");
        }
    }
      
    printf("\033[1;31m ================================================================================\033[0m\n");
    printf("\n\t\033[1;32m                   VALOR TOTAL: R$ %.2f\033[0m\n\n", total_acumulado); 
    printf("\033[1;31m ================================================================================\033[0m\n");
    printf("\t   \033[1;33mAperte qualquer tecla para retornar ao menu principal...\033[0m");
    system("pause > nul");    
   
    *saldo_caixa += total_acumulado; 
    
}


//============================================================== CASE 3: COMPRAR =========================================================================================================

void compra(int *total_produtos, int codigo[MAX], char nome_produto[MAX][30], float preco[MAX], int qt_estoque[MAX])
{
	system("cls");
	
	int cod_pesquisa, qt_compra, achou;		
		
    
    printf("\n\033[1;31m  ===================================\033[0m\033[1;34m REGISTRAR COMPRA \033[0m\033[1;31m==============================\033[0m\n");
	
    printf("\n\033[1;32m\ CODIGO DO PRODUTO ... : ");	
    scanf("%d", &cod_pesquisa);	
			
	achou = 0; // Variável de controle (0 = não encontrado, 1 = encontrado)
    
    system("cls");
    for(int i = 1; i < *total_produtos; i++)
    {
    	if(cod_pesquisa == codigo[i]) 
        {
        	achou = 1; // Marca que o produto existe no sistema
        
            printf("\n\033[1;31m ================================================================================\033[0m\n");
            printf("\033[1;31m                               \033[0m\033[1;34mPRODUTO ENCONTRADO \033[0m                              \033[1;31m\033[0m\n");
            printf("\033[1;31m ================================================================================\033[0m\n");
            printf("\033[1;32m\t%-20s \t%-10s \t%-12s \t%-10s\033[0m\n", "NOME DO PRODUTO", "CODIGO", "PRECO", "ESTOQUE");     
            printf("\033[1;33m --------------------------------------------------------------------------------\033[0m\n");
            printf("\t%-20s \t#%03d      \tR$ %-10.2f \t%d Un\n", nome_produto[i], codigo[i], preco[i], qt_estoque[i]);    
            printf("\033[1;31m ================================================================================\033[0m\n");
			            
			printf("\n\033[1;32m\ DIGITE A QUANTIDADE PARA COMPRAR ... : ");   
            scanf("%d", &qt_compra);
            			 
            printf(" DIGITE O PRECO DO PRODUTO .......... : R$ ");	
            scanf("%f", &preco[i]);
			qt_estoque[i] += qt_compra; 
               				 
            printf("\n\n");
            printf("\033[1;31m ================================================================================\033[0m\n");
       		printf("\033[1;32m                                 [SUCESSO]\033[0m\n"); 
        	printf("\033[1;31m ================================================================================\033[0m\n");
        	Sleep(2000); 
        }  
    }
        
    
    
	if(achou == 0) // Se o loop terminou e a variável 'achou' continuar em 0, significa que rodou tudo e não existia
    {
        printf("\n\n\n\n\n\n");
		printf("\033[1;31m              ================================================================================\033[0m\n");
        printf("\033[1;32m                           [AVISO] PRODUTO NAO ENCONTRADO NO SISTEMA!\033[0m\n"); 
        printf("\033[1;31m              ================================================================================\033[0m\n");
        Sleep(2000); 
    }  
}



//============================================================== CASE 4: CAIXA ===============================================================================================================
void caixa(int *total_produtos, int codigo[MAX], char nome_produto[MAX][30], float preco[MAX], int qt_estoque[MAX], float *saldo_caixa, float *cofre )
{
    system("cls");
    
    int menu;
    
    if(*saldo_caixa <= 0)
    {
        printf("\n\n\n\n\n\n");
		printf("\t\033[1;31m ====================================================================\033[0m\n\n");
		printf("\t\033[1;32m         [AVISO] Nenhuma venda foi realizada neste dia. \033[0m\n\n");
        printf("\t\033[1;31m=====================================================================\033[0m\n\n");
	    Sleep(2000);
	}
    else
    {
    	printf("\n\t\033[1;31m==================================\033[0m\033[1;34m CAIXA \033[0m\033[1;31m============================\033[0m\n");
        printf("\t\t\t \033[1;33mVALOR TOTAL ACUMULADO EM VENDAS:\033[0m\033[1;32m R$ %.2f\033[0m\n", *saldo_caixa);                    
        printf("\t\033[1;31m=====================================================================\033[0m\n\n");
		
		
		printf("\n\t\t\033[1;31m GOSTARIA DE FECHAR O CAIXA DO DIA ?\033[0m \033[1;32m[1-SIM / 2-NAO] -> \033[0m");
        scanf("%d",&menu);
	    
		if(menu == 1) 
        {
    		*cofre += *saldo_caixa;
            *saldo_caixa = 0; // Zera o caixa atual após mover para o cofre
    	
    	system("cls");
    	printf("\n\n\n\n\n\n");
		printf("\033[1;31m              ================================================================================\033[0m\n");
        printf("\033[1;32m                             [AVISO] SALVANDO INFORMACOES NO SERVIDOR! \033[0m\n"); 
        printf("\033[1;31m              ================================================================================\033[0m\n");
        Sleep(2000); 
		 
        }
    }
}


//============================================================== CASE 5: COFRE ===============================================================================================================
void cofre_caixa(float *cofre, float *saldo_caixa, char user_login[30], char data[20], char hora[20], int *qt_deposito,int conta[HISTORY], int agencia[HISTORY], float historico_valor_deposito[HISTORY],char data_deposito[HISTORY][20], char hora_deposito[HISTORY][20], char historico_user_login[HISTORY][30])
{
    
    int menu;
	float valor_deposito;
	

	system("cls");
	do 
	{         
        system("cls");         
        printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");         
        printf("\t\033[1;34m °°\033[1;32m   [1]\033[0m - NOVO DEPOSITO\033[1;32m  [2]\033[0m - HISTORICO BANCARIO\033[1;32m  [3]\033[0m - SALDO DO COFRE \033[1;32m  [0]\033[0m - SAIR  \033[1;34m  °° \n");         
        printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");    
       	printf("\t\033[1;32m   >  " );
    	scanf("%d", &menu);
        switch(menu)
    	{
        	
        	case 1:
        	system("cls");         
             //deposito_bancario(saldo_caixa, cofre);
           	printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");         
        	printf("\t\033[1;34m °°\033[1;32m   [1] - \033[0m\033[1;42mNOVO DEPOSITO\033[0m  [2]\033[0m - HISTORICO BANCARIO\033[0m  [3]\033[0m - SALDO DO COFRE \033[0m  [0]\033[0m - SAIR  \033[1;34m  °° \n");         
        	printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");   
			printf("\n\033[1;31m ================================================================================\033[0m\n");
    		printf("\033[1;31m                              \033[0m\033[1;34m DEPOSITO / MOVIMENTACAO FINANCEIRA \033[0m                      \033[1;31m\033[0m\n");
    		printf("\033[1;31m ================================================================================\033[0m\n");
    		printf("\t\033[1;33m  SALDO ATUAL DO CAIXA : \033[1;32mR$ %.2f \033[0m\n", *saldo_caixa);
    		printf("\t\033[1;33m  SALDO ATUAL DO COFRE : \033[1;32mR$ %.2f \033[0m\n", *cofre);
    		printf("\033[1;31m ================================================================================\033[0m\n\n");

    		printf("\t[1] - DEPOSITAR DO CAIXA PARA O COFRE\n");
    		printf("\t[2] - DEPOSITAR DO COFRE PARA O BANCO\n");
    		printf("\t[0] - VOLTAR AO MENU PRINCIPAL\n");
    				
			printf("\t \033[1;32m  >  " );
    		scanf("%d", &menu);

    		switch(menu)
    		{
        		case 1:
            		system("cls");
            		printf("\n\t\033[1;34m[MOVIMENTACAO] TRANSFERIR DO CAIXA PARA O COFRE\033[0m\n\n");
            		printf("\tQuanto deseja transferir? (Saldo Maximo: R$ %.2f) -> R$ ", *saldo_caixa);
            		scanf("%f", &valor_deposito);
					
            
            		if	((valor_deposito > 0 ) && (valor_deposito <= *saldo_caixa))
            		{
                		*saldo_caixa -= valor_deposito; 
   						*cofre += valor_deposito;      
						               			
						
						system("cls");
                		printf("\n\n\n\n\n\n");
                		printf("\033[1;31m      ================================================================================\033[0m\n");
                		printf("  \033[1;32m                      [SUCESSO] Transferencia realizada com sucesso!\033[0m\n");
                		printf("  \033[1;34m                      Novo Saldo do Cofre: R$ %.2f\033[0m\n", *cofre);
                		printf("\033[1;31m      ================================================================================\033[0m\n\n");
            			
					}	
            		else
           			{
                		printf("\n\t\033[1;31m[ERRO] Saldo insuficiente no caixa ou valor inválido!\033[0m\n");
            		}
            	Sleep(2500);
            	break;

        		case 2: // Submenu: Depósito Externo (Cofre para o Banco)
    system("cls");
    printf("\n\t\033[1;34m[DEPOSITO] COFRE PARA O BANCO : SALDO : %.2f\033[0m\n\n", *cofre);
    printf("\tDigite o valor do deposito externo -> R$ ");
    scanf("%f", &valor_deposito);

    if ((valor_deposito > 0) && (valor_deposito <= *cofre))
    {
        system("cls");

        printf("\n\t VALOR DO DEPOSITO ... : R$ %.2f", valor_deposito);
        printf("\n\t NUMERO DA CONTA ..... : ");
        scanf("%d", &conta[*qt_deposito]); 
        printf("\t NUMERO DA AGENCIA ... : ");
        scanf("%d", &agencia[*qt_deposito]); 
        
        data_hora(data, hora);
        
		historico_valor_deposito[*qt_deposito] = valor_deposito;
        *cofre -= valor_deposito;
        strcpy(historico_user_login[*qt_deposito], user_login);
        strcpy(data_deposito[*qt_deposito], data);
        strcpy(hora_deposito[*qt_deposito], hora);
        
        
        (*qt_deposito)++; 

        printf("\n\n\n\n\n\n");
        printf("\033[1;31m      ================================================================================\033[0m\n");
        printf("  \033[1;32m                      [SUCESSO] Deposito externo computado com sucesso!\033[0m\n");
        printf("  \033[1;34m                      Novo Saldo do Cofre: R$ %.2f\033[0m\n", *cofre);
        printf("\033[1;31m      ================================================================================\033[0m\n\n");
        	salvar_cofre(cofre, saldo_caixa, qt_deposito,conta, agencia, historico_valor_deposito, data_deposito, hora_deposito, historico_user_login);
	
        break;
    }
    else
    {
        printf("\n\t\033[1;31m[ERRO] Valor de deposito inválido!\033[0m\n");
    }
    Sleep(2500);
    break;

case 0:
    return; // Retorna ao menu anterior imediatamente
    break;

default:
    printf("\n\t\033[1;31m[AVISO] Opcao invalida!\033[0m\n");
    Sleep(2500);
    break;
} // Final do segundo switch deposito
break; // Final correto do case 1 do switch principal

case 2: // Menu Principal: Histórico de Depósitos
    system("cls");         
    
    printf("\033[1;31m  ===============================================================================================================\n");
    printf(" \033[1;34m                                             HISTORICO DE DEPOSITOS                                           \n");
    printf("\033[1;31m  ===============================================================================================================\n");
    printf("\033[1;32m  %-5s %-12s %-10s %-15s %-10s %-15s %-20s\n", "QT", "DATA", "HORAS", "N. CONTA", "AGENCIA", "VALOR DEPOSITO", "USUARIO");     
    printf("\033[1;33m  ---------------------------------------------------------------------------------------------------------------\n"); 

    
    for(int i = 1; i < *qt_deposito; i++)     
    {
        printf("\033[0m  %-5d %-12s %-10s %-15d %-10d R$ %-12.2f %-20s\n",
               i ,                      
               data_deposito[i],                
               hora_deposito[i],                   
               conta[i],                   
               agencia[i],                 
               historico_valor_deposito[i],
               historico_user_login[i]);   
   
        printf("\033[1;33m  ---------------------------------------------------------------------------------------------------------------\n");
    }

    printf("\033[1;31m  ===============================================================================================================\n\033[0m"); 
    printf("\n\t\033[1;33m  Pressione ENTER para voltar ao menu...\033[0m");
    system("pause > nul");
    break;

	case 3:
        	system("cls");         
        	printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");         
        	printf("\t\033[1;34m °°\033[0m   [1]\033[0m - NOVO DEPOSITO\033[0m  [2]\033[0m - HISTORICO BANCARIO\033[1;32m  [3] - \033[0m\033[1;42mSALDO DO COFRE\033[0m   [0]\033[0m - SAIR  \033[1;34m  °° \n");         
        	printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n"); 
			printf("\n");
    		printf("\n\t\t\t\033[1;32m=====================================================\033[0m\n");
    		printf("\t\t\t\t\t   \033[1;34mSALDO DO COFRE                    \n");
    		printf("\t\t\t\033[1;32m=====================================================\033[0m\n\n");
    		printf("\t\t\t\tVALOR TOTAL RETIDO: \033[1;32mR$ %.2f\033[0m REAIS\n\n", *cofre);
    		printf("\t\t\t\033[1;32m=====================================================\033[0m\n\t");
    		printf("\t\t\t\033[1;33mPressione ENTER para voltar ao menu...\033[0m");
      
    		system("pause > nul"); 
			
				
   	break;	
		
		}//final do swtch 1 principal
      
     }
	 while(menu !=0);   

   
}

//=============================================================== CASE 6: ESTOQUE =========================================================================================================
void consulta(int *total_produtos, int codigo[MAX], char nome_produto[MAX][30], float preco[MAX], int qt_estoque[MAX]) 
{
	 system("cls");
    
	 
    printf("\033[1;31m  ===================================\033[0m\033[1;34m CONSULTA ESTOQUE \033[0m\033[1;31m==============================\033[0m\n");
	printf("\t\033[1;32m%-20s \t%-10s \t%-12s \t%-10s\033[0m \n", "NOME DO PRODUTO", "CODIGO", "PRECO", "ESTOQUE");     
    printf("\033[1;31m  ===================================================================================\033[0m\n"); 
        
    if (*total_produtos > 1)
    {
        
        for (int i = 1; i < *total_produtos; i++)	
        {
           
            printf("\t%-20s \t#%03d      \tR$ %-10.2f \t%d Un\n", nome_produto[i], codigo[i], preco[i], qt_estoque[i]);	
            printf("\033[1;33m     ---------------------------------------------------------------------\033[0m\n");
        
		}
    }
    else
    {
        printf("\n\n\n\n\n\t\t\t    NAO HA PRODUTOS CADASTRADOS\n\n\n\n\n\n\n\a");    
        printf("================================================================================\n");
    }
   
   	printf("\t\033[1;33m            Pressione ENTER para voltar ao menu...\033[0m");
    system("pause > nul");
}




//=========================================================== CASE 7: PESQUISAR ===============================================================================================================
void pesquisa(int *total_produtos, int codigo[MAX], char nome_produto[MAX][30], float preco[MAX], int qt_estoque[MAX])
{
    int achou, pesquisa = -1; // Inicializa com -1 para entrar no loop sem conflitar com o 0 de sair
    
    while(pesquisa != 0)
    {
        system("cls");
        printf("\n\n");
        printf("\033[1;31m  ===================================\033[0m\033[1;34m PESQUISAR CODIGO \033[0m\033[1;31m==============================\033[0m\n");
        printf("\t\033[1;32m%-20s \t%-10s \t  %-12s\t%-10s\033[0m \n", "NOME DO PRODUTO", "CODIGO", "PRECO", "ESTOQUE");     
        printf("\033[1;31m  ===================================================================================\033[0m\n\n"); 
        
        achou = 0; // Resetado a cada nova busca

        
        if (pesquisa == -1) // Se for a primeira execução (pesquisa == -1), pede para digitar
        {
            printf("\033[1;32m\t\t\t\tDIGITE O CODIGO DO PRODUTO   \033[0m\n\n");
        } 
        else 
        {
            for(int i = 1; i <= *total_produtos; i++)// Busca o produto no array
            {   
                if((pesquisa == codigo[i]) && (codigo[i] > 0))
                {
                    printf("\t%-20s \t#%03d      \tR$ %-10.2f \t%d Un\n", nome_produto[i], codigo[i], preco[i], qt_estoque[i]); 
                    printf("  \n");
                    achou = 1;
                    break; // Para o loop pois já encontrou o produto único
                }       
            }
           
            if (achou == 0) 
            {
                printf("\033[1;31m\t\t\t\t     CODIGO INVALIDO  \033[0m\n\n\a"); 
            }
        }
        
        printf("\033[1;31m  ===================================================================================\033[0m\n");   
        printf("\033[1;33m\t                   [0] \033[0m DIGITE ZERO PARA SAIR DA CONSULTA\n");   
        printf("\033[1;31m  ===================================================================================\033[0m\n");   
        printf("\033[1;33m  CODIGO DO PRODUTO ->\033[0m "); 
        scanf("%d", &pesquisa); 
    }
}


//=========================================================== CASE 8: REUTILIZAR CODIGO ZERADO ===============================================================================================================
void codigo_zerado(int *total_produtos, int codigo[MAX], char nome_produto[MAX][30], float preco[MAX], int qt_estoque[MAX])
{
    system("cls");	
    
    int achou = 0, menu, novo_codigo;
	
	printf("\n\n");
   	printf("\033[1;31m  ===================================\033[0m\033[1;34m PESQUISAR CODIGO \033[0m\033[1;31m==============================\033[0m\n");
	printf("\t\033[1;32m%-20s \t%-10s \t  %-12s\t%-10s\033[0m \n", "NOME DO PRODUTO", "CODIGO", "PRECO", "ESTOQUE");     
    printf("\033[1;31m  ===================================================================================\033[0m\n\n"); 
                	    		    
    for(int i = 1; i <= *total_produtos; i++) 
    {
        if ((qt_estoque[i] == 0) && (codigo[i] >  0))
        {
            printf("\t%-20s \t#%03d      \tR$ %-10.2f \t%d Un\n", nome_produto[i], codigo[i], preco[i], qt_estoque[i]);	
            printf("\033[1;33m     ---------------------------------------------------------------------\033[0m\n");
            achou = 1; 
        }    	
    }
	
    if (achou == 0)
    {
    	system("cls");
    	
		printf("\n\n\t\033[1;34m°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°\033[0m\n");
    	printf("\t\033[1;34m°°\033[0m                           \033[1;33mALERTA DO SISTEMA\033[0m                          \033[1;34m°°\033[0m\n");
    	printf("\t\033[1;34m°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°\033[0m\n");
    	printf("\t\033[1;34m°°                                                                      °°\033[0m\n");
    	printf("\t\033[1;34m°°             \033[1;31m[!]\033[0m  \033[1;33m NAO HA PRODUTOS COM ESTOQUE ZERADO\033[0m \033[1;31m   [!]\033[0m          \033[1;34m°°\033[0m\n");
    	printf("\t\033[1;34m°°                                                                      °°\033[0m\n");
    	printf("\t\033[1;34m°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°\033[0m\n");

        system("pause > nul");
        return; 
    }

    
    printf("\n\t\t\033[1;32m\033[0m                 \033[1;33mAVISO DO SISTEMA\033[0m   \n");
  
    printf("\t\t         \033[1;31m[!]\033[1;32m REUTILIZAR CODIGO ZERADO \033[1;31m[!]\033[0m       \n");
    printf("\t\t  \033[1;32m  O ITEM ANTIGO SERA APAGADO PERMANENTEMENTE \n");
    
    printf("\n\t\t\033[1;31m   REUTILIZAR CODIGO ZERADO? [1-SIM / 2-NAO] -> \033[0m\033[1;32m");
    scanf("%d", &menu);
	 
    if (menu == 1) 
    {
        system("cls");
        printf("\n\n");
   		printf("\033[1;31m  ===================================\033[0m\033[1;34m PESQUISAR CODIGO \033[0m\033[1;31m==============================\033[0m\n");
		printf("\t\033[1;32m%-20s \t%-10s \t  %-12s\t%-10s\033[0m \n", "NOME DO PRODUTO", "CODIGO", "PRECO", "ESTOQUE");     
    	printf("\033[1;31m  ===================================================================================\033[0m\n\n"); 
                	    		    
    	for(int i = 1; i <= *total_produtos; i++) 
    	{
        	if ((qt_estoque[i] == 0) && (codigo[i] >  0))
        	{
            	printf("\t%-20s \t#%03d      \tR$ %-10.2f \t%d Un\n", nome_produto[i], codigo[i], preco[i], qt_estoque[i]);	
            	printf("\033[1;33m     ---------------------------------------------------------------------\033[0m\n");
            	achou = 1; 
        	}	    	
    	}	 
        
		printf("\n\033[1;32m CODIGO DO PRODUTO QUE DESEJA REUTILIZAR ... : ");
        scanf("%d", &novo_codigo);
                     
        int indice_encontrado = -1;
       
        for(int i = 1; i <= *total_produtos; i++) // 1. O laço serve APENAS para buscar a posição correta no vetor
        {
            if((codigo[i] == novo_codigo) && (qt_estoque[i] == 0) && (novo_codigo > 0))
            {
                indice_encontrado = i;
                break; 
            }
        }
        
        if (indice_encontrado != -1) // 2. A validação do resultado da busca e inserção de dados ocorre FORA do laço
        {
            
			printf(" DIGITE O NOVO NOME DO PRODUTO ............. : ");    
            scanf("%29s", nome_produto[indice_encontrado]); 

            printf(" DIGITE O NOVO PRECO DO PRODUTO ............ : R$ ");    
            scanf("%f", &preco[indice_encontrado]);
     
            printf(" DIGITE A NOVA QUANTIDADE EM ESTOQUE ....... : ");    
            scanf("%d", &qt_estoque[indice_encontrado]); 
            
        printf("\n\n");
		printf("\033[1;31m ================================================================================\033[0m\n");
        printf("\033[1;32m               [OK] Codigo \033[1;34m #%03d \033[0m \033[1;32m reaproveitado com sucesso!\033[0m\n", novo_codigo);
        printf("\033[1;31m ================================================================================\033[0m\n");
        Sleep(2000); 
		
        }
        else
        {
            system("cls");
    		printf("\n\n\t\033[1;34m°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°\033[0m\n");
    		printf("\t\033[1;34m°°\033[0m                           \033[1;33mALERTA DO SISTEMA\033[0m                          \033[1;34m°°\033[0m\n");
    		printf("\t\033[1;34m°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°\033[0m\n");
    		printf("\t\033[1;34m°°                                                                      °°\033[0m\n");
    		printf("\t\033[1;34m°° \033[1;31m             [!]\033[0m \033[1;33m [ERRO] Codigo invalido ou o produto                \033[1;34m°°\033[0m\n");
    		printf("\t\033[1;34m°° \033[1;33m          selecionado nao possui estoque zerado! \033[0m \033[1;31m [!]\033[0m       \033[1;34m°°\033[0m\n");
			printf("\t\033[1;34m°°                                                                      °°\033[0m\n");
    		printf("\t\033[1;34m°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°\033[0m\n");

			printf("\t\033[1;33m                               Pressione ENTER para voltar ao menu...\033[0m");
            system("pause > nul");
        }
    }
}




//========================================================== CASE 9: CONSULTA FINANCEIRA ===============================================================================================================
void consulta_financeira(int *total_produtos, int codigo[MAX], char nome_produto[MAX][30], float preco[MAX], int qt_estoque[MAX]) 
{
	system("cls");
     
    float valor_produto, valor_total_estoque;
               
    printf("\033[1;31m================================================\033[0m\033[1;34m CONSULTA FINANCEIRA \033[0m\033[1;31m==========================================\033[0m\n");
    printf("\t\033[1;32m%-20s \t%-10s \t%-12s \t%-10s \t%-15s\n\033[0m", "NOME DO PRODUTO", "CODIGO", "PRECO", "ESTOQUE", "VALOR INVESTIDO");     
    printf("\033[1;31m===============================================================================================================\033[0m\n"); 

	for(int i = 1; i < *total_produtos ; i++)	 
	{
        valor_produto = qt_estoque[i] * preco[i];
        valor_total_estoque += valor_produto;

        printf("\t%-20s \t#%03d      \tR$ %-10.2f \t%d Un     \tR$ %.2f\n", nome_produto[i], codigo[i], preco[i], qt_estoque[i], valor_produto);	
        printf("\033[1;33m    ------------------------------------------------------------------------------------------\033[0m\n");
    }    
        printf("\n");
        
		printf("\t           VALOR TOTAL DO ESTOQUE ACUMULADO NO SISTEMA: \033[1;32mR$ %.2f\033[0m  \n\n", valor_total_estoque);
        printf("\033[1;31m===============================================================================================================\033[0m\n"); 
        printf("\t\033[1;33m                  Pressione ENTER para voltar ao menu...\033[0m");
        system("pause > nul");
}




//================================================================ CASE10 : USER ==============================================================================================
void cadastrar_usuario(int *cont, char user[USUARIOS][30], int senha[USUARIOS], int ID[USUARIOS], int permissao[USUARIOS][PERMISSAO], char *user_login ) 
{     
  
	int menu, id, senha1 = 0, senha2 = 1, primeira_tentativa = 1, usuario_encontrado = 0, confirmar_salvar = 0, permissao_2[PERMISSAO], indice_alvo; 
    char user_novo[30];
                
	do 
	{         
        system("cls");         
        printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");         
        printf("\t\033[1;34m °°\033[1;32m   [1]\033[0m - NOVO USUARIO\033[1;32m  [2]\033[0m - EDITAR USUARIO\033[1;32m  [3]\033[0m - TODOS USUARIOS \033[1;32m  [0]\033[0m - SAIR  \033[1;34m  °° \n");         
        printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");    
       	printf("\t\033[1;33m  >  ");         
        scanf("%d", &menu);                  
        
        switch(menu) 
        {
    
			case 1: // CADASTRAR NOVO USUARIO
          
			if (*cont >= USUARIOS+1) 
    		{                     
        		system("cls");
        		printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");         
        		printf("\t\033[1;34m °°\033[1;32m  [1] - \033[0m\033[1;42m NOVO USUARIO \033[0m  [2]\033[0m - EDITAR USUARIO\033[0m  [3]\033[0m - TODOS USUARIOS \033[0m  [0]\033[0m - SAIR  \033[1;34m °° \n");         
        		printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");   
        		printf("\n\t \033[1;31m[AVISO] Limite maximo de %d usuarios atingido!\033[0m\n", USUARIOS);                     
        		Sleep(2000);                   
        		break; // Sai do case e volta para o menu                
    		}                  
    		else
    		{
        		system("cls");
        		printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");         
        		printf("\t\033[1;34m °°\033[1;32m  [1] - \033[0m\033[1;42m NOVO USUARIO \033[0m  [2]\033[0m - EDITAR USUARIO\033[0m  [3]\033[0m - TODOS USUARIOS \033[0m  [0]\033[0m - SAIR  \033[1;34m °° \n");         
        		printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");   
             	printf("\n\t\033[1;34m ID GERADO ...... :\033[0m [\033[1;32m # %d \033[0m]", *cont);                   				
        		printf("\n\t\033[1;34m NOVO USUARIO ... :\033[1;32m ");                 
        		scanf("%29s", user[*cont]);                 
        
        		do
        		{
            		primeira_tentativa = 1;
           	 		printf("\t\033[1;34m SENHA ............ : \033[0m");                 
            		printf("\033[30m"); // Oculta o texto digitado na tela
            		scanf("%d", &senha1);     			
            		printf("\033[0m");  

            		printf("\t\033[1;34m REPITA A SENHA ... : \033[0m");                 
            		printf("\033[30m"); // Oculta o texto digitado na tela
            		scanf("%d", &senha2);     			
            		printf("\033[0m");          
          
            		if (senha1 != senha2)  
            		{		
                		primeira_tentativa = 0;
                		printf("\n\t\033[1;31m[ERRO]\033[1;33m As senhas nao coincidem! Tente novamente.\033[0m\n\n");
           			}
                        
        		} 
				while(senha1 != senha2);
        
        		senha[*cont] = senha1;  
        		printf("\n\t\033[1;32m[SUCESSO] Senha confirmada e salva!\033[0m\n");
                    
       			printf("\n\t\033[1;33m            PERMISSOES: \033[0m\n\n");     			
        		printf("\t\033[1;34m Cadastrar? ........ NAO [0]  SIM [1] > \033[1;32m ");    				
        		scanf("%d", &permissao[*cont][0]);          				
      			printf("\t\033[1;34m Venda? ............ NAO [0]  SIM [1] > \033[1;32m ");     			
        		scanf("%d", &permissao[*cont][1]);           			
        		printf("\t\033[1;34m Comprar? .......... NAO [0]  SIM [1] > \033[1;32m ");     			
        		scanf("%d", &permissao[*cont][2]);  				 				
        		printf("\t\033[1;34m Caixa? ............ NAO [0]  SIM [1] > \033[1;32m ");     			
        		scanf("%d", &permissao[*cont][3]);      			     			
        		printf("\t\033[1;34m Cofre? ............ NAO [0]  SIM [1] > \033[1;32m ");     			
        		scanf("%d", &permissao[*cont][4]);      			     			
        		printf("\t\033[1;34m Estoque? .......... NAO [0]  SIM [1] > \033[1;32m ");     			
        		scanf("%d", &permissao[*cont][5]);      			     			
        		printf("\t\033[1;34m Pesquisar? ........ NAO [0]  SIM [1] > \033[1;32m ");     			
        		scanf("%d", &permissao[*cont][6]);  				 				
        		printf("\t\033[1;34m Editar Produto? ... NAO [0]  SIM [1] > \033[1;32m ");     			
        		scanf("%d", &permissao[*cont][7]);      			     			
        		printf("\t\033[1;34m Relatorio? ........ NAO [0]  SIM [1] > \033[1;32m ");     			
        		scanf("%d", &permissao[*cont][8]);    			 				
        		printf("\t\033[1;34m Usuario? .......... NAO [0]  SIM [1] > \033[1;32m ");     			
        		scanf("%d", &permissao[*cont][9]);    			 
                        
        		ID[*cont] = *cont;                  
                (*cont)++;      
        		salvar_user(cont, user, senha, ID, permissao);
        
        		printf("\n\t\033[1;32m[SUCESSO] Usuario criado e salvo com sucesso no banco de dados!\033[0m\n");
        		Sleep(2000);
    		}
			break;

                
            case 2://case 1 editar usuario
            do
            {
            	system("cls");         
        		printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");            
        		printf("\t\033[1;34m °°\033[1;32m   [1]\033[0m - TROCAR SENHA\033[1;32m  [2]\033[0m - EDITAR PERMISSAO\033[1;32m   [3]\033[0m - EDITAR USUARIOS \033[1;32m  [4]\033[0m - DELETAR USUARIO \033[1;34m °° \n");         
        		printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");        
        		printf("\t\033[1;33m  >  ");         
        		scanf("%d", &menu);          	
            	
				switch(menu)
            	{
            		case 1: //case 1 (editar usuario) -> case 1 (trocar senha)
            			system("cls");         
        				printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");           
        				printf("\t\033[1;34m °°\033[1;32m   [1] - \033[0m\033[1;42m TROCAR SENHA \033[0m  [2]\033[0m - EDITAR PERMISSAO\033[0m  [3]\033[0m - EDITAR USUARIO \033[0m  [4]\033[0m - DELETAR USUARIO \033[1;34m °° \n");         
        				printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");        
						printf("\n\t\033[1;34m ID ................ :\033[1;32m ");                   				
                		scanf("%d",&id);
							
						for(int i = 0; i < *cont; i++)
						{
   							if(id == ID[i])
    						{
        						usuario_encontrado = 1;
        						indice_alvo = i; // Guarda o ÍNDICE (a linha física da matriz)
        						break;           // Encontrou! Para o laço imediatamente
   								}
							}

						
							
							if ((usuario_encontrado == 1) || (id == 0 ))
							{
    							
	  							if ((id == 1000) || (id == 0))
   								{
        							indice_alvo = 0;
        							system("cls");         
                					printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");           
        							printf("\t\033[1;34m °°\033[1;32m   [1] - \033[0m\033[1;42m TROCAR SENHA \033[0m  [2]\033[0m - EDITAR PERMISSAO\033[0m  [3]\033[0m - EDITAR USUARIO \033[0m  [4]\033[0m - DELETAR USUARIO \033[1;34m °° \n");         
        							printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");           
                					printf("\n\t\033[1;34m ID ............. :\033[0m [\033[1;32m # %d \033[0m]", indice_alvo);                   				
                					printf("\n\t\033[1;34m USUARIO ........ :\033[1;32m %s \n",user[indice_alvo]);
    												
								
								}
    							else
    							{
        							system("cls");         
                					printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");           
        							printf("\t\033[1;34m °°\033[1;32m   [1] - \033[0m\033[1;42m TROCAR SENHA \033[0m  [2]\033[0m - EDITAR PERMISSAO\033[0m  [3]\033[0m - EDITAR USUARIO \033[0m  [4]\033[0m - DELETAR USUARIO \033[1;34m °° \n");         
        							printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");           
                					printf("\n\t\033[1;34m ID ............. :\033[0m [\033[1;32m # %d \033[0m]", indice_alvo);                   				
                					printf("\n\t\033[1;34m USUARIO ........ :\033[1;32m %s \n",user[indice_alvo]);
									do
   			    					{	        
        								if (!primeira_tentativa)
        								{		
            								printf("\n\t\033[1;31m[ERRO]\033[1;33m As senhas nao coincidem! Tente novamente.\033[0m\n\n");
        								}
        		
											primeira_tentativa = 0; // Próximas voltas exibirão o erro

       										printf("\t\033[1;34m SENHA ............ : \033[0m");                 
        									printf("\033[30m"); // Oculta a digitação
       										scanf("%d", &senha1);     			
        									printf("\033[0m");  

        									printf("\t\033[1;34m REPITA A SENHA ... : \033[0m");                 
        									printf("\033[30m"); // Oculta a digitação
        									scanf("%d", &senha2);     			
        									printf("\033[0m");          

    								}		 
									while(senha1 != senha2); 
									
									printf("\n\t\033[1;34m GOSTARIA SALVAR ?\033[1;33m [1-SIM / 2-NAO] -> \033[0m\033[1;32m");
                        			scanf("%d", &confirmar_salvar);	
								
									if((confirmar_salvar == 1) && (senha1 == senha2 ))
									{
									
										senha[id] = senha1;
										salvar_user(cont, user, senha, ID, permissao);	
										printf("\n\t\033[1;32m[SUCESSO] Senha salva!\033[0m\n");
									}
									else
                					{
                						printf("\n\t\033[1;33m[AVISO] Operacao cancelada. O usuario %s nao foi editado....\033[0m\n",user[id]);
									}
							       						
    							}
							}
							else
							{
    							printf("\n\t\033[1;33m[AVISO] Usuario nao existe no sistema.\033[0m\n");
    						}
																
					Sleep(2000);
					
					break;	
            			
            		case 2://case 1 (editar usuario) -> case 2 (editar permissao)
            			
						system("cls");         
        				printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");             
        				printf("\t\033[1;34m °°\033[0m  [1]\033[0m - TROCAR SENHA\033[1;32m  [2] - \033[0m\033[1;42m EDITAR PERMISSAO \033[0m  [3]\033[0m - EDITAR USUARIOS \033[0m  [4]\033[0m - DELETAR USUARIO \033[1;34m °° \n");         
        				printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");        
						printf("\n\t\033[1;34m ID ................ :\033[1;32m ");                   				
                		scanf("%d",&id);
							
						if ((id == 0) || (id == 1000)) 
						{
							printf("\n\t\033[1;31m[ATENCAO]\033[1;33m O usuario\033[0m [\033[1;32m root \033[0m]\033[1;33m nao pode ser editado\n");
							printf("\n\t\033[1;32mPressione ENTER para voltar ao menu...\033[0m");
							system("pause>nul");	
														
						}
						else
						{
							for(int i = 0; i< *cont; i++)
							{
								if(id == ID[i])
								{
									usuario_encontrado = 1;
						       	}
							}
								
							if(usuario_encontrado == 1) 
							{	
								system("cls");
								printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");             
        						printf("\t\033[1;34m °°\033[0m  [1]\033[0m - TROCAR SENHA\033[1;32m  [2] - \033[0m\033[1;42m EDITAR PERMISSAO \033[0m  [3]\033[0m - EDITAR USUARIOS \033[0m  [4]\033[0m - DELETAR USUARIO \033[1;34m °° \n");         
        						printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");
								printf("\n\t\033[1;34m ID ........ :\033[1;32m %d",id);
								printf("\n\t\033[1;34m USUARIO ... :\033[1;32m %s \n", user[id]); 
									
								printf("\n\t\033[1;33m            PERMISSOES: \033[0m\n\n");     			
                                printf("\t\033[1;34m Cadastrar? ........ NAO [0]  SIM [1] > \033[1;32m ");    				
                                scanf("%d", &permissao_2[0]);          				
                                printf("\t\033[1;34m Venda? ............ NAO [0]  SIM [1] > \033[1;32m ");     			
                                scanf("%d", &permissao_2[1]);           			
                                printf("\t\033[1;34m Comprar? .......... NAO [0]  SIM [1] > \033[1;32m ");     			
                                scanf("%d", &permissao_2[2]);  				 				
                                printf("\t\033[1;34m caixa? ............ NAO [0]  SIM [1] > \033[1;32m ");     			
                                scanf("%d", &permissao_2[3]);      			     			
                                printf("\t\033[1;34m cofre? ............ NAO [0]  SIM [1] > \033[1;32m ");     			
                                scanf("%d", &permissao_2[4]);      			     			
                                printf("\t\033[1;34m estoque? .........  NAO [0]  SIM [1] > \033[1;32m ");     			
                                scanf("%d", &permissao_2[5]);      			     			
                                printf("\t\033[1;34m pesquisar? ........ NAO [0]  SIM [1] > \033[1;32m ");     			
                                scanf("%d", &permissao_2[6]);  				 				
                                printf("\t\033[1;34m editar produto? ... NAO [0]  SIM [1] > \033[1;32m ");     			
                                scanf("%d", &permissao_2[7]);      			     			
                                printf("\t\033[1;34m relatorio? ........ NAO [0]  SIM [1] > \033[1;32m ");     			
                                scanf("%d", &permissao_2[8]);    			 				
                                printf("\t\033[1;34m ususario? ......... NAO [0]  SIM [1] > \033[1;32m ");     			
                                scanf("%d", &permissao_2[9]);    			 
                                          
                                printf("\n\t\033[1;32m [SUCESSO] MODIFICACAO REALIZADA!\033[0m\n");
                                printf("\n\t\033[1;34m GOSTARIA DE SALVAR ?\033[1;33m [1-SIM / 2-NAO] -> \033[0m\033[1;32m");
                        		scanf("%d", &confirmar_salvar);	
								if(confirmar_salvar)
								{
									for(int j = 0; j < 10; j++)
									{
										permissao[id][j] = permissao_2[j];
																			
									}
																										
									salvar_user(cont, user, senha, ID, permissao);	
                            		printf("\n\t\033[1;32m[INFO] Dados atualizados no arquivo com sucesso!\033[0m\n");
																
								}
								else
                				{
                					printf("\n\t\033[1;33m[AVISO] Operacao cancelada. O usuario %s nao foi editado....\033[0m\n",user_novo);
								}
							}
                			else
                			{
                				printf("\n\t\033[1;33m [AVISO] Alteracoes descartadas para este usuario.\033[0m\n");
							}	
						
								Sleep(2000);	
							}// final do else do 	if(id == 0)
																		
						   
					break;
					
					case 3://case 1 (editar usuario) -> case 3 (editar nome do user)
					    	
					   	system("cls");         
                		printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");          
        				printf("\t\033[1;34m °°\033[0m  [1]\033[0m - TROCAR SENHA\033[0m  [2]\033[0m - EDITAR PERMISSAO\033[1;32m   [3] - \033[0m\033[1;42m EDITAR USUARIOS \033[0m  [4]\033[0m - DELETAR USUARIO \033[1;34m °° \n");         
        				printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");      
                
                		printf("\n\t\033[1;34m ID ........... :\033[1;32m ");                   				
                		scanf("%d", &id);
								
						if ((id == 0) || (id == 1000))  //nao deixa trocar o nome do root E se a string (strcmp(user[id], "") == 0) está vazia
						{
							printf("\n\t\033[1;31m[ATENCAO]\033[1;33m O usuario\033[0m [\033[1;32m root \033[0m]\033[1;33m nao pode ser editado\n");
							printf("\n\t\033[1;32mPressione ENTER para voltar ao menu...\033[0m");
							system("pause>nul");	
														
						}
						else
						{
							for(int i = 0; i< *cont; i++)
							{
													
								if(id == ID[i])
								{
									usuario_encontrado = 1;
								}
						}
							
							if(usuario_encontrado == 1) 
							{	
											
								system("cls");         
                				printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");          
        						printf("\t\033[1;34m °°\033[0m  [1]\033[0m - TROCAR SENHA\033[0m  [2]\033[0m - EDITAR PERMISSAO\033[1;32m   [3] - \033[0m\033[1;42m EDITAR USUARIOS \033[0m  [4]\033[0m - DELETAR USUARIO \033[1;34m °° \n");         
        						printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");      
                				printf("\n\t\033[1;34m ID ............. :\033[0m [\033[1;32m # %d \033[0m]", id);                   				
                				printf("\n\t\033[1;34m USUARIO ........ :\033[1;32m %s",user[id]);
								printf("\n\t\033[1;34m NOVO USUARIO ... :\033[1;32m ");                 
                				scanf("%29s", user_novo);                         			    
                				printf("\n\t\033[1;34m GOSTARIA SALVAR ?\033[1;33m [1-SIM / 2-NAO] -> \033[0m\033[1;32m");
                        		scanf("%d", &confirmar_salvar);	
								if(confirmar_salvar)
								{
									strcpy(user[id], user_novo);
										
									salvar_user(cont, user, senha, ID, permissao);	
                            		printf("\n\t\033[1;32m[INFO] Dados atualizados no arquivo com sucesso!\033[0m\n");
								}
								else
                				{
                					printf("\n\t\033[1;33m[AVISO] Operacao cancelada. O usuario %s nao foi editado....\033[0m\n",user_novo);
								}
						}
                		else
                		{
                			printf("\n\t\033[1;33m[AVISO] Usuario nao existe no sistema....\033[0m\n");
						}	
					
					Sleep(2000);	
					}// final do else do ((id == 0)||(id == 1000))
							
					break;//final do case 3 (editar usuario)	
										
					case 4: // case 1 (editar usuario) -> case 4 (deletar user)
    					
						manutencao();
					
						/*
						system("cls");         
    					printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");         
    					printf("\t\033[1;34m °°\033[0m  [1]\033[0m - TROCAR SENHA\033[0m  [2]\033[0m - EDITAR PERMISSAO  [3]\033[0m - EDITAR USUARIOS \033[1;32m  [4] - \033[0m\033[1;42m DELETAR USUARIO \033[0m \033[1;34m °° \n");         
    					printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");    

    					printf("\n\t\033[1;34m Digite o ID para DELETAR ........... :\033[1;32m ");                   				
    					scanf("%d", &id);

    					if ((id == 0) || (id == 1000))  // Não deixa deletar ou alterar o administrador root 
    					{
        					printf("\n\t\033[1;31m[ATENCAO]\033[1;33m O usuario\033[0m [\033[1;32m root \033[0m]\033[1;33m nao pode ser deletado do sistema!\n");
        					printf("\n\t\033[1;32mPressione ENTER para voltar ao menu...\033[0m");
        					system("pause>nul");	
    					}
    					else
    					{
        
        					usuario_encontrado = 0;
        					indice_alvo = -1; // Guardará em qual linha da matriz o ID foi achado

        					// Percorre os usuários ativos na memória
        					for(int i = 0; i < *cont; i++)
        					{											
            					if(id == ID[i])
            					{
                					usuario_encontrado = 1;
                					indice_alvo = i; // Armazena o índice da linha física
                					break; // Achou, pode parar o laço
           						 }
        					}
        
        					if(usuario_encontrado == 1 && indice_alvo != -1) 
        					{	
            					system("cls");         
            					printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");         
            					printf("\t\033[1;34m °°\033[0m  [1]\033[0m - TROCAR SENHA\033[0m  [2]\033[0m - EDITAR PERMISSAO  [3]\033[0m - EDITAR USUARIOS \033[1;32m  [4] - \033[0m\033[1;42m DELETAR USUARIO \033[0m \033[1;34m °° \n");         
            					printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");    
            
            					// CORREÇÃO 2: Exibe os dados baseados no 'indice_alvo' encontrado, não na variável 'id'
           						printf("\n\t\033[1;34m ID ............. :\033[0m [\033[1;32m # %d \033[0m]", ID[indice_alvo]);                   				
            					printf("\n\t\033[1;34m USUARIO ........ :\033[1;32m %s ", user[indice_alvo]);                 
            					printf("\n\n\t\033[1;31m[ATENCAO] O USUARIO SERA DELETADO DEFINITIVAMENTE ... \033[1;32m \n");   
            					printf("\t\033[1;34mGOSTARIA DE DELETAR ?\033[1;33m [1-SIM / 2-NAO] -> \033[1;32m ");
            					scanf("%d", &confirmar_salvar);	
            
            					if(confirmar_salvar == 1)
            					{
                				// CORREÇÃO 3: Desloca todos os usuários seguintes uma posição para trás
                				// Isso remove o usuário de verdade e evita deixar "buracos" vazios na memória
                					for(int i = indice_alvo; i < (*cont) ; i++)
                					{
                  					 // ID[i] = id+1;
                   					// strcpy(user[i], user[i + 1]);
                    				//senha[i] = senha[i + 1];
                   
										strcpy(user[indice_alvo], "xxx_null_xxx");
                    			
										for(int j = 0; j < PERMISSAO; j++)
                    					{
                        					permissao[indice_alvo][j] = 7;
											//permissao[i][j] = permissao[i + 1][j];
                   				 		}
                					}
                
               						(*cont)--;
                			        salvar_user(cont, user, senha, ID, permissao);	
                					printf("\n\t\033[1;32m[INFO] Usuario deletado e dados atualizados no arquivo com sucesso!\033[0m\n");
            					}
            					else
            					{
                  					printf("\n\t\033[1;33m[AVISO] Operacao cancelada. O usuario %s nao foi deletado.\033[0m\n", user[indice_alvo]);
            					}
        					}
        					else
        					{
            					printf("\n\t\033[1;33m[AVISO] O ID %d nao existe no sistema....\033[0m\n", id);
        					}	

        					Sleep(2000);	
   						} // final do else do ((id == 0)||(id == 1000))
					     */           
                	break;//final do case 4 do segundo switch - deletar usuario
				
				}//final do switch 2
            	            	         		
			}//final do DO do case 2 do primeiro switch
            while(menu =0);           
            
			
			break;//fincal do case 2 do primeiro switch
            			
			case 3:// case 3 do primeiro switch - mostra todos os usuarios
    		
				system("cls");         
        		printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");         
        		printf("\t\033[1;34m °°\033[0m   [1]\033[0m - NOVO USUARIO\033[0m  [2]\033[0m - EDITAR USUARIO\033[1;32m  [3] -\033[0m \033[1;42m TODOS USUARIOS \033[0m  [0]\033[0m - SAIR  \033[1;34m °° \n");         
        		printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n\n");   
				
				printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°\033[0m\n");      		   
				printf("\t\033[1;34m °°\033[1;33m      ID     \033[1;34m°°\033[1;33m           USUARIO             \033[1;34m°°\033[1;33m             PERMISSOES           \033[1;34m°°\033[0m\n");
				printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°1°°2°°3°°4°°5°°6°°7°°8°°9°°10°°°°\033[0m\n");    

				for(int i = 0; i < *cont; i++) 
				{
   				
					   	printf("\t \033[1;34m°°\033[1;36m  \t# %4d  \033[1;34m°°\033[1;36m     \t   %-20s\033[1;34m  °°\033[0m ", ID[i], user[i]);
      					
					    for(int j = 0; j < PERMISSAO; j++) 
    					{
       					
						   	if(permissao[i][j] == 1) printf(" \033[1;32m X\033[0m");
        					else printf(" \033[1;35m O\033[0m");										
  	 					
						   }
   							printf("   \033[1;34m°°\033[0m\n");
    				
					printf("\t \033[1;34m°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°\033[0m\n");  
   				}
    			
								
				system("pause > nul");
			break;

        }     
    } 
	while(menu != 0); 
}

//============================================================== MAIN INICIO ========================================================================================== ======================================
int main()
{
   
        

	char nome_produto[MAX][30],user[10][30],user_login[30],data[20], hora[20], data_deposito[HISTORY][20], hora_deposito[HISTORY][20]; 
    char historico_user_login[HISTORY][30];
	int codigos[MAX], estoques[MAX], total_produtos = 1, menu,senha[10], ID[10], ID_login, permissao[10][10], cont = 1, qt_deposito = 1,conta[HISTORY],agencia[HISTORY] ;
    float precos[MAX], saldo_caixa, cofre, historico_valor_deposito[HISTORY] ;
        
	ping(); 
    
	carregar(&total_produtos, codigos, nome_produto, precos, estoques,&saldo_caixa,&cofre);
    carregar_user(&cont, user, senha, ID, permissao);
	carregar_cofre(&cofre, &saldo_caixa, &qt_deposito,conta,agencia, historico_valor_deposito, data_deposito, hora_deposito, historico_user_login);
	login(&cont, user, senha, ID, permissao, user_login, &ID_login); 	
	 
	do
    {
      	printf("\n\n");	
	  	system("cls"); 
 	  	printf("\n\n\t\033[1;34m°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°\033[0m\n");
		printf("\t\033[1;34m°°\033[0m                  \033[1;33m<<< SISTEMA DE GESTAO EMPRESARIAL >>>\033[0m               \033[1;34m°°\033[0m\n");
		printf("\t\033[1;34m°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°\033[0m\n");
		printf("\t\033[1;34m°°\033[0m                                     \033[1;34m \033[0m                               \033[1;34m °°\033[0m\n");
		printf("\t\033[1;34m°°\033[0m  \033[1;32m[1]\033[0m - CADASTRAR PRODUTOS            \033[1;34m \033[0m  \033[1;32m[6]\033[0m - CONSULTAR ESTOQUE      \033[1;34m°°\033[0m\n");
		printf("\t\033[1;34m°°\033[0m                                     \033[1;34m \033[0m                              \033[1;34m  °°\033[0m\n");
		printf("\t\033[1;34m°°\033[0m  \033[1;32m[2]\033[0m - EFETUAR VENDA                 \033[1;34m \033[0m  \033[1;32m[7]\033[0m - PESQUISAR PRODUTO      \033[1;34m°°\033[0m\n");
		printf("\t\033[1;34m°°\033[0m                                     \033[1;34m \033[0m                               \033[1;34m °°\033[0m\n");
		printf("\t\033[1;34m°°\033[0m  \033[1;32m[3]\033[0m - REGISTRAR COMPRA              \033[1;34m \033[0m  \033[1;32m[8]\033[0m - EDITAR PROTUDO         \033[1;34m°°\033[0m\n");
		printf("\t\033[1;34m°°\033[0m                                     \033[1;34m \033[0m                               \033[1;34m °°\033[0m\n");	
		printf("\t\033[1;34m°°\033[0m  \033[1;32m[4]\033[0m - FECHAMENTO DE CAIXA           \033[1;34m \033[0m  \033[1;32m[9]\033[0m - RELATORIO FINANCEIRO   \033[1;34m°°\033[0m\n");	
		printf("\t\033[1;34m°°\033[0m                                     \033[1;34m \033[0m                               \033[1;34m °°\033[0m\n");
		printf("\t\033[1;34m°°\033[0m  \033[1;32m[5]\033[0m - CONSULTAR COFRE               \033[1;34m \033[0m  \033[1;32m[10]\033[0m - USER                  \033[1;34m°°\033[0m\n");				
		printf("\t\033[1;34m°°\033[0m                                     \033[1;34m \033[0m                               \033[1;34m °°\033[0m\n");
		printf("\t\033[1;34m°°  \033[1;31m[0]\033[0m - SAIR DO SISTEMA               \033[1;34m \033[0m  \033[1;32m[11]\033[0m - LOGOUT                \033[1;34m°°\033[0m\n");				
		printf("\t\033[1;34m°°\033[0m                                     \033[1;34m \033[0m                               \033[1;34m °°\033[0m\n");
		printf("\t\033[1;34m°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°\033[0m\n");
		printf("\t\033[1;34m°° \033[1;33m USER ... :\033[1;32m %-10s      \033[1;34m°°°°°°°°°°°°°°°°°°°°°°°\033[1;34m  Versao :\033[1;32m 8.13.b \033[1;34m°°\033[0m\n",user_login);	
		printf("\t\033[1;34m°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°\033[0m\n");
	
		printf("\t\033[1;32m -> ");
		scanf("%d",&menu);
	    	 
		switch(menu)
		{
		case 1: // CADASTRO DOS PRODUTOS
    
    			if (permissao[ID_login][0] == 1) 
    			{
        			cadastro(&total_produtos, codigos, nome_produto, precos, estoques);
        			salvar_rapido(&total_produtos, codigos, nome_produto, precos, estoques, &saldo_caixa, &cofre);
   			 	}
   			 	else 
    			{
       				printf("\n\t\033[1;31m  [ACESSO NEGADO]\033[1;33m Seu usuario nao tem permissao para cadastrar produtos.\033[0m\n\a");
        			Sleep(2000);
    			}
   			
			break;
        	
			case 2: //VENDA
           		
    			if (permissao[ID_login][1] == 1) 
    			{
        			venda(&total_produtos, codigos, nome_produto, precos, estoques, &saldo_caixa);
        			salvar_rapido(&total_produtos, codigos, nome_produto, precos, estoques, &saldo_caixa, &cofre);
   			 	}
   			 	else 
    			{
       				printf("\n\t\033[1;31m  [ACESSO NEGADO]\033[1;33m Seu usuario nao tem permissao para cadastrar produtos.\033[0m\n\a");
        			Sleep(2000);
    			}
					
			break;	
		
			case 3: //COMPRA
				
				if (permissao[ID_login][2] == 1) 
    			{
        			compra(&total_produtos, codigos, nome_produto, precos, estoques);
        			salvar_rapido(&total_produtos, codigos, nome_produto, precos, estoques, &saldo_caixa, &cofre);
   			 	}
   			 	else 
    			{
       				printf("\n\t\033[1;31m  [ACESSO NEGADO]\033[1;33m Seu usuario nao tem permissao para cadastrar produtos.\033[0m\n\a");
        			Sleep(2000);
    			}
					
			break;	
		
			case 4://CAIXA
			
				if (permissao[ID_login][3] == 1) 
    			{
        			caixa(&total_produtos, codigos, nome_produto, precos, estoques,&saldo_caixa,&cofre);
        		
   			 	}
   			 	else 
    			{
       				printf("\n\t\033[1;31m  [ACESSO NEGADO]\033[1;33m Seu usuario nao tem permissao para cadastrar produtos.\033[0m\n\a");
        			Sleep(2000);
    			}
							
			break;	
		
			case 5 ://COFRE
				
				if (permissao[ID_login][4] == 1) 
    			{
        		
					cofre_caixa(&cofre, &saldo_caixa, user_login, data, hora, &qt_deposito,conta,agencia,historico_valor_deposito, data_deposito, hora_deposito, historico_user_login);
					//salvar_cofre(&cofre, &saldo_caixa, &qt_deposito,conta, agencia, historico_valor_deposito, data_deposito, hora_deposito, historico_user_login);

   			 	}
   			 	else 
    			{
       				printf("\n\t\033[1;31m  [ACESSO NEGADO]\033[1;33m Seu usuario nao tem permissao para cadastrar produtos.\033[0m\n\a");
        			Sleep(2000);
    			}
			
			break;	
		
			case 6: // CONSULTA ESTOQUE, CODIGO E PREÇO
        	 		
					if (permissao[ID_login][5] == 1) 
    				{
        				 consulta(&total_produtos, codigos, nome_produto, precos, estoques);
   			 		}
   			 		else 
    				{
       					printf("\n\t\033[1;31m  [ACESSO NEGADO]\033[1;33m Seu usuario nao tem permissao para cadastrar produtos.\033[0m\n\a");
        				Sleep(2000);
    				}
					 
           	break;
        
			case 7://PESQUISAR
        		
					if (permissao[ID_login][6] == 1) 
    				{
        				pesquisa(&total_produtos, codigos, nome_produto, precos, estoques);
   			 		}
   			 		else 
    				{
       					printf("\n\t\033[1;31m  [ACESSO NEGADO]\033[1;33m Seu usuario nao tem permissao para cadastrar produtos.\033[0m\n\a");
        				Sleep(2000);
    				} 
			
        	break;
		
			case 8: //EDITAR PRODUTO - REUTILIZAR CODIGO ZERADO
        		
				if (permissao[ID_login][7] == 1) 
    				{
        				codigo_zerado(&total_produtos, codigos, nome_produto, precos, estoques);
        	 	    	salvar_rapido(&total_produtos, codigos, nome_produto, precos, estoques,&saldo_caixa,&cofre);
   			 		}
   			 		else 
    				{
       					printf("\n\t\033[1;31m  [ACESSO NEGADO]\033[1;33m Seu usuario nao tem permissao para cadastrar produtos.\033[0m\n\a");
        				Sleep(2000);
    				} 
						 
			break;
                		
			case 9://RELATORIO DO ESTOQUE
        	
        		if (permissao[ID_login][8] == 1) 
    			{
        			consulta_financeira(&total_produtos, codigos, nome_produto, precos, estoques);
   			 	}
   			 	else 
    			{
       				printf("\n\t\033[1;31m  [ACESSO NEGADO]\033[1;33m Seu usuario nao tem permissao para cadastrar produtos.\033[0m\n\a");
        			Sleep(2000);
    			} 
				
			break;	
	 		
			case 10:
			     				 
        		if (permissao[ID_login][9] == 1) 
    			{
        			cadastrar_usuario(&cont, user, senha, ID, permissao, user_login);
   			 	}
   			 	else 
    			{
       					
					printf("\n\t\033[1;31m[ACESSO NEGADO] Seu usuario nao tem permissao para cadastrar produtos.\033[0m\n");
        			Sleep(2000);
    			} 
				     
			break; 	 	
			
			case 11:
				
					login(&cont, user, senha, ID, permissao, user_login, &ID_login);
					
			break;	
	 		
		 
		 	default:
        		if(menu != 0) manutencao();
			break; 
	 	}
    }
    while(menu!=0);

 return 0;   
}



