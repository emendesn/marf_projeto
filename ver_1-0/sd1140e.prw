#include "protheus.ch"

/*/{Protheus.doc} SF1100E
//TODO Descrição PE na exclusão da pre-nota entrada
@author marcelo.moraes
@since 24/04/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function SD1140E()

//Atualiza SZ5 na exclusão da pré nota do documento de entrada (triangulação faturamento)
If FindFunction("u_MGFFAT75")
	u_MGFFAT75()
EndIf

Return 