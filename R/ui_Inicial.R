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
                descricao = "Consolidador"
              ),

              CardFerramenta(
                inputId = "SelecionarConciliadorContaCorrente",
                icone = "check2-square",
                titulo = "C. Corrente 7988X",
                descricao = "Conciliador"
              ),

              CardFerramenta(
                inputId = "SelecionarControleInvestimentos",
                icone = "graph-up-arrow",
                titulo = "Controle Investimentos",
                descricao = "Consolidador"
              ),

              CardFerramenta(
                inputId = "SelecionarControlePagamentos",
                icone = "cash-stack",
                titulo = "Controle Pagamentos",
                descricao = "Organizador"
              ),

              CardFerramenta(
                inputId = "SelecionarExtrato",
                icone = "bank",
                titulo = "Extrato Bancário",
                descricao = "Organizador"
              ),

              CardFerramenta(
                inputId = "SelecionarFichaRazao",
                icone = "file-earmark-text",
                titulo = "Ficha Razão",
                descricao = "Organizador"
              ),

              CardFerramenta(
                inputId = "SelecionarConciliadorFichaRazao",
                icone = "check2-square",
                titulo = "Ficha Razão",
                descricao = "Conciliador"
              ),

              CardFerramenta(
                inputId = "SelecionarFolhas",
                icone = "people",
                titulo = "Folhas de Pagamento",
                descricao = "Organizador"
              ),

              CardFerramenta(
                inputId = "SelecionarGuia",
                icone = "receipt",
                titulo = "Guia de Recebimento",
                descricao = "Organizador"
              ),

              CardFerramenta(
                inputId = "SelecionarOB",
                icone = "arrow-left-right",
                titulo = "Ordens Bancárias",
                descricao = "Organizador"
              ),

              CardFerramenta(
                inputId = "SelecionarRetencao",
                icone = "shield-check",
                titulo = "Retenção Realizada",
                descricao = "Organizador"
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
