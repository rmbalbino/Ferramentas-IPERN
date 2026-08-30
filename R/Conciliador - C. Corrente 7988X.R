Conc_Corr <- function(MesAno, Extrato, Razao){

      # Organizando inputs:
      # MesAno <- format(MesAno, "%m/%Y")
      MesAno <- paste0(month(MesAno), "/", year(MesAno))
      Extrato <- Extrair_ExtratoC(Extrato)
      Razao <- Extrair_Razao(Razao)


      # Filtragens e modificacoes necessarias ----------------------------------------------------------------------------

      # Filtrando para obter data correta:
      Extrato <- Extrato %>% filter(str_detect(`Dt. Movimento`, MesAno))
      Razao <- Razao %>% filter(str_detect(Data, MesAno))


      # Cria Extrato filtrado sem coisas que atrapalhem a conciliacao:
      Extrato2 <- Extrato %>%
        filter(!str_detect(Histórico, "l Judicial-Bacen Jud|reviden RF Fluxo|Bloq Judicial-Bacen Jud|Transf Depósito Judicial|DEBITO BLOQ. JUDICIAL"))


      # Cria Extrato filtrado para guardar no arquivo final:
      Extrato.outros <- Extrato %>%
        filter(str_detect(Histórico, "l Judicial-Bacen Jud|reviden RF Fluxo|Bloq Judicial-Bacen Jud|Transf Depósito Judicial|DEBITO BLOQ. JUDICIAL"))


      # Cria Extrato filtrado para Bloqueios e Desbloqueios:
      Extrato.BD <- Extrato.outros %>% filter(`Tipo Valor` != "*", !str_detect(Histórico, "reviden RF Fluxo"))


      # Cria Extrato filtrado para Ordens Bancarias Canceladas:
      # Extrato.OBC <- Extrato.outros %>% filter(str_detect(Histórico, "ORDEM BANC CANCELADA"))


      # Cria Extrato e Razao filtrado por C e D e colunas para identificar a quantidade de vezes que valores aparecem:
      ExtratoC <- Extrato2 %>% filter(`Tipo Valor` == "C") %>% group_by(Valor) %>% mutate(Frequencia = row_number())
      ExtratoD <- Extrato2 %>% filter(`Tipo Valor` == "D") %>% group_by(Valor) %>% mutate(Frequencia = row_number())
      RazaoD   <- Razao %>% filter(`Tipo Movimento` == "D") %>% group_by(Movimento) %>% mutate(Frequencia = row_number())


      # Preparando Razaoc:
      RazaoC1 <- Razao %>% filter(`Tipo Movimento` == "C")


      # Condição lógica para quando não houver crédito no Ficha Razão
    if(nrow(RazaoC1) == 0){

      # Dados para preenchiemento:
      DV <- tibble(Índice = (nrow(Razao) + 1), Data = Razao[nrow(Razao), "Data"], `Unidade Gestora` = Razao[1, "Unidade Gestora"],
                   Gestão = Razao[1, "Gestão"], `Documento Contábil` = paste0("GR", str_extract(Razao$Data[1], "\\d{4}"), "000000"),
                   Evento = "000000", Movimento = 0, `Tipo Movimento` = "C", Saldo = NA, `Tipo Saldo` = "D")

      # Preenchendo data frame vazio:
      RazaoC1 <- DV

    }


      # Criando coluna de frequencia correta para RazaoC:
      RazaoC2 <- RazaoC1 %>%
        group_by(`Documento Contábil`) %>% summarise(Somatorio = round(sum(Movimento), 2)) %>%
        group_by(Somatorio) %>% mutate(Frequencia = row_number())

      # Adicionando frequencia correta e criando RazaoC:
      RazaoC <- RazaoC1 %>% left_join(RazaoC2, by = "Documento Contábil") %>%
        select(-Somatorio) %>% rename_all(~sub("\\.x$", "", .))


      # Somatorio de OBs repetidas (C do Razao):
      RazaoCSoma <- RazaoC %>%
        group_by(`Documento Contábil`) %>%
        mutate(`Índice Razao` = row_number(),
               `Índice Razao` = ifelse(min(Índice) == max(Índice),
                                       paste0(Índice, "*"),
                                       paste0(paste(min(Índice), max(Índice), sep = "-"), "*")),
               Valor = round(sum(Movimento), 2))


      # Somatorio de OBs repetidas e sumarizando-as (C do Razao):
      RazaoCSoma2 <- RazaoCSoma %>%
        summarise(Índice = unique(`Índice Razao`), Valor = unique(Valor)) %>%
        group_by(Valor) %>% mutate(Frequencia = row_number()) #%>% select(-`Documento Contábil`)


      # Criando frequencia de valores C (Extrato sobre Razao C, para conciliar Razao D com Razao C):
      Extrato.Razao_C <- ExtratoC %>%
        select(Índice, Valor, Frequencia) %>% mutate(Índice = as.character(Índice)) %>% bind_rows(RazaoCSoma2) %>%
        group_by(Valor) %>% mutate(`Frequencia C` = row_number()) %>% select(-c(Frequencia, `Documento Contábil`)) %>% rename("Frequencia" = "Frequencia C")



      # Conciliacao do Extrato -------------------------------------------------------------------------------------------

      # Concilia C do Extrato com o D do Razao:
      Conciliacao.Extrato.01 <- ExtratoC %>%

        left_join(RazaoD, by = c("Frequencia", "Valor" = "Movimento")) %>%

        mutate(`Valor Conciliação` = ifelse(!is.na(Índice.y), Valor, NA),
               `Índice Conciliação` = as.character(Índice.y)) %>%

        select(Índice.x, `Dt. Movimento`, `Dt. Balancete`, `Ag. Origem`, Lote, Histórico, Documento, `Documento Contábil`, Valor,
               `Tipo Valor`, Saldo.x, `Tipo Saldo.x`, `Índice Conciliação`, `Valor Conciliação`) %>%

        rename_all(~sub("\\.x$", "", .))



      # Concilia D do Extrato com o C do Razao:
      Conciliacao.Extrato.02 <- ExtratoD %>%

        left_join(RazaoCSoma2, by = c("Frequencia", "Valor")) %>%

        mutate(`Valor Conciliação` = ifelse(!is.na(Índice.y), Valor, NA),
               Índice.y = str_replace_all(Índice.y, "\\*", "")) %>%

        rename_all(~sub("\\.x$", "", .)) %>% rename("Índice Conciliação" = "Índice.y") %>%

        select(Índice, `Dt. Movimento`, `Dt. Balancete`, `Ag. Origem`, Lote, Histórico, Documento, `Documento Contábil`, Valor,
               `Tipo Valor`, Saldo, `Tipo Saldo`, `Índice Conciliação`, `Valor Conciliação`)



      # Empilhando e organizando Extrato conciliado:
      Conciliacao.Extrato <- bind_rows(Conciliacao.Extrato.01,
                                       Conciliacao.Extrato.02, Extrato.outros) %>% arrange(Índice)



      # Conciliacao do Razao ---------------------------------------------------------------------------------------------

      # Concilia D do Razao com o C do Extrato:
      Conciliacao.Razao.01 <- RazaoD %>%

        left_join(Extrato.Razao_C, by = c("Frequencia", "Movimento" = "Valor")) %>%

        mutate(`Valor Conciliação` = ifelse(!is.na(Índice.y), Movimento, NA),
               `Índice Conciliação 2` = ifelse(str_detect(Índice.y, "\\*"), paste0(Índice.x, "*"), NA)) %>%

        rename_all(~sub("\\.x$", "", .)) %>% rename("Índice Conciliação" = "Índice.y")



      # Concilia C do Razao com o D do Razao:
      Conciliacao.Razao.02 <- RazaoCSoma %>%

        left_join(Conciliacao.Razao.01, by = c("Índice Razao" = "Índice Conciliação", "Valor" = "Valor Conciliação")) %>%

        rename_all(~sub("\\.x$", "", .)) %>% rename("Índice Conciliação" = "Índice Conciliação 2") %>%

        select(Índice, Data, `Unidade Gestora`, Gestão, `Documento Contábil`, Evento, Movimento, `Tipo Movimento`, Saldo, `Tipo Saldo`, Frequencia, Valor, `Índice Conciliação`)



      # Concilia C do Razao com o D do Extrato:
      Conciliacao.Razao.02 <- Conciliacao.Razao.02 %>%

        left_join(ExtratoD, by = c("Frequencia", "Valor")) %>%

        mutate(Índice.y = as.character(Índice.y),
               `Índice Conciliação` = coalesce(`Índice Conciliação`, Índice.y),
               Valor = ifelse(!is.na(`Índice Conciliação`), Valor, NA)) %>%

        rename_all(~sub("\\.x$", "", .)) %>% rename("Valor Conciliação" = "Valor") %>%

        select(Índice, Data, `Unidade Gestora`, Gestão, `Documento Contábil`, Evento, Movimento, `Tipo Movimento`, Saldo, `Tipo Saldo`, `Índice Conciliação`, `Valor Conciliação`)



      # Empilhando e organizando Razao conciliado:
      Conciliacao.Razao <- Conciliacao.Razao.01 %>%

        select(-c(Frequencia, `Índice Conciliação 2`)) %>% bind_rows(Conciliacao.Razao.02) %>%

        arrange(Índice) %>% filter(`Documento Contábil` != "GR2025000000")



      # Bloqueios e Desbloqueios -----------------------------------------------------------------------------------------

      # Reformulando tabela:
      Extrato.BD <- Extrato.BD %>%

        pivot_wider(names_from = `Tipo Valor`, values_from = Valor) %>%

        bind_rows(summarise(., across(c(C, D), function(x){ round(sum(x, na.rm = TRUE), 2) }),

                            across(c(Índice, `Dt. Movimento`, `Dt. Balancete`, `Ag. Origem`,
                                     Histórico, Lote, Documento, Saldo, `Tipo Saldo`), function(x){ x = NA }))) %>%

        select(Índice, `Dt. Movimento`, `Dt. Balancete`, `Ag. Origem`, Histórico, Lote, Documento, C, D, Saldo, `Tipo Saldo`)


      # Exportando arquivos ----------------------------------------------------------------------------------------------

      # Guardando planilhas numa lista:
      Planilhas <- list(Extrato = Conciliacao.Extrato, Razão = Conciliacao.Razao,
                        `Bloq. e Desbloq.` = Extrato.BD)


  return(Planilhas)


}

