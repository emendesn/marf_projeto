#Include 'Protheus.ch'
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"

Static _aErr

WSSTRUCT SUBSTITUTO
	WSDATA FILIAL	    as String
	WSDATA CODIGO		as String
	WSDATA APROVADOR    as String
	WSDATA CODSUBST		as String
	WSDATA TIPO			As String
	WSDATA DATAINICIO	as String
	WSDATA DATAFIM		as String
ENDWSSTRUCT

WSSTRUCT DADOS_SUBS
	WSDATA STATUS		as String
	WSDATA MSG			as String
	WSDATA DADOS		as Array Of SUBSTITUTO
ENDWSSTRUCT

//Para Atualizar Substitutos
WSSTRUCT DADSUBS
	WSDATA FILIAL as String
	WSDATA CODSUB as String
	WSDATA TIPO   as String
ENDWSSTRUCT

WSSTRUCT ARRSUBS
	WSDATA REGISTROS as ARRAY OF DADSUBS
ENDWSSTRUCT

WSSTRUCT RETORNOSUB
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

WSSERVICE MGFCOM20 DESCRIPTION "Substitutos" NAMESPACE "http://www.totvs.com.br/MGFCOM20"
	
	WSDATA WSENVIAR   as String
	WSDATA WSRETORNO  as DADOS_SUBS
	
	WSDATA WSARRAYSUB as ARRSUBS
	WSDATA WSRETSUBS  as RETORNOSUB
	
	WSMETHOD Substitutos     DESCRIPTION "Substitutos"
	WSMETHOD SubstIntegrados DESCRIPTION "Substitutos Integrados"
	
ENDWSSERVICE

WSMETHOD Substitutos WSRECEIVE WSENVIAR WSSEND WSRETORNO WSSERVICE MGFCOM20

	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	Local aRetorno	:= {}
	Local ni
	Local oBj		:= nil
		
	BEGIN SEQUENCE
		
		RpcSetType( 3 )
		PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010001' TABLES "ZAA","ZA9"
			oBj := WSClassNew( "DADOS_SUBS")
			oBj:DADOS := {}
			
			xEncSubs(@oBj)
			
			If Empty(oBj:DADOS)
				
				AADD(oBj:DADOS,WSClassNew( "SUBSTITUTO"))
				
				oBj:DADOS[len(oBj:DADOS)]:FILIAL 	 := ''
				oBj:DADOS[len(oBj:DADOS)]:CODIGO 	 := ''
				oBj:DADOS[len(oBj:DADOS)]:APROVADOR  := ''
				oBj:DADOS[len(oBj:DADOS)]:CODSUBST   := ''
				oBj:DADOS[len(oBj:DADOS)]:TIPO 		 := ''
				oBj:DADOS[len(oBj:DADOS)]:DATAINICIO := ''
				oBj:DADOS[len(oBj:DADOS)]:DATAFIM    := ''				
						
			EndIf
				
		RESET ENVIRONMENT

	RECOVER
		Conout('Problema Ocorreu as Horas: ' + TIME() )
	END SEQUENCE
	
	ErrorBlock( bError )
	
	If ValType(_aErr) == 'A'
		aRetorno := _aErr
	EndIf
	
	//Retorno
	::WSRETORNO := oBj
	
	If !Empty(aRetorno)  
		::WSRETORNO:STATUS  := aRetorno[1]
		::WSRETORNO:MSG	    := aRetorno[2]
	EndIf
	
Return .T.

Static Function xEncSubs(oBj)
	
	Local oItemObj	:= nil
	Local cNextAlias := GetNextAlias()	

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	
	BeginSql Alias cNextAlias
		
		SELECT *
		FROM 
			%Table:ZAA% ZAA
		WHERE 
			ZAA.ZAA_INTFLG =' '
	
	EndSql
	
	(cNextAlias)->(DbGoTop())
	
	While (cNextAlias)->(!EOF())
		
		//oItemObj := WSClassNew( "SUBSTITUTO")
		AADD(oBj:DADOS,WSClassNew( "SUBSTITUTO"))
		
		oBj:DADOS[len(oBj:DADOS)]:FILIAL 	 := (cNextAlias)->ZAA_EMPFIL
		oBj:DADOS[len(oBj:DADOS)]:CODIGO 	 := (cNextAlias)->ZAA_CODIGO
		oBj:DADOS[len(oBj:DADOS)]:APROVADOR  := (cNextAlias)->ZAA_CODAPR
		oBj:DADOS[len(oBj:DADOS)]:CODSUBST   := (cNextAlias)->ZAA_CODSUB
		oBj:DADOS[len(oBj:DADOS)]:TIPO 		 := (cNextAlias)->ZAA_TIPINT
		oBj:DADOS[len(oBj:DADOS)]:DATAINICIO := LEFT((cNextAlias)->ZAA_DTINIC,4) + '-' + SUBSTR((cNextAlias)->ZAA_DTINIC,5,2) + '-' + RIGHT((cNextAlias)->ZAA_DTINIC,2) 
		oBj:DADOS[len(oBj:DADOS)]:DATAFIM    := LEFT((cNextAlias)->ZAA_DTFINA,4) + '-' + SUBSTR((cNextAlias)->ZAA_DTFINA,5,2) + '-' + RIGHT((cNextAlias)->ZAA_DTFINA,2)
		
		(cNextAlias)->(dbSkip())
	EndDo	
	
	oBj:STATUS	:= 'OK'
	oBj:MSG		:= '' 
	
Return

WSMETHOD SubstIntegrados WSRECEIVE WSARRAYSUB WSSEND WSRETSUBS WSSERVICE MGFCOM20
	
	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	Local lConti	:= .T.
	Local aRetorno	:= {}
	Local ni
	Local cxFil		:= ""
	Local cCodSubs  := ""
	Local cTipo     := ""
	
	BEGIN SEQUENCE
		RpcSetType( 3 )
		PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010001' TABLES "ZAA","ZA9"
			BEGIN TRANSACTION
				For ni:= 1 to Len(::WSARRAYSUB:REGISTROS)
					
					cxFil 	 := ::WSARRAYSUB:REGISTROS[ni]:FILIAL
					cCodSubs := ::WSARRAYSUB:REGISTROS[ni]:CODSUB
					cTipo	 := ::WSARRAYSUB:REGISTROS[ni]:TIPO 
					
					lConti := xAtSubst(cxFil,cCodSubs,cTipo)
					
					If !lConti
						Exit
					EndIf
				
				Next ni

				If !lConti
					aRetorno := {'ERROR','Não Foi possivel realizar a integração Filial: ' + cxFil + ', Substituto: ' + cCodSubs + ' Tipo: ' + cTipo }
				Else
					aRetorno := {'OK','Integração Realizada com Sucesso.'}
				EndIf

			END TRANSACTION
		RESET ENVIRONMENT
	RECOVER
		Conout('Problema Ocorreu as Horas: ' + TIME() )
	END SEQUENCE
	
	ErrorBlock( bError )
	
	If ValType(_aErr) == 'A'
		aRetorno := _aErr
	EndIf
	
	//Retorno
	::WSRETSUBS := WSClassNew( "RETORNOSUB")
	::WSRETSUBS:STATUS  := aRetorno[1]
	::WSRETSUBS:MSG	    := aRetorno[2]
	
Return .T.

/*
=====================================================================================
Programa............: xAtSubst
Autor...............: Joni Lima
Data................: 15/01/2016
Descrição / Objetivo: Atualiza Substituto
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Atualiza Substituto apos interação do Fluig 
=====================================================================================
*/
Static Function xAtSubst(cxFil,cCod,cTipo)
	
	Local aArea 	:= GetArea()
	Local aAreaZA9	:= ZA9->(GetArea())
	Local aAreaZAA	:= ZAA->(GetArea())
	Local lRet		:= .T.
	local cUpd := ""	
	
	If cTipo <> 'E'
	
		dbSelectArea('ZA9')
		ZA9->(dbSetOrder(1))//ZA9_FILIAL, ZA9_CODIGO
		
		If ZA9->(dbSeek(xFilial('ZA9',cxFil) + cCod))
			
			dbSelectArea('ZAA')
			ZAA->(dbSetOrder(1))//ZAA_FILIAL, ZAA_CODIGO
			If ZAA->(DbSeek(xFilial('ZAA',cxFil) + cCod))
				RecLock('ZA9',.F.)
					ZA9->ZA9_INTFLG := 'S'
				ZA9->(MsUnlock())
				While ZAA->(!EOF()) .and. ZAA->(ZAA_FILIAL + ZAA_CODIGO) == xFilial('ZAA') + cCod
					RecLock('ZAA',.F.)
						ZAA->ZAA_INTFLG := 'S'
					ZAA->(MsUnlock())
					
					ZAA->(dbSkip())
				EndDo
			EndIf
		Else
			lRet := .F.
		EndIf
	Else

		 cUpd := "UPDATE " + RetSQLName("ZA9")  + " ZA9 " + CRLF
		 cUpd += " SET ZA9_INTFLG = 'S' "   + CRLF
		 cUpd += " WHERE ZA9_FILIAL = '" + xFilial('ZA9',cxFil) +"' AND " + CRLF
		 cUpd += " ZA9_CODIGO = '" + cCod + "' "
		 
		 tcSQLExec(cUpd)
		 
		 cUpd := "UPDATE " + RetSQLName("ZAA")  + " ZAA " + CRLF
		 cUpd += " SET ZAA_INTFLG = 'S' "   + CRLF
		 cUpd += " WHERE ZAA_FILIAL = '" + xFilial('ZAA',cxFil) +"' AND " + CRLF
		 cUpd += " ZAA_CODIGO = '" + cCod + "' "
		
		 tcSQLExec(cUpd)
	
	EndIf
	
	RestArea(aAreaZAA)
	RestArea(aAreaZA9)
	RestArea(aArea)
	
Return lRet

Static Function MyError(oError)
	
	Local nQtd := MLCount(oError:ERRORSTACK)
	Local ni
	Local cEr := ''
	
	nQtd := IIF(nQtd > 4,4,nQtd) //Retorna as 4 linhas 
	
	FOr ni:=1 to nQTd
		cEr += MemoLine(oError:ERRORSTACK,,ni)
	Next ni
	
	Conout( oError:Description + "Deu Erro" )
	_aErr := {'ERROR',cEr}
	BREAK
	
Return .T.