#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)             

//-----------------------------------------------------------------------------------
/*/{Protheus.doc}MGFTAC10
Integração Klassmatt - Protheus, para cadastro de Produtos
@author  Marcelo Carneiro
@since 20/06/2017
*/                                                     

WSSTRUCT MGFTAC10_PRODKLASS
	WSDATA B1_ACAO      as String
	WSDATA B1_XIDKLASS  as float
	WSDATA B1_FILIAL    as String
	WSDATA B1_COD       as String
	WSDATA B1_TIPO      as String
	WSDATA B1_UM        as String
	WSDATA B1_POSIPI    as String
	WSDATA B1_EX_NCM    as String
	WSDATA B1_IPI       as float
	WSDATA B1_GRUPO     as String
	WSDATA B1_XSGRUPO   as String
	WSDATA B1_DESC      as String
	WSDATA B1_ZPRODES   as String
	WSDATA B1_LOCPAD    as String
	WSDATA B1_GRTRIB    as String
	WSDATA B1_ZMARCA	as String
	
ENDWSSTRUCT

WSSTRUCT MGFTAC10_RETORNO
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

WSSERVICE MGFTAC10 DESCRIPTION "Importação de Cadastros de Produtos - Klassmatt" NameSpace "http://www.totvs.com.br/MGFTAC10"
	WSDATA WSPRODKLASS as MGFTAC10_PRODKLASS
	WSDATA WSRETORNO   as MGFTAC10_RETORNO

	WSMETHOD IncluirProdKlass DESCRIPTION "Importação de Cadastros de Produtos - Klassmatt"
ENDWSSERVICE

WSMETHOD IncluirProdKlass WSRECEIVE WSPRODKLASS WSSEND WSRETORNO WSSERVICE MGFTAC10

Local bContinua := .T.
Local aRetorno  := {}

Private lMsHelpAuto     := .T.
Private lMsErroAuto     := .F.
Private lAutoErrNoFile  := .T.      
Private cB1FILIAL       := ::WSPRODKLASS:B1_FILIAL
Private cACAO           := ::WSPRODKLASS:B1_ACAO
Private cB1_COD         := Val(::WSPRODKLASS:B1_COD)
Private cNCM            := StrTran(::WSPRODKLASS:B1_POSIPI,".")
Private aSB1            := {}

SetFunName("MGFTAC10")
dbSelectArea('SB1')
SB1->(dbSetOrder(1))

// Tratar com Zeros se o produto é menor que 100.000
IF cB1_COD <  100000
    cB1_COD := Padr(STRZERO(cB1_COD,6),TamSX3("B1_COD")[1])
Else 
    cB1_COD := Padr(Alltrim(STR(cB1_COD)),TamSX3("B1_COD")[1])
EndIF

U_MFCONOUT("Recebida integração Klassmat para o produto " + cB1_COD + "...")

//Fazer a Validação dos Campos 
IF !(cACAO $ '12')
	AAdd(aRetorno ,"2")
	AAdd(aRetorno,'B1_ACAO:Ação deverá ser : 1=Inclusão 2=Alteração')
	bContinua := .F.
	U_MFCONOUT("Ação " + cACAO + " inválida, integração cancelada!")
Else
	IF !Empty(xFilial('SB1'))
		IF  !FWFilExist(cEmpAnt,cB1FILIAL)
			AAdd(aRetorno ,"2")
			AAdd(aRetorno,'B1_FILIAL:Filial não cadastrada')
			bContinua := .F.
			U_MFCONOUT("Filial " + cB1FILIAL + " inválida, integração cancelada!")
		Else
			cFilAnt := cB1FILIAL
		EndIF
	EndIF
	IF bContinua
		IF SB1->(dbSeek(xFilial('SB1')+cB1_COD))
			IF cACAO == '1'
				AAdd(aRetorno ,"3")
				AAdd(aRetorno,'B1_COD:Produto já Cadastrado e ação igual a 1')
				bContinua := .F.
				U_MFCONOUT("Produto " + cB1_COD + " já existe e não pode ser incluído, integração cancelada!")
			EndIF
		Else
			IF cACAO $ '23'
				AAdd(aRetorno ,"3")
				AAdd(aRetorno,'B1_COD:Produto não Cadastrado e ação igual a 2')
				bContinua := .F.
				U_MFCONOUT("Produto " + cB1_COD + " não existe e não pode ser alterado, integração cancelada!")
			EndIF
		EndIF
	EndIF
	If bContinua
		IF cB1_COD < getmv("MGFTACP",,'500000')	
			AAdd(aRetorno ,"3")
			AAdd(aRetorno,'B1_COD:Produto com codigo menor que ' + getmv("MGFTACP",,getmv("MGFTACP",,'500000')) + " não pode ser integrado nessa interface!"	)
			bContinua := .F.
			U_MFCONOUT("Produto " + cB1_COD + " com código menor que "  + getmv("MGFTACP",,getmv("MGFTACP",,'500000')) + " não pode ser integrado nessa interface!")
		Endif
	Endif
Endif

IF bContinua
	
	AAdd(aSB1,{"B1_FILIAL"    ,xFilial('SB1')          ,NIL})
	AAdd(aSB1,{"B1_COD"       ,cB1_COD	               ,NIL})
	AAdd(aSB1,{"B1_TIPO"      ,::WSPRODKLASS:B1_TIPO   ,NIL})
	AAdd(aSB1,{"B1_UM"        ,::WSPRODKLASS:B1_UM     ,NIL})              
	IF cACAO == '1' .And. ::WSPRODKLASS:B1_TIPO =='MO'
		AAdd(aSB1,{"B1_IRRF"    ,'S',NIL})
		AAdd(aSB1,{"B1_INSS"    ,'S',NIL}) 
		AAdd(aSB1,{"B1_PIS"     ,'1',NIL})
		AAdd(aSB1,{"B1_COFINS"  ,'1',NIL})
		AAdd(aSB1,{"B1_CSLL"    ,'1',NIL})
		AAdd(aSB1,{"B1_MEPLES " ,'2',NIL})
	    AAdd(aSB1,{"B1_LOCALIZ" ,"N",Nil})
	EndIF

	If empty(cNCM) .or. cNCM == '0'
		cNCM := '00000000'
	Endif

	IF (cACAO == '2' .AND. !Empty(cNCM))  .OR. cACAO == '1'
		AAdd(aSB1,{"B1_POSIPI"    ,cNCM ,NIL})
	EndIF
	IF (cACAO == '2' .AND. !Empty(::WSPRODKLASS:B1_EX_NCM))  .OR. cACAO == '1'
		AAdd(aSB1,{"B1_EX_NCM"    ,::WSPRODKLASS:B1_EX_NCM ,NIL})
	EndIF
	AAdd(aSB1,{"B1_IPI"       ,::WSPRODKLASS:B1_IPI    ,NIL})
	AAdd(aSB1,{"B1_GRUPO"     , RIGHT(ALLTRIM(::WSPRODKLASS:B1_GRUPO),4)  ,NIL})
	CONOUT(RIGHT(ALLTRIM(::WSPRODKLASS:B1_GRUPO),4))
	AAdd(aSB1,{"B1_DESC"      ,::WSPRODKLASS:B1_DESC   ,NIL})
	AAdd(aSB1,{"B1_ZPRODES"   ,::WSPRODKLASS:B1_ZPRODES,NIL})
	IF (cACAO == '2' )                                            
	     AAdd(aSB1,{"B1_LOCPAD"    ,SB1->B1_LOCPAD ,NIL})
	ELSEIF cACAO == '1'
	     AAdd(aSB1,{"B1_LOCPAD"    ,::WSPRODKLASS:B1_LOCPAD ,NIL})
	EndIF
	IF (cACAO == '2' .AND. !Empty(::WSPRODKLASS:B1_GRTRIB))  .OR. cACAO == '1'
		 AAdd(aSB1,{"B1_GRTRIB"    ,::WSPRODKLASS:B1_GRTRIB ,NIL})
	EndIF
	IF (cACAO == '2' .AND. !Empty(::WSPRODKLASS:B1_ZMARCA))  .OR. cACAO == '1'
		 AAdd(aSB1,{"B1_ZMARCA"    ,::WSPRODKLASS:B1_ZMARCA ,NIL})
	EndIF
	IF cACAO == '1'
		AAdd(aSB1,{"B1_XSFA"	,"N"					,NIL})
	ENDIF
	AAdd(aSB1,{"B1_XINTEGR"	,"P"						,NIL})

	U_MFCONOUT("Executando integração do produto " + cB1_COD + "...")

	IF cACAO == '1'
		MSExecAuto({|x,y| Mata010(x,y)},aSB1,3)
	EndIF
	IF cACAO == '2'
		MSExecAuto({|x,y| Mata010(x,y)},aSB1,4)
	EndIF
	
	IF lMsErroAuto
		aErro := GetAutoGRLog()
		cErro := ""
		For nI := 1 to Len(aErro)
			cErro += aErro[nI] + CRLF
		Next nI
		AAdd(aRetorno ,"2")
		AAdd(aRetorno ,'Erro na Integração: '+cErro)
		U_MFCONOUT("Erro no execauto:  " + cErro + "...")
		bContinua   := .F.
	Endif
	
EndIF

If Len(aRetorno) == 0
	IF bContinua
		AAdd(aRetorno ,"1")
		AAdd(aRetorno,'Acao Efetuada com Sucesso !')
		U_MFCONOUT("Completou integração do produto " + cB1_COD + "...")
	Else
		AAdd(aRetorno ,"2")
		AAdd(aRetorno,'Erro indeterminado')
		U_MFCONOUT("Erro inderteminado na integração do produto " + cB1_COD + "...")
	EndIF
Endif

::WSRETORNO := WSClassNew("MGFTAC10_RETORNO")
::WSRETORNO:STATUS  := aRetorno[1]
::WSRETORNO:MSG	    := aRetorno[2]

Return .T.     
                                   


