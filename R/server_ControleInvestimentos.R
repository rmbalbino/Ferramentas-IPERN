ServerControleInvestimentos <- function(
    input,
    session,
    CompetenciaConfirmadaInvestimento,
    DownloadLiberadoInvestimento,
    ArquivoSelecionadoInvestimento,
    ArquivoArtigosSelecionadoInvestimento
) {

  observeEvent(input$ConfirmarCompetenciaInvestimento, {

    NovoEstado <- !isTRUE(
      CompetenciaConfirmadaInvestimento()
    )

    CompetenciaConfirmadaInvestimento(
      NovoEstado
    )

    session$sendCustomMessage(
      "estado_competencia_investimento",
      list(
        confirmada = NovoEstado
      )
    )

    TemInvestimento <- isTRUE(
      ArquivoSelecionadoInvestimento()
    )

    TemArtigos <- isTRUE(
      ArquivoArtigosSelecionadoInvestimento()
    )

    if (NovoEstado) {

      session$sendCustomMessage(
        "etapa_investimento",
        list(
          etapa = if (TemInvestimento && TemArtigos) 3 else 2
        )
      )

    } else {

      DownloadLiberadoInvestimento(FALSE)

      ArquivoSelecionadoInvestimento(FALSE)
      ArquivoArtigosSelecionadoInvestimento(FALSE)

      updateActionButton(
        session = session,
        inputId = "ExecutarInvestimento",
        disabled = TRUE
      )

      session$sendCustomMessage(
        "estado_upload_investimento",
        list(
          carregado = FALSE
        )
      )

      session$sendCustomMessage(
        "estado_upload_artigos",
        list(
          carregado = FALSE
        )
      )

      session$sendCustomMessage(
        "etapa_investimento",
        list(
          etapa = 1
        )
      )

    }

  })


  observeEvent(input$MesAnoInvestimento, {

    CompetenciaConfirmadaInvestimento(FALSE)
    DownloadLiberadoInvestimento(FALSE)

    updateActionButton(
      session = session,
      inputId = "ExecutarInvestimento",
      disabled = TRUE
    )

    session$sendCustomMessage(
      "estado_competencia_investimento",
      list(
        confirmada = FALSE
      )
    )

    session$sendCustomMessage(
      "etapa_investimento",
      list(
        etapa = 1
      )
    )

  }, ignoreInit = TRUE)


  observe({

    TemInvestimento <- isTRUE(
      ArquivoSelecionadoInvestimento()
    )

    TemArtigos <- isTRUE(
      ArquivoArtigosSelecionadoInvestimento()
    )

    CompetenciaOK <- isTRUE(
      CompetenciaConfirmadaInvestimento()
    )

    ArquivosOK <- TemInvestimento && TemArtigos

    updateActionButton(
      session = session,
      inputId = "ExecutarInvestimento",
      disabled = !(CompetenciaOK && ArquivosOK)
    )

    session$sendCustomMessage(
      "estado_upload_investimento",
      list(
        carregado = TemInvestimento
      )
    )

    session$sendCustomMessage(
      "estado_upload_artigos",
      list(
        carregado = TemArtigos
      )
    )

    if (CompetenciaOK) {

      session$sendCustomMessage(
        "etapa_investimento",
        list(
          etapa = if (ArquivosOK) 3 else 2
        )
      )

    }

  })


  observe({

    session$sendCustomMessage(
      "estado_download_investimento",
      list(
        liberado = isTRUE(
          DownloadLiberadoInvestimento()
        )
      )
    )

  })


  observeEvent(
    input$BotaoInvestimento,
    {

      DownloadLiberadoInvestimento(FALSE)

      TemInvestimento <- !is.null(input$BotaoInvestimento) &&
        NROW(input$BotaoInvestimento) > 0

      ArquivoSelecionadoInvestimento(
        TemInvestimento
      )

      session$sendCustomMessage(
        "estado_upload_investimento",
        list(
          carregado = TemInvestimento
        )
      )

      TemArtigos <- isTRUE(
        ArquivoArtigosSelecionadoInvestimento()
      )

      CompetenciaOK <- isTRUE(
        CompetenciaConfirmadaInvestimento()
      )

      updateActionButton(
        session = session,
        inputId = "ExecutarInvestimento",
        disabled = !(CompetenciaOK && TemInvestimento && TemArtigos)
      )

    },
    ignoreInit = TRUE
  )


  observeEvent(
    input$BotaoArtigos,
    {

      DownloadLiberadoInvestimento(FALSE)

      TemArtigos <- !is.null(input$BotaoArtigos) &&
        NROW(input$BotaoArtigos) > 0

      ArquivoArtigosSelecionadoInvestimento(
        TemArtigos
      )

      session$sendCustomMessage(
        "estado_upload_artigos",
        list(
          carregado = TemArtigos
        )
      )

      TemInvestimento <- isTRUE(
        ArquivoSelecionadoInvestimento()
      )

      CompetenciaOK <- isTRUE(
        CompetenciaConfirmadaInvestimento()
      )

      updateActionButton(
        session = session,
        inputId = "ExecutarInvestimento",
        disabled = !(CompetenciaOK && TemInvestimento && TemArtigos)
      )

    },
    ignoreInit = TRUE
  )

}



ProcessarControleInvestimentos <- function(
    input,
    session,
    ObservFunction,
    DownloadLiberadoInvestimento
) {

  observeEvent(input$ExecutarInvestimento, {

    updateActionButton(
      session = session,
      inputId = "ExecutarInvestimento",
      disabled = TRUE
    )

    DownloadLiberadoInvestimento(FALSE)

    session$sendCustomMessage(
      "etapa_investimento",
      list(
        etapa = 3
      )
    )

    tryCatch({

      ObservFunction(
        MesAno = input$MesAnoInvestimento,
        Função = Extrair_Geral(
          input$BotaoInvestimento$name,
          input$MesAnoInvestimento,
          input$BotaoInvestimento$datapath,
          input$BotaoArtigos$datapath
        )
      )

      DownloadLiberadoInvestimento(TRUE)

      session$sendCustomMessage(
        "etapa_investimento",
        list(
          etapa = 4
        )
      )

      shinybusy::report_success(
        "Organização finalizada!",
        "O arquivo foi processado com sucesso e está pronto para download."
      )

    }, error = function(e) {

      DownloadLiberadoInvestimento(FALSE)

      session$sendCustomMessage(
        "etapa_investimento",
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
        inputId = "ExecutarInvestimento",
        disabled = FALSE
      )

    })

  })

}
