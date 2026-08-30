ServerConciliadorFichaRazao <- function(
    input,
    session,
    CompetenciaConfirmadaConciliadorFichaRazao,
    DownloadLiberadoConciliadorFichaRazao,
    ArquivoSelecionadoConciliadorFichaRazao
) {

  observeEvent(input$ConfirmarCompetenciaConciliadorFichaRazao, {

    NovoEstado <- !isTRUE(
      CompetenciaConfirmadaConciliadorFichaRazao()
    )

    CompetenciaConfirmadaConciliadorFichaRazao(
      NovoEstado
    )

    session$sendCustomMessage(
      "estado_competencia_conciliador_ficha_razao",
      list(
        confirmada = NovoEstado
      )
    )

    TemArquivo <- isTRUE(
      ArquivoSelecionadoConciliadorFichaRazao()
    )

    if (NovoEstado) {

      session$sendCustomMessage(
        "etapa_conciliador_ficha_razao",
        list(
          etapa = if (TemArquivo) 3 else 2
        )
      )

    } else {

      DownloadLiberadoConciliadorFichaRazao(FALSE)
      ArquivoSelecionadoConciliadorFichaRazao(FALSE)

      updateActionButton(
        session = session,
        inputId = "ExecutarConciliadorFichaRazao",
        disabled = TRUE
      )

      session$sendCustomMessage(
        "estado_upload_conciliador_ficha_razao",
        list(
          carregado = FALSE
        )
      )

      session$sendCustomMessage(
        "etapa_conciliador_ficha_razao",
        list(
          etapa = 1
        )
      )
    }
  })


  observe({

    TemArquivo <- isTRUE(
      ArquivoSelecionadoConciliadorFichaRazao()
    )

    CompetenciaOK <- isTRUE(
      CompetenciaConfirmadaConciliadorFichaRazao()
    )

    ArquivosOK <- TemArquivo

    updateActionButton(
      session = session,
      inputId = "ExecutarConciliadorFichaRazao",
      disabled = !(CompetenciaOK && ArquivosOK)
    )

    session$sendCustomMessage(
      "estado_upload_conciliador_ficha_razao",
      list(
        carregado = TemArquivo
      )
    )

    if (CompetenciaOK) {

      session$sendCustomMessage(
        "etapa_conciliador_ficha_razao",
        list(
          etapa = if (ArquivosOK) 3 else 2
        )
      )
    }
  })


  observe({

    session$sendCustomMessage(
      "estado_download_conciliador_ficha_razao",
      list(
        liberado = isTRUE(
          DownloadLiberadoConciliadorFichaRazao()
        )
      )
    )
  })


  observeEvent(
    input$BotaoConciliadorFichaRazao,
    {

      DownloadLiberadoConciliadorFichaRazao(FALSE)

      TemArquivo <- !is.null(
        input$BotaoConciliadorFichaRazao
      ) &&
        NROW(
          input$BotaoConciliadorFichaRazao
        ) > 0

      ArquivoSelecionadoConciliadorFichaRazao(
        TemArquivo
      )

      session$sendCustomMessage(
        "estado_upload_conciliador_ficha_razao",
        list(
          carregado = TemArquivo
        )
      )

      CompetenciaOK <- isTRUE(
        CompetenciaConfirmadaConciliadorFichaRazao()
      )

      updateActionButton(
        session = session,
        inputId = "ExecutarConciliadorFichaRazao",
        disabled = !(CompetenciaOK && TemArquivo)
      )
    },
    ignoreInit = TRUE
  )
}



ProcessarConciliadorFichaRazao <- function(
    input,
    session,
    ObservFunction,
    DownloadLiberadoConciliadorFichaRazao
) {

  observeEvent(input$ExecutarConciliadorFichaRazao, {

    updateActionButton(
      session = session,
      inputId = "ExecutarConciliadorFichaRazao",
      disabled = TRUE
    )

    DownloadLiberadoConciliadorFichaRazao(FALSE)

    session$sendCustomMessage(
      "etapa_conciliador_ficha_razao",
      list(
        etapa = 3
      )
    )

    tryCatch({

      ObservFunction(
        MesAno = input$MesAnoConciliadorFichaRazao,
        Função = Conc_Raz(
          input$MesAnoConciliadorFichaRazao,
          input$TipoConciliacaoFichaRazao,
          input$BotaoConciliadorFichaRazao$datapath
        )
      )

      DownloadLiberadoConciliadorFichaRazao(TRUE)

      session$sendCustomMessage(
        "etapa_conciliador_ficha_razao",
        list(
          etapa = 4
        )
      )

      shinybusy::report_success(
        "Conciliação finalizada!",
        "O arquivo foi processado com sucesso e está pronto para download."
      )

    }, error = function(e) {

      DownloadLiberadoConciliadorFichaRazao(FALSE)

      session$sendCustomMessage(
        "etapa_conciliador_ficha_razao",
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
        inputId = "ExecutarConciliadorFichaRazao",
        disabled = FALSE
      )
    })
  })
}
