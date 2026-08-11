# PACOTES ==========================================================================================================

# install.packages("pacman")
# pacman::p_load(rio, pdftools, tesseract, tidyverse)
#
# # Diretorio:
# diretorio <- r"(D:\Material de Estudos\IPERN\Scripts R\Folhas de Pagamento\Folhas\2025\6 - Junho\Escaneadas\Teste\Servidor)"
#
# setwd(diretorio)

# a <- Ext_FPag(ORGAOS = r"(H:\Estagio\Scripts R\Órgãos.xlsx)",
#               NOMES = list.files(pattern = "*.pdf|*.PDF"),
#               ARQUIVOS = list.files(pattern = "*.pdf|*.PDF"), DECIMO = "Não")



# Função de extração:
Ext_FPagS <- function(COMPETÊNCIA, NOMES, ARQUIVOS, DECIMO){


  # Manipulando mensagens:
  tryCatch(


    # Especificando expressão:
    expr = {



      # PRIMEIROS PASSOS =================================================================================================

      # Retirando notacao cientifica:
      options(scipen = 999)

      # Idioma português para pdfs escaneados:
      # tesseract_download("por")


      # Verificando se tem 13º:
      `Décimo Terceiro` <- DECIMO
      # `Décimo Terceiro` <- "Não"
      # `Décimo Terceiro` <- "Sim"


      # Competência:
      COMPETÊNCIA <- floor_date(COMPETÊNCIA, "month")
      # COMPETÊNCIA <- floor_date(dmy("01/01/2023"))



      # Importando pdfs  -------------------------------------------------------------------------------------------------

      # O shiny obriga a separação de nomes e arquivos:
      NOMES.FOLHAS <- NOMES[str_detect(NOMES, "\\.pdf|\\.PDF")]
      ARQUIVOS.FOLHAS <- ARQUIVOS[str_detect(ARQUIVOS, "\\.pdf|\\.PDF")]
      # NOMES.FOLHAS <- list.files(pattern = "*.pdf|*.PDF")
      # ARQUIVOS.FOLHAS <- list.files(pattern = "*.pdf|*.PDF")


      # Importando e guardando numa lista:
      FOLHAS.ESCANEADAS.S <- map2(NOMES.FOLHAS, ARQUIVOS.FOLHAS, function(x, y){


        Folhas <- paste0(pdf_ocr_text(y, language = "por",

                                      options = list(tessedit_pageseg_mode = 4)), x) |> str_split("\n")

        # Eliminar paginas que contenham TODAS AS SECRETARIAS:
        discard(Folhas, ~ any(str_detect(.x, "^TOTAL GERAL|TODAS AS SECRETARIAS"))) }) |> unlist() |> data.frame(Dados = _)



      # MANIPULACAO DE DADOS =============================================================================================

      # Servidor ---------------------------------------------------------------------------------------------------------

      FL.Servidor2 <- FOLHAS.ESCANEADAS.S |>


        mutate(

          PDF = if_else(str_detect(Dados, "\\.pdf|\\.PDF"), Dados, NA_character_),

          Emissão = if_else(str_detect(Dados, "(?=.*\\d{2}-\\d{2}-\\d{4})(?=.*\\d{2}:\\d{2}:\\d{2})"), Dados, NA_character_),

          MesAno = if_else(str_detect(Dados, "(?=.*Folha)(?=.*\\d{2}\\/\\d{4})"), Dados, NA_character_),

          Setor = if_else(str_detect(Dados, "(?=.*^[0-9])(?=.*[A-Za-z])|^FUNDACAO") &
                            !str_detect(Dados, "\\d{2}\\/\\d{4}"), Dados, NA_character_),

          Valores = if_else(str_detect(Dados, "^DESCONTOS|^VANTAGENS|(?=.*Vantagem)(?=.*Desconto)|\\d{2}/\\d{4}") &
                              !str_detect(Dados, "(?=.*Folha)(?=.*\\d{2}\\/\\d{4})"), Dados, NA_character_)


        ) |>

        fill(PDF, .direction = "up") |> group_by(PDF) |> mutate(Emissão = if(any(!is.na(Emissão))) Emissão else "VAZIO") |> ungroup() |>

        fill(Emissão, MesAno, Setor) |> filter(!is.na(Valores)) |> mutate(Emissão = if_else(Emissão == "VAZIO", NA_character_, Emissão))



      # Extraindo informacoes das linhas e fazendo ajustes:
      FL.Servidor3 <- FL.Servidor2 |>

        # Criando colunas:
        mutate(Contribuinte = "Servidor",

               PDF = str_replace(PDF, "\\.pdf|\\.PDF", ""),

               Emissão = dmy_hms(str_extract(Emissão, "\\d+(.*)")),

               Competência = dmy(paste0("01/", str_extract(MesAno, "\\d{2}/\\d{4}"))), # Extrai o formato texto e tranforma em data


               Código = str_extract(Setor, "\\d+|FUNDACAO DE AT"), # Em alguns pdfs fundase não possui código

               Código = as.character(ifelse(Código == "FUNDACAO DE AT", "24500000000000", Código)),

               Setor = str_squish(str_extract(Setor, paste0("(?<=", Código, ").*"))),
               Setor = if_else(Código == "24500000000000", "FUNDACAO DE ATENDIMENTO SOCIOEDUCATIVO DO RN - FUNDASE", Setor),
               Setor = str_trim(str_remove(Setor, "^-")),

               Código = ifelse(Código == "21910200000000" &
                                 str_detect(Setor, "PENSOES DA SEC SEGURANCA"), "21910200000001", Código), # Ajustando codigo da PENSOES DA SEC SEGURANCA

               # Código = ifelse(Código == "11700100000000" &
               #                   str_detect(Secretaria, "SETOR PARA BOLSISTA"), "11700100000000A", Código), # Ajustando codigo do FAPERN/CONTROL ESTAGIO


               `Divisão Folha` = str_extract(Valores, "DESCONTOS|VANTAGENS"),


               Valor = ifelse(!str_detect(Valores, "(?=.*Vantagem)(?=.*Desconto)"), str_extract(Valores, "-?\\d{1,3}(\\.\\d{3})*,\\d{2}"), NA), # Extrai o formato numerico (positivo ou negativo)


               Direitotxt = trimws(str_extract(Valores, "\\d{2}/\\d{4}(?=\\s*\\d+\\s*\\-?\\d{1,3}(\\.\\d{3})*,\\d{2})")), # Direito em texto

               Direito = dmy(paste0("01/", Direitotxt)), # Direito em formato data. haverá mensagem do R, mas são NAs, tudo ok


               Rubrica = ifelse(!str_detect(Valores, "(?=.*Vantagem)(?=.*Desconto)"), str_squish(str_extract(Valores, paste0(".*?(?=", Direitotxt, ")"))), NA),

               `Rubrica Cod` = as.numeric(str_extract(Rubrica, "\\d+")), # Extrai os primeiros digitos da rubrica


               Servidores = str_extract(Valores, paste0("(?<=", Direitotxt, ")\\s*\\d+")), # Retorna a competência onde os servidores trabalharam


               across(c(Valor, Servidores), ~ as.numeric(gsub(",", ".", gsub("\\.", "", .)))) # Transformando formato das colunas para numerico


        ) |> fill(`Divisão Folha`) |> filter(!is.na(Rubrica)) |>


        group_by(PDF, Código, Setor, `Divisão Folha`) |>

        mutate(`Total Vantagens` = if_else(str_detect(`Divisão Folha`, "VANTAGENS"), round(sum(Valor, na.rm = T), 2), NA),

               `Total Descontos` = if_else(str_detect(`Divisão Folha`, "DESCONTOS"), round(sum(Valor, na.rm = T), 2), NA)) |>


        group_by(PDF, Código, Setor) |>

        mutate(`Total Descontos` = if_else(is.na(`Total Descontos`) &
                                             !any(str_detect(`Divisão Folha`, "DESCONTOS")), 0, `Total Descontos`)) |>


        ungroup() |> fill(`Total Vantagens`) |> fill(`Total Descontos`, .direction = "up") |>


        mutate(IDFolha = as.numeric(str_extract(MesAno, "\\d+$|\\d+\\s*$")),
               `Folha Específica` = case_when(IDFolha == 1 ~ "Normal", IDFolha == 2 ~ "Pensão",

                                              # Folhas de adiantamento:
                                              str_detect(PDF, "(?=.*(\\bAD\\b|ADT))(?=.*13º)(?=.*PENS)") ~ "13º ADT Pensão",
                                              str_detect(PDF, "(?=.*(\\bAD\\b|ADT))(?=.*13º)") ~ "13º ADT Normal",
                                              str_detect(PDF, "(?=.*(\\bAD\\b|ADT))(?=.*PENS)") ~ "ADT Pensão",
                                              str_detect(PDF, "\\bAD\\b|ADT") ~ "ADT Normal",

                                              # Outras suplementares:
                                              str_detect(PDF, "(?=.*(SUPLE|NTAR|PISO))(?=.*PENS)(?=.*13º)") ~ "13º Suplementar Pensão",
                                              str_detect(PDF, "(?=.*(SUPLE|NTAR|PISO))(?=.*13º)") ~ "13º Suplementar Normal",

                                              str_detect(PDF, "REA|USTE") &
                                                str_detect(PDF, "PENS") ~ "Reajuste Pensão",
                                              str_detect(PDF, "EST|RNO") &
                                                str_detect(PDF, "PENS") ~ "Estorno Pensão",
                                              str_detect(PDF, "SUPLE|NTAR|PISO") &
                                                str_detect(PDF, "PENS") ~ "Suplementar Pensão",
                                              str_detect(PDF, "PRODUT|PODUT") ~ "Produtividade",
                                              str_detect(PDF, "PAE|PAI") ~ "PAE",
                                              str_detect(PDF, "PLANT") ~ "Plantão",
                                              str_detect(PDF, "SUPLE|NTAR|PISO") ~ "Suplementar Normal",
                                              str_detect(PDF, "REA|USTE") ~ "Reajuste Normal",
                                              str_detect(PDF, "EST|RNO") ~ "Estorno Normal",
                                              str_detect(PDF, "MAG") ~ "Magisterio",

                                              # Normais de décimo terceiro:
                                              `Décimo Terceiro` == "Sim" & str_detect(PDF, "(?=.*13º)(?=.*PENS)") ~ "13º Pensão",
                                              `Décimo Terceiro` == "Sim" & str_detect(PDF, "13º") ~ "13º Normal",

                                              # Demais:
                                              str_detect(PDF, "PROD") ~ "Produtividade",
                                              IDFolha > 3 ~ "Suplementar",
                                              IDFolha == 3 ~ "ADT",


               ),

               Folha = case_when(str_detect(`Folha Específica`, "Suplementar|Estorno|Magisterio|Reajuste") ~ "Suplementar",
                                 str_detect(`Folha Específica`, "ADT") ~ "ADT",
                                 str_detect(`Folha Específica`, "PAE") ~ "PAE", # PAE pensão entra aqui
                                 str_detect(`Folha Específica`, "Plantão") ~ "Plantão",
                                 str_detect(`Folha Específica`, "Produtividade") ~ "Produtividade",
                                 str_detect(`Folha Específica`, "Normal|Pensão") ~ "Normal")

        ) |>


        select(Contribuinte, PDF, Emissão, Competência, Código, Setor, `Divisão Folha`, Direito, `Rubrica Cod`, Rubrica,
               Valor, Servidores, `Total Vantagens`, `Total Descontos`, Folha, `Folha Específica`, IDFolha) |>


        # Elimina PDFs duplicados com análise por grupo e seleciona o mais recente:
        group_by(PDF) |>

        mutate(TotalLinhas = n()) |>

        group_by(Código, Setor, IDFolha, .add = T) |>

        mutate(SomaRubCod = sum(`Rubrica Cod`),

               SomaDireito = sum(as.numeric(Direito)),

               SomaServidores = sum(Servidores)) |>

        group_by(Contribuinte, Competência, Código, Setor, IDFolha, SomaDireito,
                 `Total Vantagens`, `Total Descontos`, SomaRubCod, SomaServidores) |>

        mutate(IDGrupo = cur_group_id(),
               Emissão2 = if_else(is.na(Emissão), as.POSIXct("1900-01-01 00:00:00"), Emissão)) |>

        group_by(IDGrupo) |>

        filter(TotalLinhas == max(TotalLinhas)) |> # Se o IDGrupo for igual, seleciona o pdf com mais linhas

        filter(Emissão2 == max(Emissão2)) |>       # Se o IDGrupo for igual, seleciona a Emissão mais recente

        filter(PDF == min(PDF)) |> ungroup() |>    # Se o IDGrupo for igual, seleciona o pdf de menor nome

        group_by(Competência, Código, Setor, IDFolha) |>

        filter(if (any(is.na(Emissão))) TRUE else Emissão == max(Emissão)) |> # Se o agrupamento não possuir NA, seleciona a Emissão mais recente

        select(-c(SomaRubCod, SomaDireito, SomaServidores, IDGrupo, TotalLinhas, Emissão2)) |>

        arrange(PDF, Código, Setor, `Rubrica Cod`) |> rowid_to_column("Índice")


      # Verificar mais de uma competência no mês:
      FL.ServidorM <- FL.Servidor3 |>

        mutate(Alerta = if_else(Competência != COMPETÊNCIA, "Competência divergente", "OK")) |>

        filter(Alerta == "Competência divergente") |>

        distinct(PDF, Código, Setor, Competência, Emissão, IDFolha, `Total Vantagens`, Alerta)


      # Identificando duplicados (mais de um total de vantagens por Setor):
      FL.ServidorD <- FL.Servidor3 |>

        distinct(PDF, Código, Setor, Competência, Emissão, IDFolha, `Total Vantagens`) |>

        group_by(Competência, Código, Setor, IDFolha) |> mutate(Alerta = n(), Alerta = if_else(Alerta > 1, "Vantagem excedente", "OK")) |>

        filter(Alerta == "Vantagem excedente")


      # Empilhando alertas:
      FL.ServidorAlerta <- bind_rows(FL.ServidorM, FL.ServidorD) |> arrange(Alerta, Código, IDFolha, Emissão, PDF)



      # Exportando tabelas -----------------------------------------------------------------------------------------------

      # Guardando numa lista:
      Planilhas <- list(FL.ServidorAlerta, FL.Servidor3)

      # Renomeando:
      names(Planilhas) <- c("Alerta Servidor", "Folhas")


      # Notificacao de sucesso:
      report_success("Organização Finalizada!", "Agora selecione a pasta de sua preferência para baixar o arquivo e utilizá-lo em suas atividades.")


      return(Planilhas)


    }, # Fim do sucesso


    # Especificando menssagem de erro:
    error = function(e){ report_failure("Erro!", "Verifique se você selecionou os dados corretos.")} ) # Fim do erro


}



# PATRONAL =========================================================================================================

# install.packages("pacman")
# pacman::p_load(rio, pdftools, tesseract, tidyverse)
#
# # Diretorio:
# diretorio <- r"(D:\Material de Estudos\IPERN\Scripts R\Folhas de Pagamento\Folhas\2025\6 - Junho\Escaneadas\Teste\Patronal)"
#
# setwd(diretorio)


# Função de extração:
Ext_FPagP <- function(COMPETÊNCIA, NOMES, ARQUIVOS, DECIMO){


  # Manipulando mensagens:
  tryCatch(


    # Especificando expressão:
    expr = {



      # PRIMEIROS PASSOS =================================================================================================

      # Retirando notacao cientifica:
      options(scipen = 999)

      # Idioma português para pdfs escaneados:
      # tesseract_download("por")


      # Verificando se tem 13º:
      `Décimo Terceiro` <- DECIMO
      # `Décimo Terceiro` <- "Não"
      # `Décimo Terceiro` <- "Sim"


      # Competência:
      COMPETÊNCIA <- floor_date(COMPETÊNCIA, "month")
      # COMPETÊNCIA <- floor_date(dmy("01/01/2023"))



      # Importando pdfs  -------------------------------------------------------------------------------------------------

      NOMES.FOLHAS <- NOMES
      ARQUIVOS.FOLHAS <- ARQUIVOS
      # NOMES.FOLHAS <- list.files(pattern = "*.pdf|*.PDF")
      # ARQUIVOS.FOLHAS <- list.files(pattern = "*.pdf|*.PDF")


      # Importando e guardando numa lista:
      FOLHAS.ESCANEADAS.P <- map2(NOMES.FOLHAS, ARQUIVOS.FOLHAS, function(x, y){


        Folhas <- paste0(pdf_ocr_text(y, language = "por",

                                      options = list(tessedit_pageseg_mode = 4)), x) |> str_split("\n")

        # Eliminar paginas que contenham TODAS AS SECRETARIAS:
        discard(Folhas, ~ any(str_detect(.x, "^TOTAL GERAL|TODAS AS SECRETARIAS"))) }) |> unlist() |> data.frame(Dados = _)



      # Patronal ---------------------------------------------------------------------------------------------------------

      # Preparando base de dados inicial:
      FL.Patronal2 <- FOLHAS.ESCANEADAS.P |> mutate(


        PDF = if_else(str_detect(Dados, "\\.pdf|\\.PDF"), Dados, NA_character_),

        Emissão = if_else(str_detect(Dados, "(?=.*\\d{2}-\\d{2}-\\d{4})(?=.*\\d{2}:\\d{2}:\\d{2})"), Dados, NA_character_),

        MesAno = if_else(str_detect(Dados, "(?=.*mes ano)(?=.*\\d{2}\\/\\d{4})"), Dados, NA_character_),

        Setor = if_else(str_detect(Dados, "(?=.*Secretaria)(?=.*[0-9])|FUNDACAO") &
                          !str_detect(Dados, "Referência|RELRN|-?\\d{1,3}(\\.\\d{3})*,\\d{2}"), Dados, NA_character_),

        Valores = if_else(str_detect(Dados, "Classificação|\\d{4}\\.\\d{2}\\.\\d{2}|-?\\d{1,3}(\\.\\d{3})*,\\d{2}"), Dados, NA_character_),
        Valores = str_remove_all(Valores, "^\\W+|\\W+$")

      ) |>

        fill(PDF, .direction = "up") |> group_by(PDF) |> mutate(Emissão = if(any(!is.na(Emissão))) Emissão else "VAZIO") |> ungroup() |>

        fill(Emissão, MesAno, Setor) |> filter(!is.na(Valores)) |> mutate(Emissão = if_else(Emissão == "VAZIO", NA_character_, Emissão))


      # Extraindo informacoes das linhas:
      FL.Patronal3 <- FL.Patronal2 |>

        # Criando colunas:
        mutate(Contribuinte = "Patronal",

               PDF = str_replace(PDF, "\\.pdf|\\.PDF", ""),

               Emissão = dmy_hms(str_extract(Emissão, "\\d+(.*)")),


               Competência = dmy(paste0("01/", str_extract(MesAno, "\\d{2}/\\d{4}"))), # Extrai o formato texto e tranforma em data


               Código = str_extract(Setor, "\\d+|FUNDACAO DE AT"), # Em alguns pdfs fundase não possui código

               Código = as.character(ifelse(Código == "FUNDACAO DE AT", "24500000000000", Código)),

               Setor = str_squish(str_extract(Setor, paste0("(?<=", Código, ").*"))),
               Setor = if_else(Código == "24500000000000", "FUNDACAO DE ATENDIMENTO SOCIOEDUCATIVO DO RN - FUNDASE", Setor),
               Setor = str_trim(str_remove(Setor, "^-")),

               Código = ifelse(Código == "21910200000000" &
                                 str_detect(Setor, "PENSOES DA SEC SEGURANCA"), "21910200000001", Código), # Ajustando codigo da PENSOES DA SEC SEGURANCA


               Classificação = str_extract(Valores, "Classificação(.*)"),

               Natureza = str_extract(Valores, "\\d{4}\\.\\d{2}\\.\\d{2}.*"),

               Subelemento = ifelse(str_detect(Valores, "Qtd Func"), str_squish(str_extract(Valores, ".*?(?=\\s\\d)")), NA),


               Rubrica = ifelse(str_detect(Valores,
                                           "Classificação|Qtd Func|Total do Elemento de Despesa|Total Secretaria"),
                                NA, str_squish(str_extract(Valores, ".*(?=\\s*-?\\d{1,3}(\\.\\d{3})*,\\d{2})"))), # Extrai o que está antes do valor

               `Rubrica Cod` = as.numeric(str_extract(Rubrica, "\\d+")), # Extrai os primeiros digitos da rubrica


               Valor = if_else(!is.na(`Rubrica Cod`), str_trim(str_extract(Valores, "-?\\d{1,3}(\\.\\d{3})*,\\d{2}")), NA),                 # Extrai o valor


               Servidores = if_else(!is.na(`Rubrica Cod`), str_extract(Valores, "\\b\\d+$"), NA),


               IDFolha = as.numeric(str_extract(MesAno, "(?<=folha:).*(?=grupo)")),
               `Folha Específica` = case_when(IDFolha == 1 ~ "Normal", IDFolha == 2 ~ "Pensão",

                                              # Folhas de adiantamento:
                                              str_detect(PDF, "(?=.*(\\bAD\\b|ADT))(?=.*13º)(?=.*PENS)") ~ "13º ADT Pensão",
                                              str_detect(PDF, "(?=.*(\\bAD\\b|ADT))(?=.*13º)") ~ "13º ADT Normal",
                                              str_detect(PDF, "(?=.*(\\bAD\\b|ADT))(?=.*PENS)") ~ "ADT Pensão",
                                              str_detect(PDF, "\\bAD\\b|ADT") ~ "ADT Normal",

                                              # Outras suplementares:
                                              str_detect(PDF, "(?=.*(SUPLE|NTAR|PISO))(?=.*PENS)(?=.*13º)") ~ "13º Suplementar Pensão",
                                              str_detect(PDF, "(?=.*(SUPLE|NTAR|PISO))(?=.*13º)") ~ "13º Suplementar Normal",

                                              str_detect(PDF, "REA|USTE") &
                                                str_detect(PDF, "PENS") ~ "Reajuste Pensão",
                                              str_detect(PDF, "EST|RNO") &
                                                str_detect(PDF, "PENS") ~ "Estorno Pensão",
                                              str_detect(PDF, "SUPLE|NTAR|PISO") &
                                                str_detect(PDF, "PENS") ~ "Suplementar Pensão",
                                              str_detect(PDF, "PRODUT|PODUT") ~ "Produtividade",
                                              str_detect(PDF, "PAE|PAI") ~ "PAE",
                                              str_detect(PDF, "PLANT") ~ "Plantão",
                                              str_detect(PDF, "SUPLE|NTAR|PISO") ~ "Suplementar Normal",
                                              str_detect(PDF, "REA|USTE") ~ "Reajuste Normal",
                                              str_detect(PDF, "EST|RNO") ~ "Estorno Normal",
                                              str_detect(PDF, "MAG") ~ "Magisterio",

                                              # Normais de décimo terceiro:
                                              `Décimo Terceiro` == "Sim" & str_detect(PDF, "(?=.*13º)(?=.*PENS)") ~ "13º Pensão",
                                              `Décimo Terceiro` == "Sim" & str_detect(PDF, "13º") ~ "13º Normal",

                                              # Demais:
                                              str_detect(PDF, "PROD") ~ "Produtividade",
                                              IDFolha > 3 ~ "Suplementar",
                                              IDFolha == 3 ~ "ADT",


               ),

               Folha = case_when(str_detect(`Folha Específica`, "Suplementar|Estorno|Magisterio|Reajuste") ~ "Suplementar",
                                 str_detect(`Folha Específica`, "ADT") ~ "ADT",
                                 str_detect(`Folha Específica`, "PAE") ~ "PAE", # PAE pensão entra aqui
                                 str_detect(`Folha Específica`, "Plantão") ~ "Plantão",
                                 str_detect(`Folha Específica`, "Produtividade") ~ "Produtividade",
                                 str_detect(`Folha Específica`, "Normal|Pensão") ~ "Normal"),


               across(c(Valor, Servidores), ~ as.numeric(gsub(",", ".", gsub("\\.", "", .))))        # Transformando formato das colunas para numerico:


        ) |> fill(c(Classificação, Natureza, Subelemento)) |> filter(!is.na(`Rubrica Cod`)) |>


        group_by(PDF, Código, Setor, Classificação, Natureza) |>

        mutate(`Total do Elemento de Despesa` = round(sum(Valor, na.rm = T), 2)) |>


        group_by(PDF, Código, Setor) |>

        mutate(`Total Secretaria` = round(sum(Valor, na.rm = T), 2)) |> ungroup() |>


        select(Contribuinte, PDF, Emissão, Competência, Código, Setor, Classificação, Natureza, Subelemento, `Rubrica Cod`, Rubrica,
               Valor, Servidores, `Total do Elemento de Despesa`, `Total Secretaria`, Folha, `Folha Específica`, IDFolha) |>


        # Elimina PDFs duplicados com análise por grupo e seleciona o mais recente:
        group_by(PDF) |>

        mutate(TotalLinhas = n()) |>

        group_by(Código, Setor, IDFolha, .add = T) |>

        mutate(SomaRubCod = sum(`Rubrica Cod`),

               SomaServidores = sum(Servidores)) |>

        group_by(Contribuinte, Competência, Código, Setor, IDFolha,
                 `Total Secretaria`, SomaRubCod, SomaServidores) |>

        mutate(IDGrupo = cur_group_id(),
               Emissão2 = if_else(is.na(Emissão), as.POSIXct("1900-01-01 00:00:00"), Emissão)) |>

        group_by(IDGrupo) |>

        filter(TotalLinhas == max(TotalLinhas)) |> # Se o IDGrupo for igual, seleciona o pdf com mais linhas

        filter(Emissão2 == max(Emissão2)) |>       # Se o IDGrupo for igual, seleciona a Emissão mais recente

        filter(PDF == min(PDF)) |> ungroup() |>    # Se o IDGrupo for igual, seleciona o pdf de menor nome

        group_by(Competência, Código, Setor, IDFolha) |>

        filter(if (any(is.na(Emissão))) TRUE else Emissão == max(Emissão)) |> # Se o agrupamento não possuir NA, seleciona a Emissão mais recente

        select(-c(SomaRubCod, SomaServidores, IDGrupo, TotalLinhas, Emissão2)) |>

        arrange(PDF, Código, Setor, Classificação, Natureza, Subelemento, `Rubrica Cod`) |> rowid_to_column("Índice")


      # Verificar mais de uma competência no mês:
      FL.PatronalM <- FL.Patronal3 |>

        mutate(Alerta = if_else(Competência != COMPETÊNCIA, "Competência divergente", "OK")) |>

        filter(Alerta == "Competência divergente") |>

        distinct(PDF, Código, Setor, Competência, Emissão, IDFolha, `Total Secretaria`, Alerta)


      # Identificando duplicados (mais de um total Setor):
      FL.PatronalD <- FL.Patronal3 |>

        distinct(PDF, Código, Setor, Competência, Emissão, IDFolha, `Total Secretaria`) |>

        group_by(Competência, Código, Setor, IDFolha) |> mutate(Alerta = n(), Alerta = if_else(Alerta > 1, "Total excedente", "OK")) |>

        filter(Alerta == "Total excedente")


      # Empilhando alertas:
      FL.PatronalAlerta <- bind_rows(FL.PatronalM, FL.PatronalD) |> arrange(Alerta, Código, IDFolha, Emissão, PDF)



      # Exportando tabelas -----------------------------------------------------------------------------------------------

      # Guardando numa lista:
      Planilhas <- list(FL.PatronalAlerta, FL.Patronal3)

      # Renomeando:
      names(Planilhas) <- c("Alerta Patronal", "Folhas")


      # Notificacao de sucesso:
      report_success("Organização Finalizada!", "Agora selecione a pasta de sua preferência para baixar o arquivo e utilizá-lo em suas atividades.")


      return(Planilhas)


    }, # Fim do sucesso


    # Especificando menssagem de erro:
    error = function(e){ report_failure("Erro!", "Verifique se você selecionou os dados corretos.")} ) # Fim do erro


}


