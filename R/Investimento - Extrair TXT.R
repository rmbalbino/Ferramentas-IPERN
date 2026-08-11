# PACOTES ====================================================================================================================================

# install.packages("pacman")
# pacman::p_load(rio, tidyverse)


# DEFINIÇÕES INICIAIS ========================================================================================================================

# Diretorio:
# setwd("E:\\Estagio\\Scripts R\\Extratos Investimento\\TXT")

# Arquivos <- list.files(pattern = "*.txt")

# options(scipen = 999)


# FUNÇÕES ====================================================================================================================================


Organizar_TXT <- function(NOMES, ARQUIVOS, ARTIGOS){
  
  
  # Importando planilha artigos:
  ARTIGOS <- import(ARTIGOS)
  
  
  # Filtrando:
  FILTRO <- which(str_detect(NOMES, "\\.txt"))
  ARQUIVOS <- ARQUIVOS[FILTRO]
  
  
  # Extraindo arquivos:
  Extrair_TXT <- map(ARQUIVOS, function(EXTRATO){
    
  # Importando dados:
  TXT <- import(EXTRATO, sep = "\t", col.names = "Dados", encoding = "Latin-1")
  # TXT <- import("Fundo Investimento Mensal - 7987-1 - Copia.txt", sep = "\t", col.names = "Dados", encoding = "Latin-1")
  
  
  TXT <- TXT %>% mutate(Dados = str_trim(Dados), 
                         
                         
                         FUNDO = str_extract(Dados, ".*(?=- CNPJ)"), 
                         
                         
                         # CONTA = str_extract(Dados, "(?<=Conta:).*(?= RN )"), 
                         CONTA = ifelse(str_detect(Dados, "Conta:"), str_extract(Dados, "\\d+-\\d{1}|\\d+-X"), NA), 
                        
                         
                         CNPJ = str_extract(Dados, "(?<=CNPJ:).*"), 
                         
                         
                         across(c(FUNDO, CONTA, CNPJ), ~ str_squish(.)), 
                         
                         
                         CNPJ = ifelse(nchar(CNPJ) == 13, paste0("0", CNPJ), CNPJ), 
                         
                         
                         CNPJ = str_c(
                           str_sub(CNPJ, 1, 2), ".", 
                           str_sub(CNPJ, 3, 5), ".", 
                           str_sub(CNPJ, 6, 8), "/", 
                           str_sub(CNPJ, 9, 12), "-", 
                           str_sub(CNPJ, 13, 14)), 
                        
                         
                         `SALDO ANTERIOR` = str_extract(Dados, "(?<=^SALDO ANTERIOR).*"), 
                         
                         
                         APLICAÇÕES = str_extract(str_remove(Dados, "\\(\\+\\)"), "(?<=^APLICAÇÕES).*"), 
                         
                         
                         RESGATES = str_squish(str_extract(str_remove(Dados, "\\(-\\)"), "(?<=^RESGATES).*")), 
                         
                         RESGATES = ifelse(str_detect(Dados, "^RESGATES") & !str_detect(Dados, "\\b0,00\\b"), paste0("-", RESGATES), RESGATES),
                         
                         # RESGATES = str_extract(str_remove(Dados, "\\(-\\)"), "(?<=^RESGATES).*"), 
                         
                         
                         AMORTIZAÇÃO = 0, 
                         
                         
                         `RENTABILIDADE (%)` = str_extract(Dados, "(?<=No mês:).*"), 
                         
                         
                         RENDIMENTO = ifelse(str_detect(Dados, "RENDIMENTO BRUTO"), str_extract(Dados, "\\d{1,3}(\\.\\d{3})*,\\d+"), NA), 
                         
                         
                         RENDIMENTO = ifelse(str_detect(Dados, "RENDIMENTO BRUTO") & str_detect(Dados, "\\(-\\)"), paste0("-", RENDIMENTO), RENDIMENTO), 
                         
                         
                         COTA = ifelse(str_detect(Dados, "Cota"), str_remove_all(lead(Dados, n = 3), "\\s|\\d{2}\\/\\d{2}\\/\\d{4}"), NA),
                         
                         
                         PL = NA, 
                         
                         
                         `SALDO ATUAL` = str_extract(str_remove(Dados, "="), "(?<=^SALDO ATUAL).*"), 
                         
                         
                         across(c(5:13), ~ as.numeric(gsub(",", ".", gsub("\\.", "", .))) )) %>% 
    
    
    fill(FUNDO, CONTA, CNPJ, `SALDO ANTERIOR`, APLICAÇÕES, RESGATES, RENDIMENTO, COTA, `SALDO ATUAL`) %>% filter(!is.na(`RENTABILIDADE (%)`)) %>%
  
  
    mutate(`QTD. DE COTAS` = round((`SALDO ATUAL` / COTA), 6)) %>% distinct() %>% 
    
    
    select(FUNDO, CONTA, CNPJ, `SALDO ANTERIOR`, APLICAÇÕES, RESGATES, AMORTIZAÇÃO, `RENTABILIDADE (%)`, RENDIMENTO, `QTD. DE COTAS`, COTA, PL, `SALDO ATUAL`)
    
  }) %>% bind_rows() %>% left_join(ARTIGOS, by = c("FUNDO", "CONTA", "CNPJ")) %>% 
    
    
    mutate(across(c(RESGATES, APLICAÇÕES, AMORTIZAÇÃO), ~ ifelse(is.na(.), 0, .)))
    
  
}


# EXECUÇÃO ===================================================================================================================================

# DADOS.TXTs <- Organizar_TXT(Arquivos, ARTIGOS)
