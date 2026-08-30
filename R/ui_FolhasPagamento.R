PainelFolhasPagamento <- function() {

  div(
    class = "ferramenta-conteudo",

    # CABEÇALHO ─────────────────────────────────────────────

    div(
      class = "ferramenta-cabecalho",

      div(
        class = "ferramenta-titulo-linha",

        div(
          h3(
            "Folhas de Pagamento",
            class = "ferramenta-titulo"
          ),

          p(
            "Organize e processe os arquivos das folhas de pagamento.",
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
              "1. Informe se a folha é décimo terceiro.",
              br(), br(),
              "2. Informe se o PDF é normal ou escaneado.",
              br(), br(),
              "3. Selecione a competência.",
              br(), br(),
              "4. Confirme a competência utilizando o botão ao lado dela.",
              br(), br(),
              "5. Selecione os PDFs da pasta desejada.",
            ),

            placement = "left"
          )
        )
      )
    ),

    # STEPPER ─────────────────────────────────────────────

    StepperFerramenta(prefixo = "FDP", Etapa1 = "Configuração"),

    # OPÇÕES ─────────────────────────────────────────────

    layout_columns(
      col_widths = c(6, 6),
      gap = "16px",

      radioButtons(
        inputId = "BotaoFDPTipo",
        label = strong("São Folhas de Décimo Terceiro?"),
        choices = c("Não", "Sim"),
        inline = TRUE
      ),

      radioButtons(
        inputId = "BotaoFDPClasse",
        label = strong("Tipo de PDF"),
        choices = c(
          "Normal",
          "REL04 Escaneado",
          "REL02 Escaneado"
        ),
        inline = TRUE
      )
    ),

    # COMPETÊNCIA ─────────────────────────────────────────────

    CompetenciaFerramenta("FDP"),

    # UPLOAD ─────────────────────────────────────────────

    UploadFerramenta(
      inputId = "BotaoARQFDP",
      classe = "upload-fdp",
      titulo = "Folhas de Pagamento",
      titulo_carregado = "Folhas carregadas",
      multiple = TRUE
    ),

    # PROCESSAR ─────────────────────────────────────────────

    div(
      class = "acao-centralizada",

      actionButton(
        inputId = "ExecutarFDP",
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
        id = "DownloadFDP_wrapper",
        class = "download-desabilitado",

        downloadButton(
          outputId = "DownloadFDP",
          label = "Baixar arquivo",
          class = "btn-download"
        )
      )
    )
  )
}
