#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"                                     

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFTAP22
WS Integração Assincrona de estoque - Processos Produtivos

@author Josué Danich Prestes
@since 02/03/2020 
@type WS  
/*/   


// Movimentos de Produção - Estrutura de dados. Montagem do Array de requisição. Apontamento de Produção/Consumo de Insumos
WSSTRUCT MGFTAP22RequisProducao
	WSDATA D3_ACAO  	AS string
	WSDATA D3_FILIAL  	AS string
	WSDATA D3_IDTAURA  	AS string
	WSDATA D3_OPTAURA	AS string
	WSDATA D3_TPOP		AS string
	WSDATA D3_TPMOV		AS string
	WSDATA D3_GERACAO	AS string
	WSDATA D3_EMISSAO	AS string
	WSDATA D3_ZHORA		AS string
	WSDATA D3_CODPA		AS string
	WSDATA D3_COD		AS string
	WSDATA D3_QUANT		AS Float
	WSDATA D3_LOTECTL	AS string OPTIONAL
	WSDATA D3_DTVALID	AS string OPTIONAL
	WSDATA D3_ZQTDPCS	AS Float  OPTIONAL
	WSDATA D3_ZQTDCXS	AS Float  OPTIONAL
	WSDATA D3_ZPEDLOT	AS String OPTIONAL
	WSDATA D3_LOCAL		AS String OPTIONAL
	WSDATA D3_ChaveUID  As String OPTIONAL
	WSDATA D3_BLOQ      As String OPTIONAL

ENDWSSTRUCT

// Movimentos de Produção - Estrutura de dados. Montagem do Array de retorno. Apontamento de Produção/Consumo de Insumos
WSSTRUCT MGFTAP22RetornoProducao
	WSDATA STATUS	AS String
	WSDATA MSG		AS String
ENDWSSTRUCT

// Movimentos de Produção - Estrutura de dados. Montagem do Array de requisição. Encerramento de Produção
WSSTRUCT MGFTAP22RequisEncerraOP
	WSDATA D3_ACAO  	AS string
	WSDATA D3_FILIAL  	AS string
	WSDATA D3_TPOP		AS string
	WSDATA D3_GERACAO	AS string
	WSDATA D3_CODPA		AS string
	WSDATA D3_OPTAURA	AS string         
	WSDATA D3_ChaveUID  As String OPTIONAL
	WSDATA D3_QUANT		AS Float					  
	//	WSDATA D3_IDTAURA   As String OPTIONAL
ENDWSSTRUCT

// Movimentos de Produção - Estrutura de dados. Montagem do Array de retorno. Encerramento de OP
WSSTRUCT MGFTAP22RetornoEncerraOP
	WSDATA STATUS	AS String
	WSDATA MSG		AS String
ENDWSSTRUCT

/***************************************************************************
* Definicao do Web Service. Produção.				                       *
***************************************************************************/
WSSERVICE MGFTAP22 DESCRIPTION "Integração Assincrona Protheus x TAURA - Produção - Versao sem Lote" NameSpace "http://totvs.com.br/MGFTAP22.apw"

	// Produção - Passagem dos parâmetros de entrada
	WSDATA MGFTAP22RequisProd AS MGFTAP22RequisProducao
	// Produção - Retorno (array)
	WSDATA MGFTAP22RetornoProd AS MGFTAP22RetornoProducao

	// Produção - Passagem dos parâmetros de entrada. Encerramento de OP
	WSDATA MGFTAP22RequisEncOP AS MGFTAP22RequisEncerraOP
	// Produção - Retorno (array). Encerramento de OP
	WSDATA MGFTAP22RetornoEncOP AS MGFTAP22RetornoEncerraOP

	WSMETHOD GerarMovTaura DESCRIPTION "Integração Protheus x Taura - Processos Produtivos"
	WSMETHOD EncerramentodeOP DESCRIPTION "Integração Protheus x Taura - Encerramento de OP"

ENDWSSERVICE

/************************************************************************************
** Metodo GerarMovTaura
** Grava dados de processos produtivos - apontamentos / requisições referentes a OPs
************************************************************************************/
WSMETHOD GerarMovTaura WSRECEIVE	MGFTAP22RequisProd WSSEND MGFTAP22RetornoProd WSSERVICE MGFTAP22

	Local aRetFuncaadmino := {}
	Local lReturn	:= .T.
	Local _cuuid := IIF(::MGFTAP22RequisProd:D3_ChaveUID<>NIL,::MGFTAP22RequisProd:D3_ChaveUID,"")

	U_MFCONOUT('Recebeu GerarMovTaura com UUID ' + _cuuid +"...") 

	aRetFuncao	:= MGFTAP22(	{	::MGFTAP22RequisProd:D3_ACAO	,;
	::MGFTAP22RequisProd:D3_FILIAL	,;
	::MGFTAP22RequisProd:D3_IDTAURA	,;
	::MGFTAP22RequisProd:D3_OPTAURA	,;
	::MGFTAP22RequisProd:D3_TPOP	,;
	::MGFTAP22RequisProd:D3_TPMOV	,;
	::MGFTAP22RequisProd:D3_GERACAO	,;
	::MGFTAP22RequisProd:D3_EMISSAO	,;
	::MGFTAP22RequisProd:D3_ZHORA	,;
	::MGFTAP22RequisProd:D3_CODPA	,;
	::MGFTAP22RequisProd:D3_COD		,;
	::MGFTAP22RequisProd:D3_QUANT	,;
	IIF(::MGFTAP22RequisProd:D3_LOTECTL<>NIL,::MGFTAP22RequisProd:D3_LOTECTL,"")	,;
	IIF(::MGFTAP22RequisProd:D3_DTVALID<>NIL,::MGFTAP22RequisProd:D3_DTVALID,"")	,;
	IIF(::MGFTAP22RequisProd:D3_ZQTDPCS<>NIL,::MGFTAP22RequisProd:D3_ZQTDPCS,0)		,;
	IIF(::MGFTAP22RequisProd:D3_ZQTDCXS<>NIL,::MGFTAP22RequisProd:D3_ZQTDCXS,0)		,;
	IIF(::MGFTAP22RequisProd:D3_ZPEDLOT<>NIL,::MGFTAP22RequisProd:D3_ZPEDLOT,"")	,;
	IIF(::MGFTAP22RequisProd:D3_LOCAL<>NIL,::MGFTAP22RequisProd:D3_LOCAL,"")	    ,;
	IIF(::MGFTAP22RequisProd:D3_ChaveUID<>NIL,::MGFTAP22RequisProd:D3_ChaveUID,"") ,;
	IIF(::MGFTAP22RequisProd:D3_BLOQ<>NIL    ,::MGFTAP22RequisProd:D3_BLOQ,"")	  } )	// Passagem de parâmetros para rotina

	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFTAP22RetornoProd :=  WSClassNew( "MGFTAP22RetornoProducao" )
	::MGFTAP22RetornoProd:STATUS	:= aRetFuncao[1][1]
	::MGFTAP22RetornoProd:MSG		:= aRetFuncao[1][2]

	::MGFTAP22RequisProd := Nil

	U_MFCONOUT('Completou GerarMovTaura com UUID ' + _cuuid +" e resultado " + aRetFuncao[1][1] + "...") 

	DelClassINTF()

Return lReturn

/************************************************************************************
** Metodo EncerramentodeOP
** Grava dados de processos produtivos - Encerramento de OPs
************************************************************************************/
WSMETHOD EncerramentodeOP WSRECEIVE	MGFTAP22RequisEncOP WSSEND MGFTAP22RetornoEncOP WSSERVICE MGFTAP22

	Local aRetFuncao := {}
	Local lReturn	:= .T.

	aRetFuncao	:= MGFTAP22(	{	::MGFTAP22RequisEncOP:D3_ACAO		,;
	::MGFTAP22RequisEncOP:D3_FILIAL		,;
	'',;                                    //::MGFTAP22RequisEncOP:D3_IDTAURA	,; //::MGFTAP22RequisEncOP:D3_IDTAURA
	::MGFTAP22RequisEncOP:D3_OPTAURA	,;
	::MGFTAP22RequisEncOP:D3_TPOP		,;
	"04"								,; //::MGFTAP22RequisEncOP:D3_TPMOV
	::MGFTAP22RequisEncOP:D3_GERACAO	,;
	::MGFTAP22RequisEncOP:D3_GERACAO	,; //::MGFTAP22RequisProd:D3_EMISSAO
	""									,; //::MGFTAP22RequisEncOP:D3_ZHORA
	::MGFTAP22RequisEncOP:D3_CODPA		,;
	::MGFTAP22RequisEncOP:D3_CODPA		,; //::MGFTAP22RequisProd:D3_COD
	IIF(::MGFTAP22RequisEncOP:D3_QUANT<>NIL,::MGFTAP22RequisEncOP:D3_QUANT,0)	,;
	""									,; //IIF(::MGFTAP22RequisEncOP:D3_LOTECTL<>NIL,::MGFTAP22RequisEncOP:D3_LOTECTL,"")
	""									,; //IIF(::MGFTAP22RequisEncOP:D3_DTVALID<>NIL,::MGFTAP22RequisEncOP:D3_DTVALID,"")
	0									,; //IIF(::MGFTAP22RequisEncOP:D3_ZQTDPCS<>NIL,::MGFTAP22RequisEncOP:D3_ZQTDPCS,0)
	0									,;	//IIF(::MGFTAP22RequisEncOP:D3_ZQTDCXS<>NIL,::MGFTAP22RequisEncOP:D3_ZQTDCXS,0)
	""									,;
	""									,;
	::MGFTAP22RequisEncOP:D3_ChaveUID , ''} )


	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFTAP22RetornoEncOP :=  WSClassNew( "MGFTAP22RetornoEncerraOP" )
	::MGFTAP22RetornoEncOP:STATUS	:= aRetFuncao[1][1]
	::MGFTAP22RetornoEncOP:MSG		:= aRetFuncao[1][2]

	::MGFTAP22RequisEncOP := Nil
	DelClassINTF()

Return lReturn

Static Function MGFTAP22( aMovTaura )

Local aRetorno := {}
Local cCodPro, cCodPa, cCodDes, cCodRep
Local cDBStr, cDBSrv, nDBPrt, nDBHnd
Local aDBRet 	:= {}                  
Local cLocBlq	:= GetMv("MGF_TAPBLQ",,"66")		// Almoxarifado Boqueio
Local cLineF	:= (Chr(13)+Chr(10))

	
cLocBlq		:= Stuff( Space(TamSX3("B1_LOCPAD")[1]) , 1 , Len(cLocBlq) , cLocBlq )
cLocBlq		:= Subs( cLocBlq , 1 , TamSX3("B1_LOCPAD")[1] )

U_MFCONOUT('     Recebeu chamada com UUID ' + aMovTaura[19] +"...") 

If Empty( aMovTaura[12] )
	U_MFCONOUT('     Chamada com UUID ' + aMovTaura[19] +" com quantidade zerada...") 
	aAdd( aRetorno , {"2","[ZZE] Quantidade 0 (Zero)"} )
	Return( aRetorno )
EndIf

//Valida se já existe registro com mesma UUID
ZZE->(Dbsetorder(7)) //ZZE_CHAVEU
If ZZE->(Dbseek(aMovTaura[19]))

	//Se já existe e for igual retorna sucesso
	_ligual := .T.

	If 	ALLTRIM(ZZE->ZZE_FILIAL)	!=	ALLTRIM(aMovTaura[02]) .or.;
		ALLTRIM(ZZE->ZZE_IDTAUR)	!=	ALLTRIM(aMovTaura[03]) .or.;
		ALLTRIM(ZZE->ZZE_ACAO)	!=	ALLTRIM(aMovTaura[01]) .or.;
		ALLTRIM(ZZE->ZZE_OPTAUR)	!=	ALLTRIM(aMovTaura[04]) .or.;
		ALLTRIM(ZZE->ZZE_TPOP)	!=	ALLTRIM(aMovTaura[05]) .or.;
		ALLTRIM(ZZE->ZZE_TPMOV)	!=	ALLTRIM(IIF(aMovTaura[05] == '15','06',aMovTaura[06])) .or.;
		ALLTRIM(ZZE->ZZE_HORA)	!=	ALLTRIM(aMovTaura[09]) .or.;
		ALLTRIM(ZZE->ZZE_CODPA)	!=	ALLTRIM(aMovTaura[10]) .or.;
		ALLTRIM(ZZE->ZZE_COD)	!=	ALLTRIM(aMovTaura[11]) .or.;
		ZZE->ZZE_QUANT	!=	aMovTaura[12] .or.;
		ALLTRIM(ZZE->ZZE_QTDPCS)	!=	ALLTRIM(aMovTaura[15]) .or.;
		ALLTRIM(ZZE->ZZE_QTDCXS)	!=	ALLTRIM(aMovTaura[16]) .or.;
		ALLTRIM(ZZE->ZZE_PEDLOT)	!=	ALLTRIM(aMovTaura[17]) .or.;
		ALLTRIM(ZZE->ZZE_LOCAL)	!=	ALLTRIM(IIF(Upper(SUBSTR(aMovTaura[20],1,1))=='S',cLocBlq,aMovTaura[18])) 

		_ligual := .F.

	Endif

	If _ligual 

		aAdd( aRetorno , {"1",ZZE->ZZE_ID} )
		U_MFCONOUT('     Chamada com UUID ' + aMovTaura[19] +" já existe sem divergência...") 


	Else
	
		aAdd( aRetorno , {"2","[ZZE] UUID Duplicado com dados diversos"} )
		U_MFCONOUT('     Chamada com UUID ' + aMovTaura[19] +" já existe com divergência...") 

	Endif

	Return( aRetorno )

Endif

U_MFCONOUT('     Gravando Chamada com UUID ' + aMovTaura[19] +"...")

//Verifica se há outra instância usando mesmo uuid
If !(mayiusecode(alltrim(aMovTaura[19])))
	U_MFCONOUT('     Chamada com UUID ' + aMovTaura[19] +" com já em processamento em outra instância...") 
	aAdd( aRetorno , {"2","[ZZE] Chamada com UUID " + aMovTaura[19] +" com já em processamento em outra instância..."} )
	Return( aRetorno )
Endif

If RecLock("ZZE",.T.)
	ZZE->ZZE_FILIAL	:=	aMovTaura[02]
	ZZE->ZZE_ID		:=	Subs(DtoS(Date()),3,6)+StrZero( Recno() , Len(ZZE->ZZE_ID)-6 )
	ZZE->ZZE_IDTAUR	:=	aMovTaura[03]
	ZZE->ZZE_ACAO	:=	aMovTaura[01]
	ZZE->ZZE_OPTAUR	:=	aMovTaura[04]
	ZZE->ZZE_TPOP	:=	aMovTaura[05]
	ZZE->ZZE_TPMOV	:=	IIF(aMovTaura[05] == '15','06',aMovTaura[06])

	//Quando a Data de emissão e geração for diferente, mantem a data de geração.
	//O valor original dos campos enviados está gravado no campo ZZE_MSGREQ
	If aMovTaura[07] = aMovTaura[08] .or. aMovTaura[02] $ getmv("MGF_TAP01FL",,"010003,010042,020001")
		ZZE->ZZE_GERACA	:=	StrTran(aMovTaura[07],"-")
		ZZE->ZZE_EMISSA	:=	StrTran(aMovTaura[08],"-")
	else 
		ZZE->ZZE_GERACA	:=	StrTran(aMovTaura[07],"-")
		ZZE->ZZE_EMISSA	:=	StrTran(aMovTaura[07],"-")
	endif 	

	ZZE->ZZE_HORA	:=	aMovTaura[09]
	ZZE->ZZE_CODPA	:=	aMovTaura[10]
	ZZE->ZZE_COD	:=	aMovTaura[11]
	ZZE->ZZE_QUANT	:=	aMovTaura[12]
	ZZE->ZZE_QTDPCS	:=	aMovTaura[15]
	ZZE->ZZE_QTDCXS	:=	aMovTaura[16]
	ZZE->ZZE_PEDLOT	:=	aMovTaura[17]
	ZZE->ZZE_LOCAL	:=	IIF(Upper(SUBSTR(aMovTaura[20],1,1))=='S',cLocBlq,aMovTaura[18])
	ZZE->ZZE_CHAVEU :=	aMovTaura[19]
	ZZE->ZZE_DTREC  := Date()
	ZZE->ZZE_HRREC  := Time()

	ZZE->( msUnlock() )
	aAdd( aRetorno , {"1",ZZE->ZZE_ID} )
	U_MFCONOUT('     Gravou Chamada com UUID ' + aMovTaura[19] +"...")


Else
	aAdd( aRetorno , {"2","[ZZE] Erro de Gravação"} )
	U_MFCONOUT('     Falhou gravação de Chamada com UUID ' + aMovTaura[19] +"...")

EndIf

Leave1Code(alltrim(aMovTaura[19]))

Return( aRetorno )
