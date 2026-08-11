# DEFINIÇÕES INICIAIS ========================================================================================================================

# Diretorio:
# setwd("E:\\Estagio\\Scripts R\\Extratos Investimento\\Todes")

# Importando planilha de artigos:
# ARTIGOS <- import("E:\\Estagio\\Scripts R\\Extratos Investimento\\Artigos.xlsx")

# options(scipen = 999)


# FUNÇÕES ====================================================================================================================================

# Auxilia na extração das informaçoes no str_extract_all:
Extractor <- function(COLUNA, POSIÇÃO){ sapply(COLUNA, function(x) x[POSIÇÃO]) }


# Função final:
Extrair_Geral <- function(NOMES, MESANO, ARQUIVOS, ARTIGOS){
  
  
  # Manipulando mensagens:
  tryCatch(


    # Especificando expressão:
    expr = {
  
      
      Tabela <- bind_rows(Organizar_PDF(NOMES, ARQUIVOS, ARTIGOS), Organizar_TXT(NOMES, ARQUIVOS, ARTIGOS)) %>% 
        
        arrange(FUNDO) %>% 
        
        mutate(`PART. CARTEIRA` = NA, `RENT. CARTEIRA` = NA, 
               COMPETÊNCIA = paste0(str_sub(MESANO, 6, 7), "/", str_sub(MESANO, 1, 4)), 
               `RENTABILIDADE (%)` = `RENTABILIDADE (%)` / 100) %>% 
        
        select(COMPETÊNCIA, FUNDO, CONTA, CNPJ, SEGUIMENTO, ARTIGO, `MAX. ARTIGO`, `SALDO ANTERIOR`, APLICAÇÕES, RESGATES, AMORTIZAÇÃO, 
               `RENTABILIDADE (%)`, `PART. CARTEIRA`, `RENT. CARTEIRA`, RENDIMENTO, `QTD. DE COTAS`, COTA, PL, `SALDO ATUAL`) %>% 
        
        distinct(FUNDO, CONTA, CNPJ, SEGUIMENTO, ARTIGO, `MAX. ARTIGO`, `SALDO ANTERIOR`, APLICAÇÕES, RESGATES, 
                 AMORTIZAÇÃO, `RENTABILIDADE (%)`, RENDIMENTO, `QTD. DE COTAS`, COTA, PL, `SALDO ATUAL`, .keep_all = TRUE) %>% 
        
        rowid_to_column("ÍNDICE") %>% 
        
        rename("RENTABILIDADE" = "RENTABILIDADE (%)")
    
 
      
      # Notificacao de sucesso:
      report_success("Organização Finalizada!", "Agora selecione a pasta de sua preferência para baixar o arquivo e utilizá-lo em suas atividades.")
      
      
      return(Tabela)
      
      
    }, # Fim do sucesso
  
  
  # Especificando menssagem de erro:
  error = function(e){ report_failure("Erro!", "Verifique se você selecionou corretamente os extratos de investimento e a planilha de Artigos.")} ) # Fim do erro
  
}


# EXECUÇÃO ===================================================================================================================================

# Listando arquivos:
# Arquivos <- list.files(pattern = "*\\.pdf|*\\.txt")

# Executando função final:
# A <- Extrair_Geral(Arquivos, Arquivos, ARTIGOS)
