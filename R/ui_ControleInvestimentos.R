PainelControleInvestimentos <- function() {

  div(
    class = "ferramenta-conteudo",

    # CABEÇALHO ─────────────────────────────────────────────

    div(
      class = "ferramenta-cabecalho",

      div(
        class = "ferramenta-titulo-linha",

        div(
          h3(
            "Controle Investimentos",
            class = "ferramenta-titulo"
          ),

          p(
            "Organize e consolide os arquivos de controle de investimentos.",
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
              "3. Selecione os arquivos da pasta e a planilha de Artigos."
            ),

            placement = "left"
          )
        )
      )
    ),

    # ETAPAS

    StepperFerramenta("Investimento"),

    # COMPETÊNCIA ─────────────────────────────────────────────

    CompetenciaFerramenta ("Investimento"),

    # ARQUIVOS ─────────────────────────────────────────────

    div(
      class = "uploads-duplos",

      UploadFerramenta(
        inputId = "BotaoInvestimento",
        classe = "upload-investimento",
        titulo = "Arquivos da pasta",
        titulo_carregado = "Arquivos carregados",
        multiple = TRUE
      ),

      UploadFerramenta(
        inputId = "BotaoArtigos",
        classe = "upload-artigos",
        titulo = "Planilha de Artigos",
        titulo_carregado = "Artigos carregados"
      )
    ),

    # PROCESSAR ─────────────────────────────────────────────

    div(
      class = "acao-centralizada",

      actionButton(
        inputId = "ExecutarInvestimento",
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
        id = "DownloadInvestimento_wrapper",
        class = "download-desabilitado",

        downloadButton(
          outputId = "DownloadInvestimento",
          label = "Baixar arquivo",
          class = "btn-download"
        )
      )
    )
  )
}
