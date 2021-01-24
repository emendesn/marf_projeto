#Include 'Protheus.ch'
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"

Static _aErr

WSSTRUCT ITEMRATEIO
	WSDATA FILIAL	    as String
	WSDATA NOMEFILIAL	as String
	WSDATA ITEM    		as String
	WSDATA PERCENTUAL	as Float
	WSDATA CC			as String
	WSDATA CONTA		as String
	WSDATA ITEMCONTA	as String
	WSDATA CLASSEVALOR	as String
	WSDATA FILIALDES	as String
	WSDATA NOMEDES		as String
ENDWSSTRUCT

WSSTRUCT MGFRATEIO
	WSDATA STATUS		as String
	WSDATA MSG			as String
	WSDATA DADOS		as Array Of ITEMRATEIO
ENDWSSTRUCT

WSSTRUCT INFORMACOES
	WSDATA FILIAL		as String
	WSDATA SOLICITACAO	as String
	WSDATA ITEMSOLE		as String
	WSDATA TIPO			as String
ENDWSSTRUCT

WSSERVICE MGFCOM21 DESCRIPTION "Reteio" NAMESPACE "http://www.totvs.com.br/MGFCOM21"
	
	WSDATA WSINFORMA  	as INFORMACOES
	WSDATA WSRETORNO 	as MGFRATEIO
	
	WSMETHOD Rateio DESCRIPTION "Rateio"
	
ENDWSSERVICE

WSMETHOD Rateio WSRECEIVE WSINFORMA WSSEND WSRETORNO WSSERVICE MGFCOM21

	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	Local aRetorno	:= {}	
	Local oBj		:= nil
	
	Local cxEmp		:= '01'//SUBSTR(::WSINFORMA:FILIAL,1,2)
	Local cxFilial	:= ::WSINFORMA:FILIAL
	Local cSolic	:= ::WSINFORMA:SOLICITACAO
	Local cItemSc	:= ::WSINFORMA:ITEMSOLE	
	Local cTipo		:= ::WSINFORMA:TIPO
		
	BEGIN SEQUENCE

		RpcSetType( 3 )
		PREPARE ENVIRONMENT EMPRESA cxEmp FILIAL cxFilial TABLES "SCX","SC1"
			oBj := WSClassNew( "MGFRATEIO")
			oBj:DADOS := {}	
			
			xEncRateio(@oBj,cSolic,cItemSc,cTipo)
			
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

Static Function xEncRateio(oBj,cSolic,cItemSc,cTipo)
	
	Local oItemObj		:= nil
	Local cNextAlias 	:= GetNextAlias()	
	Local cNomFilDes	:= ''
	
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	
	If cTipo == 'SC'
	
		BeginSql Alias cNextAlias
			
			SELECT
				SCX.CX_FILIAL,
				SCX.CX_ITEM,
				SCX.CX_PERC,
				SCX.CX_CC,
				SCX.CX_CONTA,
				SCX.CX_ITEMCTA,
				SCX.CX_CLVL,
				SCX.CX_ZFILDES
			FROM 
				%Table:SCX% SCX
			WHERE 
				SCX.CX_FILIAL = %xFilial:SCX% AND
				SCX.%NotDel% AND
				SCX.CX_SOLICIT = %Exp:cSolic% AND
				SCX.CX_ITEMSOL = %Exp:cItemSc%
			
		EndSql
		
		(cNextAlias)->(DbGoTop())
		
		While (cNextAlias)->(!EOF())
			
			AADD(oBj:DADOS,WSClassNew( "ITEMRATEIO"))
			

			oBj:DADOS[len(oBj:DADOS)]:FILIAL 		:= (cNextAlias)->CX_FILIAL
			oBj:DADOS[len(oBj:DADOS)]:NOMEFILIAL	:= (FWFilialName(SUBSTR((cNextAlias)->CX_FILIAL,1,2),(cNextAlias)->CX_FILIAL))
			oBj:DADOS[len(oBj:DADOS)]:ITEM  		:= (cNextAlias)->CX_ITEM
			oBj:DADOS[len(oBj:DADOS)]:PERCENTUAL	:= (cNextAlias)->CX_PERC
			oBj:DADOS[len(oBj:DADOS)]:CC 			:= (cNextAlias)->CX_CC
			oBj:DADOS[len(oBj:DADOS)]:CONTA    		:= (cNextAlias)->CX_CONTA
			oBj:DADOS[len(oBj:DADOS)]:ITEMCONTA   	:= (cNextAlias)->CX_ITEMCTA
			oBj:DADOS[len(oBj:DADOS)]:CLASSEVALOR	:= (cNextAlias)->CX_CLVL
			oBj:DADOS[len(oBj:DADOS)]:FILIALDES    	:= (cNextAlias)->CX_ZFILDES

			If !Empty(CX_ZFILDES)
				cNomFilDes := FWFilialName( SUBSTR((cNextAlias)->CX_ZFILDES,1,2),(cNextAlias)->CX_ZFILDES)
				oBj:DADOS[len(oBj:DADOS)]:NOMEDES	:= cNomFilDes
			Else
				oBj:DADOS[len(oBj:DADOS)]:NOMEDES := ""
			EndIf
			
			(cNextAlias)->(dbSkip())
		EndDo	
	
	EndIf
	
	oBj:STATUS	:= 'OK'
	oBj:MSG		:= '' 
	
Return

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