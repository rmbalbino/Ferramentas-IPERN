PainelGuiaRecebimento <- function() {

  div(
    class = "ferramenta-conteudo",

    # CABEÇALHO ─────────────────────────────────────────────

    div(
      class = "ferramenta-cabecalho",

      div(
        class = "ferramenta-titulo-linha",

        div(
          h3(
            "Guia de Recebimento",
            class = "ferramenta-titulo"
          ),

          p(
            "Organize e processe os arquivos de guia de recebimento.",
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
              "1. Selecione a competência.",
              br(), br(),
              "2. Confirme a competência utilizando o botão ao lado dela.",
              br(), br(),
              "3. Selecione o arquivo de Guia de Recebimento."
            ),

            placement = "left"
          )
        )
      )
    ),

    # STEPPER ─────────────────────────────────────────────

    StepperFerramenta("GR"),

    # COMPETÊNCIA ─────────────────────────────────────────────

    CompetenciaFerramenta("GR"),

    # UPLOAD ─────────────────────────────────────────────

    UploadFerramenta(
      inputId = "BotaoGR",
      classe = "upload-gr",
      titulo = "Guia de Recebimento",
      titulo_carregado = "Guia carregado"
    ),

    # PROCESSAR ─────────────────────────────────────────────

    div(
      class = "acao-centralizada",

      actionButton(
        inputId = "ExecutarGR",
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
        id = "DownloadGR_wrapper",
        class = "download-desabilitado",

        downloadButton(
          outputId = "DownloadGR",
          label = "Baixar arquivo",
          class = "btn-download"
        )
      )
    )
  )
}
