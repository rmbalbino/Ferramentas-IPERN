# setwd("E:\\Estagio\\Scripts R\\Extratos Investimento\\Todes")



Nordeste.III <- function(PDF){
  
  
  # Importando dados:
  PDF <- pdf_text(PDF)[[1]] %>% str_split("\n") %>% unlist() %>% data.frame(Dados = .)
  
  
  # Organizando:
  PDF <- PDF %>% 
    
    mutate(FUNDO = ifelse(str_detect(Dados, "Nordeste III"), str_extract(Dados, ".*"), NA), 
           
           CNPJ = ifelse(str_detect(Dados, "CNPJ"), str_extract(Dados, "\\d{2}\\.\\d{3}\\.\\d{3}\\/\\d{4}-\\d{2}"), NA),
           
           
           across(c(FUNDO, CNPJ), ~ str_squish(.)),
           
           
           `SALDO ANTERIOR` = NA, 
           
           APLICAÇÕES = NA,
           
           RESGATES = NA,
           
           AMORTIZAÇÃO = NA, 
           
           `RENTABILIDADE (%)` = NA, 
           
           RENDIMENTO = NA, 
           
           `QTD. DE COTAS` = ifelse(str_detect(Dados, "Quantidade de cotas integralizadas de titularidade do cotista"), 
                                    str_extract(Dados, "-?\\d{1,3}(\\.\\d{3})*,\\d+"), NA), 
           
           COTA = NA, 
           
           PL = ifelse(str_detect(Dados, "Patrimônio Líquido"), str_extract(Dados, "-?\\d{1,3}(\\.\\d{3})*,\\d+"), NA), 
           
           `SALDO ATUAL` = ifelse(str_detect(Dados, "Valor atualizado da participação do cotista no Fundo"), str_extract(Dados, "-?\\d{1,3}(\\.\\d{3})*,\\d+"), NA),
           
           
           across(c(4:13), ~ as.numeric(gsub(",", ".", gsub("\\.", "", .))))) %>% 
    
    
    select(-c(Dados)) %>% fill(FUNDO, CNPJ, `QTD. DE COTAS`, `SALDO ATUAL`) %>% 
    
    filter(!is.na(PL)) %>% mutate(COTA = `SALDO ATUAL` / `QTD. DE COTAS`)
  
  
  return(PDF)
  
  
}


