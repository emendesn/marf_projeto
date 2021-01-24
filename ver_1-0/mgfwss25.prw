#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)             

/*
==========================================================================================================
Programa.:              MGFWSS25
Autor....:              Luiz Cesar Silva
Data.....:              08/10/2020 
Descricao / Objetivo:   Integração 
Doc. Origem:            RTASK0011722-Criar WorkFlow–Solicitação de produto
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WbeService Server Metodo Retorna dados do Produto
==========================================================================================================
*/

// RETORNA PRODUTO --------------------------------------------------
WSSTRUCT WSS25_CONSULTA
	WSDATA PRODUTO       as String
ENDWSSTRUCT

WSSTRUCT WSS25_RETORNO
  WSDATA COD           as String
  WSDATA DESC          as String
  WSDATA GRUPO         as String
  WSDATA TIPO          as String
  WSDATA ZMERCAD       as String
  WSDATA ZCONSER       as String
  WSDATA ZMARCA        as String
  WSDATA ATIVO         as String
ENDWSSTRUCT

// BLOQUEIA PRODUTO
// ----------------------------------------------------------------
WSSTRUCT WSS25_CONSBLQ
	WSDATA COD       as String	
ENDWSSTRUCT

WSSTRUCT WSS25_RETBLQ
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

// DESBLOQUEIA PRODUTO
// -----------------------------------------------------------------
WSSTRUCT WSS25_CONSDESBLQ
	WSDATA COD       as String	
ENDWSSTRUCT

WSSTRUCT WSS25_RETDESBLQ
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

// Estrutura de dados. Montagem do Array de requisição
// Grupo de Produtos------------------------------------------------
WSSTRUCT aReqGrpData
	WSDATA Grupo			as string
ENDWSSTRUCT 

// Estrutura de dados. Montagem do Array de retorno
WSSTRUCT aRetGrpData
	WSDATA CodigoGrupo  	as string
	WSDATA DescrGrupo		as string
ENDWSSTRUCT 

// Estrutura de dados. Montagem do Array de retorno
WSSTRUCT aRetGrpArray
	WSDATA GrpARet	AS Array OF aRetGrpData
ENDWSSTRUCT 

// TIPOS DE PRODUTOS ----------------------------------
// Estrutura de dados. Montagem do Array de requisição
WSSTRUCT aReqtpData
	WSDATA TipodeProduto		as string
ENDWSSTRUCT 

// Estrutura de dados. Montagem do Array de retorno
WSSTRUCT aRetTPData
	WSDATA CodigoTipo  	as string
	WSDATA DescrTipo		as string
ENDWSSTRUCT 

// Estrutura de dados. Montagem do Array de retorno
WSSTRUCT aRetTPArray
	WSDATA TpArray	AS Array OF aRetTPData
ENDWSSTRUCT 

// MARCA DE PRODUTOS -----------------------------------

// Estrutura de dados. Montagem do Array de requisição

WSSTRUCT aReqMarca
	WSDATA MARCAS			as string
ENDWSSTRUCT 

// Estrutura de dados. Montagem do Array de retorno
WSSTRUCT aRetMarca
	WSDATA CodigoMARCAS  	as string
	WSDATA DescrMARCAS		as string
ENDWSSTRUCT 

// Estrutura de dados. Montagem do Array de retorno
WSSTRUCT aRetMArray
	WSDATA MrcArray	AS Array OF aRetMarca
ENDWSSTRUCT 

// Estrutura de dados. Montagem do Array de requisição
// Sub-Grupo de Produtos------------------------------------------------
WSSTRUCT aReqSubGrp
	WSDATA ZCodGrupo		as string
ENDWSSTRUCT 

// Estrutura de dados. Montagem do Array de retorno
WSSTRUCT aRetSubGrpD
	WSDATA CodSubGrupo  	 as string
	WSDATA DescrSubGrupo     as string
	WSDATA ZCodGrupo  	 as string
	WSDATA ZDescrGrupo   as string
ENDWSSTRUCT 

// Estrutura de dados. Montagem do Array de retorno
WSSTRUCT aRetSubGrpA
	WSDATA SubGrpARet	AS Array OF aRetSubGrpD
ENDWSSTRUCT 

// WEBSERVICE INTEGRACAO WORKFLOW --------------------------------------------------------------------------
WSSERVICE MGFWSS25 DESCRIPTION "Integração Workflow de Produtos" NameSpace "http://www.totvs.com.br/MGFWSS25"

 	WSMETHOD RetornaProdutosProtheus DESCRIPTION "Retorna Dados Produto Protheus"
	WSDATA WSCONSULTA as WSS25_CONSULTA
	WSDATA WSRETORNO  as WSS25_RETORNO

	WSMETHOD BloqueiaProdutosProtheus DESCRIPTION "Bloqueia Produto Protheus"
	WSDATA WSCONSBLOQ as WSS25_CONSBLQ
	WSDATA WSRETBLOQ  as WSS25_RETBLQ

	WSMETHOD DesbloqueiaProdutosProtheus DESCRIPTION "Desbloqueia Produto Protheus"
	WSDATA WSCONSDESBLOQ as WSS25_CONSDESBLQ
	WSDATA WSRETDESBLOQ  as WSS25_RETDESBLQ

	WSMETHOD RetornaGrupodeProdutos		DESCRIPTION "Retorna Grupo de Produtos"		
	WSDATA aReqGrp AS aReqGrpData	
	WSDATA aRetGrp AS aRetGrpArray

	WSMETHOD RetornaTipodeProdutos		DESCRIPTION "Retorna Tipo de Produtos"		
	WSDATA aReqTP AS aReqtpData	
	WSDATA aRetTP AS aRetTPArray

	WSMETHOD RetornaMARCASdeProdutos		DESCRIPTION "Retorna MARCAS de Produtos"
	WSDATA aReqMrc AS aReqMarca	
	WSDATA aRetMrc AS aRetMArray

	WSMETHOD RetornaSubGrupodeProdutos		DESCRIPTION "Retorna Sub-Grupo de Produtos"		
	WSDATA aReqSubGrp AS aReqSubGrp	
	WSDATA aRetSubGrp AS aRetSubGrpA

ENDWSSERVICE

// METODO RETORNA ------------------------------------------------------------------------
WSMETHOD RetornaProdutosProtheus  WSRECEIVE WSCONSULTA WSSEND WSRETORNO WSSERVICE MGFWSS25

Local lReturn := .T.

::WSRETORNO := WSClassNew("WSS25_RETORNO")
::WSRETORNO := GetInfProd(::WSCONSULTA:PRODUTO)

Return lReturn  
 
// METODO BLOQUEIA ------------------------------------------------------------------------
WSMETHOD BloqueiaProdutosProtheus  WSRECEIVE WSCONSBLOQ WSSEND WSRETBLOQ WSSERVICE MGFWSS25

Local lReturn := .T.

::WSRETBLOQ := WSClassNew("WSS25_RETBLQ")
::WSRETBLOQ := GetBlqProd(::WSCONSBLOQ:COD,"BLOQ")

Return lReturn  

// METODO DESBLOQUEIA ------------------------------------------------------------------------------
WSMETHOD DesbloqueiaProdutosProtheus  WSRECEIVE WSCONSDESBLOQ WSSEND WSRETDESBLOQ WSSERVICE MGFWSS25

Local lReturn := .T.

::WSRETDESBLOQ := WSClassNew("WSS25_RETDESBLQ")
::WSRETDESBLOQ := GetBlqProd(::WSCONSDESBLOQ:COD,"DESBLOQ")

Return lReturn  

// METODO LISTA GRUPO -------------------------------------------------------------
WSMETHOD RetornaGrupodeProdutos WSRECEIVE aReqGrp WSSEND aRetGrp WSSERVICE MGFWSS25

Local lReturn := .T.
::aRetGrp := WSClassNew( "aRetGrpArray")
::aRetGrp := GETGRUPOPROD(::aReqGrp:Grupo)
Return lReturn  

// METODO LISTA TIPO DE PRODUTOS -----------------------------------------------
WSMETHOD RetornaTipodeProdutos WSRECEIVE aReqTP WSSEND aRetTP WSSERVICE MGFWSS25

Local lReturn := .T.
::aRetTp := WSClassNew( "aRetTPArray")
::aRetTp := GETTIPOPROD(::aReqTp:TipodeProduto)

Return lReturn  

// METODO LISTA MARCAS ---------------------------------------------------------
WSMETHOD RetornaMARCASdeProdutos WSRECEIVE aReqMrc WSSEND aRetMrc WSSERVICE MGFWSS25

Local lReturn := .T.
::aRetMRC := WSClassNew( "aRetMArray")
::aRetMRC := GETMARCAS(::aReqMRC:Marcas)

Return lReturn  

// METODO LISTA SUB-GRUPO -------------------------------------------------------------
WSMETHOD RetornaSubGrupodeProdutos WSRECEIVE aReqSubGrp WSSEND aRetSubGrp WSSERVICE MGFWSS25

Local lReturn := .T.
::aRetSubGrp := WSClassNew( "aRetSubGrpA")
::aRetSubGrp := GETSUBGRPPRD(::aReqSubGrp:ZCodGrupo)
Return lReturn  

// FUNCOES AUXILIARES ----------------------------------------------------------

// GETINFPROD
Static Function GetInfProd(cParProd)

Local nI := 0
Local oRetorno  := WSClassNew("WSS25_RETORNO")  
Local cCodProd  := cParProd // Alltrim(::WSCONSULTA:PRODUTO)
Local bContinua := .t.
Local cDescGrupo := ""
Local cDescTipo  := ""
Local cMercado   := ""
Local cConser    := ""
Local cMarca     := ""
Local cAtivo     := ""

U_MFConout(" [MGFWSS25] PRODUTO REFERENCIA..." + cCodProd		)

dbSelectArea('SB1')
SB1->(dbSetorder(1))

if SB1->(!dbSeek(xFilial('SB1')+cCodProd))
    bContinua := .F.
Endif

ZDB->(dbsetorder(1))
ZDB->(dbseek(xFilial("ZDB")+SB1->B1_ZGRUPO))
cDescGrupo := ZDB->ZDB_DESCR

SX5->(dbsetorder(1))
SX5->(dbseek(xFilial("SX5")+"02"+SB1->B1_TIPO))
cDescTipo := SX5->X5_DESCRI

if SB1->B1_ZMERCAD == "1"
   cMercado := "MERCADO INTERNO"
elseif SB1->B1_ZMERCAD == "2"
   cMercado := "MERCADO EXTERNO"
Endif

// 0=Outros;1=Resfriado;2=Congelado;3=In Natura

if SB1->B1_ZCONSER == "0"
   cConser := "OUTROS"
elseif SB1->B1_ZCONSER == "1"
   cConser := "RESFRIADO"
elseif SB1->B1_ZCONSER == "2"      
   cConser := "CONGELADO"
elseif SB1->B1_ZCONSER == "3"
   cConser := "IN NATURA"
Endif

ZZU->(dbsetorder(1))
ZZU->(dbseek(xFilial("ZZU")+SB1->B1_ZMARCA))
cMarca := ZZU->ZZU_DESCRI	

IF SB1->B1_MSBLQL == "1"
   cAtivo := "FALSE"
elseif SB1->B1_MSBLQL == "2"
   cAtivo := "TRUE"
Endif

oRetorno := WSClassNew("WSS25_RETORNO")  
oRetorno:COD            := SB1->B1_COD
oRetorno:DESC           := SB1->B1_DESC
oRetorno:GRUPO          := cDescGrupo
oRetorno:TIPO           := cDescTipo
oRetorno:ZMERCAD        := cMercado
oRetorno:ZCONSER        := cConser
oRetorno:ZMARCA         := cMarca
oRetorno:ATIVO          := cAtivo

Return oretorno


// GETBLQPROD
Static Function GetBlqProd(cParProd,cParBloq)

Local _lCont 		:= .T.
Local cMsg := if (cParBloq=="BLOQ","INTEGRAÇÃO FINALIZADA COM SUCESSO - PRODUTO BLOQUEADO","INTEGRAÇÃO FINALIZADA COM SUCESSO - PRODUTO DESBLOQUEADO")
Local _aRetmsg 	:= {"O",cmsg }
Local oRetorno := WSClassNew("WSS25_RETBLQ")
Local cCodProd  := Alltrim(cParprod)

U_MFConout(" [MGFWSS25] - Produto -- PRODUTO REFERENCIA..." + cParBloq + " - " + cCodProd		)

If Empty(cCodProd)
	_lCont := .F.
	_aRetmsg := {"E","PRODUTO NÃO INFORMADO." }
EndIf
If _lCont
   dbSelectArea('SB1')
   SB1->(dbSetorder(1))
   IF SB1->(dbSeek(xFilial('SB1')+cCodProd))
	  if cParBloq == "BLOQ"

         Reclock("SB1",.F.)
         SB1->B1_MSBLQL := "1"
	     SB1->(MsUnlock()) 

	  Elseif cParBloq == "DESBLOQ"

         Reclock("SB1",.F.)
         SB1->B1_MSBLQL := "2"
	     SB1->(MsUnlock()) 

      Endif
	Else
		_aRetmsg := {"E","PRODUTO NÃO CADASTRADO NO PROTHEUS. PRODUTO: " + cCodProd}
   Endif
Endif 

U_MFConout(" [MGFWSS25] STATUS.............." + _aRetmsg[1]		)
U_MFConout(" [MGFWSS25] MSG................." + _aRetmsg[2]		)
U_MFConout("=================================| FIM - MGFWSS25 |="	)

oRetorno := WSClassNew("WSS25_RETBLQ")  
oRetorno:STATUS  := _aRetmsg[1]
oRetorno:MSG	 := _aRetmsg[2]

Return oRetorno

// RETORNA O GRUPO DE PRODUTOS
Static Function GETGRUPOPROD(cparGrupo)

Local lRet		:= .T.
Local oGRPRet
Local aRetGrp := {}
Local aListZDB := {}
Local cAliasZDB := GetNextAlias()
Local cWhere := "AND ZDB.ZDB_FILIAL = '"+xFilial('ZDB')+"'"

Local oRetGrp := WSClassNew( "aRetGrpArray")

oRetGrp:GrpaRet := {}

//oRetGrp:aRetGrp := {}
 
cWhere := '%'+cWhere+'%'

    //-------------------------------------------------------------------
    // Query para selecionar clientes
    //-------------------------------------------------------------------
BEGINSQL Alias cAliasZDB 
       SELECT ZDB.ZDB_COD, ZDB.ZDB_DESCR
         FROM %table:ZDB% ZDB
        WHERE ZDB.%NotDel%
        %exp:cWhere% 
ENDSQL 

( cAliasZDB )->( DBGOTOP() )

// Cria a instância de retorno ( WSDATA aRetExp AS aRetExpArray )
//::aRetGrp := WSClassNew( "aRetGrpArray")

// inicializa a propriedade da estrutura de retorno
// WSDATA ExpArray	AS Array OF aRetExpData
//::aRetGrp:GrpARet := {}

While ( cAliasZDB )->( ! Eof() ) 
 
			oGrpRet :=  WSClassNew( "aRetGrpData" )
			oGrpRet:codigoGrupo		:= (cAliasZDB)->ZDB_COD
			oGrpRet:descrGrupo		:= (cAliasZDB)->ZDB_DESCR
//			AAdd( ::aRetGrp:GrpARet, oGrpRet ) 
			AAdd( oRetGrp:GrpaRet, oGrpRet ) 
 
       ( cAliasZDB )->( DBSkip() )
End
 
( cAliasZDB )->( DBCloseArea() )
 
 
if Len(oRetGrp:GrpaRet) == 0
			SetSoapFault("enviaDadosGrupo", "Status:2 -Observação: Não há Dados Grupo de Produtos")
			lRet		:= .F.
EndIf

return (oRetGrp)


// RETORNA O SUB GRUPO DE PRODUTOS
Static Function GETSUBGRPPRD(cParGrp1)

Local lRet		:= .T.
Local oSubGRPRet
Local aRetSubGrp := {}
Local aListZDC := {}
Local cAliasZDC := GetNextAlias()

Local oRetSubGrp := WSClassNew( "aRetSubGrpA")

//Local cWhere := "AND ZDC.ZDC_FILIAL = '"+xFilial('ZDC')+"' AND ZDC.ZDC_CODGRP = '" +cParGrp1+ "'"

//Local cWhere := "AND ZDC.ZDC_FILIAL = '"+xFilial('ZDC')+"' AND ZDC.ZDC_CODGRP = '" + cParGrp1+ "' "
Local cWhere := "AND ZDC.ZDC_FILIAL = '"+xFilial('ZDC')+"' AND ZDC.ZDC_CODGRP = '" + cParGrp1+ "' "+ "AND ZDC.ZDC_CODGRP<>'      ' AND ZDC.ZDC_STATUS ='1' "
oRetSubGrp:SubGrpaRet := {}

cWhere := '%'+cWhere+'%'

U_MFCONOUT(CWHERE)
    //-------------------------------------------------------------------
    // Query para selecionar clientes
    //-------------------------------------------------------------------
BEGINSQL Alias cAliasZDC 
       SELECT ZDC.ZDC_COD, ZDC.ZDC_DESCR, ZDC.ZDC_CODGRP,ZDC.ZDC_DESGRP
         FROM %table:ZDC% ZDC
        WHERE ZDC.%NotDel%
        %exp:cWhere% 
ENDSQL 

( cAliasZDC )->( DBGOTOP() )

IF (cAliasZDC)->(Eof())

   oSubGrpRet :=  WSClassNew( "aRetSubGrpD" )
   oSubGrpRet:codSubGrupo	:= ' '
   oSubGrpRet:descrSubGrupo	:= ' '
   oSubGrpRet:zcodGrupo		:= ' '
   oSubGrpRet:zdescrGrupo	:= ' '

   AAdd( oRetSubGrp:SubGrpaRet, oSubGrpRet ) 

Endif

While ( cAliasZDC )->( ! Eof() ) 
 
			oSubGrpRet :=  WSClassNew( "aRetSubGrpD" )
			oSubGrpRet:codSubGrupo		:= (cAliasZDC)->ZDC_COD
			oSubGrpRet:descrSubGrupo	:= (cAliasZDC)->ZDC_DESCR
			oSubGrpRet:zcodGrupo		:= (cAliasZDC)->ZDC_CODGRP
			oSubGrpRet:zdescrGrupo	:= (cAliasZDC)->ZDC_DESGRP

			AAdd( oRetSubGrp:SubGrpaRet, oSubGrpRet ) 
 
       ( cAliasZDC )->( DBSkip() )
End
 
( cAliasZDC )->( DBCloseArea() )
 
 
/*if Len(oRetSubGrp:SubGrpaRet) == 0
			SetSoapFault("enviaDadosSub-Grupo", "Status:2 -Observação: Não há Dados Sub-Grupo de Produtos")
			lRet		:= .F.
EndIf */


return (oRetSubGrp)

// RETORNA O TIPO DE PRODUTOS
// -----------------------------------
Static Function GETTIPOPROD(cparGrupo)

Local lRet		:= .T.
Local oTPRet
Local aRetTP := {}

Local aListSX5 := {}
Local cAliasSX5 := GetNextAlias()

Local cWhere := "AND SX5.X5_TABELA = '02' "
Local oRetTP := WSClassNew( "aRetTPArray")

cWhere := '%'+cWhere+'%'


oRetTP:TpArray := {}

 //-------------------------------------------------------------------
 // Query para selecionar TIPOS
 //-------------------------------------------------------------------
 BEGINSQL Alias cAliasSX5
 
 SELECT SX5.X5_CHAVE, SX5.X5_DESCRI
   FROM %table:SX5% SX5
  WHERE SX5.%NotDel%
 %exp:cWhere%
 
 ENDSQL

//-------------------------------------------------------------------
 // Posiciona no primeiro registro.
 //-------------------------------------------------------------------
 ( cAliasSX5 )->( DBGoTop() )

While ( cAliasSX5 )->( ! Eof() ) 
 
			oTPRet :=  WSClassNew( "aRetTPData" )
			oTPRet:codigoTipo 		:= (cAliasSX5)->X5_CHAVE
			oTpRet:descrTipo		:= (cAliasSX5)->X5_DESCRI
			AAdd(oRetTP:TpArray, oTPRet ) 
 
       ( cAliasSX5 )->( DBSkip() )
End
 
( cAliasSX5 )->( DBCloseArea() )
 
if Len(oRetTP:TpArray) == 0
			SetSoapFault("enviaDadosTipodeProduto", "Status:2 -Observação: Não há Dados de Tipo de Produtos")
			lRet		:= .F.
EndIf

return (oRetTp)

Static function GETMARCAS(cParMarcas)
Local lRet		:= .T.
Local oGRPRet
Local aRetMRC := {}
Local cParMarcas := ""

Local aListZZU := {}
Local cAliasZZU := GetNextAlias()

Local cWhere := ""

Local oRetMRC := WSClassNew( "aRetMArray")

oRetMRC:MrcArray := {}

/*If !ExisteSx6("MGF_WSS25M")
		CriarSX6("MGF_WSS25M", "C", "Marcas de produtos"	, "'715','609','363','724','199','105','752','759','560','153','310','706','705','650','718','693','697','561','727','007','730','113','642','624','192','601','114','001','696','125','043','735','640','559','758','023','694','008','057','110','413','548','354','206','634','630','629','631','692','603','623','003','176','047','744','215','622','030','022','189','588','109','019','236','613','351','745','722'" )	
EndIf*/
cParMarcas := alltrim(supergetmv("MGF_WSS25M",,"'715','609','363','724','199','105','752','759','560','153','310','706','705','650','718','693','697','561','727','007','730','113','642','624','192','601','114','001','696','125','043','735','640','559','758','023','694','008','057','110','413','548','354','206','634','630','629','631','692','603','623','003','176','047','744','215','622','030','022','189','588','109','019','236','613','351','745','722'"))

cWhere := "AND ZZU.ZZU_FILIAL = '"+xFilial('ZZU')+"' AND ZZU.ZZU_CODIGO IN(" + cParMarcas +")"
cWhere := '%'+cWhere+'%'

memoWrite("WHERE.TXT", cWhere)

    //-------------------------------------------------------------------
    // Query para selecionar clientes
    //-------------------------------------------------------------------
BEGINSQL Alias cAliasZZU 
       SELECT ZZU.ZZU_CODIGO, ZZU.ZZU_DESCRI
         FROM %table:ZZU% ZZU
        WHERE ZZU.%NotDel%
        %exp:cWhere% 
ENDSQL 

( cAliasZZU )->( DBGOTOP() )

While ( cAliasZZU )->( ! Eof() ) 
 
			oGrpRet :=  WSClassNew( "aRetMarca" )
			oGrpRet:codigoMARCAS		:= (cAliasZZU)->ZZU_CODIGO
			oGrpRet:descrMARCAS		:= (cAliasZZU)->ZZU_DESCRI
			AAdd( oRetMrc:MrcArray, oGrpRet ) 
 
       ( cAliasZZU )->( DBSkip() )
End
 
( cAliasZZU )->( DBCloseArea() )
 
 
if Len(oRetMrc:MrcArray) == 0
			SetSoapFault("enviaDadosMARCAS", "Status:2 -Observação: Não há Dados MARCAS de Produtos")
			lRet		:= .F.
EndIf

return (oRetMrc)

