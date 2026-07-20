#include<stdio.h>
#include<stdlib.h>

#define MAX 9998 //Quantidade do estoque

int main()
{
	 
    system("color 0B");
    
	char nome_produto[MAX][30];
    int op, cont=1, i=0, escolha, vetor_codigo[MAX], qt_estoque[MAX], venda, achou, qt_venda, qt_compra;
    float preco[MAX], total_venda, valor_total_estoque = 0, valor_produto;
      
	// =========================================================================
    // ROTINA DE CARREGAMENTO AUTOMÁTICO (INÍCIO DO PROGRAMA)
    // =========================================================================
    FILE *arquivo_leitura = fopen("dados.txt", "r");
    if (arquivo_leitura != NULL) 
    {
        // 1º passo: lê a quantidade total de produtos cadastrados guardada no topo
        if (fscanf(arquivo_leitura, "%d\n", &cont) != EOF) 
        {
            // 2º passo: reconstrói as linhas da tabela/vetores na memória
            for (i = 1; i < cont; i++) 
            {
                fscanf(arquivo_leitura, "%d %29s %f %d\n", &vetor_codigo[i], nome_produto[i], &preco[i], &qt_estoque[i]);
            }
        }
        fclose(arquivo_leitura);
    }
    // =========================================================================
        
	do
    {
       system("cls");
	   printf("\n\n");	
	   printf("\t°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°\n");
	   printf("\t°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°\n");	
       printf("\t°°              <<< SISTEMA DE GESTAO EMPRESARIAL >>>                  °°\n");
	   printf("\t°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°\n");	
       printf("\t°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°\n");
	   printf("\t°°                                                                     °°\n");
       printf("\t°°            1 - CADASTRAR                                            °°\n");
	   printf("\t°°            2 - VENDA                                                °°\n");
	   printf("\t°°            3 - COMPRA                                               °°\n");
	   printf("\t°°            4 - ESTOQUE                                              °°\n");
	   printf("\t°°            5 - ESTOQUE ZERADO                                       °°\n");
	   printf("\t°°            6 - CONSULTA FINANCEIRA                                  °°\n");	
	   printf("\t°°            7 - DELETAR PRODUTO                                      °°\n");	
	   printf("\t°°                                                                     °°\n");
	   printf("\t°°            9 - SALVAR                                               °°\n");	
	   printf("\t°°                                                                     °°\n");
	   printf("\t°°            0- SAIR                                      <<FredBenz>>°°\n");	
       printf("\t°°                                                             V3.00.0 °°\n");	
	   printf("\t°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°\n");
       printf("\t°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°\n");
	   printf("\t- ");	 
	   scanf("%d",&op);
		
		switch(op)
		{
			
	    case 1: //CADASTRO DOS PRODUTOS
		      
			   system("cls");
			  
			   if(cont < MAX)
               {
                    printf("\t================ CADASTRAR PRODUTO ================\n");
                    printf("\t* CODIGO GERADO -> %d\n", cont);
                        
					vetor_codigo[cont]=cont;
                        
				    printf("\t* DIGITE O NOME DO PRODUTO -> ");	
                    scanf("%29s", nome_produto[cont]); 
			
                    printf("\t* DIGITE O PRECO DO PRODUTO -> R$ ");	
                    scanf("%f", &preco[cont]);
		     
                    printf("\t* DIGITE A QUANTIDADE EM ESTOQUE -> ");	
                    scanf("%d", &qt_estoque[cont]); 
                        
                    cont++; // Incrementa o contador para o próximo produto
                        
                        
                    if(cont > MAX) // Se atingiu o limite logo após cadastrar, avisa e sai 
					{
                        printf("\n\t[AVISO] Limite de armazenamento atingido (%d produtos)!\n", MAX);
                        system("pause");
                        break;
                    }

                    printf("\n\t CADASTRAR OUTRO PRODUTO? [1-SIM / 2-NAO] -> ");
                    scanf("%d", &escolha);		
                   		 
					while((escolha == 1) && (cont < MAX))
                    {
                           	
						system("cls");
                        	
						printf("\t================ CADASTRAR PRODUTO ================\n");
                        printf("\t* CODIGO GERADO -> %d\n", cont);
                          
                        vetor_codigo[cont]=cont;
                               
						printf("\t* DIGITE O NOME DO PRODUTO -> ");	
                        scanf("%s", nome_produto[cont]); 
			
                        printf("\t* DIGITE O PRECO DO PRODUTO -> R$ ");	
                        scanf("%f", &preco[cont]);
		     
                        printf("\t* DIGITE A QUANTIDADE EM ESTOQUE -> ");	
                        scanf("%d", &qt_estoque[cont]); 
                        
                        cont++; // Incrementa o contador para o próximo produto	
                           
						printf("\n\t CADASTRAR OUTRO PRODUTO? [1-SIM / 2-NAO] -> ");
                        scanf("%d", &escolha);		
                        									   
					}				   
							   
			    }
                else
                {
                    printf("\n\t<<< ESTOQUE CHEIO! Nao e possivel cadastrar mais produtos >>>\n");	
                    system("pause");
                    escolha = 2; // Força a saída do laço de cadastro
				}
			
		break;//final do case 1: cadastro de produtos
			
		case 2: // VENDA
            
		     	system("cls");
                printf("\t================ VENDAS ================\n");
                printf("\t* CODIGO DO PRODUTO -> ");	
           		scanf("%d", &venda);	
    
           		achou = 0; // Variável de controle (0 = não encontrado, 1 = encontrado)
    
                system("cls");
    			for(i = 1; i < cont; i++)
    			{
        
        			if(venda == vetor_codigo[i]) 
        			{
            			achou = 1; // Marca que o produto existe no sistema
            
           				 printf("\n\t======================= PRODUTO ENCONTRADO ===========================\n");
           				 printf("\t%-20s \t%-10s \t%-12s \t%-10s\n", "NOME DO PRODUTO", "CODIGO", "PRECO", "ESTOQUE ATUAL");     
           				 printf("\t======================================================================\n");
            			 printf("\t%-20s \t#%03d      \tR$ %-10.2f \t%d Un\n", nome_produto[i], vetor_codigo[i], preco[i], qt_estoque[i]);
            			 printf("\t----------------------------------------------------------------------\n");
            
           
            			 printf("\n\t* DIGITE A QUANTIDADE PARA VENDA -> ");   
            			 scanf("%d", &qt_venda);
            
            
                         if(qt_venda <= qt_estoque[i]) // Valida se há estoque suficiente
           				 {
                			qt_estoque[i] -= qt_venda; 
               				total_venda = qt_venda * preco[i];
                
               				printf("\n\t[SUCESSO] Venda realizada com sucesso!\n");
                            printf("\tTOTAL A PAGAR: R$ %.2f\n\n\n\n\n\n\n\n", total_venda);
                         }
            			 else
            			 {
                			printf("\n\t[ERRO] Estoque insuficiente! Operacao cancelada.\n\n\n\n\n\n\n\n");
            			 }
            
            		system("pause");
            		break; // Para o loop 'for', pois já encontrou o produto desejado
                    }
                }                     
   
                if(achou == 0) // Se o loop terminou e a variável 'achou' continuar em 0, significa que rodou tudo e não existia
                {
                    printf("\n\t[AVISO] PRODUTO NAO ENCONTRADO NO SISTEMA!\n\n\n\n\n\n\n\n"); 
                    system("pause");	
                }
    
        break; // Final do case 2
			
		case 3: // COMPRA
			
				system("cls");
                printf("\t================ COMPRA ================\n");
                printf("\t* CODIGO DO PRODUTO -> ");	
           		scanf("%d", &escolha);	
			
				achou = 0; // Variável de controle (0 = não encontrado, 1 = encontrado)
    
                system("cls");
    			for(i = 1; i < cont; i++)
    			{
        
        			if(escolha == vetor_codigo[i]) 
        			{
            			achou = 1; // Marca que o produto existe no sistema
            
           				 printf("\n\t======================= PRODUTO ENCONTRADO ===========================\n");
           				 printf("\t%-20s \t%-10s \t%-12s \t%-10s\n", "NOME DO PRODUTO", "CODIGO", "PRECO", "ESTOQUE ATUAL");     
           				 printf("\t======================================================================\n");
            			 printf("\t%-20s \t#%03d      \tR$ %-10.2f \t%d Un\n", nome_produto[i], vetor_codigo[i], preco[i], qt_estoque[i]);
            			 printf("\t----------------------------------------------------------------------\n");
            
           
            			 printf("\n\t* DIGITE A QUANTIDADE PARA COMPRAR -> ");   
            			 scanf("%d", &qt_compra);
            			 
            			 printf("\t* DIGITE O PRECO DO PRODUTO -> R$ ");	
                         scanf("%f", &preco[i]);
            
            
                        qt_estoque[i] += qt_compra; 
               				 
                
               			printf("\n\t           [SUCESSO] \n\n\n\n\n\n\n");
                            
                    }
                }
              
                if(achou == 0) // Se o loop terminou e a variável 'achou' continuar em 0, significa que rodou tudo e não existia
                {
                    printf("\n\t[AVISO] PRODUTO NAO ENCONTRADO NO SISTEMA!\n\n\n\n\n\n"); 
                    system("pause");	
                }  
			
		break; // FINAL DO CASE 3:
				
		case 4://consula estoque, codigo e preço
			     
			    system("cls");
				 
				printf("==================================== CONSULTA ==================================\n");
                printf("\t%-20s \t%-10s \t%-12s \t%-10s\n", "NOME DO PRODUTO", "CODIGO", "PRECO", "ESTOQUE");     
                printf("================================================================================\n");
                
                for(i = 1; i < cont; i++)	
                {
                    // Usa %-20s para alinhar o texto à esquerda com tamanho fixo
                    printf("\t%-20s \t#%03d      \tR$ %-10.2f \t%d Un\n", nome_produto[i], vetor_codigo[i], preco[i], qt_estoque[i]);	
                    printf("--------------------------------------------------------------------------------\n");
                }
                
                printf("\n");
                system("pause");
        break;
				
		case 5: // MOSTRA OS PRODUTOS ZERADOS NO ESTOQUE
			    system("cls");	
				printf("================================ ESTOQUE ZERADO ================================\n");
                printf("\t%-20s \t%-10s \t%-12s \t%-10s\n", "NOME DO PRODUTO", "CODIGO", "PRECO", "ESTOQUE");     
                printf("================================================================================\n");
                	    		    
		    	achou = 0;
				for(i = 1; i < cont; i++ )
		    	{
		    															
					
					if (qt_estoque[i] == 0 )
		    		{
		    		   printf("\t%-20s \t#%03d      \tR$ %-10.2f \t%d Un\n", nome_produto[i], vetor_codigo[i], preco[i], qt_estoque[i]);	
                       printf("--------------------------------------------------------------------------------\n");	
		    		   
					   achou = 1;	
					}    	
					
					if (achou == 0)
					{
						printf("\n\n\n\n\n\t\t\t    NAO HA PRODUTOS ZERADOS\n\n\n\n\n\n\n\a") ;    
				        printf("================================================================================\n");
					    break;
					}
				}
			    printf("\n");
                system("pause");
			
		break;
				
		case 6:// RELATÓRIO FINANCEIRO DO ESTOQUE
		   	     
               system("cls");
     
                printf("========================================== CONSULTA FINANCEIRA ================================================\n");
                printf("\t%-20s \t%-10s \t%-12s \t%-10s \t%-15s\n", "NOME DO PRODUTO", "CODIGO", "PRECO", "ESTOQUE", "VALOR INVESTIDO");     
                printf("===============================================================================================================\n");
           
		        for(i = 1; i < cont; i++)	 
			    {
        
                     valor_produto = qt_estoque[i] * preco[i];
                     valor_total_estoque += valor_produto;

                     printf("\t%-20s \t#%03d      \tR$ %-10.2f \t%d Un     \tR$ %.2f\n", nome_produto[i], vetor_codigo[i], preco[i], qt_estoque[i], valor_produto);	
                     printf("\  -------------------------------------------------------------------------------------------------------\n");
                 }    
                 
				 printf("\n");
                 printf("\t           VALOR TOTAL DO ESTOQUE ACUMULADO NO SISTEMA: R$ %.2f  \n\n", valor_total_estoque);
                 printf("================================================================================================================\n");
                 printf("\n");
                 system("pause");
        break;

		case 7:
				system("cls");	
				printf("==================================== DELETAR ==================================\n");
                printf("\t%-20s \t%-10s \t%-12s \t%-10s\n", "NOME DO PRODUTO", "CODIGO", "PRECO", "ESTOQUE");     
                printf("================================================================================\n");
                	    		    
		    	achou = 0;
		    	
				for(i = 1; i < cont; i++ )
		    	{
		    	    if ((qt_estoque[i] == 0 ) && (vetor_codigo[i] !=0) && (preco[i]>0 ))
		    		{
		    		    printf("\t%-20s \t#%03d      \tR$ %-10.2f \t%d Un\n", nome_produto[i], vetor_codigo[i], preco[i], qt_estoque[i]);	
                        printf("--------------------------------------------------------------------------------\n");	
		    				    			
						achou = 1;
						
						printf("\n\t* DIGITE O CODIGO -> ");   
            	        scanf("%d", &escolha);
            	        
							
            	       	if(escolha == vetor_codigo[i])  
						{
							nome_produto[i][0] = '\0'; 
                            //vetor_codigo[i] = 0;
                            preco[i] = 0.0;
										
						}    	
					}
				}
				
				if (achou == 0)
				{
					
					printf("\n\n\n\n\n\t\t\t    NAO HA PRODUTOS ZERADOS\n\n\n\n\n\n\n") ;    
				    printf("================================================================================\n\a");
					system("pause");
				break;
				}
				
				printf("\n\n");
				printf("================================================================================\n");
                printf("\n");
                system("pause");
			
		break;
		
		case 9: //SALVA DADOS NO ARQUIVO.txt
		    
		        // =====================================================================
                // ROTINA DE SALVAMENTO AUTOMÁTICO (FECHAMENTO)
                // =====================================================================
				printf("\n\t\t\tSalvando informacoes no banco de dados...\n\a");
                
                FILE *arquivo_escrita = fopen("dados.txt", "w");
                if (arquivo_escrita != NULL) 
                {
                    
                    fprintf(arquivo_escrita, "%d\n", cont); // Grava o valor do contador no topo do arquivo
                    
                for (i = 1; i < cont; i++) // Grava as informações de cada item linha por linha
		     	{
			        fprintf(arquivo_escrita, "%d %s %.2f %d\n",vetor_codigo[i], nome_produto[i], preco[i], qt_estoque[i]);
			    }
			    fclose(arquivo_escrita);
			    
				printf("\t\t\t[OK] Dados salvos com sucesso!\n\n\n\n\n\n\n");
			    system("pause");
			    } 
				else
				{
				   printf("\t[ERRO] Nao foi possivel salvar as informacoes!\n\n\n\n\n\n\n");
				   system("pause");
			    }
		break;	
		}//final do SWITCH
		
	}//final do DO
	while(op!=0);
    
return 0;
}   //final do MAIN() 
