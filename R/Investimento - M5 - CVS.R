

CVS <- function(PDF){
  
  
  # Importando dados:
  PDF <- pdf_text(PDF)[[1]] %>% str_split("\n") %>% unlist() %>% data.frame(Dados = .)
  
  
  # Organizando:
  PDF <- PDF %>% 
    
    mutate(FUNDO = "TÍTULO CVS - CAIXA ECONÔMICA FEDERAL", 
           
           CONTA = NA, 
           
           CNPJ = NA, 
           
           
           Extração = str_extract_all(Dados, "-?\\d{1,3}(\\.\\d{3})*,\\d+|\\d+\\.\\d+"), 
           
           
           `SALDO ANTERIOR` = NA, 
           
           APLICAÇÕES = NA, 
           
           RESGATES = NA,
           
           JUROS = ifelse(str_detect(Dados, "\\*\\*\\*"), Extractor(Extração, 3), NA),
           
           AMORTIZAÇÃO = ifelse(str_detect(Dados, "\\*\\*\\*"), Extractor(Extração, 4), NA), 
           
           `RENTABILIDADE (%)` = NA,
           
           RENDIMENTO = NA, 
           
           `QTD. DE COTAS` = ifelse(str_detect(Dados, "\\*\\*\\*"), Extractor(Extração, 1), NA), 
           
           COTA = NA, 
           
           PL = NA,
           
           `SALDO ATUAL` = ifelse(str_detect(Dados, "\\*\\*\\*"), Extractor(Extração, 2), NA), 
           
           
           across(c(6:16), ~ as.numeric(gsub(",", ".", gsub("\\.", "", .)))),
           
           
           AMORTIZAÇÃO = JUROS + AMORTIZAÇÃO) %>% select(-c(Dados, Extração, JUROS)) %>% filter(!is.na(AMORTIZAÇÃO))
  
  
  return(PDF)
  
  
}
