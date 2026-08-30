PainelConciliadorContaCorrente <- function() {

  div(
    class = "ferramenta-conteudo",

    # CABEÇALHO ─────────────────────────────────────────────

    div(
      class = "ferramenta-cabecalho",

      div(
        class = "ferramenta-titulo-linha",

        div(
          h3(
            "Conta Corrente 7988X",
            class = "ferramenta-titulo"
          ),

          p(
            "Concilie o Extrato Bancário com a Ficha Razão.",
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
              "3. Selecione o Extrato Bancário (TXT).",
              br(), br(),
              "4. Selecione a Ficha Razão (PDF)."
            ),

            placement = "left"
          )
        )
      )
    ),

    # STEPPER ─────────────────────────────────────────────

    StepperFerramenta(
      prefixo = "ConciliadorContaCorrente"
    ),

    # COMPETÊNCIA ─────────────────────────────────────────────

    CompetenciaFerramenta(
      "ConciliadorContaCorrente"
    ),

    # UPLOADS ─────────────────────────────────────────────

    div(
      class = "uploads-duplos",

      UploadFerramenta(
        inputId = "BotaoConciliadorContaCorrenteExtrato",
        classe = "upload-conciliador-conta-corrente-extrato",
        titulo = "Extrato Bancário",
        titulo_carregado = "Extrato carregado"
      ),

      UploadFerramenta(
        inputId = "BotaoConciliadorContaCorrenteRazao",
        classe = "upload-conciliador-conta-corrente-razao",
        titulo = "Ficha Razão",
        titulo_carregado = "Ficha Razão carregada"
      )
    ),

    # PROCESSAR ─────────────────────────────────────────────

    div(
      class = "acao-centralizada",

      actionButton(
        inputId = "ExecutarConciliadorContaCorrente",
        label = tagList(
          bsicons::bs_icon("gear"),
          " Processar arquivos"
        ),
        class = "btn-processar",
        disabled = TRUE
      )
    ),

    # DOWNLOAD ─────────────────────────────────────────────

    div(
      class = "acao-centralizada",

      tags$div(
        id = "DownloadConciliadorContaCorrente_wrapper",
        class = "download-desabilitado",

        downloadButton(
          outputId = "DownloadConciliadorContaCorrente",
          label = "Baixar arquivo",
          class = "btn-download"
        )
      )
    )
  )
}
