fui_Inicial <- function() {

  nav_panel(
    title = "Início",

    div(
      class = "container-fluid px-4 py-4",

      # APRESENTAÇÃO ─────────────────────────────────────────────
      card(
        class = "card-apresentacao",

        card_body(

          class = "py-2 px-4",

          div(
            class = "d-flex align-items-center gap-3",

            div(
              class = "card-apresentacao-icone",
              bsicons::bs_icon(
                "tools",
                size = "1.8rem"
              )
            ),

            div(
              h4(
                "Ferramentas auxiliares",
                class = "mb-0 fw-bold"
              ),

              p(
                "Automatize o tratamento, a organização e a conciliação de arquivos utilizados nas rotinas do IPERN.",
                class = "mb-0 mt-1 text-muted"
              )
            )
          )
        )
      ),

      # PAINÉIS ─────────────────────────────────────────────
      layout_columns(
        col_widths = c(6, 6),
        gap = "24px",

        # PAINEL ESQUERDO — FERRAMENTAS
        card(
          class = "painel-ferramentas",

          card_body(

            div(
              class = "ferramenta-cabecalho",

              h3(
                "Ferramentas",
                class = "ferramenta-titulo"
              ),

              p(
                "Selecione uma ferramenta para começar.",
                class = "ferramenta-descricao"
              )
            ),

            layout_columns(
              col_widths = c(3, 3, 3, 3),
              gap = "16px",
              fill = FALSE,
              fillable = FALSE,

              CardFerramenta(
                inputId = "SelecionarAlmoxarifado",
                icone = "archive",
                titulo = "Almoxarifado",
                descricao = "Organizar arquivos"
              ),

              CardFerramenta(
                inputId = "SelecionarControlePagamentos",
                icone = "cash-stack",
                titulo = "Controle Pagamentos",
                descricao = "Processar pagamentos"
              ),

              CardFerramenta(
                inputId = "SelecionarExtrato",
                icone = "bank",
                titulo = "Extrato Bancário",
                descricao = "Consolidar extratos"
              ),

              CardFerramenta(
                inputId = "SelecionarFichaRazao",
                icone = "file-earmark-text",
                titulo = "Ficha Razão",
                descricao = "Processar ficha"
              ),

              CardFerramenta(
                inputId = "SelecionarFolhas",
                icone = "people",
                titulo = "Folhas de Pagamento",
                descricao = "Processar folhas"
              ),

              CardFerramenta(
                inputId = "SelecionarGuia",
                icone = "receipt",
                titulo = "Guia de Recebimento",
                descricao = "Processar guias"
              ),

              CardFerramenta(
                inputId = "SelecionarControleInvestimentos",
                icone = "graph-up-arrow",
                titulo = "Controle Investimentos",
                descricao = "Processar investimentos"
              ),

              CardFerramenta(
                inputId = "SelecionarOB",
                icone = "arrow-left-right",
                titulo = "Ordens Bancárias",
                descricao = "Processar arquivos"
              ),

              CardFerramenta(
                inputId = "SelecionarRetencao",
                icone = "shield-check",
                titulo = "Retenção Realizada",
                descricao = "Consolidar retenções"
              )
            )
          )
        ),

        # PAINEL DIREITO — APLICAÇÃO
        card(
          class = "painel-aplicacao",

          card_body(
            uiOutput("PainelFerramenta")
          )
        )
      )
    )
  )
}
