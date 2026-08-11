


BB.FII <- function(PDF){
  
  
  # Importando dados:
  PDF <- pdf_text(PDF)[[1]] %>% str_split("\n") %>% unlist() %>% data.frame(Dados = .)
  
  
  # Organizando:
  PDF <- PDF %>% 
    
    mutate(FUNDO = ifelse(str_detect(Dados, "Nome do Fundo"), str_extract(lead(Dados), ".*(?=\\s{2,})"), NA), 
           
           CNPJ = ifelse(str_detect(Dados, "Nome do Fundo"), str_extract(lead(Dados), "\\d{2}\\.\\d{3}\\.\\d{3}\\/\\d{4}-\\d{2}"), NA), 
           
           
           across(c(FUNDO, CNPJ), ~ str_squish(.)), 
           
           
           Extração = str_extract_all(Dados, "-?\\d{1,3}(\\.\\d{3})*,\\d+"),
           
           
           `SALDO ANTERIOR` = ifelse(str_detect(Dados, "Saldo Anterior"), Extractor(Extração, 1), NA), 
           
           APLICAÇÕES = ifelse(str_detect(Dados, "Aplicações"), Extractor(Extração, 1), NA), 
           
           RESGATES = ifelse(str_detect(Dados, "Resgates"), Extractor(Extração, 1), NA), 
           
           AMORTIZAÇÃO = NA,
           
           `RENTABILIDADE (%)` = NA, 
           
           RENDIMENTO = ifelse(str_detect(Dados, "Rendimento Bruto"), Extractor(Extração, 1), NA), 
           
           `QTD. DE COTAS` = ifelse(str_detect(Dados, "Saldo Final"), Extractor(Extração, 3), NA), 
           
           COTA = ifelse(str_detect(Dados, "Saldo Final"), Extractor(Extração, 2), NA), 
           
           PL = NA, 
           
           `SALDO ATUAL` = ifelse(str_detect(Dados, "Saldo Final"), Extractor(Extração, 1), NA),
           
           
           across(c(5:14), ~ as.numeric(gsub(",", ".", gsub("\\.", "", .))))) %>% 
    
    
    select(-c(Dados, Extração)) %>% fill(FUNDO, CNPJ) %>% fill(RENDIMENTO, `SALDO ANTERIOR`, APLICAÇÕES, RESGATES, .direction = "up") %>% 
    
    filter(!is.na(`QTD. DE COTAS`)) %>% mutate(`RENTABILIDADE (%)` = round((RENDIMENTO * 100) / `SALDO ANTERIOR`, 4))
  
  
  return(PDF)
  
  
}

# a <- BB.FII("ESTADO - Extrato Cotistas BB Recebiveis Imobiliarios (5).pdf")
