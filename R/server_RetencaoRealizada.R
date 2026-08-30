ServerRetencaoRealizada <- function(
    input,
    session,
    CompetenciaConfirmadaRR,
    DownloadLiberadoRR,
    ArquivoSelecionadoRR,
    ArquivoCNPJSelecionadoRR
) {

  observeEvent(input$ConfirmarCompetenciaRR, {

    NovoEstado <- !isTRUE(
      CompetenciaConfirmadaRR()
    )

    CompetenciaConfirmadaRR(
      NovoEstado
    )

    session$sendCustomMessage(
      "estado_competencia_rr",
      list(
        confirmada = NovoEstado
      )
    )

    TemRR <- isTRUE(
      ArquivoSelecionadoRR()
    )

    TemCNPJ <- isTRUE(
      ArquivoCNPJSelecionadoRR()
    )


    if (NovoEstado) {

      session$sendCustomMessage(
        "etapa_rr",
        list(
          etapa = if (TemRR && TemCNPJ) 3 else 2
        )
      )

    } else {

      DownloadLiberadoRR(FALSE)
      ArquivoSelecionadoRR(FALSE)
      ArquivoCNPJSelecionadoRR(FALSE)

      updateActionButton(
        session = session,
        inputId = "ExecutarRR",
        disabled = TRUE
      )

      session$sendCustomMessage(
        "estado_upload_rr",
        list(
          carregado = FALSE
        )
      )

      session$sendCustomMessage(
        "estado_upload_rr_cnpj",
        list(
          carregado = FALSE
        )
      )

      session$sendCustomMessage(
        "etapa_rr",
        list(
          etapa = 1
        )
      )

    }

  })


  observe({

    TemRR <- isTRUE(
      ArquivoSelecionadoRR()
    )

    TemCNPJ <- isTRUE(
      ArquivoCNPJSelecionadoRR()
    )

    CompetenciaOK <- isTRUE(
      CompetenciaConfirmadaRR()
    )

    ArquivosOK <- TemRR && TemCNPJ

    updateActionButton(
      session = session,
      inputId = "ExecutarRR",
      disabled = !(CompetenciaOK && ArquivosOK)
    )

    session$sendCustomMessage(
      "estado_upload_rr",
      list(
        carregado = TemRR
      )
    )

    session$sendCustomMessage(
      "estado_upload_rr_cnpj",
      list(
        carregado = TemCNPJ
      )
    )

    if (CompetenciaOK) {

      session$sendCustomMessage(
        "etapa_rr",
        list(
          etapa = if (ArquivosOK) 3 else 2
        )
      )

    }

  })


  observe({

    session$sendCustomMessage(
      "estado_download_rr",
      list(
        liberado = isTRUE(
          DownloadLiberadoRR()
        )
      )
    )

  })


  observeEvent(
    input$BotaoRR,
    {

      DownloadLiberadoRR(FALSE)

      TemRR <- !is.null(input$BotaoRR) &&
        NROW(input$BotaoRR) > 0

      ArquivoSelecionadoRR(
        TemRR
      )

      session$sendCustomMessage(
        "estado_upload_rr",
        list(
          carregado = TemRR
        )
      )

      TemCNPJ <- isTRUE(
        ArquivoCNPJSelecionadoRR()
      )

      CompetenciaOK <- isTRUE(
        CompetenciaConfirmadaRR()
      )

      updateActionButton(
        session = session,
        inputId = "ExecutarRR",
        disabled = !(CompetenciaOK && TemRR && TemCNPJ)
      )

    },
    ignoreInit = TRUE
  )


  observeEvent(
    input$BotaoRRCNPJ,
    {

      DownloadLiberadoRR(FALSE)

      TemCNPJ <- !is.null(input$BotaoRRCNPJ) &&
        NROW(input$BotaoRRCNPJ) > 0

      ArquivoCNPJSelecionadoRR(
        TemCNPJ
      )

      session$sendCustomMessage(
        "estado_upload_rr_cnpj",
        list(
          carregado = TemCNPJ
        )
      )

      TemRR <- isTRUE(
        ArquivoSelecionadoRR()
      )

      CompetenciaOK <- isTRUE(
        CompetenciaConfirmadaRR()
      )

      updateActionButton(
        session = session,
        inputId = "ExecutarRR",
        disabled = !(CompetenciaOK && TemRR && TemCNPJ)
      )

    },
    ignoreInit = TRUE
  )

}



ProcessarRetencaoRealizada <- function(
    input,
    session,
    ObservFunction,
    DownloadLiberadoRR
) {

  observeEvent(input$ExecutarRR, {

    updateActionButton(
      session = session,
      inputId = "ExecutarRR",
      disabled = TRUE
    )

    DownloadLiberadoRR(FALSE)

    session$sendCustomMessage(
      "etapa_rr",
      list(
        etapa = 3
      )
    )

    tryCatch({

      ObservFunction(
        MesAno = input$MesAnoRR,
        Função = Format_Retenção(
          input$BotaoRR$datapath,
          input$BotaoRRCNPJ$datapath
        )
      )

      DownloadLiberadoRR(TRUE)

      session$sendCustomMessage(
        "etapa_rr",
        list(
          etapa = 4
        )
      )

      shinybusy::report_success(
        "Organização finalizada!",
        "O arquivo foi processado com sucesso e está pronto para download."
      )

    }, error = function(e) {

      DownloadLiberadoRR(FALSE)

      session$sendCustomMessage(
        "etapa_rr",
        list(
          etapa = 3
        )
      )

      shinybusy::report_failure(
        "Erro durante o processamento",
        conditionMessage(e)
      )

      updateActionButton(
        session = session,
        inputId = "ExecutarRR",
        disabled = FALSE
      )

    })

  })

}
