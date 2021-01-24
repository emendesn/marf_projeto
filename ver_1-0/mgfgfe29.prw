#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*-------------------------------------------------------------------                                                                           
{Protheus.doc} MGFGFE29
Reformulação da 'Cópia e Reajuste' de Tabela de Frete

@author Rodrigo dos Santos
@since 01/12/2018
@version 1.0
-------------------------------------------------------------------*/
 User Function MGFGFE2()
	Local aCoors := FWGetDialogSize( oMainWnd )
	Local oLayerTabFrete, oLayerNeg
	Local oDialog0mg
	Local oRelacGV9
	Private oBrwTabFrete, oBrwNeg
	Private cAliasGV9, aCamposGV9, aStructGV9
	Private cAliasGV1, aCamposGV1, aStructGV1
	Private cAliasGUC, aCamposGUC, aStructGUC
	Private nCountGV1
	Private nCountGUC
	Private aRotas := {}
	Private aFaixas := {}
	Private aColsFaixas := {}
	Private aComponentes := {}
	Private aClientesCompAdicionais := {}
	
	/* -- Definição dos Structs e criação das tabelas temporárias - */
	
	DefStruct()
	
	                                              
	Define MsDialog oDialog0mg Title "Cópia entre Filiais" From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel
		/* -- Layers -------------------------------------------------- */
		oFWLayer := FWLayer():New()
		oFWLayer:Init(oDialog0mg, .F., .T.)
		
		// Tabela de Frete
		oFWLayer:AddLine('TOP', 50, .F.)
		oFWLayer:AddCollumn('TABFRETE', 100, .T., 'TOP') // Tabela de Frete
		oLayerTabFrete := oFWLayer:GetColPanel('TABFRETE', 'TOP')
		
		// Negociação
		oFWLayer:AddLine('BOTTON', 50, .F.) 
		oFWLayer:AddCollumn('NEGOC', 100, .T., 'BOTTON') // Negociação
		oLayerNeg := oFWLayer:GetColPanel('NEGOC', 'BOTTON')
		
	     
		/* -- Browse -------------------------------------------------- */
		oBrwTabFrete := FWMBrowse():New()
		oBrwTabFrete:SetOwner(oLayerTabFrete)
		oBrwTabFrete:SetDescription("Tabelas de Frete")
		oBrwTabFrete:SetAlias('GVA')
		oBrwTabFrete:SetFilterDefault("GVA_TPTAB == '1'")
		oBrwTabFrete:SetMenuDef("")
		oBrwTabFrete:AddButton("Copiar",{|| U_MGFGFE30(), oBrwTabFrete:UpdateBrowse(), oBrwNeg:UpdateBrowse() },,2,,.F.)
		oBrwTabFrete:SetProfileID("1")
		oBrwTabFrete:SetAmbiente(.F.)
		oBrwTabFrete:SetWalkthru(.F.)	
		oBrwTabFrete:DisableDetails()
		oBrwTabFrete:Refresh()

		oBrwNeg := FWMBrowse():New()
		oBrwNeg:SetOwner(oLayerNeg)
		oBrwNeg:SetDescription("Negociações")
		oBrwNeg:SetAlias('GV9')
		oBrwNeg:DisableDetails()
		aRotina :=oBrwNeg:SetMenuDef("MGFGFE2")
				
		oBrwNeg:ForceQuitButton(.T.)
		oBrwNeg:SetProfileID("2")
		oBrwNeg:SetAmbiente(.F.)
		oBrwNeg:SetWalkthru(.F.)
		
		oRelacGV9:= FWBrwRelation():New()
		oRelacGV9:AddRelation(oBrwTabFrete, oBrwNeg, {{'GV9_FILIAL', 'xFilial( "GV9" )'}, {'GV9_CDEMIT', 'GVA_CDEMIT'}, {'GV9_NRTAB', 'GVA_NRTAB'}})
		oRelacGV9:Activate()
				
		oBrwTabFrete:Activate()
		If oBrwTabFrete:lnobrowse 
			oBrwTabFrete:UpdateBrowse()
			oBrwTabFrete:Activate()
		EndIf
		
		oBrwNeg:Activate()
		
		oBrwNeg:DelColumn(1)
		oBrwNeg:DelColumn(2)
		oBrwNeg:DelColumn(3)
		oBrwNeg:DelColumn(4)
		oBrwNeg:UpdateBrowse()
		oBrwNeg:Refresh()
		oBrwTabFrete:UpdateBrowse()
		
	Activate MsDialog oDialog0mg Center
	
	GFEDelTab(cAliasGV9)
	GFEDelTab(cAliasGV1)
	GFEDelTab(cAliasGUC)
	
Return



/*-------------------------------------------------------------------                                                                           
{Protheus.doc} ModelDef
ModelDef

@author Rodrigo dos Santos
@since 20/12/2018
@version 1.0
-------------------------------------------------------------------*/
Static Function ModelDef()
	Local oStructGV9 := Nil
	Local oStructGV1 := Nil
	Local oStructGUC := Nil

	Private oModel   := Nil

	If IsInCallStack("U_MGFGFE2")

		oStructGV9 := GetStruct(1, 'GV9')
		oStructGV1 := GetStruct(1, "GV1")
		oStructGUC := GetStruct(1, "GUC")
		
		If !lCopyTabFrt
			oStructGV9:SetProperty("GV9_NNRNEG", MODEL_FIELD_OBRIGAT, .F.)
			oStructGV9:SetProperty("GV9_NDTVLI", MODEL_FIELD_OBRIGAT, .F.)
		EndIf
		
		oModel := MPFormModel():New("GV9001", /*bPre*/ , {|oModel| GFEA062POS(oModel)} , /* bCommit */{|oModel| GFEA062CMT(oModel)}, /*bCancel*/)
		oModel:AddFields("GFEA062_GV9", Nil, oStructGV9, /*bPre*/, /*bPost*/, /*bLoad*/)
		oModel:SetPrimaryKey({"GV9_CDEMIT", "GV9_NRTAB", "GV9_NRNEG"})
		oModel:SetDescription("Cópia e Reajuste da Tabela de Frete")
		
		oModel:AddGrid("GFEA062_GV1","GFEA062_GV9", oStructGV1, /* bLinePre */, /* nLinePost */ {|oModel| GV1Post(oModel)},/*bPre*/, /* {|oModel| GV1Post(oModel)} */, {|oGrid| LoadGridGV1(oGrid)})
		oModel:AddGrid("GFEA062_GUC","GFEA062_GV9", oStructGUC, /* bLinePre */, /* nLinePost */ {|oModel| GUCPost(oModel)},/*bPre*/, /*{|oModel| GUCPost(oModel, "#4")}*/, {|oGrid| LoadGridGUC(oGrid)})
		
		oModel:SetOptional("GFEA062_GV1", .T. )
		oModel:SetOptional("GFEA062_GUC", .T. )
		
		oModel:GetModel('GFEA062_GV1'):SetNoInsertLine( .T. ) 
		oModel:GetModel('GFEA062_GUC'):SetNoInsertLine( .T. )

	EndIf
 
Return oModel

/*-------------------------------------------------------------------                                                                           
{Protheus.doc} ViewDef
ViewDef

@author Rodrigo dos Santos
@since 12/01/2018
@version 1.0
-------------------------------------------------------------------*/
Static Function ViewDef()
	Local oModel     := FWLoadModel("MGFGFE2")
	Local oView      := Nil 
	Local oStructGV9  := GetStruct(2, "GV9")
	Local oStructGV1  := GetStruct(2, "GV1")
	Local oStructGUC  := GetStruct(2, "GUC")
	
	Static oBrwGV8, oBrwGV7
	
	oStructGV9:AddGroup("GrpTabela"	, "Tabela de Frete"		, "1", 2)
	oStructGV9:AddGroup("GrpNeg"   	, "Negociação"			, "1", 2)
	
	oStructGV9:SetProperty("GV9_CDEMIT", MVC_VIEW_GROUP_NUMBER, "GrpTabela")
	oStructGV9:SetProperty("GV9_NMEMIT", MVC_VIEW_GROUP_NUMBER, "GrpTabela")
	oStructGV9:SetProperty("GV9_NRTAB" , MVC_VIEW_GROUP_NUMBER, "GrpTabela")
	oStructGV9:SetProperty("GV9_NRNEG" , MVC_VIEW_GROUP_NUMBER, "GrpNeg")
	oStructGV9:SetProperty("GV9_CDCLFR", MVC_VIEW_GROUP_NUMBER, "GrpNeg")
	oStructGV9:SetProperty("GV9_CDTPOP", MVC_VIEW_GROUP_NUMBER, "GrpNeg")
	oStructGV9:SetProperty("GV9_TPLOTA", MVC_VIEW_GROUP_NUMBER, "GrpNeg")
	oStructGV9:SetProperty("GV9_DTVALI", MVC_VIEW_GROUP_NUMBER, "GrpNeg")
	oStructGV9:SetProperty("GV9_DTVALF", MVC_VIEW_GROUP_NUMBER, "GrpNeg")
	
	oStructGV9:SetProperty("GV9_TPLOTA", MVC_VIEW_INSERTLINE, .T.)
	
	If lCopyTabFrt
		oStructGV9:AddGroup("GrpNovaVig", "Nova Vigência", "1", 2)
		oStructGV9:SetProperty("GV9_NDTVLI", MVC_VIEW_GROUP_NUMBER, "GrpNovaVig")
		oStructGV9:SetProperty("GV9_NDTVLF", MVC_VIEW_GROUP_NUMBER, "GrpNovaVig")
		oStructGV9:SetProperty("GV9_NNRNEG", MVC_VIEW_GROUP_NUMBER, "GrpNovaVig")
		oStructGV9:SetProperty("GV9_NCLFR" , MVC_VIEW_GROUP_NUMBER, "GrpNovaVig")
		oStructGV9:SetProperty("GV9_NTPOP" , MVC_VIEW_GROUP_NUMBER, "GrpNovaVig")
		
		oStructGV9:SetProperty("GV9_NDTVLF", MVC_VIEW_INSERTLINE, .T.)
	Else
		oStructGV9:RemoveField("GV9_NDTVLI")
		oStructGV9:RemoveField("GV9_NDTVLF")
		oStructGV9:RemoveField("GV9_NNRNEG")
		oStructGV9:RemoveField("GV9_NCLFR")
		oStructGV9:RemoveField("GV9_NTPOP")
	EndIf
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("GFEA062_GV9", oStructGV9)
	oView:AddGrid("GFEA062_GV1" , oStructGV1)
	oView:AddGrid("GFEA062_GUC" , oStructGUC)

	oView:CreateHorizontalBox( "MASTER" , 40)
	oView:CreateHorizontalBox( "DETAIL" , 60)

	oView:CreateFolder("IDFOLDER","DETAIL")
	oView:AddSheet("IDFOLDER", "FOLDER_ROTAS" , "Rotas")
	oView:AddSheet("IDFOLDER", "FOLDER_FAIXAS", "Faixas")
	oView:AddSheet("IDFOLDER", "FOLDER_TARIFAS", "Componentes da Tarifas")
	oView:AddSheet("IDFOLDER", "FOLDER_ADDTARIFAS", "Componentes Adicionais da Tarifas")

	oView:CreateHorizontalBox( "DETAIL_GV8"  , 100,,,"IDFOLDER", "FOLDER_ROTAS" )
	oView:CreateHorizontalBox( "DETAIL_GV7"  , 100,,,"IDFOLDER", "FOLDER_FAIXAS" )
	oView:CreateHorizontalBox( "DETAIL_GV1"  , 100,,,"IDFOLDER", "FOLDER_TARIFAS" )
	oView:CreateHorizontalBox( "DETAIL_GUC"  , 100,,,"IDFOLDER", "FOLDER_ADDTARIFAS" )

	oView:SetOwnerView("GFEA062_GV9" , "MASTER")
	
	oView:AddOtherObejct("GFEA062_GV8", {|oPanel, oObj| U_GFEAGV8(oPanel, oObj)},,{|oPanel| oBrwGV8:Refresh()})
	oView:AddOtherObejct("GFEA062_GV7", {|oPanel, oObj| U_GFEAGV7(oPanel, oObj)},,{|oPanel| oBrwGV7:Refresh()})
	
	oView:SetOwnerView( "GFEA062_GV8" , "DETAIL_GV8" )
	oView:SetOwnerView( "GFEA062_GV7" , "DETAIL_GV7" )
	oView:SetOwnerView( "GFEA062_GV1" , "DETAIL_GV1" )
	oView:SetOwnerView( "GFEA062_GUC" , "DETAIL_GUC" )
	
	oView:addUserButton("Reajuste", "MAGIC_BMP", {|| ReajusteFiltro() }, "Realiza o reajuste com filtro e condições")
	
	oView:addUserButton("Reajuste Comp. Adicionais", "MAGIC_BMP", {|| ReajusteFiltro(2) }, "Realiza o reajuste com filtro e condições")
	
	oView:addUserButton("Preview de Reajuste", "MAGIC_BMP", {|| U_PreviewRe()}, "Tela de Preview dos Reajustes") 
Return oView

/*-------------------------------------------------------------------                                                                           
{Protheus.doc} GFEA062BRW
Cria os registros do Browse

@author Rodrigo dos Santos
@since 06/12/2018
@version 1.0
-------------------------------------------------------------------*/
Static Function MenuDef()
Local aRotina := {}

	// AAdd(aRotina, {/*Título*/,/*Rotina*/,/*Reservado*/,/*Tipo de Transação*/,/*Nível de Acesso*/,/*Habilita Menu Funcional*/})
	AAdd(aRotina, {"Reajustar", "U_GFEAREA()", 0, 2, 0, .F.})
	AAdd(aRotina, {"Copiar"   , "U_GFEACOP()", 0, 4, 0, .F.})

Return aRotina

/*-------------------------------------------------------------------
{Protheus.doc} GFEA062REA
Abre a tela de Reajuste

@author Rodrigo dos Santos
@since 12/12/2018
@version 1.0
-------------------------------------------------------------------*/
USER Function GFEAREA()
	Local cAprova := ""
	Local cSituacao := ""
	Private lCopyTabFrt := .F.
	
	U_GFEACRG()
	
	cAprova := SUPERGETMV("MV_APRTAB")
	cSituacao := GV9->GV9_SIT
	
	If cAprova = "1" .and. cSituacao = "2"
		Alert("Não é possível reajustar tabelas quando o controle de aprovação está ativo e a negociação está liberada. Primeiramente, é preciso realizar uma cópia da negociação para que seja possível reajustá-la.")
		return .F.
		oBrwNeg:Refresh()		
	EndIf
	
	FWExecView("REAJUSTE",'MGFGFE2', MODEL_OPERATION_UPDATE, , {|| .T. },{|| .T.},,,{|| .T.})
	oBrwNeg:Refresh()
Return


/*-------------------------------------------------------------------
{Protheus.doc} GFEA062COP
Abre a tela de Cópia

@author Rodrigo dos Santos
@since 12/12/2018
@version 1.0
-------------------------------------------------------------------*/
USER Function GFEACOP()
	Private lCopyTabFrt := .T.
	
	U_GFEACRG()
	
	FWExecView("CÓPIA",'MGFGFE2', MODEL_OPERATION_UPDATE, , {|| .T. },{|| .T.},,,{|| .T.})

	//Para atualizar a exibição com a cópia recém criada e para dar foco no grid de tabelas
	oBrwNeg:UpdateBrowse()
	oBrwNeg:Refresh()
	oBrwTabFrete:Refresh()	
	
	lCopyTabFrt := .F.
Return

/*-------------------------------------------------------------------
{Protheus.doc} GFEA062CRG
Preenche os campos da tabela temporária

@author Rodrigo dos Santos
@since 12/12/218
@version 1.0
-------------------------------------------------------------------*/
USER Function GFEACRG()

	// -- Cabeçalho Negociação --------------------------------------
	dbSelectArea((cAliasGV9))
	ZAP
	
	RecLock((cAliasGV9), .T.)
		(cAliasGV9)->GV9_CDEMIT := GV9->GV9_CDEMIT
		(cAliasGV9)->GV9_NMEMIT := POSICIONE("GU3",1,xFilial("GU3") + GV9->GV9_CDEMIT, "GU3_NMEMIT")
		(cAliasGV9)->GV9_NRTAB  := GV9->GV9_NRTAB
		(cAliasGV9)->GV9_NRNEG  := GV9->GV9_NRNEG
		(cAliasGV9)->GV9_CDCLFR := GV9->GV9_CDCLFR
		(cAliasGV9)->GV9_CDTPOP := GV9->GV9_CDTPOP
		(cAliasGV9)->GV9_NCLFR  := GV9->GV9_CDCLFR
		(cAliasGV9)->GV9_NTPOP  := GV9->GV9_CDTPOP
		(cAliasGV9)->GV9_DTVALF := GV9->GV9_DTVALF
		(cAliasGV9)->GV9_DTVALF := GV9->GV9_DTVALF
	MsUnLock((cAliasGV9))
	
	// -- Componentes -----------------------------------------------
	aComponentes := {}
	
	dbSelectArea("GUY")
	dbSetOrder(1)
	dbSeek(GV9->GV9_FILIAL + GV9->GV9_CDEMIT + GV9->GV9_NRTAB + GV9->GV9_NRNEG)
	While !GUY->(Eof())                        .AND. ;
		   GUY->GUY_FILIAL == GV9->GV9_FILIAL  .AND. ;
		   GUY->GUY_CDEMIT == GV9->GV9_CDEMIT  .AND. ;
		   GUY->GUY_NRTAB  == GV9->GV9_NRTAB   .AND. ;
		   GUY->GUY_NRNEG  == GV9->GV9_NRNEG
	
		aADD(aComponentes, GUY->GUY_CDCOMP)
		
		GUY->(dbSkip())
	EndDo
	
	// -- Componentes da Tarifa -------------------------------------
	aClientesCompAdicionais := {}
	
	dbSelectArea((cAliasGV1))
	ZAP
	
	nCountGV1 := 0
	
	dbSelectArea("GV1")
	dbSetOrder(1)
	dbSeek(xFilial("GV1") + GV9->GV9_CDEMIT + GV9->GV9_NRTAB + GV9->GV9_NRNEG)
	While !GV1->(Eof()) 					  .AND. ;
	       GV1->GV1_FILIAL == xFilial("GV1")  .AND. ;
	       GV1->GV1_CDEMIT == GV9->GV9_CDEMIT .AND. ;
	       GV1->GV1_NRTAB  == GV9->GV9_NRTAB  .AND. ;
	       GV1->GV1_NRNEG  == GV9->GV9_NRNEG
	       
		nCountGV1++

		RecLock((cAliasGV1), .T.)
			(cAliasGV1)->GV1_CDEMIT := GV9->GV9_CDEMIT
			(cAliasGV1)->GV1_NRTAB  := GV9->GV9_NRTAB
			(cAliasGV1)->GV1_NRNEG  := GV9->GV9_NRNEG
			(cAliasGV1)->GV1_CDFXTV := GV1->GV1_CDFXTV
			(cAliasGV1)->GV1_NRROTA := GV1->GV1_NRROTA
			(cAliasGV1)->GV1_CDCOMP := GV1->GV1_CDCOMP
			(cAliasGV1)->GV1_MODIFY := .F.
			(cAliasGV1)->GV1_INDNOR := 1.000000
			(cAliasGV1)->GV1_ADDNOR := 000000.00
			(cAliasGV1)->GV1_INDEXT := 1.000000
			(cAliasGV1)->GV1_ADDEXT := 000000.00
			(cAliasGV1)->GV1_INDMIN := 1.000000
			(cAliasGV1)->GV1_ADDMIN := 000000.00
		MsUnlock((cAliasGV1))
		
		GV1->(dbSkip())
	EndDo
	
	// -- Componentes Adicionais da Tarifa --------------------------
	dbSelectArea((cAliasGUC))
	ZAP
	
	nCountGUC := 0
	
	aADD(aClientesCompAdicionais, "(TODOS)")
	
	dbSelectArea("GUC")
	dbSetOrder(1)
	dbSeek(xFilial("GUC") + GV9->GV9_CDEMIT + GV9->GV9_NRTAB + GV9->GV9_NRNEG)
	While !GUC->(Eof()) 					  .AND. ;
	       GUC->GUC_FILIAL == xFilial("GUC")  .AND. ;
	       GUC->GUC_CDEMIT == GV9->GV9_CDEMIT .AND. ;
	       GUC->GUC_NRTAB  == GV9->GV9_NRTAB  .AND. ;
	       GUC->GUC_NRNEG  == GV9->GV9_NRNEG
	       
		nCountGUC++
		
		aADD(aClientesCompAdicionais, AllTrim(GUC->GUC_EMICOM) + " - " + POSICIONE("GU3", 1, xFilial("GU3") + GUC->GUC_EMICOM, "GU3_NMEMIT"))

		RecLock((cAliasGUC), .T.)
			(cAliasGUC)->GUC_CDEMIT := GV9->GV9_CDEMIT
			(cAliasGUC)->GUC_NRTAB  := GV9->GV9_NRTAB
			(cAliasGUC)->GUC_NRNEG  := GV9->GV9_NRNEG
			(cAliasGUC)->GUC_CDFXTV := GUC->GUC_CDFXTV
			(cAliasGUC)->GUC_NRROTA := GUC->GUC_NRROTA
			(cAliasGUC)->GUC_CDCOMP := GUC->GUC_CDCOMP
			(cAliasGUC)->GUC_EMICOM := GUC->GUC_EMICOM
			(cAliasGUC)->GUC_MODIFY := .F.
			(cAliasGUC)->GUC_INDNOR := 1.000000
			(cAliasGUC)->GUC_ADDNOR := 000000.00
			(cAliasGUC)->GUC_INDEXT := 1.000000
			(cAliasGUC)->GUC_ADDEXT := 000000.00
			(cAliasGUC)->GUC_INDMIN := 1.000000
			(cAliasGUC)->GUC_ADDMIN := 000000.00
		MsUnlock((cAliasGUC))
		
		GUC->(dbSkip())
	EndDo	
	
Return

/*-------------------------------------------------------------------                                                                           
{Protheus.doc} GFEAGV8
Criação do Browse de Rotas

@author Rodrigo dos Santos
@since 18/12/2018
@version 1.0
-------------------------------------------------------------------*/
 USER Function GFEAGV8(oPanel, oObj)
	Local nI
	Local oView := oObj:oControl
	Local oColumn
	
	aRotas := {}
	
	dbSelectArea("GV8")
	dbSetOrder(1)
	dbSeek(xFilial("GV8") + GV9->GV9_CDEMIT + GV9->GV9_NRTAB + GV9->GV9_NRNEG)
	While !GV8->(Eof()) 					  		.AND. ;
	       GV8->GV8_FILIAL == xFilial("GV8")  .AND. ;
	       GV8->GV8_CDEMIT == GV9->GV9_CDEMIT .AND. ;
	       GV8->GV8_NRTAB  == GV9->GV9_NRTAB  .AND. ;
	       GV8->GV8_NRNEG  == GV9->GV9_NRNEG
	       
	    // [1] Rota Atual, [2] Nova Rota
	    aAdd(aRotas, { GV8->GV8_NRROTA, "" })
		GV8->(dbSkip())
	EndDo
	
	oBrwGV8 := FWMarkBrowse():New()
	oBrwGV8:SetOwner(oPanel)
	oBrwGV8:SetDescription("Rotas")
	oBrwGV8:SetAlias('GV8')
	oBrwGV8:AddMarkColumns({|| GV8MkColBMark() }, {|| GV8MkColClick() }, {|| oBrwGV8:AllMark()})
	oBrwGV8:DisableDetails()
	oBrwGV8:SetMenuDef("")
	oBrwGV8:SetProfileID("2")
	oBrwGV8:SetAmbiente(.F.)
	oBrwGV8:SetWalkthru(.F.)
	oBrwGV8:DisableReport()
	oBrwGV8:DisableConfig()
	oBrwGV8:DisableFilter()
	oBrwGV8:DisableLocate()
	oBrwGV8:DisableSaveConfig()
	//oBrwGV8:DisableSeek()
	//oBrwGV8:oBrowse:SetFixedBrowse(.T.)
	oBrwGV8:SetFilterDefault("GV8_CDEMIT == '" + GV9->GV9_CDEMIT + "' .AND. GV8_NRTAB == '" + GV9->GV9_NRTAB + "' .AND. GV8_NRNEG == '" + GV9->GV9_NRNEG + "'")
	oBrwGV8:oBrowse:SetOnlyFields( { 'GV8_NRROTA', 'GV8_TPORIG', 'GV8_TPDEST', 'GV8_DUPSEN', 'GV8_PCDEV', 'GV8_PCREEN', 'GV8_VLMXRE'} )
	
	oBrwGV8:Activate()
	
	oColumn := FWBrwColumn():New()
	oColumn:SetTitle("Origem")
	oColumn:SetData({|| GV8Origem()})
	oColumn:SetType("C")
	oColumn:SetDecimal(0)
	oColumn:SetPicture("")
	oColumn:SetAlign(1)
	oColumn:SetSize(50)
	
	oBrwGV8:SetColumns({oColumn})
	
	oColumn := FWBrwColumn():New()
	oColumn:SetTitle("Destino")
	oColumn:SetData({|| GV8Destino()})
	oColumn:SetType("C")
	oColumn:SetDecimal(0)
	oColumn:SetPicture("")
	oColumn:SetAlign(1)
	oColumn:SetSize(50)
		
	oBrwGV8:SetColumns({oColumn})
	
	oBrwGV8:oBrowse:SetColumnOrder(Len(oBrwGV8:oBrowse:aColumns)-1, 4)
	oBrwGV8:oBrowse:SetColumnOrder(Len(oBrwGV8:oBrowse:aColumns), 6)
	
	If !lCopyTabFrt
		oBrwGV8:oBrowse:DelColumn(1)
	EndIf	
	
	oBrwGV8:oBrowse:UpdateBrowse()
	
Return

/*-------------------------------------------------------------------                                                                           
{Protheus.doc} GV8Origem
Retorna a descrição da rota de origem com base no tipo

@author Rodrigo dos Santos
@since 29/11/2018
@version 1.0
-------------------------------------------------------------------*/
Static Function GV8Origem()
	Local cRet := ""
	If GV8->GV8_TPORIG == "1"		// Cidade
		cRet := /* GV8->GV8_NRCIOR + " - " + */ POSICIONE("GU7",1,XFILIAL("GU7")+GV8->GV8_NRCIOR,"GU7_NMCID")
	ElseIF GV8->GV8_TPORIG == "2"	// Distância
		cRet := GV8->GV8_DSTORI
	ElseIF GV8->GV8_TPORIG == "3"	// Região
		cRet := /* GV8->GV8_NRREO + " - " + */ AllTrim(POSICIONE("GU9",1,XFILIAL("GU9")+GV8->GV8_NRREOR,"GU9_NMREG")) + " / " + POSICIONE("GU9",1,XFILIAL("GU9")+GV8->GV8_NRREOR,"GU9_CDUF")
	ElseIF GV8->GV8_TPORIG == "4"	// País/UF
		cRet := GV8->GV8_CDUFOR + " / " + POSICIONE("SYA",1,XFILIAL("SYA")+GV8->GV8_CDPAOR,"YA_DESCR")
	ElseIF GV8->GV8_TPORIG == "5"	// Remetente
		cRet := /* GV8->GV8_CDREM + " - " + */ POSICIONE("GU3",1,XFILIAL("GU3")+GV8->GV8_CDREM,"GU3_NMEMIT")
	EndIf
Return (cRet)


/*-------------------------------------------------------------------
{Protheus.doc} GV8Destino
Retorna a descrição da rota de destino com base no tipo

@author Rodrigo dos Santos
@since 12/12/2018
@version 1.0
-------------------------------------------------------------------*/
Static Function GV8Destino()
	Local cRet := ""
	If GV8->GV8_TPDEST == "1"		// Cidade
		cRet := /* GV8->GV8_NRCIOR + " - " + */ POSICIONE("GU7",1,XFILIAL("GU7")+GV8->GV8_NRCIDS,"GU7_NMCID")
	ElseIF GV8->GV8_TPDEST == "2"	// Distância
		cRet := GV8->GV8_DSTORF
	ElseIF GV8->GV8_TPDEST == "3"	// Região
		cRet := /* GV8->GV8_NRREO + " - " + */ AllTrim(POSICIONE("GU9",1,XFILIAL("GU9")+GV8->GV8_NRREDS,"GU9_NMREG")) + " / " + POSICIONE("GU9",1,XFILIAL("GU9")+GV8->GV8_NRREDS,"GU9_CDUF")
	ElseIF GV8->GV8_TPDEST == "4"	// País/UF
		cRet := GV8->GV8_CDUFDS + " / " + POSICIONE("SYA",1,XFILIAL("SYA")+GV8->GV8_CDPADS,"YA_DESCR")
	ElseIF GV8->GV8_TPDEST == "5"	// Remetente
		cRet := /* GV8->GV8_CDREM + " - " + */ POSICIONE("GU3",1,XFILIAL("GU3")+GV8->GV8_CDDEST,"GU3_NMEMIT")
	EndIf
Return (cRet)


/*-------------------------------------------------------------------                                                                           
{Protheus.doc} GV8MkColBMark
Regra para marcação dos registros de rotas

@author Rodrigo dos Santos
@since 13/12/20118
@version 1.0
-------------------------------------------------------------------*/
Static Function GV8MkColBMark()
	Local lRet := 'LBNO'
	
	If aScan(aRotas,{|x| x[1] == GV8->GV8_NRROTA  }) > 0
		lRet := 'LBOK'	
	EndIf
	
Return lRet

/*-------------------------------------------------------------------                                                                           
{Protheus.doc} 
Ação de duplo clique na coluna de marcação

@author Rodrigo dos Santos

-------------------------------------------------------------------*/
Static Function GV8MkColClick()
	Local lRet := .T.
	
	If aScan(aRotas,{|x| x[1] == GV8->GV8_NRROTA  }) == 0
		aAdd(aRotas, { GV8->GV8_NRROTA })
	Else
		aDel(aRotas,aScan(aRotas,{|x| x[1] == GV8->GV8_NRROTA }))
		aSize(aRotas, Len(aRotas) - 1)
	EndIf
	
Return lRet


/*-------------------------------------------------------------------                                                                           
{Protheus.doc} GFEAGV7
Criação do Browse de Faixas

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
USER Function GFEAGV7(oPanel, oObj)
	Local nI
	Local oView := oObj:oControl
	
	aFaixas := {}
	aColsFaixas := {}
	
	
	dbSelectArea("GV7")
	dbSetOrder(1) // GV7_FILIAL+GV7_CDEMIT+GV7_NRTAB+GV7_NRNEG+GV7_CDFXTV
	dbSeek(xFilial("GV7") + GV9->GV9_CDEMIT + GV9->GV9_NRTAB + GV9->GV9_NRNEG)
	While !GV7->(Eof()) 					  		.AND. ;
	       GV7->GV7_FILIAL == xFilial("GV7")  .AND. ;
	       GV7->GV7_CDEMIT == GV9->GV9_CDEMIT .AND. ;
	       GV7->GV7_NRTAB  == GV9->GV9_NRTAB  .AND. ;
	       GV7->GV7_NRNEG  == GV9->GV9_NRNEG
	       
		AAdd(aColsFaixas, Array(5))
		
		aColsFaixas[Len(aColsFaixas), 1] := "LBOK"
		aColsFaixas[Len(aColsFaixas), 2] := GV7->GV7_CDFXTV
		
		If !Empty(GV7->GV7_CDTPVC)
			aColsFaixas[Len(aColsFaixas), 3] := GV7->GV7_CDTPVC
		Else
			aColsFaixas[Len(aColsFaixas), 3] := AllTrim(Str(GV7->GV7_QTFXFI))
			aColsFaixas[Len(aColsFaixas), 4] := GV7->GV7_UNICAL
		EndIF
		
		aColsFaixas[Len(aColsFaixas), 5] := .F.	       
	       
	    // [1] Faixa Atual, [2] Nova Faixa
	    aAdd(aFaixas, { GV7->GV7_CDFXTV, "" })
		GV7->(dbSkip())
	EndDo
	
	oBrwGV7 := FWMarkBrowse():New()
	oBrwGV7:SetOwner(oPanel)
	oBrwGV7:SetDescription("Faixas")
	oBrwGV7:SetAlias('GV7')
	oBrwGV7:AddMarkColumns({|| GV7MkColBMark() }, {|| GV7MkColClick() }, {|| oBrwGV7:AllMark()})
	oBrwGV7:DisableDetails()
	oBrwGV7:SetMenuDef("")
	oBrwGV7:SetProfileID("3")
	oBrwGV7:SetAmbiente(.F.)
	oBrwGV7:SetWalkthru(.F.)
	oBrwGV7:DisableReport()
	oBrwGV7:DisableConfig()
	oBrwGV7:DisableFilter()
	oBrwGV7:DisableLocate()
	oBrwGV7:DisableSaveConfig()
	//oBrwGV7:DisableSeek()
	//oBrwGV7:oBrowse:SetFixedBrowse(.T.)
	oBrwGV7:SetFilterDefault("GV7_CDEMIT == '" + GV9->GV9_CDEMIT + "' .AND. GV7_NRTAB == '" + GV9->GV9_NRTAB + "' .AND. GV7_NRNEG == '" + GV9->GV9_NRNEG + "'")
	oBrwGV7:Activate()
	
	If !lCopyTabFrt
		oBrwGV7:oBrowse:DelColumn(1)
	EndIf
	oBrwGV7:oBrowse:DelColumn(2)
	oBrwGV7:oBrowse:DelColumn(3)
	oBrwGV7:oBrowse:DelColumn(4)
	oBrwGV7:oBrowse:DelColumn(5)
	oBrwGV7:oBrowse:DelColumn(6)
	
	oBrwGV7:oBrowse:UpdateBrowse()
	
Return



/*-------------------------------------------------------------------                                                                           
{Protheus.doc} 
Regra para marcação dos registros de Faixas

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function GV7MkColBMark()
	Local lRet := 'LBNO'
	
	If aScan(aFaixas,{|x| x[1] == GV7->GV7_CDFXTV  }) > 0
		lRet := 'LBOK'	
	EndIf
	
Return lRet

/*-------------------------------------------------------------------                                                                           
{Protheus.doc} 
Ação de duplo clique na coluna de marcação

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function GV7MkColClick()
	Local lRet := .T.
	
	If aScan(aFaixas,{|x| x[1] == GV7->GV7_CDFXTV  }) == 0
		aAdd(aFaixas, { GV7->GV7_CDFXTV })
	Else
		aDel(aFaixas,aScan(aFaixas,{|x| x[1] == GV7->GV7_CDFXTV }))
		aSize(aFaixas, Len(aFaixas) - 1)
	EndIf	

Return lRet


/*-------------------------------------------------------------------                                                                           
{Protheus.doc} 
Carrega o Grid de Componentes da Tarifa

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function LoadGridGV1(oGrid)
	Local aRet := {}
	
	aRet := FWLoadByAlias( oGrid, cAliasGV1 )
	
Return (aRet)


/*-------------------------------------------------------------------                                                                           
{Protheus.doc} 
Carrega o Grid de Componentes da Tarifa


@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function LoadGridGUC(oGrid)
	Local aRet := {}
	
	aRet := FWLoadByAlias( oGrid, cAliasGUC )
	
Return (aRet)


/*-------------------------------------------------------------------                                                                           
{Protheus.doc}
Ação ao alterar uma linha do Grid de Componentes da Tarifa

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function GV1Post(oModel)
	Local nLine := oModel:GetLine()
	
	dbSelectArea((cAliasGV1))
	dbSetOrder(1)
	If dbSeek(FwFldGet('GV1_CDFXTV',nLine) + FwFldGet('GV1_NRROTA',nLine) + FwFldGet('GV1_CDCOMP',nLine))
		RecLock((cAliasGV1), .F.)
			(cAliasGV1)->GV1_MODIFY := .T.
			(cAliasGV1)->GV1_INDNOR := FwFldGet('GV1_INDNOR',nLine)
			(cAliasGV1)->GV1_ADDNOR := FwFldGet('GV1_ADDNOR',nLine)
			(cAliasGV1)->GV1_INDEXT := FwFldGet('GV1_INDEXT',nLine)
			(cAliasGV1)->GV1_ADDEXT := FwFldGet('GV1_ADDEXT',nLine)
			(cAliasGV1)->GV1_INDMIN := FwFldGet('GV1_INDMIN',nLine)
			(cAliasGV1)->GV1_ADDMIN := FwFldGet('GV1_ADDMIN',nLine)
		MsUnlock()
	EndIf
Return .T.

/*-------------------------------------------------------------------                                                                           
{Protheus.doc} 
Ação ao alterar uma linha do Grid de Componentes da Tarifa
@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function GUCPost(oModel)
	Local nLine := oModel:GetLine()
	
	dbSelectArea((cAliasGUC))
	dbSetOrder(1)
	If dbSeek(FwFldGet('GUC_CDFXTV',nLine) + FwFldGet('GUC_NRROTA',nLine) + FwFldGet('GUC_CDCOMP',nLine) + FwFldGet('GUC_EMICOM',nLine))
		RecLock((cAliasGUC), .F.)
			(cAliasGUC)->GUC_MODIFY := .T.
			(cAliasGUC)->GUC_INDNOR := FwFldGet('GUC_INDNOR',nLine)
			(cAliasGUC)->GUC_ADDNOR := FwFldGet('GUC_ADDNOR',nLine)
			(cAliasGUC)->GUC_INDEXT := FwFldGet('GUC_INDEXT',nLine)
			(cAliasGUC)->GUC_ADDEXT := FwFldGet('GUC_ADDEXT',nLine)
			(cAliasGUC)->GUC_INDMIN := FwFldGet('GUC_INDMIN',nLine)
			(cAliasGUC)->GUC_ADDMIN := FwFldGet('GUC_ADDMIN',nLine)
		MsUnlock()
	EndIf
Return .T.

/*-------------------------------------------------------------------                                                                           
{Protheus.doc} GFEA062POS
Validação do Model

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function GFEA062POS(oModel)
	Local lRet := .T.
	
	If lCopyTabFrt
		dbSelectArea("GV9")
		dbSetOrder(1) // GV9_FILIAL + GV9_CDEMIT + GV9_NRTAB + GV9_NRNEG
		If dbSeek(xFilial("GV9") + FwFldGet('GV9_CDEMIT') + FwFldGet('GV9_NRTAB') + FwFldGet('GV9_NNRNEG'))
			Help( ,, 'Help' ,, "Já existe esta Negociação para esta tabela de frete. Digite um novo código.", 1, 0 )
			Return .F.
		EndIf
		dbSetOrder(2)
		If DbSeek(xFilial('GV9')+FwFldGet('GV9_CDEMIT')+FwFldGet('GV9_NRTAB')+FwFldGet('GV9_CDCLFR')+FwFldGet('GV9_CDTPOP')+DtoS(FwFldGet('GV9_DTVALI')))
			Help( ,, 'Help',, 'Não é possível incluir um novo registro com os mesmos atributos e data de vigência inicial de uma negociação já existente para a tabela de frete. Altere a data de vigência inicial da negociação.', 1, 0 ) 
			Return .F.
		EndIf
	EndIf
	
Return lRet

/*-------------------------------------------------------------------                                                                           
{Protheus.doc} GFEA062CMT
Realiza a cópia ou o commit
@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function GFEA062CMT(oModel)
	Local nI
	
	/* -- Copia --------------------------------------------------- */
	If lCopyTabFrt
		Processa({|| Copia() }, "Copiando negociação com nova vigência", "Aguarde...")
	Else
	/* -- Reajuste------------------------------------------------- */
		//GFERTBFR()
		Processa({|| Reajuste() }, "Reajustando negociação", "Aguarde...")
	EndIf
	
Return (.T.)


/*-------------------------------------------------------------------                                                                           
{Protheus.doc} Reajuste
Tela de Preview
@author Rodrigo dos Santos
-------------------------------------------------------------------*/

Static Function TelaPreview(aReaComp,aReaCompAdc)
	
	Static oDlg
	Local  aReaItens := aReaComp
	Local  aReaItAdc := aReaCompAdc
	
	Local 	oSize
	Local  aPos
			
	oSize := FWDefSize():New(.T.)
	oSize:AddObject( "ENCHOICE", 100, 60, .T., .T. ) // Adiciona enchoice
	oSize:SetWindowSize({000, 000, 470, 800})
	oSize:lLateral     := .F.  // Calculo vertical	
	oSize:Process() //executa os calculos
	
	DEFINE MSDIALOG oDlg TITLE "Tela de Preview do Reajuste" ;
							FROM oSize:aWindSize[1],oSize:aWindSize[2] ;
							TO oSize:aWindSize[3],oSize:aWindSize[4] ;
							COLORS 0, 16777215 PIXEL	
							
	//Array com as posições dinamicas se quiser alterar o tamnho da tela é so alterar o tamanho do SetWindowSize
	aPos := {oSize:GetDimension("ENCHOICE","LININI"),; 
            oSize:GetDimension("ENCHOICE","COLINI"),;
            oSize:GetDimension("ENCHOICE","XSIZE"),;
            oSize:GetDimension("ENCHOICE","YSIZE")}
	
	//if que verifica quais arrays estão vazios para poder criar a tela corretamente		
	If (!(Empty(aReaItens)) .AND. Empty(aReaItAdc))
		
		@ aPos[1], aPos[2] FOLDER oFolder1 SIZE aPos[3], aPos[4] OF oDlg ITEMS "Componentes da Tarifa" COLORS 0, 16777215 PIXEL	
		@ 005, 05 LISTBOX oWBrowse1 Fields HEADER "Seq Faixa","Rota","Componente","Vl. Fixo Nor","Vl. Fixo Nor Novo","% Normal","% Normal Novo","Vl. Unit Nor","Vl. Unit Nor Novo","Vl. Min Norm","Vl. Min Norm Novo","Vl. Fixo Ext","Vl. Fixo Ext Novo","% Extra","% Extra Novo","Vl. Unit Ext","Vl. Unit Ext Novo" SIZE aPos[3]-10, aPos[4]-25 OF oFolder1:aDialogs[1] PIXEL ColSizes 50,50
		oWBrowse1:SetArray(aReaItens)
		oWBrowse1:bLine := {||{;
									aReaItens[oWBrowse1:nAt, 1],;
									aReaItens[oWBrowse1:nAt, 2],;
									aReaItens[oWBrowse1:nAt, 3],;
									aReaItens[oWBrowse1:nAt, 4],;
									aReaItens[oWBrowse1:nAt, 5],;
									aReaItens[oWBrowse1:nAt, 6],;
									aReaItens[oWBrowse1:nAt, 7],;
									aReaItens[oWBrowse1:nAt, 8],;
									aReaItens[oWBrowse1:nAt, 9],;
									aReaItens[oWBrowse1:nAt,10],;
									aReaItens[oWBrowse1:nAt,11],;
									aReaItens[oWBrowse1:nAt,12],;
									aReaItens[oWBrowse1:nAt,13],;
									aReaItens[oWBrowse1:nAt,14],;
									aReaItens[oWBrowse1:nAt,15],;
									aReaItens[oWBrowse1:nAt,16],;
									aReaItens[oWBrowse1:nAt,17],;
								}}	
	
	Elseif (((Empty(aReaItens)) .AND. !(Empty(aReaItAdc))))
		
		@ aPos[1], aPos[2] FOLDER oFolder1 SIZE aPos[3], aPos[4] OF oDlg ITEMS "Componentes Adcionais da Tarifa" COLORS 0, 16777215 PIXEL
		@ 005, 05 LISTBOX oWBrowse2 Fields HEADER "Seq Faixa","Rota","Componente","Vl. Fixo Nor","Vl. Fixo Nor Novo","% Normal","% Normal Novo","Vl. Unit Nor","Vl. Unit Nor Novo","Vl. Min Norm","Vl. Min Norm Novo","Vl. Fixo Ext","Vl. Fixo Ext Novo","% Extra","% Extra Novo","Vl. Unit Ext","Vl. Unit Ext Novo" SIZE aPos[3]-10, aPos[4]-25 OF oFolder1:aDialogs[1] PIXEL ColSizes 50,50
		oWBrowse2:SetArray(aReaItAdc)
		oWBrowse2:bLine := {||{;
								aReaItAdc[oWBrowse2:nAt, 1],;
								aReaItAdc[oWBrowse2:nAt, 2],;
								aReaItAdc[oWBrowse2:nAt, 3],;
								aReaItAdc[oWBrowse2:nAt, 4],;
								aReaItAdc[oWBrowse2:nAt, 5],;
								aReaItAdc[oWBrowse2:nAt, 6],;
								aReaItAdc[oWBrowse2:nAt, 7],;
								aReaItAdc[oWBrowse2:nAt, 8],;
								aReaItAdc[oWBrowse2:nAt, 9],;
								aReaItAdc[oWBrowse2:nAt,10],;
								aReaItAdc[oWBrowse2:nAt,11],;
								aReaItAdc[oWBrowse2:nAt,12],;
								aReaItAdc[oWBrowse2:nAt,13],;
								aReaItAdc[oWBrowse2:nAt,14],;
								aReaItAdc[oWBrowse2:nAt,15],;
								aReaItAdc[oWBrowse2:nAt,16],;
								aReaItAdc[oWBrowse2:nAt,17],;
						 	}}
	
	else
		
		@ aPos[1], aPos[2] FOLDER oFolder1 SIZE aPos[3], aPos[4] OF oDlg ITEMS "Componentes da Tarifa","Componentes Adcionais da Tarifa" COLORS 0, 16777215 PIXEL
		@ 005, 05 LISTBOX oWBrowse1 Fields HEADER "Seq Faixa","Rota","Componente","Vl. Fixo Nor","Vl. Fixo Nor Novo","% Normal","% Normal Novo","Vl. Unit Nor","Vl. Unit Nor Novo","Vl. Min Norm","Vl. Min Norm Novo","Vl. Fixo Ext","Vl. Fixo Ext Novo","% Extra","% Extra Novo","Vl. Unit Ext","Vl. Unit Ext Novo" SIZE aPos[3]-10, aPos[4]-25 OF oFolder1:aDialogs[1] PIXEL ColSizes 50,50
		oWBrowse1:SetArray(aReaItens)
		oWBrowse1:bLine := {||{;
							 		aReaItens[oWBrowse1:nAt, 1],;
							 		aReaItens[oWBrowse1:nAt, 2],;
							 		aReaItens[oWBrowse1:nAt, 3],;
							 		aReaItens[oWBrowse1:nAt, 4],;
							 		aReaItens[oWBrowse1:nAt, 5],;
							 		aReaItens[oWBrowse1:nAt, 6],;
							 		aReaItens[oWBrowse1:nAt, 7],;
							 		aReaItens[oWBrowse1:nAt, 8],;
							 		aReaItens[oWBrowse1:nAt, 9],;
							 		aReaItens[oWBrowse1:nAt,10],;
							 		aReaItens[oWBrowse1:nAt,11],;
							 		aReaItens[oWBrowse1:nAt,12],;
									aReaItens[oWBrowse1:nAt,13],;
									aReaItens[oWBrowse1:nAt,14],;
									aReaItens[oWBrowse1:nAt,15],;
									aReaItens[oWBrowse1:nAt,16],;
									aReaItens[oWBrowse1:nAt,17],;
								}}
		
		@ 005, 05 LISTBOX oWBrowse2 Fields HEADER "Seq Faixa","Rota","Componente","Vl. Fixo Nor","Vl. Fixo Nor Novo","% Normal","% Normal Novo","Vl. Unit Nor","Vl. Unit Nor Novo","Vl. Min Norm","Vl. Min Norm Novo","Vl. Fixo Ext","Vl. Fixo Ext Novo","% Extra","% Extra Novo","Vl. Unit Ext","Vl. Unit Ext Novo" SIZE aPos[3]-10, aPos[4]-25 OF oFolder1:aDialogs[2] PIXEL ColSizes 50,50
		oWBrowse2:SetArray(aReaItAdc)
		oWBrowse2:bLine := {||{;
								aReaItAdc[oWBrowse2:nAt, 1],;
								aReaItAdc[oWBrowse2:nAt, 2],;
								aReaItAdc[oWBrowse2:nAt, 3],;
								aReaItAdc[oWBrowse2:nAt, 4],;
								aReaItAdc[oWBrowse2:nAt, 5],;
								aReaItAdc[oWBrowse2:nAt, 6],;
								aReaItAdc[oWBrowse2:nAt, 7],;
								aReaItAdc[oWBrowse2:nAt, 8],;
								aReaItAdc[oWBrowse2:nAt, 9],;
								aReaItAdc[oWBrowse2:nAt,10],;
								aReaItAdc[oWBrowse2:nAt,11],;
								aReaItAdc[oWBrowse2:nAt,12],;
								aReaItAdc[oWBrowse2:nAt,13],;
								aReaItAdc[oWBrowse2:nAt,14],;
								aReaItAdc[oWBrowse2:nAt,15],;
								aReaItAdc[oWBrowse2:nAt,16],;
								aReaItAdc[oWBrowse2:nAt,17],;
						 	}}
	
	EndIf
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||ODlg:End()}, {||ODlg:End()}) CENTERED
return

/*-------------------------------------------------------------------                                                                           
{Protheus.doc} Reajuste
Preview do Reajuste

@author Rodrigo dos Santos
-------------------------------------------------------------------*/

USER Function previewRe()
	//Variaveis dos componentes
	Local nVLFIXN  := 0
	Local nPCNORM  := 0
	Local nVLUNIN  := 0
	Local nVLMINN  := 0
	Local nVLFIXE  := 0
	Local nPCEXTR  := 0
	Local nVLUNIE  := 0
	//Variaveis que vão recer o valor do componentes transformado
	Local nVLFIXNT 
	Local nPCNORMT 
	Local nVLUNINT 
	Local nVLFIXET 
	Local nPCEXTRT 
	Local nVLUNIET 
	Local nVLMINNT
	Local nI 
	Local aSaveLines  := FWSaveRows()//salva a posição das linhas dos grids
	//Carrega o Model
	Local oModel      := FWModelActive()
	Local oModelGV1   := oModel:GetModel('GFEA062_GV1')
	Local oModelGUC   := oModel:GetModel('GFEA062_GUC') 
	//Arrays dos Componentes/Conponentes Adcionais
	Local aCompFAdc   := {}
	Local aCompFrete  := {}
	
	ProcRegua(nCountGV1 + nCountGUC)
	
	//Componentes
	For nI := 1 To oModelGV1:Length()
		oModelGV1:GoLine( nI )
		If nI == 1
 			aCompFrete := {}
 		endif
		If (oModelGV1:IsUpdated())
		 	oActiveView := FWViewActive()
			oGridView   := oActiveView:GetViewObj("GFEA062_GV1")[3]
			oGridModel  := oGridView:GetModel("GFEA062_GV1")
	
			GV1Post(oModelGV1)
			IncProc()
			dbSelectArea("GV1")
			dbSetOrder(1)
			If dbSeek(xFilial("GV1") + (cAliasGV1)->GV1_CDEMIT + (cAliasGV1)->GV1_NRTAB + (cAliasGV1)->GV1_NRNEG + (cAliasGV1)->GV1_CDFXTV + (cAliasGV1)->GV1_NRROTA + (cAliasGV1)->GV1_CDCOMP)
				// Normal
				nVLFIXN  := ValorReajuste(GV1->GV1_VLFIXN, (cAliasGV1)->GV1_INDNOR, (cAliasGV1)->GV1_ADDNOR)
				nVLFIXNT := Transf(nVLFIXN,"@E 999,999,999.99999")
				
				nPCNORM  := ValorReajuste(GV1->GV1_PCNORM, (cAliasGV1)->GV1_INDNOR, (cAliasGV1)->GV1_ADDNOR)
				nPCNORMT := Transf(nPCNORM,"@E 999,999,999.99999")
				
				nVLUNIN  := ValorReajuste(GV1->GV1_VLUNIN, (cAliasGV1)->GV1_INDNOR, (cAliasGV1)->GV1_ADDNOR)
				nVLUNINT := Transf(nVLUNIN,"@E 999,999,999.99999")
				
				// Extra
				nVLFIXE  := ValorReajuste(GV1->GV1_VLFIXE, (cAliasGV1)->GV1_INDEXT, (cAliasGV1)->GV1_ADDEXT)
				nVLFIXET := Transf(nVLFIXE,"@E 999,999,999.99999")
				
				nPCEXTR  := ValorReajuste(GV1->GV1_PCEXTR, (cAliasGV1)->GV1_INDEXT, (cAliasGV1)->GV1_ADDEXT)
				nPCEXTRT := Transf(nPCEXTR,"@E 999,999,999.99999")
				
				nVLUNIE  := ValorReajuste(GV1->GV1_VLUNIE, (cAliasGV1)->GV1_INDEXT, (cAliasGV1)->GV1_ADDEXT)
				nVLUNIET := Transf(nVLUNIE,"@E 999,999,999.99999")
				
				// Minimo
				nVLMINN  := ValorReajuste(GV1->GV1_VLMINN, (cAliasGV1)->GV1_INDMIN, (cAliasGV1)->GV1_ADDMIN)
				nVLMINNT := Transf(nVLMINN,"@E 999,999,999.99999")
				
				Aadd(aCompFrete,{GV1->GV1_CDFXTV,GV1->GV1_NRROTA,Transf(GV1->GV1_CDCOMP,"@!"),Transf(GV1->GV1_VLFIXN,"@E 999,999,999.99999"),nVLFIXNT,Transf(GV1->GV1_PCNORM,"@E 999,999,999.99999"),nPCNORMT,Transf(GV1->GV1_VLUNIN,"@E 999,999,999.99999"),nVLUNINT,Transf(GV1->GV1_VLMINN,"@E 999,999,999.99999"),nVLMINNT,Transf(GV1->GV1_VLFIXE,"@E 999,999,999.99999"),nVLFIXET,Transf(GV1->GV1_PCEXTR,"@E 999,999,999.99999"),nPCEXTRT,Transf(GV1->GV1_VLUNIE,"@E 999,999,999.99999"),nVLUNIET})
			EndIf
			(cAliasGV1)->(dbSkip())
		EndIF
	Next		
	
	//Componentes Adcionais		
	For nI := 1 To oModelGUC:Length() 
 		oModelGUC:GoLine( nI )
 		If nI == 1
 			aCompFAdc  := {}
 		endif
		If (oModelGUC:IsUpdated())						  
			oActiveView := FWViewActive()
			oGridView   := oActiveView:GetViewObj("GFEA062_GUC")[3]
			oGridModel  := oGridView:GetModel("GFEA062_GUC")
	
			GUCPost(oModelGUC)
			IncProc()
			dbSelectArea("GUC")
			dbSetOrder(1)
			If dbSeek(xFilial("GUC") + (cAliasGUC)->GUC_CDEMIT + (cAliasGUC)->GUC_NRTAB + (cAliasGUC)->GUC_NRNEG + (cAliasGUC)->GUC_CDFXTV + (cAliasGUC)->GUC_NRROTA + (cAliasGUC)->GUC_CDCOMP + (cAliasGUC)->GUC_EMICOM)
				// Normal
				nVLFIXN  := ValorReajuste(GUC->GUC_VLFIXN, (cAliasGUC)->GUC_INDNOR, (cAliasGUC)->GUC_ADDNOR)
				nVLFIXNT := Transf(nVLFIXN,"@E 999,999,999.99999")
				
				nPCNORM  := ValorReajuste(GUC->GUC_PCNORM, (cAliasGUC)->GUC_INDNOR, (cAliasGUC)->GUC_ADDNOR)
				nPCNORMT := Transf(nPCNORM,"@E 999,999,999.99999")
				
				nVLUNIN  := ValorReajuste(GUC->GUC_VLUNIN, (cAliasGUC)->GUC_INDNOR, (cAliasGUC)->GUC_ADDNOR)
				nVLUNINT := Transf(nVLUNIN,"@E 999,999,999.99999")
					
				// Extra
				nVLFIXE  := ValorReajuste(GUC->GUC_VLFIXE, (cAliasGUC)->GUC_INDEXT, (cAliasGUC)->GUC_ADDEXT)
				nVLFIXET := Transf(nVLFIXE,"@E 999,999,999.99999")
				
				nPCEXTR  := ValorReajuste(GUC->GUC_PCEXTR, (cAliasGUC)->GUC_INDEXT, (cAliasGUC)->GUC_ADDEXT)
				nPCEXTRT := Transf(nPCEXTR,"@E 999,999,999.99999")
					
				nVLUNIE  := ValorReajuste(GUC->GUC_VLUNIE, (cAliasGUC)->GUC_INDEXT, (cAliasGUC)->GUC_ADDEXT)
				nVLUNIET := Transf(nVLUNIE,"@E 999,999,999.99999")
					
				// Minimo
				nVLMINN  := ValorReajuste(GUC->GUC_VLMINN, (cAliasGUC)->GUC_INDMIN, (cAliasGUC)->GUC_ADDMIN)
				nVLMINNT := Transf(nVLMINN,"@E 999,999,999.99999")
				
				
				Aadd(aCompFAdc,{GUC->GUC_CDFXTV,GUC->GUC_NRROTA,Transf(GUC->GUC_CDCOMP,"@!"),Transf(GUC->GUC_VLFIXN,"@E 999,999,999.99999"),nVLFIXNT,Transf(GUC->GUC_PCNORM,"@E 999,999,999.99999"),nPCNORMT,Transf(GUC->GUC_VLUNIN,"@E 999,999,999.99999"),nVLUNINT,Transf(GUC->GUC_VLMINN,"@E 999,999,999.99999"),nVLMINNT,Transf(GUC->GUC_VLFIXE,"@E 999,999,999.99999"),nVLFIXET,Transf(GUC->GUC_PCEXTR,"@E 999,999,999.99999"),nPCEXTRT,Transf(GUC->GUC_VLUNIE,"@E 999,999,999.99999"),nVLUNIET})
			EndIf
			(cAliasGUC)->(dbSkip())
		EndIf	
	 next
 	FWRestRows( aSaveLines )
	
	If (Empty(aCompFrete) .AND. Empty(aCompFAdc))
		alert('As Abas Componentes de Frete e Componentes Adcionais de Frete não foram Alteradas/Reajustadas, reajuste pelo menos item para habilitar a visualização do Preview')
	Else
		TelaPreview(aCompFrete,aCompFAdc)
	Endif
	
	aCompFrete := {}
	aCompFAdc  := {}		
return

/*-------------------------------------------------------------------                                                                           
{Protheus.doc} Reajuste
Realiza o reajuste

@author Rodrigo dos Santos
-------------------------------------------------------------------*/

Static Function Reajuste()
	
	Local nVLFIXN
	Local nPCNORM
	Local nVLUNIN
	Local nVLMINN
	Local nVLFIXE
	Local nPCEXTR
	Local nVLUNIE
	Local cChvRea

	ProcRegua(nCountGV1 + nCountGUC)
	

	
	/* ------------------------------------------------------------------------- */
	/* -- C O M P O N E N T E S ------------------------------------------------ */
	/* ------------------------------------------------------------------------- */
		
	dbSelectArea((cAliasGV1))
	dbGoTop()
	While !(cAliasGV1)->(Eof())
		IncProc()
		
		If (cAliasGV1)->GV1_MODIFY
			dbSelectArea("GV1")
			dbSetOrder(1)
			If dbSeek(xFilial("GV1") + (cAliasGV1)->GV1_CDEMIT + (cAliasGV1)->GV1_NRTAB + (cAliasGV1)->GV1_NRNEG + (cAliasGV1)->GV1_CDFXTV + (cAliasGV1)->GV1_NRROTA + (cAliasGV1)->GV1_CDCOMP)
			
				If Empty(cChvRea)
					cChvRea := (cAliasGV1)->GV1_CDEMIT + (cAliasGV1)->GV1_NRTAB
				EndIf
				// Normal
				nVLFIXN := ValorReajuste(GV1->GV1_VLFIXN, (cAliasGV1)->GV1_INDNOR, (cAliasGV1)->GV1_ADDNOR)
				nPCNORM := ValorReajuste(GV1->GV1_PCNORM, (cAliasGV1)->GV1_INDNOR, (cAliasGV1)->GV1_ADDNOR)
				nVLUNIN := ValorReajuste(GV1->GV1_VLUNIN, (cAliasGV1)->GV1_INDNOR, (cAliasGV1)->GV1_ADDNOR)
				
				// Extra
				nVLFIXE := ValorReajuste(GV1->GV1_VLFIXE, (cAliasGV1)->GV1_INDEXT, (cAliasGV1)->GV1_ADDEXT)
				nPCEXTR := ValorReajuste(GV1->GV1_PCEXTR, (cAliasGV1)->GV1_INDEXT, (cAliasGV1)->GV1_ADDEXT)
				nVLUNIE := ValorReajuste(GV1->GV1_VLUNIE, (cAliasGV1)->GV1_INDEXT, (cAliasGV1)->GV1_ADDEXT)
				
				// Minimo
				nVLMINN := ValorReajuste(GV1->GV1_VLMINN, (cAliasGV1)->GV1_INDMIN, (cAliasGV1)->GV1_ADDMIN)

				// Efetiva o Reajuste
				RecLock("GV1", .F.)
					EfetivaReajuste("GV1->GV1_VLFIXN", nVLFIXN)
					EfetivaReajuste("GV1->GV1_PCNORM", nPCNORM)
					EfetivaReajuste("GV1->GV1_VLUNIN", nVLUNIN)
					EfetivaReajuste("GV1->GV1_VLMINN", nVLMINN)
					EfetivaReajuste("GV1->GV1_VLFIXE", nVLFIXE)
					EfetivaReajuste("GV1->GV1_PCEXTR", nPCEXTR)
					EfetivaReajuste("GV1->GV1_VLUNIE", nVLUNIE)
				MsUnlock()
			EndIf
		EndIf
		(cAliasGV1)->(dbSkip())
	EndDo		
	/* ------------------------------------------------------------------------- */
	/* -- C O M P O N E N T E S   A D I C I O N A I S -------------------------- */
	/* ------------------------------------------------------------------------- */
	dbSelectArea((cAliasGUC))
	dbGoTop()
	While !(cAliasGUC)->(Eof())
		IncProc()
		
		If (cAliasGUC)->GUC_MODIFY
			dbSelectArea("GUC")
			dbSetOrder(1)
			If dbSeek(xFilial("GUC") + (cAliasGUC)->GUC_CDEMIT + (cAliasGUC)->GUC_NRTAB + (cAliasGUC)->GUC_NRNEG + (cAliasGUC)->GUC_CDFXTV + (cAliasGUC)->GUC_NRROTA + (cAliasGUC)->GUC_CDCOMP + (cAliasGUC)->GUC_EMICOM)
				
				If Empty(cChvRea)
					cChvRea := (cAliasGV1)->GV1_CDEMIT + (cAliasGV1)->GV1_NRTAB
				EndIf
			
				// Normal
				nVLFIXN := ValorReajuste(GUC->GUC_VLFIXN, (cAliasGUC)->GUC_INDNOR, (cAliasGUC)->GUC_ADDNOR)
				nPCNORM := ValorReajuste(GUC->GUC_PCNORM, (cAliasGUC)->GUC_INDNOR, (cAliasGUC)->GUC_ADDNOR)
				nVLUNIN := ValorReajuste(GUC->GUC_VLUNIN, (cAliasGUC)->GUC_INDNOR, (cAliasGUC)->GUC_ADDNOR)
				
				// Extra
				nVLFIXE := ValorReajuste(GUC->GUC_VLFIXE, (cAliasGUC)->GUC_INDEXT, (cAliasGUC)->GUC_ADDEXT)
				nPCEXTR := ValorReajuste(GUC->GUC_PCEXTR, (cAliasGUC)->GUC_INDEXT, (cAliasGUC)->GUC_ADDEXT)
				nVLUNIE := ValorReajuste(GUC->GUC_VLUNIE, (cAliasGUC)->GUC_INDEXT, (cAliasGUC)->GUC_ADDEXT)
				
				// Minimo
				nVLMINN := ValorReajuste(GUC->GUC_VLMINN, (cAliasGUC)->GUC_INDMIN, (cAliasGUC)->GUC_ADDMIN)
				
				// Efetiva o Reajuste
				RecLock("GUC", .F.)
					EfetivaReajuste("GUC->GUC_VLFIXN", nVLFIXN)
					EfetivaReajuste("GUC->GUC_PCNORM", nPCNORM)
					EfetivaReajuste("GUC->GUC_VLUNIN", nVLUNIN)
					EfetivaReajuste("GUC->GUC_VLMINN", nVLMINN)
					EfetivaReajuste("GUC->GUC_VLFIXE", nVLFIXE)
					EfetivaReajuste("GUC->GUC_PCEXTR", nPCEXTR)
					EfetivaReajuste("GUC->GUC_VLUNIE", nVLUNIE)
				MsUnlock()
			EndIf
		EndIf
		(cAliasGUC)->(dbSkip())
	EndDo

	If !Empty(cChvRea)
		GFE61ATDP(cChvRea)
	EndIf
	
Return

/*-------------------------------------------------------------------                                                                           
{Protheus.doc} Copia
Realiza a copia

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function Copia()
	Local nI, nJ
	Local nCountRotas, nCountFaixas
	Local cCountRotas, cCountFaixas
	Local cCdTransp 	:= FwFldGet('GV9_CDEMIT')
	Local cNrTab    	:= FwFldGet('GV9_NRTAB')
	Local cNrNeg    	:= FwFldGet('GV9_NRNEG')
	Local nNovaNeg  	:= FwFldGet('GV9_NNRNEG')
	Local nNovaClFr  	:= FwFldGet('GV9_NCLFR')
	Local nNovoTpOper	:= FwFldGet('GV9_NTPOP')
	Local aAreaCopy
	Local nVLFIXN
	Local nPCNORM
	Local nVLUNIN
	Local nVLMINN
	Local nVLFIXE
	Local nPCEXTR
	Local nVLUNIE
	
	ProcRegua(0)
	
	dbSelectArea("GV9")
	dbSetOrder(1)
	If dbSeek(xFilial("GV9") + cCdTransp + cNrTab + cNrNeg)
		IncProc()
	
		// -- Copia da Negociação -----------------------------------
		CopyReg("GV9")
			GV9->GV9_FILIAL := xFilial("GV9")
			GV9->GV9_NRNEG  := nNovaNeg
			GV9->GV9_CDCLFR := nNovaClFr
			GV9->GV9_CDTPOP := nNovoTpOper
			GV9->GV9_DTCRIA := DDATABASE
			GV9->GV9_HRCRIA := SubStr(TIME(), 1, 5)
			GV9->GV9_USUCRI := cUserName
			GV9->GV9_ENVAPR := "2"
			GV9->GV9_DTAPR  := Stod("  /  /  ")
			GV9->GV9_HRAPR  := ""
			GV9->GV9_USUAPR := ""
			GV9->GV9_MTVRPR := ""
			GV9->GV9_SIT	:= "1"
			GV9->GV9_DTVALI := FwFldGet('GV9_NDTVLI')
			GV9->GV9_DTVALF := FwFldGet('GV9_NDTVLF')
			If GV9->(FieldPos("GV9_CODCOT")) > 0
				GV9->GV9_CODCOT := ""
				GV9->GV9_SEQCOT := ""
			EndIf
			If GV9->(FieldPos("GV9_SITMLA")) > 0
				GV9->GV9_SITMLA := "1"
				GV9->GV9_MOTMLA := ""
			EndIf
		MsUnlock("GV9")
		GFE61ATDP(GV9->GV9_CDEMIT + GV9->GV9_NRTAB)
		IncProc()
		
		// -- Copia dos Componentes ---------------------------------
		dbSelectArea("GUY")
		dbSetOrder(1)
		dbSeek(xFilial("GUY") + cCdTransp + cNrTab + cNrNeg)	
		While !GUY->(Eof()) .AND. ;
		       GUY->GUY_FILIAL == xFilial("GUY") .AND. ;
		       GUY->GUY_CDEMIT == cCdTransp  	 .AND. ;
		       GUY->GUY_NRTAB  == cNrTab 		 .AND. ;
		       GUY->GUY_NRNEG  == cNrNeg
			
			aAreaCopy := GUY->(GetArea())						       
		       
			CopyReg("GUY")
			dbSelectArea("GUY")
			GUY->GUY_FILIAL := xFilial("GUY")
			GUY->GUY_NRNEG  := nNovaNeg						       
		    MsUnlock("GUY")
		    
		    RestArea(aAreaCopy)
			GUY->(dbSkip())
		EndDo
		
		IncProc()
		
		// -- Faixa de Entrega --------------------------------------
		dbSelectArea("GUZ")
		dbSetOrder(1)
		dbSeek(xFilial("GUZ") + cCdTransp + cNrTab + cNrNeg)	
		While !GUZ->(Eof()) .AND. ;
		       GUZ->GUZ_FILIAL == xFilial("GUZ") .AND. ;
		       GUZ->GUZ_CDEMIT == cCdTransp  	 .AND. ;
		       GUZ->GUZ_NRTAB  == cNrTab 		 .AND. ;
		       GUZ->GUZ_NRNEG  == cNrNeg
		       
			aAreaCopy := GUZ->(GetArea())						       
		       
			CopyReg("GUZ")
				dbSelectArea("GUZ")
				GUZ->GUZ_FILIAL := xFilial("GUZ")
				GUZ->GUZ_NRNEG  := nNovaNeg						       
		    MsUnlock("GUZ")
		    
		    RestArea(aAreaCopy)
			GUZ->(dbSkip())
		EndDo
		
		// -- Copia das Rotas ---------------------------------------
		nCountRotas := 0
		For nI := 1 To Len(aRotas)
			IncProc()
			
			nCountRotas++
			cCountRotas := PadL(AllTrim(Str(nCountRotas)), 4, "0")
			
			// Novo número de Rota
			aRotas[nI][2] := cCountRotas
			
			dbSelectArea("GV8")
			dbSetOrder(1)
			If dbSeek(xFilial("GV8") + cCdTransp + cNrTab + cNrNeg + aRotas[nI][1])
				CopyReg("GV8")
					GV8->GV8_FILIAL := xFilial("GV8")
					GV8->GV8_NRNEG  := nNovaNeg
					GV8->GV8_NRROTA := cCountRotas
				MsUnlock("GV8")
			EndIf
		Next nI

		// -- Copia das Faixas --------------------------------------
		nCountFaixas := 0
		For nJ := 1 To Len(aFaixas)
			IncProc()
			
			nCountFaixas++
			cCountFaixas := PadL(AllTrim(Str(nCountFaixas)), 4, "0")
			
			// Novo número da Faixa
			aFaixas[nJ][2] := cCountFaixas
						
			dbSelectArea("GV7")
			dbSetOrder(1)
			If dbSeek(xFilial("GV7") + cCdTransp + cNrTab + cNrNeg + aFaixas[nJ][1])
				CopyReg("GV7")
					GV7->GV7_FILIAL := xFilial("GV7")
					GV7->GV7_NRNEG  := nNovaNeg
					GV7->GV7_CDFXTV := cCountFaixas
				MsUnlock("GV7")
			EndIf
		Next nJ
		
		// -- Copia das Tarifas -------------------------------------
		For nI := 1 To Len(aRotas)
			For nJ := 1 To Len(aFaixas)
				IncProc()
				
				// -- Tarifas -------------------------------------
				dbSelectArea("GV6")
				dbSetOrder(1)
				dbSeek(xFilial("GV6") + cCdTransp + cNrTab + cNrNeg + aFaixas[nJ][1] + aRotas[nI][1])
				While !GV6->(Eof()) .AND. ;
				       GV6->GV6_FILIAL == xFilial("GV6") .AND. ;
				       GV6->GV6_CDEMIT == cCdTransp  	 .AND. ;
				       GV6->GV6_NRTAB  == cNrTab 		 .AND. ;
				       GV6->GV6_NRNEG  == cNrNeg		 .AND. ;
				       GV6->GV6_CDFXTV == aFaixas[nJ][1] 	 .AND. ;
				       GV6->GV6_NRROTA == aRotas[nI][1]
				       
					aAreaCopy := GV6->(GetArea())	
						CopyReg("GV6")
							GV6->GV6_FILIAL := xFilial("GV6")
							GV6->GV6_NRNEG  := nNovaNeg
							GV6->GV6_CDFXTV := aFaixas[nJ][2]
							GV6->GV6_NRROTA := aRotas[nI][2]
						MsUnlock("GV6")
				    RestArea(aAreaCopy)
				    
					GV6->(dbSkip())
				EndDo
				
				// -- Componentes da Tarifas ----------------------
				dbSelectArea("GV1")
				dbSetOrder(1)
				dbSeek(xFilial("GV1") + cCdTransp + cNrTab + cNrNeg + aFaixas[nJ][1] + aRotas[nI][1])
				While !GV1->(Eof())                      .AND. ;
				       GV1->GV1_FILIAL == xFilial("GV1") .AND. ;
				       GV1->GV1_CDEMIT == cCdTransp      .AND. ;
				       GV1->GV1_NRTAB  == cNrTab         .AND. ;
				       GV1->GV1_NRNEG  == cNrNeg         .AND. ;
				       GV1->GV1_CDFXTV == aFaixas[nJ][1] .AND. ;
				       GV1->GV1_NRROTA == aRotas[nI][1]

					dbSelectArea((cAliasGV1))
					dbSetOrder(1)
					dbSeek(GV1->GV1_CDFXTV + GV1->GV1_NRROTA + GV1->GV1_CDCOMP)

					// Normal
					nVLFIXN := ValorReajuste(GV1->GV1_VLFIXN, (cAliasGV1)->GV1_INDNOR, (cAliasGV1)->GV1_ADDNOR, .T.)
					nPCNORM := ValorReajuste(GV1->GV1_PCNORM, (cAliasGV1)->GV1_INDNOR, (cAliasGV1)->GV1_ADDNOR, .T.)
					nVLUNIN := ValorReajuste(GV1->GV1_VLUNIN, (cAliasGV1)->GV1_INDNOR, (cAliasGV1)->GV1_ADDNOR, .T.)

					// Extra
					nVLFIXE := ValorReajuste(GV1->GV1_VLFIXE, (cAliasGV1)->GV1_INDEXT, (cAliasGV1)->GV1_ADDEXT, .T.)
					nPCEXTR := ValorReajuste(GV1->GV1_PCEXTR, (cAliasGV1)->GV1_INDEXT, (cAliasGV1)->GV1_ADDEXT, .T.)
					nVLUNIE := ValorReajuste(GV1->GV1_VLUNIE, (cAliasGV1)->GV1_INDEXT, (cAliasGV1)->GV1_ADDEXT, .T.)

					// Minimo
					nVLMINN := ValorReajuste(GV1->GV1_VLMINN, (cAliasGV1)->GV1_INDMIN, (cAliasGV1)->GV1_ADDMIN, .T.)

					aAreaCopy := GV1->(GetArea())
						CopyReg("GV1")
							GV1->GV1_FILIAL := xFilial("GV1")
							GV1->GV1_NRNEG  := nNovaNeg
							GV1->GV1_CDFXTV := aFaixas[nJ][2]
							GV1->GV1_NRROTA := aRotas[nI][2]
							GV1->GV1_VLFIXN := nVLFIXN
							GV1->GV1_PCNORM := nPCNORM
							GV1->GV1_VLUNIN := nVLUNIN
							GV1->GV1_VLMINN := nVLMINN
							GV1->GV1_VLFIXE := nVLFIXE
							GV1->GV1_PCEXTR := nPCEXTR
							GV1->GV1_VLUNIE := nVLUNIE
						MsUnlock("GV1")
					 RestArea(aAreaCopy)

					GV1->(dbSkip())
				EndDo
				
				// -- Componentes Adicionais da Tarifas -----------
				dbSelectArea("GUC")
				dbSetOrder(1)
				dbSeek(xFilial("GUC") + cCdTransp + cNrTab + cNrNeg + aFaixas[nJ][1] + aRotas[nI][1])
				While !GUC->(Eof())                       .AND. ;
				       GUC->GUC_FILIAL == xFilial("GUC")  .AND. ;
				       GUC->GUC_CDEMIT == cCdTransp       .AND. ;
				       GUC->GUC_NRTAB  == cNrTab          .AND. ;
				       GUC->GUC_NRNEG  == cNrNeg          .AND. ;
				       GUC->GUC_CDFXTV == aFaixas[nJ][1]  .AND. ;
				       GUC->GUC_NRROTA == aRotas[nI][1]

					dbSelectArea((cAliasGV1))
					dbSetOrder(1)
					dbSeek(GV1->GV1_CDFXTV + GV1->GV1_NRROTA + GV1->GV1_CDCOMP)

					// Normal
					nVLFIXN := ValorReajuste(GUC->GUC_VLFIXN, (cAliasGUC)->GUC_INDNOR, (cAliasGUC)->GUC_ADDNOR, .T.)
					nPCNORM := ValorReajuste(GUC->GUC_PCNORM, (cAliasGUC)->GUC_INDNOR, (cAliasGUC)->GUC_ADDNOR, .T.)
					nVLUNIN := ValorReajuste(GUC->GUC_VLUNIN, (cAliasGUC)->GUC_INDNOR, (cAliasGUC)->GUC_ADDNOR, .T.)

					// Extra
					nVLFIXE := ValorReajuste(GUC->GUC_VLFIXE, (cAliasGUC)->GUC_INDEXT, (cAliasGUC)->GUC_ADDEXT, .T.)
					nPCEXTR := ValorReajuste(GUC->GUC_PCEXTR, (cAliasGUC)->GUC_INDEXT, (cAliasGUC)->GUC_ADDEXT, .T.)
					nVLUNIE := ValorReajuste(GUC->GUC_VLUNIE, (cAliasGUC)->GUC_INDEXT, (cAliasGUC)->GUC_ADDEXT, .T.)

					// Minimo
					nVLMINN := ValorReajuste(GUC->GUC_VLMINN, (cAliasGUC)->GUC_INDMIN, (cAliasGUC)->GUC_ADDMIN, .T.)

					aAreaCopy := GUC->(GetArea())
						CopyReg("GUC")
							GUC->GUC_FILIAL := xFilial("GUC")
							GUC->GUC_NRNEG  := nNovaNeg
							GUC->GUC_CDFXTV := aFaixas[nJ][2]
							GUC->GUC_NRROTA := aRotas[nI][2]

							GUC->GUC_VLFIXN := nVLFIXN
							GUC->GUC_PCNORM := nPCNORM
							GUC->GUC_VLUNIN := nVLUNIN
							GUC->GUC_VLMINN := nVLMINN
							GUC->GUC_VLFIXE := nVLFIXE
							GUC->GUC_PCEXTR := nPCEXTR
							GUC->GUC_VLUNIE := nVLUNIE
						MsUnlock("GUC")
					 RestArea(aAreaCopy)

					GUC->(dbSkip())
				EndDo
				
			Next nJ
		Next nI
	EndIf
	
Return


/*-------------------------------------------------------------------                                                                           
{Protheus.doc} EfetivaReajuste
Efetiva o reajuste do valor de acordo com o índice e o adicional

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function EfetivaReajuste(cCampo, nNovoValor)
	Private nValor := nNovoValor
	
	If nValor == 0
		Return
	EndIf
	
	&(cCampo + " := nValor")
Return


/*-------------------------------------------------------------------                                                                           
{Protheus.doc} ValorReajuste
Retorna o reajuste do valor de acordo com o índice e o adicional

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function ValorReajuste(nValor, nIndice, nAdicional, lCopia)
	Local nRet := 0
	Default lCopia := .F.
	
	If nIndice == 1 .AND. nAdicional == 0
		If lCopia
			Return nValor
		Else
			Return 0
		EndIf
	EndIf
	
	If nValor <> 0
		nRet := (nValor * nIndice) + nAdicional
		
		If nRet < 0
			nRet := 0
		EndIf
		
		nRet := Round(nRet,5)
	EndIf		
Return nRet    




/*-------------------------------------------------------------------                                                                           
{Protheus.doc} ReajusteFiltro
Wizard de reajuste dos Componentes da Tarifa usando filtro e condições

@param nTipo
	1: Componentes da Tarifa
	2: Componentes Adicionais da Tarifa

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function ReajusteFiltro(nTipo)
	Local oFolder1
	Local oPanel2
	Local oGroup1
	Local oGroup2
	Local oGroup3
	Local oGroup4
	Local oGroup5
	Local oGroup6
	
	Local aHeadFaixas := DefTabFaixas()
	
	Default nTipo := 1
	
	Private oDlgReajuste
	
	// -- Componente ----------------------------------
	Private nComboCompo
	Private nComboCliente
	
	// -- Reajuste ------------------------------------
	Private nIndNormal := 1
	Private nAddNormal := 0
	Private nIndExtra  := 1
	Private nAddExtra  := 0
	Private nIndMinimo := 1
	Private nAddMinimo := 0	
	
	// -- Filtro --------------------------------------
	Private cOrigUF 	 	:= Space(2)
	Private cOrigCidade  := Space(TamSX3("GU7_NRCID")[1])
	Private cOrigRegiao  := Space(TamSX3("GU9_NRREG")[1])
	Private cOrigCidDesc := Space(50)
	Private cOrigRegDesc := Space(50)
	Private oOrigCidDesc
	Private oOrigRegDesc
	
	Private cDestUF 	 	:= Space(2)
	Private cDestCidade  := Space(TamSX3("GU7_NRCID")[1])
	Private cDestRegiao  := Space(TamSX3("GU9_NRREG")[1])
	Private cDestCidDesc := Space(50)
	Private cDestRegDesc := Space(50)
	Private oDestCidDesc
	Private oDestRegDesc
	
	// -- Faixas --------------------------------------
	Private oGetFaixas
	
	Private lChkTpDest 	:= .T.
	Private lChkTpOrig 	:= .T.
	
	oSize := FWDefSize():New(.T.)
	oSize:AddObject( "ENCHOICE", 100, 60, .T., .T. ) // Adiciona enchoice
	oSize:SetWindowSize({000, 000, 370, 500})
	oSize:lLateral     := .F.  // Calculo vertical	
	oSize:Process() //executa os calculos
	
	
		DEFINE MSDIALOG oDlgReajuste TITLE "Aplicar reajuste com filtro" ;
							FROM oSize:aWindSize[1],oSize:aWindSize[2] ;
							TO oSize:aWindSize[3],oSize:aWindSize[4] ;
							COLORS 0, 16777215 PIXEL	
	    @ 000, 000 MSPANEL oPanel2 SIZE 250, 137 OF oDlgReajuste COLORS 0, 16777215 RAISED
	    @ 000, 000 FOLDER oFolder1 SIZE 249, 136 OF oPanel2 ITEMS "Reajuste","Filtro","Filtro por Faixas" COLORS 0, 16777215 PIXEL
	    
	    // -- Componente ----------------------------------
	    @ 002, 003 GROUP oGroup4 TO 026, 241 PROMPT If(nTipo == 1, "Componente", "Componente e Cliente") OF oFolder1:aDialogs[1] COLOR 0, 16777215 PIXEL
	    @ 010, 009 MSCOMBOBOX oComboBo1 VAR nComboCompo ITEMS aComponentes SIZE 100, 010 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
	    
	    If nTipo == 2
		    @ 010, 115 MSCOMBOBOX oComboBo1 VAR nComboCliente ITEMS aClientesCompAdicionais SIZE 115, 010 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
	    EndIf
	    
	    // -- Reajuste ------------------------------------
	    @ 033, 004 GROUP oGroup3 TO 058, 240 PROMPT "Normal" OF oFolder1:aDialogs[1] COLOR 0, 16777215 PIXEL
	    @ 043, 012 SAY oSay2 PROMPT "Índice:"      SIZE 023, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
	    @ 043, 131 SAY oSay3 PROMPT "Adicional:"   SIZE 028, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
	    @ 042, 040 MSGET oIndNormal VAR nIndNormal SIZE 050, 010 OF oFolder1:aDialogs[1] PICTURE "@E 9.999999"    COLORS 0, 16777215 HASBUTTON PIXEL
	    @ 041, 162 MSGET oAddNormal VAR nAddNormal SIZE 050, 010 OF oFolder1:aDialogs[1] PICTURE "@E 999,999.99" COLORS 0, 16777215 HASBUTTON PIXEL

	    @ 063, 004 GROUP oGroup5 TO 088, 240 PROMPT "Extra" OF oFolder1:aDialogs[1] COLOR 0, 16777215 PIXEL
	    @ 073, 012 SAY oSay4 PROMPT "Índice:"    SIZE 025, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
	    @ 073, 131 SAY oSay5 PROMPT "Adicional:" SIZE 029, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
	    @ 071, 040 MSGET oIndExtra VAR nIndExtra SIZE 050, 010 OF oFolder1:aDialogs[1] PICTURE "@E 9.999999"    COLORS 0, 16777215 HASBUTTON PIXEL
	    @ 071, 162 MSGET oAddExtra VAR nAddExtra SIZE 050, 010 OF oFolder1:aDialogs[1] PICTURE "@E 999,999.99" COLORS 0, 16777215 HASBUTTON PIXEL
	    
	    @ 092, 004 GROUP oGroup6 TO 117, 241 PROMPT "Mínimo" OF oFolder1:aDialogs[1] COLOR 0, 16777215 PIXEL	    
	    @ 102, 012 SAY oSay6 PROMPT "Índice:"      SIZE 026, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
	    @ 102, 131 SAY oSay13 PROMPT "Adicional:"  SIZE 031, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
	    @ 101, 040 MSGET oIndMinimo VAR nIndMinimo SIZE 050, 010 OF oFolder1:aDialogs[1] PICTURE "@E 9.999999"    COLORS 0, 16777215 HASBUTTON PIXEL
	    @ 101, 162 MSGET oAddMinimo VAR nAddMinimo SIZE 050, 010 OF oFolder1:aDialogs[1] PICTURE "@E 999,999.99" COLORS 0, 16777215 HASBUTTON PIXEL

	    // -- Filtro --------------------------------------
	    @ 001, 004 GROUP oGroup1 TO 097, 121 PROMPT "Origem" OF oFolder1:aDialogs[2] COLOR 0, 16777215 PIXEL
	    @ 011, 009 SAY oSay7 PROMPT "UF:"     SIZE 025, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
	    @ 035, 009 SAY oSay8 PROMPT "Cidade:" SIZE 025, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
	    @ 060, 010 SAY oSay9 PROMPT "Região"  SIZE 025, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
	    @ 019, 009 MSGET oOrigUF 	 VAR cOrigUF 	 SIZE 027, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 F3 X3F3("GV8_CDUF") HASBUTTON PIXEL
	    @ 043, 009 MSGET oOrigCidade VAR cOrigCidade SIZE 045, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 F3 "GU7GUA" VALID ValCidade(cOrigCidade, "1")  HASBUTTON PIXEL
	    @ 068, 009 MSGET oOrigRegiao VAR cOrigRegiao SIZE 045, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 F3 "GU9" 	  VALID ValRegiao(cOrigRegiao, "1")  HASBUTTON PIXEL
	    @ 043, 057 MSGET oOrigCidDesc   VAR cOrigCidDesc 	 SIZE 062, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
	    @ 068, 057 MSGET oOrigRegDesc   VAR cOrigRegDesc 	 SIZE 062, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL

	    @ 001, 126 GROUP oGroup2 TO 097, 243 PROMPT "Destino" OF oFolder1:aDialogs[2] COLOR 0, 16777215 PIXEL
	    @ 011, 131 SAY oSay10 PROMPT "UF:"     SIZE 025, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
	    @ 035, 131 SAY oSay11 PROMPT "Cidade:" SIZE 025, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
	    @ 060, 132 SAY oSay12 PROMPT "Região"  SIZE 025, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
	    @ 019, 131 MSGET oDestUF     VAR cDestUF 	 SIZE 027, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 F3 X3F3("GV8_CDUF") HASBUTTON PIXEL
	    @ 043, 131 MSGET oDestCidade VAR cDestCidade SIZE 045, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 F3 "GU7GUA" VALID ValCidade(cDestCidade, "2")  HASBUTTON PIXEL
	    @ 068, 131 MSGET oDestRegiao VAR cDestRegiao SIZE 045, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 F3 "GU9"    VALID ValRegiao(cDestRegiao, "2")  HASBUTTON PIXEL
	    @ 043, 179 MSGET oDestCidDesc   VAR cDestCidDesc 	 SIZE 062, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
	    @ 068, 179 MSGET oDestRegDesc   VAR cDestRegDesc   SIZE 062, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
	    
	    @ 100, 009 SAY oSay7 PROMPT "* Tipos de Rotas: Cidade, Região, País/UF e Remetente. Se não for marcado, será considerado apenas o tipo correspondente ao informado."     SIZE 230, 017 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
	    
	    // -- Faixas --------------------------------------
	    oGetFaixas := MsNewGetDados():New(01, 01, 60, 160, GD_UPDATE, "AllwaysTrue", "AllwaysTrue",/*[ cIniCpos]*/, {}	,/* [ nFreeze]*/,/*[ nMax]*/,"AllwaysTrue",/*[ cSuperDel]*/,/*[ cDelOk]*/, oFolder1:ADialogs[3], aHeadFaixas, /* aColsFil*/ aColsFaixas,,/*[ cTela]*/)
	    oGetFaixas:oBrowse:blDblClick 	:= { |x,nCol| MrkLinha() }
	    oGetFaixas:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	    
	    @ 085, 009 CHECKBOX oChkTpOrig VAR lChkTpOrig PROMPT "Aplicar para todos os tipos de rotas. *" SIZE 107, 008 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
	    @ 085, 131 CHECKBOX oChkTpDest VAR lChkTpDest PROMPT "Aplicar para todos os tipos de rotas. *" SIZE 107, 008 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
	
	    oFolder1:Align := CONTROL_ALIGN_ALLCLIENT
	    oPanel2:Align := CONTROL_ALIGN_ALLCLIENT
	    
	    oGetFaixas:SetArray(aColsFaixas, .T.)
	    oGetFaixas:oBrowse:GoBottom()
	    oGetFaixas:oBrowse:GoTop()
	    oGetFaixas:oBrowse:Refresh()
	    
	ACTIVATE MSDIALOG oDlgReajuste ON INIT EnchoiceBar(oDlgReajuste,{|| Processa({|| btOkReajuste(nTipo)}, "Aplicando Reajuste com Filtro","")}, {||oDlgReajuste:End()}) CENTERED    


Return

/*-------------------------------------------------------------------                                                                           
MrkLinha
Evento de duplo clique do grid de Faixas da tela de Reajuste

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function MrkLinha()
	If GDFieldGet( 'MRK', oGetFaixas:nAt,, oGetFaixas:aHeader, oGetFaixas:aCols ) == 'LBNO'
		GDFieldPut( 'MRK', 'LBOK', oGetFaixas:nAt, oGetFaixas:aHeader, oGetFaixas:aCols )
	Else
		GDFieldPut( 'MRK', 'LBNO' , oGetFaixas:nAt , oGetFaixas:aHeader , oGetFaixas:aCols )
	EndIf
Return


/*-------------------------------------------------------------------                                                                           
{Protheus.doc} ValCidade
Reajuste Componentes: Valid do campo Cidade Origem e Destino do Filtro

@author Israel A. Possoli
@since 01/04/2014
@version 1.0
-------------------------------------------------------------------*/
Static Function ValCidade(cNrCidade, cTipo)
	Local lRet := .T.
	Local cNmCidade
	
	If !Empty(cNrCidade)
		lRet := ExistCpo("GU7",cNrCidade)
	EndIF
	
	cNmCidade := POSICIONE("GU7", 1, xFilial("GU7") + cNrCidade,"GU7_NMCID")
	
	// -- Origem -----
	If cTipo == "1"
		If lRet
			cOrigCidDesc := cNmCidade
			oOrigCidDesc:CtrlRefresh()
		Else
			cOrigCidDesc := ""
			oOrigCidDesc:CtrlRefresh()					
		EndIf
	EndIf
	
	// -- Destino ----
	If cTipo == "2"
		If lRet
			cDestCidDesc := cNmCidade
			oDestCidDesc:CtrlRefresh()
		Else
			cDestCidDesc := ""
			oDestCidDesc:CtrlRefresh()				
		EndIf
	EndIf
	
Return (lRet)


/*-------------------------------------------------------------------                                                                           
{Protheus.doc} ValRegiao
Reajuste Componentes: Valid do campo Região Origem e Destino do Filtro

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function ValRegiao(cNrRegiao, cTipo)
	Local lRet := .T.
	Local cNmRegiao
	
	If !Empty(cNrRegiao)
		lRet := ExistCpo("GU9",cNrRegiao)
	EndIf
	
	cNmRegiao := POSICIONE("GU9", 1, xFilial("GU9") + cNrRegiao,"GU9_NMREG")
	
	// -- Origem -----
	If cTipo == "1"
		If lRet
			cOrigRegDesc := cNmRegiao
			oOrigRegDesc:CtrlRefresh()		
		Else
			cOrigRegDesc := ""
			oOrigRegDesc:CtrlRefresh()				
		EndIf
	EndIf
	
	// -- Destino ----
	If cTipo == "2"
		If lRet
			cDestRegDesc := cNmRegiao
			oDestRegDesc:CtrlRefresh()		
		Else
			cDestRegDesc := ""
			oDestRegDesc:CtrlRefresh()				
		EndIf	
	EndIf
	
Return (lRet)

/*-------------------------------------------------------------------                                                                           
{Protheus.doc} btOkReajuste
Reajuste Componentes: Ação do botão OK da tela de reajuste com filtro

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function btOkReajuste(nTipo)
	Local nCountOrigem
	Local nCountDestino
	Local lOrigemOk
	Local lDestinoOk
	Local lAplicar
	Local cCodCliente
	
	Local nI
	Local nCount := 0
	
	Local aFaixasSel := {}
	
	Local oActiveModel
	Local oGridModel
	
	Default nTipo := 1
	
	//Local oActiveView
	//Local oGridView
	
	/* -- Validações --------------------------------------------------- */
	nCountOrigem := 0
	nCountOrigem := If(!Empty(cOrigUF)    , nCountOrigem + 1, nCountOrigem)
	nCountOrigem := If(!Empty(cOrigCidade), nCountOrigem + 1, nCountOrigem)
	nCountOrigem := If(!Empty(cOrigRegiao), nCountOrigem + 1, nCountOrigem)
	
	If nCountOrigem > 1
		Help( ,, 'HELP',, "Apenas uma Origem deve ser informada, ou deixe os campos em branco para considerar a faixa aberta para as rotas de Origem.", 1, 0)
		Return .F.
	EndIf
	
	nCountDestino := 0
	nCountDestino := If(!Empty(cDestUF)    , nCountDestino + 1, nCountDestino)
	nCountDestino := If(!Empty(cDestCidade), nCountDestino + 1, nCountDestino)
	nCountDestino := If(!Empty(cDestRegiao), nCountDestino + 1, nCountDestino)
	
	If nCountDestino > 1
		Help( ,, 'HELP',, "Apenas um Destino deve ser informado, ou deixe os campos em branco para considerar a faixa aberta para as rotas de Destino.", 1, 0)
		Return .F.
	EndIf
	
	/* -- Faixas Selecionadas ------------------------------------------ */
	For nI := 1 To Len(oGetFaixas:aCols)
		If GDFieldGet( 'MRK', nI,, oGetFaixas:aHeader, oGetFaixas:aCols ) == 'LBOK'
			aADD(aFaixasSel, GDFieldGet( 'SEQ', nI,, oGetFaixas:aHeader, oGetFaixas:aCols ))
		EndIf
	Next
	
	oActiveModel := FWModelActive()

	/* ------------------------------------------------------------------------- */
	/* -- C O M P O N E N T E S ------------------------------------------------ */
	/* ------------------------------------------------------------------------- */
	If nTipo == 1
		oGridModel   := oActiveModel:GetModel('GFEA062_GV1')
		ProcRegua(oGridModel:Length())
		
		/* -- Validações --------------------------------------------------- */
		For nI := 1 To oGridModel:Length()
			IncProc()
			
			dbSelectArea((cAliasGV1))
			dbSetOrder(1)
			If dbSeek(oGridModel:GetValue('GV1_CDFXTV', nI) + oGridModel:GetValue('GV1_NRROTA', nI) + oGridModel:GetValue('GV1_CDCOMP', nI))
				If AllTrim(nComboCompo) == AllTrim((cAliasGV1)->GV1_CDCOMP) .AND. aScan(aFaixasSel,{|x| x == oGridModel:GetValue('GV1_CDFXTV', nI) }) > 0
					nCount++
					
					lAplicar := .F.
					
					If nCountOrigem == 0 .AND. nCountDestino == 0
						lAplicar := .T.
					Else
						dbSelectArea("GV8")
						dbSetOrder(1)
						If dbSeek(xFilial("GV8") + (cAliasGV1)->GV1_CDEMIT + (cAliasGV1)->GV1_NRTAB + (cAliasGV1)->GV1_NRNEG + (cAliasGV1)->GV1_NRROTA)
						
							// -- Origem ----------
							If nCountOrigem == 0
								lOrigemOk := .T.
							Else
								lOrigemOk  := VerFiltro("1", lChkTpOrig)
							EndIf
							
							// -- Destino----------
							If nCountDestino == 0
								lDestinoOk := .T.
							Else
								lDestinoOk := VerFiltro("2", lChkTpDest)
							EndIf
							
							lAplicar := lOrigemOk .AND. lDestinoOk
						Else
							lAplicar := .F.
						EndIf
					EndIf
					
					// -- Efetivar----------
					If lAplicar
						
						oGridModel:GoLine(nI)
						
						oGridModel:LoadValue('GV1_INDNOR', nIndNormal)
						oGridModel:LoadValue('GV1_ADDNOR', nAddNormal)
						oGridModel:LoadValue('GV1_INDEXT', nIndExtra )
						oGridModel:LoadValue('GV1_ADDEXT', nAddExtra )
						oGridModel:LoadValue('GV1_INDMIN', nIndMinimo)
						oGridModel:LoadValue('GV1_ADDMIN', nAddMinimo)
						
						RecLock((cAliasGV1), .F.)
							(cAliasGV1)->GV1_INDNOR := nIndNormal
							(cAliasGV1)->GV1_ADDNOR := nAddNormal
							(cAliasGV1)->GV1_INDEXT := nIndExtra
							(cAliasGV1)->GV1_ADDEXT := nAddExtra
							(cAliasGV1)->GV1_INDMIN := nIndMinimo
							(cAliasGV1)->GV1_ADDMIN := nAddMinimo
						MsUnlock()
					EndIf
				EndIf
			EndIf	
		Next
	EndIf


	/* ------------------------------------------------------------------------- */
	/* -- C O M P O N E N T E S   A D I C I O N A I S -------------------------- */
	/* ------------------------------------------------------------------------- */
	If nTipo == 2
		oGridModel   := oActiveModel:GetModel('GFEA062_GUC')
		ProcRegua(oGridModel:Length())
		
		cCodCliente := StrTokArr(nComboCliente, "-")[1]
		
		/* -- Validações --------------------------------------------------- */
		For nI := 1 To oGridModel:Length()
			IncProc()
			
			dbSelectArea((cAliasGUC))
			dbSetOrder(1)
			If dbSeek(oGridModel:GetValue('GUC_CDFXTV', nI) + oGridModel:GetValue('GUC_NRROTA', nI) + oGridModel:GetValue('GUC_CDCOMP', nI) + oGridModel:GetValue('GUC_EMICOM', nI))
				If AllTrim(nComboCompo) == AllTrim((cAliasGUC)->GUC_CDCOMP) .AND. ;
				   aScan(aFaixasSel,{|x| x == oGridModel:GetValue('GUC_CDFXTV', nI) }) > 0 .AND. ;
				   (AllTrim(nComboCliente) == "(TODOS)" .OR. AllTrim(cCodCliente) == AllTrim((cAliasGUC)->GUC_EMICOM))
				   
					nCount++
					
					lAplicar := .F.
					
					If nCountOrigem == 0 .AND. nCountDestino == 0
						lAplicar := .T.
					Else
						dbSelectArea("GV8")
						dbSetOrder(1)
						If dbSeek(xFilial("GV8") + (cAliasGUC)->GUC_CDEMIT + (cAliasGUC)->GUC_NRTAB + (cAliasGUC)->GUC_NRNEG + (cAliasGUC)->GUC_NRROTA)
						
							// -- Origem ----------
							If nCountOrigem == 0
								lOrigemOk := .T.
							Else
								lOrigemOk  := VerFiltro("1", lChkTpOrig)
							EndIf
							
							// -- Destino----------
							If nCountDestino == 0
								lDestinoOk := .T.
							Else
								lDestinoOk := VerFiltro("2", lChkTpDest)
							EndIf
							
							lAplicar := lOrigemOk .AND. lDestinoOk
						Else
							lAplicar := .F.
						EndIf
					EndIf
					
					// -- Efetivar----------
					If lAplicar
						
						oGridModel:GoLine(nI)
						
						oGridModel:LoadValue('GUC_INDNOR', nIndNormal)
						oGridModel:LoadValue('GUC_ADDNOR', nAddNormal)
						oGridModel:LoadValue('GUC_INDEXT', nIndExtra )
						oGridModel:LoadValue('GUC_ADDEXT', nAddExtra )
						oGridModel:LoadValue('GUC_INDMIN', nIndMinimo)
						oGridModel:LoadValue('GUC_ADDMIN', nAddMinimo)
						
						RecLock((cAliasGUC), .F.)
							(cAliasGUC)->GUC_INDNOR := nIndNormal
							(cAliasGUC)->GUC_ADDNOR := nAddNormal
							(cAliasGUC)->GUC_INDEXT := nIndExtra 
							(cAliasGUC)->GUC_ADDEXT := nAddExtra 
							(cAliasGUC)->GUC_INDMIN := nIndMinimo
							(cAliasGUC)->GUC_ADDMIN := nAddMinimo
						MsUnlock()
					EndIf
				EndIf
			EndIf	
		Next
	EndIf
	
	oGridModel:GoLine(1)
	
	/*oActiveView := FWViewActive()
	oGridView   := oActiveView:GetViewObj("GFEA062_GV1")[3]
	
	oGridView:OBrowse:Refresh()
	oGridView:Refresh()*/
	
	oDlgReajuste:End()
	
Return (.T.)
/*-------------------------------------------------------------------                                                                           
{Protheus.doc} VerFiltro
Reajuste Componentes: Verifica se a rota do componente atual pertence
ao filtro

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function VerFiltro(cTipo, lTodosTiposRotas)
	Local cUFOrigem      := ""
	Local cCidadeOrigem  := ""
	Local cRegiaoOrigem  := ""
	
	Local cUFDestino     := ""
	Local cCidadeDestino := ""
	Local cRegiaoDestino := ""
	
	Local lRet := .F.
	
	/* -- O R I G E M -------------------------------------------------- */
	If cTipo == "1"
		If GV8->GV8_TPORIG == "1"
			// -- Cidade -----
			cCidadeOrigem := GV8->GV8_NRCIOR
			
			If lTodosTiposRotas
				cUFOrigem     := POSICIONE("GU7",1, XFILIAL("GU7") + GV8->GV8_NRCIOR, "GU7_CDUF")
			EndIf
		ElseIf GV8->GV8_TPORIG == "3"
			// -- Região -----
			cRegiaoOrigem := GV8->GV8_NRREOR
			
			If lTodosTiposRotas
				cUFOrigem     := POSICIONE("GU9",1, XFILIAL("GU9") + GV8->GV8_NRREOR, "GU9_CDUF")
			EndIf
		ElseIf GV8->GV8_TPORIG == "4"
			// -- País/UF ---
			cUFOrigem     := GV8->GV8_CDUFOR
		ElseIf GV8->GV8_TPORIG == "5"
			// -- Remetente -
			If lTodosTiposRotas
				cCidadeOrigem := POSICIONE("GU3",1, XFILIAL("GU3") + GV8->GV8_CDREM, "GU3_NRCID")
				cUFOrigem     := POSICIONE("GU7",1, XFILIAL("GU7") + cCidadeOrigem , "GU7_CDUF")
			EndIf
		EndIf
	EndIf
	
	/* -- D E S T I N O ------------------------------------------------ */
	If cTipo == "2"
		If GV8->GV8_TPDEST == "1"
			// -- Cidade -----
			cCidadeDestino := GV8->GV8_NRCIDS
			
			If lTodosTiposRotas
				cUFDestino     := POSICIONE("GU7",1, XFILIAL("GU7") + GV8->GV8_NRCIDS, "GU7_CDUF")
			EndIf
		ElseIf GV8->GV8_TPDEST == "3"
			// -- Região -----
			cRegiaoDestino := GV8->GV8_NRREDS
			
			If lTodosTiposRotas
				cUFDestino     := POSICIONE("GU9",1, XFILIAL("GU9") + GV8->GV8_NRREDS, "GU9_CDUF")
			EndIf
		ElseIf GV8->GV8_TPDEST == "4"
			// -- País/UF ---
			cUFDestino     := GV8->GV8_CDUFDS
		ElseIf GV8->GV8_TPDEST == "5"
			// -- Remetente -
			If lTodosTiposRotas
				cCidadeDestino := POSICIONE("GU3",1, XFILIAL("GU3") + GV8->GV8_CDDEST, "GU3_NRCID")
				cUFDestino     := POSICIONE("GU7",1, XFILIAL("GU7") + cCidadeDestino , "GU7_CDUF")
			EndIf
		EndIf
		
	EndIf
	
	/* -- C O M P A R A Ç Ã O ------------------------------------------ */
	If cTipo == "1"
		If Empty(cOrigUF);     cUFOrigem     := ""; EndIf
		If Empty(cOrigCidade); cCidadeOrigem := ""; EndIf
		If Empty(cOrigRegiao); cRegiaoOrigem := ""; EndIf
		
		If AllTrim(cOrigUF)     == AllTrim(cUFOrigem)     .AND. ;
		   AllTrim(cOrigCidade) == AllTrim(cCidadeOrigem) .AND. ;
		   AllTrim(cOrigRegiao) == AllTrim(cRegiaoOrigem)
		   
		   lRet := .T.
		EndIf
		
	EndIf

	If cTipo == "2"
		If Empty(cDestUF);     cUFDestino     := ""; EndIf
		If Empty(cDestCidade); cCidadeDestino := ""; EndIf
		If Empty(cDestRegiao); cRegiaoDestino := ""; EndIf
			
		If AllTrim(cDestUF)     == AllTrim(cUFDestino)     .AND. ;
		   AllTrim(cDestCidade) == AllTrim(cCidadeDestino) .AND. ;
		   AllTrim(cDestRegiao) == AllTrim(cRegiaoDestino)
		   
		   lRet := .T.
		EndIf
		
	EndIf

Return (lRet)


/*-------------------------------------------------------------------                                                                           
{Protheus.doc} GetStruct
Retorna a estrutura das tabelas

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function GetStruct(nOP, cTab)
	Local nI
	Local nOrdem
	Local cAlias
	Local cDescTable
	Local oStruct
	Local aIndex
	Local aUniqueIndex
	Local oStructRet
	Local lObrigatorio
	Local cF3
	
	Do Case
		Case cTab == "GV9"
			aUniqueIndex := {"GV9_CDEMIT","GV9_NRTAB","GV9_NRNEG"}
			aIndex := {1, "1", "GV9_CDEMIT+GV9_NRTAB+GV9_NRNEG", "Transportador|Tabela|Negociação"}
			cAlias := cAliasGV9
			oStruct := aStructGV9
			cDescTable := "Negociação"
		Case cTab == "GV1"
			aUniqueIndex := {"GV1_CDEMIT","GV1_NRTAB","GV1_NRNEG","GV1_CDFXTV","GV1_NRROTA","GV1_CDCOMP"}
			aIndex := {1, "1", "GV1_CDEMIT+GV1_NRTAB+GV1_NRNEG+GV1_CDFXTV+GV1_NRROTA+GV1_CDCOMP", "Transportador|Tabela|Negociação|Seq Faixa|Rota|Componente"}
			cAlias := cAliasGV1
			oStruct := aStructGV1
			cDescTable := "Componentes da Tarifa"
		Case cTab == "GUC"
			aUniqueIndex := {"GUC_CDEMIT","GUC_NRTAB","GUC_NRNEG","GUC_CDFXTV","GUC_NRROTA","GUC_CDCOMP","GUC_EMICOM"}
			aIndex := {1, "1", "GUC_CDEMIT+GUC_NRTAB+GUC_NRNEG+GUC_CDFXTV+GUC_NRROTA+GUC_CDCOMP+GUC_EMICOM", "Transportador|Tabela|Negociação|Seq Faixa|Rota|Componente|Cliente"}
			cAlias := cAliasGUC
			oStruct := aStructGUC
			cDescTable := "Componentes Adicionais da Tarifa"
		Otherwise 
			Return Nil
	EndCase
	
	If nOP == 1
		oStructRet := FWFormModelStruct():New()
		
		oStructRet:AddTable(;
			cAlias , ;     	// [01] Alias da tabela
			aUniqueIndex, ;	// [02] Array com os campos que correspondem a primary key
			cDescTable)	// [03] Descrição da tabela
				
		//-------------------------------------------------------------------
		// Indices
		//-------------------------------------------------------------------
		oStructRet:AddIndex( ;
			aIndex[1]  , ;          // [01] Ordem do indice
			aIndex[2]  , ;          // [02] ID
			aIndex[3]  , ;          // [03] Chave do indice
			aIndex[4]  , ;          // [04] Descrição do indice
			''         , ;          // [05] Expressão de lookUp dos campos de indice
			''         , ;     		// [06] Nickname do indice
			.T.)                 	// [07] Indica se o indice pode ser utilizado pela interface   
		
		//-------------------------------------------------------------------
		// Campos
		//-------------------------------------------------------------------
		For nI := 1 To Len(oStruct)
			lObrigatorio := .F.
			If oStruct[nI][2] == "GV9_NDTVLI" .OR. oStruct[nI][2] == "GV9_NNRNEG"
				lObrigatorio :=.T.
			EndIf
			oStructRet:AddField(;
				oStruct[nI][1] 	, ;          // [01] Titulo do campo
				oStruct[nI][1] 	, ;          // [02] ToolTip do campo
				oStruct[nI][2] 	, ;          // [03] Id do Field
				oStruct[nI][3] 	, ;          // [04] Tipo do campo
				oStruct[nI][4] 	, ;          // [05] Tamanho do campo
				oStruct[nI][5] 	, ;          // [06] Decimal do campo
				{|| .T.}          	, ;      // [07] Code-block de validação do campo
				oStruct[nI][13]	, ;        	 // [08] Code-block de validação When do campo
				{}                  , ;      // [09] Lista de valores permitido do campo
				lObrigatorio	    , ;      // [10] Indica se o campo tem preenchimento obrigatório
				NIL                 , ;      // [11] Code-block de inicializacao do campo
				.F.                 , ;      // [12] Indica se trata-se de um campo chave
				.F.                 , ;      // [13] Indica se o campo pode receber valor em uma operação de update.
				.F.)                		 // [14] Indica se o campo é virtual
		End
	EndIf	
	
	If nOP == 2
		nOrdem := 0
		oStructRet := FWFormViewStruct():New()
		For nI := 1 To len(oStruct)
			cF3 := Nil
			If oStruct[nI][2] == "GV9_NCLFR"
				cF3 := "GUB"
			EndIf
			
			If oStruct[nI][2] == "GV9_NTPOP"
				cF3 := "GV4"
			EndIf
			
			If oStruct[nI][11]
				oStructRet:AddField(;
					oStruct[nI][2]    		, ;   	// [01] Campo
					Alltrim(StrZero(++nOrdem, 2))  , ;     // [02] Ordem
					oStruct[nI][1]  	    , ;     // [03] Titulo
					oStruct[nI][1]       	, ;   	// [04] Descricao
					NIL                     , ;     // [05] Help
					oStruct[nI][10]      	, ;   	// [06] Tipo do campo   COMBO, Get ou CHECK
					oStruct[nI][6]       	, ;     // [07] Picture
					NIL                     , ;     // [08] PictVar
					cF3                   	, ;     // [09] F3
					.T.	   	 				, ;     // [10] Editavel
					NIL               		, ;     // [11] Folder
					NIL               		, ;     // [12] Group
					oStruct[nI][8]       	, ;   	// [13] Lista Combo
					NIL                    	, ;     // [14] Tam Max Combo
					NIL                		, ;     // [15] Inic. Browse
					.F.)              				// [16] Virtual
			EndIf
		End
	EndIf
	
Return (oStructRet)


/*-------------------------------------------------------------------                                                                           
{Protheus.doc} DefStruct
Definição da Tabela Temporária da Tabela de Frete x Negociação

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function DefStruct()
	Local nI
	/* -------------------------------------------------------
		[01] Titulo do campo                                                
		[02] ToolTip do campo                                               
		[03] Id do Field                                                    
		[04] Tipo do campo                                                  
		[05] Tamanho do campo                                               
		[06] Decimal do campo                                               
		[07] Code-block de validação do campo                               
		[08] Code-block de validação When do campo                          
		[09] Lista de valores permitido do campo                            
		[10] Indica se o campo tem preenchimento obrigatório                
		[11] Code-block de inicializacao do campo                           
		[12] Indica se o campo será mostrado no Browse                         
		[13] Code-block de validação When do campo
	------------------------------------------------------- */
	
	// -- GV9 - Negociação -----------------------------------------------------------
	aStructGV9 := {{"Transportador"  	, "GV9_CDEMIT", "C", TamSX3("GV9_CDEMIT")[1], 0, "@!", .F., {}, 1, "GET", .T., .T., {||.F.}},;
				   {"Nome"  			, "GV9_NMEMIT", "C", TamSX3("GVA_NMEMIT")[1], 0, "@!", .F., {}, 1, "GET", .T., .T., {||.F.}},;
				   {"Tabela"		   	, "GV9_NRTAB" , "C", TamSX3("GV9_NRTAB")[1] , 0, "@!", .F., {}, 1, "GET", .T., .T., {||.F.}},;
				   {"Negociação"		, "GV9_NRNEG" , "C", TamSX3("GV9_NRNEG")[1] , 0, "@!", .F., {}, 1, "GET", .T., .T., {||.F.}},;
				   {"Class. Frete"	    , "GV9_CDCLFR", "C", TamSX3("GV9_CDCLFR")[1], 0, "@!", .F., {}, 1, "GET", .T., .T., {||.F.}},;
				   {"Tipo Operação"		, "GV9_CDTPOP", "C", TamSX3("GV9_CDTPOP")[1], 0, "@!", .F., {}, 1, "GET", .T., .T., {||.F.}},;
				   {"Tipo Lotação"		, "GV9_TPLOTA", "C", TamSX3("GV9_TPLOTA")[1], 0, "@!", .F., {}, 1, "GET", .T., .T., {||.F.}},;
				   {"Vigência De"		, "GV9_DTVALI", "D", TamSX3("GV9_DTVALI")[1], 0, ""  , .F., {}, 1, "GET", .T., .T., {||.F.}},;
				   {"Vigência Até"		, "GV9_DTVALF", "D", TamSX3("GV9_DTVALF")[1], 0, ""  , .F., {}, 1, "GET", .T., .T., {||.F.}},;
				   {"Nova Negociação"	, "GV9_NNRNEG", "C", TamSX3("GV9_NRNEG")[1] , 0, "@!", .F., {}, 1, "GET", .T., .T., {||.T.}},;
				   {"Nova Vigência De"	, "GV9_NDTVLI", "D", TamSX3("GV9_DTVALI")[1], 0, ""  , .F., {}, 1, "GET", .T., .T., {||.T.}},;
				   {"Nova Vigência Até"	, "GV9_NDTVLF", "D", TamSX3("GV9_DTVALF")[1], 0, ""  , .F., {}, 1, "GET", .T., .T., {||.T.}},;
				   {"Nova Class. Frete"	, "GV9_NCLFR" , "C", TamSX3("GV9_CDCLFR")[1], 0, "@!", .F., {}, 1, "GET", .T., .T., {||.T.}},;
				   {"Novo Tipo Operação", "GV9_NTPOP" , "C", TamSX3("GV9_CDTPOP")[1], 0, "@!", .F., {}, 1, "GET", .T., .T., {||.T.}};
				  }
				  
	aCamposGV9 := {}
	
	For nI := 1 To Len(aStructGV9)
		aADD(aCamposGV9, {aStructGV9[nI][2], aStructGV9[nI][3], aStructGV9[nI][4], aStructGV9[nI][5] })
	Next
	
	cAliasGV9 := GFECriaTab({aCamposGV9, {"GV9_CDEMIT+GV9_NRTAB+GV9_NRNEG"}})
	
	// -- GV1 - Componentes/Tarifa ---------------------------------------------------
	aStructGV1 := {}
	
	BuscarStructSX3("GV1", @aStructGV1, {'GV1_CDEMIT', 'GV1_NRTAB', 'GV1_NRNEG'}, .F.)
	BuscarStructSX3("GV1", @aStructGV1, {'GV1_CDFXTV', 'GV1_NRROTA','GV1_CDCOMP'})
	
	aADD(aStructGV1, {"Modificado"				, "GV1_MODIFY", "L", 1,  0, ""             	, .F., {}, 1, "GET", .F., .T., {||.F.}})
	aADD(aStructGV1, {"Índice Sobre Normal"	  	, "GV1_INDNOR", "N", 8,  6, "@E 9.999999"   	, .F., {}, 1, "GET", .T., .T., {||.T.}})
	aADD(aStructGV1, {"Adicional Sobre Normal"	, "GV1_ADDNOR", "N", 10, 2, "@E 999,999.99"	, .F., {}, 1, "GET", .T., .T., {||.T.}})
	aADD(aStructGV1, {"Índice Sobre Extra"	  	, "GV1_INDEXT", "N", 8,  6, "@E 9.999999"   	, .F., {}, 1, "GET", .T., .T., {||.T.}})
	aADD(aStructGV1, {"Adicional Sobre Extra" 	, "GV1_ADDEXT", "N", 10, 2, "@E 999,999.99"	, .F., {}, 1, "GET", .T., .T., {||.T.}})
	aADD(aStructGV1, {"Índice Sobre Mínimo"	  	, "GV1_INDMIN", "N", 8,  6, "@E 9.999999"   	, .F., {}, 1, "GET", .T., .T., {||.T.}})
	aADD(aStructGV1, {"Adicional Sobre Mínimo"	, "GV1_ADDMIN", "N", 10, 2, "@E 999,999.99"	, .F., {}, 1, "GET", .T., .T., {||.T.}})
	
	
	
	aCamposGV1 := {}
	
	For nI := 1 To Len(aStructGV1)
		aADD(aCamposGV1, {aStructGV1[nI][2], aStructGV1[nI][3], aStructGV1[nI][4], aStructGV1[nI][5] })
	Next
	
	cAliasGV1 := GFECriaTab({aCamposGV1, {"GV1_CDFXTV+GV1_NRROTA+GV1_CDCOMP", "GV1_CDEMIT+GV1_NRTAB+GV1_NRNEG+GV1_CDFXTV+GV1_NRROTA+GV1_CDCOMP"}})
	

	// -- GUC - Componentes Adicionais/Tarifa ----------------------------------------
	aStructGUC := {}
		
	BuscarStructSX3("GUC", @aStructGUC, {'GUC_CDEMIT', 'GUC_NRTAB', 'GUC_NRNEG'}, .F.)
	BuscarStructSX3("GUC", @aStructGUC, {'GUC_CDFXTV', 'GUC_NRROTA','GUC_CDCOMP','GUC_EMICOM'})
	
	aADD(aStructGUC, {"Modificado"				, "GUC_MODIFY", "L", 1,  0, ""             	, .F., {}, 1, "GET", .F., .T., {||.F.}})
	aADD(aStructGUC, {"Índice Sobre Normal"		, "GUC_INDNOR", "N", 8,  6, "@E 9.999999"   	, .F., {}, 1, "GET", .T., .T., {||.T.}})
	aADD(aStructGUC, {"Adicional Sobre Normal"	, "GUC_ADDNOR", "N", 10, 2, "@E 999,999.99"	, .F., {}, 1, "GET", .T., .T., {||.T.}})
	aADD(aStructGUC, {"Índice Sobre Extra"		, "GUC_INDEXT", "N", 8,  6, "@E 9.999999"   	, .F., {}, 1, "GET", .T., .T., {||.T.}})
	aADD(aStructGUC, {"Adicional Sobre Extra"	, "GUC_ADDEXT", "N", 10, 2, "@E 999,999.99"	, .F., {}, 1, "GET", .T., .T., {||.T.}})
	aADD(aStructGUC, {"Índice Sobre Mínimo"		, "GUC_INDMIN", "N", 8,  6, "@E 9.999999"   	, .F., {}, 1, "GET", .T., .T., {||.T.}})
	aADD(aStructGUC, {"Adicional Sobre Mínimo"	, "GUC_ADDMIN", "N", 10, 2, "@E 999,999.99"	, .F., {}, 1, "GET", .T., .T., {||.T.}})
				  
	aCamposGUC := {}
	
	For nI := 1 To Len(aStructGUC)
		aADD(aCamposGUC, {aStructGUC[nI][2], aStructGUC[nI][3], aStructGUC[nI][4], aStructGUC[nI][5] })
	Next
	
	cAliasGUC := GFECriaTab({aCamposGUC, {"GUC_CDFXTV+GUC_NRROTA+GUC_CDCOMP+GUC_EMICOM", "GUC_CDEMIT+GUC_NRTAB+GUC_NRNEG+GUC_CDFXTV+GUC_NRROTA+GUC_CDCOMP"}})

Return


//-------------------------------------------------------------------
/*/{Protheus.doc} BuscarStrucSX3
Função auxiliar para buscar os campos do SX3 de uma tabela e retornar um array

@author Rodrigo dos Santos
/*/
//-------------------------------------------------------------------
Static Function BuscarStructSX3(cTabela, aStruct, aCamposView, lShowBrowse)
	Local lInView := .T.
	Local cTipoC  := "GET"
	Local cCombo  := ""
	Default aCamposView := {}
	Default lShowBrowse := .T.
	
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(dbSeek(cTabela))
	While !SX3->(EOF()) .AND. SX3->X3_ARQUIVO == cTabela
		// [1] Título
		// [2] Campo
		// [3] Tipo
		// [4] Tamanho
		// [5] Decimal
		// [6] Picture
		// [7] Imagem?
		// [8] Opções para combobox
		// [9] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
		// [10] Tipo de Campos (GET, COMBO, CHECK)
		// [11] Visível na visualização/edição
		// [12] Visível no Browse
		// [13] Validação When

		If AScan (aCamposView,  {|x| x == ALLTRIM(SX3->X3_CAMPO) }) > 0
			If lShowBrowse
				lInView := .T.
			Else
				lInView := .F.
			EndIf
			
			If Empty(SX3->X3_CBOX)
				cTipoC := "GET"
				cCombo := {}
			Else
				cTipoC := "COMBO"
				cCombo := StrTokArr(SX3->X3_CBOX, ";")
			EndIf
			
			aADD(aStruct,;
				{SX3->X3_TITULO , ALLTRIM(SX3->X3_CAMPO), SX3->X3_TIPO, SX3->X3_TAMANHO , SX3->X3_DECIMAL, SX3->X3_PICTURE , .F., cCombo, 1, cTipoC, lInView, .F., {||.F.}};
			)
		EndIf
		SX3->(dbSkip())
	EndDo

Return

/*-------------------------------------------------------------------                                                                           
CopyReg
Copia todos os campos da tabela especificada do registro atual


-------------------------------------------------------------------*/ 
Static Function CopyReg(cTab)
	Local aTab := {}
	Local nCount
	Local aArea
	
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(dbGoTop())
	SX3->(dbSeek(cTab))
	
	While !SX3->( EOF() ) .AND. SX3->X3_ARQUIVO == cTab
		If SX3->X3_CONTEXT == "R"
			AAdd(aTab,&(cTab + "->" + SX3->X3_CAMPO))
		EndIf
		SX3->(dbSkip())
	End
	
	SX3->(dbSetOrder(1))
	SX3->(dbGoTop())
	SX3->(dbSeek(cTab))
	
	RecLock(cTab, .T.)
	nCount := 0
	While !SX3->( EOF() ) .AND. SX3->X3_ARQUIVO == cTab
		If SX3->X3_CONTEXT == "R"
			nCount++
			&(cTab+"->"+ALLTRIM(SX3->X3_CAMPO))  := aTab[nCount]
		EndIf
		SX3->(dbSkip())
	End
	
	dbSelectArea(cTab)
Return aTab


/*-------------------------------------------------------------------                                                                           
DefTabNeg
Definição do Grid de Negociações

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function DefTabFaixas()

	Local aHead    := {}	// Campos da temp-table de Tabela de Frete
	
	aAdd( aHead, { ;
		''                 , ;    // 01 - Titulo
		'MRK'            , ;    // 02 - Campo
		'@BMP'             , ;    // 03 - Picture
		10                 , ;    // 04 - Tamanho
		0                  , ;    // 05 - Decimal
		''                 , ;    // 06 - Valid
		''                 , ;    // 07 - Usado
		'C'                , ;    // 08 - Tipo
		''                 , ;    // 09 - F3
		'R'                , ;    // 10 - Contexto
		''                 , ;    // 11 - ComboBox
		''             , ;    // 12 - Relacao
		''                 , ;    // 13 - Alterar
		'V'                , ;    // 14 - Visual
		''                 } )    // 15 - Valid Usuario
		
	aAdd( aHead, { ;
		'Seq Faixa'        , ;    // 01 - Titulo
		'SEQ'            , ;    // 02 - Campo
		'@!'               , ;    // 03 - Picture
		4                 , ;    // 04 - Tamanho
		0                  , ;    // 05 - Decimal
		''                 , ;    // 06 - Valid
		''                 , ;    // 07 - Usado
		'C'                , ;    // 08 - Tipo
		''                 , ;    // 09 - F3
		'R'                , ;    // 10 - Contexto
		''                 , ;    // 11 - ComboBox
		''             	   , ;    // 12 - Relacao
		''                 , ;    // 13 - Alterar
		''                , ;    // 14 - Visual
		''                 } )    // 15 - Valid Usuario				
	
	aAdd( aHead, { ;
		'Faixa'            , ;    // 01 - Titulo
		'FAIXA'            , ;    // 02 - Campo
		'@!'               , ;    // 03 - Picture
		50                 , ;    // 04 - Tamanho
		0                  , ;    // 05 - Decimal
		''                 , ;    // 06 - Valid
		''                 , ;    // 07 - Usado
		'C'                , ;    // 08 - Tipo
		''                 , ;    // 09 - F3
		'R'                , ;    // 10 - Contexto
		''                 , ;    // 11 - ComboBox
		''             	   , ;    // 12 - Relacao
		''                 , ;    // 13 - Alterar
		''                , ;    // 14 - Visual
		''                 } )    // 15 - Valid Usuario				
	
	aAdd( aHead, { ;
		'Unidade'            , ;    // 01 - Titulo
		'UNIDADE'            , ;    // 02 - Campo
		'@!'               , ;    // 03 - Picture
		4                 , ;    // 04 - Tamanho
		0                  , ;    // 05 - Decimal
		''                 , ;    // 06 - Valid
		''                 , ;    // 07 - Usado
		'C'                , ;    // 08 - Tipo
		''                 , ;    // 09 - F3
		'R'                , ;    // 10 - Contexto
		''                 , ;    // 11 - ComboBox
		''             	   , ;    // 12 - Relacao
		''                 , ;    // 13 - Alterar
		''                , ;    // 14 - Visual
		''                 } )    // 15 - Valid Usuario				

Return aHead