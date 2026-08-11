# PDF <- pdf_text("Extrato Mensal_RPPS RIO GRANDE DO NORTE_FI BRASIL 2024 I TP RF_31-08-2023.pdf")[[1]]
# PDF <- pdf_text("Extrato Mensal_RPPS RIO GRANDE DO NORTE_FI BRASIL 2024 I TP RF_31-12-2023.pdf")[[1]]


Caixa02 <- function(PDF){
  
  
  # Importando dados:
  PDF <- pdf_text(PDF)[[1]] %>% str_split("\n") %>% unlist() %>% data.frame(Dados = .)
  
  
  # Organizando:
  PDF <- PDF %>% 
    
    mutate(FUNDO = str_extract(Dados[8], ".*(?=CNPJ)"), 
           
           CNPJ = str_extract(Dados[8], "(?<=CNPJ:).*"), 
           
           
           across(c(FUNDO, CNPJ), ~ str_squish(.)),
           
           
           Extração = str_extract_all(Dados, "-?\\d{1,3}(\\.\\d{3})*,\\d+"), 
           
           
           `SALDO ANTERIOR` = ifelse(str_detect(Dados, "Saldo Bruto Anterior"), Extractor(Extração, 1), NA), 
           
           APLICAÇÕES = ifelse(str_detect(Dados, "Aplicações"), Extractor(Extração, 1), NA), 
           
           RESGATES = ifelse(str_detect(Dados, "Resgates"), Extractor(Extração, 1), NA), 
           
           AMORTIZAÇÃO = ifelse(str_detect(Dados, "Mov. Financeiro"), Extractor(lead(Extração), 3), NA), 
           
           `RENTABILIDADE (%)` = ifelse(str_detect(Dados, "Rentabilidade Mês Anterior"), str_extract(Dados, "-?\\d+,\\d+"), NA), 
           
           RENDIMENTO = ifelse(str_detect(Dados, "Rendimento Bruto"), Extractor(Extração, 3), NA), 
           
           `QTD. DE COTAS` = ifelse(str_detect(Dados, "Saldo Bruto Final"), Extractor(Extração, 2), NA), 
           
           COTA = ifelse(str_detect(Dados, "VL Cota Data Fim"), Extractor(Extração, 2), NA), 
           
           PL = NA, 
           
           `SALDO ATUAL` = ifelse(str_detect(Dados, "Saldo Bruto Final"), Extractor(Extração, 3), NA), 
           
           
           across(c(5:14), ~ as.numeric(gsub(",", ".", gsub("\\.", "", .))))) %>% 
    
    
    select(FUNDO, CNPJ, `SALDO ANTERIOR`, APLICAÇÕES, RESGATES, AMORTIZAÇÃO, `RENTABILIDADE (%)`, RENDIMENTO, `QTD. DE COTAS`, COTA, PL, `SALDO ATUAL`) %>% 
    
    
    fill(`SALDO ANTERIOR`, APLICAÇÕES, RESGATES, AMORTIZAÇÃO, RENDIMENTO, `QTD. DE COTAS`, COTA, `SALDO ATUAL`, .direction = "up") %>% 
    
    filter(!is.na(`RENTABILIDADE (%)`))
  
  
  return(PDF)
  
  
}
