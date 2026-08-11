fui_OrdensBancarias <- function(){
  
  nav_panel(title = "Ordens Bancárias", # Título da aba
            
            
            # Inputs:
            layout_columns(col_widths = c(-2, 2, -1, 5, -2),
                           
                           dateInput(inputId = "MesAnoOB", label = strong("Competência"), format = "mm/yyyy", language = "pt-br"),
                           
                           fileInput(inputId = "BotaoOB", label = strong("Selecione as Ordens Bancárias"), buttonLabel = "Procurar...", placeholder = "")),
            
            
            # layout_columns(col_widths = c(-2, 4, 4, -2),
            #
            #                fileInput(inputId = "BotaoOR", label = strong("Selecione a planilha PP Servidor"), buttonLabel = "Procurar...", placeholder = ""),
            #
            #                fileInput(inputId = "BotaoDE", label = strong("Selecione a planilha PP Patronal"), buttonLabel = "Procurar...", placeholder = "")),
            
            
            br(),
            
            
            # Execução:
            layout_columns(col_widths = c(-5, 2, -3, 1),
                           
                           actionButton(inputId = "ExecutarOB", label = "Executar",
                                        class = "bnt-success", icon = icon("circle-check")),
                           
                           actionButton(inputId = "InfoOB", label = "", class = "info", icon = icon("info"))),
            
            
            br(),
            
            
            # Saída:
            layout_columns(col_widths = c(-5, 2, -5),
                           downloadButton(outputId = "DownloadOB",
                                          label = "Baixar", class = "bnt-success", icon = icon("download"))),
            
  )
  
}