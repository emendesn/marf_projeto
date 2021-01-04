#include "totvs.ch"
#include "protheus.ch"
#include "parmtype.ch"
#include "fwmvcdef.ch"
#include "fwmbrowse.ch"

/*/{Protheus.doc} MGFFIN82
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}
@param cTipo, characters, descricao
@type function
/*/
User Function MGFFIN82(cTipo)
	Local aArea		:= GetArea()
	Local aAreaSE1	:= SE1->(GetArea())
	Local _cREDE 	:=""
	Local _cDREDE 	:=""
	Local _cDSEG 	:=""
	Local _CUSR  	:= ""
	Local _DCUSR 	:= ""
	Local cQuery	:= ""
	Local cTitulo	:= ""
	Local cPrefixo	:= ""
	Local cCliente	:= ""
	Local cLoja		:= ""
	Local cCNPJ		:= ""
	Local cNomeCF	:= ""
	Local cAliasSE1	:= GetNextAlias()
	Local cAliasZDN := GetNextAlias()
	Local cAliasZDM := GetNextAlias()
	Local cCodFil	:= IIF(FUNNAME() $ "MATA103|MATA100",SF1->F1_FILIAL,SE1->E1_FILIAL)
	Local cRede		:= ""
	Local cSegmento := ""

	local cUpdSE1	:= ""

	cTitulo		:= IIF(FUNNAME() $ "MATA103|MATA100",SF1->F1_DOC,IIF(FUNNAME() $ "MATA460",SF2->F2_DOC,SE1->E1_NUM))
	cPrefixo	:= IIF(FUNNAME() $ "MATA103|MATA100",SF1->F1_SERIE,IIF(FUNNAME() $ "MATA460",SF2->F2_SERIE,SE1->E1_PREFIXO))
	cCliente	:= IIF(FUNNAME() $ "MATA103|MATA100",SF1->F1_FORNECE,IIF(FUNNAME() $ "MATA460",SF2->F2_CLIENTE,SE1->E1_CLIENTE))
	cLoja		:= IIF(FUNNAME() $ "MATA103|MATA100",SF1->F1_LOJA,IIF(FUNNAME() $ "MATA460",SF2->F2_LOJA,SE1->E1_LOJA))


	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+cCliente+cLoja))
	cCNPJ   := SA1->A1_CGC
	cNomeCF := SA1->A1_NOME
	cRede	:= SA1->A1_ZREDE
	cSegmento := SA1->A1_CODSEG






	__execSql(cAliasZDN," SELECT ZDN_USUARI,ZDN_CODRED,ZDN_DESRED FROM  "+RetSqlName('ZDN')+" ZDN WHERE ZDN.D_E_L_E_T_= ' ' AND ZDN_CODRED= "+___SQLGetValue(CREDE),{},.F.)

	(cAliasZDN)->(dbGoTop())

	If (cAliasZDN)->(!EOF())
		_CUSR   :=(cAliasZDN)->ZDN_USUARI
		_DCUSR  := AllTrim(u_MGF8NomU(_CUSR))
		_cREDE  :=(cAliasZDN)->ZDN_CODRED
		_cDREDE :=(cAliasZDN)->ZDN_DESRED
	Else
		_cREDE  :=""
		_cDREDE :=""






		__execSql(cAliasZDM," SELECT ZDM_USUARI,ZDM_CODSEG,ZDM_DESCSE FROM  "+RetSqlName('ZDM')+" ZDM WHERE ZDM.D_E_L_E_T_= ' ' AND ZDM_CODSEG= "+___SQLGetValue(CSEGMENTO),{},.F.)
		(cAliasZDM)->(dbGoTop())

		If (cAliasZDM)->(!EOF())
			_CUSR  := (cAliasZDM)->ZDM_USUARI
			_DCUSR := AllTrim(u_MGF8NomU(_CUSR))
			_cDSEG := (cAliasZDM)->ZDM_DESCSE
		Else
			_CUSR  := ""
			_DCUSR := ""
			_cDSEG := ""
		Endif
		(cAliasZDM)->(dbCloseArea())
	Endif

	(cAliasZDN)->(dbCloseArea())

	RestArea(aArea)

	if funName() $ "MATA100|MATA103" .and. SF1->F1_TIPO == "D"
		cUpdSE1 := ""
		cUpdSE1 := "UPDATE " + retSQLName("SE1")													+ CRLF
		cUpdSE1 += "	SET"																		+ CRLF
		cUpdSE1 += " 		E1_XINTSFO	= 'P' "														+ CRLF
		cUpdSE1 += " WHERE"																			+ CRLF
		cUpdSE1 += " 		E1_FILIAL || E1_CLIENTE || E1_LOJA || E1_PREFIXO || E1_NUM"				+ CRLF
		cUpdSE1 += " 		IN"																		+ CRLF
		cUpdSE1 += " 		("																		+ CRLF
		cUpdSE1 += "			SELECT DISTINCT"													+ CRLF
		cUpdSE1 += "				D1_FILIAL || D1_FORNECE || D1_LOJA || D1_SERIORI || D1_NFORI"	+ CRLF
		cUpdSE1 += "			FROM "			+ retSQLName( "SF1" ) + " SF1"						+ CRLF
		cUpdSE1 += "			INNER JOIN "	+ retSQLName( "SD1" ) + " SD1"						+ CRLF
		cUpdSE1 += "			ON"																	+ CRLF
		cUpdSE1 += "					SD1.D1_SERIE	=	SF1.F1_SERIE"							+ CRLF
		cUpdSE1 += "				AND SD1.D1_DOC		=	SF1.F1_DOC"								+ CRLF
		cUpdSE1 += "				AND SD1.D1_LOJA		=	SF1.F1_LOJA"							+ CRLF
		cUpdSE1 += "				AND	SD1.D1_FORNECE	=	SF1.F1_FORNECE"							+ CRLF
		cUpdSE1 += " 				AND	SD1.D1_FILIAL	=	SF1.F1_FILIAL"							+ CRLF
		cUpdSE1 += " 				AND	SD1.D_E_L_E_T_	<>	'*'"									+ CRLF
		cUpdSE1 += " 			WHERE"																+ CRLF
		cUpdSE1 += "					SF1.F1_TIPO		=	'D'"									+ CRLF
		cUpdSE1 += "				AND	SF1.F1_SERIE	=	'" + SF1->F1_SERIE		+ "'"			+ CRLF
		cUpdSE1 += "				AND SF1.F1_DOC		=	'" + SF1->F1_DOC		+ "'"			+ CRLF
		cUpdSE1 += "				AND SF1.F1_LOJA		=	'" + SF1->F1_LOJA		+ "'"			+ CRLF
		cUpdSE1 += "				AND	SF1.F1_FORNECE	=	'" + SF1->F1_FORNECE	+ "'"			+ CRLF
		cUpdSE1 += " 				AND	SF1.F1_FILIAL	=	'" + SF1->F1_FILIAL		+ "'"			+ CRLF
		cUpdSE1 += " 				AND	SF1.D_E_L_E_T_	<>	'*'"									+ CRLF
		cUpdSE1 += " 		)"																		+ CRLF
		cUpdSE1 += "		AND E1_LOJA		=	'" + SF1->F1_LOJA		+ "'"						+ CRLF
		cUpdSE1 += "		AND	E1_CLIENTE	=	'" + SF1->F1_FORNECE	+ "'"						+ CRLF
		cUpdSE1 += " 		AND	E1_FILIAL	=	'" + SF1->F1_FILIAL		+ "'"						+ CRLF
		cUpdSE1 += " 		AND	D_E_L_E_T_	<>	'*'"												+ CRLF

//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

		if tcSQLExec( cUpdSE1 ) < 0
			conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
		endif


		IF INCLUI

			C_PREFIXO 	:= ""
			C_NUM 		:= ""
			C_PARCELA 	:= ""
			C_TIPO		:= ""
			C_CLIENTE 	:= ""
			C_LOJA 		:= ""
			C_PORTADO 	:= ""
			C_NUMBOR 	:= ""
			C_VALOR 	:= 0
			C_SALDO 	:= 0
			C_SITUACA 	:= ""
			C_NUMCART   := ""
			C_OCORR  	:= ""
			C_DESCRI 	:= ""

			C_PORTADO := GETADVFVAL("SE1","E1_PORTADO",XFILIAL("SE1")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_SERIORI+SD1->D1_NFORI,2,"")

			cQuery1  = " SELECT E1_PREFIXO,E1_NUM,E1_PARCELA,E1_NUMCART,E1_TIPO,E1_CLIENTE,E1_LOJA,E1_PORTADO,E1_NUMBOR,E1_VALOR,E1_SALDO,E1_SITUACA,EB_OCORR,EB_DESCRI "
			cQuery1 += " FROM " + RetSqlName("SE1") + " "
			cQuery1 += " LEFT OUTER JOIN " + RetSqlName("SEB") + " ON EB_BXTIT<>' ' AND EB_BANCO =  '"+C_PORTADO+"' "
			cQuery1 += " WHERE E1_PREFIXO='"+SD1->D1_SERIORI+"' AND SE1010.D_E_L_E_T_<>'*' AND E1_CLIENTE='"+SD1->D1_FORNECE+"' AND E1_NUM='"+SD1->D1_NFORI+"' "

			If Select("TEMP2") > 0
				TEMP2->(dbCloseArea())
			EndIf
			cQuery1  := ChangeQuery(cQuery1)
			dbUseArea( .T. ,"TOPCONN",TcGenQry(,,cQuery1),"TEMP2", .T. , .F. )
			dbSelectArea("TEMP2")
			TEMP2->(dbGoTop())


			While TEMP2->(!Eof())

				C_PREFIXO 	:= TEMP2->E1_PREFIXO
				C_NUM 		:= TEMP2->E1_NUM
				C_PARCELA 	:= TEMP2->E1_PARCELA
				C_TIPO		:= TEMP2->E1_TIPO
				C_CLIENTE 	:= TEMP2->E1_CLIENTE
				C_LOJA 		:= TEMP2->E1_LOJA
				C_PORTADO 	:= TEMP2->E1_PORTADO
				C_NUMBOR 	:= TEMP2->E1_NUMBOR
				C_VALOR 	:= TEMP2->E1_VALOR
				C_SALDO 	:= TEMP2->E1_SALDO
				C_SITUACA 	:= TEMP2->E1_SITUACA

				C_OCORR  	:= TEMP2->EB_OCORR
				C_DESCRI 	:= TEMP2->EB_DESCRI


				IF C_PORTADO <> "" .AND.  C_VALOR <> C_SALDO


					DBSELECTAREA("FI2")
					DBSETORDER(1)
					IF !DBSEEK("      "+C_SITUACA+C_NUMBOR+C_PREFIXO+C_NUM+C_PARCELA+C_TIPO+C_CLIENTE+C_LOJA)

						DbSelectArea("FI2")
						RecLock("FI2", .T. )
						FI2->FI2_FILIAL  := xFilial("FI2")
						FI2->FI2_CARTEI := C_SITUACA
						FI2->FI2_NUMBOR := C_NUMBOR
						FI2->FI2_PREFIX := C_PREFIXO
						FI2->FI2_TITULO := C_NUM
						FI2->FI2_PARCEL := C_PARCELA
						FI2->FI2_TIPO   := C_TIPO
						FI2->FI2_CODCLI := C_CLIENTE
						FI2->FI2_LOJCLI := C_LOJA
						FI2->FI2_DTOCOR := Date()
						FI2->FI2_DTGER  := Date()
						FI2->FI2_OCORR  := 	C_OCORR
						FI2->FI2_DESCOC :=  C_DESCRI
						FI2->FI2_GERADO := "2"
						FI2->FI2_VALANT := TRANS(C_VALOR,"9999999.99")
						FI2->FI2_VALNOV := TRANS(C_SALDO,"9999999.99")
						FI2->FI2_CAMPO  := "E1_SALDO"
						FI2->(MsUnlock())
					ENDIF

					dbSelectArea("TEMP2")
				ENDIF
				TEMP2->(dbSKIP())
			EndDo
			TEMP2->(dbCloseArea())
		ENDIF
	ENDIF










	__execSql(cAliasSE1," SELECT R_E_C_N_O_ AS SE1RECNO FROM  "+RetSqlName('SE1')+" WHERE E1_NUM =  "+___SQLGetValue(CTITULO)+" AND E1_PREFIXO =  "+___SQLGetValue(CPREFIXO)+" AND E1_CLIENTE =  "+___SQLGetValue(CCLIENTE)+" AND E1_LOJA =  "+___SQLGetValue(CLOJA)+" AND D_E_L_E_T_= ' '",{},.F.)
	TcSetField(cAliasSE1,"SE1RECNO","N",10,0)

	(cAliasSE1)->(dbGoTop())

	dbSelectArea("SE1")

	While (cAliasSE1)->(!EOF())

		SE1->(dbGoTo((cAliasSE1)->SE1RECNO))

		SE1->(RecLock("SE1", .F. ))
		SE1->E1_ZATEND  := _DCUSR
		SE1->E1_ZDESRED	:= _cDREDE
		SE1->E1_ZSEGMEN	:= _cDSEG
		SE1->E1_NOMCLI  := SUBSTR(cNomeCF,1,20)
		SE1->E1_ZCNPJ	:= cCNPJ
		SE1->E1_XINTSFO	:= "P" //Flag para integração do titulo com Salesforce
		SE1->(MsUnlock())

		(cAliasSE1)->(dbSkip())
	End

	(cAliasSE1)->(dbCloseArea())

	RestArea(aArea)



Return

Static Function MGUsrFullName(cUser)
	Local aArea := GetArea()
	Local cName := ""

	If cUser == Nil
		cUser := RetCodUsr()
	EndIf

	PswOrder(1)
	If PswSeek(cUser)
		cName := PswRet(1)[1][4]
	Else
		cName := Space(15)
	EndIf

	RestArea(aArea)

Return( cName )
