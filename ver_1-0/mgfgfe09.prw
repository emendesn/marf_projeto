#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
=========================================================================================================
Programa.................: MGFGFE09
Autor:...................: Fl�vio Dentello
Data.....................: 06/09/2016
Descri��o / Objetivo.....: Altera��o do GAP GFE09
Doc. Origem..............: GAP - GFE11
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................: 
=========================================================================================================
*/

User Function GFE0901

	Local oMBrowse := nil
	Local aAux := {}
	oMBrowse:= FWmBrowse():New()

	oMBrowse:SetAlias("ZD3")
	oMBrowse:SetDescription("Cadastro de Regras Tipo de Opera��o")
	oMBrowse:Setmenudef("MGFGFE09")
	
	oMBrowse:Activate()
	
Return

**********************************************************
Static Function MenuDef()
	
	Local	aRotina	:= {}
	
	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"         OPERATION 1                       ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFGFE09" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	  ACTION "VIEWDEF.MGFGFE09" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	  ACTION "VIEWDEF.MGFGFE09" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	  ACTION "VIEWDEF.MGFGFE09" OPERATION MODEL_OPERATION_DELETE ACCESS 0
	
Return aRotina
**********************************************************
Static Function ModelDef()

Local oStruZD3 := FWFormStruct( 1, 'ZD3', /*bAvalCampo*/,/*lViewUsado*/ )
Local oModel
//Public xcExpressao := ""

oModel := MPFormModel():New('XGFE0901', /*bPreValidacao*/, { | oModel | GFE09POS( oModel ) }, /*bCommit*/, /*bCancel*/ )

oModel:AddFields( 'ZD3MASTER', /*cOwner*/, oStruZD3, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

oStruZD3:setProperty("ZD3_CARGA"	, MODEL_FIELD_VALID	,{||U_CARGA_MGF()	})
oStruZD3:setProperty("ZD3_NOTA"		, MODEL_FIELD_VALID	,{||U_NOTA()		})
oStruZD3:setProperty("ZD3_PEDIDO"	, MODEL_FIELD_VALID	,{||U_PEDIDO()		})
oStruZD3:setProperty("ZD3_ITEM"		, MODEL_FIELD_VALID	,{||U_ITEMZD3()		})
oStruZD3:setProperty("ZD3_ROMANE"	, MODEL_FIELD_VALID	,{||U_xRomanei()	})
oStruZD3:setProperty("ZD3_TRECH1"	, MODEL_FIELD_VALID	,{||U_GFE09Tr1()	})
oStruZD3:setProperty("ZD3_TRECH2"	, MODEL_FIELD_VALID	,{||U_GFE09Tr2()	})
oStruZD3:setProperty("ZD3_PRODUT"	, MODEL_FIELD_VALID	,{||U_xGFE09PR()	})
oStruZD3:setProperty("ZD3_CLIENT"	, MODEL_FIELD_VALID	,{||U_xGFE09CL()	})

oModel:SetDescription( 'Regras de Tipo Opera��o' )

oModel:SetPrimaryKey({"ZD3_FILIAL","ZD3_COD"})

//oStruZD3:setValue('ZD3MASTER','ZD3_EXPRES', xcExpressao)

oModel:GetModel( 'ZD3MASTER' ):SetDescription( 'Regras de Tipo Opera��o' )

Return oModel

**********************************************************
Static Function ViewDef()

Local oModel   := FWLoadModel( 'MGFGFE09' )
Local oStruZD3 := FWFormStruct( 2, 'ZD3' )
Local oView
Local cCampos := {}


	oStruZD3:AddGroup( 'GRP01', '                                          ', '', 1 )
	oStruZD3:AddGroup( 'GRP02', 'Tipo de Opera��o a ser utilizado na Carga ', '', 2 )
	oStruZD3:AddGroup( 'GRP03', 'Observa��es                               ', '', 3 )

	oStruZD3:SetProperty( 'ZD3_COD'    , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZD3:SetProperty( 'ZD3_CARGA'  , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZD3:SetProperty( 'ZD3_NOTA'   , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZD3:SetProperty( 'ZD3_PEDIDO' , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZD3:SetProperty( 'ZD3_ITEM'   , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZD3:SetProperty( 'ZD3_EXPRES' , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZD3:SetProperty( 'ZD3_EXPSIM' , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZD3:SetProperty( 'ZD3_ROMANE' , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZD3:SetProperty( 'ZD3_TRECH1' , MVC_VIEW_GROUP_NUMBER, 'GRP01' )	
	oStruZD3:SetProperty( 'ZD3_TRECH2' , MVC_VIEW_GROUP_NUMBER, 'GRP01' )		
	oStruZD3:SetProperty( 'ZD3_CALFRR' , MVC_VIEW_GROUP_NUMBER, 'GRP01' )	
	oStruZD3:SetProperty( 'ZD3_PRIORI' , MVC_VIEW_GROUP_NUMBER, 'GRP01' )		
	oStruZD3:SetProperty( 'ZD3_PRODUT' , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZD3:SetProperty( 'ZD3_CLIENT' , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZD3:SetProperty( 'ZD3_TPOP'   , MVC_VIEW_GROUP_NUMBER, 'GRP02' )
	oStruZD3:SetProperty( 'ZD3_DESTPO' , MVC_VIEW_GROUP_NUMBER, 'GRP02' )
	
	oStruZD3:SetProperty( 'ZD3_OBSERV' , MVC_VIEW_GROUP_NUMBER, 'GRP03' )

oView := FWFormView():New()

oView:SetModel( oModel )

oView:AddField( 'VIEW_ZD3', oStruZD3, 'ZD3MASTER' )

oView:CreateHorizontalBox( 'TELA' , 100 )

oView:SetOwnerView( 'VIEW_ZD3', 'TELA' )

Return oView

**********************************************************
//FUN��O QUE RETORNA TELA DE EXPRESS�O DA TABELA DE CARGA
**********************************************************
User Function CARGA_MGF()

Local oMdlZD3    := FWModelActive()
Local cExpres   := ""
Local aCFOP := {}

dBselectArea('DAK')
cExpres := BuildExpr('DAK',,,.T.,,,)  

cExpres := Alltrim(StrTran(cExpres,".",""))
	If Len(cExpres) > TamSX3("ZD3_CARGA")[1]
		Help( ,, 'HELP',, "O tamanho da express�o (" + cValToChar(Len(cExpres)) + ") � maior do que o sistema comporta (" + cValTochar(TamSX3("ZD3_CARGA")[1]) + ")", 1, 0,)
		Return cRet 
	EndIf
			
	oMdlZD3:LoadValue("ZD3MASTER","ZD3_CARGA",cExpres)
	//xcExpressao += cExpres
Return .T.

**********************************************************
//FUN��O QUE RETORNA TELA DE EXPRESS�O DA TABELA GWN
**********************************************************
User Function xRomanei()

Local oMdlZD3    := FWModelActive()
Local cExpres   := ""

dBselectArea('DA3')
cExpres := BuildExpr('DA3',,,.T.,,,)  

cExpres := Alltrim(StrTran(cExpres,".",""))
	If Len(cExpres) > TamSX3("ZD3_ROMANE")[1]
		Help( ,, 'HELP',, "O tamanho da express�o (" + cValToChar(Len(cExpres)) + ") � maior do que o sistema comporta (" + cValTochar(TamSX3("ZD3_ROMANE")[1]) + ")", 1, 0,)
		Return cRet 
	EndIf

	oMdlZD3:LoadValue("ZD3MASTER","ZD3_ROMANE",cExpres)
	//xcExpressao += cExpres
Return .T.

**********************************************************
//FUN��O QUE RETORNA TELA DE EXPRESS�O DA TABELA DE NOTA
**********************************************************
User Function NOTA()

Local oMdlZD3    := FWModelActive()
Local cExpres   := ""
Local aCFOP := {}

dBselectArea('SF2')

	cExpres := BuildExpr('SF2',,,.T.,,,)  

	cExpres := Alltrim(StrTran(cExpres,".",""))
	If Len(cExpres) > TamSX3("ZD3_NOTA")[1]
		Help( ,, 'HELP',, "O tamanho da express�o (" + cValToChar(Len(cExpres)) + ") � maior do que o sistema comporta (" + cValTochar(TamSX3("ZD3_NOTA")[1]) + ")", 1, 0,)
		Return cRet 
	EndIf
			
	oMdlZD3:LoadValue("ZD3MASTER","ZD3_NOTA",cExpres)
	//xcExpressao += cExpres
Return .T.

**********************************************************
//FUN��O QUE RETORNA TELA DE EXPRESS�O DA TABELA DE PEDIDO
**********************************************************
User Function PEDIDO()

Local oMdlZD3    := FWModelActive()
Local cExpres   := ""
Local aCFOP := {}

dBselectArea('SC5')

	cExpres := BuildExpr('SC5',,,.T.,,,)  

	cExpres := Alltrim(StrTran(cExpres,".",""))
	If Len(cExpres) > TamSX3("ZD3_PEDIDO")[1]
		Help( ,, 'HELP',, "O tamanho da express�o (" + cValToChar(Len(cExpres)) + ") � maior do que o sistema comporta (" + cValTochar(TamSX3("ZD3_PEDIDO")[1]) + ")", 1, 0,)
		Return cRet 
	EndIf
			
	oMdlZD3:LoadValue("ZD3MASTER","ZD3_PEDIDO",cExpres)
	//xcExpressao += cExpres
Return .T.

**********************************************************
//FUN��O QUE RETORNA TELA DE EXPRESS�O DA TABELA DE ITEM NF
**********************************************************
User Function ITEMZD3()

Local oMdlZD3    := FWModelActive()
Local cExpres   := ""
Local aCFOP := {}

dBselectArea('SD2')

	cExpres := BuildExpr('SD2',,,.T.,,,)  

	cExpres := Alltrim(StrTran(cExpres,".",""))
	If Len(cExpres) > TamSX3("ZD3_ITEM")[1]
		Help( ,, 'HELP',, "O tamanho da express�o (" + cValToChar(Len(cExpres)) + ") � maior do que o sistema comporta (" + cValTochar(TamSX3("ZD3_ITEM")[1]) + ")", 1, 0,)
		Return cRet 
	EndIf
			
	oMdlZD3:LoadValue("ZD3MASTER","ZD3_ITEM",cExpres)
	//xcExpressao += cExpres
Return .T.


**********************************************************
//FUN��O QUE RETORNA TELA DE EXPRESS�O DA TABELA DE TRECHO DE ITINERARIO 1
**********************************************************
User Function GFE09Tr1()

Local oMdlZD3    := FWModelActive()
Local cExpres   := ""

dBselectArea('GWU')

	cExpres := BuildExpr('GWU',,,.T.,,,)  

	cExpres := Alltrim(StrTran(cExpres,".",""))
	If Len(cExpres) > TamSX3("ZD3_TRECH1")[1]
		Help( ,, 'HELP',, "O tamanho da express�o (" + cValToChar(Len(cExpres)) + ") � maior do que o sistema comporta (" + cValTochar(TamSX3("ZD3_TRECH1")[1]) + ")", 1, 0,)
		Return cRet 
	EndIf
			
	oMdlZD3:LoadValue("ZD3MASTER","ZD3_TRECH1",cExpres)
	//xcExpressao += cExpres
Return .T.

**********************************************************
//FUN��O QUE RETORNA TELA DE EXPRESS�O DA TABELA DE TRECHO DE ITINERARIO 2
**********************************************************
User Function GFE09Tr2()

Local oMdlZD3    := FWModelActive()
Local cExpres   := ""

dBselectArea('GWU')

	cExpres := BuildExpr('GWU',,,.T.,,,)  

	cExpres := Alltrim(StrTran(cExpres,".",""))
	If Len(cExpres) > TamSX3("ZD3_TRECH2")[1]
		Help( ,, 'HELP',, "O tamanho da express�o (" + cValToChar(Len(cExpres)) + ") � maior do que o sistema comporta (" + cValTochar(TamSX3("ZD3_TRECH2")[1]) + ")", 1, 0,)
		Return cRet 
	EndIf
			
	oMdlZD3:LoadValue("ZD3MASTER","ZD3_TRECH2",cExpres)
	//xcExpressao += cExpres
Return .T.

/*/{Protheus.doc} xGFE09PR
	Valida��o, para abertura de tela de filtro, onde sera geradado a express�o para tabela SB1
	@type function

	@return  	xRet, true ou false, valida��o do campo ZD3_PRODUT

	@author Joni Lima do Carmo
	@since 18/07/2019
	@version P12
/*/
User Function xGFE09PR()

	Local oMdlZD3    := FWModelActive()
	Local cExpres   := ""

	dBselectArea('SB1')

	cExpres := BuildExpr('SB1',,,.T.,,,)
	cExpres := Alltrim(StrTran(cExpres,".",""))
	If Len(cExpres) > TamSX3("ZD3_PRODUT")[1]
		Help( ,, 'HELP',, "O tamanho da express�o (" + cValToChar(Len(cExpres)) + ") � maior do que o sistema comporta (" + cValTochar(TamSX3("ZD3_PRODUT")[1]) + ")", 1, 0,)
		Return cRet
	EndIf

	oMdlZD3:LoadValue("ZD3MASTER","ZD3_PRODUT",cExpres)

Return .T.

/*/{Protheus.doc} xGFE09CL
	Valida��o, para abertura de tela de filtro, onde sera geradado a express�o para tabela SA1
	@type function

	@return  	xRet, true ou false, valida��o do campo ZD3_CLIENT

	@author Joni Lima do Carmo
	@since 18/07/2019
	@version P12
/*/
User Function xGFE09CL()

	Local oMdlZD3    := FWModelActive()
	Local cExpres   := ""

	dBselectArea('SA1')

	cExpres := BuildExpr('SA1',,,.T.,,,)
	cExpres := Alltrim(StrTran(cExpres,".",""))
	If Len(cExpres) > TamSX3("ZD3_CLIENT")[1]
		Help( ,, 'HELP',, "O tamanho da express�o (" + cValToChar(Len(cExpres)) + ") � maior do que o sistema comporta (" + cValTochar(TamSX3("ZD3_CLIENT")[1]) + ")", 1, 0,)
		Return cRet
	EndIf

	oMdlZD3:LoadValue("ZD3MASTER","ZD3_CLIENT",cExpres)

Return .T.
**********************************************************
//FUN��O QUE GRAVA EXPRESS�O NO CAMPO MEMO
**********************************************************
Static Function GFE09POS()

local oModel		:= FWModelActive()
local oModelZD3		:= oModel:GetModel('ZD3MASTER')
local nOper			:= oModel:getOperation()
local aSaveLines	:= FWSaveRows()
Local aTab			:={}

If nOper != MODEL_OPERATION_DELETE
//If oModelZD3:SetValue("ZD3_EXPRES","")
	// zera o campo
	oModelZD3:SetValue("ZD3_EXPRES","")
	
	If !empty(oModelZD3:getValue("ZD3_CARGA"))
	oModelZD3:SetValue("ZD3_EXPRES",oModelZD3:getValue("ZD3_EXPRES") + Alltrim(oModelZD3:getValue("ZD3_CARGA")) + " ")
	AADD(aTab,"DAK")
	EndIf
	
	If !empty(oModelZD3:getValue("ZD3_NOTA"))
	oModelZD3:SetValue("ZD3_EXPRES",oModelZD3:getValue("ZD3_EXPRES") + Alltrim(oModelZD3:getValue("ZD3_NOTA")) + " ")
	AADD(aTab,"SF2")
	EndIf
	
	If !empty(oModelZD3:getValue("ZD3_PEDIDO"))
	oModelZD3:SetValue("ZD3_EXPRES",oModelZD3:getValue("ZD3_EXPRES") + Alltrim(oModelZD3:getValue("ZD3_PEDIDO")) + " ")
	AADD(aTab,"SC5")
	EndIf
	
	If !empty(oModelZD3:getValue("ZD3_ITEM"))
	oModelZD3:SetValue("ZD3_EXPRES",oModelZD3:getValue("ZD3_EXPRES") + Alltrim(oModelZD3:getValue("ZD3_ITEM")) + " ")
	AADD(aTab,"SD2")
	EndIf

	If !empty(oModelZD3:getValue("ZD3_ROMANE"))
	oModelZD3:SetValue("ZD3_EXPRES",oModelZD3:getValue("ZD3_EXPRES") + Alltrim(oModelZD3:getValue("ZD3_ROMANE")) + " ")
	AADD(aTab,"DA3")
	EndIf

	If !empty(oModelZD3:getValue("ZD3_TRECH1"))
	oModelZD3:SetValue("ZD3_EXPRES",oModelZD3:getValue("ZD3_EXPRES") + Alltrim(oModelZD3:getValue("ZD3_TRECH1")) + " ")
	AADD(aTab,"GWU")
	EndIf

	If !empty(oModelZD3:getValue("ZD3_TRECH2"))
	oModelZD3:SetValue("ZD3_EXPRES",oModelZD3:getValue("ZD3_EXPRES") + Alltrim(oModelZD3:getValue("ZD3_TRECH2")) + " ")
	AADD(aTab,"GWU")
	EndIf

	If !empty(oModelZD3:getValue("ZD3_PRODUT"))
	oModelZD3:SetValue("ZD3_EXPRES",oModelZD3:getValue("ZD3_EXPRES") + Alltrim(oModelZD3:getValue("ZD3_PRODUT")) + " ")
	AADD(aTab,"SB1")
	EndIf

	If !empty(oModelZD3:getValue("ZD3_CLIENT"))
	oModelZD3:SetValue("ZD3_EXPRES",oModelZD3:getValue("ZD3_EXPRES") + Alltrim(oModelZD3:getValue("ZD3_CLIENT")) + " ")
	AADD(aTab,"SA1")
	EndIf
	oModelZD3:SetValue("ZD3_EXPSIM",xCriaEsp(oModelZD3:getValue("ZD3_EXPRES"),aTab))
//EndIf
Endif

Return .T.
	
	
	
/*
=========================================================================================================
Programa.................: MGFGFE09
Autor:...................: Fl�vio Dentello
Data.....................: 06/09/2016
Descri��o / Objetivo.....: Cadastro de Ve�culos Fidelizados
Doc. Origem..............: GAP - GFE09
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................: 
=========================================================================================================
*/

/*
User Function GFE0901


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := "U_INCLUI()"//".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZN"

dbSelectArea("SZN")
dbSetOrder(1)

AxCadastro(cString,"Par�metro Tipo de Opera��o e Classifica��o de Frete",cVldExc,cVldAlt)

Return
             
// Valida inclus�o
                            
User Function INCLUI()

Local lRet     := .T.
Local cAlias   := ""
Local cQuery   := ""                 
Local cPlaca   := M->ZN_ZPLACA
Local cTpop    := M->ZN_ZTPOPE
Local cClassf  := M->ZN_ZCDCLFR
Local cUnidade := M->ZN_UNIDADE  
Local cTpPed   := M->ZN_TIPPED     
Local cCdveic  := M->ZN_ZCDVEIC    
Local cTpVeic  := M->ZN_ZCDTIPO
Local cTransp  := M->ZN_CNPJTRP
Local nReg     := 0

cAlias	:= GetNextAlias()                 

cQuery := " SELECT *"
cQuery += " FROM "+RetSqlName("SZN") + " SZN "
cQuery += " WHERE SZN.ZN_FILIAL = '" + cFilant +"' "  
cQuery += " AND SZN.ZN_ZCDVEIC = '" + cCdveic + "'"  
cQuery += " AND SZN.ZN_ZCDTIPO = '" + cTpVeic + "'"  
cQuery += " AND SZN.ZN_ZPLACA = '" + cPlaca + "'" 
cQuery += " AND SZN.ZN_ZTPOPE = '" + cTpop + "' "
cQuery += " AND SZN.ZN_ZCDCLFR = '" + cClassf + "' "
cQuery += " AND SZN.ZN_TIPPED = '" + cTpPed + "' "  
cQuery += " AND SZN.ZN_UNIDADE = '" + cUnidade + "' "
cQuery += " AND SZN.ZN_CNPJTRP = '" + cTransp + "' "
cQuery += " AND SZN.D_E_L_E_T_=''"

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias, .F., .T.)

If !Empty((cAlias)->ZN_FILIAL)

	lRet := .F.

EndIf	

dBselectArea(cAlias)
DbCloseArea()

If lRet = .F.

	MsgAlert("Regra j� cadastrada, N�o � poss�vel criar regras duplicadas!")

EndIf

if empty(M->ZN_CNPJTRP) .AND. empty(M->ZN_ZCDVEIC) .AND. empty(M->ZN_ZCDTIPO) .AND. empty(M->ZN_TIPPED)
	msgAlert("Obrigatorio o preenchimento de um dos campos: Transportador, Veiculo, Tipo de Veiculo, Tipo de Pedido")
	lRet := .F.
endif

Return lRet
*/


User Function GFE09PrioVld()

Local lRet := .T.

If Len(Alltrim(M->ZD3_PRIORI)) < TamSX3("ZD3_PRIORI")[1]
	APMsgAlert("Preencha o campo com "+Alltrim(Str(TamSX3("ZD3_PRIORI")[1]))+" d�gitos.")
	lRet := .F.
Endif

//M->ZD3_PRIORI := Padl(M->ZD3_PRIORI,TamSX3("ZD3_PRIORI")[1],"0")

Return(lRet)	
Static Function xCriaEsp(cExp,aTab)

	Local aArea := GetArea()
	Local cRet := cExp
	Local ni   := 0

	Default aTab :={}

	For ni:= 1 To len(aTab)
		cRet := xFieldTab(aTab[ni],cRet)
	Next ni

	//Substitui os AND
	cRet := STRTRAN(cRet,"AND","E")

	//Substitui os OU
	cRet := STRTRAN(cRet,"OR","OU")

	RestArea(aArea)

Return cRet

Static Function xFieldTab(cxAlias,cText)

	Local cRet := cText
	Local cNextAlias := GetNextAlias()

	BeginSql Alias cNextAlias

		SELECT
			X3_CAMPO,
			X3_TITULO
		FROM SX3010 X3
		WHERE
				X3.%NotDel%
			AND X3.X3_ARQUIVO = %Exp:cxAlias%
		ORDER BY X3_ORDEM

	EndSql

	While (cNextAlias)->(!EOF())
		cRet := STRTRAN(cRet, Alltrim((cNextAlias)->X3_CAMPO),Alltrim((cNextAlias)->X3_TITULO))
		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

Return cRet