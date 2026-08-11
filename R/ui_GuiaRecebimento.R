fui_GuiaRecebimento <- function(){
  
  nav_panel(title = "Guia Recebimento", # Título da aba
            
            
            # Inputs:
            layout_columns(col_widths = c(-2, 2, -1, 5, -2),
                           
                           dateInput(inputId = "MesAnoGR", label = strong("Competência"), format = "mm/yyyy", language = "pt-br"),
                           
                           fileInput(inputId = "BotaoGR", label = strong("Selecione o Guia Recebimento"), buttonLabel = "Procurar...", placeholder = "")),
            
            
            # layout_columns(col_widths = c(-2, 4, 4, -2),
            #
            #   fileInput(inputId = "BotaoClassificacao", label = strong("Selecione a planilha de Classificação"), buttonLabel = "Procurar...", placeholder = ""),
            #
            #   fileInput(inputId = "BotaoOrgao", label = strong("Selecione a planilha de Órgãos"), buttonLabel = "Procurar...", placeholder = "")),
            
            
            br(),
            
            
            # Execução:
            layout_columns(col_widths = c(-5, 2, -3, 1),
                           
                           actionButton(inputId = "ExecutarGR", label = "Executar",
                                        class = "bnt-success", icon = icon("circle-check")),
                           
                           actionButton(inputId = "InfoGR", label = "", class = "info", icon = icon("info"))),
            
            
            br(),
            
            
            # Saída:
            layout_columns(col_widths = c(-5, 2, -5),
                           downloadButton(outputId = "DownloadGR",
                                          label = "Baixar", class = "bnt-success", icon = icon("download"))),
            
  )
  
}