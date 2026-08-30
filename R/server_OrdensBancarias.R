ServerOrdensBancarias <- function(
    input,
    session,
    CompetenciaConfirmadaOB,
    DownloadLiberadoOB,
    ArquivoSelecionadoOB
) {

  observe({

    TemArquivo <- isTRUE(
      ArquivoSelecionadoOB()
    )

    CompetenciaOK <- isTRUE(
      CompetenciaConfirmadaOB()
    )

    updateActionButton(
      session = session,
      inputId = "ExecutarOB",
      disabled = !(CompetenciaOK && TemArquivo)
    )

    session$sendCustomMessage(
      "estado_upload_ob",
      list(
        carregado = TemArquivo
      )
    )

    if (CompetenciaOK) {

      session$sendCustomMessage(
        "etapa_ob",
        list(
          etapa = if (TemArquivo) 3 else 2
        )
      )

    }

  })


  observeEvent(
    input$BotaoOB,
    {

      TemArquivo <- !is.null(input$BotaoOB) &&
        NROW(input$BotaoOB) > 0

      ArquivoSelecionadoOB(
        TemArquivo
      )

      DownloadLiberadoOB(FALSE)

      session$sendCustomMessage(
        "estado_upload_ob",
        list(
          carregado = TemArquivo
        )
      )

      if (isTRUE(CompetenciaConfirmadaOB())) {

        session$sendCustomMessage(
          "etapa_ob",
          list(
            etapa = if (TemArquivo) 3 else 2
          )
        )

      }

    },
    ignoreInit = TRUE
  )


  observe({

    session$sendCustomMessage(
      "estado_download_ob",
      list(
        liberado = isTRUE(
          DownloadLiberadoOB()
        )
      )
    )

  })


  observeEvent(input$ConfirmarCompetenciaOB, {

    NovoEstado <- !isTRUE(
      CompetenciaConfirmadaOB()
    )

    CompetenciaConfirmadaOB(
      NovoEstado
    )

    session$sendCustomMessage(
      "estado_competencia_ob",
      list(
        confirmada = NovoEstado
      )
    )

    TemArquivo <- isTRUE(
      ArquivoSelecionadoOB()
    )

    if (NovoEstado) {

      session$sendCustomMessage(
        "etapa_ob",
        list(
          etapa = if (TemArquivo) 3 else 2
        )
      )

    } else {

      DownloadLiberadoOB(FALSE)
      ArquivoSelecionadoOB(FALSE)

      updateActionButton(
        session = session,
        inputId = "ExecutarOB",
        disabled = TRUE
      )

      session$sendCustomMessage(
        "estado_upload_ob",
        list(
          carregado = FALSE
        )
      )

      session$sendCustomMessage(
        "etapa_ob",
        list(
          etapa = 1
        )
      )

    }

  })


  observeEvent(
    input$BotaoOB,
    {

      DownloadLiberadoOB(FALSE)

      TemArquivo <- !is.null(input$BotaoOB) &&
        NROW(input$BotaoOB) > 0

      ArquivoSelecionadoOB(
        TemArquivo
      )

      session$sendCustomMessage(
        "estado_upload_ob",
        list(
          carregado = TemArquivo
        )
      )

      CompetenciaOK <- isTRUE(
        CompetenciaConfirmadaOB()
      )

      updateActionButton(
        session = session,
        inputId = "ExecutarOB",
        disabled = !(CompetenciaOK && TemArquivo)
      )

    },
    ignoreInit = TRUE
  )

}



ProcessarOrdensBancarias <- function(
    input,
    session,
    ObservFunction,
    DownloadLiberadoOB
) {

  observeEvent(input$ExecutarOB, {

    updateActionButton(
      session = session,
      inputId = "ExecutarOB",
      disabled = TRUE
    )

    DownloadLiberadoOB(FALSE)

    session$sendCustomMessage(
      "etapa_ob",
      list(
        etapa = 3
      )
    )

    tryCatch({

      ObservFunction(
        MesAno = input$MesAnoOB,
        Função = Format_OrdensBancarias(
          input$BotaoOB$datapath
        )
      )

      DownloadLiberadoOB(TRUE)

      session$sendCustomMessage(
        "etapa_ob",
        list(
          etapa = 4
        )
      )

      shinybusy::report_success(
        "Organização finalizada!",
        "O arquivo foi processado com sucesso e está pronto para download."
      )

    }, error = function(e) {

      DownloadLiberadoOB(FALSE)

      session$sendCustomMessage(
        "etapa_ob",
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
        inputId = "ExecutarOB",
        disabled = FALSE
      )

    })

  })

}
