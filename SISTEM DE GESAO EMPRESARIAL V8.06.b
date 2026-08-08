#include<stdio.h>
#include<stdlib.h>
#include <cstdlib>     // Necessário para usar a função system() PING SERVIDOR
#include <windows.h> // Necessário para usar a função Sleep()


#define IP_SERVIDOR "192.168.0.101"
#define MAX 9998 //Quantidade do estoque
#define USUARIOS 5
#define PERMISSAO 10
//================================================================================================================================================================================
void manutencao()
{
    system("cls");
     
    printf ("") ;
    printf ("\n\t\033[1;32m=====================================================\033[1;32m\n") ;
    printf( "\t\t         \033[1;33mAVISO DO SISTEMA\033[0m                     \n");
    printf ("\t\033[1;32m=====================================================\033[1;32m\n") ;
    printf (" \n\t\t [!] PAGINA EM MANUTENCAO [!]\n\n ") ;
    printf ("\t\tEstamos trabalhando para melhorar. \n") ;
    printf (" \t\tPor favor, tente novamente mais tarde.\n\n") ;
    printf ("\t\033[1;32m=====================================================\033[1;32m\n") ;
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
//====================================================================== CARREGAR (PRODUTOS DO ARQUIVO .TXT====================================================================================================
void carregar(int *total_produtos, int codigo[MAX], char nome_produto[MAX][30], float preco[MAX], int qt_estoque[MAX], float *saldo_caixa, float *cofre)
{
   
    int largura_barra = 45,blocos_preenchidos;
	
	
	FILE *arquivo_leitura = fopen("dados.txt", "r");//CARREGAR O ARQUIVO DO PC LOCAL
	//FILE *arquivo_leitura = fopen("\\\\192.168.0.101\\dados\\dados.txt", "r");//CARREGAR O ARQUIVO NA REDE
    
    if (arquivo_leitura != NULL) 
    {
        if (fscanf(arquivo_leitura, "%f\n", saldo_caixa) != EOF && 
            fscanf(arquivo_leitura, "%f\n", cofre) != EOF &&
            fscanf(arquivo_leitura, "%d\n", total_produtos) != EOF) 
            
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
        system("pause > nul");
    }
}
//============================================================== SALVAR (PRODUTOS NO ARQUIVO .TXT ===================================================================================================
void salvar(int *total_produtos, int codigo[MAX], char nome_produto[MAX][30], float preco[MAX], int qt_estoque[MAX], float *saldo_caixa, float *cofre)
{
   
   int largura_barra = 45,blocos_preenchidos;
    printf("\n\t\t\tSalvando informacoes no servidor...\n");
    
    FILE *arquivo_escrita = fopen("dados.txt", "w");//SALVA O ARQUIVO NO PC LOCAL
    //FILE *arquivo_escrita = fopen("\\\\192.168.0.101\\dados\\dados.txt", "w");//SALVA O ARQUIVO NA REDE
    if (arquivo_escrita != NULL) 
    {
        fprintf(arquivo_escrita, "%f\n", *saldo_caixa);
		fprintf(arquivo_escrita, "%f\n", *cofre);
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
        system("pause > nul");
    }
}
//======================================================================= SALVAR RAPIDO (PRODUTOS NO ARQUIVO .TXT ===================================================================================================
void salvar_rapido(int *total_produtos, int codigo[MAX], char nome_produto[MAX][30], float preco[MAX], int qt_estoque[MAX], float *saldo_caixa, float *cofre)
{
          
	FILE *arquivo_escrita = fopen("dados.txt", "w");//SALVA O ARQUIVO NO PC LOCAL
    //FILE *arquivo_escrita = fopen("\\\\192.168.0.101\\dados\\dados.txt", "w");//SALVA O ARQUIVO NA REDE
    
    if (arquivo_escrita != NULL) 
    {
        fprintf(arquivo_escrita, "%f\n", *saldo_caixa);
		fprintf(arquivo_escrita, "%f\n", *cofre);
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
        system("pause > nul");
    }
}
//============================================================== CARREGAR USUARIOS DO ARQUIVO .TXT ===================================================================================
void carregar_user(int *cont, char user[USUARIOS][30], int senha[USUARIOS], int ID[USUARIOS], int permissao[USUARIOS][PERMISSAO]) 
{ 	 	 
    
	FILE *arquivo_leitura = fopen("LOGIN.txt", "r");//CARREGAR O ARQUIVO DE LOGIN DOS USUARIOS DO PC LOCAL
    //FILE *arquivo_leitura = fopen("\\\\192.168.0.101\\dados\\LOGIN.txt", "r");//CARREGAR O ARQUIVO DOS USUARIOS NA REDE
	if (arquivo_leitura != NULL) 
    {
       
        if (fscanf(arquivo_leitura, "%d", cont) != EOF) 
        {
            if (*cont > 10) *cont = 10;

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
        printf("\n\n\t\t\033[1;32m[INFO]     Criando novo banco de dados LOGIN.txt...\n");
        printf("\t\t\033[1;32m[INFO]     User ... :\033[1;34m root    \033[1;32m Senha ... :\033[1;34m 3585 \033[0m \n\n");
        system("pause > nul");
		//Sleep(2000);
    }
}
//============================================================== SALVAR USUARIOS NO ARQUIVO .TXT ==========================================================================================
void salvar_user(int *cont, char user[USUARIOS][30], int senha[USUARIOS], int ID[USUARIOS], int permissao[USUARIOS][PERMISSAO]) 
{
    
	FILE *arquivo_escrita = fopen("LOGIN.txt", "w"); // SALVA O ARQUIVO DOS USUARIOS NO PC LOCAL
    //FILE *arquivo_escrita = fopen("\\\\192.168.0.101\\dados\\LOGIN.txt", "w"); //SALVA O ARQUIVO DOS USUARIOS NA REDE 
    
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
        printf("\a");
    } 
    else
    {
        printf("\n\t\t[ERRO] Sem permissao de escrita ou servidor offline!\n\n\n\n\n\n\n");
        system("pause > nul");
    }
}
//================================================================= TELA DE LOGIN ======================================================================================
void login(int *cont, char user[USUARIOS][30], int senha[USUARIOS], int ID[USUARIOS], int permissao[USUARIOS][PERMISSAO],char user_login[30], int *ID_login )
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

    if((*cont )== 0) //primeiro login - criar o arquivo e o (usario root e senha 3585)
    {
    	
		ID[0] = 1000; 
		strcpy(user[0], "root");
        senha[0] = 3585;
          
    	for(int j = 0; j < PERMISSAO; j++) 
		{
            permissao[0][j] = 1;
        }
    	
			 *cont = 1; 
        	 salvar_user(cont, user, senha, ID, permissao);	
   	} 
   
      
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
        
        printf("\n\n\t \033[1;32mCODIGO GERADO ........... : \033[1;44m # %03d \033[0m   \n", *total_produtos);
       
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
        
    
    
	if(achou == 0) 
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
void cofre_caixa(const float *cofre)
{
    system("cls");
	
	
   	printf("\n\n");
    printf("\n\t\033[1;32m=====================================================\033[0m\n");
    printf("\t\t\t   \033[1;34mSALDO DO COFRE                    \n");
    printf("\t\033[1;32m=====================================================\033[0m\n\n");
    printf("\t\tVALOR TOTAL RETIDO: \033[1;32mR$ %.2f\033[0m REAIS\n\n", *cofre);
    printf("\t\033[1;32m=====================================================\033[0m\n\t");
    printf("\t\033[1;33mPressione ENTER para voltar ao menu...\033[0m");
       	
	   	

    system("pause > nul"); 
   
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
                break; // Encontrou, pode parar o laço imediatamente
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
void cadastrar_usuario(int *cont, char user[USUARIOS][30], int senha[USUARIOS], int ID[USUARIOS], int permissao[USUARIOS][PERMISSAO]) 
{     
    int menu, id, senha1 = 0, senha2 = 1, primeira_tentativa = 1, usuario_encontrado = 0, confirmar_salvar = 0, permissao_2[PERMISSAO]; 
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
           
		   
		    case 1:                                  
                if (*cont >= USUARIOS + 1) 
                {                     
                    system("cls");
					printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");         
        			printf("\t\033[1;34m °°\033[1;32m  [1] - \033[0m\033[1;42m NOVO USUARIO \033[0m  [2]\033[0m - EDITAR USUARIO\033[0m  [3]\033[0m - TODOS USUARIOS \033[0m  [0]\033[0m - SAIR  \033[1;34m °° \n");         
        			printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");   
					printf("\n\t [AVISO] Limite maximo de %d usuarios atingido!\n",USUARIOS);                     
                    Sleep(2000);                   
                    break;                 
                }                  
                                 
                system("cls");         
        		printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");         
        		printf("\t\033[1;34m °°\033[1;32m   [1]\033[1;36m - NOVO USUARIO\033[0m  [2]\033[0m - EDITAR USUARIO\033[0m  [3]\033[0m - TODOS USUARIOS \033[0m  [0]\033[0m - SAIR  \033[1;34m  °° \n");         
        		printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");   
                printf("\n\t\033[1;34m ID ............. :\033[0m [\033[1;32m # %d \033[0m]", *cont);                   				
                printf("\n\t\033[1;34m NOVO USUARIO ... :\033[1;32m ");                 
                scanf("%29s", user[*cont]);                         			    
                
				do
   			    {

                    primeira_tentativa = 1;
					
					printf("\t\033[1;34m SENHA ............ : \033[0m");                 
                    printf("\033[30m"); // Oculta a digitação
                    scanf("%d", &senha1);     			
                    printf("\033[0m");  

                    printf("\t\033[1;34m REPITA A SENHA ... : \033[0m");                 
                    printf("\033[30m"); // Oculta a digitação
                    scanf("%d", &senha2);     			
                    printf("\033[0m");          

                   
                    if (senha1 != senha2)  // Se errou, desmarca a primeira tentativa para que a próxima volta exiba o erro
                    {
                        primeira_tentativa = 0;
                    }
                    
                    
         			if (!primeira_tentativa)
                    {	
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
                printf("\t\033[1;34m caixa? ............ NAO [0]  SIM [1] > \033[1;32m ");     			
                scanf("%d", &permissao[*cont][3]);      			     			
                printf("\t\033[1;34m cofre? ............ NAO [0]  SIM [1] > \033[1;32m ");     			
                scanf("%d", &permissao[*cont][4]);      			     			
                printf("\t\033[1;34m estoque? .........  NAO [0]  SIM [1] > \033[1;32m ");     			
                scanf("%d", &permissao[*cont][5]);      			     			
                printf("\t\033[1;34m pesquisar? ........ NAO [0]  SIM [1] > \033[1;32m ");     			
                scanf("%d", &permissao[*cont][6]);  				 				
                printf("\t\033[1;34m editar produto? ... NAO [0]  SIM [1] > \033[1;32m ");     			
                scanf("%d", &permissao[*cont][7]);      			     			
                printf("\t\033[1;34m relatorio? ........ NAO [0]  SIM [1] > \033[1;32m ");     			
                scanf("%d", &permissao[*cont][8]);    			 				
                printf("\t\033[1;34m ususario? ......... NAO [0]  SIM [1] > \033[1;32m ");     			
                scanf("%d", &permissao[*cont][9]);    			 
                               
                printf("\n\t\033[1;32m[SUCESSO] Usuario criado....!\033[0m\n");
                Sleep(1000);
                
				ID[*cont] = *cont;                  
                (*cont)++;                  				 				 
                                
                 salvar_user(cont, user, senha, ID, permissao);
                
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
							
							if (strcmp(user[id], "") == 0) //se a string (strcmp(user[id], "") == 0) estiver vazia nao vai entrar
							{
								printf("\n\t\033[1;31m[ATENCAO]\033[1;33m O usuario\033[0m nao pode ser editado\n");
								Sleep(2000);
								break;
							}	
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
                				printf("\n\t\033[1;34m USUARIO ........ :\033[1;32m %s \n",user[id]);
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
                			else
                			{
                				printf("\n\t\033[1;33m[AVISO] Usuario nao existe no sistema....\033[0m\n");
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
							
							if (strcmp(user[id], "") == 0) //se a string (strcmp(user[id], "") == 0) estiver vazia nao vai entrar
							{
								printf("\n\t\033[1;31m[ATENCAO]\033[1;33m O usuario\033[0m nao pode ser editado\n");
								Sleep(2000);
								break;
							}		
							
							if ((id == 0) || (id == 1000)) //nao deixa trocar o nome do root E se a string (strcmp(user[id], "") == 0) está vazia
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
										for(int i = 0; i < 10; i++)
										{
											permissao[id][i] = permissao_2[i];
																				
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
							
							if (strcmp(user[id], "") == 0) //se a string (strcmp(user[id], "") == 0) estiver vazia nao vai entrar
							{
								printf("\n\t\033[1;31m[ATENCAO]\033[1;33m O usuario\033[0m nao pode ser editado\n");
								Sleep(2000);
								break;
							}
														
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
						
						case 4://case 1 (editar usuario) -> case 4 (deletar user)
							system("cls");         
                			printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");         
        					printf("\t\033[1;34m °°\033[0m  [1]\033[0m - TROCAR SENHA\033[0m  [2]\033[0m - EDITAR PERMISSAO  [3]\033[0m - EDITAR USUARIOS \033[1;32m  [4] - \033[0m\033[1;42m DELETAR USUARIO \033[0m \033[1;34m °° \n");         
        					printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");    
                
                			printf("\n\t\033[1;34m ID ........... :\033[1;32m ");                   				
                			scanf("%d", &id);
						
							if (strcmp(user[id], "") == 0) //se a string (strcmp(user[id], "") == 0) estiver vazia nao vai entrar
							{
								printf("\n\t\033[1;31m[ATENCAO]\033[1;33m O usuario\033[0m nao pode ser editado\n");
								Sleep(2000);
								break;
							}
							
							if ((id == 0) || (id == 1000))  //nao deixa trocar o nome do root 
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
        							printf("\t\033[1;34m °°\033[0m  [1]\033[0m - TROCAR SENHA\033[0m  [2]\033[0m - EDITAR PERMISSAO  [3]\033[0m - EDITAR USUARIOS \033[1;32m  [4] - \033[0m\033[1;42m DELETAR USUARIO \033[0m \033[1;34m °° \n");         
        							printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");    
									printf("\n\t\033[1;34m ID ............. :\033[0m [\033[1;32m # %d \033[0m]", id);                   				
                					printf("\n\t\033[1;34m USUARIO ........ :\033[1;32m %s ",user[id]);                 
                					printf("\n\n\t\033[1;31m[ATENCAO] O USUARIO SERA DELETADO ... \033[1;32m \n");   
                        			printf("\t\033[1;34mGOSTARIA DE DELETAR ?\033[1;33m [1-SIM / 2-NAO] -> \033[1;32m ");
									scanf("%d", &confirmar_salvar);	
									if(confirmar_salvar)
									{
										for(int i = 0; i < PERMISSAO; i++)
										{
												permissao[id][i] = 0;
										}
										strcpy(user[id], "");
										senha[id]=0;
										
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
						
						
						
						break;	
									           			
					}//final do switch
            	            	         		
				}//final do DO do case 2
            	while(menu =0);           
            	
			break;//fincal do case 2
                
           
				
			case 3:// case 3 do primeiro switch
    		
				system("cls");         
        		printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n");         
        		printf("\t\033[1;34m °°\033[0m   [1]\033[0m - NOVO USUARIO\033[0m  [2]\033[0m - EDITAR USUARIO\033[1;32m  [3] -\033[0m \033[1;42m TODOS USUARIOS \033[0m  [0]\033[0m - SAIR  \033[1;34m °° \n");         
        		printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° \n\n");   
				
				printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°\033[0m\n");      		   
				printf("\t\033[1;34m °°\033[1;33m      ID     \033[1;34m°°\033[1;33m           USUARIO             \033[1;34m°°\033[1;33m             PERMISSOES           \033[1;34m°°\033[0m\n");
				printf("\t\033[1;34m °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°1°°2°°3°°4°°5°°6°°7°°8°°9°°10°°°°\033[0m\n");    

				for(int i = 0; i < *cont; i++) 
				{
   					if (strcmp(user[i], "") != 0)
   					{
					   	printf("\t \033[1;34m°°\033[1;36m  \t# %4d  \033[1;34m°°\033[1;36m     \t   %-20s\033[1;34m  °°\033[0m ", ID[i], user[i]);
      					
					    for(int j = 0; j < PERMISSAO; j++) 
    					{
       					
						   	if(permissao[i][j] == 1) printf(" \033[1;32m X\033[0m");
        					else printf(" \033[1;35m O\033[0m");										
  	 					
						   }
   							printf("   \033[1;34m°°\033[0m\n");
    				}		
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
   
	char nome_produto[MAX][30],user[USUARIOS][30],usuario_digitado[USUARIOS][30], user_login[30]; 
    int codigos[MAX], estoques[MAX], total_produtos = 1, menu,senha[USUARIOS], ID[USUARIOS], permissao[USUARIOS][10],senha_digitada[USUARIOS],ID_login, cont = 0 ;
    float precos[MAX], saldo_caixa, cofre ;
        
	
	ping(); 
    
	carregar(&total_produtos, codigos, nome_produto, precos, estoques,&saldo_caixa,&cofre);
    carregar_user(&cont, user, senha, ID, permissao);
		
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
		printf("\t\033[1;34m°° \033[1;33m USER ... :\033[1;32m %-10s      \033[1;34m°°°°°°°°°°°°°°°°°°°°°°°\033[1;34m  Versao :\033[1;32m 8.06.b \033[1;34m°°\033[0m\n",user_login);	
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
        			salvar_rapido(&total_produtos, codigos, nome_produto, precos, estoques, &saldo_caixa, &cofre);
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
        			cofre_caixa(&cofre);
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
        			cadastrar_usuario(&cont, user, senha, ID, permissao);
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
 
   salvar(&total_produtos, codigos, nome_produto, precos, estoques,&saldo_caixa,&cofre);
     
 return 0;   
}