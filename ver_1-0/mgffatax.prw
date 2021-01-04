#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"
/*
=====================================================================================
Programa.:              MGFFATAX
Autor....:              Rafael Garcia
Data.....:              27/03/2019
Descricao / Objetivo:   Integracao PROTHEUS x Multiembarcador - Integra NF 
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              WS Server para Integracao PROTHEUS x Multiembarcador - Integra NF 
Componentes da integracao:
Integracao PROTHEUS x Multiembarcador - Integra NF 
=====================================================================================
*/

WSSTRUCT MGFFATAXRequisINF
	WSDATA Filial		 AS string
	WSDATA OrdemEmbarque AS string
	WSDATA Pv 			 AS string
	
ENDWSSTRUCT


WSSTRUCT MGFFATAXRetornoINF
	WSDATA status   AS string
	WSDATA Msg  	AS string
	WSDATA json		AS String
ENDWSSTRUCT


/***************************************************************************
* Definicao do Web Service. Add Carga multiembarcador.				                       *
***************************************************************************/
WSSERVICE MGFFATAX DESCRIPTION "Integracao Protheus x Multiembarcador - Integra NF " NameSpace "http://totvs.com.br/MGFFATAX.apw"

	// Passagem dos parametros de entrada
	WSDATA MGFFATAXReqINF AS MGFFATAXRequisINF
	// Retorno (array)
	WSDATA MGFFATAXRetINF AS MGFFATAXRetornoINF

	WSMETHOD RetornoINF DESCRIPTION "Integracao Protheus x Multiembarcador - Integra NF "

ENDWSSERVICE

/************************************************************************************
** Metodo RetornoCarga
** Grava dados de retorno de Carga - Protocolo ou MsgErro
************************************************************************************/
WSMETHOD RetornoINF WSRECEIVE	MGFFATAXReqINF WSSEND MGFFATAXRetINF WSSERVICE MGFFATAX

	Local aRetFuncao := {}
	Local lReturn	:= .T.

	aRetFuncao	:= u_MGFFATAX(	{	::MGFFATAXReqINF:Filial		,;
	::MGFFATAXReqINF:OrdemEmbarque,;
	::MGFFATAXReqINF:PV			})	// Passagem de parametros para rotina

	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFFATAXRetINF :=  WSClassNew( "MGFFATAXRetornoINF" )
	::MGFFATAXRetINF:STATUS	:= aRetFuncao[1]
	::MGFFATAXRetINF:MSG	:= aRetFuncao[2]
	::MGFFATAXRetINF:json	:= aRetFuncao[3]


Return lReturn

user Function MGFFATAX( aEmb)

	local cJson 			:= ""
	local oaddNF			
	local oIntNF
	local aRet:={}
	local cQuery :=" "

	RpcSetEnv( "01" ,aEmb[1] , Nil, Nil, "EST", Nil )

	QWSFATAX(aEmb) // CRIAR FUNCAO QUE RETORNA A QUERY DOS REGISTRO



	if !QFATAX->(EOF()) 

		oaddNF 	 := nil
		oaddNF 	 := addNF():new()

		oaddNF:Token:= getmv("MGF_TOKMEM")

		oaddNF:IntegrarNotasFiscais := {} 

		oIntNF := IntegrarNotasFiscais():new()
		//PROTOCOLO
		oIntNF:protocolo:={}
		oIntNF:protocolo:= protocolo():new()
		oIntNF:protocolo:protocoloIntegracaoCarga	:=	QFATAX->DAI_XPROTO
		oIntNF:protocolo:protocoloIntegracaoPedido	:=	QFATAX->DAI_XPROPV
		//TokensXMLNotasFiscais
		oIntNF:TokensXMLNotasFiscais := {}
		oIntNF:TokensXMLNotasFiscais := TokensXMLNotasFiscais():new()
		//TOKENNF
		oIntNF:TokensXMLNotasFiscais:TokenNF := {}
		oIntNF:TokensXMLNotasFiscais:TokenNF := TokenNF():NEW()
		oIntNF:TokensXMLNotasFiscais:TokenNF:TipoNotaFiscalIntegrada:= "FATURAMENTO"
		oIntNF:TokensXMLNotasFiscais:TokenNF:Token := QFATAX->F2_XTOKEN
		//averbacao
		oIntNF:Averbacao:={}
		oIntNF:Averbacao:= Averbacao():new()

		oIntNF:Averbacao:CNPJResponsavel	:=	QFIL(QFATAX->F2_FILIAL )
		oIntNF:Averbacao:CNPJSeguradora		:=	QFATAX->ZBS_CNPJSE
		oIntNF:Averbacao:NomeSeguradora		:=	QFATAX->ZBS_NSEGUR
		oIntNF:Averbacao:NumeroApolice		:=	QFATAX->ZBS_NUMAPO
		oIntNF:Averbacao:NumeroAverbacao	:=	QFATAX->ZBS_AVERBA
		aadd( oaddNF:IntegrarNotasFiscais, oIntNF )	

		
		
		conout(cJson)
		cJson:=FWJsonSerialize(oaddNF,.F.,.T.)


		cQuery := " UPDATE " + RetSqlname("SF2") + " "
		cQuery += " SET 	F2_XINTMEM = 'P', "
		cQuery += " F2_XOPENF='I'"  			
		cQuery += " WHERE F2_FILIAL = '" + QFATAX->F2_FILIAL + "' "
		cQuery += "	AND F2_DOC= '" + QFATAX->F2_DOC + "' "
		cQuery += " AND F2_SERIE = '"+QFATAX->F2_SERIE+"' "
		cQuery += "	AND D_E_L_E_T_ <> '*' "				
		TcSqlExec(cQuery)

		IF ALLTRIM(QFATAX->ZBS_NUM)<>'' .AND. ALLTRIM(QFATAX->ZBS_CNPJSE) <>''
			aRet:={"1","Registro Localizado, averbacao localizada",cJson}
		elseif ALLTRIM(QFATAX->ZBS_NUM)<>'' .AND. ALLTRIM(QFATAX->ZBS_CNPJSE) ==''
			aRet:={"3","Registro Localizado, averbacao nao localizada, aguardando",cJson}
		elseif 	ALLTRIM(QFATAX->ZBS_NUM)==''
			aRet:={"4","Registro Localizado, nao necessita de averbacao ",cJson}
		ENDIF	
			
	

	else
		aRet:={"2","Registro nao Localizado"," "}
	endif
	IF SELECT("QFATAX") > 0
		QFATAX->( dbCloseArea() )
	ENDIF   

return aRet

//-------------------------------------------------------------------
// Seleciona Notas a serem enviadas
//-------------------------------------------------------------------
static function QWSFATAX(aEmb)

	local cQ := ""

	cQ := " SELECT  "
	cQ += " SF2.F2_FILIAL,"+CRLF
	cQ += " SF2.F2_DOC,"+CRLF
	cQ += " SF2.F2_SERIE,"+CRLF
	cQ += " SF2.R_E_C_N_O_,"+CRLF
	cQ += " SF2.F2_XTOKEN,"+CRLF
	cQ += " DAI.DAI_XPROTO,"+CRLF
	cQ += " DAI.DAI_XPROPV,"+CRLF
	cQ += " DAI.DAI_COD,"+CRLF
	cQ += " ZBS.ZBS_NUM,"+CRLF
	cQ += " ZBS.ZBS_CNPJSE,"+CRLF
	cQ += " ZBS.ZBS_NSEGUR,"+CRLF
	cQ += " ZBS.ZBS_NUMAPO,"+CRLF
	cQ += " ZBS.ZBS_AVERBA "+CRLF
	cQ += " FROM "+ retSQLName("SF2") +" SF2"	+CRLF
	cQ += " INNER JOIN "+ retSQLName("DAI") +"  DAI"+CRLF
	cQ += " ON DAI.DAI_NFISCA=SF2.F2_DOC"+CRLF
	cQ += " AND DAI.DAI_SERIE= SF2.F2_SERIE"+CRLF
	cQ += " AND DAI.D_E_L_E_T_ <>  '*'"+CRLF
	cQ += " AND DAI.DAI_FILIAL=SF2.F2_FILIAL"+CRLF
	cQ += " LEFT JOIN "+ retSQLName("ZBS") +" ZBS"+CRLF
	cQ += " ON ZBS.ZBS_NUM=SF2.F2_DOC"+CRLF
	cQ += " AND ZBS.ZBS_SERIE= SF2.F2_SERIE"+CRLF
	cQ += " AND ZBS.D_E_L_E_T_ <>  '*'"+CRLF
	cQ += " AND ZBS.ZBS_FILIAL=SF2.F2_FILIAL"+CRLF
	cQ += " WHERE "
	cQ += " SF2.D_E_L_E_T_<>'*'"+CRLF 
	cQ += " AND SF2.F2_XTOKEN <>' '"+CRLF
	cQ += " and DAI.DAI_XPROTO<>' '"+CRLF
	cQ += " AND SF2.F2_CHVNFE <> ' '"+CRLF
	cQ += " AND SF2.F2_FILIAL ='"+aEmb[1]+"'"+CRLF
	cQ += " AND DAI.DAI_COD = '" + aEmb[2] + "' "+CRLF
	cQ += " AND DAI.DAI_PEDIDO = '"+ aEmb[3] +"' "+CRLF

	TcQuery changeQuery(cQ) New Alias "QFATAX"

	IF SELECT("QFATAX") > 0
		QFATAX->( dbCloseArea() )
	ENDIF   
	TcQuery changeQuery(cQ) New Alias "QFATAX"
return


static function QFIL(cFil)

	Local cQuery
	LOCAL cRet := ""

	IF SELECT("cSM0") > 0
		cSM0->( dbCloseArea() )
	ENDIF  

	cQuery := " SELECT M0_CGC FROM SYS_COMPANY "
	cQuery += "  WHERE M0_CODFIL = '" + cFil + "'"
	cQuery += "  AND SYS_COMPANY.D_E_L_E_T_<> '*' "

	TcQuery changeQuery(cQuery) New Alias "cSM0"
	if !cSM0->(EOF())
		cRet:=cSM0->M0_CGC
	ENDIF	
	IF SELECT("cSM0") > 0
		cSM0->( dbCloseArea() )
	ENDIF 

Return cRet

/*
Classe d addcarga
*/
class addNF

data Token						as string
data IntegrarNotasFiscais		as array


method New() constructor constructor
//method setProduct()
return

/*
Construtor
*/
method New() class addNF

return


class IntegrarNotasFiscais


data protocolo							as Array
data TokensXMLNotasFiscais				as Array
data Averbacao							as Array	


method New() constructor
//method setProduct()

return

/*
Construtor
*/
method New() class IntegrarNotasFiscais

return

/*
Endereco
*/
class protocolo	

data protocoloIntegracaoCarga			as string
data protocoloIntegracaoPedido			as string

method New() constructor
//method setProduct()

return

/*
Construtor
*/
method New() class protocolo

return

/*
Cidade
*/
class TokensXMLNotasFiscais

data TokenNF			as ARRAY

method New() constructor
//method setProduct()

return

/*
Construtor
*/
method New() class TokensXMLNotasFiscais

return
///TokenNF

class TokenNF

data TipoNotaFiscalIntegrada		as String
data Token							as String

method New() constructor
//method setProduct()

return

/*
Construtor
*/
method New() class TokenNF

return

///Averbacao

class Averbacao

data CNPJResponsavel				as String
data CNPJSeguradora					as String
data NomeSeguradora					as String
data NumeroApolice					as String
data NumeroAverbacao				as String


method New() constructor
//method setProduct()

return

/*
Construtor
*/
method New() class Averbacao

return
