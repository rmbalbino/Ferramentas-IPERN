PainelExtratoBancario <- function() {

  div(
    class = "ferramenta-conteudo",

    # CABEÇALHO ─────────────────────────────────────────────

    div(
      class = "ferramenta-cabecalho",

      div(
        class = "ferramenta-titulo-linha",

        div(
          h3(
            "Extrato Bancário",
            class = "ferramenta-titulo"
          ),

          p(
            "Organize e processe extratos de conta corrente ou de investimento.",
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
              "3. Selecione o arquivo de Extrato Bancário (Banco do Brasil) em formato TXT."
            ),

            placement = "left"
          )
        )
      )
    ),

    # STEPPER ─────────────────────────────────────────────

    StepperFerramenta("Extrato"),

    # COMPETÊNCIA ─────────────────────────────────────────────

    CompetenciaFerramenta("Extrato"),

    # UPLOADS ─────────────────────────────────────────────

    UploadFerramenta(
      inputId = "BotaoExtrato",
      classe = "upload-extrato",
      titulo = "Extrato Bancário",
      titulo_carregado = "Extrato carregado"
    ),

    # PROCESSAR ─────────────────────────────────────────────

    div(
      class = "acao-centralizada",

      actionButton(
        inputId = "ExecutarExtrato",
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
        id = "DownloadExtrato_wrapper",
        class = "download-desabilitado",

        downloadButton(
          outputId = "DownloadExtrato",
          label = "Baixar arquivo",
          class = "btn-download"
        )
      )
    )
  )
}
