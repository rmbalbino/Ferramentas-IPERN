# PDF <- pdf_text("Extrato cotista LME - DEZEMBRO - 2023.pdf")[[1]]
# PDF <- pdf_text("FP2 Dezembro - 2023.pdf")[[1]]


Modelo03 <- function(PDF){
  
  
  # Importando dados:
  PDF <- pdf_text(PDF)[[1]] %>% str_split("\n") %>% unlist() %>% data.frame(Dados = .)
  
  
  # Organizando:
  PDF <- PDF %>% 
    
    mutate(FUNDO = ifelse(str_detect(Dados, "CNPJ") & !str_detect(Dados, "Administrador|IPE"), str_extract(Dados, ".*(?=CNPJ)"), NA), 
           
           CNPJ = ifelse(str_detect(Dados, "CNPJ") & !str_detect(Dados, "Administrador|IPE"), str_extract(Dados, "(?<=CNPJ:).*"), NA), 
           
           
           across(c(FUNDO, CNPJ), ~ str_squish(.)), 
           
           
           Extração = str_extract_all(Dados, "\\(?-?\\d{1,3}(\\.\\d{3})*,\\d+"), 
           
           
           `SALDO ANTERIOR` = ifelse(str_detect(Dados, "Saldo Anterior"), Extractor(Extração, 1), NA), 
           
           APLICAÇÕES = NA, 
           
           RESGATES = NA, 
           
           AMORTIZAÇÃO = NA, 
           
           `RENTABILIDADE (%)` = ifelse(str_detect(Dados, "Ano"), str_replace(Extractor(lead(Extração), 1), "\\(", "-"), NA), 
           
           RENDIMENTO = NA, 
           
           `QTD. DE COTAS` = ifelse(str_detect(Dados, "Saldo Final"), Extractor(Extração, 7), NA), 
           
           COTA = ifelse(str_detect(Dados, "Saldo Final"), Extractor(Extração, 6), NA), 
           
           PL = ifelse(str_detect(Dados, "PL"), Extractor(Extração, 2), NA), 
           
           `SALDO ATUAL` = ifelse(str_detect(Dados, "Saldo Final"), Extractor(Extração, 1), NA), 
           
           
           across(c(5:14), ~ as.numeric(gsub(",", ".", gsub("\\.", "", .))))) %>% 
    
    
    select(-c(Dados, Extração)) %>% fill(FUNDO, CNPJ, `SALDO ANTERIOR`) %>% 
    
    
    fill(PL, `RENTABILIDADE (%)`, .direction = "up") %>% filter(!is.na(COTA)) %>% mutate(RENDIMENTO = `SALDO ATUAL` - `SALDO ANTERIOR`)
    
  
  return(PDF)
  
}
