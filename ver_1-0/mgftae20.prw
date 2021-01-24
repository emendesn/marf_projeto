#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: MGFTAE20
Autor...............: Marcelo Carneiro
Data................: 30/11/2016 
Descricao / Objetivo: Integração TAURA - ENTRADAS
Doc. Origem.........: Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Programa WebService Client Metodo: SituacaoEstoque
=====================================================================================
*/
User Function MGFTAE20(xRet,xFilProd,xProd,xEntrega,xPerc)

Local cURLPost		:= ''
Local oWSTAE20		:= Nil
Local lRet          := .F.                          

Private oSaldo	    := Nil 

Private aMatriz   := {"01","010001"}  
Private lIsBlind  :=  IsBlind() .OR. Type("__LocalDriver") == "U"                                                            
Private cHtml     :=  ''    
Private cFilProd  := xFilProd
Private cProd     := xProd
Private dEntrega  := xEntrega
Private nPerc     := xPerc 
Private oObjRet

IF lIsBlind
	RpcSetType(3)
	RpcSetEnv(aMatriz[1],aMatriz[2])
	If !LockByName("MGFINT41")
		Conout("JOB já em Execução : MGFINT41 " + DTOC(dDATABASE) + " - " + TIME() )
		RpcClearEnv()
		Return
	EndIf   
EndIF

cURLPost		:= GetMV('MGF_TAE13',.F.,'http://SPDWVTDS002/wsintegracaoshape/api/v0/SituacaoEstoque/consultaestoqueValidade' )

oSaldo := nil
oSaldo := AE20_ESTOQUEVALIDADE():new()
oSaldo:setDados()
oWSTAE20 := nil                                               
oWSTAE20 := MGFINT23():new(cURLPost, oSaldo,0, "", "", "", "","","", .T. )
StaticCall(MGFTAC01,ForcaIsBlind,oWSTAE20)
//MemoWrite("c:\temp\MGFTAE20"+StrTran(Time(),":","")+".txt",oWSTAE20:cJson)
IF oWSTAE20:lOk
	fwJsonDeserialize(oWSTAE20:cPostRet, @oObjRet)    
	xRet  := {"",""}
	IF fwJsonDeserialize(oWSTAE20:cPostRet, @oObjRet)
		lRet := .T.
		IF VALTYPE(oObjRet) == 'C'                   
		    fwJsonDeserialize(oObjRet, @oObjRet)
		EndIF
		IF VALTYPE(oObjRet:DataValidadeMinima) == 'C'
		   xRet[1]:= STRTRAN(SUBSTR(oObjRet:DataValidadeMinima,1,10),"-","") 
		EndIF
		IF VALTYPE(oObjRet:DataValidadeMaxima) == 'C'
		   xRet[2]:= STRTRAN(SUBSTR(oObjRet:DataValidadeMaxima,1,10),"-","")  
		EndIF
	EndIF
EndIF
Return lRet

******************************************************************************************************************
CLASS AE20_ESTOQUEVALIDADE
	Data applicationArea	  as ApplicationArea
	Data Produto	      	  as String
	Data Filial		          as String
    Data DataEntrega          as String
    Data fatorValidadeInicial as float
    Data fatorValidadeFinal   as float 

	Method New()
	Method setDados()
Return
******************************************************************************************************************
Method new() Class AE20_ESTOQUEVALIDADE
	self:applicationArea	:= ApplicationArea():new()
Return
******************************************************************************************************************
Method setDados() Class AE20_ESTOQUEVALIDADE
	
	Self:Produto              := cProd
	Self:Filial               := cFilProd
	Self:DataEntrega		  := dEntrega		
	Self:fatorValidadeInicial := 0		
	Self:fatorValidadeFinal   := 1-nPerc
	
Return
