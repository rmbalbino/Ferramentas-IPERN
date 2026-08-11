fui_ControleInvestimentos <- function(){
  
  nav_panel(title = "Controle Investimentos", # Título da aba
            
            
            br(),
            
            
            # Inputs:
            layout_columns(col_widths = c(-1, 2, 4, 4, -1),
                           
                           dateInput(inputId = "MesAnoInvestimento", label = strong("Competência"), format = "mm/yyyy", language = "pt-br"),
                           
                           fileInput(inputId = "BotaoInvestimento", label = strong("Selecione os arquivos da pasta"), buttonLabel = "Procurar...", placeholder = "", multiple = TRUE),
                           
                           fileInput(inputId = "BotaoArtigos", label = strong("Selecione a planilha de Artigos"), buttonLabel = "Procurar...", placeholder = "")),
            
            
            br(),
            
            
            # Execução:
            layout_columns(col_widths = c(-5, 2, -3, 1),
                           
                           actionButton(inputId = "ExecutarInvestimento", label = "Executar",
                                        class = "bnt-success", icon = icon("circle-check")),
                           
                           actionButton(inputId = "InfoInvestimento", label = "", class = "info", icon = icon("info"))),
            
            
            br(),
            
            
            # Saída:
            layout_columns(col_widths = c(-5, 2, -5),
                           downloadButton(outputId = "DownloadInvestimento",
                                          label = "Baixar", class = "bnt-success", icon = icon("download"))),
            
  )
  
}