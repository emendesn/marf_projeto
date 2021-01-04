#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
==============================================================================================
Programa............: MGFTAE21.
Autor...............: Marcelo Carneiro
Data................: 30/11/2016 
Descricao / Objetivo: Integração TAURA - ENTRADAS
Obs.................: Programa WebService Client Metodo: SituacaoEstoque e SituacaoEstoqueFEFO
===============================================================================================
*/
User Function MGFTAE21(xRet,xFilProd,xProd,xFEFO,xDTInicial,xDTFinal)

	Local cURLPost		:= ''
	Local oWSTAE21		:= Nil
	Local lRet          := .T.                          
	local bError 			:= ErrorBlock( { | oError | errorTAE21( oError ) } )

	Private oSaldo	    := Nil 
	Private aRet        := {0,0,0,0,0,"","",""}

	Private aMatriz   := {"01","010001"}  
	Private lIsBlind  :=  IsBlind() .OR. Type("__LocalDriver") == "U"                                                            
	Private cHtml     :=  ''    
	Private cFilProd  := xFilProd
	Private cProd     := xProd                 
	Private bFefo     := xFEFO
	Private dDtIni    := xDTInicial
	Private dDtFim    := xDTFinal                     
	Private oObjRet

	If isInCallStack("U_XEXEC")
		return
	Endif

	IF lIsBlind .and. !isInCallStack("U_MGFWSC27") .and. !isInCallStack("U_MGFFAT53") .and. !isInCallStack("U_MGFWSC05") .and. !isInCallStack("U_runFAT53") .and. !isInCallStack("U_runFATA5")
		RpcSetType(3)
		RpcSetEnv(aMatriz[1],aMatriz[2])
		If !LockByName("MGFINT21")
			U_MFCONOUT("JOB já em Execução : MGFINT21 " + DTOC(dDATABASE) + " - " + TIME() )
			RpcClearEnv()
			Return
		EndIf   
	EndIF

	U_MFConout('[MGFTAE21] [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + ' Iniciando leitura do Taura...' )

	BEGIN SEQUENCE
		IF bFefo
			cURLPost :=GetMV('MGF_TAE14',.F.,"http://spdwvtds001/wsintegracaoshape/api/v0/situacaoestoque/consultaestoqueFEFO")
		Else 
			cURLPost :=GetMV('MGF_TAE15',.F.,"http://SPDWVTDS002/wsintegracaoshape/api/v0/SituacaoEstoque/ConsultaEstoque")
		EndIF
	
		oSaldo := nil
	
		IF bFefo
			oSaldo := AE21_ESTOQUEFEFO():new()
		Else 
			oSaldo := AE21_ESTOQUE():new()
		EndIF
	
		oSaldo:setDados()
		oWSTAE21 := nil
		oWSTAE21 := MGFINT23():new(cURLPost, oSaldo,0, "", "", "", "","","", .T. )
		oWSTAE21:lLogInCons := .T. //Se informado .T. exibe mensagens de log de integração no console quando executado o método sendByHttpPost. Não obrigatório. DEFAULT .F.

		// tratamento para funcao padrao do frame, httpPost(), nao apresentar mensagem de "DATA COMMAND ERRO" quando executada em tela,	
		// forca funcao padrao IsBlind() a retornar .T.
		cSavcInternet	:= Nil
		cSavcInternet	:= __cInternet	
		__cInternet		:= "AUTOMATICO"
		oWSTAE21:SendByHttpPost()
		__cInternet := cSavcInternet

		IF oWSTAE21:lOk
			aRet  := {0,0,0,0,0,oWSTAE21:cPostRet,"",oWSTAE21:cJson}
			IF fwJsonDeserialize(oWSTAE21:cPostRet, @oObjRet)
				IF VALTYPE(oObjRet) == 'C'                   
					If !(fwJsonDeserialize(oObjRet, @oObjRet))
						lret := .F.
						BREAK
					Endif
				EndIF
				IF VALTYPE(oObjRet:PESO) == 'N'
					aRet[1]:= oObjRet:PESO // Estoque 
				Else
					lret := .F.
					BREAK
				EndIF
				IF VALTYPE(oObjRet:QUANT) == 'N'
					aRet[2]:= oObjRet:QUANT // Caixas
				Else
					lret := .F.
					BREAK
				EndIF
				IF VALTYPE(oObjRet:PECAS) == 'N'
					aRet[3]:= oObjRet:PECAS // Pecas
				Else
					lret := .F.
					BREAK
				EndIF

				IF VALTYPE(oObjRet:PESO_PRO) == 'N'
					aRet[5]:= oObjRet:PESO_PRO // Peso Medio
				Else
					lret := .F.
					BREAK
				EndIF
				if VALTYPE(oObjRet:CHAVEUID) == "C"
					aRet[7]:= oObjRet:CHAVEUID // UUID
				Else
					lret := .F.
					BREAK
				EndIF
                 // Deduzir nas quantidades o campo _SEQ = SEQUESTRADO ( BLOQUEADO)
                IF VALTYPE(oObjRet:PESO_SEQ) == 'N'
					aRet[1] -= oObjRet:PESO_SEQ // Estoque 
				EndIF
				IF VALTYPE(oObjRet:QUANT_SEQ) == 'N'
					aRet[2] -= oObjRet:QUANT_SEQ // Caixas
				EndIF
				IF VALTYPE(oObjRet:PECAS_SEQ) == 'N'
					aRet[3] -= oObjRet:PECAS_SEQ // Pecas
				EndIF
                
				oObjRet := nil
				freeObj( oObjRet )
				delClassINTF()
			
			Else

				lret := .F.
				BREAK

			EndIF
					
		Else

			aRet  := {0,0,0,0,0,oWSTAE21:CDETAILINT,"",oWSTAE21:cJson}
			lret := .F.
			BREAK
		
		EndIF

		oWSTAE21 := nil
		freeObj( oWSTAE21 )
		delClassINTF()

		oSaldo := nil
		freeObj( oSaldo )
		delClassINTF()
	
	RECOVER
		U_MFCONOUT('[MGFTAE21] [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + ' Problema Ocorreu em : ' + dToC(dDataBase) + " - " + time() )
	END SEQUENCE

	xRet := aRet //popular variavel de retorno

Return lRet

	******************************************************************************************************************
CLASS AE21_ESTOQUE
Data applicationArea   as ApplicationArea
Data Produto	       as String
Data Filial		       as String

Method New()
Method setDados()
//Return
EndClass
******************************************************************************************************************
Method new() Class AE21_ESTOQUE
self:applicationArea	:= ApplicationArea():new()
Return
******************************************************************************************************************
Method setDados() Class AE21_ESTOQUE

Self:Produto  := Alltrim(cProd)
Self:Filial   := cFilProd

Return
******************************************************************************************************************
CLASS AE21_ESTOQUEFEFO
Data applicationArea	  as ApplicationArea
Data Produto	          as String
Data Filial		          as String
Data DataValidadeInicial  as String
Data DataValidadeFinal    as String

Method New()
Method setDados()
endclass
Return
******************************************************************************************************************
Method new() Class AE21_ESTOQUEFEFO
self:applicationArea	:= ApplicationArea():new()
Return
******************************************************************************************************************
Method setDados() Class AE21_ESTOQUEFEFO

Self:Produto             := Alltrim(cProd)
Self:Filial              := cFilProd
Self:DataValidadeInicial := SUBSTR(DTOS(dDtIni),1,4)+'-'+SUBSTR(DTOS(dDtIni),5,2)+'-'+SUBSTR(DTOS(dDtIni),7,2)
Self:DataValidadeFinal   := SUBSTR(DTOS(dDtFim),1,4)+'-'+SUBSTR(DTOS(dDtFim),5,2)+'-'+SUBSTR(DTOS(dDtFim),7,2)

Return

//-------------------------------------------------------
//-------------------------------------------------------
static function errorTAE21( oError )
	local nQtd := MLCount(oError:ERRORSTACK)
	local ni
	local cEr := ''

	for ni:=1 to nQtd
		cEr += memoLine(oError:ERRORSTACK,,ni)
	next ni

	_aErr := { '0', cEr }
return .T.
