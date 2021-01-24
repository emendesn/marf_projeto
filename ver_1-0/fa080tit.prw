#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} FA080TIT
//Descri��o : Ponto de Entrada FA080TIT() ativada em FINA080, que chama MGFFINB6(), 
                  para gerar registro de movimenta��o de reposi��o de Caixinha na baixa de t�tulo
@author Andy Pudja / Eric
@since 17/12/2018
@version 1.0
@type function

10/07/2020 - Paulo da Mata - RTASK0010971 - Recria��o para PRD em 13/07/2020
/*/

User Function FA080TIT()

	Local lRet := .T.

	If FindFunction( "U_MGFFINB6" )
	   lRet := U_MGFFINB6()
	EndIf

	// Paulo da Mata - 15/04/2020 - Inclui a data de baixa do titulo de CTE, no documento de frete
	If FindFunction("U_MGFFINBM")
	   lRet := U_MGFFINBM()
	EndIf

Return lRet
