#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)             
/*
==========================================================================================================
Programa.:              MGFEST79
Autor....:              Wagner Neves
Data.....:              24/07/2020 
Descricao / Objetivo:   Integração TAURA - Protheus
Doc. Origem:            RITM0031994 - CONSULTA ESTOQUE EMBALAGENS PROTHEUS
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WbeService Server Metodo ConsultaEmbalagemProtheus
==========================================================================================================
*/
WSSTRUCT EST79_CONSULTA
	WSDATA idEmpresa    as String
    WSDATA idProduto    as String
    WSDATA dataInicial  as String
    WSDATA dataFinal    as String
ENDWSSTRUCT

WSSTRUCT EST79_AREQSALDOS
   WSDATA AREQSALDOS  as Array of EST79_CONSULTA OPTIONAL
ENDWSSTRUCT

WSSTRUCT EST79_ITENS
	WSDATA idEmpresa	 as String
    WSDATA idProduto     as String
	WSDATA dataInicial   as String
	WSDATA dataFinal     as String
    WSDATA qtdEmTransito as Float
    WSDATA qtdMinima     as Float
    WSDATA qtdSaldo      as Float
ENDWSSTRUCT

WSSTRUCT EST79_RETORNO
   WSDATA ITENS  as Array of EST79_ITENS
ENDWSSTRUCT

WSSERVICE MGFEST79 DESCRIPTION "Consulta Saldo Estoque Embalagem Protheus" NameSpace "http://www.totvs.com.br/MGFEST79"
	WSDATA WSCONSULTA  as EST79_AREQSALDOS //CONSULTA
	WSDATA WSRETORNO   as EST79_RETORNO

	WSMETHOD EstoqueEmbalagemProtheus DESCRIPTION "Consulta Saldo Estoque Embalagem Protheus"
ENDWSSERVICE

WSMETHOD EstoqueEmbalagemProtheus  WSRECEIVE WSCONSULTA WSSEND WSRETORNO WSSERVICE MGFEST79
     
Local nI := 0 
Private cAlmox      := GetMv("MGF_EST79A")
Private aRetorno    := {} 
Private aRec     	:= {}

For nI := 1 To len(WSCONSULTA:areqsaldos) //len(oobjtmp:_mgf_wsconsulta:_mgf_areqsaldos)
	Private nSaldoTrans   := 0
	Private nSaldoMin 	  := 0
	Private nSaldoEst	  := 0
	Private _cFilial      := WSCONSULTA:areqsaldos[nI]:IDEMPRESA //oobjtmp:_mgf_wsconsulta:_mgf_areqsaldos[nI]:_mgf_est79_consulta:_mgf_idempresa:TEXT
	Private _cProduto     := WSCONSULTA:areqsaldos[nI]:IDPRODUTO //oobjtmp:_mgf_wsconsulta:_mgf_areqsaldos[nI]:_mgf_est79_consulta:_mgf_idproduto:TEXT
	Private _dDataInicial := AllTrim(StrTran(WSCONSULTA:areqsaldos[nI]:datainicial, "-","")) //Alltrim(StrTran(wsconsulta:areqsaldos[1]:_mgf_est79_consulta:_mgf_datainicial:TEXT, "-", "" ))
	Private _dDataFinal   := AllTrim(StrTran(WSCONSULTA:areqsaldos[nI]:datafinal, "-",""))//Alltrim(StrTran(oobjtmp:_mgf_wsconsulta:_mgf_areqsaldos[1]:_mgf_est79_consulta:_mgf_datafinal:TEXT, "-", "" ))
	Private aRec := {}
	fEstTransito(_cFilial,_cProduto,_dDataInicial,_dDataFinal)
	fEstMinimo(_cFilial,_cProduto,_dDataInicial,_dDataFinal)
	
	_cCodigo := _cFilial+_cProduto+space(TamSX3("B2_COD")[1]-len(alltrim(_cProduto)))+"01"
	SB2->(DBSETORDER(1))
	SB2->(MSSEEK(_cCodigo))
	nSaldoEst += SaldoSB2() 

	_cCodigo := _cFilial+_cProduto+space(TamSX3("B2_COD")[1]-len(alltrim(_cProduto)))+"41"
	SB2->(DBSETORDER(1))
	SB2->(MSSEEK(_cFilial+_cProduto+space(TamSX3("B2_COD")[1]-len(alltrim(_cProduto)))+"41"))
	nSaldoEst += SaldoSB2() 

//	fEstSaldo(_cFilial,_cProduto,_dDataInicial,_dDataFinal)

	AAdd(aRec,SUBS(_dDataFinal,1,4)+"-"+SUBS(_dDataFinal,5,2)+"-"+SUBS(_dDataFinal,7,2))
	AAdd(aRec,SUBS(_dDataInicial,1,4)+"-"+SUBS(_dDataInicial,5,2)+"-"+SUBS(_dDataInicial,7,2))
	AAdd(aRec,_cFilial)
	AAdd(aRec,_cProduto)
	AAdd(aRec,nSaldoTrans)
	AAdd(aRec,nSaldoMin)
	AAdd(aRec,nSaldoEst)
	AAdd(aRetorno,aRec)
Next
/*
IF Len(aRetorno) == 0 
	aRec := {}
	AAdd(aRec,'')
	AAdd(aRec,'')
	AAdd(aRec,'')
	AAdd(aRec,'')
	AAdd(aRec,0)
	AAdd(aRec,0)
	AAdd(aRec,0)
	AAdd(aRetorno,aRec)
EndIF
*/
::WSRETORNO := WSClassNew( "EST79_RETORNO")
::WSRETORNO:ITENS := {}

For nI := 1 To Len(aRetorno)
	aAdd(::WSRETORNO:ITENS,WSClassNew( "EST79_ITENS"))
	::WSRETORNO:ITENS[nI]:datafinal      := aRetorno[nI,1]
	::WSRETORNO:ITENS[nI]:datainicial    := aRetorno[nI,2]
	::WSRETORNO:ITENS[nI]:idempresa      := aRetorno[nI,3]
	::WSRETORNO:ITENS[nI]:idproduto      := aRetorno[nI,4]
	::WSRETORNO:ITENS[nI]:qtdEmTransito  := aRetorno[nI,5]
	::WSRETORNO:ITENS[nI]:qtdMinima      := aRetorno[nI,6]
	::WSRETORNO:ITENS[nI]:qtdSaldo       := aRetorno[nI,7]

Next nI
Return .T.

// Estoque em Trânsito
Static Function fEstTransito(_cFilial,_cProduto,_dDataInicial,_dDataFinal)
	cQryTran := " "
	cQryTran := "SELECT ZGG_FILIAL,ZGG_PROD,SUM(ZGG_QUANT) QTDPED "
	cQryTran += " FROM "+RetSqlName("ZGG")+" ZGG"
	cQryTran += " WHERE "
	cQryTran += " ZGG.ZGG_FILIAL = '"+_cFilial+"' AND "
	cQryTran += " ZGG.ZGG_PROD='"+_cProduto+"' AND "
	cQryTran += " ZGG.ZGG_DTPRF BETWEEN '"+_dDataInicial+"' AND '"+_dDataFinal+"' AND "
	cQryTran += " ZGG.D_E_L_E_T_ = ' ' "
	cQryTran += " GROUP BY ZGG_FILIAL,ZGG_PROD"
	If Select("QRYTRANS") > 0
		QRYTRANS->(dbCloseArea())
	EndIf
	tcQuery cQryTran New Alias "QRYTRANS"
	Conout("[MGFEST79] - Consulta Estoque em Trânsito-ZGG")
	Conout(cQryTran)
	nSaldoTrans := QRYTRANS->QTDPED
	QRYTRANS->(dbCloseArea())

	If nSaldoTrans == 0
		nSaldoTrans := 0
		If Select("QRYPED") > 0
			QRYPED->(dbCloseArea())
		EndIf
		cQryPed := " "
		cQryPed := "SELECT C7_FILIAL,C7_PRODUTO,SUM(C7_QUANT-C7_QUJE) QTDPED"
		cQryPed += " FROM "+RetSqlName("SC7")+" TSC7" 
		cQryPed += " WHERE"  
		cQryPed += " TSC7.C7_FILIAL  = '"+_cFilial+"' AND "
		cQryPed += " TSC7.C7_PRODUTO = '"+_cProduto+"' AND "
		cQryPed += " TSC7.C7_DATPRF BETWEEN '"+_dDataInicial+"' AND '"+_dDataFinal+"' AND "
		cQryPed += " TSC7.C7_QUJE < TSC7.C7_QUANT AND "
		cQryPed += " TSC7.C7_RESIDUO = ' ' AND "
		cQryPed += " TSC7.D_E_L_E_T_ = ' '
		cQryPed += " GROUP BY C7_FILIAL,C7_PRODUTO"
		tcQuery cQryPed New Alias "QRYPED"
		Conout("[MGFEST79] - Consulta Estoque em Trânsito-SC7")
		Conout(cQryPed)
		nSaldoTrans := QRYPED->QTDPED
	ENDIF
	
Return nSaldoTrans

Static Function fEstMinimo(_cFilial,_cProduto,_dDataInicial,_dDataFinal)
	// Estoque Mínimo
	cQryEstMin := " "
	cQryEstMin := "SELECT ZG9_CODPRO,ZGA_CODPRO,ZGA_ESTMIN"
	cQryEstMin += " FROM "+RetSqlname("ZG9") +" ZG9"
	cQryEstMin += " INNER JOIN "+RetSqlName("ZGA")+" ZGA ON ZGA_CODPRO=ZG9.ZG9_CODPRO"
	cQryEstMin += " WHERE "
	cQryEstMin += " ZGA.ZGA_ITEFIL='"+_cFilial+"' AND"
	cQryEstMin += " ZGA.ZGA_CODPRO='"+_cProduto+"' AND"
	cQryEstMin += " ZG9.D_E_L_E_T_ = ' ' AND"
	cQryEstMin += " ZGA.D_E_L_E_T_ = ' ' "
	If Select("QRYESTMIN") > 0
		QRYESTMIN->(dbCloseArea())
	EndIf
	tcQuery cQryEstMin New Alias "QRYESTMIN"
	Conout("[MGFEST79] - Consulta Estoque Minimo")
	Conout(cQryEstMin)
	nSaldoMin := QRYESTMIN->ZGA_ESTMIN
Return nSaldoMin

/*
Static Function fEstSaldo(_cFilial,_cProduto,_dDataInicial,_dDataFinal)
	// Saldo Estoque
	cQrySaldo := " "
	cQrySaldo := "SELECT B2_FILIAL,B2_COD,B2_LOCAL,B2_QATU"
	cQrySaldo += " FROM "+RetSqlname("SB2") +" SB2"
	cQrySaldo += " WHERE "
	cQrySaldo += " SB2.B2_FILIAL = '"+_cFilial+"' AND"
	cQrySaldo += " SB2.B2_COD = '"+_cProduto+"' AND"
	cQrySaldo += " SB2.B2_LOCAL IN "+cAlmox+" AND"
	cQrySaldo += " SB2.D_E_L_E_T_ = ' ' "
	If Select("QRYSALDO") > 0
		QRYSALDO->(dbCloseArea())
	EndIf
	tcQuery cQrySaldo New Alias "QRYSALDO"
	MemoWrite("c:\Temp\MGFEST79_QRYSALDO.txt",cQrySaldo)
	Conout("[MGFEST79] - Consulta Saldo em Estoque")
	Conout(cQrySaldo)
	nSaldoEst := QRYSALDO->B2_QATU			
Return nSaldoEst
*/