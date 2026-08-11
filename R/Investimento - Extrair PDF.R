# PACOTES ====================================================================================================================================

# install.packages("pacman")
# pacman::p_load(pdftools, tidyverse)


# DEFINIÇÕES INICIAIS ========================================================================================================================

# Diretorio:
# setwd(r"(E:\Estagio\Scripts R\IPERN\Extratos Investimento\\PDFs)")


# ARQUIVOS <- list.files(pattern = "*.pdf")
# NOMES <- ARQUIVOS


# options(scipen = 999)


# FUNÇÕES ====================================================================================================================================

# Auxilia na extração das informaçoes no str_extract_all:
# Extractor <- function(COLUNA, POSIÇÃO){ sapply(COLUNA, function(x) x[POSIÇÃO]) }


Organizar_PDF <- function(NOMES, ARQUIVOS, ARTIGOS){
  
  
  # Importando planilha artigos:
  ARTIGOS <- import(ARTIGOS)
  
  
  # Filtrando:
  FILTRO <- which(str_detect(NOMES, "\\.pdf"))
  ARQUIVOS <- ARQUIVOS[FILTRO]
  
  
  # Extraindo arquivos:
  Extrair_PDF <- map(ARQUIVOS, function(PDF){
    
    
    # Dados para teste if:
    PDFIF <- pdf_text(PDF)[[1]] %>% str_split("\n") %>% unlist() %>% data.frame(Dados = .)
    
    
    if(str_detect(PDFIF$Dados[6], "CAIXA")){


      Caixa01(PDF)
      
      
     } else if(str_detect(PDFIF$Dados[18], "00.360.305/0001-04")){
      
      
       Caixa01_1(PDF)
      
      
    } else if(str_detect(PDFIF$Dados[10], "Administrador")){
      
      
      Caixa02(PDF)
      
      
    } else if(str_detect(PDFIF$Dados[2], "Administrador")){
      
      
      Modelo03(PDF)
      
      
    } else if(str_detect(PDFIF$Dados[2], "BB RECEBÍVEIS")){
      
      
      BB.FII(PDF)
      
    
    } else if(str_detect(PDFIF$Dados[7], "BB RECEBÍVEIS")){
      
      
      BB.FII(PDF)
      
      
    } else if(str_detect(PDFIF$Dados[9], "CVS") | str_detect(PDFIF$Dados[12], "CVS") | str_detect(PDFIF$Dados[13], "CVS")){
      
      
      CVS(PDF)
      
      
    } else if(str_detect(PDFIF$Dados[2], "Nordeste III")){
      
      
      Nordeste.III(PDF)
      
    } 
    
    
  }) %>% bind_rows() %>% select(-CONTA) %>% left_join(ARTIGOS, by = c("FUNDO", "CNPJ")) %>% 
    
    
    mutate(across(c(RESGATES, APLICAÇÕES, AMORTIZAÇÃO), ~ ifelse(is.na(.), 0, .))) 
    
}


# EXECUÇÃO ===================================================================================================================================

# NOMES <- "CAIXA - PRATICO NOVO - Maio.pdf"
# ARQUIVOS <- "PDFs\\CAIXA - PRATICO NOVO - Maio.pdf"
# ARTIGOS <- "Complementar - Artigos.xlsx"

# DADOS.PDFs <- Organizar_PDF(NOMES, ARQUIVOS, ARTIGOS)



# NOVO <- pdf_text("ESTADO - Extrato Cotistas BB Recebiveis Imobiliarios (5).pdf")[[1]] %>% str_split("\n") %>% unlist() %>% data.frame(Dados = .)
