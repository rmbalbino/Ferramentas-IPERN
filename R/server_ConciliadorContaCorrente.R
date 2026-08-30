ServerConciliadorContaCorrente <- function(
    input,
    session,
    CompetenciaConfirmadaConciliadorContaCorrente,
    DownloadLiberadoConciliadorContaCorrente,
    ArquivoExtratoSelecionadoConciliadorContaCorrente,
    ArquivoRazaoSelecionadoConciliadorContaCorrente
) {

  observeEvent(input$ConfirmarCompetenciaConciliadorContaCorrente, {

    NovoEstado <- !isTRUE(
      CompetenciaConfirmadaConciliadorContaCorrente()
    )

    CompetenciaConfirmadaConciliadorContaCorrente(
      NovoEstado
    )

    session$sendCustomMessage(
      "estado_competencia_conciliador_conta_corrente",
      list(
        confirmada = NovoEstado
      )
    )

    TemExtrato <- isTRUE(
      ArquivoExtratoSelecionadoConciliadorContaCorrente()
    )

    TemRazao <- isTRUE(
      ArquivoRazaoSelecionadoConciliadorContaCorrente()
    )

    ArquivosOK <- TemExtrato && TemRazao

    if (NovoEstado) {

      session$sendCustomMessage(
        "etapa_conciliador_conta_corrente",
        list(
          etapa = if (ArquivosOK) 3 else 2
        )
      )

    } else {

      DownloadLiberadoConciliadorContaCorrente(FALSE)

      ArquivoExtratoSelecionadoConciliadorContaCorrente(FALSE)
      ArquivoRazaoSelecionadoConciliadorContaCorrente(FALSE)

      updateActionButton(
        session = session,
        inputId = "ExecutarConciliadorContaCorrente",
        disabled = TRUE
      )

      session$sendCustomMessage(
        "estado_upload_conciliador_conta_corrente_extrato",
        list(
          carregado = FALSE
        )
      )

      session$sendCustomMessage(
        "estado_upload_conciliador_conta_corrente_razao",
        list(
          carregado = FALSE
        )
      )

      session$sendCustomMessage(
        "etapa_conciliador_conta_corrente",
        list(
          etapa = 1
        )
      )
    }
  })


  observe({

    TemExtrato <- isTRUE(
      ArquivoExtratoSelecionadoConciliadorContaCorrente()
    )

    TemRazao <- isTRUE(
      ArquivoRazaoSelecionadoConciliadorContaCorrente()
    )

    CompetenciaOK <- isTRUE(
      CompetenciaConfirmadaConciliadorContaCorrente()
    )

    ArquivosOK <- TemExtrato && TemRazao

    updateActionButton(
      session = session,
      inputId = "ExecutarConciliadorContaCorrente",
      disabled = !(CompetenciaOK && ArquivosOK)
    )

    session$sendCustomMessage(
      "estado_upload_conciliador_conta_corrente_extrato",
      list(
        carregado = TemExtrato
      )
    )

    session$sendCustomMessage(
      "estado_upload_conciliador_conta_corrente_razao",
      list(
        carregado = TemRazao
      )
    )

    if (CompetenciaOK) {

      session$sendCustomMessage(
        "etapa_conciliador_conta_corrente",
        list(
          etapa = if (ArquivosOK) 3 else 2
        )
      )
    }
  })


  observe({

    session$sendCustomMessage(
      "estado_download_conciliador_conta_corrente",
      list(
        liberado = isTRUE(
          DownloadLiberadoConciliadorContaCorrente()
        )
      )
    )
  })


  observeEvent(
    input$BotaoConciliadorContaCorrenteExtrato,
    {

      DownloadLiberadoConciliadorContaCorrente(FALSE)

      TemExtrato <- !is.null(
        input$BotaoConciliadorContaCorrenteExtrato
      ) &&
        NROW(
          input$BotaoConciliadorContaCorrenteExtrato
        ) > 0

      ArquivoExtratoSelecionadoConciliadorContaCorrente(
        TemExtrato
      )

      session$sendCustomMessage(
        "estado_upload_conciliador_conta_corrente_extrato",
        list(
          carregado = TemExtrato
        )
      )
    },
    ignoreInit = TRUE
  )


  observeEvent(
    input$BotaoConciliadorContaCorrenteRazao,
    {

      DownloadLiberadoConciliadorContaCorrente(FALSE)

      TemRazao <- !is.null(
        input$BotaoConciliadorContaCorrenteRazao
      ) &&
        NROW(
          input$BotaoConciliadorContaCorrenteRazao
        ) > 0

      ArquivoRazaoSelecionadoConciliadorContaCorrente(
        TemRazao
      )

      session$sendCustomMessage(
        "estado_upload_conciliador_conta_corrente_razao",
        list(
          carregado = TemRazao
        )
      )
    },
    ignoreInit = TRUE
  )
}


ProcessarConciliadorContaCorrente <- function(
    input,
    session,
    ObservFunction,
    DownloadLiberadoConciliadorContaCorrente
) {

  observeEvent(input$ExecutarConciliadorContaCorrente, {

    updateActionButton(
      session = session,
      inputId = "ExecutarConciliadorContaCorrente",
      disabled = TRUE
    )

    DownloadLiberadoConciliadorContaCorrente(FALSE)

    session$sendCustomMessage(
      "etapa_conciliador_conta_corrente",
      list(
        etapa = 3
      )
    )

    tryCatch({

      ObservFunction(
        MesAno = input$MesAnoConciliadorContaCorrente,
        Função = Conc_Corr(
          input$MesAnoConciliadorContaCorrente,
          input$BotaoConciliadorContaCorrenteExtrato$datapath,
          input$BotaoConciliadorContaCorrenteRazao$datapath
        )
      )

      DownloadLiberadoConciliadorContaCorrente(TRUE)

      session$sendCustomMessage(
        "etapa_conciliador_conta_corrente",
        list(
          etapa = 4
        )
      )

      shinybusy::report_success(
        "Conciliação finalizada!",
        "Os arquivos foram processados com sucesso e estão prontos para download."
      )

    }, error = function(e) {

      DownloadLiberadoConciliadorContaCorrente(FALSE)

      session$sendCustomMessage(
        "etapa_conciliador_conta_corrente",
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
        inputId = "ExecutarConciliadorContaCorrente",
        disabled = FALSE
      )
    })
  })
}

