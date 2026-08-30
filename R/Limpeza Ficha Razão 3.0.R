# ORGANIZANDO FICHA RAZÃO ===================================================================================================================================

# Tratar pdf do Razao ----------------------------------------------------------------------------------------------

Extrair_Razao <- function(RAZAO){



      # Importando dados:
      Ficha_Razao.PDF <- pdf_text(RAZAO)

      # Organizacao inicial:
      Ficha_Razao.PDF <- Ficha_Razao.PDF %>%
        strsplit("\n") %>% unlist() %>%           # Organiza por pagina e linhas numa lista %>% junta todas as listas
        data.frame(Dados = .) %>%                 # Tranforma num objeto dataframe
        filter(str_detect(Dados, ",")) %>%        # Filtra todas as linhas que possuem virgula
        tail(-1)                                  # Exclui a primeira linha


      # Padronizacao:
      Ficha_Razao <- map(Ficha_Razao.PDF$Dados, function(x){

        # Retirando espacos excessivos:
        x <- trimws(x)

        # Separando itens por espaco:
        x <- x %>% str_split(" +") %>% unlist()

        # Resolvendo o problema de itens estornados:
        if(length(x) > 9){ x = c(x[1:4], paste(x[5:6], collapse = " "), x[7:10]) } else { x = x } })


      # Juntando itens:
      Ficha_Razao <- as.data.frame(do.call(rbind, Ficha_Razao)) %>%   # Pega os itens da lista, empilha e coloca num dataframe
        mutate(Índice = seq(1, nrow(.), 1)) %>%                       # Criando coluna Índice
        select(10, 1:9)


      # Renomeando colunas:
      names(Ficha_Razao)[-1] <- c("Data", "Unidade Gestora", "Gestão", "Documento Contábil",
                                  "Evento", "Movimento", "Tipo Movimento", "Saldo", "Tipo Saldo")


      # Convertendo as colunas Movimento e Saldo para numerico:
      Ficha_Razao <- Ficha_Razao %>% mutate_at(vars(Movimento, Saldo),
                                               ~ as.numeric(gsub(",", ".", gsub("\\.", "", .))))


      return(Ficha_Razao)


}

