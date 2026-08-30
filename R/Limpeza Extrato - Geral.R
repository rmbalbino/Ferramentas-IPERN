ExtrairExtratoGeral <- function(Arquivo) {

  tryCatch(

    Extrair_Extrato(
      Arquivo
    ),

    error = function(e) {

      Extrair_Extrato_IN(
        Arquivo
      )

    }
  )
}
