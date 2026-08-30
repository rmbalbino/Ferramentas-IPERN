PainelFichaRazao <- function() {

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
            "Organize e processe os arquivos de Ficha Razão.",
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
              "3. Selecione o arquivo de Ficha Razão."
            ),

            placement = "left"
          )
        )
      )
    ),

    # STEPPER ─────────────────────────────────────────────

    StepperFerramenta("Razao"),

    # COMPETÊNCIA ─────────────────────────────────────────────

    CompetenciaFerramenta("Razao"),

    # UPLOAD ─────────────────────────────────────────────

    UploadFerramenta(
      inputId = "BotaoRazao",
      classe = "upload-razao",
      titulo = "Ficha Razão",
      titulo_carregado = "Ficha Razão carregada"
    ),

    # PROCESSAR ─────────────────────────────────────────────

    div(
      class = "acao-centralizada",

      actionButton(
        inputId = "ExecutarRazao",
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
        id = "DownloadRazao_wrapper",
        class = "download-desabilitado",

        downloadButton(
          outputId = "DownloadRazao",
          label = "Baixar arquivo",
          class = "btn-download"
        )
      )
    )
  )
}
