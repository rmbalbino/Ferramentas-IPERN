ServerExtratorOBs <- function(
    input,
    session,
    DadosReativo,
    DownloadLiberadoExtratorOBs
) {

  observe({

    CPF <- gsub(
      "\\D",
      "",
      input$UsuarioExtratorOBs
    )

    Senha <- input$SenhaExtratorOBs

    CNPJ <- gsub(
      "\\D",
      "",
      input$CNPJExtratorOBs
    )

    UG <- gsub(
      "\\D",
      "",
      input$UGExtratorOBs
    )

    Gestao <- gsub(
      "\\D",
      "",
      input$GestaoExtratorOBs
    )

    DadosPessoaisOK <-
      nchar(CPF) == 11 &&
      nchar(Senha) >= 8

    ConfiguracaoOK <-
      !is.null(input$ExercicioExtratorOBs) &&
      nchar(CNPJ) == 14 &&
      nchar(UG) == 6 &&
      nchar(Gestao) == 5 &&
      !is.null(input$DataInicioExtratorOBs) &&
      !is.null(input$DataTerminoExtratorOBs)

    TudoOK <-
      DadosPessoaisOK &&
      ConfiguracaoOK

    updateActionButton(
      session = session,
      inputId = "ExecutarExtratorOBs",
      disabled = !TudoOK
    )

    Etapa <- case_when(
      !DadosPessoaisOK ~ 1,
      !ConfiguracaoOK ~ 2,
      TRUE ~ 3
    )

    session$sendCustomMessage(
      "etapa_extrator_obs",
      list(
        etapa = Etapa
      )
    )
  })


  observe({

    session$sendCustomMessage(
      "estado_download_extrator_obs",
      list(
        liberado = DownloadLiberadoExtratorOBs()
      )
    )
  })


  observeEvent(input$ExecutarExtratorOBs, {

    # VALIDAÇÕES ─────────────────────────────────────────────

    req(
      input$UsuarioExtratorOBs,
      input$SenhaExtratorOBs,
      input$ExercicioExtratorOBs,
      input$CNPJExtratorOBs,
      input$UGExtratorOBs,
      input$GestaoExtratorOBs,
      input$DataInicioExtratorOBs,
      input$DataTerminoExtratorOBs
    )


    CPF <- gsub(
      "\\D",
      "",
      input$UsuarioExtratorOBs
    )

    CNPJ <- gsub(
      "\\D",
      "",
      input$CNPJExtratorOBs
    )

    UG <- gsub(
      "\\D",
      "",
      input$UGExtratorOBs
    )

    Gestao <- gsub(
      "\\D",
      "",
      input$GestaoExtratorOBs
    )


    if (nchar(CPF) != 11) {

      shinybusy::report_failure(
        "CPF inválido",
        "O usuário deve possuir 11 dígitos."
      )

      return()
    }


    if (nchar(input$SenhaExtratorOBs) < 8) {

      shinybusy::report_failure(
        "Senha inválida",
        "A senha deve possuir no mínimo 8 caracteres."
      )

      return()
    }


    if (nchar(CNPJ) != 14) {

      shinybusy::report_failure(
        "CNPJ inválido",
        "O CNPJ deve possuir 14 dígitos."
      )

      return()
    }


    if (nchar(UG) != 6) {

      shinybusy::report_failure(
        "Unidade Gestora inválida",
        "A Unidade Gestora deve possuir 6 dígitos."
      )

      return()
    }


    if (nchar(Gestao) != 5) {

      shinybusy::report_failure(
        "Gestão inválida",
        "A Gestão deve possuir 5 dígitos."
      )

      return()
    }


    if (
      input$DataInicioExtratorOBs >
      input$DataTerminoExtratorOBs
    ) {

      shinybusy::report_failure(
        "Período inválido",
        "A data inicial não pode ser posterior à data final."
      )

      return()
    }


    if (
      !nzchar(
        Sys.getenv("URL_BASE")
      )
    ) {

      shinybusy::report_failure(
        "URL do sistema não configurada",
        "A variável de ambiente URL_BASE não foi encontrada."
      )

      return()
    }


    # PREPARAÇÃO ─────────────────────────────────────────────

    updateActionButton(
      session = session,
      inputId = "ExecutarExtratorOBs",
      disabled = TRUE
    )

    DownloadLiberadoExtratorOBs(FALSE)

    DadosReativo$Dados <- NULL


    session$sendCustomMessage(
      "etapa_extrator_obs",
      list(
        etapa = 3
      )
    )


    Usuario <- CPF

    Senha <- input$SenhaExtratorOBs

    Exercicio <- as.character(
      input$ExercicioExtratorOBs
    )

    DataInicio <- format(
      input$DataInicioExtratorOBs,
      "%d%m%Y"
    )

    DataTermino <- format(
      input$DataTerminoExtratorOBs,
      "%d%m%Y"
    )


    # EXTRAÇÃO ─────────────────────────────────────────────

    b <- NULL

    tryCatch({

      b <- acessar_sistema(
        usuario = Usuario,
        senha = Senha,
        exercicio = Exercicio
      )


      Resultado <- processar_ordens_bancarias(
        b = b,
        cnpj_favorecido = CNPJ,
        data_inicio = DataInicio,
        data_termino = DataTermino,
        unidade_gestora = UG,
        gestao = Gestao
      )


      DadosReativo$Dados <- Resultado

      DownloadLiberadoExtratorOBs(TRUE)


      session$sendCustomMessage(
        "etapa_extrator_obs",
        list(
          etapa = 4
        )
      )


      shinybusy::report_success(
        "Extração finalizada!",
        "As Ordens Bancárias foram extraídas com sucesso."
      )

    }, error = function(e) {

      DadosReativo$Dados <- NULL

      DownloadLiberadoExtratorOBs(FALSE)


      session$sendCustomMessage(
        "etapa_extrator_obs",
        list(
          etapa = 3
        )
      )


      shinybusy::report_failure(
        "Erro durante a extração",
        conditionMessage(e)
      )

    }, finally = {

      if (!is.null(b)) {

        try(
          b$close(),
          silent = TRUE
        )
      }


      updateActionButton(
        session = session,
        inputId = "ExecutarExtratorOBs",
        disabled = FALSE
      )
    })
  })
}
