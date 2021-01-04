#include 'protheus.ch'
#include 'parmtype.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFFAT19
Autor....:              Gustavo Ananias Afonso
Data.....:              24/10/2016
Descricao / Objetivo:   Apos a alteracao do produto atualiza status de instegracao para SFA se for elegivel
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
user function MGFFAT19()
	local cUpdSA1	:= ""
	local cUpdSB1	:= ""

	if isInCallStack("U_OS010GRV") //.and. FieldPos("DA0_XENVEC") > 0 .and. FieldPos("DA0_XINTEC") > 0 inclusao nao estava funcionando
		if DA0->DA0_XENVEC == "1"

			recLock("DA0", .F.)
				DA0->DA0_XINTEC := "0"
			DA0->(msUnLock())

/*
			cUpdSA1 := "UPDATE " + retSQLName("SA1")							+ CRLF
			cUpdSA1 += "	SET"												+ CRLF
			cUpdSA1 += " 		A1_XINTECO = '0',"								+ CRLF
			cUpdSA1 += " 		A1_XENVECO = '1'"								+ CRLF
			cUpdSA1 += " WHERE"													+ CRLF
			cUpdSA1 += " 		A1_ZPRCECO	=	'" + DA0->DA0_CODTAB	+ "'"	+ CRLF
			cUpdSA1 += " 	AND	A1_FILIAL	=	'" + xFilial("SA1")		+ "'"	+ CRLF
			cUpdSA1 += " 	AND	D_E_L_E_T_	<>	'*'"							+ CRLF

			if tcSQLExec( cUpdSA1 ) < 0
				conout("Nao foi possivel executar UPDATE." + CRLF + tcSqlError())
			endif
*/

			cUpdSB1 := "UPDATE " + retSQLName("SB1")									+ CRLF
			cUpdSB1 += "	SET"														+ CRLF
			cUpdSB1 += " 		B1_XINTECO = '0',"										+ CRLF
			cUpdSB1 += " 		B1_XENVECO = '1'"										+ CRLF
			cUpdSB1 += " WHERE"															+ CRLF
			cUpdSB1 += " 		B1_FILIAL	=	'" + xFilial("SB1")	+ "'"				+ CRLF
			cUpdSB1 += " 	AND	D_E_L_E_T_	<>	'*'"									+ CRLF
			cUpdSB1 += " 	AND	B1_ZSTATEC	<>	'1'"									+ CRLF
			cUpdSB1 += " 	AND	B1_COD IN"												+ CRLF
			cUpdSB1 += " 	("															+ CRLF
			cUpdSB1 += "		SELECT DA1_CODPRO"										+ CRLF
			cUpdSB1 += " 		FROM " + retSQLName("DA1") + " DA1"						+ CRLF
			cUpdSB1 += " 		WHERE"													+ CRLF
			cUpdSB1 += " 			DA1.DA1_CODTAB	=	'" + DA0->DA0_CODTAB	+ "'"	+ CRLF
			cUpdSB1 += " 		AND	DA1.DA1_FILIAL	=	'" + xFilial("DA1")		+ "'"	+ CRLF
			cUpdSB1 += " 		AND	DA1.D_E_L_E_T_	<>	'*'"							+ CRLF
			cUpdSB1 += " 	)"															+ CRLF

			if tcSQLExec( cUpdSB1 ) < 0
				conout("Nao foi possivel executar UPDATE." + CRLF + tcSqlError())
			endif

			If DA0->DA0_ATIVO == "2" //tabela ativa? 1=sim, 2=nao
				xAtuClie(DA0->DA0_CODTAB)
			EndIf
		endif
	else

		if SB1->B1_XSFA == "S"
			recLock("SB1", .F.)
				SB1->B1_XINTEGR := "P"
			SB1->(msUnLock())
		endif

		If FieldPos("B1_XENVECO") > 0
			if SB1->B1_XENVECO == "1"
				recLock("SB1", .F.)
					SB1->B1_XINTECO := "0"
				SB1->(msUnLock())
			endif
		endif
			
		//Tratamento de integracao Produto x Salesforce
		if SB1->B1_XENVSFO == "S" .AND. ALLTRIM(SB1->B1_COD)  < "500000"
			recLock("SB1", .F.)
				SB1->B1_XINTSFO := "P"
			SB1->(msUnLock())	
		endif	

	endif
return

/*
	Atualiza os Clientes E-commerce que estao vinulados a esta lista de preco
*/
Static Function xAtuClie(cTabela)

	Local aArea 	:= GetArea()
	Local aAreaSA1	:= SA1->(GetArea())

	Local cNextAlias := GetNextAlias()
	Local cListaPdr := alltrim(SuperGetMv( "MGF_LISTEC", , "LPC" ))

	BeginSql Alias cNextAlias

		SELECT
			SA1.R_E_C_N_O_ A1RECNO
		FROM
			%Table:SA1% SA1
		WHERE
			SA1.%NotDel% AND
			SA1.A1_ZPRCECO = %Exp:cTabela%

	EndSql

	(cNextAlias)->(DbGoTop())

	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))//A1_FILIAL+A1_COD+A1_LOJA
	While (cNextAlias)->(!EOF())
		SA1->(dbGoTo((cNextAlias)->A1RECNO))

		RecLock("SA1",.F.)
			SA1->A1_ZPRCECO := cListaPdr
			SA1->A1_XINTECO = '0'
			SA1->A1_XENVECO = '1'
		SA1->(MsUnlock())

		(cNextAlias)->(dbSkip())
	EndDo

	RestArea(aAreaSA1)
	RestArea(aArea)

Return