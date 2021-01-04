#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#DEFINE CRLF chr(13) + chr(10)

/*
	Cadastro de Pré Cálculo
*/
User Function MGFEEC65()

Local oBrowse

Private cTipo := ''
Private nAcao := 0 

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('ZED')
oBrowse:SetDescription('Pré Cálculo')
oBrowse:Activate()

Return Nil

//---------------------------------------------------------------
Static function MenuDef()
local aRotina := {}

	ADD OPTION aRotina TITLE 'Incluir'		ACTION 'U_EEC65_MNU(1)'	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'		ACTION 'U_EEC65_MNU(2)'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar'	ACTION 'U_EEC65_MNU(3)'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'		ACTION 'U_EEC65_MNU(4)'	OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Copiar'		ACTION 'U_EEC65_CPY()'	OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE 'Importar CSV'	ACTION 'U_MGFEEC64'		OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE 'Exportar CSV'	ACTION 'U_MGFEEC66'		OPERATION 8 ACCESS 0

return aRotina

//--------------------------------------------------------
//--------------------------------------------------------
static function ModelDef()
	local aZEERel	:= {}
	local oStruZED 	:= FWFormStruct( 1, "ZED")
	local oStruZEE	:= FWFormStruct( 1, 'ZEE' )
	local oModel	:= nil
	
	oModel := MPFormModel():New( 'MDLEEC65' , , {|x|Val_ZED(x)}, /*bcommit*/)

	
	oStruZED:SetProperty("*", MODEL_FIELD_OBRIGAT	, .F. )
	oStruZED:SetProperty("ZED_DESPAC", MODEL_FIELD_VALID, { || U_EEC65_VLD("ZED_DESPAC") } )

	oStruZED:SetProperty("ZED_TIPODE", MODEL_FIELD_WHEN, {|| .F. })    
	oStruZED:SetProperty("ZED_CODIGO", MODEL_FIELD_WHEN, {|| .F. })


	oModel:AddFields( 'ZEDMASTER',				, oStruZED )
	oModel:AddGrid	( 'ZEEDETAIL', 'ZEDMASTER'	, oStruZEE, , {|x|Val_Linha(x)} )


    //Fazendo o relacionamento entre o Pai e Filho
    aadd(aZEERel, {'ZEE_FILIAL', 'xFilial( "ZEE" )'	})
    aadd(aZEERel, {'ZEE_CODIGO', 'ZED_CODIGO'		})

    oModel:SetRelation( 'ZEEDETAIL' , aZEERel , ZEE->( indexKey( 4 ) ) )

	oModel:SetDescription( 'Pré Cálculo' )

	oModel:setPrimaryKey( { 'ZED_FILIAL' , 'ZED_CODIGO' } )

	oModel:GetModel( 'ZEDMASTER' ):SetDescription( 'Tabela de Pré Cálculo' )
	oModel:GetModel( 'ZEEDETAIL' ):SetDescription( 'Despesas de Pré Cálculo' )
	
return oModel

//--------------------------------------------------------
//--------------------------------------------------------
static function ViewDef()
	local oModel	:= FWLoadModel( 'MGFEEC65' )
	local oStruZED	:= FWFormStruct( 2, 'ZED'	, {| cCampo |  allTrim( cCampo ) $ CamposZED() } )
	local oStruZEE	:= FWFormStruct( 2, 'ZEE'	, {| cCampo |  allTrim( cCampo ) $ CamposZEE() } )
	local oView		:= nil


  	IF cTipo == 'T'
	  	oStruZEE:SetProperty( 'ZEE_CODDES'	, MVC_VIEW_ORDEM, '01' )
	  	oStruZEE:SetProperty( 'ZEE_DESPES'	, MVC_VIEW_ORDEM, '02' )
	  	oStruZEE:SetProperty( 'ZEE_TERMIN'	, MVC_VIEW_ORDEM, '03' )
	  	oStruZEE:SetProperty( 'ZEE_NOMTER'	, MVC_VIEW_ORDEM, '04' )
	  	//oStruZEE:SetProperty( 'ZEE_QTDDIA'	, MVC_VIEW_ORDEM, '05' )
	  	oStruZEE:SetProperty( 'ZEE_PER'	    , MVC_VIEW_ORDEM, '06' )
	  	oStruZEE:SetProperty( 'ZEE_DIAPER'	, MVC_VIEW_ORDEM, '07' )
	  	oStruZEE:SetProperty( 'ZEE_VLPER'	, MVC_VIEW_ORDEM, '08' )
	  	oStruZEE:SetProperty( 'ZEE_MOEDA'	, MVC_VIEW_ORDEM, '09' )
	  	oStruZEE:SetProperty( 'ZEE_COB'	    , MVC_VIEW_ORDEM, '10' )
	  	oStruZEE:SetProperty( 'ZEE_CONT'	, MVC_VIEW_ORDEM, '11' )
	  	oStruZEE:SetProperty( 'ZEE_DESCON'	, MVC_VIEW_ORDEM, '12' )
	  	oStruZEE:SetProperty( 'ZEE_PCALC'	, MVC_VIEW_ORDEM, '13' )
  	ELSEIF cTipo == 'D'
		 oStruZED:SetProperty("ZED_TIPODE", MODEL_FIELD_WHEN, {|| .F. })
		oStruZEE:SetProperty( 'ZEE_COB'		, MVC_VIEW_TITULO, 'Multiplica' )  
	  	oStruZEE:SetProperty( 'ZEE_CODDES'	, MVC_VIEW_ORDEM, '01' )
	  	oStruZEE:SetProperty( 'ZEE_DESPES'	, MVC_VIEW_ORDEM, '02' )
		oStruZEE:SetProperty( 'ZEE_TPDESP'	, MVC_VIEW_ORDEM, '03' )
		oStruZEE:SetProperty( 'ZEE_COB'	    , MVC_VIEW_ORDEM, '04' )
		oStruZEE:SetProperty( 'ZEE_DVAL1'	, MVC_VIEW_ORDEM, '05' )
	  	oStruZEE:SetProperty( 'ZEE_DVAL2'	, MVC_VIEW_ORDEM, '06' )
		oStruZEE:SetProperty( 'ZEE_MOEDA'	, MVC_VIEW_ORDEM, '07' )
	  	oStruZEE:SetProperty( 'ZEE_VALOR'   , MVC_VIEW_ORDEM, '08' )
	  	oStruZEE:SetProperty( 'ZEE_VALMIN'	, MVC_VIEW_ORDEM, '09' )
	  	oStruZEE:SetProperty( 'ZEE_VALMAX'	, MVC_VIEW_ORDEM, '10' )
	  	oStruZEE:SetProperty( 'ZEE_FORN'	, MVC_VIEW_ORDEM, '11' )
	  	oStruZEE:SetProperty( 'ZEE_DESCFO'	, MVC_VIEW_ORDEM, '11' )
	EndIF


	oView := FWFormView():New()

	oView:SetModel( oModel )

	oView:AddField( 'VIEW_ZED'	, oStruZED, 'ZEDMASTER' )
	oView:AddGrid( 'VIEW_ZEE'	, oStruZEE, 'ZEEDETAIL' )

	oView:SetViewProperty("VIEW_ZEE", "GRIDFILTER", {.T.})
	
	oView:CreateHorizontalBox( 'TABPRECALC'	, 28 )
	oView:CreateHorizontalBox( 'DESPESAS'	, 72 )

	oView:SetOwnerView( 'VIEW_ZED', 'TABPRECALC' )
	oView:SetOwnerView( 'VIEW_ZEE', 'DESPESAS' )

    //Habilitando título
    oView:EnableTitleView( 'ZEDMASTER', 'Tabela de Pré Cálculo' )
    oView:EnableTitleView( 'ZEEDETAIL', 'Despesas de Pré Cálculo' )

return oView

***********************************************************************************************************************************
User Function EEC65_MNU(nTipo)

Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}
Local aRet		:= {}
Local aParambox	:= {}

Private nParamOpc	:= 0
Private oBrowse

nAcao := nTipo

IF nAcao == 1 
	AAdd( aParambox, { 3 , "Tipo de Lançamento" , 1 , { "Armadores" , "Terminais","Despachantes" } , 070 , "" , .T. } )
	If ParamBox(aParambox, "Tipo de Lançamento"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .F. /*lCanSave*/, .F. /*lUserSave*/)
		nParamOpc := MV_PAR01
		If nParamOpc == 1
             cTipo := 'A'
		ElseIF nParamOpc == 2
             cTipo := 'T'
		ElseIF nParamOpc == 3
             cTipo := 'D'
		Endif
	EndIF
	FWExecView('INCLUSÃO','MGFEEC65', MODEL_OPERATION_INSERT, , { || .T. }, , ,aButtons )
ElseIF  nAcao == 2 
    cTipo := ZED->ZED_TIPODE
	FWExecView('ALTERAÇÃO','MGFEEC65', MODEL_OPERATION_UPDATE, , { || .T. }, , ,aButtons )
ElseIF nAcao == 3
    cTipo := ZED->ZED_TIPODE
	FWExecView('VISUALIZAÇÃO','MGFEEC65', MODEL_OPERATION_VIEW, , { || .T. }, , ,aButtons )
ElseIF nAcao == 4
    cTipo := ZED->ZED_TIPODE
	FWExecView('EXCLUSÃO','MGFEEC65', MODEL_OPERATION_DELETE, , { || .T. }, , ,aButtons )
EndIF

Return .T.
***********************************************************************************************************************************
Static Function CamposZED()
Local cCampos := ""


IF cTipo == 'A'
    cCampos += ' ZED_CODIGO | ZED_DESCRI | ZED_TIPODE | ZED_DTINIC | ZED_DTFIM | ZED_TAMCON '
ElseIF cTipo == 'T'
    cCampos += ' ZED_CODIGO | ZED_DESCRI | ZED_TIPODE | ZED_DTINIC | ZED_DTFIM | '
ElseIF cTipo == 'D'
    cCampos += ' ZED_CODIGO | ZED_DESCRI | ZED_TIPODE | ZED_DESPAC | ZED_DESCDE'
EndIF

Return cCampos

***********************************************************************************************************************************
Static Function CamposZEE()
Local cCampos := ""


IF cTipo == 'A'
    cCampos += ' ZEE_CODDES | ZEE_DESPES | ZEE_TIPOPR | ZEE_MOEDA  | ZEE_VALOR  | ZEE_VALMIN | ZEE_VALMAX | ZEE_ORIGEM | ZEE_NOMORI | ZEE_DESTIN | ZEE_NOMDES | ZEE_ARMADO | ZEE_NOMARM'
ElseIF cTipo == 'T'
    cCampos += ' ZEE_CODDES | ZEE_DESPES | ZEE_TERMIN | ZEE_NOMTER | ZEE_PER  | ZEE_MOEDA    | ZEE_VLPER | ZEE_COB | ZEE_PCALC | ZEE_DIAPER | ZEE_CONT   | ZEE_DESCON'
ElseIF cTipo == 'D'
    cCampos += ' ZEE_CODDES | ZEE_DESPES | ZEE_COB  | ZEE_DVAL1 | ZEE_DVAL2 | ZEE_TPDESP  | ZEE_MOEDA  | ZEE_VALOR  | ZEE_VALMIN | ZEE_VALMAX | ZEE_FORN  | ZEE_DESCFO | '
EndIF

Return cCampos

***************************************************************************************************************************************
User Function EEC65_VLD(cCampo)
Local oModel := FwModelActive()
Local cValor := ''
Local cRet   := .F. 

IF cCampo =='ZEE_CONT'
     IF ExistCpo("EYG", oModel:GetValue('ZEEDETAIL','ZEE_CONT'))
     	 cValor := GetAdvFVal("EYG","EYG_DESCON",xFilial("EYG")+oModel:GetValue('ZEEDETAIL','ZEE_CONT'),1,"")
     	 cRet   := .T. 
     EndIF
     oModel:SetValue("ZEEDETAIL","ZEE_DESCON",cValor)
EndIF

IF cCampo =='ZEE_TERMIN'
     IF ExistCpo("SY5", oModel:GetValue('ZEEDETAIL','ZEE_TERMIN'))
     	 cValor := GetAdvFVal("SY5","Y5_NOME",xFilial("SY5")+oModel:GetValue('ZEEDETAIL','ZEE_TERMIN'),1,"")                                                  
     	 cRet   := .T. 
     EndIF
     oModel:SetValue("ZEEDETAIL","ZEE_NOMTER",cValor)
EndIF

IF cCampo =='ZEE_FORN'
     IF ExistCpo("SX5", 'Z1'+oModel:GetValue('ZEEDETAIL','ZEE_FORN'))
     	 cValor := Posicione("SX5",1,xFilial("SX5")+"Z1"+oModel:GetValue('ZEEDETAIL','ZEE_FORN'), "X5DESCRI()")
     	 cRet   := .T. 
     EndIF
     oModel:SetValue("ZEEDETAIL","ZEE_DESCFO",cValor)
EndIF

IF cCampo =='ZEE_CODDES'
     IF ExistCpo("SYB", oModel:GetValue('ZEEDETAIL','ZEE_CODDES'))
     	 cValor := GetAdvFVal("SYB","YB_DESCR",xFilial("SYB")+oModel:GetValue('ZEEDETAIL','ZEE_CODDES'),1,"")    
     	 cRet   := .T. 
     EndIF
     oModel:SetValue("ZEEDETAIL","ZEE_DESPES",cValor)
EndIF
IF cCampo =='ZED_DESPAC' .AND. (nAcao == 1 .OR. nAcao == 2) .AND. cTipo == "D" 
	SY5->(dbSetOrder(1))
	IF SY5->(!dbSeek(xFilial('SY5')+oModel:GetValue('ZEDMASTER','ZED_DESPAC')))
			Help('',1,'Codigo do Despachante',,'Despachante não encontrado !!' ,1,0)
			cRet  := .F.  
	Else
		IF !(LEFT(SY5->Y5_TIPOAGE,1) == "6" .OR. LEFT(SY5->Y5_TIPOAGE,1) == " ")
			Help('',1,'Codigo do Despachante',,'Codigo não é de despachante !!' ,1,0)
			cRet  := .F.  
		Else
		    cRet   := .T.  
			cValor := SY5->Y5_NOME
		EndIF
	EndIF
     oModel:SetValue('ZEDMASTER','ZED_DESCDE',cValor)
EndIF


Return cRet
***************************************************************************************************************************************
User Function EEC65_INI(cCampo)
Local oModel := FwModelActive()
Local cRet   := ' ' 

IF cCampo =='ZEE_TIPODE'
     cRet :=  oModel:GetValue('ZEDMASTER','ZED_TIPODE')
     //oModel:SetValue("ZEEDETAIL","ZEE_TIPODE",oModel:GetValue('ZEDMASTER','ZED_TIPODE'))
EndIF

Return cRet
*****************************************************************************************************************************************
Static Function Val_Linha(oMdlZEE)

Local lRet       := .T.
Local ni         := 1	
Local aSaveLines := FwSaveRows()
Local nLinAtual	 := oMdlZEE:GetLine()
Local cDespesa   := oMdlZEE:GetValue('ZEE_CODDES')
Local cDesTipo   := oMdlZEE:GetValue('ZEE_TPDESP')
Local cMoeda     := oMdlZEE:GetValue('ZEE_MOEDA')
Local cForn      := oMdlZEE:GetValue('ZEE_FORN')
Local dDtIni     := oMdlZEE:GetValue('ZEE_DVAL1')
Local dDtFim     := oMdlZEE:GetValue('ZEE_DVAL2')

IF  cTipo == 'D' .And. (nAcao == 1 .OR. nAcao == 2)
	For ni:= 1  TO oMdlZEE:Length()
		oMdlZEE:GoLine(ni)
		If nLinAtual <> ni 
			IF AllTrim(oMdlZEE:GetValue('ZEE_CODDES')) == AllTrim(cDespesa) .AND.;
			AllTrim(oMdlZEE:GetValue('ZEE_TPDESP')) == AllTrim(cDesTipo) .AND.;
			AllTrim(oMdlZEE:GetValue('ZEE_FORN')) == AllTrim(cForn) .AND.;
			((oMdlZEE:GetValue('ZEE_DVAL1') >= dDtIni .And. oMdlZEE:GetValue('ZEE_DVAL1') <= dDtFim) .OR.;
			(oMdlZEE:GetValue('ZEE_DVAL2') >= dDtIni .And. oMdlZEE:GetValue('ZEE_DVAL2') <= dDtFim) ).And.;
			cDesTipo $ "F | L" 	
				
				lRet := .F.
				Help('',1,"Para Tipo de Despesa Folha ou Fixo, só poderá ter um lançamento por Fornecedor e Validade",,"Favor Verificar a Linha: '" + AllTrim(str(ni)) + "' , e realizar os ajustes necessarios.",1,0)
				Exit
			EndIF
			IF AllTrim(oMdlZEE:GetValue('ZEE_CODDES')) == AllTrim(cDespesa) .AND.;
			AllTrim(oMdlZEE:GetValue('ZEE_TPDESP')) == AllTrim(cDesTipo) .AND.;
			AllTrim(oMdlZEE:GetValue('ZEE_FORN')) == AllTrim(cForn) .AND.;
			AllTrim(oMdlZEE:GetValue('ZEE_MOEDA')) <> AllTrim(cMoeda)
				
				lRet := .F.
				Help('',1,"Só pode ter uma mesma Moeda para o Tipo de Despesa, Fornecedor",,"Favor Verificar a Linha: '" + AllTrim(str(ni)) + "' , e realizar os ajustes necessarios.",1,0)
				Exit
			EndIF

		Else
			IF AllTrim(oMdlZEE:GetValue('ZEE_TPDESP')) <> 'F' .And. AllTrim(oMdlZEE:GetValue('ZEE_CODIGO')) == GetNewPar('MGF_EEC65A','005')
				lRet := .F.
				Help('',1,'RTASK0010432',,"Só está habilitado o tipo de pré calculo Fixo.",1,0,,,,,,{"Por favor verificar a Linha: '" + AllTrim(str(ni)) + "' , e alterar o tipo do pré calculo, ou contatar o responsável pela Task RTASK0010432."})
				Exit
			EndIF	

		EndIf

	Next ni
EndIF

FWRestRows( aSaveLines )

Return lRet
*********************************************************************************************************************
Static Function Val_ZED(oModel)
	
Local lRet 		:= .T.
Local oMdlZED	:= oModel:GetModel('ZEDMASTER')
Local ni

IF  cTipo == 'D' .And. (nAcao == 1 .OR. nAcao == 2) 

	If Empty(oMdlZED:GetValue('ZED_DESPAC'))
		lRet := .F.
		Help('',1,'Codigo do Despachante',,'Codigo do Despachante em Branco !!' ,1,0)
	Else
		cQuery := " SELECT ZED_CODIGO "	
		cQuery += " From "+retSQLName("ZED")
		cQuery += " Where D_E_L_E_T_ = ' ' "								 
		cQuery += "  AND ZED_TIPODE	 =	 'D' "								
		cQuery += "  AND ZED_DESPAC  =   '"+oMdlZED:GetValue('ZED_DESPAC')+"'"								
		IF nAcao == 2
		     cQuery += "  AND R_E_C_N_O_  <> '"+Alltrim(Str(ZED->(Recno())))+"'"
		EndIf
		If Select("QRY_VLD") > 0
			QRY_VLD->(dbCloseArea())
		EndIf
		cQuery  := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_VLD",.T.,.F.)
		dbSelectArea("QRY_VLD")
		QRY_VLD->(dbGoTop())
		IF QRY_VLD->(!Eof())
			Help('',1,'Codigo do Despachante',,'Já Existe Tabela para este Despachante' ,1,0)
			lRet  := .F.
		EndIF
	EndIf
EndIf

Return lRet
***************************************************************************************************************
User Function EEC65_CPY()

Local aArea        := GetArea()
Local oModel
Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}

oModel := FWLoadModel("MGFEEC65")
oModel:SetOperation(MODEL_OPERATION_INSERT) 
oModel:Activate(.T.) 
	
oModelGrid := oModel:GetModel("ZEEDETAIL")

cTipo := ZED->ZED_TIPODE
nAcao := 1
FWExecView('COPIA','MGFEEC65', MODEL_OPERATION_INSERT, , { || .T. }, , ,aButtons, , , ,oModel )

oModel:DeActivate()
	
RestArea(aArea)

Return oModel
