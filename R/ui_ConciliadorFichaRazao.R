PainelConciliadorFichaRazao <- function() {

  div(
    class = "ferramenta-conteudo",

    # CABEÇALHO ─────────────────────────────────────────────

    div(
      class = "ferramenta-cabecalho",

      div(
        class = "ferramenta-titulo-linha",

        div(
          h3(
            "Ficha Razão",
            class = "ferramenta-titulo"
          ),

          p(
            "Concilie os lançamentos da Ficha Razão.",
            class = "ferramenta-descricao"
          )
        ),

        div(
          class = "ferramenta-acoes",

          bslib::tooltip(
            bsicons::bs_icon("person-circle"),
            "Desenvolvedor: Renan Balbino",
            placement = "left"
          ),

          bslib::tooltip(
            bsicons::bs_icon("info-circle"),

            tagList(
              "1. Selecione o tipo de conciliação.",
              br(), br(),
              "2. Selecione a competência.",
              br(), br(),
              "3. Confirme a competência utilizando o botão ao lado dela.",
              br(), br(),
              "4. O arquivo Ficha Razão (PDF) deve ser de uma única competência, abrangendo todos os dias do mês.",
              br(), br(),
              "OBS: O método de conciliação Avançado faz somatório de Documentos Contábeis repetidos, já o Simples, não."
              ),

            placement = "left"
          )
        )
      )
    ),

    # STEPPER ─────────────────────────────────────────────

    StepperFerramenta(
      prefixo = "ConciliadorFichaRazao",
      Etapa1 = "Configuração"
    ),

    # OPÇÕES ─────────────────────────────────────────────

    radioButtons(
      inputId = "TipoConciliacaoFichaRazao",
      label = strong("Tipo de conciliação"),
      choices = c(
        "Simples",
        "Avançado"
      ),
      selected = "Avançado",
      inline = TRUE
    ),

    # COMPETÊNCIA ─────────────────────────────────────────────

    CompetenciaFerramenta(
      "ConciliadorFichaRazao"
    ),

    # UPLOAD ─────────────────────────────────────────────

    UploadFerramenta(
      inputId = "BotaoConciliadorFichaRazao",
      classe = "upload-conciliador-ficha-razao",
      titulo = "Ficha Razão",
      titulo_carregado = "Ficha Razão carregada"
    ),

    # PROCESSAR ─────────────────────────────────────────────

    div(
      class = "acao-centralizada",

      actionButton(
        inputId = "ExecutarConciliadorFichaRazao",
        label = tagList(
          bsicons::bs_icon("gear"),
          " Processar arquivo"
        ),
        class = "btn-processar",
        disabled = TRUE
      )
    ),

    # DOWNLOAD ─────────────────────────────────────────────

    div(
      class = "acao-centralizada",

      tags$div(
        id = "DownloadConciliadorFichaRazao_wrapper",
        class = "download-desabilitado",

        downloadButton(
          outputId = "DownloadConciliadorFichaRazao",
          label = "Baixar arquivo",
          class = "btn-download"
        )
      )
    )
  )
}
