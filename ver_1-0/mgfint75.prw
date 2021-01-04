#include "RESTFUL.ch"
#include "PROTHEUS.ch"
#include "TOTVS.ch"
#include "PARMTYPE.ch"

/*/{Protheus.doc} MGFINT53
Integração Protheus-ME, (Alteraçao) produto
@type function
@author Anderson Reis
@since 18/07/2019
@version P12
@history Alteração 19/03 - Mudança da regra de Produtos 
/*/


User Function MGFINT75()

	Local cRet

	If ALTERA .AND. SB1->B1_MGFFAM <> ' '  ;
	.AND. SB1->B1_COD >= '500000'
	
		cQ := " UPDATE "
		cQ += RetSqlName("SB1")+" "
		cQ += " SET "
		cQ += " B1_ZPEDME = 'A' "
		cQ += " WHERE B1_COD = '" + SB1->B1_COD + "'    "

		nRet := tcSqlExec(cQ)

		If nRet == 0

		Else
			conout("Problemas na gravação dos campos do cadastro do Meracado eletronico , para envio ao ME.(MGFINT75)")

		EndIf

		

	Endif


Return .T.