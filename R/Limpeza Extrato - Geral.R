ExtrairExtratoGeral <- function(Arquivo) {

  tryCatch(

    Extrair_ExtratoC(
      Arquivo
    ),

    error = function(e) {

      Extrair_Extrato_IN(
        Arquivo
      )

    }
  )
}
