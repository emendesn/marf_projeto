#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#INCLUDE "FWMVCDEF.CH"

Static _aErr

/*
==========================================================================================================
Programa.:              MGFFAT52
Autor....:              Joni Lima do Carmo
Data.....:              14/09/2017
Descricao / Objetivo:   Consulta de Nota Fiscal para COMPROVEI
Doc. Origem:            Contrato GAP - FATCON- Consulta NFE
Solicitante:            Cliente
Uso......:              
Obs......:              Consulta de NFE - Parte WS Server consumir o Metodo Consulta NFE
==========================================================================================================
*/

WSSTRUCT FTRG52_DADOS

	WSDATA FILIAL	    as String
	WSDATA NOTA    		as String
	WSDATA TIPO	    	as String

ENDWSSTRUCT

WSSTRUCT DADOS_RETCN
	WSDATA STATUS		as String
	WSDATA MSG			as String
	WSDATA DADOS		as Array Of FTRG52_RETORNO
ENDWSSTRUCT

WSSTRUCT FTRG52_RETORNO

	WSDATA SERIE   as String
	WSDATA EMISSAO as String //'YYYYMMDD'
	WSDATA NUMNFE  as String
	WSDATA CHAVE   as String
	WSDATA VALOR   as String
	WSDATA CNPJ    as String
	
	WSDATA PEDIDO    as String
	WSDATA CODGER    as String
	WSDATA NOMGER    as String
	WSDATA EMAGER    as String
	WSDATA CELGER    as String
	
	WSDATA CODSUP    as String
	WSDATA NOMSUP    as String
	WSDATA EMASUP    as String
	WSDATA CELSUP    as String

	WSDATA RODNET    as String
	WSDATA DTENTR    as String //'YYYYMMDD'
	

ENDWSSTRUCT

WSSERVICE MGFFAT52 DESCRIPTION "Consulta NFE" NAMESPACE "http://www.totvs.com.br/MGFFAT52"
	WSDATA WSDADOS 	 as FTRG52_DADOS
	WSDATA WSRETORNO as DADOS_RETCN

	WSMETHOD RetInfNfe DESCRIPTION "Retorno de Informacao NFE"

ENDWSSERVICE


WSMETHOD RetInfNfe WSRECEIVE WSDADOS WSSEND WSRETORNO WSSERVICE MGFFAT52

	Local cxFil 	:= ::WSDADOS:FILIAL
	Local cNfe 		:= ::WSDADOS:NOTA
	Local cTipo		:= ::WSDADOS:TIPO 

	Local aRetorno	:= {}

	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	
	Local oBj		:= nil
	
	BEGIN SEQUENCE

		oBj := WSClassNew( "DADOS_RETCN" )
		oBj:DADOS := {}

		aRetorno := xConsNFE(cxFil,cNfe,cTipo,@oBj)//xMF27PcInf(cxFil,cPedido,cStatREC,cStatSIN,cStatSUF)

		If Empty(oBj:DADOS)
			
			AADD(oBj:DADOS,WSClassNew( "FTRG52_RETORNO"))
			
			oBj:DADOS[len(oBj:DADOS)]:SERIE 	:= ''
			oBj:DADOS[len(oBj:DADOS)]:EMISSAO 	:= ''
			oBj:DADOS[len(oBj:DADOS)]:NUMNFE  	:= ''
			oBj:DADOS[len(oBj:DADOS)]:CHAVE   	:= ''
			oBj:DADOS[len(oBj:DADOS)]:VALOR 	:= ''
			oBj:DADOS[len(oBj:DADOS)]:CNPJ 		:= ''
			oBj:DADOS[len(oBj:DADOS)]:PEDIDO    := ''
			oBj:DADOS[len(oBj:DADOS)]:CODGER    := ''
			oBj:DADOS[len(oBj:DADOS)]:NOMGER    := ''
			oBj:DADOS[len(oBj:DADOS)]:EMAGER    := ''
			oBj:DADOS[len(oBj:DADOS)]:CELGER    := ''
			oBj:DADOS[len(oBj:DADOS)]:CODSUP    := ''
			oBj:DADOS[len(oBj:DADOS)]:NOMSUP    := ''
			oBj:DADOS[len(oBj:DADOS)]:EMASUP    := ''
			oBj:DADOS[len(oBj:DADOS)]:CELSUP    := ''
			oBj:DADOS[len(oBj:DADOS)]:RODNET    := ''
			oBj:DADOS[len(oBj:DADOS)]:DTENTR    := ''
			
		EndIf

		RECOVER
		Conout('Problema Ocorreu as Horas: ' + TIME() )
	END SEQUENCE

	ErrorBlock( bError )

	If ValType(_aErr) == 'A'
		oBj:STATUS := _aErr[1]
		oBj:MSG	   := _aErr[2]
	EndIf

	//Retorno
	::WSRETORNO := oBj

Return .T.

Static Function MyError(oError)

	Local nQtd := MLCount(oError:ERRORSTACK)
	Local ni
	Local cEr := ''

	nQtd := IIF(nQtd > 4,4,nQtd) //Retorna as 4 linhas 

	FOr ni:=1 to nQTd
		cEr += MemoLine(oError:ERRORSTACK,,ni)
	Next ni

	Conout( oError:Description + "Deu Erro" )
	_aErr := {'E',cEr}
	BREAK

Return .T.

Static Function xConsNFE(cxFil,cNumNfe,cTipo,oBj)

	Local cSerSai	  := '200'//SuperGetMV("MGF_FAT52A",.F.,'200')//Serie da Nota de Saida

	Local cNextAlias := GetNextAlias()
	
	Default cTipo := "S"

	If cTipo == "S"

		BeginSql Alias cNextAlias
	
		SELECT DISTINCT
			SF2.F2_SERIE,
			SF2.F2_EMISSAO,
			SF2.F2_DOC,
			SF2.F2_CHVNFE,
			SF2.F2_VALBRUT,
            (CASE 
                WHEN SF2.F2_TIPO='B' OR SF2.F2_TIPO='D'
                    THEN SA2.A2_CGC
                ELSE    
                    SA1.A1_CGC
            END ) AS CGC,       
            SC5.C5_NUM,
			C5_FECENT AS DTENTR,
			SC5.C5_ZCROAD AS RODNET,
            SA31.A3_COD CODGER,
            SA31.A3_NOME NOMGER,
            SA31.A3_EMAIL EMAGER,
            SA31.A3_CEL CELGER,
            SA3.A3_COD CODSUB,
            SA3.A3_NOME NOMSUB,
            SA3.A3_EMAIL EMASUB,
            SA3.A3_CEL CELSUB,
            SF2.F2_HAUTNFE
			
		FROM  SF2010 SF2
		INNER JOIN  SD2010 SD2
             ON SF2.F2_FILIAL = SD2.D2_FILIAL
            AND SF2.F2_DOC    = SD2.D2_DOC
            AND SF2.F2_SERIE    = SD2.D2_SERIE
            AND SD2.%notdel%
        INNER JOIN  SC5010 SC5
             ON SC5.C5_FILIAL = SD2.D2_FILIAL
            AND SC5.C5_NUM = SD2.D2_PEDIDO
			AND SC5.%notdel%
        LEFT JOIN  SA1010 SA1
            ON  SA1.A1_COD = SF2.F2_CLIENTE 
            AND SA1.A1_LOJA = SF2.F2_LOJA
            AND SA1.%notdel%
        LEFT JOIN  SA2010 SA2
            ON  SA2.A2_COD = SF2.F2_CLIENTE 
            AND SA2.A2_LOJA = SF2.F2_LOJA
            AND SA2.%notdel%
        LEFT JOIN  SA3010 SA3
             ON  SA3.A3_FILIAL = ' ' 
             AND SA3.A3_COD = SC5.C5_VEND1
             AND SA3.%notdel%
        LEFT JOIN  ZBI010 ZBI
             ON ZBI.ZBI_REPRES = SC5.C5_VEND1
            AND ZBI.%notdel%
        LEFT OUTER JOIN  ZBH010 ZBH
                ON ZBI.ZBI_SUPERV	= ZBH.ZBH_CODIGO 
               AND	ZBI.ZBI_REGION  = ZBH.ZBH_REGION
               AND	ZBI.ZBI_TATICA  = ZBH.ZBH_TATICA
               AND	ZBI.ZBI_NACION  = ZBH.ZBH_NACION
               AND	ZBI.ZBI_DIRETO  = ZBH.ZBH_DIRETO
               AND	ZBH.ZBH_FILIAL	= ' '
               AND  ZBH.%notdel%
        LEFT OUTER JOIN  SA3010 SA31 
            ON ZBI.ZBI_REPRES	=	SA31.A3_COD
            AND	SA31.A3_FILIAL	=	' '
            AND SA31.%notdel%
        WHERE
            SF2.%notdel% AND
            SF2.F2_FILIAL = %exp:cxFil% AND
			SF2.F2_SERIE = %exp:cSerSai% AND
			SF2.F2_DOC = %exp:cNumNfe% AND
			SF2.F2_CHVNFE <> ' ' 
	
		EndSql

		(cNextAlias)->(DbGoTop())
		
		If (cNextAlias)->(!EOF())
			oBj:STATUS := "O"
			oBj:MSG := "Danfe Encontrada"
		Else
			oBj:STATUS := "E"
			oBj:MSG := 'Danfe Nao Encontrada ou sem chave da Sefaz, Verifique os Dados Filial: "' + cxFil + '",  Documento:"' + cNumNfe + '", Tipo: "' + cTipo + '"'
		EndIf
		
		While (cNextAlias)->(!EOF())
			
			AADD(oBj:DADOS,WSClassNew( "FTRG52_RETORNO"))
			
			oBj:DADOS[len(oBj:DADOS)]:SERIE 	:= (cNextAlias)->F2_SERIE
			oBj:DADOS[len(oBj:DADOS)]:EMISSAO 	:= (cNextAlias)->F2_EMISSAO
			oBj:DADOS[len(oBj:DADOS)]:NUMNFE  	:= (cNextAlias)->F2_DOC
			oBj:DADOS[len(oBj:DADOS)]:CHAVE   	:= (cNextAlias)->F2_CHVNFE
			oBj:DADOS[len(oBj:DADOS)]:VALOR 	:= cValToChar((cNextAlias)->F2_VALBRUT)
			oBj:DADOS[len(oBj:DADOS)]:CNPJ 		:= (cNextAlias)->CGC
			oBj:DADOS[len(oBj:DADOS)]:PEDIDO    := (cNextAlias)->C5_NUM
			if valtype((cNextAlias)->CODGER)=='U'
				oBj:DADOS[len(oBj:DADOS)]:CODGER    := ' '
			ELSE 	
				oBj:DADOS[len(oBj:DADOS)]:CODGER    := (cNextAlias)->CODGER
			ENDIF
			if valtype((cNextAlias)->NOMGER)=='U'
				oBj:DADOS[len(oBj:DADOS)]:NOMGER    := ' ' 
			ELSE 	
				oBj:DADOS[len(oBj:DADOS)]:NOMGER    := (cNextAlias)->NOMGER
			ENDIF
			if valtype((cNextAlias)->EMAGER)=='U'
				oBj:DADOS[len(oBj:DADOS)]:EMAGER    := ' '
			ELSE	
				oBj:DADOS[len(oBj:DADOS)]:EMAGER    := (cNextAlias)->EMAGER
			ENDIF
			if valtype((cNextAlias)->CELGER)=='U'
				oBj:DADOS[len(oBj:DADOS)]:CELGER    := ' '
			ELSE 	
				oBj:DADOS[len(oBj:DADOS)]:CELGER    := (cNextAlias)->CELGER
			ENDIF
			oBj:DADOS[len(oBj:DADOS)]:CODSUP    := (cNextAlias)->CODSUB
			oBj:DADOS[len(oBj:DADOS)]:NOMSUP    := (cNextAlias)->NOMSUB
			oBj:DADOS[len(oBj:DADOS)]:EMASUP    := (cNextAlias)->EMASUB
			oBj:DADOS[len(oBj:DADOS)]:CELSUP    := (cNextAlias)->CELSUB

			oBj:DADOS[len(oBj:DADOS)]:RODNET    := (cNextAlias)->RODNET
			oBj:DADOS[len(oBj:DADOS)]:DTENTR    := (cNextAlias)->DTENTR
			
			(cNextAlias)->(dbSkip())
		EndDo

		(cNextAlias)->(DbClosearea())
			
	ElseIf cTipo == "E"
		oBj:STATUS := "E"
		oBj:MSG := "Aguardando defini��es para Desenvolvimento"
	EndIf

Return .t.