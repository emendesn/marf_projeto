#Include "GFEA065.ch"
#Include "Protheus.ch"
#Include "FWMVCDEF.ch"
#Include "FWMBROWSE.ch"
#Include "FILEIO.CH"

//
//
Static lGfeAtu := .F.
Static lDlg    := .F.
Static dDataDf := NIL
Static aCalcRel := {}
Static lConferiu := .F.
Static cSitAnt := ""
Static cSitCusAnt := ""
Static __lCpoSDoc := Nil

//
//
Static s_VLCNPJ_1 := SuperGetMV("MV_VLCNPJ", .F. ,"1")
Static s_VLCNPJ_2 := SuperGetMV("MV_VLCNPJ",,"1")
Static s_AUDINF   := SuperGetMV("MV_AUDINF", .F. ,"1")
Static s_GFEPF1   := SuperGetMv("MV_GFEPF1",,"1")
Static s_DPSERV   := SuperGetMV("MV_DPSERV", .F. , "1")
Static s_ESCPED   := SuperGetMV("MV_ESCPED", .F. , "2")

//
//
//
/*/{Protheus.doc} UGFEA065
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function UGFEA065()
	Local oBrowse
	Local aLegenda 	:= {}
	Local nI 			:= 0
	Private cTTRELAT
	Private lCopy 	:= .F.

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("GW3")

	oBrowse:SetDescription("Documento de Frete")
	aAdd(aLegenda, {"GW3_SIT=='1'", "BLACK", "Recebido"})
	aAdd(aLegenda, {"GW3_SIT=='2'", "RED"  , "Bloqueado"})
	aAdd(aLegenda, {"GW3_SIT=='3'", "GREEN", If( cPaisLoc $ "ANG|PTG", "Aprovado pelo sistema", "Aprovado pelo Sistema" )})
	aAdd(aLegenda, {"GW3_SIT=='4'", "BLUE" , If( cPaisLoc $ "ANG|PTG", "Aprovado pelo utilizador", "Aprovado pelo Usuário" )})

	
	For nI := 1 To Len(aLegenda)
		oBrowse:AddLegend(aLegenda[nI][1], aLegenda[nI][2], aLegenda[nI][3])
	Next

	oBrowse:Activate()

Return(Nil)

Static Function MenuDef()
	Local aRotina := {}
	Local aRetPE  := {}
	Local cERPGFE := ""






	Aadd( aRotina, { "Alterar", "VIEWDEF.UGFEA065", 0, 4, 0,,, })
	Aadd( aRotina, { "Incluir", "VIEWDEF.UGFEA065", 0, 3, 0,,, })
	Aadd( aRotina, { "Visualizar", "VIEWDEF.UGFEA065", 0, 2, 0,,, })

	Aadd( aRotina, { "Pesquisar", "AxPesqui", 0, 1, 0,,, })
	Aadd( aRotina, { "Excluir", "VIEWDEF.UGFEA065", 0, 5, 0,,, })
	Aadd( aRotina, { "Copiar", "u_GFEA65CP()", 0, 6, 0,,, })
	Aadd( aRotina, { "Imprimir", "VIEWDEF.UGFEA065", 0, 8, 0,,, })
	Aadd( aRotina, { "Dados da Conferï¿½ncia", "GFE66AP(.F.)", 0, 4, 0,,, })
	Aadd( aRotina, { "Atualizar Fiscal ERP", "u_GFE65XF(.F., '1', .T. )", 0, 10, 0,,, })

	If cERPGFE == "2"
		Aadd( aRotina, { "Atualizar Prï¿½ Nota", "u_GFE65XF(.F., '4' )", 0, 10, 0,,, })
	EndIf

	Aadd( aRotina, { "Desatualiz Fiscal ERP", "u_GFE65XD('1')", 0, 10, 0,,, })
	Aadd( aRotina, { "Atualizar Aprop Desp ERP", "u_GFE65XC(.F., '2', .T.)", 0, 11, 0,,, })

	If cERPGFE == "2"
		Aadd( aRotina, { "Atualizar Prï¿½ CT", "u_GFE65XC(.F., '5')", 0, 11, 0,,, })
	EndIf

	Aadd( aRotina, { "Desatualiz Aprop Desp ERP", "U_GFE65XD('2')", 0, 11, 0,,, })
	Aadd( aRotina, { "Gerar Fatura Avulsa", "u_GFE5GFAT(.T.)", 0, 4, 0,,, })
	Aadd( aRotina, { "Gerar Doc Complementar", "u_GFE65CC()", 0, 12, 0,,, })

	If cERPGFE == "2"
		Aadd( aRotina, { "Dados Integraï¿½ï¿½o ERP", "U_GFE65IPR()", 0, 13, 0,,, })
	EndIf

Return aRotina


Static Function ModelDef()
	Local oModel
	Local oView
	Local oStructGW3 := FWFormStruct(1, "GW3")
	Local oStructGW4 := FWFormStruct(1, "GW4")
	Local oStructGW8 := FWFormStruct(1, "GW8", {|cCampo| u_BscStrGW8(cCampo)})



	oStructGW3:AddField (If( cPaisLoc $ "ANG|PTG", "Alíquota PIS", "Aliquota PIS" ), If( cPaisLoc $ "ANG|PTG", "Alíquota PIS", "Aliquota PIS" ), "GW3_PCPIS" , "N", 12, 2, , {|| .F. }, , .F. , {||UGFEA065PCD("PIS")}, .F. , , .T. )
	oStructGW3:AddField (If( cPaisLoc $ "ANG|PTG", "Alíquota COFINS", "Aliquota COFINS" ), If( cPaisLoc $ "ANG|PTG", "Alíquota COFINS", "Aliquota COFINS" ), "GW3_PCCOFI", "N", 12, 2, , {|| .F. }, , .F. , {||UGFEA065PCD("COFINS")}, .F. , , .T. )



	oStructGW3:AddField ("UF Destinatario", "UF Destinatario", "GW3_UFDEST", "C", TamSX3("GU7_CDUF")[1], 0, , {|| .F. }, , .F. , , .F. , , .T. )
	oStructGW3:AddField ("UF Emissor", "UF Emissor", "GW3_UFEMIS", "C", TamSX3("GU7_CDUF")[1], 0, , {|| .F. }, , .F. , , .F. , , .T. )

	If GFXXB12117("GWJPRE")
		oStructGW4:AddField("OK", "OK", "_VALID", "BT", 1, 0, , , , .F. , {|| CORVALID( .T. )}, .F. , , .T. )
	EndIf







	oView := FWViewActive()
	oModel := MPFormModel():New("XUGFEA065", , , {|oModel| UGFEA065CMT(oModel)}, )
	oModel:bPost := {|oModel| u_UGFEAVP(oModel, oView)}
	oModel:SetVldActivate ( { |oMod| u_UGFE5VL( oMod ) } )







	oModel:AddFields("UGFEA065_GW3", Nil, oStructGW3, ,,)
	oModel:SetPrimaryKey({"GW3_FILIAL", "GW3_CDESP", "GW3_EMISDF", "GW3_SERDF", "GW3_NRDF", "GW3_DTEMIS"})

	If U_GFE65DCS()

		oModel:AddGrid("UGFEA065_GW4","UGFEA065_GW3", oStructGW4, {|oMod| U_G065GW4VPR(oMod)}, {|oMod| GFE065PreT(oMod), U_G065GW4VP(oMod)}, , , )
		oModel:AddGrid("UGFEA065_GW8","UGFEA065_GW4", oStructGW8, , , , ,  {|oMod| UGFEA065GW8(oMod)} )
		oModel:GetModel("UGFEA065_GW8"):SetOptional( .T. )
		oModel:GetModel("UGFEA065_GW8"):SetOnlyQuery( .T. )
		If !IsBlind()
			oModel:GetModel("UGFEA065_GW4"):SetMaxLine(9999)
		EndIf
		oModel:GetModel("UGFEA065_GW4"):SetUniqueLine({"GW4_EMISDC","GW4_SERDC","GW4_NRDC","GW4_TPDC"})
		oModel:GetModel("UGFEA065_GW4"):SetDelAllLine( .T.  )

		oModel:GetModel("UGFEA065_GW8"):SetDescription(If( cPaisLoc $ "ANG|PTG", "Elementos", "Itens" ))
		oModel:GetModel("UGFEA065_GW8"):SetUniqueLine({"GW8_CDTPDC","GW8_EMISDC","GW8_SERDC","GW8_NRDC","GW8_SEQ"})
		oModel:SetOptional("UGFEA065_GW4", .T.  )

		oModel:SetRelation("UGFEA065_GW4",{{"GW4_FILIAL","xFilial('GW4')"},{"GW4_CDESP","GW3_CDESP"},{"GW4_EMISDF","GW3_EMISDF"},{"GW4_SERDF","GW3_SERDF"},{"GW4_NRDF","GW3_NRDF"},{"GW4_DTEMIS","GW3_DTEMIS"}},"GW4_FILIAL+GW4_CDESP+GW4_EMISDF+GW4_SERDF+GW4_NRDF+GW4_DTEMIS")
		oModel:SetRelation("UGFEA065_GW8",{{"GW8_FILIAL","xFilial('GW8')"},{"GW8_CDTPDC","GW4_TPDC"},{"GW8_EMISDC","GW4_EMISDC"},{"GW8_SERDC","GW4_SERDC"},{"GW8_NRDC","GW4_NRDC"}},"GW8_FILIAL+GW8_CDTPDC+GW8_EMISDC+GW8_SERDC+GW8_NRDC")

	EndIf

	oModel:SetActivate({|oMod| u_GFEA65ACT(oMod)})

Return oModel

Static Function ViewDef()

	Local oModel		:= FWLoadModel("UGFEA065")
	Local oView     	:= Nil
	Local oStructGW3	:= FWFormStruct(2, "GW3")
	Local oStructGW4	:= FWFormStruct(2, "GW4")
	Local lCpoTES		:= u_GFE65INP()

	
	oStructGW3:AddField("GW3_PCPIS" , AllTrim(Str(Val(oStructGW3:GetFields()[AScan(oStructGW3:GetFields(), {|x| x[1] == "GW3_BASPIS"})][2]) + 1)), If( cPaisLoc $ "ANG|PTG", "Alíquota PIS", "Aliquota PIS" ), "", {If( cPaisLoc $ "ANG|PTG", "Alíquota PIS", "Aliquota PIS" )}, "N", "@E 999,999,999.99", , , , "1", "GrpImp", , , " ", .T. , , )
	oStructGW3:AddField("GW3_PCCOFI", AllTrim(Str(Val(oStructGW3:GetFields()[AScan(oStructGW3:GetFields(), {|x| x[1] == "GW3_BASCOF"})][2]) + 1)), If( cPaisLoc $ "ANG|PTG", "Alíquota COFINS", "Aliquota COFINS" ), "", {If( cPaisLoc $ "ANG|PTG", "Alíquota COFINS", "Aliquota COFINS" )}, "N", "@E 999,999,999.99", , , , "1", "GrpImp", , , " ", .T. , , )

	oStructGW3:AddGroup("GrpId" , "Identificação", "1", 2)
	oStructGW3:AddGroup("GrpOri", "Origem/Destino", "1", 2)
	oStructGW3:AddGroup("GrpVal", "Valores", "1", 2)
	oStructGW3:AddGroup("GrpDtC", "Dados da Carga", "1", 2)
	oStructGW3:AddGroup("GrpImp", "Impostos", "1", 2)
	oStructGW3:AddGroup("GrpCom", "Complementos", "1", 2)

	If lCpoTES
		oStructGW3:AddGroup("GrpInt",	"Geral"	  , "2", 2)
		oStructGW3:AddGroup("GrpDS"	, 	"Datasul" , "2", 2)
		oStructGW3:AddGroup("GrpProt",	"Protheus"	, "2", 2)

		oStructGW3:AddGroup("GrpMLA",   "MLA"     , "2", 2)

		oStructGW3:AddGroup("GrpDFt", "Dados da Fatura", "4", 2)
		oStructGW3:AddGroup("GrpFtA", "Faturamento Avulso", "4", 2)

		oStructGW3:AddGroup("GrpCsg", "Consignatário", "5", 2)
		oStructGW3:AddGroup("GrpDFO", "Documento de Frete de Origem", "5", 2)
	Else
		oStructGW3:AddGroup("GrpDFt", "Dados da Fatura", "3", 2)
		oStructGW3:AddGroup("GrpFtA", "Faturamento Avulso", "3", 2)

		oStructGW3:AddGroup("GrpCsg", "Consignatário", "4", 2)
		oStructGW3:AddGroup("GrpDFO", "Documento de Frete de Origem", "4", 2)
		oStructGW3:AddGroup("GrpInt", "Integrações", "4", 2)
	EndIf

	oStructGW3:SetProperty("GW3_CDESP" , 12, "GrpId")
	oStructGW3:SetProperty("GW3_EMISDF", 12, "GrpId")
	oStructGW3:SetProperty("GW3_NMEMIS", 12, "GrpId")
	oStructGW3:SetProperty("GW3_SERDF" , 12, "GrpId")
	oStructGW3:SetProperty("GW3_NRDF"  , 12, "GrpId")
	oStructGW3:SetProperty("GW3_DTEMIS", 12, "GrpId")
	oStructGW3:SetProperty("GW3_TPDF"  , 12, "GrpId")
	oStructGW3:SetProperty("GW3_DTENT" , 12, "GrpId")
	oStructGW3:SetProperty("GW3_CFOP"  , 12, "GrpId")
	oStructGW3:SetProperty("GW3_ORIGEM", 12, "GrpId")
	oStructGW3:SetProperty("GW3_SIT"   , 12, "GrpId")
	oStructGW3:SetProperty("GW3_USUIMP", 12, "GrpId")
	If GFXCP12117("GW3_CDTPSE")
		oStructGW3:SetProperty("GW3_CDTPSE", 12, "GrpId")
		oStructGW3:SetProperty("GW3_DSTPSE", 12, "GrpId")
	EndIf

	
	If ExistBlock("XGFEINC")
		ExecBlock("XGFEINC", .f. , .f. ,{oStructGW3, "GrpId"})
	EndIf

	
	oStructGW3:SetProperty("GW3_CDREM" , 12, "GrpOri")
	oStructGW3:SetProperty("GW3_NMREM" , 12, "GrpOri")
	oStructGW3:SetProperty("GW3_CDDEST", 12, "GrpOri")
	oStructGW3:SetProperty("GW3_NMDEST", 12, "GrpOri")

	oStructGW3:SetProperty("GW3_VLDF"  , 12, "GrpVal")
	oStructGW3:SetProperty("GW3_TAXAS" , 12, "GrpVal")
	oStructGW3:SetProperty("GW3_FRPESO", 12, "GrpVal")
	oStructGW3:SetProperty("GW3_FRVAL" , 12, "GrpVal")
	oStructGW3:SetProperty("GW3_PEDAG" , 12, "GrpVal")
	oStructGW3:SetProperty("GW3_PDGFRT", 12, "GrpVal")
	oStructGW3:SetProperty("GW3_ICMPDG", 12, "GrpVal")
	oStructGW3:SetProperty("GW3_PDGPIS", 12, "GrpVal")

	oStructGW3:SetProperty("GW3_QTDCS" , 12, "GrpDtC")
	oStructGW3:SetProperty("GW3_QTVOL" , 12, "GrpDtC")
	oStructGW3:SetProperty("GW3_VOLUM" , 12, "GrpDtC")
	oStructGW3:SetProperty("GW3_PESOR" , 12, "GrpDtC")
	oStructGW3:SetProperty("GW3_PESOC" , 12, "GrpDtC")
	oStructGW3:SetProperty("GW3_VLCARG", 12, "GrpDtC")

	oStructGW3:SetProperty("GW3_TRBIMP", 12, "GrpImp")
	oStructGW3:SetProperty("GW3_TPIMP" , 12, "GrpImp")
	oStructGW3:SetProperty("GW3_BASIMP", 12, "GrpImp")
	oStructGW3:SetProperty("GW3_PCIMP" , 12, "GrpImp")
	oStructGW3:SetProperty("GW3_VLIMP" , 12, "GrpImp")
	oStructGW3:SetProperty("GW3_IMPRET", 12, "GrpImp")
	oStructGW3:SetProperty("GW3_PCRET" , 12, "GrpImp")
	oStructGW3:SetProperty("GW3_CRDICM", 12, "GrpImp")
	oStructGW3:SetProperty("GW3_BASCOF", 12, "GrpImp")
	oStructGW3:SetProperty("GW3_VLCOF" , 12, "GrpImp")
	oStructGW3:SetProperty("GW3_BASPIS", 12, "GrpImp")
	oStructGW3:SetProperty("GW3_VLPIS" , 12, "GrpImp")
	oStructGW3:SetProperty("GW3_NATFRE", 12, "GrpImp")
	oStructGW3:SetProperty("GW3_CRDPC" , 12, "GrpImp")

	oStructGW3:SetProperty("GW3_OBS"   , 12, "GrpCom")
	oStructGW3:SetProperty("GW3_CTE"   , 12, "GrpCom")
	oStructGW3:SetProperty("GW3_TPCTE" , 12, "GrpCom")

	oStructGW3:SetProperty("GW3_FILFAT", 12, "GrpDFt")
	oStructGW3:SetProperty("GW3_EMIFAT", 12, "GrpDFt")
	oStructGW3:SetProperty("GW3_SERFAT", 12, "GrpDFt")
	oStructGW3:SetProperty("GW3_NRFAT" , 12, "GrpDFt")
	oStructGW3:SetProperty("GW3_DTEMFA", 12, "GrpDFt")
	If GFXCP12116("GW3","GW3_DTVCFT")
		oStructGW3:SetProperty("GW3_DTVCFT", 12, "GrpDFt")
	EndIf

	If GFXCP12117("GW3_MOTFIN")
		oStructGW3:SetProperty("GW3_SITFIN", 12, "GrpDFt")
		oStructGW3:SetProperty("GW3_DTFIN" , 12, "GrpDFt")
		oStructGW3:SetProperty("GW3_MOTFIN", 12, "GrpDFt")
	EndIf

	oStructGW3:SetProperty("GW3_DTVNFT", 12, "GrpFtA")

	oStructGW3:SetProperty("GW3_CDCONS", 12, "GrpCsg")
	oStructGW3:SetProperty("GW3_NMCONS", 12, "GrpCsg")

	oStructGW3:SetProperty("GW3_ORINR" , 12, "GrpDFO")
	oStructGW3:SetProperty("GW3_ORISER", 12, "GrpDFO")
	oStructGW3:SetProperty("GW3_ORIDTE", 12, "GrpDFO")

	oStructGW3:SetProperty("GW3_TPCTB" , 12, "GrpInt")
	oStructGW3:SetProperty("GW3_ACINT" , 12, "GrpInt")
	oStructGW3:SetProperty("GW3_DSOFDT", 12, "GrpInt")
	oStructGW3:SetProperty("GW3_DTFIS" , 12, "GrpInt")
	oStructGW3:SetProperty("GW3_SITFIS", 12, "GrpInt")
	oStructGW3:SetProperty("GW3_MOTFIS", 12, "GrpInt")
	oStructGW3:SetProperty("GW3_DTREC" , 12, "GrpInt")
	oStructGW3:SetProperty("GW3_SITREC", 12, "GrpInt")
	oStructGW3:SetProperty("GW3_MOTREC", 12, "GrpInt")

	If lCpoTES
		oStructGW3:SetProperty("GW3_DSOFIT", 12, "GrpDS")
		oStructGW3:SetProperty("GW3_DSOFDT", 12, "GrpDS")
		oStructGW3:SetProperty("GW3_PRITDF", 12, "GrpProt")
		oStructGW3:SetProperty("GW3_CPDGFE", 12, "GrpProt")
		oStructGW3:SetProperty("GW3_TES",    12, "GrpProt")
		oStructGW3:SetProperty("GW3_CONTA",  12, "GrpProt")
		oStructGW3:SetProperty("GW3_ITEMCT", 12, "GrpProt")
		oStructGW3:SetProperty("GW3_CC",	  12, "GrpProt")
	Else
		oStructGW3:SetProperty("GW3_DSOFIT", 12, "GrpInt")
		oStructGW3:SetProperty("GW3_PRITDF", 12, "GrpInt")
	EndIf
	If GFXTB12117("GWC")
		oStructGW3:SetProperty("GW3_SITCUS", 12, "GrpProt")
		oStructGW3:SetProperty("GW3_DESCUS", 12, "GrpProt")
		oStructGW3:SetProperty("GW3_DTCUS",  12, "GrpProt")
		oStructGW3:SetProperty("GW3_USUCUS", 12, "GrpProt")
		oStructGW3:SetProperty("GW3_MOTCUS", 12, "GrpProt")
	EndIf
	If oStructGW3:HasField("GW3_SITMLA") .And.  lCpoTes
		oStructGW3:SetProperty("GW3_SITMLA", 12, "GrpMLA")
		oStructGW3:SetProperty("GW3_MOTMLA", 12, "GrpMLA")
		oStructGW3:SetProperty("GW3_HRAPR" , 12, "GrpMLA")
	EndIf

	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("UGFEA065_GW3", oStructGW3)

	if SuperGetMv("MV_ERPGFE", .F. , "2") == "1" .and.  lCpoTES
		oStructGW3:RemoveField("GW3_PRITDF")
		oStructGW3:RemoveField("GW3_TES")
		oStructGW3:RemoveField("GW3_CONTA")
		oStructGW3:RemoveField("GW3_ITEMCT")
		oStructGW3:RemoveField("GW3_CC")
		oStructGW3:RemoveField("GW3_CPDGFE")
	endif

	oStructGW3:RemoveField("GW3_DSOFUM")
	oStructGW3:RemoveField("GW3_DSOFCF")
	oStructGW3:RemoveField("GW3_DSOFCT")
	oStructGW3:RemoveField("GW3_DSOFCS")

	If GFXXB12117("GWJPRE")
		oStructGW4:AddField( "_VALID"  ,"00" , "OK"          , "OK"      , {} , "BT" ,"@BMP", NIL, NIL, .F. , NIL, NIL, NIL,	NIL, NIL, .T.  )
	EndIf

	oStructGW4:RemoveField("GW4_FILIAL")
	oStructGW4:RemoveField("GW4_CDESP")
	oStructGW4:RemoveField("GW4_EMISDF")
	oStructGW4:RemoveField("GW4_SERDF")
	oStructGW4:RemoveField("GW4_NRDF")
	oStructGW4:RemoveField("GW4_DTEMIS")
	oView:AddGrid("UGFEA065_GW4", oStructGW4)

	oView:CreateHorizontalBox("MASTER", 55)
	oView:CreateHorizontalBox("DETAIL", 45)

	oView:CreateFolder("IDFOLDER", "DETAIL")
	oView:AddSheet("IDFOLDER", "IDSHEET01", If( cPaisLoc $ "ANG|PTG", "Documentos de carga", "Documentos de Carga" ))

	oView:CreateVerticalBox("EMBAIXOESQ", 90,,, "IDFOLDER", "IDSHEET01")
	oView:CreateVerticalBox("EMBAIXODIR", 10,,, "IDFOLDER", "IDSHEET01")

	oView:SetOwnerView( "UGFEA065_GW3" , "MASTER"     )
	oView:SetOwnerView( "UGFEA065_GW4" , "EMBAIXOESQ" )

	oView:AddOtherObject("OTHER_PANEL", {|oPanel,oModel| UGFEA065ADD(oPanel,oModel)})
	oView:SetOwnerView("OTHER_PANEL","EMBAIXODIR")
	If GFXXB12117("GWJPRE")
		oView:AddUserButton("Legenda","",{|| LEGVALID() })
	EndIf

Return oView





User Function GFE65DCS()
	Local lGera 	:= .F.
	Local cIntGFE2:= SuperGetMv("MV_INTGFE2", .F. ,"2")


	If IsInCallStack("u_GFE65In") .And.  cIntGFE2 == "2"

		dbSelectArea("GW4")
		GW4->( dbSetOrder(1) )
		GW4->( dbSeek(xFilial("GW4") + GW3->GW3_EMISDF + GW3->GW3_CDESP + GW3->GW3_SERDF + GW3->GW3_NRDF) )

		While !GW4->( Eof() ) .And.  GW4->GW4_FILIAL == xFilial("GW4") .And.  GW4->GW4_EMISDF == GW3->GW3_EMISDF .And.  GW4->GW4_CDESP == GW3->GW3_CDESP .And.  GW4->GW4_SERDF == GW3->GW3_SERDF .And.  GW4->GW4_NRDF == GW3->GW3_NRDF

			dbSelectArea("GV5")
			GV5->( dbSetOrder(1) )
			If GV5->( dbSeek(xFilial("GV5") + GW4->GW4_TPDC) ) .And.  GV5->GV5_SENTID <> "2"
				lGera := .T.
				Exit
			EndIf

			GW4->( dbSkip() )
		EndDo

	Else
		lGera := .T.
	EndIf

Return lGera














User Function BscStrGW8(cCampo)
	Local aCampos	:= {}
	Local lRet   	:= .F.


	aAdd( aCampos, "GW8_FILIAL")
	aAdd( aCampos, "GW8_CDTPDC")
	aAdd( aCampos, "GW8_EMISDC")
	aAdd( aCampos, "GW8_SERDC ")
	aAdd( aCampos, "GW8_NRDC  ")
	aAdd( aCampos, "GW8_ITEM  ")
	aAdd( aCampos, "GW8_SEQ   ")
	aAdd( aCampos, "GW8_INFO1 ")

	lRet := ( aScan( aCampos, { |x| PadR( cCampo, 10 ) == x } ) > 0 )

Return lRet



User Function UGFEAVP(oModel,oViewImp)
	Local aArea      	:= GetArea()
	Local aAreaGW3   	:= GW3->( GetArea() )
	Local aAreaGW4   	:= GW4->( GetArea() )
	Local nOpc       	:= (oModel:GetOperation())
	Local oView      	:= oViewImp
	Local lAprovar   	:= .F.
	Local nBasImp    	:= FwFldGet("GW3_BASIMP" )
	Local nVlDf      	:= FwFldGet("GW3_VLDF"   )
	Local nPedag     	:= FwFldGet("GW3_PEDAG"  )
	Local cTrbImp    	:= FwFldGet("GW3_TRBIMP" )
	Local nCont      	:= 0, nQtdPISCOF := 0, nQtdTotal := 0
	Local oModelGW4
	Local oModelGW3  	:= oModel:GetModel("UGFEA065_GW3")
	Local nVlPIS     	:= 0, nVlCO := 0, nVlBasePIS := 0, nVlBaseCO := 0, nVlDoc := 0
	Local nLine
	Local lTemDC     	:= .F.
	Local nI
	Local cChaveDF   	:= ""
	Local cUniDF      := SuperGetMV("MV_GFEVLDT", .F. ,"3")
	Local cCredIcms   := SuperGetMV("MV_GFECRIC", .F. ,"1")
	Local cIcmsSt     := SuperGetMV("MV_ICMSST" , .F. ,"1")
	Local aFil       	:= GFEGETFIL(cEmpAnt)
	Local aGVTStru
	Local lDCUsoCons 	:= .F.
	Local cCredPC
	Local cChvCte    	:= FwFldGet("GW3_CTE")
	Local cTpCte     	:= FwFldGet("GW3_TPCTE")
	Local cEmissor   	:= FwFldGet("GW3_EMISDF")
	Local cSerie     	:= FwFldGet("GW3_SERDF")
	Local cNumero    	:= FwFldGet("GW3_NRDF")
	Local dDataEmis  	:= FwFldGet("GW3_DTEMIS")
	Local aRetVldCte 	:= {}
	Local aRet       	:= { .T. ,"",""}
	Local cCdEsp     	:= FwFldGet("GW3_CDESP" )
	Local cRatFis    	:= SUPERGETMV("MV_ATUCTRC", .F. ,"1")
	Local lNfEnt     	:= .F.
	Local lChvCte    	:= .F.
	Local cCredPCTF
	Local aGVTStruct
	Local lTribPC    	:= .F.
	Local lTrechoPC  	:= .F.
	Local lEspCTe    	:= .T.
	Local lEmiCTe    	:= .F.
	Local lCusto     	:= .F.
	Local cNrDF      	:= ""
	Local nQtAlg     	:= 0
	Local lRetPE		:= .F.

	Local cCidRem
	Local cCidDes
	Local cCidTrp
	Local cCidFil
	Local cCFOFR1 	:= SuperGetMV("MV_CFOFR1", .T. ,"")
	Local cCFOFR2 	:= SuperGetMV("MV_CFOFR2", .T. ,"")
	Local cCFOFR3 	:= SuperGetMV("MV_CFOFR3", .T. ,"")
	Local cCFOFR4 	:= SuperGetMV("MV_CFOFR4", .T. ,"")
	Local nERP    	:= SuperGetMV("MV_ERPGFE", .T. ,"2")
	Local cTpImp  	:= ""
	Local aForLoj 	:= ""

	Local cTes			:= ""
	Local cTesAuto	:= SuperGetMV("MV_TESGFE", .T. ,"1")
	Local lCpoTES 	:= u_GFE65INP()

	Local lAspaInic 	:= .F.
	Local lAspaFim  	:= .F.
	Local cFormCredICMS := SuperGetMV("MV_CRDPAR", .F. ,"1")
	Local lCrdSim       := .F.
	Local nLinha
	Local aArrFil := {}

	Local lAprovMLA := SuperGetMv("MV_ERPGFE", .F. ,"1") == "1" .And.  SuperGetMv("MV_DFMLA", .F. ,"1") $ "2|3"

	Private cMotBloq 	:= ""


	dbSelectArea("GVT")
	aGVTStruct := GVT->( dbStruct() )

	IIf (nOpc == 4, cSitAnt := GW3->GW3_SIT, cSitAnt := "")
	If GFXCP12117("GW3_SITCUS")
		IIf (nOpc == 4, cSitCusAnt := GW3->GW3_SITCUS, cSitCusAnt := "")
	EndIf

	If nOpc <> 5
		lChvCte := AScan(aGVTStruct, {|x| x[1] == "GVT_CHVCTE"}) <> 0
	EndIf

	If nOpc == 3 .Or.  nOpc == 4


		If Empty(oModelGW3:GetValue("GW3_CFOP"))
			oModelGW4 := oModel:GetModel("UGFEA065_GW4")
			dbSelectArea("GW1")
			GW1->( dbSetOrder(1) )
			GW1->( dbSeek(If(Empty(FwFldGet("GW4_FILIAL")),xFilial("GW4"),FwFldGet("GW4_FILIAL"))+FwFldGet("GW4_TPDC")+FwFldGet("GW4_EMISDC")+FwFldGet("GW4_SERDC")+FwFldGet("GW4_NRDC")) )

			dbSelectArea("GWH")
			GWH->( dbSetOrder(2) )
			If GWH->( dbSeek(GW1->GW1_FILIAL+GW1->GW1_CDTPDC+GW1->GW1_EMISDC+GW1->GW1_SERDC+GW1->GW1_NRDC) )

				While !Eof() .And.  GW1->GW1_FILIAL+GW1->GW1_CDTPDC+GW1->GW1_EMISDC+GW1->GW1_SERDC+GW1->GW1_NRDC == GWH->GWH_FILIAL+GWH->GWH_CDTPDC+GWH->GWH_EMISDC+GWH->GWH_SERDC+GWH->GWH_NRDC

					dbSelectArea("GWF")
					GWF->( dbSetOrder(1) )
					GWF->( dbSeek(GWH->GWH_FILIAL+GWH->GWH_NRCALC) )

					dbSelectArea("GWU")
					GWU->( dbSetOrder(5) )



					If GWU->( dbSeek(GWF->GWF_TRANSP + xFilial("GWU")+ oModelGW4:GetValue("GW4_TPDC") + oModelGW4:GetValue("GW4_EMISDC") + oModelGW4:GetValue("GW4_SERDC") + oModelGW4:GetValue("GW4_NRDC") + GWF->GWF_SEQTRE ))

						If FwFldGet("GW3_TPDF") == GWF->GWF_TPCALC .AND.  (!GFXCP12117("GW3_CDTPSE") .Or.  FwFldGet("GW3_CDTPSE") == GWF->GWF_CDTPSE)
							cCidRem := GWF->GWF_CIDORI
							cCidDes := GWF->GWF_CIDDES
						EndIf
					EndIf
					GWH->( dbSkip() )
				EndDo
			EndIf

			If Empty(cCidRem)
				GWU->( dbSetOrder(5) )

				GWU->( dbSeek(oModelGW3:GetValue("GW3_EMISDF")+xFilial("GWU")+ oModelGW4:GetValue("GW4_TPDC") + oModelGW4:GetValue("GW4_EMISDC") + oModelGW4:GetValue("GW4_SERDC") + oModelGW4:GetValue("GW4_NRDC")) )
				cCidRem := Posicione("GU3",1,XFILIAL("GU3")+oModelGW3:GetValue("GW3_CDREM"),"GU3_NRCID")
				cCidDes := GWU->GWU_NRCIDD
			EndIf

			If FwFldGet("GW3_TPIMP") == "2"
				aArrFil := FWArrFilAtu()

				cCidTrp := Posicione("GU3",1,XFILIAL("GU3")+oModelGW3:GetValue("GW3_EMISDF"),"GU3_NRCID")
				cCidFil := Posicione("GU3",11,XFILIAL("GU3")+aArrFil[18],"GU3_NRCID")

				If Empty(FwFldGet("GW3_CFOP")) .And.  Posicione("GU7",1, xfilial("GU7")+cCidFil, "GU7_NRCID") == Posicione("GU7",1, xfilial("GU7")+cCidTrp, "GU7_NRCID")
					oModelGW3:LoadValue("GW3_CFOP", cCFOFR3)
				ElseIf Empty(FwFldGet("GW3_CFOP"))
					oModelGW3:LoadValue("GW3_CFOP", cCFOFR4)
				EndIf
			Else
				If Posicione("GU7",1, xfilial("GU7")+cCidRem, "GU7_CDUF") == Posicione("GU7",1, xfilial("GU7")+cCidDes, "GU7_CDUF")
					oModelGW3:LoadValue("GW3_CFOP", cCFOFR1)
				Else
					oModelGW3:LoadValue("GW3_CFOP", cCFOFR2)
				EndIf
			EndIf

			aSize(aArrFil,0)

		EndIf


		dbSelectArea("GVT")
		dbSetOrder(1)
		If dbSeek(XFILIAL("GVT") + oModelGW3:GetValue("GW3_CDESP"))
			If GVT->(FieldPos("GVT_CHVCTE")) > 0 .And.  GVT->GVT_CHVCTE == "3"
				lEspCTe := .F.
			EndIf
		EndIf

		dbSelectArea("GU3")
		dbSetOrder(1)
		If dbSeek(XFILIAL("GU3") + oModelGW3:GetValue("GW3_EMISDF"))
			If GU3->GU3_CTE == "1"
				lEmiCTe := .T.
			EndIf
		EndIf

		If !empty(cChvCte) .And.  lEspCTe .And.  lEmiCTe
			If u_GFE065VLDV(cChvCte) .and.  Empty(cTpCte) .and.  !IsInCallStack("GFEA115PRO")
				oModel:SetErrorMessage(,,,,,"Tipo do CT-e em branco.","ï¿½ necessï¿½rio preencher o tipo do CT-e.")
				Return .F.
			EndIf
		EndIf

		If oModelGW3:GetValue("GW3_TPDF") <> "3" .And.  oModelGW3:GetValue("GW3_VLDF") == 0
			Help( ,, "HELP",, "Nï¿½o ï¿½ permitido criar um documento de frete deste tipo com valor zerado.", 1, 0)
			Return .F.
		EndIf

		If GFXTB12117("GWC") .And.  u_UGFEACTA()
			If AllTrim(FwFldGet("GW3_DESCUS")) == ""
				Help( ,, "HELP",, "Necessï¿½rio preencher o cï¿½digo da despesa de custo de frete.", 1, 0)
				Return .F.
			EndIf

			If AllTrim(Posicione("DT7",1,xFilial("DT7")+FwFldGet("GW3_DESCUS"), "DT7_CODDES")) == ""
				Help( ,, "HELP",, "Despesa de custo de frete nï¿½o cadastrado no Protheus.", 1, 0)
				Return .F.
			EndIf
		EndIf
	EndIf

	If nOpc == 3

		If Empty(oModelGW3:GetValue("GW3_CTE")) .and.  IsInCallStack("U_UGFEA065")
			oModelGW3:LoadValue("GW3_TPCTE", "")
		EndIf


		If AScan(aGVTStruct, {|x| x[1] == "GVT_FORMNM"}) <> 0

			dbSelectArea("GVT")
			GVT->( dbSetOrder(1) )
			If GVT->( dbSeek(xFilial("GVT") + oModelGW3:GetValue("GW3_CDESP")) )

				cNrDF  := AllTrim(oModelGW3:GetValue("GW3_NRDF"))
				nQtAlg := Iif(GVT->GVT_QTALG > 0, GVT->GVT_QTALG, TamSX3("GW3_NRDF")[1])


				If GVT->GVT_ZEROS $ "2|3"
					cNrDF := u_GFEZapZero(cNrDF)
					If GVT->GVT_ZEROS == "3" .And.  Len(cNrDF) < nQtAlg
						cNrDF := PadL(cNrDF, nQtAlg, "0")
					EndIf
				EndIf

				If Len(cNrDF) > nQtAlg
					oModel:SetErrorMessage(,,,,,"A quantidade de caracteres no Nï¿½mero do Documento de Frete ultrapassa o delimitado no cadastro da Espï¿½cie.","Informe um nï¿½mero com quantidade menor de caracteres.")
					Return .F.
				EndIf


				oModelGW3:LoadValue("GW3_NRDF", cNrDF)




				lAspaInic := SUBSTR(AllTrim(oModelGW3:GetValue("GW3_NRDF")),1,1) == "'"
				lAspaFim  := SUBSTR(AllTrim(oModelGW3:GetValue("GW3_NRDF")),Len(AllTrim(oModelGW3:GetValue("GW3_NRDF"))),1) == "'"

				If  lAspaInic .Or.  lAspaFim
					If GVT->GVT_FORMNM == "1"
						oModel:SetErrorMessage(,,,,,"Nï¿½mero do Documento de Frete com algarismos em formato diferente do parametrizado no cadastro de Espï¿½cie.","Informe um nï¿½mero com algarismos em formato compatï¿½vel com o parametrizado no cadastro de Espï¿½cie do Documento de Frete.")
						Return .F.
					ElseIf GVT->GVT_FORMNM == "2"
						oModel:SetErrorMessage(,,,,,"Nï¿½mero do Documento de Frete com algarismos ou letras em formato diferente do parametrizado no cadastro de Espï¿½cie.","Informe um nï¿½mero com algarismos ou letras em formato compatï¿½vel com o parametrizado no cadastro de Espï¿½cie do Documento de Frete.")
						Return .F.

					ElseIf GVT->GVT_FORMNM == "3"
						If lAspaInic .AND.   !lAspaFim
							oModelGW3:LoadValue("GW3_NRDF",'"'+SUBSTR(AllTrim(oModelGW3:GetValue("GW3_NRDF")),2,LEN(AllTrim(oModelGW3:GetValue("GW3_NRDF")))))
						ElseIf !lAspaInic .AND.  lAspaFim
							oModelGW3:LoadValue("GW3_NRDF",SUBSTR(AllTrim(oModelGW3:GetValue("GW3_NRDF")),1,LEN(AllTrim(oModelGW3:GetValue("GW3_NRDF")))-1)+'"')
						ElseIf lAspaInic .AND.  lAspaFim
							oModelGW3:LoadValue("GW3_NRDF",'"'+SUBSTR(AllTrim(oModelGW3:GetValue("GW3_NRDF")),2,LEN(AllTrim(oModelGW3:GetValue("GW3_NRDF")))-1)+'"')
						EndIf
					EndIf
				EndIf

				If GVT->GVT_FORMNM == "1" .And.  !GFEVldForm(AllTrim(oModelGW3:GetValue("GW3_NRDF")), "IsDigit")
					oModel:SetErrorMessage(,,,,,"Nï¿½mero do Documento de Frete com algarismos em formato diferente do parametrizado no cadastro de Espï¿½cie.","Informe um nï¿½mero com algarismos em formato compatï¿½vel com o parametrizado no cadastro de Espï¿½cie do Documento de Frete.")
					Return .F.
				ElseIf GVT->GVT_FORMNM == "2" .And.  !GFEVldForm(AllTrim(oModelGW3:GetValue("GW3_NRDF")), "LetterOrNum")
					oModel:SetErrorMessage(,,,,,"Nï¿½mero do Documento de Frete com algarismos ou letras em formato diferente do parametrizado no cadastro de Espï¿½cie.","Informe um nï¿½mero com algarismos ou letras em formato compatï¿½vel com o parametrizado no cadastro de Espï¿½cie do Documento de Frete.")
					Return .F.
				EndIf

			EndIf

		EndIf

		If Empty(cUniDF)
			cUniDF := "3"
		EndIf

		If cUniDF == "1"
			cChaveDF := (oModelGW3:GetValue("GW3_NRDF"))
		ElseIf cUniDF == "2"
			cChaveDF := (oModelGW3:GetValue("GW3_NRDF")) + (oModelGW3:GetValue("GW3_SERDF"))
		ElseIf cUniDF == "3"
			cChaveDF := (oModelGW3:GetValue("GW3_NRDF")) + (oModelGW3:GetValue("GW3_SERDF")) + DToS(oModelGW3:GetValue("GW3_DTEMIS"))
		EndIf

		For nI := 1 To Len(aFil)

			dbSelectArea("GW3")
			GW3->( dbSetOrder(11) )
			If GW3->( dbSeek(aFil[nI][1] + oModelGW3:GetValue("GW3_CDESP") + oModelGW3:GetValue("GW3_EMISDF") + cChaveDF) )

				oModel:SetErrorMessage(,,,,,"Jï¿½ existe Documento de Frete cadastrado com a chave informada na Filial " + Iif(aFil[nI][1] == cFilAnt, "corrente", aFil[nI][1] + " - " + aFil[nI][2]),"Verifique se os dados informados estï¿½o corretos.")

				RestArea(aAreaGW3)
				RestArea(aAreaGW4)

				Return .F.
			EndIf
		Next
		cValDF := AllTrim(oModelGW3:GetValue("GW3_NRDF"))
		oModelGW3:SetValue("GW3_NRDF",cValDF)

		cValSerDF := AllTrim(oModelGW3:GetValue("GW3_SERDF"))
		oModelGW3:SetValue("GW3_SERDF",cValSerDF)

		RestArea(aAreaGW3)
		RestArea(aAreaGW4)
	EndIf

	lConferiu := .F.

	If !IsInCallStack("U_GFE65In")

		oModelGW4 := oModel:GetModel("UGFEA065_GW4")
		nLine     := oModelGW4:GetLine()

		If nOpc == 3


			cCredPC   := SuperGetMV("MV_GFEPC" , .F. ,"1",cFilAnt)
			cCredPCTF := SuperGetMV("MV_PICOTR", .F. ,"2",cFilAnt)

			If Empty(cCredPC)
				cCredPC := "1"
			EndIf

			If Empty(cCredPCTF)
				cCredPCTF := "2"
			EndIf

			If cCredPC == "1"

				If (Posicione("GU3", 1, xFilial("GU3") + oModelGW3:GetValue("GW3_CDREM"), "GU3->GU3_EMFIL") == "1" .And.  Posicione("GU3", 1, xFilial("GU3") + oModelGW3:GetValue("GW3_CDDEST"), "GU3->GU3_EMFIL") == "1")


					If SubStr(Posicione("GU3", 1, xFilial("GU3") + oModelGW3:GetValue("GW3_CDREM"), "GU3->GU3_IDFED"), 1, 8) == SubStr(Posicione("GU3", 1, xFilial("GU3") + oModelGW3:GetValue("GW3_CDDEST"), "GU3->GU3_IDFED"), 1, 8) .And.  cCredPCTF == "2"
						oModelGW3:LoadValue("GW3_CRDPC", "2")
					Else
						oModelGW3:LoadValue("GW3_CRDPC", "1")
					EndIf
				Else
					oModelGW3:LoadValue("GW3_CRDPC", "1")
				EndIf
			EndIf

			dbSelectArea("GVT")
			GVT->( dbSetOrder(1) )
			If GVT->( dbSeek(xFilial("GVT") + oModelGW3:GetValue("GW3_CDESP")) ) .And.  GVT->GVT_TPIMP == "3"
				oModelGW3:LoadValue("GW3_SITFIS", "6")
			EndIf


			If !oModelGW4:IsEmpty()
				DbSelectArea("GV5")
				GV5->(DbSetOrder(1))
				For nI := 1 To oModelGW4:Length()
					oModelGW4:GoLine(nI)
					If !oModelGW4:IsDeleted()
						If GV5->(DbSeek(xFilial("GV5")+oModelGW4:GetValue("GW4_TPDC")))
							If GV5->GV5_SENTID == "1"
								lNfEnt := .T.
							EndIf
							If GV5->GV5_FRCTB == "2"
								lCusto := .T.
							EndIf
							If lNfEnt .And.  lCusto
								Exit
							EndIf
						EndIf
					EndIf
				next

				oModelGW4:GoLine(nLine)
			EndIf




			If (nERP == "1" .And.  (!lCusto .Or.  (oModelGW3:GetValue("GW3_TPDF") == "3" .And.  oModelGW3:GetValue("GW3_VLDF") == 0))) .Or.  (nERP == "2" .And.  !lCusto)
				oModelGW3:SetValue("GW3_SITFIS", "1")
				oModelGW3:SetValue("GW3_SITREC", "6")
			ElseIf (nERP == "1" .And.  cRatFis == "2" .And.  lCusto) .Or.  (nERP == "2" .And.  lCusto)
				oModelGW3:SetValue("GW3_SITFIS", "6")
				oModelGW3:SetValue("GW3_SITREC", "1")
			Else
				oModelGW3:SetValue("GW3_SITREC", "1")
				oModelGW3:SetValue("GW3_SITFIS", "1")
			EndIf



			oModelGW3:SetValue("GW3_TPCTB", Iif(lCusto,"2","1"))

		EndIf






		If nOpc == 3 .Or.  nOpc == 4

			If !oModelGW4:IsEmpty()
				oModelGW4:GoLine(1)
				If !oModelGW4:IsDeleted()
					dbSelectArea("GW1")
					GW1->( dbSetOrder(1) )

					If GW1->( dbSeek(xFilial("GW1") + oModelGW4:GetValue("GW4_TPDC") + oModelGW4:GetValue("GW4_EMISDC") + oModelGW4:GetValue("GW4_SERDC") + oModelGW4:GetValue("GW4_NRDC")) ) .And.  GW1->GW1_USO == "2"
						lDCUsoCons := .T.
					EndIf
				EndIf

				oModelGW4:GoLine(nLine)
			EndIf

		EndIf

		If nOpc <> 5



			If ExistBlock("GFEA0656")
				lRetPE := ExecBlock("GFEA0656", .F. , .F. )
				If ValType(lRetPE) == "L" .And.  !lRetPE
					Return .F.
				EndIf
			Else
				If !oModelGW4:IsEmpty()
					For nI := 1 To oModelGW4:Length()
						oModelGW4:GoLine(nI)
						If !oModelGW4:IsDeleted() .And.  !Empty(oModelGW4:GetValue("GW4_NRDC"))
							lTemDC := .T.
							Exit
						EndIf
					next

					oModelGW4:GoLine(nLine)

					If !lTemDC
						oModel:SetErrorMessage(,,,,,"Nï¿½o existem Documentos de Carga relacionados ao Documento de Frete.","O Documento de Frete deve possuir Documentos de Carga relacionados.")
						Return .F.
					EndIf
				Else
					oModel:SetErrorMessage(,,,,,"Nï¿½o existem Documentos de Carga relacionados ao Documento de Frete.","O Documento de Frete deve possuir Documentos de Carga relacionados.")
					Return .F.
				EndIf

			EndIf


			If ExistBlock("XGFEMODE")
				cRet := ExecBlock("XGFEMODE", .f. , .f. ,{oModelGW3, oModelGW4})
				If cRet == .F.
					Return .F.
				EndIf
			EndIf


			If FwFldGet("GW3_TPDF") <> "3"

				If nBasImp > 0 .And.  nBasImp <> nVlDf .And.  !(cTrbImp $ "53") .And.  Abs(nBasImp - nVlDf) <> nPedag
					oModel:SetErrorMessage(,,,,,"Documentos com Base de Imposto menor que o valor do documento devem ter tipo de tributação Reduzido","Informe uma Base de Imposto maior ou altere o tipo de tributaï¿½ï¿½o do documento.")
					Return .F.
				EndIf
			EndIf


			If !Empty(FwFldGet("GW3_CDCONS"))
				If Posicione("GU3", 1, xFilial("GU3") + FwFldGet("GW3_CDCONS"), "GU3_EMFIL") == "2"
					oModel:SetErrorMessage(,,,,,"O consignatï¿½rio do frete nï¿½o ï¿½ Filial.","O consignatário deve ser Filial")
					Return .F.
				EndIf
			EndIf
















			If FwFldGet("GW3_TRBIMP") == "2"
				If FwFldGet("GW3_VLIMP") <> 0.OR.FwFldGet("GW3_BASIMP") <> 0
					oModel:SetErrorMessage(,,,,,"Valor e Base de Imposto maiores que zero.","Quando a tributaï¿½ï¿½o informada for 'Isento/Nï¿½o-tributado', o Valor e a Base de Imposto devem ser iguais a zero.")
					Return .F.
				EndIf
			ElseIf FwFldGet("GW3_TRBIMP") == "6"
				If FwFldGet("GW3_BASIMP") == 0
					oModel:SetErrorMessage(,,,,,"Base de Imposto nï¿½o informada.","Quando a tributaï¿½ï¿½o for 'Outros', a Base de Imposto deve ser informada.")
					Return .F.
				EndIf
			Else
				If FwFldGet("GW3_VLIMP") == 0 .Or.  FwFldGet("GW3_BASIMP") == 0 .Or.  FwFldGet("GW3_PCIMP") == 0
					oModel:SetErrorMessage(,,,,,"Valor, Base e Alï¿½quota de Imposto nï¿½o informados.","Quando a tributaï¿½ï¿½o for 'Tributado', 'Substituiï¿½ï¿½o Tributï¿½ria', 'Diferido' ou 'Presumido', o Valor, a Base e a Alï¿½quota do Imposto devem ser informados.")
					Return .F.
				EndIf
			EndIf



			If oModelGW3:GetValue("GW3_TRBIMP") $ "3;4;7"


				If cIcmsSt == "1"
					oModelGW3:LoadValue("GW3_CRDICM", "1")
				Else
					oModelGW3:LoadValue("GW3_CRDICM", "2")
				EndIf
			ElseIf oModelGW3:GetValue("GW3_TRBIMP") $ "2;6"

				oModelGW3:LoadValue("GW3_CRDICM", "2")
			Else

				oModelGW3:LoadValue("GW3_CRDICM", "1")
			EndIf



			If oModelGW3:GetValue("GW3_CRDICM") == "1"
				If cCredIcms == "1"


					If cFormCredICMS == "2"

						nLinha := 1

						For nLinha := 1 To oModelGW4:GetQtdLine()
							oModelGW4:GoLine( nLinha )
							If !oModelGW4:isDeleted()

								dbSelectArea("GW8")
								dbSetOrder(2)
								If dbSeek(xFilial("GW8")+FwFldGet("GW4_TPDC", nLinha)+FwFldGet("GW4_EMISDC", nLinha)+FwFldGet("GW4_SERDC", nLinha)+FwFldGet("GW4_NRDC", nLinha))


									While !EoF() .And.  GW8->GW8_FILIAL+GW8->GW8_CDTPDC+GW8->GW8_EMISDC+GW8->GW8_SERDC+GW8->GW8_NRDC == xFilial("GW8")+FwFldGet("GW4_TPDC", nLinha)+FwFldGet("GW4_EMISDC", nLinha)+FwFldGet("GW4_SERDC", nLinha)+FwFldGet("GW4_NRDC", nLinha)



										If GW8->GW8_CRDICM == "1"

											lCrdSim := .T.
											EXIT
										EndIf
										GW8->(dbSkip())
									EndDo
								EndIf
							EndIf
						next



						If lCrdSim == .F.

							oModelGW3:LoadValue("GW3_CRDICM", "2")
						EndIf
					Else


						If lDCUsoCons
							dbSelectArea("GW1")
							dbSetOrder(1)
							dbSeek(xFilial("GW1")+oModelGW3:GetValue("GW3_EMISDF")+oModelGW3:GetValue("GW3_CDESP")+oModelGW3:GetValue("GW3_SERDF")+oModelGW3:GetValue("GW3_NRDF")+DTOS(oModelGW3:GetValue("GW3_DTEMIS")))

							If(Posicione("GV5", 1, xFilial("GV5") + FwFldGet("GW4_TPDC"), "GV5_SENTID") == "1")

								oModelGW3:LoadValue("GW3_CRDICM","2")
							EndIF
						EndIF
					EndIf
				Else

					oModelGW3:LoadValue("GW3_CRDICM","2")
				EndIf
			EndIf



			lAprovar := U_UGFE5CO(oModel)
			If !lAprovar
				oModel:LoadValue("UGFEA065_GW3" ,"GW3_SIT","2")
				oModel:LoadValue("UGFEA065_GW3" ,"GW3_USUBLQ",cUserName)
				oModel:LoadValue("UGFEA065_GW3" ,"GW3_MOTBLQ",cMotBloq)
				oModel:LoadValue("UGFEA065_GW3" ,"GW3_DTBLQ",DDATABASE)

				oModel:LoadValue("UGFEA065_GW3" ,"GW3_MOTAPR","")
				oModel:LoadValue("UGFEA065_GW3" ,"GW3_DTAPR" ,CtoD("  /  /  "))
				oModel:LoadValue("UGFEA065_GW3" ,"GW3_USUAPR","")
			Else
				oModel:SetValue("UGFEA065_GW3","GW3_SIT","3")
				oModel:LoadValue("UGFEA065_GW3" ,"GW3_USUBLQ","")
				oModel:SetValue("UGFEA065_GW3","GW3_MOTBLQ","")
				oModel:SetValue("UGFEA065_GW3","GW3_MOTREC","")
				oModel:SetValue("UGFEA065_GW3","GW3_MOTFIS","")
				oModel:SetValue("UGFEA065_GW3","GW3_DTAPR",DDATABASE)
			EndIf

			If GfeVerCmpo({"GW3_SITMLA","GW3_MOTMLA"})

				If lAprovMLA
					If oModel:GetValue("UGFEA065_GW3","GW3_SITMLA") == "7"
						oModel:LoadValue("UGFEA065_GW3","GW3_SITMLA","8")
					Else
						oModel:LoadValue("UGFEA065_GW3","GW3_SITMLA","2")
						oModel:LoadValue("UGFEA065_GW3","GW3_MOTMLA","")
					EndIf
				Else
					oModel:LoadValue("UGFEA065_GW3","GW3_SITMLA","6")
					oModel:LoadValue("UGFEA065_GW3","GW3_MOTMLA","")
				EndIf
			EndIf
		EndIf


		If (nOpc == 3 .Or.  nOpc == 4)

			dbSelectArea("GVT")
			dbSetOrder(1)
			If dbSeek(xFilial("GVT")+cCdEsp)
				If GVT->GVT_TPIMP == "1"
					If Empty(oModelGW3:GetValue("GW3_CTE"))
						If lChvCte .And.  ( Posicione("GU3", 1, xFilial("GU3")+oModelGW3:GetValue("GW3_EMISDF"), "GU3_CTE")) == "1" .And.  GVT->GVT_CHVCTE == "1"
							oModel:SetErrorMessage(,,,,,"A Chave do CT-e nï¿½o foi informada.","A Espï¿½cie do Documento de Frete obriga a digitaï¿½ï¿½o do campo Chave CT-e.")
							Return .F.
						ElseIf Posicione("GU3", 1, xFilial("GU3")+oModelGW3:GetValue("GW3_EMISDF"), "GU3_CTE") == "1" .And.  GVT->GVT_CHVCTE == "1"
							oModel:SetErrorMessage(,,,,,"A Chave do CT-e nï¿½o foi informada.","O Emissor do Documento de Frete estï¿½ parametrizado para emitir CT-e. O campo Chave CT-e deve ser preenchido.")
							Return .F.
						EndIf
					EndIf

					aRetVldCte := u_GFE065VCTE(cChvCte, cEmissor, cSerie, cNumero, dDataEmis)
					If !aRetVldCte[1]
						If !(Empty(oModelGW3:GetValue("GW3_CTE"))) .and.  (GVT->GVT_CHVCTE == "2") .And.  Posicione("GU3", 1, xFilial("GU3")+oModelGW3:GetValue("GW3_EMISDF"), "GU3_CTE") == "1"
							oModel:SetErrorMessage(,,,,,"Chave Ct-e invï¿½lida:" + Chr(13)+Chr(10) + aRetVldCte[2],"Informe uma Chave de CT-e vï¿½lida.")
							Return .F.
						elseif ((!lChvCte) .Or.  (GVT->GVT_CHVCTE == "1")) .And.  Posicione("GU3", 1, xFilial("GU3")+oModelGW3:GetValue("GW3_EMISDF"), "GU3_CTE") == "1"
							oModel:SetErrorMessage(,,,,,"Chave Ct-e invï¿½lida:" + Chr(13)+Chr(10) + aRetVldCte[2],"Informe uma Chave de CT-e vï¿½lida.")
							Return .F.
						EndIf
					Else
						If !U_UGFEACTE( .T. )
							Return .F.
						EndIf
					EndIf
				EndIf
			EndIf
			If FwFldGet("GW3_TPDF") == "1" .OR.  FwFldGet("GW3_TPDF") == "3" .OR.  FwFldGet("GW3_TPDF") == "5"
				For nCont := 1 To oModelGW4:GetQtdLine()
					oModelGW4:GoLine( nCont )
					If !oModelGW4:isDeleted()
						dbSelectArea("GW4")
						dbSetOrder(2)
						dbSeek(xFilial("GW4")+FwFldGet("GW4_EMISDC", nCont)+FwFldGet("GW4_SERDC", nCont)+FwFldGet("GW4_NRDC", nCont)+FwFldGet("GW4_TPDC", nCont))

						While !Eof() .AND.  GW4->GW4_FILIAL + GW4->GW4_EMISDC + GW4->GW4_SERDC + GW4->GW4_NRDC + GW4->GW4_TPDC == xFilial("GW4") + FwFldGet("GW4_EMISDC", nCont) + FwFldGet("GW4_SERDC", nCont) + FwFldGet("GW4_NRDC", nCont) + FwFldGet("GW4_TPDC", nCont)
							dbSelectArea("GW3")
							dbSetOrder(1)
							If dbSeek(xFilial("GW3")+GW4->GW4_CDESP+GW4->GW4_EMISDF+GW4->GW4_SERDF+GW4->GW4_NRDF+DTOS(GW4->GW4_DTEMIS))

								If  GW3->GW3_CDESP        + GW3->GW3_EMISDF         + GW3->GW3_SERDF        + GW3->GW3_NRDF        + DtoS(GW3->GW3_DTEMIS) <> FwFldGet("GW3_CDESP") + FwFldGet("GW3_EMISDF")  + FwFldGet("GW3_SERDF") + FwFldGet("GW3_NRDF") + DtoS(FwFldGet("GW3_DTEMIS"))
									If GW3->GW3_TPDF == FwFldGet("GW3_TPDF")
										oModel:SetErrorMessage(,,,,,"Tentativa de vincular o mesmo Documento de Carga em mais de um Documento de Frete do mesmo tipo.","Por favor, verifique as informaï¿½ï¿½es:"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"- Documento de carga "+alltrim(GW4->GW4_NRDC)+" cd. Emissor "+alltrim(GW4->GW4_EMISDC)+" vinculado ao documento de frete "+alltrim(GW3->GW3_NRDF)+".")
										Return .F.
									EndIf
								EndIf
							EndIf
							dbSelectArea("GW4")
							GW4->( DbSkip() )
						EndDo
					EndIf
				next
			EndIf


			cCredPCTF := SuperGetMV("MV_PICOTR", .F. ,"2",cFilAnt)

			If Empty(cCredPCTF)
				cCredPCTF := "2"
			EndIf




			If (Posicione("GU3", 1, xFilial("GU3") + oModelGW3:GetValue("GW3_CDREM") , "GU3_EMFIL") == "1" .And.  Posicione("GU3", 1, xFilial("GU3") + oModelGW3:GetValue("GW3_CDDEST"), "GU3_EMFIL") == "1") .And.  (SubStr(Posicione("GU3", 1, xFilial("GU3") + oModelGW3:GetValue("GW3_CDREM"), "GU3->GU3_IDFED"), 1, 8) == SubStr(Posicione("GU3", 1, xFilial("GU3") + oModelGW3:GetValue("GW3_CDDEST"), "GU3->GU3_IDFED"), 1, 8))

				If cCredPCTF == "2"

					oModelGW3:LoadValue("GW3_NATFRE", "4")

				Else

					oModelGW3:LoadValue("GW3_NATFRE", "0")




					dbSelectArea("GW1")
					GW1->( dbSetOrder(01) )
					GW1->( dbSeek(xFilial("GW1")+oModel:getValue("UGFEA065_GW4","GW4_TPDC")+oModel:getValue("UGFEA065_GW4","GW4_EMISDC")+oModel:getValue("UGFEA065_GW4","GW4_SERDC")+oModel:getValue("UGFEA065_GW4","GW4_NRDC")) )

					If GW1->GW1_USO == "1"
						lTribPC := .T.
					EndIf

				EndIf

			ElseIf Posicione("GV5", 1, xFilial("GV5") + oModelGW4:GetValue("GW4_TPDC", 1), "GV5_SENTID") <> "1"


				If oModelGW3:GetValue("GW3_CRDPC") == "1"
					oModelGW3:LoadValue("GW3_NATFRE", "0")
				Else
					oModelGW3:LoadValue("GW3_NATFRE", "1")
				EndIf

			Else

				If oModelGW3:GetValue("GW3_CRDPC") == "1"

					oModelGW3:LoadValue("GW3_NATFRE", "2")

				Else

					oModelGW3:LoadValue("GW3_NATFRE", "3")

				EndIf

			EndIf

			cParamRat := SuperGetMV("MV_CRIRAT", .F. ,"5")

			If cParamRat == "5"
				GFEMsgErro(If( cPaisLoc $ "ANG|PTG", "Parâmetro MV_CRIRAT (Critério de Rateio) não está registado", "Parâmetro MV_CRIRAT (Critério de Rateio) não está cadastrado" ))
			EndIf

			If cParamRat $ "1;4"

				For nCont := 1 To oModelGW4:GetQtdLine()

					oModelGW4:GoLine( nCont )

					If !(oModelGW4:IsDeleted(nCont))




						dbSelectArea("GW8")
						dbSetOrder(1)
						dbSeek(xFilial("GW8")+oModel:getValue("UGFEA065_GW4","GW4_TPDC")+oModel:getValue("UGFEA065_GW4","GW4_EMISDC")+oModel:getValue("UGFEA065_GW4","GW4_SERDC")+oModel:getValue("UGFEA065_GW4","GW4_NRDC"))
						While !Eof() .And.  xFilial("GW8")+oModel:getValue("UGFEA065_GW4","GW4_TPDC")+oModel:getValue("UGFEA065_GW4","GW4_EMISDC")+oModel:getValue("UGFEA065_GW4","GW4_SERDC")+oModel:getValue("UGFEA065_GW4","GW4_NRDC") == GW8->GW8_FILIAL+GW8->GW8_CDTPDC+GW8->GW8_EMISDC+GW8->GW8_SERDC+GW8->GW8_NRDC

							If cParamRat == "1"

								If GW8->GW8_TRIBP == "1"
									If GW8->GW8_PESOR > GW8->GW8_PESOC
										nQtdPISCOF += GW8->GW8_PESOR
									Else
										nQtdPISCOF += GW8->GW8_PESOC
									EndIf
								EndIf

							ElseIf cParamRat == "3"

								If GW8->GW8_TRIBP == "1"
									nQtdPISCOF += GW8->GW8_VOLUME
								EndIf

							EndIf

							GW8->( dbSkip() )
						EndDo

					EndIf

				next

				If nQtdPISCOF == 0
					cParamRat := "4"
				Else

					nQtdPISCOF := 0
				EndIf

			EndIf



			If GFEVerCmpo({"GVT_CRDPC"})
				If GVT->GVT_CRDPC == "2"
					oModelGW3:LoadValue("GW3_CRDPC", "1")
				ElseIf GVT->GVT_CRDPC == "3"
					oModelGW3:LoadValue("GW3_CRDPC", "2")
				EndIf
			EndIf


			For nCont := 1 To oModelGW4:GetQtdLine()
				oModelGW4:GoLine( nCont )

				If !(oModelGW4:IsDeleted(nCont))

					If IsBlind()


						dbSelectArea("GW1")
						dbSetOrder(1)
						If dbSeek(If(Empty(oModel:getValue("UGFEA065_GW4","GW4_FILIAL")),xFilial("GW4"),oModel:getValue("UGFEA065_GW4","GW4_FILIAL"))+oModel:getValue("UGFEA065_GW4","GW4_TPDC")+oModel:getValue("UGFEA065_GW4","GW4_EMISDC")+oModel:getValue("UGFEA065_GW4","GW4_SERDC")+oModel:getValue("UGFEA065_GW4","GW4_NRDC"))
							dbSelectArea("GWU")
							dbSetOrder(1)
							dbSeek(GW1->GW1_FILIAL+GW1->GW1_CDTPDC+GW1->GW1_EMISDC+GW1->GW1_SERDC+GW1->GW1_NRDC)
							lTrechoEmi := .F.

							While !Eof() .And.  GWU->GWU_FILIAL+GWU->GWU_CDTPDC+GWU->GWU_EMISDC+GWU->GWU_SERDC+GWU->GWU_NRDC == GW1->GW1_FILIAL+GW1->GW1_CDTPDC+GW1->GW1_EMISDC+GW1->GW1_SERDC+GW1->GW1_NRDC
								dbSelectArea("GU3")
								GU3->(DbSetOrder(1))
								GV5->(DbSetOrder(1))
								If GU3->(DbSeek(xFilial("GU3")+oModelGW3:getValue("GW3_EMISDF"))) .And.  GV5->(DbSeek(xFilial("GV5")+GW1->GW1_CDTPDC))
									If GWU->GWU_CDTRP == oModelGW3:getValue("GW3_EMISDF") .And.  Empty(GWU->GWU_DTENT) .And.  GU3->GU3_ENTOBR == "1" .And.  GV5->GV5_SENTID $ "23"
										oModel:SetErrorMessage(,,,,,"Tentativa de vincular um Documento de Carga sem entrega para esse Emissor.","ï¿½ necessï¿½rio realizar a entrega do Documento de Carga: "+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"- Sï¿½rie: " +alltrim(GW1->GW1_SERDC) + " Documento de carga: "+alltrim(GW1->GW1_NRDC)+".")
										Return .F.
									EndIf
									lTrechoEmi := .T.
								EndIf

								dbSelectArea("GWU")
								DbSkip()
							EndDo

						EndIf

						If !lTrechoEmi
							oModel:SetErrorMessage(,,,,,"Tentativa de inclusï¿½o de Documentos de Carga sem trecho atendido pelo Emissor.","Verifique se existem cï¿½lculos vinculados ao Documento de Carga.")
							Return .F.
						EndIf
						If lTrechoEmi
							If !u_GFEA65CAL(oModelGW4)
								Return .F.
							EndIf
						EndIf
					EndIf
					dbSelectArea("GW8")
					dbSetOrder(1)
					dbSeek(xFilial("GW8")+oModel:getValue("UGFEA065_GW4","GW4_TPDC")+oModel:getValue("UGFEA065_GW4","GW4_EMISDC")+oModel:getValue("UGFEA065_GW4","GW4_SERDC")+oModel:getValue("UGFEA065_GW4","GW4_NRDC"))
					While !Eof() .And.  xFilial("GW8")+oModel:getValue("UGFEA065_GW4","GW4_TPDC")+oModel:getValue("UGFEA065_GW4","GW4_EMISDC")+oModel:getValue("UGFEA065_GW4","GW4_SERDC")+oModel:getValue("UGFEA065_GW4","GW4_NRDC") == GW8->GW8_FILIAL+GW8->GW8_CDTPDC+GW8->GW8_EMISDC+GW8->GW8_SERDC+GW8->GW8_NRDC

						If GW8->GW8_TRIBP == "1"
							lTrechoPC := .T.
						EndIf
						If cParamRat == "1"

							If GW8->GW8_TRIBP== "1" .Or.  lTribPC
								If GW8->GW8_PESOR > GW8->GW8_PESOC
									nQtdPISCOF += GW8->GW8_PESOR
								Else
									nQtdPISCOF += GW8->GW8_PESOC
								EndIf
							EndIf

							If GW8->GW8_PESOR > GW8->GW8_PESOC
								nQtdTotal += GW8->GW8_PESOR
							Else
								nQtdTotal += GW8->GW8_PESOC
							EndIf

						ElseIf cParamRat == "2"

							If GW8->GW8_TRIBP== "1" .Or.  lTribPC
								nQtdPISCOF += GW8->GW8_VALOR
							EndIf

							nQtdTotal += GW8->GW8_VALOR

						ElseIf cParamRat == "4"

							If GW8->GW8_TRIBP== "1" .Or.  lTribPC
								nQtdPISCOF += GW8->GW8_QTDE
							EndIf

							nQtdTotal += GW8->GW8_QTDE

						ElseIf cParamRat == "3"

							If GW8->GW8_TRIBP== "1" .Or.  lTribPC
								nQtdPISCOF += GW8->GW8_VOLUME
							EndIf

							nQtdTotal += GW8->GW8_VOLUME

						EndIf
						dbSelectArea("GW8")
						DbSkip()
					EndDo

				EndIf
			next

			nVlDoc := oModelGW3:getValue("GW3_VLDF")


			If nVlDoc <> 0 .And.  M->GW3_PEDAG <> 0 .And.  Posicione("GVT", 1, xFilial("GVT") + M->GW3_CDESP, "GVT_TPIMP") <> "2"

				If M->GW3_PDGFRT == "1" .And.  M->GW3_PDGPIS == "2"

					nVlDoc -= M->GW3_PEDAG

				ElseIf M->GW3_PDGFRT == "2" .And.  M->GW3_PDGPIS == "1"

					nVlDoc += M->GW3_PEDAG

				EndIf

			EndIf



			If Posicione("GVT", 1, xFilial("GVT") + oModelGW3:GetValue("GW3_CDESP"), "GVT_TPIMP") == "2" .And.  SuperGetMV("MV_ISSBAPI",,"2") $ "2N"

				nVlDoc -= oModelGW3:GetValue("GW3_VLIMP")

				If nVlDoc < 0
					nVlDoc := 0
				EndIf

			EndIf


			If Posicione("GVT", 1, xFilial("GVT") + oModelGW3:GetValue("GW3_CDESP"), "GVT_TPIMP") == "1" .And.  SuperGetMV("MV_ICMBAPI",,"2") $ "2N"

				nVlDoc -= oModelGW3:GetValue("GW3_IMPRET")

				If nVlDoc < 0
					nVlDoc := 0
				EndIf

			EndIf

			If Posicione("GVT", 1, xFilial("GVT") + oModelGW3:GetValue("GW3_CDESP"), "GVT_TPIMP") == "1" .And.   SuperGetMV("MV_ICMBAPI",,"2") == "3"

				nVlDoc -= oModelGW3:GetValue("GW3_VLIMP")

				If nVlDoc < 0
					nVlDoc := 0
				EndIf

			EndIf

			nVlBasePIS := nVlDoc * nQtdPISCOF / nQtdTotal
			nVlBaseCO  := nVlDoc * nQtdPISCOF / nQtdTotal

			nVlPIS  := GFETratDec((nVlBasePIS * UGFEA065PCD("PIS") / 100),0, .T. )
			nVLCO   := GFETratDec((nVlBaseCO  * UGFEA065PCD("COFINS") / 100),0, .T. )


			If !lTrechoPC .And.  nVlBasePIS == 0 .And.  nVlBaseCO == 0
				oModelGW3:LoadValue("GW3_CRDPC", "2")
			Else


				If nVlBasePIS < 0 .And.  nVlBaseCO < 0
					nVlBasePIS := 0
					nVlBaseCO  := 0
					nVlPIS     := 0
					nVLCO      := 0
				EndIf
				oModelGW3:SetValue("GW3_BASCOF", nVlBaseCO)
				oModelGW3:SetValue("GW3_VLCOF" , nVlCO)
				oModelGW3:SetValue("GW3_BASPIS", nVlBasePIS)
				oModelGW3:SetValue("GW3_VLPIS" , nVLPIS)
			EndIf

			If oModel:GetValue( "UGFEA065_GW3", "GW3_NATFRE")== "2" .and.  oModel:GetValue( "UGFEA065_GW3", "GW3_CRDPC") == "2"
				oModelGW3:LoadValue("GW3_NATFRE", "3")
			EndIf
			If oModel:GetValue( "UGFEA065_GW3", "GW3_NATFRE")== "0" .and.  oModel:GetValue( "UGFEA065_GW3", "GW3_CRDPC") == "2"
				oModelGW3:LoadValue("GW3_NATFRE", "1")
			EndIf


			If lCpoTES .And.  cTesAuto == "1"
				cTes := oModelGW3:GetValue("GW3_TES")
				If Empty( cTes )
					cTpImp	:= Posicione("GVT", 1, xFilial("GVT") + oModelGW3:GetValue("GW3_CDESP"), "GVT_TPIMP")
					aForLoj:= GFEA055GFL(oModelGW3:GetValue("GW3_EMISDF"))
					cTes 	:= u_GFE065TES(cTes, cTpImp, oModelGW3:GetValue("GW3_TRBIMP"), oModelGW3:GetValue("GW3_CRDICM"), oModelGW3:GetValue("GW3_CRDPC"), aForLoj)
					oModel:SetValue("UGFEA065_GW3", "GW3_TES", cTes)
				EndIf
			EndIf

		EndIf

		RestArea( aAreaGW4 )
		RestArea( aAreaGW3 )
		RestArea( aArea )

	Else
		If nOpc == 4

			If oModel:GetValue( "UGFEA065_GW3", "GW3_SITFIS") $ "25"
				U_GFE65IPG("1",oModel:GetValue( "UGFEA065_GW3", "GW3_SITFIS"),oModel,@aRet)

				If !Empty(aRet[2])
					If !aRet[1]
						oModel:SetValue( "UGFEA065_GW3", "GW3_SITFIS", "3")
						oModel:SetValue( "UGFEA065_GW3", "GW3_MOTFIS", AllTrim(aRet[3]) )
					Else
						oModel:SetValue( "UGFEA065_GW3", "GW3_SITFIS", "4")
						oModel:SetValue( "UGFEA065_GW3", "GW3_MOTFIS", " ")
						lGfeAtu := .T.
					EndIf
				EndIf

			EndIf

			If oModel:GetValue( "UGFEA065_GW3", "GW3_SITREC") $ "25"
				u_GFE65IPG("2",oModel:GetValue( "UGFEA065_GW3", "GW3_SITREC"),oModel,@aRet)

				If !Empty(aRet[2])
					If !aRet[1]
						oModel:SetValue( "UGFEA065_GW3", "GW3_SITREC", "3")
						oModel:SetValue( "UGFEA065_GW3", "GW3_MOTREC", AllTrim(aRet[3]) )
					Else
						oModel:SetValue( "UGFEA065_GW3", "GW3_SITREC", "4")
						oModel:SetValue( "UGFEA065_GW3", "GW3_MOTREC", " ")
					EndIf
				EndIf
			EndIf

		EndIf

	EndIf

Return .T.



Static Function GFEVldForm(cStr, cFun)

	Local nI

	For nI := 1 To Len(cStr)

		If &("!" + cFun + "('" + SubStr(cStr, nI) + "')")
			Return .F.
		EndIf

	Next

Return .T.



User Function GFEZapZero(cStr)

	Local nI
	Local nPos := 2

	If SubStr(cStr, 1, 1) <> "0"
		Return cStr
	EndIf

	For nI := 2 To Len(cStr)

		If SubStr(cStr, nI, 1) == "0"
			nPos++
		Else
			Exit
		EndIf

	Next

Return SubStr(cStr, nPos)





Static Function UGFEA065CMT(oModel)

	Local lRet       := .T.
	Local lExistCamp := GFXCP12116("GWF","GWF_CDESP") .And.  (SuperGetMV("MV_DPSERV", .F. , "1") == "1") .And.  (FindFunction("u_UGFVFIX") .And.  U_UGFVFIX())
	Local aRetRateio := {}
	Local nQtLinhas  := 0
	Local nI         := 1
	Local oModelGW4  := oModel:getModel("UGFEA065_GW4")
	Local oModelGW3  := oModel:getModel("UGFEA065_GW3")
	Local aCalcProv  := {}
	Local cCidDest	 := ""
	Local cCidEmis := ""
	Local dDataMod   := oModel:getValue("UGFEA065_GW3","GW3_DTENT")

	
	FwDateUpd( .T. )



	If oModel:getOperation() <> 5 .And.  dDataDf <> dDataMod
		oModel:GetModel("UGFEA065_GW3"):SetValue("GW3_DTENT",dDataMod)
	ElseIf oModel:GetOperation() == 3
		oModel:GetModel("UGFEA065_GW3"):SetValue("GW3_DTENT",dDataBase)
	EndIf

	If IsInCallStack("u_GFE65In")
		If oModel:getOperation() == 3 .OR.  oModel:getOperation() == 4
			cCidDest := POSICIONE("GU3", 1, xFilial("GU3") + oModel:getValue("UGFEA065_GW3","GW3_CDDEST"), "GU3_NRCID")
			oModel:LoadValue("UGFEA065_GW3", "GW3_UFDEST", POSICIONE("GU7", 1, xFilial("GU7") + cCidDest, "GU7_CDUF"))

			cCidEmis := Posicione("GU3", 1, oModel:getValue("UGFEA065_GW3","GW3_EMISDF"),"GU3_NRCID")
			oModel:LoadValue("UGFEA065_GW3", "GW3_UFEMIS", POSICIONE("GU7", 1, xFilial("GU7") + cCidEmis, "GU7_CDUF"))
		EndIf
	EndIf

	If !IsInCallStack("u_GFE65In")


		For nI := 1 to oModelGW4:getQtdLine()


			if !oModelGW4:isDeleted(nI)
				nQtLinhas++
			EndIf

			If oModelGW4:isDeleted(nI) .OR.  oModel:getOperation() == 5



				dbSelectArea("GWH")
				dbSetOrder(2)
				If dbSeek(xFilial("GWH")+oModelGW4:getValue("GW4_TPDC")+oModelGW4:getValue("GW4_EMISDC")+oModelGW4:getValue("GW4_SERDC")+oModelGW4:getValue("GW4_NRDC"))





					While !Eof() .AND.  xFilial("GWH")                   == GWH->GWH_FILIAL .AND.  oModelGW4:getValue("GW4_TPDC")   == GWH->GWH_CDTPDC .AND.  oModelGW4:getValue("GW4_EMISDC") == GWH->GWH_EMISDC .AND.  oModelGW4:getValue("GW4_SERDC")  == GWH->GWH_SERDC .AND.  oModelGW4:getValue("GW4_NRDC")   == GWH->GWH_NRDC

						dbSelectArea("GWF")
						dbSetOrder(1)
						if dbSeek(xFilial("GWF")+GWH->GWH_NRCALC)
							If GWF->GWF_TPCALC $ "16"
								nPos := aScan(aCalcProv,{|x| x == GWF->GWF_NRCALC})
								if nPos == 0
									aAdd(aCalcProv,GWF->GWF_NRCALC)
								EndIf
							EndIf
						EndIf
						dbSelectArea("GWH")
						dbSkip()
					EndDo
				EndIf
			EndIf
		next


		If oModel:getOperation() == 5 .OR.  nQtLinhas == 0


			dbSelectArea("GWM")
			dbSetOrder(1)
			dbSeek(xFilial("GWM")+"2"+oModel:getValue("UGFEA065_GW3","GW3_CDESP")+oModel:getValue("UGFEA065_GW3","GW3_EMISDF")+oModel:getValue("UGFEA065_GW3","GW3_SERDF")+oModel:getValue("UGFEA065_GW3","GW3_NRDF")+DTOS(oModel:getValue("UGFEA065_GW3","GW3_DTEMIS")))







			While !Eof() .AND.  GWM->GWM_FILIAL == xFilial("GWM") .AND.  GWM->GWM_TPDOC  == "2" .AND.  GWM->GWM_CDESP  == oModel:getValue("UGFEA065_GW3","GW3_CDESP" ) .AND.  GWM->GWM_CDTRP  == oModel:getValue("UGFEA065_GW3","GW3_EMISDF") .AND.  GWM->GWM_SERDOC == oModel:getValue("UGFEA065_GW3","GW3_SERDF" ) .AND.  GWM->GWM_NRDOC  == oModel:getValue("UGFEA065_GW3","GW3_NRDF"  ) .AND.  GWM->GWM_DTEMIS == oModel:getValue("UGFEA065_GW3","GW3_DTEMIS")
				RecLock("GWM", .F. )
				dbDelete()
				MsUnlock("GWM")
				dbSelectArea("GWM")
				dbSkip()
			EndDo


			dbSelectArea("GWA")
			dbSetOrder(3)
			dbSeek(xFilial("GWA")+"2"+oModel:getValue("UGFEA065_GW3","GW3_NRDF"))



			While !Eof() .AND.  GWA->GWA_FILIAL == xFilial("GWA") .AND.  GWA->GWA_TPDOC  == "2" .AND.  GWA->GWA_NRDOC  == oModel:getValue("UGFEA065_GW3","GW3_NRDF")
				RecLock("GWA", .F. )
				dbDelete()
				MsUnlock("GWA")
				dbSelectArea("GWA")
				dbSkip()
			EndDo
		EndIf
	EndIf

	If oModel:getOperation() == 5
		aCalcRel := {}

		If GFXTB12117("GWC")
			u_UGFEA065CTP("E")
		EndIf
	EndIf

	If lExistCamp .And.  (lConferiu .Or.  oModel:getOperation() == 5)

		dbSelectArea("GWF")
		GWF->(dbSetOrder(1))


		cQuery := " SELECT R_E_C_N_O_ RECNOGWF"
		cQuery += "   FROM"+RetSqlName("GWF")
		cQuery += "  WHERE GWF_FILIAL = '"+xFilial("GWF")+"'"
		cQuery += "    AND GWF_CDESP  = '"+oModelGW3:getValue("GW3_CDESP") +"'"
		cQuery += "    AND GWF_EMISDF = '"+oModelGW3:getValue("GW3_EMISDF")+"'"
		cQuery += "    AND GWF_SERDF  = '"+oModelGW3:getValue("GW3_SERDF") +"'"
		cQuery += "    AND GWF_NRDF   = '"+oModelGW3:getValue("GW3_NRDF")  +"'"
		cQuery += "    AND GWF_DTEMDF = '"+DtoS(oModelGW3:getValue("GW3_DTEMIS"))+"'"
		cQuery += "    AND D_E_L_E_T_ = ' '"
		cQuery := ChangeQuery(cQuery)
		cAliasQry := GetNextAlias()
		DbUseArea( .T. ,"TOPCONN",TcGenQry(,,cQuery),cAliasQry, .F. , .T. )

		While (cAliasQry)->(!EoF())
			GWF->(dbGoTo((cAliasQry)->RECNOGWF))
			RecLock("GWF", .F. )
			GWF->GWF_CDESP := ""
			GWF->GWF_EMISDF:= ""
			GWF->GWF_SERDF := ""
			GWF->GWF_NRDF  := ""
			GWF->GWF_DTEMDF:= StoD("  \  \  ")
			MsUnlock("GWF")
			(cAliasQry)->(dbSkip())
		EndDo
		(cAliasQry)->(dbCloseArea())


		For nI := 1 to Len(aCalcRel)
			GWF->(dbSeek(xFilial("GWF")+aCalcRel[nI]))
			RecLock("GWF", .F. )
			GWF->GWF_CDESP := oModelGW3:getValue("GW3_CDESP")
			GWF->GWF_EMISDF:= oModelGW3:getValue("GW3_EMISDF")
			GWF->GWF_SERDF := oModelGW3:getValue("GW3_SERDF")
			GWF->GWF_NRDF  := oModelGW3:getValue("GW3_NRDF")
			GWF->GWF_DTEMDF:= oModelGW3:getValue("GW3_DTEMIS")
			MsUnlock("GWF")
		next

	EndIf

	aCalcRel := {}
	lConferiu := .F.
	lRet := FWFormCommit(oModel)


	If !IsInCallStack("u_GFE65In")
		dbSelectArea("GW3")
		GW3->( dbSetOrder(1) )


		If GW3->( dbSeek(xFilial("GW3") + oModel:getValue("UGFEA065_GW3", "GW3_CDESP") + oModel:getValue("UGFEA065_GW3", "GW3_EMISDF") + oModel:getValue("UGFEA065_GW3", "GW3_SERDF") + oModel:getValue("UGFEA065_GW3", "GW3_NRDF") + DTos(oModel:getValue("UGFEA065_GW3", "GW3_DTEMIS"))) )


			If oModel:getOperation() <> 5 .AND.  (oModel:getValue("UGFEA065_GW3","GW3_SIT") == "3" .OR.  oModel:getValue("UGFEA065_GW3","GW3_SIT") == "4")

				If SuperGetMV("MV_TPGERA", .F. ,"1") == "1"





					aRetRateio := GFERatDF( .F. , oModel:getValue("UGFEA065_GW3","GW3_CDESP" ), oModel:getValue("UGFEA065_GW3","GW3_EMISDF"), oModel:getValue("UGFEA065_GW3","GW3_SERDF" ), oModel:getValue("UGFEA065_GW3","GW3_NRDF"  ), oModel:getValue("UGFEA065_GW3","GW3_DTEMIS"))
					If aRetRateio[1] == .F.
						GFEMsgErro(aRetRateio[2])
					EndIf
				Else

					GFERatDFSimp({GW3->GW3_FILIAL, GW3->GW3_CDESP, GW3->GW3_EMISDF, GW3->GW3_SERDF, GW3->GW3_NRDF, GW3->GW3_DTEMIS})
				EndIf
			EndIf



			If (oModel:getOperation() == 5 .OR.  nQtLinhas == 0) .AND.  !Empty(aCalcProv)
				For nI := 1 to len(aCalcProv)
					GFERatCal( .F. ,aCalcProv[nI])
				next
			EndIf

			If GFXTB12117("GWC")




				If oModel:GetOperation() == 3 .And.  oModelGW3:GetValue("GW3_SIT") == "3"
					u_UGFEA065CTP("IA")
				ElseIf oModel:GetOperation() == 4
					If oModelGW3:GetValue("GW3_SIT") $ "2;3"
						If SuperGetMv("MV_GFEI21", .F. ,"3") == "1" .And.  cSitAnt $ "3;4" .And.  cSitCusAnt == "2"
							u_UGFEA065CTP("P")
						ElseIf SuperGetMv("MV_GFEI21", .F. ,"3") == "2"
							u_UGFEA065CTP("E")
							If SuperGetMv("MV_GFEI21", .F. ,"3") == "2"
								u_UGFEA065CTP("IA")
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf

		If oModel:getOperation() <> 5
			If oModel:GetValue("UGFEA065_GW3", "GW3_SIT") $ "3/4"

				If SuperGetMV("MV_GFEI13",,"1") == "2" .And.  oModel:GetValue("UGFEA065_GW3", "GW3_SITFIS") $ "1;3"
					U_GFE65XF( .T. )
				EndIf
				If SuperGetMV("MV_GFEI14",,"1") == "2"
					u_GFE65XC( .T. )
				EndIf
			EndIf
		EndIf

		If GFXCP12117("GW1_SITFRE") .And.  SuperGetMV("MV_INTFRE", .F. ,"1") == "2" .And.  oModel:GetValue("UGFEA065_GW3", "GW3_SIT") $ "3/4"
			u_UGFE5VF(oModel)
		EndIf
	EndIf


	If oModel:GetOperation() <> 5 .And.  (oModel:GetValue("UGFEA065_GW3", "GW3_SIT") == "3" .Or.  oModel:GetValue("UGFEA065_GW3", "GW3_SIT") == "4")

		dbSelectArea("GW3")
		GW3->( dbSetOrder(1) )


		If GW3->( dbSeek(xFilial("GW3") + oModel:GetValue("UGFEA065_GW3", "GW3_CDESP") + oModel:GetValue("UGFEA065_GW3", "GW3_EMISDF") + oModel:GetValue("UGFEA065_GW3", "GW3_SERDF") + oModel:GetValue("UGFEA065_GW3", "GW3_NRDF") + DToS(oModel:GetValue("UGFEA065_GW3", "GW3_DTEMIS"))) )
			if !IsInCallStack("u_GFE65XF")
				u_GFE5GFAT( .F. )
			EndIf
		EndIf

	EndIf

	cFil    := Nil
	nPreFat := Nil
Return lRet





User Function UGFE5VL(oModel)
	Local lRet    	:= .T.
	Local nOpc    	:= (oModel:GetOperation())
	Local lAprovMLA 	:= SuperGetMv("MV_ERPGFE", .F. ,"1") == "1" .And.  SuperGetMv("MV_DFMLA", .F. ,"1") $ "2|3"
	Local lCteSubs	:= "#infctesub#" $ GW3->GW3_OBS



	If (nOpc == 4 .OR.  nOpc == 5 ) .And.  !ISINCALLSTACK("u_GFE65In")


		If GW3->GW3_SITFIS == "2" .And.  !lCteSubs
			Help( ,, "HELP",, "O Documento de Frete estï¿½ pendente no Fiscal, portanto, nï¿½o poderï¿½ ser excluï¿½do nem alterado.", 1, 0)
			Return .F.
		EndIf


		If GW3->GW3_SITFIS == "4" .AND.  !lGfeAtu .And.  !lCteSubs
			Help( ,, "HELP",, "O Documento de Frete estï¿½ atualizado no Fiscal. Primeiramente o Documento de Frete deve ser desatualizado para entï¿½o poder ser excluï¿½do ou alterado.", 1, 0)
			Return .F.
		EndIf


		If GW3->GW3_SITFIS == "5"
			Help( ,, "HELP",, "O Documento de Frete estï¿½ Pendente de Desatualizaï¿½ï¿½o no Fiscal, ï¿½ necessï¿½rio aguardar retorno.", 1, 0)
			Return .F.
		EndIf


		If GW3->GW3_SITREC == "2"
			Help( ,, "HELP",, "O Documento de Frete estï¿½ pendente no Recebimento, portanto, nï¿½o poderï¿½ ser excluï¿½do nem alterado.", 1, 0)
			Return .F.
		EndIf
		

		If GW3->GW3_SITREC == "4"
			Help( ,, "HELP",, "O Documento de Frete estï¿½ atualizado no Recebimento. Primeiramente o Documento de Frete deve ser desatualizado para entï¿½o poder ser excluï¿½do ou alterado.", 1, 0)
			Return .F.
		EndIf


		If GW3->GW3_SITREC == "5"
			Help( ,, "HELP",, "O Documentos de Frete estï¿½ Pendente de Desatualizaï¿½ï¿½o no Recebimento, ï¿½ necessï¿½rio aguardar retorno.", 1, 0)
			Return .F.
		EndIf

		If nOpc == 4
			dbSelectArea("GW6")
			GW6->( dbSetOrder(1) )
			If GW6->( dbSeek(GW3->GW3_FILFAT + GW3->GW3_EMIFAT + GW3->GW3_SERFAT + GW3->GW3_NRFAT + DToS(GW3->GW3_DTEMFA)) )
				If GW6->GW6_SITAPR $ "3;4"

					Help( ,, "HELP",, "O Documento de Frete nï¿½o pode ser alterado, pois estï¿½ vinculado a uma Fatura aprovada." + "ï¿½ necessï¿½rio que o Documento de Frete seja desvinculado da Fatura para que possa ser efetuada a alteraï¿½ï¿½o.", 1, 0)
					Return .F.
				EndIf
			EndIf
		EndIf
	EndIf

	If nOpc == 5

		If !Empty(GW3->GW3_NRFAT)
			Help( ,, "HELP",, If( cPaisLoc $ "ANG|PTG", "Não é possível excluir quando o documento de frete estiver vinculado em uma factura", "Não é possível excluir quando o documento de frete estiver vinculado em uma fatura" ), 1, 0)
			Return .F.
		EndIf

		If GW3->GW3_SITREC == "2" .OR.  GW3->GW3_SITREC == "4" .OR.  GW3->GW3_SITREC == "5"
			Help( ,, "HELP",, "Nï¿½o ï¿½ possï¿½vel excluir quando a situaï¿½ï¿½o do Recebimento estiver 'Pendente' ou 'Atualizado' ", 1, 0)
			Return .F.
		ElseIf ( GW3->GW3_SITFIS == "2" .OR.  GW3->GW3_SITFIS == "4" .OR.  GW3->GW3_SITFIS == "5" ) .And.  !lCteSubs
			Help( ,, "HELP",, "Nï¿½o ï¿½ possï¿½vel excluir quando a situaï¿½ï¿½o do Fiscal estiver 'Pendente' ou 'Atualizado'", 1, 0)
			Return .F.
		EndIf

		If GfeVerCmpo({"GW3_SITMLA"})

			If lAprovMLA .And.  !(GW3->GW3_SITMLA $ "1|6" .Or.  Empty(GW3->GW3_SITMLA))
				Help(,,"HELP",,"Documento de Frete estï¿½ integrado ao MLA ou pendente de integraï¿½ï¿½o, realize a desatualizaï¿½ï¿½o para esta operaï¿½ï¿½o.",1,0)
				Return .F.
			EndIf
		EndIf
	EndIf

	If lGfeAtu
		lGfeAtu := .F.
	EndIf

Return lRet


Static Function GW4_VAL1(cTipo, nLine)
	Local aArea    := GetArea()
	Local aAreaGW4 := GW4->( GetArea() )
	Local aAreaGW3 := GW3->( GetArea() )
	Local lRet     := .T.


	If cTipo == "1" .OR.  cTipo == "3" .OR.  cTipo == "5"
		dbSelectArea("GW4")
		dbSetOrder(2)
		dbSeek(xFilial("GW4")+FwFldGet("GW4_EMISDC", nLine)+FwFldGet("GW4_SERDC", nLine)+FwFldGet("GW4_NRDC", nLine)+FwFldGet("GW4_TPDC", nLine))

		While !Eof() .AND.  GW4->GW4_FILIAL + GW4->GW4_EMISDC + GW4->GW4_SERDC + GW4->GW4_NRDC + GW4->GW4_TPDC == xFilial("GW4") + FwFldGet("GW4_EMISDC", nLine) + FwFldGet("GW4_SERDC", nLine) + FwFldGet("GW4_NRDC", nLine) + FwFldGet("GW4_TPDC", nLine)
			dbSelectArea("GW3")
			dbSetOrder(1)
			If dbSeek(xFilial("GW3")+GW4->GW4_CDESP+GW4->GW4_EMISDF+GW4->GW4_SERDF+GW4->GW4_NRDF+DTOS(GW4->GW4_DTEMIS))

				If  GW3->GW3_CDESP        + GW3->GW3_EMISDF         + GW3->GW3_SERDF        + GW3->GW3_NRDF        + DtoS(GW3->GW3_DTEMIS) <> FwFldGet("GW3_CDESP") + FwFldGet("GW3_EMISDF")  + FwFldGet("GW3_SERDF") + FwFldGet("GW3_NRDF") + DtoS(FwFldGet("GW3_DTEMIS"))
					If GW3->GW3_TPDF == FwFldGet("GW3_TPDF")
						Help( ,, "HELP",, "Nï¿½o ï¿½ possï¿½vel vincular o mesmo Documento de Carga em mais de um Documento de Frete do mesmo tipo."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"- Documento de carga "+alltrim(GW4->GW4_NRDC)+" cd. Emissor "+alltrim(GW4->GW4_EMISDC)+" vinculado ao documento de frete "+alltrim(GW3->GW3_NRDF)+".", 1, 0)
						lRet := .F.
					EndIf
				EndIf
			EndIf
			dbSelectArea("GW4")
			GW4->( DbSkip() )
		EndDo
	EndIf

	RestArea( aAreaGW3 )
	RestArea( aAreaGW4 )
	RestArea( aArea )
Return lRet


User Function G065GW4VPR(oModel)
	Local lRet		:= .T.
	Local aArea	:= GetArea()



	If !Empty(FwFldGet("GW3_EMIFAT")) .Or.  !Empty(FwFldGet("GW3_SERFAT")) .Or.  !Empty(FwFldGet("GW3_NRFAT")) .Or.  !Empty(FwFldGet("GW3_DTEMFA")) .Or.  !Empty(FwFldGet("GW3_FILFAT"))
		Help( ,, "HELP",, If( cPaisLoc $ "ANG|PTG", "Não é possível vincular/desvincular Documentos de Carga quando o documento de Factura estiver vinculado em uma factura", "Não é possível vincular/desvincular Documentos de Carga, quando o documento de Fatura estiver vinculado em uma fatura" ), 1, 0)
		lRet := .F.
	EndIf
	RestArea( aArea )

Return lRet


User Function G065GW4VP(oModel)
	Local lRet			:= .T.
	Local aArea      	:= GetArea()
	Local aAreaGW1   	:= GW1->( GetArea() )
	Local aAreaGW3   	:= GW3->( GetArea() )
	Local aAreaGW4   	:= GW4->( GetArea() )
	Local aAreaGWF   	:= GWF->( GetArea() )
	Local aAreaGWH   	:= GWH->( GetArea() )
	Local cTipo      	:= FwFldGet("GW3_TPDF")
	Local lTrechoEmi 	:= .F.

	Private lCalc		:= .T.



	If lRet
		dbSelectArea("GW1")
		dbSetOrder(1)
		If !dbSeek(If(Empty(FwFldGet("GW4_FILIAL")),xFilial("GW4"),FwFldGet("GW4_FILIAL"))+FwFldGet("GW4_TPDC")+FwFldGet("GW4_EMISDC")+FwFldGet("GW4_SERDC")+FwFldGet("GW4_NRDC"))
			Help( ,, "HELP",, If( cPaisLoc $ "ANG|PTG", "O documento de carga não existe", "Documento de Carga não existe" ), 1, 0)
			lRet := .F.
		Else
			dbSelectArea("GWN")
			dbSetOrder(1)
			If dbSeek(xFilial("GWN")+GW1->GW1_NRROM)
				If !(GWN->GWN_SIT $ "3,4")
					Help( ,, "HELP",, "O Romaneio relacionado a este Documento de Carga deve estar liberado ou encerrado.", 1, 0)
					lRet := .F.
				EndIf
			EndIf
		EndIf
	EndIf


	If lRet
		lRet := GW4_VAL1(cTipo, oModel:getLine())
	EndIf


	If lRet
		dbSelectArea("GW1")
		dbSetOrder(1)
		dbSeek(If(Empty(FwFldGet("GW4_FILIAL")),xFilial("GW4"),FwFldGet("GW4_FILIAL"))+FwFldGet("GW4_TPDC")+FwFldGet("GW4_EMISDC")+FwFldGet("GW4_SERDC")+FwFldGet("GW4_NRDC"))
		If GW1_SIT == "7"
			Help( ,, "HELP",, If( cPaisLoc $ "ANG|PTG", "Não é possível vincular um Documento de Carga cancelado", "Não é possível vincular um Documento de Carga Cancelado" ), 1, 0)
			lRet := .F.
		EndIf
	EndIf



	If lRet
		dbSelectArea("GW1")
		dbSetOrder(1)
		If dbSeek(If(Empty(FwFldGet("GW4_FILIAL")),xFilial("GW4"),FwFldGet("GW4_FILIAL"))+FwFldGet("GW4_TPDC")+FwFldGet("GW4_EMISDC")+FwFldGet("GW4_SERDC")+FwFldGet("GW4_NRDC"))

			dbSelectArea("GWU")
			dbSetOrder(1)
			dbSeek(GW1->GW1_FILIAL+GW1->GW1_CDTPDC+GW1->GW1_EMISDC+GW1->GW1_SERDC+GW1->GW1_NRDC)
			lTrechoEmi := .F.

			While !Eof() .And.  GWU->GWU_FILIAL+GWU->GWU_CDTPDC+GWU->GWU_EMISDC+GWU->GWU_SERDC+GWU->GWU_NRDC == GW1->GW1_FILIAL+GW1->GW1_CDTPDC+GW1->GW1_EMISDC+GW1->GW1_SERDC+GW1->GW1_NRDC
				dbSelectArea("GU3")
				GU3->(DbSetOrder(1))
				GV5->(DbSetOrder(1))
				If GU3->(DbSeek(xFilial("GU3")+FwFldGet("GW3_EMISDF"))) .And.  GV5->(DbSeek(xFilial("GV5")+GW1->GW1_CDTPDC))
					If GWU->GWU_CDTRP == FwFldGet("GW3_EMISDF") .And.  Empty(GWU->GWU_DTENT) .And.  GU3->GU3_ENTOBR == "1" .And.  GV5->GV5_SENTID $ "23"
						If !IsBlind()
							Help( ,, "HELP",, "Nï¿½o ï¿½ possï¿½vel vincular um Documento de Carga sem entrega para esse Emissor", 1, 0)
							lRet := .F.
						EndIf
					EndIf
					lTrechoEmi := .T.
				EndIf

				dbSelectArea("GWU")
				DbSkip()
			EndDo

		EndIf

		If !lTrechoEmi
			Help( ,, "HELP",, "Sï¿½ permite incluir Documentos de Cargas, se algum trecho for o Emissor. Verificar se existe cï¿½lculo vinculado ao Documento de Carga", 1, 0)
			lRet := .F.
		EndIf
	EndIf







	If lRet
		If FwFldGet("GW3_TPDF") == "6" .And.  (IsInCallStack("GFEA115") .Or.  IsInCallStack("GFEA118"))
			dbSelectArea("GW4")
			dbSetOrder(2)
			If dbSeek(If(Empty(FwFldGet("GW4_FILIAL")),xFilial("GW4"),FwFldGet("GW4_FILIAL"))+FwFldGet("GW4_EMISDC")+FwFldGet("GW4_SERDC")+FwFldGet("GW4_NRDC")+FwFldGet("GW4_TPDC"))


				While xFilial("GW4") == GW4->GW4_FILIAL .And.  FwFldGet("GW4_EMISDC") == GW4->GW4_EMISDC .And.  FwFldGet("GW4_SERDC") == GW4->GW4_SERDC .And.  FwFldGet("GW4_NRDC")== GW4->GW4_NRDC .And.  FwFldGet("GW4_TPDC") == GW4->GW4_TPDC
					dbSelectArea("GW3")
					dbSetOrder(10)
					If dbSeek(GW4->GW4_FILIAL+GW4->GW4_EMISDF+GW4->GW4_SERDF+GW4->GW4_NRDF)
						If GW3->GW3_TPDF == "6"
							GFEA115Red( .T. )
						EndIf
					EndIf
					GW4->(dbSkip())
				EndDo
			EndIf
		EndIf
	EndIf

	If lRet

		dbSelectArea("GW1")
		dbSetOrder(1)

	EndIf


	If lRet .AND. lTrechoEmi


		If !u_GFEA65CAL(oModel)
			lRet := .F.
		EndIf

	EndIf


	If lRet .And.  oModel:getLine() == 1 .And.  oModel:IsInserted() .And.  Empty(FwFldGet("GW3_CDREM")) .And.  Empty(FwFldGet("GW3_CDDEST"))

		cRem := Posicione("GW1",1,xFilial("GW1")+FwFldGet("GW4_TPDC")+FwFldGet("GW4_EMISDC")+FwFldGet("GW4_SERDC")+FwFldGet("GW4_NRDC"),"GW1_CDREM")
		cDest := Posicione("GW1",1,xFilial("GW1")+FwFldGet("GW4_TPDC")+FwFldGet("GW4_EMISDC")+FwFldGet("GW4_SERDC")+FwFldGet("GW4_NRDC"),"GW1_CDDEST")

		If !Empty(cRem) .And.  !Empty(cDest)




			If Iif(FindFunction("APMsgYesNo"), APMsgYesNo("Deseja utilizar remetente e destinatï¿½rio deste documento de carga para o documento de frete?"+Chr(13)+Chr(10)+"Remetente:"+AllTrim(cRem)+"-"+AllTrim(Posicione("GU3",1,xFilial("GU3")+cRem,"GU3_NMEMIT"))+Chr(13)+Chr(10)+"Destinatï¿½rio:"+AllTrim(cDest)+"-"+AllTrim(Posicione("GU3",1,xFilial("GU3")+cDest,"GU3_NMEMIT"))+Chr(13)+Chr(10), "Ajuda"), (cMsgYesNo:="MsgYesNo", &cMsgYesNo.("Deseja utilizar remetente e destinatï¿½rio deste documento de carga para o documento de frete?"+Chr(13)+Chr(10)+"Remetente:"+AllTrim(cRem)+"-"+AllTrim(Posicione("GU3",1,xFilial("GU3")+cRem,"GU3_NMEMIT"))+Chr(13)+Chr(10)+"Destinatï¿½rio:"+AllTrim(cDest)+"-"+AllTrim(Posicione("GU3",1,xFilial("GU3")+cDest,"GU3_NMEMIT"))+Chr(13)+Chr(10), "Ajuda")))

				FwFldPut("GW3_CDREM", cRem)
				FwFldPut("GW3_CDDEST", cDest)

			EndIf

		EndIf

	EndIf

	If !IsBlind() .And.  GFXXB12117("GWJPRE")
		oModel:SetValue("_VALID",CORVALID(lRet))
	EndIf

	RestArea(aAreaGW1)
	RestArea(aAreaGW3)
	RestArea(aAreaGW4)
	RestArea(aAreaGWF)
	RestArea(aAreaGWH)
	RestArea(aArea)

Return lRet







User Function UGFE5CO(oModel)
	Local lRet   := .T.


	Local iQT_VOL    := 0
	Local iPESO_REAL := 0
	Local iPESO_CUBA := 0
	Local iVOLUME    := 0
	Local iVALOR 	 := 0


	Local iFRET_UNID := 0
	Local iFRET_VAL  := 0
	Local iTAXAS	 := 0
	Local iVAL_PEDA	 := 0


	Local iVAL_FRETE := 0
	Local iALIQUOTA	 := 0
	Local iVAL_IMPO	 := 0

	Local lIntGFE := SuperGetMv("MV_INTGFE", .F. , .F. )
	Local cIntGFE2 := SuperGetMv("MV_INTGFE2", .F. ,"2")
	Local lUnitiz	 := .F.

	Local aArea      := GetArea()
	Local aAreaGW1   := GW1->( GetArea() )
	Local aAreaGW4   := GW4->( GetArea() )
	Local aAreaGWB   := GWB->( GetArea() )
	Local aAreaGW8   := GW8->( GetArea() )
	Local aAreaGUG   := GUG->( GetArea() )
	Local aAreaGWH   := GWH->( GetArea() )
	Local aAreaGWI   := GWI->( GetArea() )
	Local aAreaGWF   := GWF->( GetArea() )
	Local aAreaGV2   := GV2->( GetArea() )

	Local aDocRel    := {}
	Local oModelGW4  := oModel:GetModel("UGFEA065_GW4")
	Local nLine      := oModelGW4:GetLine()
	Local nI         := 0
	Local lMsgOco := .F.
	Local lExistCamp := GFXCP12116("GWF","GWF_CDESP") .And.  (SuperGetMV("MV_DPSERV", .F. , "1") == "1") .And.  (FindFunction("u_UGFVFIX") .And.  u_UGFVFIX())
	Local cQuery     := ""
	Local cAliasQry  := ""
	Local cAliasGWI  := ""
	Private cmsgoco := " "
	lConferiu := .T.


	aCalcRel := {}






	For nI := 1 To oModelGW4:GetQtdLine()

		oModelGW4:GoLine( nI )
		If !oModelGW4:IsDeleted()

			AAdd(aDocRel, FwFldGet("GW4_TPDC")+FwFldGet("GW4_EMISDC")+FwFldGet("GW4_SERDC")+FwFldGet("GW4_NRDC"))

			dbSelectArea("GW1")
			dbSetOrder(1)
			dbSeek(xFilial("GW4")+FwFldGet("GW4_TPDC")+FwFldGet("GW4_EMISDC")+FwFldGet("GW4_SERDC")+FwFldGet("GW4_NRDC"))





			dbSelectArea("GWL")
			dbSetOrder(5)
			dbSeek(xFilial("GWL")+FwFldGet("GW4_EMISDC")+FwFldGet("GW4_TPDC")+FwFldGet("GW4_SERDC")+FwFldGet("GW4_NRDC"))

			While !GWL->(Eof()) .And.  GWL->(GWL_FILDC+GWL_EMITDC+GWL_TPDC+GWL_SERDC+GWL_NRDC) == xFilial("GWL")+FwFldGet("GW4_EMISDC")+FwFldGet("GW4_TPDC")+FwFldGet("GW4_SERDC")+FwFldGet("GW4_NRDC")
				dbSelectArea("GWD")
				dbSetOrder(1)
				If dbSeek(GWL->GWL_FILIAL+GWL->GWL_NROCO)
					If GWD->GWD_SIT == "2"
						dbSelectArea("GU5")
						dbSetOrder(1)
						If dbSeek(xFilial("GU5") + GWD->GWD_CDTIPO)
							dbSelectArea("GU3")
							dbSetOrder(1)
							If dbSeek(xFilial("GU3") + GWD->GWD_CDTRP)
								If GU3->GU3_ACOCO == "1" .and.  GWD->GWD_CDTRP == FwFldGet("GW3_EMISDF")
									If GU5->GU5_ACAODF == "3"
										lRet := .F.
										cMotBloq := "Hï¿½ Registro de Ocorrï¿½ncia para o(s) Documento(s) de Carga do Documento de Frete com aï¿½ï¿½o de bloqueio."
										lMsgOco := .T.
										GFEA115Msg(lMsgOco)
										Exit
									ElseIf GU5->GU5_ACAODF == "2"
										If !IsInCallStack("GFEA115") .And.  !IsInCallStack("GFEA118")
											Alert("Atenï¿½ï¿½o: Documento de Carga " + AllTrim(GW1->GW1_NRDC) + " possui ocorrï¿½ncia!")
											Exit
										Else
											lMsgOco := .T.
											GFEA115Msg(lMsgOco)
											Exit
										EndIf
									EndIf
								ElseIf GU3->GU3_ACOCO == "3"
									If GU5->GU5_ACAODF == "2" .Or.  GU5->GU5_ACAODF == "3"
										Alert("Atenï¿½ï¿½o: Documento de Carga " + AllTrim(GW1->GW1_NRDC) + " possui ocorrï¿½ncia!")
										Exit
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf

				dbSelectArea("GWL")
				GWL->(dbSkip())

			EndDo


			dbSelectArea("GWB")
			dbSetOrder(2)
			dbSeek(xFilial("GWB")+GW1->GW1_CDTPDC+GW1->GW1_EMISDC+GW1->GW1_SERDC+GW1->GW1_NRDC)
			While !GWB->( Eof() ) .And.  xFilial("GWB")+GW1->GW1_CDTPDC+GW1->GW1_EMISDC+GW1->GW1_SERDC+GW1->GW1_NRDC == GWB->GWB_FILIAL+GWB->GWB_CDTPDC+GWB->GWB_EMISDC+GWB->GWB_SERDC+GWB->GWB_NRDC

				lUnitiz := .T.

				iQT_VOL := iQT_VOL + GWB->GWB_QTDE

				dbSelectArea("GUG")
				dbSetOrder(1)
				If dbSeek(xFilial("GUG")+GWB->GWB_CDUNIT)
					iVOLUME    := iVOLUME    + GUG->GUG_VOLUME*GWB->GWB_QTDE
				EndIf

				dbSelectArea("GWB")
				dbSkip()

			EndDo


			dbSelectArea("GW8")
			dbSetOrder(1)
			dbSeek(xFilial("GW8")+GW1->GW1_CDTPDC+GW1->GW1_EMISDC+GW1->GW1_SERDC+GW1->GW1_NRDC)
			While !GW8->( Eof() ) .And.  xFilial("GW8")+GW1->GW1_CDTPDC+GW1->GW1_EMISDC+GW1->GW1_SERDC+GW1->GW1_NRDC == GW8->GW8_FILIAL+GW8->GW8_CDTPDC+GW8->GW8_EMISDC+GW8->GW8_SERDC+GW8->GW8_NRDC

				If !lUnitiz
					iQT_VOL    := iQT_VOL    + GW8->GW8_QTDE
					iVOLUME    := iVOLUME 	 + GW8->GW8_VOLUME
				EndIf

				iPESO_REAL := iPESO_REAL + GW8->GW8_PESOR
				iPESO_CUBA := iPESO_CUBA + GW8->GW8_PESOC
				iVALOR     := iVALOR     + GW8->GW8_VALOR

				dbSelectArea("GW8")
				dbSkip()

			EndDo


			cQuery := " SELECT GWF.GWF_NRCALC,GWF.GWF_FILIAL,GWF.GWF_VLAJUS,GWF.GWF_IMPOST,GWF.GWF_PCISS,GWF.GWF_PCICMS,GWF.GWF_VLICMS,GWF.GWF_VLISS,GWF.GWF_TRANSP,GWH.GWH_NRCALC,GWF.GWF_ORIGEM"
			cQuery += "   FROM "+RetSqlName("GWH")+" GWH"
			cQuery += "  INNER JOIN "+RetSqlName("GWF")+" GWF"
			cQuery += "     ON GWF.GWF_FILIAL = GWH.GWH_FILIAL"
			cQuery += "    AND GWF.GWF_NRCALC = GWH.GWH_NRCALC"
			cQuery += "    AND GWF.GWF_TPCALC = '"+FwFldGet("GW3_TPDF")+"'"
			If GFXCP12117("GW3_CDTPSE") .And.  !Empty(FwFldGet("GW3_CDTPSE"))
				cQuery += "    AND GWF.GWF_CDTPSE = '"+FwFldGet("GW3_CDTPSE")+"'"
			EndIf
			cQuery += "    AND GWF.D_E_L_E_T_ = ' '"
			If lExistCamp
				cQuery += "    AND (GWF.GWF_CDESP  = '"+Space(TamSX3("GWF_CDESP")[1]) +"' OR GWF_CDESP  = '"+FwFldGet("GW3_CDESP ")+"')"
				cQuery += "    AND (GWF.GWF_EMISDF = '"+Space(TamSX3("GWF_EMISDF")[1])+"' OR GWF_EMISDF = '"+FwFldGet("GW3_EMISDF")+"')"
				cQuery += "    AND (GWF.GWF_SERDF  = '"+Space(TamSX3("GWF_SERDF")[1]) +"' OR GWF_SERDF  = '"+FwFldGet("GW3_SERDF ")+"')"
				cQuery += "    AND (GWF.GWF_NRDF   = '"+Space(TamSX3("GWF_NRDF")[1])  +"' OR GWF_NRDF   = '"+FwFldGet("GW3_NRDF  ")+"')"
				cQuery += "    AND (GWF.GWF_DTEMDF = '"+Space(TamSX3("GWF_DTEMDF")[1])+"' OR GWF_DTEMDF = '"+DtoS(FwFldGet("GW3_DTEMIS"))+"')"
			EndIf
			If s_VLCNPJ_1 == "1"
				cQuery += "    AND GWF.GWF_TRANSP = '"+FwFldGet("GW3_EMISDF")+"'"
			EndIf
			cQuery += "  WHERE GWH.GWH_FILIAL = '"+GW1->GW1_FILIAL+"'"
			cQuery += "    AND GWH.GWH_CDTPDC = '"+GW1->GW1_CDTPDC+"'"
			cQuery += "    AND GWH.GWH_EMISDC = '"+GW1->GW1_EMISDC+"'"
			cQuery += "    AND GWH.GWH_SERDC  = '"+GW1->GW1_SERDC +"'"
			cQuery += "    AND GWH.GWH_NRDC   = '"+GW1->GW1_NRDC  +"'"
			cQuery += "    AND GWH.D_E_L_E_T_ = ' '"
			If GFXCP12117("GW3_CDTPSE")
				cQuery += " ORDER BY GWF.GWF_CDTPSE"
			EndIf
			cQuery := ChangeQuery(cQuery)
			cAliasQry := GetNextAlias()
			DbUseArea( .T. ,"TOPCONN",TcGenQry(,,cQuery),cAliasQry, .F. , .T. )

			While (cAliasQry)->(!EoF())
				If s_VLCNPJ_2 == "1" .Or.  SubStr(Posicione("GU3", 1, xFilial("GU3") +FwFldGet("GW3_EMISDF"), "GU3->GU3_IDFED"), 1, 8) == SubStr(Posicione("GU3", 1, xFilial("GU3") + (cAliasQry)->GWF_TRANSP, "GU3->GU3_IDFED"), 1, 8)
					If AScan(aCalcRel, {|x| x == (cAliasQry)->GWH_NRCALC}) > 0
						Exit
					EndIf

					AAdd(aCalcRel, (cAliasQry)->GWF_NRCALC)

					iVAL_FRETE += (cAliasQry)->GWF_VLAJUS


					If (cAliasQry)->GWF_IMPOST == "2"

						iAliquota := (cAliasQry)->GWF_PCISS
						iVal_IMPO += GFETratDec((cAliasQry)->GWF_VLISS,0, .T. )
					Else

						iAliquota := (cAliasQry)->GWF_PCICMS
						iVal_IMPO += GFETratDec((cAliasQry)->GWF_VLICMS,0, .T. )
					EndIf



					If s_AUDINF $ "2" .And.  (cAliasQry)->GWF_ORIGEM == "2"
						lRet := .F.
						cMotBloq := cMotBloq + " Hï¿½ Frete Combinado"
					EndIf

					cQuery := " SELECT SUM(GWI.GWI_VLFRET) GWI_VLFRET,GV2.GV2_CATVAL"
					cQuery += "   FROM "+RetSqlName("GWI")+" GWI"
					cQuery += "  INNER JOIN "+RetSqlName("GV2")+" GV2"
					cQuery += "     ON GV2.GV2_FILIAL = '"+xFilial("GV2")+"'"
					cQuery += "    AND GV2.GV2_CDCOMP = GWI.GWI_CDCOMP"
					cQuery += "    AND GV2.D_E_L_E_T_ = ' '"
					cQuery += "  WHERE GWI.GWI_FILIAL = '"+(cAliasQry)->GWF_FILIAL+"'"
					cQuery += "    AND GWI.GWI_NRCALC = '"+(cAliasQry)->GWF_NRCALC+"'"
					cQuery += "    AND GWI.GWI_TOTFRE = '1'"
					cQuery += "    AND GWI.D_E_L_E_T_ = ' '"
					cQuery += "  GROUP BY GV2.GV2_CATVAL"
					cQuery := ChangeQuery(cQuery)
					cAliasGWI := GetNextAlias()
					DbUseArea( .T. ,"TOPCONN",TcGenQry(,,cQuery),cAliasGWI, .F. , .T. )

					While (cAliasGWI)->(!Eof())


						iVAL_FRETE := iVAL_FRETE + (cAliasGWI)->GWI_VLFRET


						Do Case
							Case (cAliasGWI)->GV2_CATVAL == "1"
							iFRET_UNID += (cAliasGWI)->GWI_VLFRET

							Case (cAliasGWI)->GV2_CATVAL == "2"
							iFRET_VAL  += (cAliasGWI)->GWI_VLFRET

							Case (cAliasGWI)->GV2_CATVAL == "3"
							iTAXAS     += (cAliasGWI)->GWI_VLFRET

							Case (cAliasGWI)->GV2_CATVAL == "4"
							iVAL_PEDA  += (cAliasGWI)->GWI_VLFRET
						EndCase

						(cAliasGWI)->(dbSkip())
					EndDo
					(cAliasGWI)->(dbCloseArea())
					Exit
				EndIf
				(cAliasQry)->(dbSkip())
			EndDo
			(cAliasQry)->(dbCloseArea())
		EndIf
	Next

	oModelGW4:GoLine(nLine)

	For nI := 1 To Len(aCalcRel)

		dbSelectArea("GWH")
		GWH->( dbSetOrder(1) )
		GWH->(dbSeek(xFilial("GWH") + aCalcRel[nI]))
		While !GWH->( Eof() ) .And.  GWH->GWH_NRCALC == aCalcRel[nI]

			If AScan(aDocRel, {|x| x == GWH->GWH_CDTPDC+GWH->GWH_EMISDC+GWH->GWH_SERDC+GWH->GWH_NRDC}) == 0
				lRet := .F.
				cMotBloq += " Nem todos os Documentos de Carga do Cï¿½lculo " + GWH->GWH_NRCALC + " foram relacionados ao Documento de Frete."
				Exit
			EndIf

			dbSelectArea("GWH")
			GWH->( dbSkip() )

		EndDo

		If !lRet
			Exit
		EndIf

	next


	If SuperGetMV("MV_DCOUT", .F. ,"N") $ "1S"

		If FwFldGet("GW3_QTVOL") <> iQT_VOL
			lRet := .F.
			cMotBloq := cMotBloq + If( cPaisLoc $ "ANG|PTG", "Há diferença na Quantidade de Volume", "Há diferença no Quantidade de Volume" )
		EndIf


		If FwFldGet("GW3_PESOR") <> iPESO_REAL
			lRet := .F.
			cMotBloq := cMotBloq + " Há diferença no Peso Real"
		EndIf


		If FwFldGet("GW3_PESOC") <> iPESO_CUBA
			lRet := .F.
			cMotBloq := cMotBloq + " Há diferença no Peso Cubado"
		EndIf


		If FwFldGet("GW3_VOLUM") <> iVOLUME
			lRet := .F.
			cMotBloq := cMotBloq + " Há diferença no Volume"
		EndIf


		If FwFldGet("GW3_VLCARG") <> iVALOR
			lRet := .F.
			cMotBloq := cMotBloq + " Há diferença no Valor dos Itens"
		EndIf
	EndIf


	If Empty(FwFldGet("GW3_CFOP")) .and.  lIntGFE == .T.  .And.  cIntGFE2 $ "1S"
		lRet := .F.
		cMotBloq := cMotBloq + "Campo CFOP deve ser preenchido quando sistema parametrizado para realizar integraï¿½ï¿½o."
	EndIf

	If SuperGetMV("MV_DCABE", .F. ,"N") $ "1S"

		If AbaixoTol(FwFldGet("GW3_FRPESO"), iFRET_UNID)
			lRet := .F.
			cMotBloq := cMotBloq + " Há diferença no Frete Unidade"
		EndIf


		If AbaixoTol(FwFldGet("GW3_FRVAL"), iFRET_VAL)
			lRet := .F.
			cMotBloq := cMotBloq + " Há diferença no Frete Valor"
		EndIf


		If AbaixoTol(FwFldGet("GW3_TAXAS"), iTAXAS)
			lRet := .F.
			cMotBloq := cMotBloq + " Hï¿½ diferenï¿½a nas Taxas"
		EndIf


		If AbaixoTol(FwFldGet("GW3_PEDAG"), iVAL_PEDA)
			lRet := .F.
			cMotBloq := cMotBloq + " Há diferença no Valor do Pedágio"
		EndIf
	EndIf


	If SuperGetMV("MV_DCTOT", .F. ,"N") $ "1S"

		If AbaixoTol(FwFldGet("GW3_VLDF"), iVAL_FRETE)
			lRet := .F.
			cMotBloq := cMotBloq + " Há diferença no Valor Total do Frete"
		EndIf


		If FwFldGet("GW3_PCIMP") <> iALIQUOTA
			lRet := .F.
			cMotBloq := cMotBloq + " Hï¿½ diferenï¿½a na Alï¿½quota"
		EndIf


		If AbaixoTol(Round(FwFldGet("GW3_VLIMP"), 2), iVAL_IMPO)
			lRet := .F.
			cMotBloq := cMotBloq + " Há diferença no Valor do Imposto"
		EndIf
	EndIf

	RestArea(aAreaGW1)
	RestArea(aAreaGW4)
	RestArea(aAreaGWB)
	RestArea(aAreaGW8)
	RestArea(aAreaGUG)
	RestArea(aAreaGWH)
	RestArea(aAreaGWI)
	RestArea(aAreaGWF)
	RestArea(aAreaGV2)
	RestArea(aArea)
Return lRet


Static Function DiffValor(nInfo, nCalc)
	Local nDif := nInfo - nCalc
Return nDif



Static Function AbaixoTol(nInfo, nCalc)
	Local lRet := .T.
	Local nDif
	Local nPorc

	nDif := DiffValor(nInfo, nCalc)

	If nDif == 0
		Return .F.
	EndIf




	If SuperGetMV("MV_DCNEG", .F. ,"N") $ "1S" .And.  nInfo < nCalc
		lRet := .F.
	Else
		If !Empty(SuperGetMV("MV_DCVAL", .F. ,"")) .And.  !Empty(SuperGetMV("MV_DCPERC", .F. ,""))
			nPorc := (SuperGetMV("MV_DCPERC", .F. ,"") / 100) * nCalc
			If (abs(nDif) <= nPorc ) .And.  abs(nDif) <= SuperGetMV("MV_DCVAL", .F. ,"")
				lRet := .F.
			EndIf
		EndIf
	EndIf


Return lRet













User Function GFEA65CAL(oModelGW4)
	Local lRet       := .T.
	Local cOBNENT    := SuperGetMV("MV_OBNENT", .F. ,"1",cFilAnt)
	Local cOBCOMP    := SuperGetMV("MV_OBCOMP", .F. ,"1",cFilAnt)
	Local cOBREEN    := SuperGetMV("MV_OBREEN", .F. ,"1",cFilAnt)
	Local cOBDEV     := SuperGetMV("MV_OBDEV" , .F. ,"1",cFilAnt)
	Local cOBSERV    := SuperGetMV("MV_OBSERV", .F. ,"1",cFilAnt)
	Local cOBREDE    := SuperGetMV("MV_OBREDE", .F. ,cOBNENT,cFilAnt)
	Local ChkObrigat := .F.
	Local lVldCalc   := .F.
	Local lVldSrv := .F.
	Local lExistCamp := GFXCP12116("GWF","GWF_CDESP") .And.  SuperGetMV("MV_DPSERV", .F. , "1") == "1" .And.  (FindFunction("u_UGFVFIX") .And.  u_UGFVFIX())
	Local cCpnjDF
	Local cCpnjDC
	Local nRecPriClc


	Do Case
		Case FwFldGet("GW3_TPDF") == "1"




		dbSelectArea("GVT")
		GVT->( dbSetOrder(1) )
		If GVT->( dbSeek(xFilial("GVT") + FwFldGet("GW3_CDESP")) )
			cCalcn := IIF(!Empty(GVT->GVT_CALCN),GVT->GVT_CALCN,"3")
			If cCalcn == "1" .Or.  (cCalcn == "3" .And.  cOBNENT == "1")
				ChkObrigat := .T.
			EndIf
		EndIf
		Case FwFldGet("GW3_TPDF") == "2" .OR.  FwFldGet("GW3_TPDF") == "3"
		If cOBCOMP $ "1S"
			ChkObrigat := .T.
		EndIf

		Case FwFldGet("GW3_TPDF") == "4"
		If cOBREEN $ "1S"
			ChkObrigat := .T.
		EndIf

		Case FwFldGet("GW3_TPDF") == "5"
		If cOBDEV $ "1S"
			ChkObrigat := .T.
		EndIf

		Case FwFldGet("GW3_TPDF") == "6"
		If cOBREDE $ "1S"
			ChkObrigat := .T.
		EndIf
		Case FwFldGet("GW3_TPDF") == "7"
		If cOBSERV $ "1S"
			ChkObrigat := .T.
		EndIf
	EndCase


	If ChkObrigat

		If !oModelGW4:IsDeleted()
			dbSelectArea("GW1")
			GW1->( dbSetOrder(1) )
			GW1->( dbSeek(If(Empty(FwFldGet("GW4_FILIAL")),xFilial("GW4"),FwFldGet("GW4_FILIAL"))+FwFldGet("GW4_TPDC")+FwFldGet("GW4_EMISDC")+FwFldGet("GW4_SERDC")+FwFldGet("GW4_NRDC")) )

			dbSelectArea("GWH")
			GWH->( dbSetOrder(2) )
			If GWH->( dbSeek(GW1->GW1_FILIAL+GW1->GW1_CDTPDC+GW1->GW1_EMISDC+GW1->GW1_SERDC+GW1->GW1_NRDC) )


				While !Eof() .And.  GW1->GW1_FILIAL+GW1->GW1_CDTPDC+GW1->GW1_EMISDC+GW1->GW1_SERDC+GW1->GW1_NRDC == GWH->GWH_FILIAL+GWH->GWH_CDTPDC+GWH->GWH_EMISDC+GWH->GWH_SERDC+GWH->GWH_NRDC .And.  !lVldCalc

					dbSelectArea("GWF")
					GWF->( dbSetOrder(1) )
					GWF->( dbSeek(GWH->GWH_FILIAL+GWH->GWH_NRCALC) )


					If lVldCalc <> .T.  .And.  FwFldGet("GW3_TPDF") == GWF->GWF_TPCALC
						lVldCalc := .T.


						If FwFldGet("GW3_EMISDF") <> GWF->GWF_TRANSP
							If s_VLCNPJ_2 == "2"
								cCpnjDC     := Posicione("GU3", 1,xFilial("GU3") + GW3_EMISDF, "GU3_IDFED" )
								cCpnjDCNun  := SUBSTR(cCpnjDC,1,8)
								cCpnjDF  	 := Posicione("GU3", 1,xFilial("GU3") + GWF_TRANSP, "GU3_IDFED" )
								cCpnjDFNun  := SUBSTR(cCpnjDF,1,8)
								If cCpnjDCNun <> cCpnjDFNun
									lVldCalc := .F.
									lVldSrv := .T.
								EndIf
							Else
								lVldCalc := .F.
								lVldSrv := .T.
							EndIf
						EndIf
					EndIf



					If lVldCalc .And.  FwFldGet("GW3_TPDF") == GWF->GWF_TPCALC .And.  lExistCamp .And.  !Empty(GWF->(GWF_CDESP+GWF_EMISDF+GWF_SERDF+GWF_NRDF+DToS(GWF_DTEMDF))) .And.  GWF->(GWF_FILIAL+GWF_CDESP+GWF_EMISDF+GWF_SERDF+GWF_NRDF+DToS(GWF_DTEMDF)) <>  FwFldGet("GW3_FILIAL")+FwFldGet("GW3_CDESP")+FwFldGet("GW3_EMISDF")+FwFldGet("GW3_SERDF")+FwFldGet("GW3_NRDF")+DToS(FwFldGet("GW3_DTEMIS"))
						lVldCalc := .F.
						lVldSrv := .T.
					EndIf

					If GFXCP12117("GW3_CDTPSE")
						If lVldCalc .And.  FwFldGet("GW3_TPDF") == "7"
							If Empty(nRecPriClc)
								nRecPriClc := GWF->(Recno())
							EndIf
							If FwFldGet("GW3_CDTPSE") <> GWF->GWF_CDTPSE
								lVldCalc := .F.
								lVldSrv := .F.
							Else
								lVldSrv := .T.
							EndIf
						EndIf
					EndIf



					If lVldCalc .And.  FwFldGet("GW3_TPDF") == GWF->GWF_TPCALC .And.  lExistCamp .And.  !Empty(GWF->(GWF_CDESP+GWF_EMISDF+GWF_SERDF+GWF_NRDF+DToS(GWF_DTEMDF))) .And.  GWF->(GWF_FILIAL+GWF_CDESP+GWF_EMISDF+GWF_SERDF+GWF_NRDF+DToS(GWF_DTEMDF)) <>  FwFldGet("GW3_FILIAL")+FwFldGet("GW3_CDESP")+FwFldGet("GW3_EMISDF")+FwFldGet("GW3_SERDF")+FwFldGet("GW3_NRDF")+DToS(FwFldGet("GW3_DTEMIS"))
						lVldCalc := .F.
					EndIf

					dbSelectArea("GWH")
					dbSkip()
				EndDo

				If GFXCP12117("GW3_CDTPSE") .And.  lVldCalc == .F.  .And.  lVldSrv == .F.  .And.  !Empty(nRecPriClc)
					lVldCalc := .T.
					GWF->(dbGoTo(nRecPriClc))
				EndIf
			Else
				lVldCalc := .F.
			EndIf

			If !lVldCalc .and.  !(IsInCallStack("GFEA115") .or.  IsInCallStack("GFEA118"))
				Help( ,, "HELP",, "ï¿½ necessï¿½rio que haja um Cï¿½lculo de Frete para o Documento de Carga que possua o mesmo Tipo do Documento de Frete e Transportador do Cï¿½lculo igual ao Emissor do Documento de Frete.", 1, 0)
				lRet := .F.
			ElseIf !lVldCalc .and.  (IsInCallStack("GFEA115") .or.  IsInCallStack("GFEA118"))
				Help( ,, "HELP",, "ï¿½ necessï¿½rio que haja um Cï¿½lculo de Frete para o Documento de Carga (Emissor: "+ GW1->GW1_EMISDC + "Tipo: "+ GW1->GW1_CDTPDC +  "Serie; "+ GW1->GW1_SERDC +" e Nï¿½mero: " + GW1->GW1_NRDC +") que possua o mesmo Tipo do Documento de Frete e Transportador do Cï¿½lculo igual ao Emissor do Documento de Frete." , 1, 0)
				lRet := .F.
				Return .F.
			EndIf
		EndIf

	EndIf

Return lRet















User Function GFE65XF(lAutom,nOpc,lExec)

	Local lRet := .F.
	lRet := GFEA065In(lAutom, nOpc, lExec,"GFE65XF")

Return lRet

Static Function xGFE65XF(lAutom, nOpc, lExec)

	Local lRet     := .F.
	Local aRet     := {}
	Local dData    := nil
	Local lIntGFE  := SuperGetMv("MV_INTGFE" , .F. , .F. )
	Local cIntGFE2 := SuperGetMv("MV_INTGFE2", .F. ,"2")
	Local cSiGFE   := SuperGetMv("MV_SIGFE"  , .F. ,"2")
	Local cERPGFE  := SuperGetMv("MV_ERPGFE" , .F. ,"2")
	Local lIntDocF    := SuperGetMv("MV_DSCTB",, "1") == "2"
	Local lCpoTES  := u_GFE65INP()
	Local lcall115 := IsInCallStack("GFEA115")
	Local lcall118 := IsInCallStack("GFEA118")
	Local cDTInt   := SuperGetMv("MV_DSOFDT", .F. ,"1")
	Local lMsg     := .F.
	Local nVlMov  := 0
	Local dDtUlFe  := SuperGetMv("MV_DTULFE", .F. ,"01/01/1900")

	lAutom := If( lAutom == nil, .F. , lAutom )
	nOpc := If( nOpc == nil, "1", nOpc )
	lExec := If( lExec == nil, .F. , lExec )



	FwDateUpd( .T. )

	If !lcall115 .And.  !lcall118
		dData := dDatabase
	EndIf

	If lCpoTES
		cSiGFE := SuperGetMv("MV_SIGFE", .F. , "2")
	EndIf

	If !lAutom

		If dData <= dDtUlFe .and.  cERPGFE == "2"
			Help( ,, "Help",, If( cPaisLoc $ "ANG|PTG", "Data de transacção deve ser posterior a data do último fechamento: ", "Data de transação deve ser posterior a data do último fechamento: " ) + DToC(dDtUlFe) + " (Parâmetro MV_DTULFE)", 1, 0 )
			Return .F.
		EndIf


		If GW3->GW3_SITFIS <> "1" .AND. GW3->GW3_SITFIS <> "3"
			Help( ,, "Help",, "Somente Documentos de Frete Não-Enviado ou Rejeitado podem ser integrados", 1, 0 )
			Return .F.
		EndIf


		If GW3->GW3_SIT <> "3" .AND. GW3->GW3_SIT <> "4"
			Help( ,, "Help",, If( cPaisLoc $ "ANG|PTG", "Somente Documentos de Frete Aprov.Sistema ou Aprov.Utilizador podem ser integrados", "Somente Documentos de Frete Aprov.Sistema ou Aprov.Usuario podem ser integrados" ), 1, 0 )
			Return .F.
		EndIf

	EndIf


	If cERPGFE == "1"
		If lIntDocF
			dbSelectArea("GWA")
			GWA->(dbSetOrder(1))

			If GWA->(dbSeek(GW3->GW3_FILIAL+"2" +GW3->GW3_CDESP+GW3->GW3_EMISDF+GW3->GW3_SERDF+GW3->GW3_NRDF+ DtoS(GW3->GW3_DTEMIS)))






				While GWA->(!Eof()) .AND.  GWA->GWA_FILIAL == GW3->GW3_FILIAL .AND.  GWA->GWA_TPDOC  == "2" .AND.  GWA->GWA_CDESP  == GW3->GW3_CDESP .AND.  GWA->GWA_CDEMIT == GW3->GW3_EMISDF .AND.  GWA->GWA_SERIE  == GW3->GW3_SERDF .AND.  GWA->GWA_NRDOC  == GW3->GW3_NRDF .AND.  GWA->GWA_DTEMIS == GW3->GW3_DTEMIS

					nVlMov += GWA->GWA_VLMOV

					GWA->(DbSkip())
				EndDo
			EndIf

			If	nVlMov <> GW3->GW3_VLDF
				Help( ,, "Help",, "No modo de integraï¿½ï¿½o fiscal pelo Recebimento, o valor do documento: "+ cValToChar(GW3->GW3_VLDF) +" deve ser igual ao total dos rateios contï¿½beis: "+ cValToChar(nVlMov) +" ", 1, 0 )
				Return .F.
			EndIf
		EndIf
		If (cDTInt == "2" .or.  cDTInt == "3") .and.  (lcall115 .or.  lcall118)
			lMsg := .T.
			PosVal115(lMsg)
			Return .F.
		EndIf



		If cDTInt == "3"
			dData := u_UGFEADT()
			If Empty(dData)
				Return .F.
			EndIf

			If dData <= dDtUlFe .AND.  !lAutom
				Help( ,, "Help",, If( cPaisLoc $ "ANG|PTG", "Data de transacção deve ser posterior a data do último fechamento: ", "Data de transação deve ser posterior a data do último fechamento: " ) + DTOC(dDtUlFe) + " (Parâmetro MV_DTULFE)", 1, 0 )
				Return .F.
			EndIf
		EndIf




		If cDTInt == "2"
			dbSelectArea("GW6")
			dbSetOrder(1)
			If dbSeek(xFilial("GW6") + GW3->GW3_EMIFAT + GW3->GW3_SERFAT + GW3->GW3_NRFAT + DToS(GW3->GW3_DTEMFA))
				If GW6->GW6_SITFIN <> "4"
					Help( ,, "Help",, "A Fatura de Frete nï¿½o foi atualizada no financeiro.", 1, 0 )
					Return .F.
				EndIf

				If GW6->GW6_DTFIN <= dDtUlFe .AND.  !lAutom
					Help( ,, "Help",, If( cPaisLoc $ "ANG|PTG", "Data de envio da Factura de Frete deve ser posterior a data do último fechamento: ", "Data de envio da Fatura de Frete deve ser posterior a data do último fechamento: " ) + DTOC(dDtUlFe) + " (Parâmetro MV_DTULFE)", 1, 0 )
					Return .F.
				EndIf
			Else

				If GW3->GW3_TPDF <> "3"
					Help( ,, "Help",, "Integraï¿½ï¿½o com o fiscal nï¿½o executada, pois nï¿½o hï¿½ Fatura de Frete relacionado a este Documento de Frete para definir a data de transaï¿½ï¿½o. Verificar o parï¿½metro 'Data de Transaï¿½ï¿½o do Documento Fiscal' na aba 'Integraï¿½ï¿½es Datasul'.", 1, 0 )
					Return .F.
				EndIf
			EndIf

			If GW3->GW3_TPDF == "3"
				dData := u_UGFEADT()
				If Empty(dData)
					Return .F.
				EndIf
			Else
				dData := GW6->GW6_DTFIN
			EndIf
		EndIf





		If cDTInt == "1"
			If Empty(GW3->GW3_DTENT)
				Help( ,, "Help",, If( cPaisLoc $ "ANG|PTG", "A Factura de Frete não foi enviada", "A Fatura de Frete não foi enviada" ), 1, 0 )
				Return .F.
			EndIf

			If GW3->GW3_DTENT <= dDtUlFe .AND.  !lAutom
				Help( ,, "Help",, "Data de envio do Documento de Frete deve ser posterior a data do ï¿½ltimo fechamento: " + DTOC(dDtUlFe) + " (Parâmetro MV_DTULFE)", 1, 0 )
				Return .F.
			EndIf
			dData := GW3->GW3_DTENT
		EndIf
	EndIf


	If ExistBlock("XGFEENOF")
		aRotAdic := ExecBlock("XGFEENOF", .f. , .f. ,{GW3->GW3_FILIAL, GW3->GW3_CDESP, GW3->GW3_EMISDF, GW3->GW3_SERDF, GW3->GW3_NRDF, DTOS(GW3->GW3_DTEMIS)})
		If aRotAdic == .F.
			Return .F.
		endif
	EndIf





	If lCpoTES .And.  cERPGFE == "2"
		If lExec
			If cSiGFE == "1" .And.  nOpc == "1"
				lRet := u_GFE65IPR( .T. , "", nOpc )
				If !lRet
					Iif(FindFunction("APMsgAlert"), APMsgAlert("Operaï¿½ï¿½o Cancelada pelo Usuï¿½rio - Produto nï¿½o informado",), MsgAlert("Operaï¿½ï¿½o Cancelada pelo Usuï¿½rio - Produto nï¿½o informado",))
					Return .F.
				EndIf
			EndIf
			If !GFE065VCPO(nOpc, .T. )
				Return .F.
			EndIf
		ElseIf lAutom
			GFE065VCPO(nOpc, .T. )
		EndIf
	EndIf

	aRet := u_GFE65In("2", dData, nOpc)

	If !(lIntGFE == .T.  .And.  cIntGFE2 $ "1S")
		If !lAutom
			If aRet[1]
				Iif(FindFunction("APMsgInfo"), APMsgInfo("Documento de Frete enviado para atualizaï¿½ï¿½o no Fiscal.",), MsgInfo("Documento de Frete enviado para atualizaï¿½ï¿½o no Fiscal.",))
			Else
				Alert("Documento de Frete nï¿½o foi enviada para atualizaï¿½ï¿½o no Fiscal por causa do seguinte erro: " + aRet[1][6])
			EndIf
		EndIf
	EndIf

return lRet















User Function UGFE5VF(oModel,lAcao)
	Local lRet 		:= .T.
	Local nI
	Local oModelGW4  := oModel:getModel("UGFEA065_GW4")

	GW1->( dbSetOrder(1) )
	For nI := 1 To oModelGW4:Length()
		oModelGW4:GoLine(nI)
		If !oModelGW4:IsDeleted() .And.  !Empty(oModelGW4:GetValue("GW4_NRDC"))

			GW1->( dbSeek(xFilial("GW1") + oModelGW4:GetValue("GW4_TPDC") + oModelGW4:GetValue("GW4_EMISDC") + oModelGW4:GetValue("GW4_SERDC") + oModelGW4:GetValue("GW4_NRDC")) )
			If GW1->GW1_SITFRE <> "6" .And.  GW1->GW1_ORIGEM == "2"
				RecLock("GW1", .F. )
				GW1->GW1_SITFRE := "2"
				GW1->GW1_MOTFRE := "UGFEA065 - Documento de Frete"
				GW1->GW1_DTFRE := Date()
				GW1->( Msunlock() )
			EndIf
		EndIf
	next

Return lRet












User Function GFE65XC(lAutom,nOpc,lExec)
	Local lRet := .F.
	lRet := GFEA065In(lAutom, nOpc, lExec,"GFE65XC")
Return lRet






Static Function GFEA065In(lAutom, nOpc, lExec,cFunc)

	Local lRet	:= .F.

	If Alltrim(cFunc) == "GFE65XC"
		lRet	:= xGFE65XC(lAutom, nOpc, lExec)
	EndIf

	If Alltrim(cFunc) == "GFE65XF"
		lRet	:= xGFE65XF(lAutom, nOpc, lExec)
	EndIf

	If Alltrim(cFunc) == "GFE65XD"
		SetFunName("GFEA065")
		lRet	:= .T.
		xGFE65XD() //xGFE65XD(lAutom, nOpc, lExec) // THIAGO QUEIROZ - 20191004 - REMOVIDO PARAMETROS DA FUNÇÃO, NÃO CONDIZEM COM A FUNÇÃO REAL
	EndIf

return lRet

Static Function xGFE65XC(lAutom, nOpc, lExec)

	Local lRet       := .F.
	Local aRet       := {}
	Local dData      := CtoD("  /  /  ")
	Local dDataint   := Date()
	Local cParData   := SuperGetMV("MV_DSDTRE",,"1")
	Local lIntGFE    := SuperGetMv("MV_INTGFE", .F. , .F. )
	Local cIntGFE2   := SuperGetMv("MV_INTGFE2", .F. ,"2")
	Local cSitFinFat := ""
	Local cSiGFE     := SuperGetMv("MV_SIGFE", .F. , "2")
	Local cERPGFE    := SuperGetMv("MV_ERPGFE", .F. , "2")
	Local lcall115   := IsInCallStack("GFEA115")
	Local lcall118   := IsInCallStack("GFEA118")
	Local lCpoTES 	:= U_GFE65INP()
	Local dDtUlFe    := SuperGetMv("MV_DTULFE", .F. ,"01/01/1900")

	lAutom := If( lAutom == nil, .F. , lAutom )
	nOpc := If( nOpc == nil, "2", nOpc )
	lExec := If( lExec == nil, .F. , lExec )
	

	FwDateUpd( .T. )

	If lCpoTES
		cSiGFE := SuperGetMv("MV_SIGFE", .F. , "2")
	EndIf

	If !lcall115 .and.  !lcall118
		dDataint := dDatabase
	EndIf

	If dDataint <= dDtUlFe .and.  cERPGFE == "2"
		If !lAutom
			Help( ,, "Help",, If( cPaisLoc $ "ANG|PTG", "Data de transacção deve ser posterior a data do último fechamento: ", "Data de transação deve ser posterior a data do último fechamento: " ) + DToC(dDtUlFe) + " (Parâmetro MV_DTULFE)", 1, 0 )
		EndIf
		Return .F.
	EndIf


	If GW3->GW3_SITREC <> "1" .AND. GW3->GW3_SITREC <> "3"
		If !lAutom
			Help( ,, "Help",, "Somente Documentos de Frete Não-Enviado ou Rejeitado podem ser integrados", 1, 0 )
		EndIf
		Return .F.
	EndIf


	If GW3->GW3_SIT <> "3" .AND. GW3->GW3_SIT <> "4"
		If !lAutom
			Help( ,, "Help",, If( cPaisLoc $ "ANG|PTG", "Somente Documentos de Frete Aprov.Sistema ou Aprov.Utilizador podem ser integrados", "Somente Documentos de Frete Aprov.Sistema ou Aprov.Usuario podem ser integrados" ), 1, 0 )
		EndIf
		Return .F.
	EndIf

	If Empty(cParData)
		cParData := "1"
	EndIf


	If SUPERGETMV("MV_ERPGFE", .F. ,"2") == "1"
		If cParData == "3"
			dData := u_UGFEADT()
		ElseIf cParData == "1"
			dData := DDATABASE
		ElseIf cParData == "2"
			dData := GW3->GW3_DTENT
		ElseIf cParData == "4"
			dbSelectArea("GW6")
			dbSetOrder(1)
			If dbSeek(xFilial("GW6")+GW3->GW3_EMIFAT+GW3->GW3_SERFAT+GW3->GW3_NRFAT+DTOS(GW3->GW3_DTEMFA))
				cSitFinFat := GW6->GW6_SITFIN
				dData := GW6->GW6_DTFIN
				If cSitFinFat <> "4"
					Help( ,, "Help",, "A Fatura de Frete nï¿½o foi atualizada no financeiro.", 1, 0 )
					Return .F.
				EndIf
			else
				Help( ,, "Help",, "O parï¿½metro Data Integraï¿½ï¿½o Recebimento esta configurado para assumir a data do Financeiro, porï¿½m nï¿½o existe Fatura de Frete atualizada com o Financeiro para este Documento de Frete.", 1, 0 )
			EndIf
		EndIf

		If Empty(dData)
			Return .F.
		EndIf

		If dData <= dDtUlFe
			Help( ,, "Help",, If( cPaisLoc $ "ANG|PTG", "Data de transacção deve ser posterior a data do último fechamento: ", "Data de transação deve ser posterior a data do último fechamento: " ) + DTOC(dDtUlFe) + " (Parâmetro MV_DTULFE)", 1, 0 )
			Return .F.
		EndIf
	EndIf



	If lCpoTES .And.  cERPGFE == "2"
		If lExec
			If cSiGFE == "1"
				lRet := u_GFE65IPR( .T. , "", nOpc )
				If !lRet
					Iif(FindFunction("APMsgAlert"), APMsgAlert("Operaï¿½ï¿½o Cancelada pelo Usuï¿½rio - Produto nï¿½o informado",), MsgAlert("Operaï¿½ï¿½o Cancelada pelo Usuï¿½rio - Produto nï¿½o informado",))
					Return .F.
				EndIf
			EndIf
		ElseIf lAutom
			GFE065VCPO(nOpc, .T. )
		EndIf
	EndIf

	aRet := u_GFE65In("2", dData, nOpc)

	If !(lIntGFE == .T.  .And.  cIntGFE2 $ "1S")
		If !lAutom
			If aRet[1]
				lRet := .T.
				Iif(FindFunction("APMsgInfo"), APMsgInfo("Documento de Frete enviado para atualizaï¿½ï¿½o no Recebimento.",), MsgInfo("Documento de Frete enviado para atualizaï¿½ï¿½o no Recebimento.",))
			Else
				Alert("Documento de Frete nï¿½o foi enviado para atualizaï¿½ï¿½o no Recebimento. Motivo: " + aRet[1][6])
			EndIf
		EndIf
	EndIf

return lRet





User Function GFE65XD(cOp)
	GFEA065In(cOp, nil, nil,"GFE65XD")
Return Nil

Static Function xGFE65XD(cOp)

	Local aRet     := {}
	Local lIntGFE  := SuperGetMv("MV_INTGFE", .F. , .F. )
	Local cIntGFE2 := SuperGetMv("MV_INTGFE2", .F. ,"2")
	Local dDtUlFe  := SuperGetMv("MV_DTULFE", .F. ,"01/01/1900")
	Local cOp	   := "2"
	If cOp == "1" .And.  GW3->GW3_SITFIS <> "4"
		Help( ,, "Help",, "O Documento de Frete deve estar atualizado no Fiscal", 1, 0 )
		Return
	ElseIf cOp == "2" .And.  GW3->GW3_SITREC <> "4"
		Help( ,, "Help",, "O Documento de Frete deve estar atualizado no Recebimento", 1, 0 )
		Return
	EndIf

	If !Empty(GW3->GW3_DTFIS) .And.  GW3->GW3_DTFIS <= dDtUlFe
		Help( ,, "Help",, If( cPaisLoc $ "ANG|PTG", "Data de transacção deve ser posterior a data do último fechamento: ", "Data de transação deve ser posterior a data do último fechamento: " ) + DToC(dDtUlFe) + " (Parâmetro MV_DTULFE)", 1, 0 )
		Return
	EndIf

	If Existblock( "GFEA65XD" )
		If ! Execblock( "GFEA65XD" , .F.  , .F.  , {cOp} )
			Return
		EndIf
	EndIf

	If !Iif(FindFunction("APMsgNoYes"), APMsgNoYes("Deseja desatualizar o Documento de Frete no "+IIf(cOp=="1","Fiscal","Recebimento")+"?", "Aviso"), (cMsgNoYes:="MsgNoYes", &cMsgNoYes.("Deseja desatualizar o Documento de Frete no "+IIf(cOp=="1","Fiscal","Recebimento")+"?", "Aviso")))
		Return
	EndIf

	aRet := u_GFE65In("5", , cOp)

	If !(lIntGFE == .T.  .And.  cIntGFE2 $ "1S")
		If aRet[1]
			Iif(FindFunction("APMsgInfo"), APMsgInfo("Documento de Frete enviado para desatualizaï¿½ï¿½o no "+IIf(cOp=="1","Fiscal","Recebimento"),), MsgInfo("Documento de Frete enviado para desatualizaï¿½ï¿½o no "+IIf(cOp=="1","Fiscal","Recebimento"),))
		Else
			Alert("Documento de Frete nï¿½o foi enviada para desatualizaï¿½ï¿½o no " + IIf(cOp == "1", "Fiscal", "Recebimento") + " por causa do seguinte erro: " + aRet[2][6])
		EndIf
	EndIf

Return Nil
























User Function GFE65In(cSituacao,dData,tpAcaoInt,cFatu)
	Local oModelPai
	Local oModel
	Local aRet      := { .T. , {}}
	Local aRetAux   := { .T. ,"",""}
	Local cProg     := "1"
	Local cERPGFE   := SuperGetMv("MV_ERPGFE", .F. , "2")
	Local lCpoTES	:= u_GFE65INP()






	If lCpoTES
		cSiGFE := SuperGetMv("MV_SIGFE", .F. , "2")
	EndIf

	If cFatu == "1" .and.  cERPGFE == "2"
		aRet := GFEAIntGW3(cSituacao, dData, tpAcaoInt,cFatu)
	Else
		oModelPai := FWLoadModel("UGFEA065")
		oModel    := oModelPai:GetModel("UGFEA065_GW3")
		If cSituacao == "5"



			U_GFE65IPG(tpAcaoInt, "5",, @aRetAux)

			If !Empty(aRetAux[2])

				If aRetAux[1]

					RecLock("GW3", .F. )
					If tpAcaoInt == "1"
						GW3->GW3_SITFIS := "1"
						GW3->GW3_DTFIS  := CtoD("  /  /  ")
						GW3->GW3_MOTFIS := ""
					ElseIf tpAcaoInt == "2" .And.  !(GW3->GW3_TPDF == "3" .And.  GW3->GW3_VLDF == 0)
						GW3->GW3_SITREC := "1"
						GW3->GW3_DTREC  := CtoD("  /  /  ")
						GW3->GW3_MOTREC := ""
					EndIf
					GW3->( MsUnlock() )

					Return { .T. , {}}

				Else

					RecLock("GW3", .F. )
					If tpAcaoInt == "1"
						GW3->GW3_SITFIS := "4"
						GW3->GW3_MOTFIS := aRetAux[3]
					ElseIf tpAcaoInt == "2"
						GW3->GW3_SITREC := "4"
						GW3->GW3_MOTREC := aRetAux[3]
					EndIf
					GW3->( MsUnlock() )

					Return { .F. , {,,,,,aRetAux[3]}}

				EndIf

			EndIf

		EndIf

		oModelPai:SetOperation( 4 )
		oModelPai:Activate()

		If cERPGFE == "2"
			If AllTRIM(tpAcaoInt) $ "1;3"
				oModel:SetValue( "GW3_ACINT", "1" )
			ElseIf AllTRIM(tpAcaoInt) == "2"
				oModel:SetValue( "GW3_ACINT", "2" )
			ElseIf AllTRIM(tpAcaoInt) == "4"
				oModel:SetValue( "GW3_ACINT", "3" )
			ElseIf AllTRIM(tpAcaoInt) == "5"
				oModel:SetValue( "GW3_ACINT", "4" )
			Else
				oModel:SetValue( "GW3_ACINT", AllTRIM(tpAcaoInt) )
			EndIf
		EndIf

		If IsInCallStack("GFEA115AIN")
			cProg = "2"
		EndIf


		If tpAcaoInt $ "1;3" .And.  oModel:getValue("GW3_SITFIS") <> "6"

			oModel:SetValue("GW3_SITFIS", AllTrim(cSituacao))

			If cSituacao <> "5"
				oModel:SetValue("GW3_DTFIS", dData)
			EndIf

			If cSituacao == "2"
				oModel:ClearField("GW3_MOTFIS")
			EndIf

		EndIf


		If tpAcaoInt $ "2;3" .And.  oModel:getValue("GW3_SITREC") <> "6"

			oModel:SetValue("GW3_SITREC", AllTrim(cSituacao))

			If cSituacao <> "5"
				oModel:SetValue("GW3_DTREC",  dData)
			EndIf

			If cSituacao == "2"
				oModel:ClearField("GW3_MOTREC")
			EndIf

		EndIf

		If cSituacao == "3" .Or.  cSituacao == "4"

			GFERatDF( .F. ,oModel:getValue("GW3_CDESP"),oModel:getValue("GW3_EMISDF"),oModel:getValue("GW3_SERDF"),oModel:getValue("GW3_NRDF"),oModel:getValue("GW3_DTEMIS"))
			If GFXTB12117("GWC")



				If oModel:GetOperation() == 3 .And.  oModelGW3:GetValue("GW3_SIT") == "3"
					u_UGFEA065CTP("IA")
				ElseIf oModel:GetOperation() == 4
					If SuperGetMv("MV_GFEI21", .F. ,"3") == "1" .And.  oModelGW3:GetValue("GW3_SIT") == "2"
						u_UGFEA065CTP("P")
					ElseIf SuperGetMv("MV_GFEI21", .F. ,"3") == "2" .And.  oModelGW3:GetValue("GW3_SIT") == "3"
						u_UGFEA065CTP("E")
						u_UGFEA065CTP("IA")
					EndIf
				EndIf
			EndIf
		EndIf

		If tpAcaoInt == "4"

			oModel:SetValue("GW3_SITFIS", AllTrim(cSituacao))

			If cSituacao <> "5"
				oModel:SetValue("GW3_DTFIS", dData)
			EndIf

			If cSituacao == "2"
				oModel:ClearField("GW3_MOTFIS")
			EndIf

		end

		If tpAcaoInt == "5"

			oModel:SetValue("GW3_SITREC", AllTrim(cSituacao))

			If cSituacao <> "5"
				oModel:SetValue("GW3_DTREC", dData)
			EndIf

			If cSituacao == "2"
				oModel:ClearField("GW3_MOTREC")
			EndIf

		end

		If oModelPai:VldData()
			oModelPai:CommitData()
			If !IsInCallStack("U_UGFEA065")

				If tpAcaoInt $ "1;3;4"
					If oModel:GetValue("GW3_SITFIS") == "3"
						aRet := { .F. , {,,,,,oModel:GetValue("GW3_MOTFIS"),,,}}
					EndIf
				EndIf
				If tpAcaoInt $ "2;3;5"
					If oModel:GetValue("GW3_SITREC") == "3"
						aRet := { .F. , {,,,,,oModel:GetValue("GW3_MOTREC"),,,}}
					EndIf
				EndIf
			EndIf
		Else
			aRet := { .F. , oModelPai:GetErrorMessage()}
		EndIf

		oModelPai:Deactivate()
		oModelPai:Destroy()
		oModelPai := nil
	EndIf

Return aRet














User Function UGFEADT()
	Local dData := Date()
	Local lOk := .F.

	oDlg = TDialog():New( 180, 180, 350, 460, "Seleciona a data de transaï¿½ï¿½o no fiscal",,,.F.,,,,,,.T.,,,,, )

	oMsCalend := MsCalend():New(01,01,oDlg, .F. )


	oMsCalend:dDiaAtu := dData


	oMsCalend:bChange := {|| dData := oMsCalend:dDiaAtu}

	oTButton1 := TButton():New( 070, 30, "Ok",oDlg,{||lOk := .T. ,oDlg:End()}, 40,10,,, .F. , .T. , .F. ,, .F. ,,, .F.  )
	oTButton1 := TButton():New( 070, 75, "Cancelar",oDlg,{||oDlg:End()}, 40,10,,, .F. , .T. , .F. ,, .F. ,,, .F.  )

	oDlg:Activate( oDlg:bLClicked, oDlg:bMoved, oDlg:bPainted,.T.,,,, oDlg:bRClicked, )

	If !lOk
		dData := nil
	EndIf

Return dData



User Function GFE65CC()
	Local lRet       := .T.
	Local aColsComp  := {}
	Local nSeqComp   := 000
	Local cNrCalcPri := ""

	dbSelectArea("GW4")
	dbSetOrder(1)
	If dbSeek(xFilial("GW4")+GW3->GW3_EMISDF+GW3->GW3_CDESP+GW3->GW3_SERDF+GW3->GW3_NRDF+DTOS(GW3->GW3_DTEMIS))

		dbSelectArea("GWH")
		dbSetOrder(2)
		dbSeek(xFilial("GWH")+GW4->GW4_TPDC+GW4->GW4_EMISDC+GW4->GW4_SERDC+GW4->GW4_NRDC)
		While !Eof() .and.  xFilial("GWH")+GWH->GWH_CDTPDC+GWH->GWH_EMISDC+GWH->GWH_SERDC+GWH->GWH_NRDC == xFilial("GW4")+GW4->GW4_TPDC+GW4->GW4_EMISDC+GW4->GW4_SERDC+GW4->GW4_NRDC

			dbSelectArea("GWF")
			dbSetOrder(1)
			dbseek(xFilial("GWF")+GWH->GWH_NRCALC)

			IF GWF->GWF_TPCALC == GW3->GW3_TPDF .And.  GWF->GWF_TRANSP == GW3->GW3_EMISDF

				dbSelectArea("GWI")
				dbSetOrder(1)
				dbSeek(xFilial("GWI")+GWH->GWH_NRCALC)

				While !Eof() .and.  GWI->GWI_NRCALC == GWH->GWH_NRCALC
					nSeqComp += 1



					aAdd(aColsComp,{ nSeqComp ,									  GWI->GWI_CDCOMP,									  GWI->GWI_VLFRET, GW3->GW3_EMISDF})

					cNrCalcPri := GWH->GWH_NRCALC

					dbSelectArea("GWI")
					GWI->( dbSkip() )
				EndDo

			EndIf

			dbSelectArea("GWH")
			GWH->( dbSkip() )
		EndDo

		If Empty(cNrCalcPri)

			nSeqComp += 1




			aAdd(aColsComp,{ nSeqComp ,							 GWI->GWI_CDCOMP,							 GWI->GWI_VLFRET, GW3->GW3_EMISDF })
		EndIf

		dbSelectArea("GW4")
		GW4->( dbSkip() )
	EndIf

	UGFEA065A(aColsComp,cNrCalcPri)

return (lRet)



Static Function UGFEA065ADD(oPanel,oView)

	TButton():New( 10, 10, "Doc.Relac.", oPanel,{||  GFEADOCRE(FwFldGet("GW4_TPDC"),FwFldGet("GW4_EMISDC"),FwFldGet("GW4_SERDC"),FwFldGet("GW4_NRDC"))}, 36, 13,,,.F.,.T.,.F., "Documentos Relacionados",.F.,,,.F. )
	If GFXXB12117("GWJPRE")
		TButton():New( 30, 10, "Doc.Prï¿½-Fat", oPanel,{||  GFEADOCPF()}, 36, 13,,,.F.,.T.,.F., "Documentos Relacionados",.F.,,,.F. )
	EndIf

Return .T.



Static Function GFEADOCRE(cTpDc, cEmisDc, cSerDc, cNrDc)
	Local oView     := FWViewActive()
	Local oModel    := oView:GetModel()
	Local oModelGW4 := oModel:GetModel("UGFEA065_GW4")
	Local aAreaGWH  := GWH->(GetArea())
	Local aAreaGWF  := GWF->(GetArea())
	Local aPosGWH
	Local nLineaUX
	Local nTotLen

	Local nCalc     := 0
	Local nDC       := 0
	Local nChange   := 0
	Local aErroGW4
	Local cGW3_TPDF
	Local cGW3_EMISDF

	If __lCpoSDoc == Nil
		__lCpoSDoc := Len(TamSX3("GW4_SDOCDC")) > 0
	EndIf

	nLineaUX := oModelGW4:GetLine()

	If oModelGW4:IsEmpty()
		Help(,,"HELP",, "Informe pelo menos um Documento de Carga para buscar os relacionados a ele.", 1, 0)
		Return .F.
	EndIf

	If oModelGW4:IsDeleted()
		Help(,,"HELP",, "O registro selecionado estï¿½ deletado.", 1, 0)
		Return .F.
	EndIf

	If !oModelGW4:VldLineData()
		aErroGW4 := oModel:GetErrorMessage()
		Help(,,"HELP",, aErroGW4[6], 1, 0)
		Return .F.
	EndIf
	cGW3_TPDF 	:= FwFldGet("GW3_TPDF")
	cGW3_EMISDF	:= FwFldGet("GW3_EMISDF")

	dbSelectArea("GWH")
	GWH->( dbSetOrder(2) )
	GWH->( dbSeek(xFilial("GWH") + cTpDc + cEmisDc + cSerDc + cNrDc) )





	While !GWH->( Eof() ) .And.  GWH->GWH_FILIAL == xFilial("GWH") .And.  GWH->GWH_CDTPDC == cTpDc .And.  GWH->GWH_EMISDC == cEmisDc .And.  GWH->GWH_SERDC  == cSerDc .And.  GWH->GWH_NRDC   == cNrDc

		aPosGWH := GWH->( GetArea() )

		dbSelectArea("GWF")
		GWF->( dbSetOrder(1) )
		If GWF->( dbSeek(xFilial("GWF") + GWH->GWH_NRCALC) )
			If GWF->GWF_TPCALC == cGW3_TPDF .And.  (!GFXCP12117("GW3_CDTPSE") .OR.  FwFldGet("GW3_CDTPSE") == GWF->GWF_CDTPSE) .And.  GWF->GWF_TRANSP == cGW3_EMISDF
				nCalc++

				dbSelectArea("GWH")
				GWH->( dbSetOrder(1) )
				GWH->( dbSeek(xFilial("GWH") + GWF->GWF_NRCALC) )


				While !GWH->( Eof() ) .AND.  GWH->GWH_FILIAL == xFilial("GWH") .AND.  GWF->GWF_NRCALC == GWH->GWH_NRCALC

					dbSelectArea("GW1")
					GW1->( dbSetOrder(1) )
					If GW1->( dbSeek(xFilial("GW1") + GWH->GWH_CDTPDC + GWH->GWH_EMISDC + GWH->GWH_SERDC + GWH->GWH_NRDC) )


						If oModelGW4:SeekLine({{"GW4_TPDC", GW1->GW1_CDTPDC}, {"GW4_EMISDC", GW1->GW1_EMISDC}, {"GW4_SERDC", GW1->GW1_SERDC}, {"GW4_NRDC", GW1->GW1_NRDC}})

							If oModelGW4:IsDeleted()
								oModelGW4:UndeleteLine()
								nDc++

							ElseIf GW1->GW1_CDTPDC + GW1->GW1_EMISDC + GW1->GW1_SERDC + GW1->GW1_NRDC <> cTpDc + cEmisDc + cSerDc + cNrDc
								nDc++
								nChange++
							EndIf

							oModelGW4:GoLine( nLineaUX )
							GWH->( dbSetOrder(1) )
							GWH->( dbSkip() )
							Loop
						EndIf

						nTotLen := oModelGW4:Length() + 1

						If oModelGW4:AddLine() <> nTotLen
							Help(,,"HELP",, oModel:GetErrorMessage()[6],1,0)
						Else
							nDc++
							oModelGW4:LoadValue("GW4_TPDC"  , GW1->GW1_CDTPDC)
							oModelGW4:LoadValue("GW4_EMISDC", GW1->GW1_EMISDC)
							oModelGW4:LoadValue("GW4_NMEMIS", POSICIONE("GU3", 1, xFilial("GU3") + GW1->GW1_EMISDC, "GU3_NMEMIT"))
							oModelGW4:LoadValue("GW4_SERDC" , GW1->GW1_SERDC )
							oModelGW4:LoadValue("GW4_NRDC"  , GW1->GW1_NRDC  )
							If __lCpoSDoc
								oModelGW4:LoadValue("GW4_SDOCDC", GW1->GW1_SDOC)
							EndIf
						EndIf

					EndIf

					GWH->( dbSkip() )
				EndDo

			EndIf

		EndIf

		RestArea(aPosGWH)

		GWH->( dbSkip() )
	EndDo

	RestArea(aAreaGWF)
	RestArea(aAreaGWH)

	oModelGW4:SetLine(nLineaUX)
	oView:Refresh()

	If nCalc == 0
		Help(,,"HELP",, "Nï¿½o foram encontrados Cï¿½lculos do tipo " + GFEFldInfo("GW3_TPDF", FwFldGet("GW3_TPDF"), 2) + " para o Documento de Carga.", 1, 0)
	ElseIf nDC == 0
		Help(,,"HELP",, "Nï¿½o foram encontrados outros Documentos de Carga para vincular ao Documento de Frete.", 1, 0)
	ElseIf nDC == nChange
		Help(,,"HELP",, "Todos os Documentos de Carga relacionados a este jï¿½ foram vinculados.", 1, 0)
	EndIf

Return


User Function UGFETTD()
	Local cEmisDf := FwFldGet("GW3_EMISDF")
	Local cCdEsp  := FwFldGet("GW3_CDESP" )
	Local lRet    := "1"
	Local cTpImp


	dbSelectArea("GVT")
	dbSetOrder(1)
	If dbSeek(xFilial("GVT")+cCdEsp)
		If GVT->GVT_TPIMP == "1"
			cTpImp := "1"
		Else
			cTpImp := "2"
		EndIf
	EndIf

	dbSelectArea("GU3")
	dbSetOrder(1)
	If dbSeek(xfilial("GU3")+cEmisDf)

		If (cTpImp == "1" .And.  GU3->GU3_CONICM == "2") .Or.  (cTpImp == "2" .And.  GU3->GU3_CONISS == "2")
			lRet := "2"
		Else
			If cTpImp == "1"
				If GU3->GU3_APUICM == "1"
					lRet := "1"
				ElseIf GU3->GU3_APUICM == "2"
					lRet := "3"
				ElseIf GU3->GU3_APUICM == "3"
					lRet := "4"
				ElseIf GU3->GU3_APUICM == "4"
					lRet := "7"
				EndIf
			ElseIf cTpImp == "2"
				If GU3->GU3_APUISS == "1"
					lRet := "1"
				Else
					lRet := "2"
				EndIf
			EndIf
		EndIf
	EndIf
Return lRet

User Function GFE65BIM()
	Local cCdEsp  := FwFldGet("GW3_CDESP"  )
	Local nVlPeda := FwFldGet("GW3_PEDAG"  )
	Local cPdgFrt := FwFldGet("GW3_PDGFRT" )
	Local cIcmPdg := FwFldGet("GW3_ICMPDG" )
	Local nVlDf   := FwFldGet("GW3_VLDF"   )
	Local nVlBase := 0

	dbSelectArea("GVT")
	dbSetOrder(1)
	If dbSeek(xFilial("GVT")+cCdEsp)
		If GVT->GVT_TPIMP == "1"
			If cPdgFrt == "1" .And.  cIcmPdg == "2"
				If nVlDf > 0
					nVlBase := nVlDf - nVlPeda
				EndIf
			Else
				nVlBase := nVlDf
			EndIf
		EndIf
	EndIf

Return nVlBase

User Function UGFEVIM()
	Local nPcImp  := FwFldGet("GW3_PCIMP"  )
	Local nBasImp := FwFldGet("GW3_BASIMP" )
	Local cTpTrib := FwFldGet("GW3_TRBIMP" )
	Local nVlImp  := 0

	If cTpTrib == "2" .And.  nPcImp > 0
		Return .F.
	EndIf
	nVlImp := nBasImp * ( nPcImp / 100 )

Return nVlImp














User Function UGFEAPRE()

	Local cTpTrib := FwFldGet("GW3_TRBIMP")
	Local cEmisDf := FwFldGet("GW3_EMISDF")
	Local cNrCid  := ""
	Local cCdUf   := ""
	Local cIcmPre := 0

	If cTpTrib == "7"
		cNrCid  := Posicione("GU3", 1,xFilial("GU3") + cEmisDf, "GU3_NRCID" )
		cCdUf   := Posicione("GU7", 1,xFilial("GU7") + cNrCid , "GU7_CDUF"  )
		cIcmPre := Posicione("GUT", 1,xFilial("GUT") + cCdUf  , "GUT_ICMPRE")
	EndIf

Return cIcmPre



User Function GFE65IMP()

	Local cTpTrib  := FwFldGet("GW3_TRBIMP")
	Local nBasImp  := FwFldGet("GW3_BASIMP")
	Local nPcImp   := FwFldGet("GW3_PCIMP")
	Local nPcRet   := FwFldGet("GW3_PCRET")
	Local nVlImpre := 0

	If cTpTrib == "7"
		nVlImpre := nBasImp * nPcImp / 100 * (1 - (nPcRet / 100))
	ElseIf cTpTrib == "3"
		nVlImpre := nBasImp * nPcImp / 100
	EndIf

Return nVlImpre













User Function GFEA65GTRB()
	Local cCdEsp  := FwFldGet("GW3_CDESP")
	Local cCdEmis := FwFldGet("GW3_EMISDF")
	Local cApuIcms
	Local cApuIss
	Local cTipoImpEsp := Posicione("GVT", 1, xFilial("GVT")+cCdEsp, "GVT_TPIMP")

	If !Empty(cCdEmis) .And.  !Empty(cCdEsp)

		If cTipoImpEsp == "1"
			If Posicione("GU3", 1, xFilial("GU3")+cCdEmis, "GU3_CONICM") == "2"
				Return "2"
			Else
				cApuIcms := GU3->GU3_APUICM
				If cApuIcms == "1"
					Return "1"
				ElseIf cApuIcms == "2"
					Return "3"
				ElseIf cApuIcms == "3"
					Return "4"
				ElseIf cApuIcms == "4"
					Return "7"
				EndIf
			EndIf
		EndIf


		If cTipoImpEsp == "2"
			If Posicione("GU3", 1, xFilial("GU3")+cCdEmis, "GU3_CONISS") == "2"
				Return "2"
			Else
				cApuIss := GU3->GU3_APUISS
				If cApuIss == "1"
					Return "1"
				ElseIf cApuIss == "2"
					Return "3"
				ElseIf cApuIss == "3"
					Return "4"
				ElseIf cApuIss == "4"
					Return "7"
				EndIf
			EndIf
		EndIf
	EndIf
Return FwFldGet("GW3_TRBIMP")













User Function GFEA65ACT(oModel)
	Local oModelGW3 	:= oModel:GetModel("UGFEA065_GW3")
	Local aFieldGW3 	:= oModelGW3:GetStruct():aFields
	Local nI
	Local aCmpGW3		:= {""}


	If U_GFE65INP()


		aCmpGW3 := {"GW3_CDESP", "GW3_EMISDF", "GW3_SERDF", "GW3_DTEMIS", "GW3_CDREM", "GW3_CDDEST", "GW3_TPDF", "GW3_DTENT", "GW3_CFOP", "GW3_PDGFRT", "GW3_ICMPDG", "GW3_PDGPIS", "GW3_TRBIMP", "GW3_PCIMP", "GW3_CDCONS", "GW3_OBS", "GW3_DSOFIT", "GW3_DSOFDT", "GW3_PCRET", "GW3_TPIMP", "GW3_PRITDF", "GW3_CPDGFE", "GW3_CONTA", "GW3_ITEMCT", "GW3_CC", "GW3_TES" }
	Else


		aCmpGW3 := {"GW3_CDESP", "GW3_EMISDF", "GW3_SERDF", "GW3_DTEMIS", "GW3_CDREM", "GW3_CDDEST", "GW3_TPDF", "GW3_DTENT", "GW3_CFOP", "GW3_PDGFRT", "GW3_ICMPDG", "GW3_PDGPIS", "GW3_TRBIMP", "GW3_PCIMP", "GW3_CDCONS", "GW3_OBS", "GW3_DSOFIT", "GW3_DSOFDT", "GW3_PCRET", "GW3_TPIMP", "GW3_PRITDF" }
	EndIf


	FwDateUpd( .T. )

	dDataDf := oModel:getValue("UGFEA065_GW3","GW3_DTENT")

	If oModel:GetOperation() == 3
		oModel:GetModel("UGFEA065_GW3"):SetValue("GW3_DTENT",dDataBase)
	EndIf

	If IsInCallStack("U_UGFEA065") .And.  lCopy

		For nI := 1 To Len(aFieldGW3)

			If aFieldGW3[nI][3] == "GW3_SIT"
				oModelGW3:SetValue(aFieldGW3[nI][3], "1")
			ElseIf aFieldGW3[nI][3] == "GW3_SITFIS"
				oModelGW3:SetValue(aFieldGW3[nI][3], "1")
			ElseIf aFieldGW3[nI][3] == "GW3_SITREC"
				oModelGW3:SetValue(aFieldGW3[nI][3], "1")
			ElseIf aFieldGW3[nI][3] == "GW3_USUIMP"
				oModelGW3:SetValue(aFieldGW3[nI][3], cUserName)
			ElseIf aFieldGW3[nI][3] == "GW3_DTENT"
				Loop
			ElseIf aFieldGW3[nI][3] == "GW3_DESCUS"
				If GFXTB12117("GWC")
					oModelGW3:SetValue(aFieldGW3[nI][3], u_UGFEAGTP(oModelGW3:GetValue("GW3_TPDF")))
				EndIf
			ElseIf aFieldGW3[nI][3] == "GW3_SITCUS"
				If GFXTB12117("GWC")
					oModelGW3:SetValue(aFieldGW3[nI][3], IIf (u_UGFEACTA(), "1", "0"))
				EndIf
			ElseIf aFieldGW3[nI][14]
				Loop
			ElseIf aScan( aCmpGW3, {|x| x == aFieldGW3[nI][3] } ) > 0
				oModelGW3:SetValue(aFieldGW3[nI][3], &("GW3->"+aFieldGW3[nI][3]))
			Else
				oModel:ClearField("UGFEA065_GW3", aFieldGW3[nI][3])
			EndIf

		next

		lCopy := .F.

	EndIf

Return Nil













User Function GFEA65CP()

	lCopy := .T.

	FWExecView("Cópia","UGFEA065",3,,{|| .T. })

Return Nil












Static Function UGFEA065GW8(oModel)

	Local nCont
	Local aStruc    := {}
	Local aRet      := {}
	Local aCmp      := {}
	Local nRec      := 1
	Local aInfo01   := {}
	Local oModelGW4 := oModel:GetModel():GetModel("UGFEA065_GW4")

	aStruc := oModel:GetStruct()

	dbSelectArea("GW8")
	GW8->( dbSetOrder(1) )

	GW8->( dbSeek(xFilial("GW8") + oModelGW4:GetValue("GW4_TPDC") + oModelGW4:GetValue("GW4_EMISDC") + oModelGW4:GetValue("GW4_SERDC") + oModelGW4:GetValue("GW4_NRDC")) )


	While !GW8->( Eof() ) .And.  xFilial("GW8") == GW8->GW8_FILIAL .And.  oModelGW4:GetValue("GW4_TPDC") == GW8->GW8_CDTPDC .And.  oModelGW4:GetValue("GW4_EMISDC") == GW8->GW8_EMISDC .And.  oModelGW4:GetValue("GW4_SERDC") == GW8->GW8_SERDC .And.  oModelGW4:GetValue("GW4_NRDC") == GW8->GW8_NRDC

		If aScan(aInfo01, {|x| x == GW8->GW8_INFO1}) == 0

			For nCont := 1 To Len(aStruc:aFields)

				AAdd(aCmp, &("GW8->" + aStruc:aFields[nCont][3]))

			next


			AAdd(aRet, {nRec, aCmp})

			aCmp := {}
			nRec++

			AAdd(aInfo01, GW8->GW8_INFO1)

		EndIf

		GW8->( dbSkip() )

	EndDo


	If Empty(aRet)
		aRet := {{0,&("{" + Replicate(",", Len(aStruc:aFields)-1) + "}")}}
	EndIf

Return aRet





User Function GFE5GFAT(lInterface)

	Local aValues    :={}
	Local aAreaGW3 := GW3->( GetArea() )
	Local cAliasQry := ""
	Local cQuery    := ""
	Local dDtVenc    := Nil
	Local lExistCamp := GFXCP12116("GWF","GWF_CDESP") .And.  (SuperGetMV("MV_DPSERV", .F. , "1") == "1") .And.  (FindFunction("u_UGFVFIX") .And.  u_UGFVFIX())
	Local cCalVenFat := "1"

	If lInterface .And.  !(GW3->GW3_SIT $ "3;4")
		Help( ,, "Help",, "O Documento de Frete deve estar aprovado para a geraï¿½ï¿½o da Fatura.", 1, 0 )
		Return
	EndIf

	If !lInterface .And.  Posicione("GU3", 1, xFilial("GU3") + GW3->GW3_EMISDF, "GU3_FATAUT") <> "1"
		Return
	EndIf

	If lInterface
		dbSelectArea("GW6")
		GW6->( dbSetOrder(1) )
		If dbSeek(xFilial("GW6") + GW3->GW3_EMISDF + GW3->GW3_SERDF + GW3->GW3_NRDF )
			Help( ,, "Help",, "Fatura jï¿½ cadastrada no sistema. A fatura jï¿½ existe no sistema portanto este documento de frete deverï¿½ ser vinculado a uma fatura manualmente.", 1, 0 )
			Return
		EndIf
	elseIf IsInCallStack("GFEA066OK")
		dbSelectArea("GW6")
		GW6->( dbSetOrder(1) )
		If dbSeek(xFilial("GW6") + GW3->GW3_EMISDF + GW3->GW3_SERDF + GW3->GW3_NRDF )
			If (GW6->GW6_SITFIN == "1")
				Help( ,, "Help",, "Fatura jï¿½ cadastrada no sistema. A fatura jï¿½ existe no sistema portanto este documento de frete deverï¿½ ser vinculado a uma fatura manualmente.", 1, 0 )
				Return
			EndIf
		EndIf
	ElseIf (IsInCallStack("U_UGFEA065") .Or.  IsInCallStack("GFEA115")) .And.  (GW3->GW3_SIT == "3" .Or.  GW3->GW3_SIT == "4")
		dbSelectArea("GW6")
		GW6->( dbSetOrder(1) )
		If dbSeek(xFilial("GW6") + GW3->GW3_EMISDF + GW3->GW3_SERDF + GW3->GW3_NRDF )
			If (GW6->GW6_SITFIN == "1")
				Help( ,, "Help",, "Fatura jï¿½ cadastrada no sistema. A fatura jï¿½ existe no sistema portanto este documento de frete deverï¿½ ser vinculado a uma fatura manualmente.", 1, 0 )
				Return
			EndIf
		EndIf
	ElseIf (IsInCallStack("U_UGFEA065") .Or.  IsInCallStack("GFEA115")) .And.  (GW3->GW3_SIT == "1" .or. GW3->GW3_SIT == "2")
		dbSelectArea("GW6")
		GW6->( dbSetOrder(1) )
		If dbSeek(xFilial("GW6") + FwFldGet("GW3_EMISDF") + FwFldGet("GW3_SERDF") + (FwFldGet("GW3_NRDF") ))
			Help( ,, "Help",, "Fatura jï¿½ cadastrada no sistema. A fatura jï¿½ existe no sistema portanto este documento de frete deverï¿½ ser vinculado a uma fatura manualmente.", 1, 0 )
			Return
		EndIf
	ElseIF IsInCallStack("U_GFE65XF")
		dbSelectArea("GW6")
		GW6->( dbSetOrder(1) )
		If dbSeek(xFilial("GW6") + GW3->GW3_EMISDF + GW3->GW3_SERDF + GW3->GW3_NRDF )
			Return
		EndIf
	EndIf


	If !Empty(GW3->GW3_FILFAT + GW3->GW3_EMIFAT + GW3->GW3_SERFAT + GW3->GW3_NRFAT + DToS(GW3->GW3_DTEMFA))

		If lInterface
			Help( ,, "Help",, "O Documento de Frete jï¿½ estï¿½ vinculado a uma Fatura.", 1, 0 )
		EndIf

		Return
	EndIf

	If GW3->GW3_TPDF == "3" .And.  GW3->GW3_VLDF == 0
		If lInterface
			Help( ,, "HELP",, "Nï¿½o ï¿½ permitido gerar uma fatura para o documento de frete deste tipo com valor zerado.", 1, 0)
		EndIf

		Return
	EndIf

	If !Empty(GW3->GW3_DTVNFT)

		dDtVenc := GW3->GW3_DTVNFT
	Else

		dDtVenc := GFECalcVc(GW3->GW3_DTEMIS, GW3->GW3_EMISDF)

		If lInterface






			cCalVenFat := SuperGetMV("MV_GFECVFA", .T. ,"1")


			If cCalVenFat == "3" .Or.  (cCalVenFat == "1" .And.  Posicione("GU3", 1, xFilial("GU3") + GW3->GW3_EMISDF, "GU3_CALCVC") == "2")

				oDlg = TDialog():New( 180, 180, 350, 460, "Selecione a Data de Vencimento",,,.F.,,,,,,.T.,,,,, )
				oMsCalend := MsCalend():New(01,01,oDlg, .F. )
				oMsCalend:dDiaAtu := dDtVenc
				oMsCalend:bChange := {|| dDtVenc := oMsCalend:dDiaAtu}
				oTButton1 := TButton():New( 070, 30, "Ok" ,oDlg,{||oDlg:End()}, 40,10,,, .F. , .T. , .F. ,, .F. ,,, .F.  )
				lOK := .T.
				oDlg:Activate( oDlg:bLClicked, oDlg:bMoved, oDlg:bPainted,.T.,,,, oDlg:bRClicked, )

			EndIf

		EndIf

	EndIf

	If Empty(dDtVenc)
		dDtVenc := GW3->GW3_DTENT
	EndIf













	aValues := { {{"GW6_FILIAL", xFilial("GW6") }, {"GW6_EMIFAT" , GW3->GW3_EMISDF}, {"GW6_NRFAT"  , GW3->GW3_NRDF  }, {"GW6_SERFAT" , GW3->GW3_SERDF }, {"GW6_DTEMIS" , GW3->GW3_DTEMIS}, {"GW6_DTCRIA" , GW3->GW3_DTENT }, {"GW6_DTVENC" , dDtVenc        }, {"GW6_VLFATU" , GW3->GW3_VLDF  }, {"GW6_ORIGEM" , "3"}, {"GW6_SITAPR" , "1"}, {"GW6_SITFIN" , "1"}} }
	if GFXCP12117("GW6_USUIMP")
		aAdd(aValues[1],{"GW6_USUIMP" ,CUSERNAME})
	EndIf

	If GFEINSFAT(aValues)


		RecLock("GW3", .F. )
		GW3->GW3_FILFAT := xFilial("GW6")
		GW3->GW3_EMIFAT := GW3->GW3_EMISDF
		GW3->GW3_SERFAT := GW3->GW3_SERDF
		GW3->GW3_NRFAT  := GW3->GW3_NRDF
		GW3->GW3_DTEMFA := GW3->GW3_DTEMIS
		MSUnlock("GW3")

		dbSelectArea("GW6")
		GW6->( dbSetOrder(1) )
		If GW6->( dbSeek(xFilial("GW6") + GW3->GW3_EMISDF + GW3->GW3_SERDF + GW3->GW3_NRDF + DToS(GW3->GW3_DTEMFA)) )


			If Posicione("GVT", 1, xFilial("GVT") + GW3->GW3_CDESP, "GVT_TPIMP") == "1"
				RecLock("GW6", .F. )
				GW6->GW6_VLICMS := GFETratDec((GW3->GW3_VLIMP),0, .T. )
				GW6->GW6_VLICRE := GW3->GW3_IMPRET
				MsUnLock("GW6")
			Else
				RecLock("GW6", .F. )
				GW6->GW6_VLISS := GFETratDec((GW3->GW3_VLIMP),0, .T. )
				GW6->GW6_VLISRE := GW3->GW3_IMPRET
				MsUnLock("GW6")
			EndIf




			If lExistCamp
				cQuery := " SELECT DISTINCT GWJ.R_E_C_N_O_ RECNOGWJ"
				cQuery += "   FROM "+RetSqlName("GWF")+" GWF"
				cQuery += "  INNER JOIN "+RetSqlName("GWJ")+" GWJ"
				cQuery += "     ON GWJ.GWJ_FILIAL = GWF.GWF_FILIAL"
				cQuery += "    AND GWJ.GWJ_NRPF   = GWF.GWF_NRPREF"
				cQuery += "    AND GWJ.GWJ_SIT    = '3'"
				cQuery += "    AND GWJ.GWJ_SITFIN = '4'"
				cQuery += "    AND GWJ.GWJ_CDTRP  = '"+GW6->GW6_EMIFAT+"'"
				cQuery += "    AND GWJ.GWJ_FILFAT = '"+Space(TamSx3("GWJ_FILFAT")[1])+"'"
				cQuery += "    AND GWJ.GWJ_EMIFAT = '"+Space(TamSx3("GWJ_EMIFAT")[1])+"'"
				cQuery += "    AND GWJ.GWJ_SERFAT = '"+Space(TamSx3("GWJ_SERFAT")[1])+"'"
				cQuery += "    AND GWJ.GWJ_NRFAT  = '"+Space(TamSx3("GWJ_NRFAT")[1])+"'"
				cQuery += "    AND GWJ.GWJ_DTEMFA = '"+Space(TamSx3("GWJ_DTEMFA")[1])+"'"
				cQuery += "    AND GWJ.D_E_L_E_T_ = ' '"
				cQuery += "  WHERE GWF.GWF_FILIAL = '"+GW3->GW3_FILIAL+"'"
				cQuery += "    AND GWF.GWF_CDESP  = '"+GW3->GW3_CDESP+"'"
				cQuery += "    AND GWF.GWF_EMISDF = '"+GW3->GW3_EMISDF+"'"
				cQuery += "    AND GWF.GWF_SERDF  = '"+GW3->GW3_SERDF+"'"
				cQuery += "    AND GWF.GWF_NRDF   = '"+GW3->GW3_NRDF+"'"
				cQuery += "    AND GWF.GWF_DTEMDF = '"+DToS(GW3->GW3_DTEMIS)+"'"
				cQuery += "    AND GWF.D_E_L_E_T_ = ' '"
				cQuery := ChangeQuery(cQuery)
				cAliasQry := GetNextAlias()
				DbUseArea( .T. ,"TOPCONN",TcGenQry(,,cQuery),cAliasQry, .F. , .T. )

				While (cAliasQry)->(!EoF())
					GWJ->(dbGoTo((cAliasQry)->RECNOGWJ))
					RecLock("GWJ", .F. )
					GWJ->GWJ_FILFAT := xFilial("GW6")
					GWJ->GWJ_EMIFAT := GW3->GW3_EMISDF
					GWJ->GWJ_SERFAT := GW3->GW3_SERDF
					GWJ->GWJ_NRFAT  := GW3->GW3_NRDF
					GWJ->GWJ_DTEMFA := GW3->GW3_DTEMIS
					MsUnLock("GWJ")
					(cAliasQry)->(dbSkip())
				EndDo
			Else
				dbSelectArea("GW4")
				GW4->( dbSetOrder(1) )
				GW4->( dbSeek(xFilial("GW4") + GW3->GW3_EMISDF + GW3->GW3_CDESP + GW3->GW3_SERDF + GW3->GW3_NRDF + DToS(GW3->GW3_DTEMIS)) )


				While !GW4->( Eof() ) .And.  GW4->GW4_FILIAL == xFilial("GW4") .And.  GW4->GW4_CDESP == GW3->GW3_CDESP .And.  GW4->GW4_EMISDF == GW3->GW3_EMISDF .And.  GW4->GW4_SERDF == GW3->GW3_SERDF .And.  GW4->GW4_NRDF == GW3->GW3_NRDF .And.  DtoS(GW4->GW4_DTEMIS) == DToS(GW3->GW3_DTEMIS)

					dbSelectArea("GWH")
					GWH->( dbSetOrder(2) )
					GWH->( dbSeek(xFilial("GWH") + GW4->GW4_TPDC + GW4->GW4_EMISDC + GW4->GW4_SERDC + GW4->GW4_NRDC) )

					While !GWH->( Eof() ) .And.  GWH->GWH_FILIAL == xFilial("GWH") .And.  GWH->GWH_CDTPDC == GW4->GW4_TPDC .And.  GWH->GWH_EMISDC == GW4->GW4_EMISDC .And.  GWH->GWH_SERDC == GW4->GW4_SERDC .And.  GWH->GWH_NRDC == GW4->GW4_NRDC

						dbSelectArea("GWF")
						GWF->( dbSetOrder(1) )
						If GWF->( dbSeek(xFilial("GWF") + GWH->GWH_NRCALC) ) .And.  GWF->GWF_TPCALC == GW3->GW3_TPDF .And.  (!GFXCP12117("GW3_CDTPSE") .OR.  GW3->GW3_CDTPSE == GWF->GWF_CDTPSE)

							dbSelectArea("GWJ")
							GWJ->( dbSetOrder(1) )





							If GWJ->( dbSeek(GWF->GWF_FILPRE + GWF->GWF_NRPREF) ) .And.  ((s_GFEPF1 == "1" .AND.  GWJ->GWJ_SIT == "3") .OR.  (s_GFEPF1 == "2" .AND.  (GWJ->GWJ_SIT == "2" .OR.  GWJ->GWJ_SIT == "3") )) .AND.  (GWJ->GWJ_CDTRP  == GW6->GW6_EMIFAT) .And.  Empty(GWJ->GWJ_FILFAT + GWJ->GWJ_EMIFAT + GWJ->GWJ_SERFAT + GWJ->GWJ_NRFAT + DToS(GWJ->GWJ_DTEMFA)) .And.  GWJ->GWJ_SITFIN == "4"

								RecLock("GWJ", .F. )
								GWJ->GWJ_FILFAT := xFilial("GW6")
								GWJ->GWJ_EMIFAT := GW3->GW3_EMISDF
								GWJ->GWJ_SERFAT := GW3->GW3_SERDF
								GWJ->GWJ_NRFAT  := GW3->GW3_NRDF
								GWJ->GWJ_DTEMFA := GW3->GW3_DTEMIS
								MsUnLock("GWJ")

								Exit

							EndIf

						EndIf

						dbSelectArea("GWH")
						GWH->( dbSkip() )
					EndDo

					dbSelectArea("GW4")
					GW4->( dbSkip() )
				EndDo
			EndIf

			If lInterface
				Iif(FindFunction("APMsgInfo"), APMsgInfo("Fatura gerada com sucesso.",), MsgInfo("Fatura gerada com sucesso.",))
			EndIf

			GFEA070CO()

		EndIf

	EndIf

	RestArea(aAreaGW3)

Return












User Function GFE065CFOP()
	Local cCidRem
	Local cCidDes
	Local cCFOP
	Local cCFOPAtu := M->GW3_CFOP
	Local cCFOFR1 := SuperGetMV("MV_CFOFR1", .T. ,"")
	Local cCFOFR2 := SuperGetMV("MV_CFOFR2", .T. ,"")

	If Empty(M->GW3_CDREM) .OR.  Empty(M->GW3_CDDEST)
		Return cCFOPAtu
	EndIf

	cCidRem := Posicione("GU3",1,XFILIAL("GU3")+M->GW3_CDREM,"GU3_NRCID")
	cCidDes := Posicione("GU3",1,XFILIAL("GU3")+M->GW3_CDDEST,"GU3_NRCID")

	If Posicione("GU7",1, xfilial("GU7")+cCidRem, "GU7_CDUF") == Posicione("GU7",1, xfilial("GU7")+cCidDes, "GU7_CDUF")
		cCFOP := cCFOFR1
	Else
		cCFOP := cCFOFR2
	EndIf

	If !Empty(M->GW3_CFOP) .And.  M->GW3_CFOP <> cCFOFR1 .And.  M->GW3_CFOP <> cCFOFR2
		Return cCFOPAtu
	EndIf

Return cCFOP









User Function UGFE5BAS()

	Local nBaseImp := M->GW3_VLDF

	If nBaseImp <> 0 .And.  M->GW3_PEDAG <> 0 .And.  Posicione("GVT", 1, xFilial("GVT") + M->GW3_CDESP, "GVT_TPIMP") <> "2"

		If M->GW3_PDGFRT == "1" .And.  M->GW3_ICMPDG == "2"

			nBaseImp -= FwFldGet("GW3_PEDAG")

		ElseIf FwFldGet("GW3_PDGFRT") == "2" .And.  FwFldGet("GW3_ICMPDG") == "1"

			nBaseImp += FwFldGet("GW3_PEDAG")
		EndIf
	EndIf

Return nBaseImp














User Function GFE065VCTE(cChvCte,cEmissor,cSerie,cNumero,dDataEmis)

	Local cUF     :=   Substr(cChvCte,1,2)
	Local cAAMM   :=   Substr(cChvCte,3,4)
	Local cCNPJ 	:=  Substr(cChvCte,7,14)
	Local cMod 	:=  Substr(cChvCte,21,2)
	Local cSerieChave  :=  Substr(cChvCte,23,3)
	Local cNct 	:=  Substr(cChvCte,26,9)
	Local cTpEmis :=  Substr(cChvCte,35,1)
	Local cCdEsp  := FwFldGet("GW3_CDESP" )
	Local cNrCid
	Local cUfBrw
	Local cAAMMBrw
	Local cCNPJBrw
	Local cTpEmisStr
	Local aRet := Array(2)
	Local cAliasTmp := ""
	Local cQuery := ""
	aRet[1] := .F.
	aRet[2] := ""


	dbSelectArea("GVT")
	dbSetOrder(1)
	If dbSeek(xFilial("GVT")+cCdEsp)
		If GVT->(FieldPos("GVT_CHVCTE")) > 0 .And.  GVT->GVT_CHVCTE == "3"
			aRet[1] := .T.
			Return(aRet)
		EndIf
		If GVT->GVT_TPIMP == "1"
			If Len(cChvCte) <> 44
				aRet[2] := "Nï¿½mero de caracteres informado no campo Chave Ct-e invï¿½lido."
				Return (aRet)
			EndIf

			cNrCid := Posicione("GU3",1,xFilial("GU3")+cEmissor,"GU3_NRCID")
			cUfBrw := Posicione("GU7",1,xFilial("GU7")+cNrCid,"GU7_CDUF")

			cAAMMBrw := Substr(strtran(DtoS(dDataEmis),"/"),3,2) + Substr(strtran(DtoS(dDataEmis),"/"),5,2)

			cCNPJBrw := AllTrim(Posicione("GU3",1,xFilial("GU3")+cEmissor,"GU3_IDFED"))


			If (u_GFE065RUF(cUF, 2) == "0") .Or.  (u_GFE065RUF(cUF, 2) <> "0" .And.  u_GFE065RUF(cUF, 2) <> cUfBrw)
				aRet[2] := "UF da chave difere da chave do documento de frete."
				Return (aRet)
			EndIf


			If cAAMM <> cAAMMBrw
				aRet[2] := "Ano e mï¿½s da chave difere do documento de frete."
				Return (aRet)
			EndIf


			If cCNPJ <> cCNPJBrw
				aRet[2] := "CNPJ da chave difere do documento de frete."
				Return (aRet)
			EndIf

			If cMod <> "57"
				aRet[2] := "Modalidade de transporte invï¿½lido."
				Return (aRet)
			EndIf


			If (Empty(cSerie) .And.  cSerieChave <> "000") .Or.  ( !Empty(cSerie) .And.  PADL(AllTrim(cSerie), 3, "0") <> cSerieChave)
				aRet[2] := "Sï¿½rie da chave difere do documento de frete."
				Return (aRet)
			EndIf



			If Val(cNct) <> Val(cNumero)
				aRet[2] := "Nï¿½mero do conhecimento da chave difere do documento de frete."
				Return (aRet)
			EndIf


			If !cTpEmis $ "1;4;5;7;8"
				cTpEmisStr := "Cï¿½digo invï¿½lido."

				aRet[2] := "Tipo emissï¿½o invï¿½lida. [" + cTpEmis + "] " + cTpEmisStr

				Return (aRet)
			EndIf

			If !u_GFE065VLDV(cChvCte)
				aRet[2] := "Digito verificador invï¿½lido."
				Return (aRet)
			EndIf

			cAliasTmp := GetNextAlias()

			cQuery := "SELECT GW3_NRDF FROM "+ RetSqlName("GW3")+" GW3 "
			cQuery += "WHERE GW3_CTE = '" + cChvCte + "'"
			cQuery += " AND (GW3_FILIAL <> '" + xFilial("GW3") + "'"
			cQuery += " OR GW3_CDESP <> '" + cCdEsp + "'"
			cQuery += " OR GW3_EMISDF <> '" + cEmissor + "'"
			cQuery += " OR GW3_SERDF <> '" + cSerie + "'"
			cQuery += " OR GW3_NRDF <> '" + cNumero + "'"
			cQuery += " OR GW3_DTEMIS <> '" + Dtos(dDataEmis) + "'"
			cQuery += " )"
			cQuery += " AND GW3.D_E_L_E_T_ = ' ' "

			dbUseArea( .T. ,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp, .T. , .T. )

			If (cAliasTmp)->(!Eof())
				aRet[2] := "Jï¿½ existe uma chave ct-e igual cadastrada."
				(cAliasTmp)->(dbCloseArea())
				Return (aRet)
			EndIf
			(cAliasTmp)->(dbCloseArea())
			aRet[1] := .T.
		EndIf
	EndIf

Return (aRet)
















User Function GFE065RUF(cUF,nTipo)



























	Local aUf := {{"RO","11"}, {"AC","12"}, {"AM","13"}, {"RR","14"}, {"PA","15"}, {"AP","16"}, {"TO","17"}, {"MA","21"}, {"PI","22"}, {"CE","23"}, {"RN","24"}, {"PB","25"}, {"PE","26"}, {"AL","27"}, {"SE","28"}, {"BA","29"}, {"MG","31"}, {"ES","32"}, {"RJ","33"}, {"SP","35"}, {"PR","41"}, {"SC","42"}, {"RS","43"}, {"MS","50"}, {"MT","51"}, {"GO","52"}, {"DF","53"}}

	Local bSeek
	Local cUfArray
	Local cPosArray

	bSeek := {|cUfArray|,cUfArray[nTipo] == cUF}

	cPosArray := aScan(aUf,bSeek)

	If cPosArray <> 0
		If nTipo == 1
			Return aUf[cPosArray][2]
		Else
			Return aUf[cPosArray][1]
		EndIf
	EndIf

Return "0"












User Function GFE065VLDV(cChvAcesso)
	Local cDigChave := Substr(cChvAcesso,44,1)
	Local cDigCalc	:= u_UFEADVC(cChvAcesso)

Return cDigChave == cDigCalc












User Function UFEADVC(cChvAcesso)

	Local cDigCalc
	Local aChvAcesso := {}
	Local nResto := 0
	Local nSomaChvAc := 0
	Local nI
	Local nCont := 2

	For	nI := 1 To 43
		AADD(aChvAcesso,AllTrim(substr(cChvAcesso,nI,1)))
	next

	For	nI := 43 To 1 STEP -1
		nSomaChvAc := nSomaChvAc + Val(aChvAcesso[nI]) * nCont
		If nCont == 9
			nCont := 2
		Else
			nCont++
		EndIf
	next

	nResto := nSomaChvAc % 11

	If nResto == 0 .OR.  nResto == 1
		cDigCalc := "0"
	Else
		cDigCalc  := ALLTRIM(STR(11 - (nResto)))
	EndIf

Return cDigCalc









User Function IsNumeric(cSerire)

	Local nPos
	Local nLen


	cSerire	:=	AllTrim( cSerire )
	nLen		:=	Len( cSerire )

	For nPos := 1 to nLen
		If !IsDigit( Substr( cSerire, nPos, 1 ) )
			Return .F.
		EndIf
	Next

Return .T.











User Function GFE065PCTE()
	Local cNrCid
	Local cUf
	Local cCdUf
	Local cAAMM
	Local cCNPJ
	Local cCteParte
	Local cCdEsp	:= FwFldGet("GW3_CDESP" )
	Local lCmpCte	:= .F.

	Local cSerie	:= FwFldGet("GW3_SERDF")
	Local cEmissor	:= FwFldGet("GW3_EMISDF")



	DbSelectArea("GVT")
	dbSetOrder(1)
	lCmpCte := GVT->(FieldPos("GVT_CHVCTE")) > 0
	If dbSeek(xFilial("GVT")+cCdEsp)
		If GU3->(DbSeek(xFilial("GU3")+cEmissor))
			If (GU3->GU3_CTE == "1") .And.  !(u_IsNumeric(cSerie)) .And.  (GVT->GVT_TPIMP <> "2")
				If !lCmpCte .Or.  (lCmpCte .And.  GVT->GVT_CHVCTE <> "3")
					Iif(FindFunction("APMsgInfo"), APMsgInfo("Transportador cadastrado para gerar chave ct-e, sï¿½rie do documento tem que ser nï¿½merica.",), MsgInfo("Transportador cadastrado para gerar chave ct-e, sï¿½rie do documento tem que ser nï¿½merica.",))
					Return .F.
				EndIf
			EndIf
		EndIf
		If GVT->GVT_TPIMP == "1"
			If  lCmpCte .And.  GVT->GVT_CHVCTE == "3"
				Return cCteParte
			EndIf

			If Empty(M->GW3_EMISDF) .Or.  Empty(M->GW3_DTEMIS) .Or.  Empty(M->GW3_NRDF) .Or.  !Empty(M->GW3_CTE) .Or.  Posicione("GU3", 1, xFilial("GU3")+ M->GW3_EMISDF, "GU3_CTE") == "2"
				Return M->GW3_CTE
			EndIf

			cNrCid := Posicione("GU3" ,1, xFilial("GU3")+ M->GW3_EMISDF,"GU3_NRCID")
			cUf    := Posicione("GU7",1,xFilial("GU7")+cNrCid,"GU7_CDUF")
			cCdUf := u_GFE065RUF(cUF, 1)


			cAAMM := Substr(strtran(DtoS(M->GW3_DTEMIS),"/"),3,2)  + Substr(strtran(DtoS(M->GW3_DTEMIS),"/"),5,2)
			cCNPJ  := Padr(Posicione("GU3",1,xFilial("GU3")+M->GW3_EMISDF,"GU3_IDFED"),14)
			cMod := "57"
			cSerie := PadL(AllTrim(Substr(M->GW3_SERDF,1,3)),3,"0")
			cNct := PadL(AllTrim(Substr(M->GW3_NRDF,1,9)),9,"0")
			cTpEmis := "1"

			cCteParte := Padr(cCdUf+cAAMM+cCNPJ+cMod+cSerie+cNct+cTpEmis,TamSx3("GW3_CTE")[1])

		Else
			cCteParte := " "
		EndIf
	EndIf

Return cCteParte


User Function GFE065CAMP()
	dbSelectArea("GVT")
	dbSetOrder(1)
	If dbSeek(xFilial("GVT")+ M->GW3_CDESP)

		If (GVT->(FieldPos("GVT_CHVCTE")) > 0 .And.  GVT->GVT_CHVCTE == "3") .or.  ( Posicione("GU3", 1, xFilial("GU3")+M->GW3_EMISDF, "GU3_CTE")) == "2"
			Return .F.
		EndIf
		If M->GW3_ORIGEM == "2"

			If (GVT->GVT_TPIMP <> "1")
				Return .F.
			EndIf
		EndIf
	EndIf
Return .T.








User Function GFE65IPG(nInt,cSituacao,oModel,aRet)

	Local cMsg     := ""
	Local lIntGFE  := SuperGetMv("MV_INTGFE" , .F. , .F. )
	Local cIntGFE2 := SuperGetMv("MV_INTGFE2", .F. ,"2")
	Local cERPGFE  := SuperGetMv("MV_ERPGFE" , .F. ,"2")

	If lIntGFE == .T.  .And.  cIntGFE2 $ "1S" .And.  cERPGFE == "2"
		Do Case

			Case cSituacao == "2"
			If !AtuDocFret(nInt,oModel,@cMsg)
				aRet := { .F. ,"2",cMsg}
			Else
				aRet := { .T. ,"2",""}
			EndIf

			Case cSituacao == "5"
			If !DesAtuDocFret(nInt,oModel,@cMsg)
				aRet := { .F. ,"5",cMsg}
			Else
				aRet := { .T. ,"5",""}
			EndIf

			Otherwise

			Return

		EndCase

	EndIf

Return













Static Function AtuDocFret(nInt, oModel, cMsg, nOpc)
	Local aDocFrete	:= {}
	Local aItensDoc 	:= {}
	Local aNotasFis 	:= {}
	Local lErro 		:= .F.
	Local aForLoj 	:= GFEA055GFL(GW3->GW3_EMISDF)
	Local aCliLoj 	:= GFEA055GFL(GW3->GW3_CDDEST)
	Local cF1_DOC 	:= GW3->GW3_NRDF
	Local cOper 		:= ""
	Local cTes 		:= ""
	Local aErro 		:= {}
	Local nX 			:= 0
	Local cCpdGFE		:= ""
	Local cSigfe		:= SuperGetMv("MV_SIGFE",,"2")
	Local cFilAtu
	Local aCustFis 	:= {}
	Local aCustRec 	:= {}
	Local cTpCte 		:= ""
	Local cOpcInteg 	:= ""
	Local aCidades	    := {}
	Local aCidadesUF    := {}
	Local lCpoTES 	:= u_GFE65INP()
	cMsg := If( cMsg == nil, "", cMsg ) ;

	Private lMsHelpAuto 		:= .T.
	Private lAutoErrNoFile 	:= .T.
	Private lMsErroAuto 		:= .F.
	Private aHeader 			:= {}
	Private cOperPE 			:= ""
	Private ctpNfMat	   := ""


	If Empty(aForLoj[1])
		cMsg := "Fornecedor nï¿½o cadastrado no Protheus."
		lErro := .T.
	EndIf

	cOpcInteg := oModel:getValue("UGFEA065_GW3","GW3_ACINT")

	If !lErro
		If Empty(aForLoj[2])
			aForLoj[2] := "01"
		EndIf

		cF1_DOC := SubStr(cF1_DOC,1,TamSx3("F1_DOC")[1])







		aCidades   := (GFEWSCITY( GW3->GW3_FILIAL, GW3->GW3_EMISDF, GW3->GW3_CDESP, GW3->GW3_SERDF, GW3->GW3_NRDF, DTOS(GW3->GW3_DTEMIS)))
		aAdd(aCidadesUF,{Substr(aCidades[1][1], 3,7), Posicione("GU7", 1, xFilial("GU7") + aCidades[1][1], "GU7_CDUF"), Substr(aCidades[1][2], 3,7), Posicione("GU7", 1, xFilial("GU7") + aCidades[1][2], "GU7_CDUF") })


		If nInt == "2" .And.  (Empty(cOpcInteg) .Or.  cOpcInteg $ "2;4")


			u_GetNotasFis(@aNotasFis,oModel,aForLoj,cF1_DOC)


			u_ParamMt116 ( 2,@aDocFrete,aForLoj,cF1_DOC,aCidadesUF )


			If !Empty(aNotasFis)


				If  ExistBlock("GFEA0654")
					aCustRec := ExecBlock("GFEA0654", .F. , .F. , {aDocFrete, aNotasFis, cOperPE})
					aDocFrete := aCustRec[1][1]
					aNotasFis := aCustRec[1][2]
				EndIf
				If cOpcInteg <> "4"
					MSExecAuto( { |x,y| MATA116(x,y) }, aDocFrete, aNotasFis )
				Else
					MSExecAuto( { |x,y| MATA116(x,y,, .T. ) }, aDocFrete, aNotasFis )
				EndIf
			Else
				lErro := .T.
				cMsg := "Notas Fiscais nï¿½o selecionadas."
			EndIf
		Else

			Aadd(aDocFrete, {"F1_DOC"     , cF1_DOC                     , Nil } )
			Aadd(aDocFrete, {"F1_SERIE"   , GW3->GW3_SERDF              , Nil } )
			Aadd(aDocFrete, {"F1_FORNECE" , aForLoj[1]                  , Nil } )
			Aadd(aDocFrete, {"F1_LOJA"    , aForLoj[2]                  , Nil } )
			Aadd(aDocFrete, {"F1_EMISSAO" , GW3->GW3_DTEMIS             , Nil } )


			If  ExistBlock("GFEA0653")
				cCpdGFE :=  ExecBlock("GFEA0653", .F. , .F. ,{3})
			EndIf

			If Empty(cCpdGFE)
				If lCpoTES
					cCpdGFE := GW3->GW3_CPDGFE
				else
					cCpdGFE := SuperGetMv("MV_CPDGFE",,"1")
				EndIf
			EndIf


			Aadd(aDocFrete, {"F1_COND"    , cCpdGFE                     , Nil } )

			Aadd(aDocFrete, {"F1_RECBMTO" , GW3->GW3_DTFIS              , Nil } )
			Aadd(aDocFrete, {"F1_CHVNFE"  , GW3->GW3_CTE                , Nil } )

			if cOpcInteg == "4"
				Aadd(aDocFrete, {"F1_TIPO" , "C"                     , Nil } )
			Else
				Aadd(aDocFrete, {"F1_TIPO" , "N"                           , Nil } )
			EndIf
			Aadd(aDocFrete, {"F1_FORMUL"  , "N"                         , Nil } )
			Aadd(aDocFrete, {"F1_ESPECIE" , GW3->GW3_CDESP              , Nil } )
			Aadd(aDocFrete, {"F1_ORIGEM"  , "UGFEA065"                   , Nil } )
			Aadd(aDocFrete, {"F1_VALPEDG" , GW3->GW3_PEDAG              , Nil } )

			If !(cOpcInteg $ "3") .And.  !Empty(GW3->GW3_CTE)
				If GW3->GW3_TPCTE == "0"
					cTpCte = "N"
				ElseIF GW3->GW3_TPCTE == "1"
					cTpCte = "C"
				ElseIF GW3->GW3_TPCTE == "2"
					cTpCte = "A"
				ElseIF GW3->GW3_TPCTE == "3"
					cTpCte = "S"
				EndIf
				aAdd(aDocFrete,{"F1_TPCTE" ,cTpCte ,nil})
			EndIf

			AAdd(aDocFrete, {"F1_TPFRETE" , "C"							 , Nil } )

			AAdd(aDocFrete, {"F1_CLIDEST" , PADR(aCliLoj[1], TamSX3("F1_CLIDEST") [1])				 , Nil } )
			AAdd(aDocFrete, {"F1_LOJDEST" , PADR(aCliLoj[2], TamSX3("F1_LOJDEST") [1])				 , Nil } )


			Aadd(aDocFrete, {"F1_EST"     , aCidadesUF[1][2]    , Nil } )
			Aadd(aDocFrete, {"F1_ESTDES"  , aCidadesUF[1][4]    , Nil } )
			Aadd(aDocFrete, {"F1_MUORITR" , aCidadesUF[1][1]    , Nil } )
			Aadd(aDocFrete, {"F1_UFORITR" , aCidadesUF[1][2]    , Nil } )
			Aadd(aDocFrete, {"F1_MUDESTR" , aCidadesUF[1][3]    , Nil } )
			Aadd(aDocFrete, {"F1_UFDESTR" , aCidadesUF[1][4]    , Nil } )

			u_GetItens(@aItensDoc,aForLoj,cF1_DOC,3, cOpcInteg)



			cFilAtu := cFilAnt
			cFilAnt := GW3->GW3_FILIAL


			If  ExistBlock("GFEA0655")
				aCustFis 	:= ExecBlock("GFEA0655", .F. , .F. ,{aDocFrete, aItensDoc, cOperPE})
				aDocFrete 	:= aCustFis[1][1]
				aItensDoc 	:= aCustFis[1][2]
			EndIf

			If cOpcInteg $ "3"

				MSExecAuto( { |x,y,z| MATA140(x,y,z) }, aDocFrete,aItensDoc,3 )
			Else

				MSExecAuto( { |x,y,z| MATA103(x,y,z) }, aDocFrete,aItensDoc,3 )
			EndIf
			cFilAnt := cFilAtu

		EndIf

		If lMsErroAuto
			aErro 	:= GetAutoGrLog()
			cMsg 	:= ""

			For nX := 1 To Len(aErro)
				cMsg += aErro[nX] + Chr(13)+Chr(10)
			next

			lErro := .T.

		EndIf

	EndIf

	If nInt == "1"
		cTipInt := "Fiscal"
	Else
		cTipInt := "Recebimento"
	EndIf

	If IsInCallStack("U_UGFEA065")
		If lErro
			Iif(FindFunction("APMsgInfo"), APMsgInfo("Documento de Frete nï¿½o enviada para atualizaï¿½ï¿½o. Verificar motivo no campo 'Mot Rej "+SubStr(cTipInt,1,3)+"'.",), MsgInfo("Documento de Frete nï¿½o enviada para atualizaï¿½ï¿½o. Verificar motivo no campo 'Mot Rej "+SubStr(cTipInt,1,3)+"'.",))
		Else
			Iif(FindFunction("APMsgInfo"), APMsgInfo("Documento de Frete atualizado no "+cTipInt+".",), MsgInfo("Documento de Frete atualizado no "+cTipInt+".",))
		EndIf
	EndIf

Return !lErro














Static Function DesAtuDocFret(nInt, oModel, cMsg)
	Local aDocFrete	:= {}
	Local aItensDoc 	:= {}
	Local aNotasFis 	:= {}
	Local lErro     	:= .F.
	Local lErroDc   	:= .F.
	Local aForLoj   	:= GFEA055GFL(GW3->GW3_EMISDF)
	Local cF1_DOC   	:= SubStr(GW3->GW3_NRDF,1,TamSx3("F1_DOC")[1])
	Local cTipInt   	:= ""
	Local aErro 		:= {}
	Local nX 			:= 0
	Local cCpdGFE 	:= ""
	Local cOpcInteg 	:= ""
	Local lCpoTES 	:= U_GFE65INP()
	Local aAreaSF1
	Local cTipo 		:= ""
	Local aCidadesUF    := {}
	cMsg := If( cMsg == nil, "", cMsg ) ;

	Private lMsHelpAuto 		:= .T.
	Private lAutoErrNoFile 	:= .T.
	Private lMsErroAuto    	:= .F.
	Private aHeader        	:= {}
	Private ctpNfMat	   := ""

	If Empty(aForLoj[1])
		cMsg := "Fornecedor nï¿½o cadastrado no Protheus."
		lErro := .T.
	EndIf

	If !lErro

		If Empty(aForLoj[2])
			aForLoj[2] := "01"
		EndIf

		aAreaSF1 := SF1->(GetArea())
		dbSelectArea("SF1")
		SF1->(dbSetOrder(1))
		If SF1->(dbSeek(xFilial("SF1") + cF1_DOC + PadR(GW3->GW3_SERDF, TamSX3("F1_SERIE")[1]) + aForLoj[1] + aForLoj[2]))
			If GW3->(FieldPos("GW3_ACINT")) > 0 .And.  !Empty(GW3->GW3_ACINT)
				cOpcInteg := GW3->GW3_ACINT
				If cOpcInteg $ "3"
					If !Empty(SF1->F1_STATUS)
						cOpcInteg := "1"
						cTipo := SF1->F1_TIPO
					EndIf
				EndIf
			EndIf
		Else

			lErro 		:= .T.
			lErroDc 	:= .T.
			cMsg 		:= "O documento de Frete nï¿½o foi localizado no ERP para desatualizaï¿½ï¿½o."
		EndIf
		RestArea(aAreaSF1)
		aSize(aAreaSF1,0)
	EndIf

	If !lErro





		aCidades   := (GFEWSCITY( GW3->GW3_FILIAL, GW3->GW3_EMISDF, GW3->GW3_CDESP, GW3->GW3_SERDF, GW3->GW3_NRDF, DTOS(GW3->GW3_DTEMIS)))
		aAdd(aCidadesUF,{Substr(aCidades[1][1], 3,7), Posicione("GU7", 1, xFilial("GU7") + aCidades[1][1], "GU7_CDUF"), Substr(aCidades[1][2], 3,7), Posicione("GU7", 1, xFilial("GU7") + aCidades[1][2], "GU7_CDUF") })



		If nInt == "2" .And.  (Empty(cOpcInteg) .Or.  cOpcInteg $ "2;4")


			U_GetNotasFis(@aNotasFis,oModel,aForLoj,cF1_DOC)


			u_ParamMt116 ( 1,@aDocFrete,aForLoj,cF1_DOC,aCidadesUF )


			If !Empty(aNotasFis)
				If cOpcInteg <> "4"
					MSExecAuto( { |x,y| MATA116(x,y) }, aDocFrete,aNotasFis )
				Else
					MSExecAuto( { |x,y| MATA116(x,y,, .T. ) }, aDocFrete,aNotasFis )
				EndIf
			Else
				lErro := .T.
				cMsg := "Notas Fiscais nï¿½o selecionadas."
			EndIf
		Else

			Aadd(aDocFrete, {"F1_DOC"     , cF1_DOC                  , Nil } )
			Aadd(aDocFrete, {"F1_SERIE"  , PadR(GW3->GW3_SERDF, TamSX3("F1_SERIE")[1]), Nil } )
			Aadd(aDocFrete, {"F1_FORNECE" , aForLoj[1]               , Nil } )
			Aadd(aDocFrete, {"F1_LOJA"    , aForLoj[2]               , Nil } )
			Aadd(aDocFrete, {"F1_EMISSAO" , GW3->GW3_DTEMIS          , Nil } )


			If  ExistBlock("GFEA0653")
				cCpdGFE :=  ExecBlock("GFEA0653", .F. , .F. ,{5})
			EndIf

			If Empty(cCpdGFE)
				If lCpoTES
					cCpdGFE := GW3->GW3_CPDGFE
				else
					cCpdGFE := SuperGetMv("MV_CPDGFE",,"1")
				EndIf
			EndIf



			Aadd(aDocFrete, {"F1_COND"    , cCpdGFE                  , Nil } )
			Aadd(aDocFrete, {"F1_EST"     , Posicione("GU7",1,XFILIAL("GU7")+Posicione("GU3",1,xFilial("GU3")+GW3->GW3_CDREM,"GU3_NRCID") ,"GU7_CDUF") } )
			Aadd(aDocFrete, {"F1_RECBMTO" , GW3->GW3_DTFIS           , Nil } )
			Aadd(aDocFrete, {"F1_CHVNFE"  , GW3->GW3_CTE             , Nil } )
			If !Empty(cTipo)
				Aadd(aDocFrete, {"F1_TIPO"    , cTipo           , Nil } )
			Else
				Aadd(aDocFrete, {"F1_TIPO"    , "N"                      , Nil } )
			EndIf
			Aadd(aDocFrete, {"F1_FORMUL"  , "N"                      , Nil } )
			Aadd(aDocFrete, {"F1_ESPECIE" , GW3->GW3_CDESP           , Nil } )
			Aadd(aDocFrete, {"F1_ORIGEM"  , "UGFEA065"                , Nil } )
			AAdd(aDocFrete, {"F1_TPFRETE" , "C"						           , Nil } )


			u_GetItens(@aItensDoc,aForLoj,cF1_DOC,5, cOpcInteg)

			If cOpcInteg $ "3"

				MSExecAuto( { |x,y,z| MATA140(x,y,z) }, aDocFrete,aItensDoc,5 )
			Else

				MSExecAuto( { |x,y,z| MATA103(x,y,z) }, aDocFrete,aItensDoc,5 )
			EndIf

		EndIf

		If lMsErroAuto
			aErro := GetAutoGrLog()
			cMsg := ""

			For nX := 1 To Len(aErro)
				cMsg += aErro[nX] + Chr(13)+Chr(10)
			next

			lErro := .T.

		EndIf

	EndIf

	If nInt == "1"
		cTipInt := "Fiscal"
	Else
		cTipInt := "Recebimento"
	EndIf

	If IsInCallStack("U_UGFEA065")
		If lErro
			If lErroDc
				Iif(FindFunction("APMsgInfo"), APMsgInfo(cMsg,), MsgInfo(cMsg,))
			Else
				Iif(FindFunction("APMsgInfo"), APMsgInfo("Documento de Frete nï¿½o enviado para desatualizaï¿½ï¿½o. Verificar motivo no campo 'Mot Rej "+SubStr(cTipInt,1,3)+"'.",), MsgInfo("Documento de Frete nï¿½o enviado para desatualizaï¿½ï¿½o. Verificar motivo no campo 'Mot Rej "+SubStr(cTipInt,1,3)+"'.",))
			EndIf
		Else
			Iif(FindFunction("APMsgInfo"), APMsgInfo("Documento de Frete desatualizado no "+cTipInt+".",), MsgInfo("Documento de Frete desatualizado no "+cTipInt+".",))
		EndIf
	EndIf

Return !lErro









User Function GetItens(aItensDoc,aForLoj,cF1_DOC,nOp,cOpcInt)
	Local aItemDoc := {}
	Local cTes     := ""
	Local cTesSis  := ""
	Local cCenCus  := GW3->GW3_CC
	Local cRetPE   := ""
	Local cTpImp   := Posicione("GVT", 1, xFilial("GVT") + GW3->GW3_CDESP, "GVT_TPIMP")
	Local cPrdFrete:= ""
	Local cD1_Quant:= 1
	Local lCpoTES  := u_GFE65INP()
	Local lEscPed  := .F.
	Local nVlDoc   := GW3->GW3_VLDF

	cOpcInt := If( cOpcInt == nil, "0", cOpcInt )


	If cOpcInt == "4"
		cD1_Quant := 0
	EndIf



	If s_ESCPED == "1" .And.  cTpImp == "1" .And.  GW3->GW3_PDGFRT == "1" .And.  GW3->GW3_ICMPDG == "2"
		lEscPed := .T.
		nVlDoc  := GW3->GW3_VLDF - GW3->GW3_PEDAG
	EndIf


	Aadd(aItemDoc, {"D1_DOC"    , cF1_DOC           , Nil} )
	Aadd(aItemDoc, {"D1_SERIE"  , GW3->GW3_SERDF    , Nil} )
	Aadd(aItemDoc, {"D1_FORNECE", aForLoj[1]        , Nil} )
	Aadd(aItemDoc, {"D1_LOJA"   , aForLoj[2]        , Nil} )
	Aadd(aItemDoc, {"D1_EMISSAO", GW3->GW3_DTEMIS   , Nil} )

	If ExistBlock("GFEA0651")
		cPrdFrete := ExecBlock("GFEA0651", .F. , .F. ,{nOp})
	EndIf

	If Empty(cPrdFrete)
		If lCpoTES .And.  !Empty(GW3->GW3_PRITDF)
			cPrdFrete := GW3->GW3_PRITDF
		Else
			cPrdFrete := SuperGetMv("MV_PRITDF", .F. ,"")
		EndIf
	EndIf


	Aadd(aItemDoc, {"D1_COD"    , cPrdFrete         , Nil} )
	Aadd(aItemDoc, {"D1_UM"     , "UN"              , Nil} )
	Aadd(aItemDoc, {"D1_QUANT"  , cD1_Quant		, Nil} )
	Aadd(aItemDoc, {"D1_VUNIT"  , nVlDoc        , Nil} )
	Aadd(aItemDoc, {"D1_TOTAL"  , nVlDoc        , Nil} )


	If ExistBlock( "UGFEA0658" )
		cRetPE := ExecBlock( "UGFEA0658", .F. , .F. ,{cCenCus} )
		If ValType(cRetPE) == "C"
			cCenCus := cRetPE
		EndIf
	EndIf


	If lCpoTES



		If GFE065VCPO("1", .T. ,, .F. )
			cTes := GW3->GW3_TES
			Aadd(aItemDoc, {"D1_CONTA"  , GW3->GW3_CONTA  , Nil})
			Aadd(aItemDoc, {"D1_ITEMCTA", GW3->GW3_ITEMCT, Nil})
			Aadd(aItemDoc, {"D1_CC"     , cCenCus         , Nil})
		EndIf
	EndIf

	If Empty(cTes) .and.  SuperGetMv("MV_TESGFE", .F. , "1") == "1"
		cTes := u_GFE065TES(cTes, cTpImp, GW3->GW3_TRBIMP, GW3->GW3_CRDICM, GW3->GW3_CRDPC, aForLoj)
	EndIf


	If ExistBlock( "GFEA0652" )
		cTesSis := cTes

		cTes := ExecBlock( "GFEA0652", .F. , .F. ,{nOp} )

		If Empty(cTes)
			cTes := cTesSis
		EndIf
	EndIf


	If cOpcInt $ "3"
		Aadd( aItemDoc,{ "D1_TESACLA", cTes, Nil })
	Else
		Aadd( aItemDoc,{ "D1_TES", cTes, Nil })
	EndIf

	If cTpImp == "1"
		Aadd(aItemDoc, {"D1_VALICM"  , GW3->GW3_VLIMP  , Nil } )
		Aadd(aItemDoc, {"D1_PICM"    , GW3->GW3_PCIMP  , Nil } )
		Aadd(aItemDoc, {"D1_BASEICM" , GW3->GW3_BASIMP , Nil } )
		Aadd(aItemDoc, {"D1_ICMSRET" , GW3->GW3_IMPRET , Nil } )
	EndIf

	If cTpImp == "2"
		Aadd(aItemDoc, {"D1_VALISS"  , GW3->GW3_VLIMP  , Nil } )
		Aadd(aItemDoc, {"D1_ALIQISS" , GW3->GW3_PCIMP  , Nil } )
		Aadd(aItemDoc, {"D1_BASEISS" , GW3->GW3_BASIMP , Nil } )
	EndIf

	Aadd(aItensDoc, aItemDoc)


	If lEscPed

		aItemDoc := {}
		cTes     := ""
		cTes     := u_GFE065TES(cTes, "3", GW3->GW3_TRBIMP, GW3->GW3_CRDICM, GW3->GW3_CRDPC, aForLoj)

		Aadd(aItemDoc, {"D1_ITEM"    , "0002"            , Nil} )
		Aadd(aItemDoc, {"D1_DOC"     , cF1_DOC           , Nil} )
		Aadd(aItemDoc, {"D1_SERIE"   , GW3->GW3_SERDF    , Nil} )
		Aadd(aItemDoc, {"D1_FORNECE" , aForLoj[1]        , Nil} )
		Aadd(aItemDoc, {"D1_LOJA"    , aForLoj[2]        , Nil} )
		Aadd(aItemDoc, {"D1_EMISSAO" , GW3->GW3_DTEMIS   , Nil} )
		Aadd(aItemDoc, {"D1_COD"     , cPrdFrete         , Nil} )
		Aadd(aItemDoc, {"D1_UM"      , "UN"              , Nil} )
		Aadd(aItemDoc, {"D1_QUANT"   , cD1_Quant	     , Nil} )
		Aadd(aItemDoc, {"D1_VUNIT"   , GW3->GW3_PEDAG    , Nil} )
		Aadd(aItemDoc, {"D1_TOTAL"   , GW3->GW3_PEDAG    , Nil} )
		Aadd(aItemDoc, {"D1_TES"     , cTes              , Nil })
		Aadd(aItemDoc, {"D1_VALICM"  , 0                 , Nil } )
		Aadd(aItemDoc, {"D1_PICM"    , 0                 , Nil } )
		Aadd(aItemDoc, {"D1_BASEICM" , 0                 , Nil } )
		Aadd(aItemDoc, {"D1_ICMSRET" , 0                 , Nil } )

		Aadd(aItensDoc, aItemDoc)
	EndIf
Return









User Function GetNotasFis(aNotasFis,oModel,aForLoj,cF1_DOC)



	Local aEmis
	Local cNrDc  := ""
	Local cSerDc := ""
	Local nX	  := 0

	If Empty(aForLoj[2])
		aForLoj[2] := "01"
	EndIf

	dbSelectArea("GW4")
	GW4->( dbSetOrder(1) )
	GW4->( dbSeek(xFilial("GW4") + GW3->GW3_EMISDF + GW3->GW3_CDESP + GW3->GW3_SERDF + GW3->GW3_NRDF + DToS(GW3->GW3_DTEMIS)) )


	While !GW4->( Eof() ) .And.  GW4->GW4_FILIAL == xFilial("GW4") .And.  GW4->GW4_EMISDF == GW3->GW3_EMISDF .And.  GW4->GW4_CDESP == GW3->GW3_CDESP .And.  GW4->GW4_SERDF == GW3->GW3_SERDF .And.  GW4->GW4_NRDF == GW3->GW3_NRDF .And.  DToS(GW4->GW4_DTEMIS) == DToS(GW3->GW3_DTEMIS)


		GW1->( dbSetOrder(1) )
		GW1->( dbSeek( GW4->GW4_FILIAL+GW4->GW4_TPDC+GW4->GW4_EMISDC+GW4->GW4_SERDC+GW4->GW4_NRDC ) )

		SF1->( dbSetOrder(8) )
		SF1->( dbSeek( xFilial("SF1")+GW1->GW1_DANFE ) )


		If !Empty( GW1->GW1_DANFE )

			If !SF1->( EOF() ) .And.  SF1->F1_FILIAL == xFilial("SF1") .And.  AllTrim(SF1->F1_CHVNFE) == AllTrim(GW1->GW1_DANFE)



				ctpNfMat := SF1->F1_TIPO

				Aadd(aNotasFis,{ {"PRIMARYKEY",SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+ctpNfMat,Nil} })
			EndIf
		Else

			aEmis  := xEncFor(Alltrim(GW4->GW4_EMISDC))
			cNrDc  := PadR(GW4->GW4_NRDC, TamSX3("F1_DOC")[1])
			cSerDc := PadR(GW4->GW4_SERDC, TamSX3("F1_SERIE")[1])

			dbSelectArea("SF1")
			SF1->( dbSetOrder(1) )

			for nX:= 1 to Len(aEmis)

				SF1->( dbSeek( xFilial("SF1")+cNrDc+cSerDc+aEmis[nX][1]+aEmis[nX][2] ) )





				If !SF1->( EOF() ) .And.  SF1->F1_FILIAL == xFilial("SF1") .And.  SF1->F1_EMISSAO == GW1->GW1_DTEMIS .And.  AllTrim(SF1->F1_DOC) == AllTrim(cNrDc) .And.  AllTrim(SF1->F1_SERIE) == AllTrim(cSerDc) .And.  AllTrim(SF1->F1_FORNECE) == AllTrim(aEmis[nX][1]) .And.  Alltrim(SF1->F1_LOJA) == AllTrim(aEmis[nX][2])



					ctpNfMat := SF1->F1_TIPO

					Aadd(aNotasFis,{ {"PRIMARYKEY",cNrDc+cSerDc+aEmis[nX][1]+aEmis[nX][2]+ctpNfMat,Nil} })
					Return

				EndIf
			next
		Endif

		GW4->( dbSkip() )

	EndDo

Return

Static Function xEncFor(cCgc)

	Local cCod     := ""
	Local cLoja    := ""
	Local nTamCod  := TamSX3("A2_COD" )[1]
	Local nTamLoja := TamSx3("A2_LOJA")[1]
	Local cTipoFor := Posicione("GU3", 1, xFilial("GU3") + cCgc, "GU3_NATUR")
	Local lNumProp := SuperGetMv("MV_EMITMP", .F. ,"0") == "1" .And.  SuperGetMv("MV_INTGFE2", .F. ,"2") == "1"
	Local aCliSF1	 := {}

	cAlias := GetNextAlias()
	cQuery := " SELECT SA2.A2_COD, SA2.A2_LOJA FROM "+RetSQLName("SA2")+" SA2 "
	cQuery += " WHERE "
	cQuery += " 	SA2.A2_CGC = '"+cCgc+"'       AND "
	cQuery += " 	SA2.A2_MSBLQL  <> '1'	AND "
	cQuery += "	SA2.D_E_L_E_T_ <> '*'"
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T. , "TOPCONN", TCGENQRY(,,cQuery),cAlias, .F. , .T. )

	While (cAlias)->(!Eof())

		cCod  := PadR((cAlias)->A2_COD , nTamCod )
		cLoja := PadR((cAlias)->A2_LOJA, nTamLoja)
		Aadd(aCliSF1,{cCod,cLoja})

		(cAlias)->(dbSkip())
	EndDo
	(cAlias)->(dbCloseArea())

Return aCliSF1









User Function ParamMt116(nOpc,aDocFrete,aForLoj,cF1_DOC,aCidadesUF)
	Local cTes    := ""
	Local cOper   := ""
	Local cTpImp  := Posicione("GVT", 1, xFilial("GVT") + GW3->GW3_CDESP, "GVT_TPIMP")
	Local cTpCte  := ""
	Local lCpoTES := u_GFE65INP()
	Local cCidOri := Posicione("GU7",1,XFILIAL("GU7")+Posicione("GU3",1,xFilial("GU3")+GW3->GW3_CDREM,"GU3_NRCID") ,"GU7_CDUF")
	Local cOpcInteg := ""

	aAdd(aDocFrete,{"MV_PAR11", dDataBase-99999               , Nil})
	aAdd(aDocFrete,{"MV_PAR12", dDataBase                     , Nil})
	aAdd(aDocFrete,{"MV_PAR13", nOpc                          , Nil})
	aAdd(aDocFrete,{"MV_PAR14", Space(TamSx3("F1_FORNECE")[1]), Nil})
	aAdd(aDocFrete,{"MV_PAR15", Space(TamSx3("F1_LOJA")[1])   , Nil})
	aAdd(aDocFrete,{"MV_PAR16", Iif(ctpNfMat $ "BD", 2, 1)    , Nil})
	aAdd(aDocFrete,{"MV_PAR17", 2                             , Nil})
	aAdd(aDocFrete,{"MV_PAR18", cCidOri    					  , Nil})
	aAdd(aDocFrete,{"MV_PAR21", GW3->GW3_VLDF                 , Nil})
	aAdd(aDocFrete,{"MV_PAR22", 1                             , Nil})
	aAdd(aDocFrete,{"MV_PAR23", cF1_DOC                       , Nil})
	aAdd(aDocFrete,{"MV_PAR24", PadR(GW3->GW3_SERDF, TamSX3("F1_SERIE")[1])       , Nil})
	aAdd(aDocFrete,{"MV_PAR25", aForLoj[1]                    , Nil})
	aAdd(aDocFrete,{"MV_PAR26", aForLoj[2]                    , Nil})

	If lCpoTes
		cTes := GW3->GW3_TES
	EndIf

	Do Case
		Case cTpImp == "1"
		Do Case
			Case GW3->GW3_TRBIMP == "2"
			cOper := "T8"

			Case GW3->GW3_TRBIMP == "3"
			cOper := "T9"
		EndCase
	EndCase

	If Empty(cOper)
		cOper := "T7"
	EndIf

	If Empty(cTes) .And.  SuperGetMv("MV_TESGFE", .F. , "1") == "1"

		dbSelectArea("SFM")
		SFM->(dbSetOrder(1))
		SFM->(dbSeek(xFilial("SFM")+cOper))
		While !Eof() .AND.  SFM->FM_TIPO == cOper
			If aForLoj[1] == SFM->FM_FORNECE .AND.  aForLoj[2] == SFM->FM_LOJAFOR
				cTes := SFM->FM_TE
				Exit
			EndIf


			If Empty(SFM->FM_FORNECE) .AND.  Empty(SFM->FM_LOJAFOR)
				cTes := SFM->FM_TE
			EndIf
			SFM->(dbSkip())
		EndDo
	EndIf

	if !Empty(AllTrim(cTes))
		aAdd(aDocFrete,{"MV_PAR27"  ,cTes				, Nil})
	EndIf

	aAdd(aDocFrete,{"MV_PAR28"  ,0					, Nil})
	aAdd(aDocFrete,{"MV_PAR29"  ,0					, Nil})
	if lCpoTES
		aAdd(aDocFrete,{"MV_PAR31",GW3->GW3_CPDGFE, Nil})
	else
		aAdd(aDocFrete,{"MV_PAR31",SuperGetMv("MV_CPDGFE", .F. , ""), Nil})
	EndIf
	aAdd(aDocFrete,{"Emissao"   ,GW3->GW3_DTEMIS	, Nil})
	aAdd(aDocFrete,{"F1_ESPECIE",GW3->GW3_CDESP	, Nil})
	aAdd(aDocFrete,{"Natureza"  ,"C"				,nil})
	aAdd(aDocFrete,{"F1_CHVNFE" ,GW3->GW3_CTE		, Nil})






	if Empty(AllTrim(cTes)) .AND.  !Empty(AllTrim(cOper))
		aAdd(aDocFrete,{"D1_OPER"   ,cOper,nil})
	EndIf

	AAdd(aDocFrete,{"F1_TPFRETE","F"  ,nil})
	AAdd(aDocFrete,{"F1_VALPEDG", GW3->GW3_PEDAG, Nil})

	If (cOpcInteg $ "2") .And.  !Empty(GW3->GW3_CTE)
		If GW3->GW3_TPCTE == "0"
			cTpCte = "N"
		ElseIF GW3->GW3_TPCTE == "1"
			cTpCte = "C"
		ElseIF GW3->GW3_TPCTE == "2"
			cTpCte = "A"
		ElseIF GW3->GW3_TPCTE == "3"
			cTpCte = "S"
		EndIf

		aAdd(aDocFrete,{"F1_TPCTE" ,cTpCte ,nil})
	EndIf
	

	If cTpImp == "1"
		AAdd(aDocFrete,{"NF_BASEICM",GW3->GW3_BASIMP,Nil})
		AAdd(aDocFrete,{"IT_ALIQICM",GW3->GW3_PCIMP,Nil})
		AAdd(aDocFrete,{"NF_VALICM",GW3->GW3_VLIMP,Nil})
	EndIf

	Aadd(aDocFrete, {"F1_EST"     , aCidadesUF[1][2]    , Nil } )
	Aadd(aDocFrete, {"F1_ESTDES"  , aCidadesUF[1][4]    , Nil } )
	Aadd(aDocFrete, {"F1_MUORITR" , aCidadesUF[1][1]    , Nil } )
	Aadd(aDocFrete, {"F1_UFORITR" , aCidadesUF[1][2]    , Nil } )
	Aadd(aDocFrete, {"F1_MUDESTR" , aCidadesUF[1][3]    , Nil } )
	Aadd(aDocFrete, {"F1_UFDESTR" , aCidadesUF[1][4]    , Nil } )
Return
















User Function UGFEACTE(lValCte)
	Local lRet := .T.
	Local aRet := {}
	Local aRetVldCte  := { .T. ,""}
	Local cChvCte     := FwFldGet("GW3_CTE")
	Local cEmissor    := FwFldGet("GW3_EMISDF")
	Local cSerie      := FwFldGet("GW3_SERDF")
	Local cNumero     := FwFldGet("GW3_NRDF")
	Local dDataEmis   := FwFldGet("GW3_DTEMIS")
	Local cTpCte      := FwFldGet("GW3_TPCTE")
	Local cTextoProc
	Private oProcess
	lValCte := If( lValCte == nil, .F. , lValCte )

	If SuperGetMv("MV_CHVNFE", .F. , .F. )
		If !lValCte
			aRetVldCte := u_GFE065VCTE(cChvCte, cEmissor, cSerie, cNumero, dDataEmis)
		EndIf
		If !lValCte .And.  !aRetVldCte[1] .And.  Len(AllTrim(SubStr(cChvCte,1,Len(cChvCte)-1))) == Len(cChvCte)-1
			Help(,, "HELP",, "Chave Ct-e invï¿½lida:"+Chr(13)+Chr(10)+aRetVldCte[2], 1, 0)
			Return .F.
		EndIf

		If !Empty(cChvCte) .And.  Len(AllTrim(SubStr(cChvCte,1,Len(cChvCte)-1))) == Len(cChvCte)-1
			If IsBlind()
				aRet := u_UGFEPROC(cChvCte)
			Else
				If u_GA065TC20()
					cTextoProc := "Gerando arquivo de envio para Neogrid..."
				Else
					cTextoProc := "Conectando ao TSS..."
				EndIf

				oProcess := MsNewProcess():New({|| (aRet := u_UGFEPROC(cChvCte)),aRet[1]}, "Consulta ao SEFAZ", cTextoProc)
				oProcess:Activate()
			EndIf
			If !aRet[1]
				Help(,,"HELP",,aRet[2],1,0)
				Return .F.
			EndIf
		EndIf
	EndIf
Return lRet












User Function UGFEPROC(cChvCte)

	Local aRet := { .F. ,""}
	Local lTela := !IsBlind()

	Local cCodRet	:= "Codigo de retorno: "
	Local cMensRet	:= "Mensagem de retorno: "
	Local cProt	:= "Protocolo: "


	Local aDir := {"",""}
	Local cXML
	Local cNmArqSExt
	Local cNmArqOut
	Local cNmArqIn
	Local cDirArqIn
	Local nCount
	Local lEncerraConsulta := .F.
	Local cError   	:= ""
	Local cWarning	:= ""
	Local nHandle		:= 0
	Local cBuffer		:= ""
	Local nSize
	Local oXML	:= NIL
	Local cRetProt, cRetCodRet, cRetMensRet := ""
	Local nTentativa := 1
	Local cURL       := PadR(SuperGetMV("MV_SPEDURL", .F. ,"http://"),250)
	Local nTimeOut   := SuperGetMV("MV_GFETOTC", .F. , 25)
	Local cVerCte    := SuperGetMv("MV_VERCTE", .F. , "2.00")


	Local cIdEnt	:= ""
	Private oWS

	cChvCte := If( cChvCte == nil, "", cChvCte )

	If u_GA065TC20()

		If ((!FindFunction("FWLSEnable") .Or.  !FWLSEnable(3100)) .and.  !FwEmpTeste())
			aRet[2] := "Ambiente nï¿½o licenciado para o modelo TOTVS Colaboraï¿½ï¿½o 2.0."
			Return aRet
		EndIf

		If nTimeOut = 0
			aRet[2] := "Parï¿½metro Tempo de espera para processar retorno da consulta via TOTVS Colaboraï¿½ï¿½o 2.0 nï¿½o informado (aba Integraï¿½ï¿½es ERP)."
			Return aRet
		EndIf

		If Empty(cVerCte) .Or.  cVerCte = " "
			aRet[2] := "Parï¿½metro Versï¿½o do CTe para TOTVS Colaboraï¿½ï¿½o 2.0 nï¿½o informado (aba Integraï¿½ï¿½es ERP)."
			Return aRet
		EndIf


		cNmArqSExt := "208_" + GFENOW( .T. , .T. , "") + "_0001"

		aDir := GA065DPar("MV_NGOUT")
		If Empty(aDir[1])
			aRet[2] := aDir[2]
			Return aRet
		Else
			cNmArqOut := aDir[1] + cNmArqSExt + ".xml"
		EndIf

		aDir := GA065DPar("MV_NGINN")
		If Empty(aDir[1])
			aRet[2] := aDir[2]
			Return aRet
		Else
			cDirArqIn := aDir[1]
			cNmArqIn := cDirArqIn + cNmArqSExt + "*.xml"
		EndIf

		If lTela
			oProcess:setRegua1(nTimeOut + 1)
			oProcess:incRegua1("Gerando arquivo de envio para Neogrid...")
			oProcess:setRegua2(nTimeOut + 1)
			oProcess:incRegua2("Gerando arquivo de envio para Neogrid...")
		EndIf


		If !File(cNmArqOut)
			nHandle := FCreate(cNmArqOut,0)
			If nHandle <= 0
				aRet[2] :=  "Nï¿½o foi possï¿½vel gerar o arquivo de consulta " + cNmArqOut + "."
				Return aRet
			EndIf
			FSeek(nHandle, 0)
		Else
			nHandle := FOpen(cNmArqOut,2)
			If nHandle = 0
				aRet[2] := "Nï¿½o foi possï¿½vel gerar o arquivo de consulta " + cNmArqOut + "."
				Return aRet
			EndIf
			FSeek(nHandle, 0, 2)
		EndIf






		cXML := '<consSitCTe xmlns="http://www.portalfiscal.inf.br/cte" versao="' + cVerCTe + '">' + "<tpAmb>" + cValToChar(SuperGetMV("MV_AMBCTEC", .F. , "1")) + "</tpAmb>" + "<xServ>CONSULTAR</xServ>" + "<chCTe>" + cChvCte + "</chCTe>" + "</consSitCTe>"


		FWrite(nHandle,cXML,len(cXML))
		FClose(nHandle)


		while !lEncerraConsulta
			oProcess:setRegua1(nTimeOut + 1)
			oProcess:setRegua2(nTimeOut + 1)

			For nCount = 1 to nTimeOut
				If lTela
					oProcess:incRegua1("Aguardando retorno da consulta - " + cValToChar(nTentativa) + "ï¿½ tentativa...")
					oProcess:incRegua2("Tempo restante: " + cValToChar(nTimeOut - nCount + 1) + " segundos...")
				end

				Sleep(1000)


				If nCount % 5 = 0 .Or.  nCount = nTimeOut
					aDirImpor := DIRECTORY(Alltrim(cNmArqIn))


					If Len(aDirImpor) = 1
						cNmArqIn := cDirArqIn + aDirImpor[1][1]

						If File(cNmArqIn)
							nHandle := FOpen(cNmArqIn,0+64)
							If nHandle < 0
								aRet[2] := "Nï¿½o foi possï¿½vel efetuar leitura do arquivo de retorno de consulta via Neogrid " + cNmArqIn + "."
								Return aRet
							EndIf

							nSize := FSeek(nHandle,0,2)
							FSeek(nHandle,0)
							FRead(nHandle,@cBuffer,nSize)

							oXML  := XmlParser( cBuffer , "_", @cError, @cWarning)
							FClose(nHandle)
							nHandle   := -1
							FErase(cNmArqIn)

							If XmlChildEx(oXML, "_RETCONSSITCTE") = NIL
								aRet[2] := "Arquivo de retorno com estrutura invï¿½lida."
							Else
								If XmlChildEx(oXML:_RETCONSSITCTE, "_PROTCTE") <> NIL
									cRetProt := oXML:_RETCONSSITCTE:_PROTCTE:_INFPROT:_NPROT:TEXT
								EndIf

								cRetCodRet  := oXML:_RETCONSSITCTE:_CSTAT:TEXT
								cRetMensRet := oXML:_RETCONSSITCTE:_XMOTIVO:TEXT

								If Empty (cRetProt)
									aRet[2] := "A chave digitada nï¿½o foi encontrada na SEFAZ."
								ElseIf AllTrim(cRetCodRet) <> "100"



									aRet[2] := "Uso do CT-e nï¿½o autorizado." + Chr(13)+Chr(10) + cCodRet+cRetCodRet+"."+Chr(13)+Chr(10)+ cMensRet+cRetMensRet+"."+Chr(13)+Chr(10)+ cProt+cRetProt+"."
								Else
									aRet[1] := .T.
								EndIf
							EndIf

							lEncerraConsulta := .T.
							Exit
						EndIf
					ElseIf Len(aDirImpor) > 1
						aRet[2] := "Foi encontrado mais de um arquivo usando o filtro " + cNmArqIn + ". Repita a consulta."
						lEncerraConsulta := .T.
						Exit
					EndIf
				EndIf
			next




			If !lEncerraConsulta
				If !lTela
					aRet[2] := "A consulta da chave de acesso nï¿½o retornou nenhum resultado."
					lEncerraConsulta := .T.
				Else
					If Iif(FindFunction("APMsgYesNo"), APMsgYesNo("A consulta da chave de acesso nï¿½o retornou nenhum resultado. Repetir a busca?",), (cMsgYesNo:="MsgYesNo", &cMsgYesNo.("A consulta da chave de acesso nï¿½o retornou nenhum resultado. Repetir a busca?",)))
						nTentativa += 1
					Else
						aRet[2] := "A chave digitada nï¿½o foi validada na SEFAZ."
						lEncerraConsulta := .T.
					EndIf
				EndIf
			EndIf
		endDo
	Else
		If lTela
			oProcess:setRegua1(3)
			oProcess:incRegua1("Conectando ao TSS...")
			oProcess:setRegua2(3)
			oProcess:incRegua2("Conectando ao TSS...")
		EndIf

		If TMSIsReady(,, .F. )

			If lTela
				oProcess:incRegua1("Obtendo identidade de conexï¿½o...")
				oProcess:incRegua2("Obtendo identidade de conexï¿½o...")
			EndIf
			oWS := WsSPEDAdm():New()
			oWS:cUSERTOKEN := "TOTVS"
			oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or.  Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
			oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
			oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
			oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
			oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
			oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
			oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
			oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
			oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
			oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
			oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
			oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
			oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
			oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
			oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
			oWS:oWSEMPRESA:cCEP_CP     := Nil
			oWS:oWSEMPRESA:cCP         := Nil
			oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
			oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
			oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
			oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
			oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
			oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
			oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
			oWS:oWSEMPRESA:cINDSITESP  := ""
			oWS:oWSEMPRESA:cID_MATRIZ  := ""
			oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
			oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"

			If oWs:ADMEMPRESAS()
				cIdEnt  := oWs:cADMEMPRESASRESULT
			Else
				aRet[2] := "Nï¿½o foi possï¿½vel obter o cï¿½digo da identidade. Motivo:" + Chr(13)+Chr(10) + IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
				Return aRet
			EndIf

			If lTela
				oProcess:incRegua1("Consultando Chave CT-e...")
				oProcess:incRegua2("Consultando Chave CT-e...")
			EndIf

			oWs:= WsNFeSBra():New()
			oWs:cUserToken   := "TOTVS"
			oWs:cID_ENT      := cIdEnt
			ows:cCHVNFE      := cChvCte
			oWs:_URL         := AllTrim(cURL)+"/NFeSBRA.apw"

			If oWs:ConsultaChaveNFE()
				If Type ("oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO") == "U" .OR.  Empty (oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO)
					aRet[2] := "A chave digitada nï¿½o foi encontrada na SEFAZ."
				ElseIf AllTrim(oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE) <> "100"



					aRet[2] := "Uso do CT-e nï¿½o autorizado. " + Chr(13)+Chr(10) + cCodRet+oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE+"."+Chr(13)+Chr(10)+ cMensRet+oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE+"."+Chr(13)+Chr(10)+ cProt+oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO+"."
				Else
					aRet[1] := .T.
				EndIf
			Else
				aRet[2] := "Nï¿½o foi possï¿½vel consultar a Chave CT-e no SEFAZ. Motivo:" + Chr(13)+Chr(10) + IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
			EndIf
		Else
			If Empty(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
				aRet[2] := "Nï¿½o foi possï¿½vel conectar ao TSS. Verifique as configuraï¿½ï¿½es de conexï¿½o. "
			Else
				aRet[2] := "Nï¿½o foi possï¿½vel conectar ao TSS. Motivo: " + Chr(13)+Chr(10) + IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
			EndIf
		EndIf
	EndIf

Return aRet

Static Function GA065DPar(cParam)
	Local aRet := {nil, nil}
	Local cBarra := If(isSrvUnix(),"/","\")

	aRet[1] := AllTrim(SuperGetMv(cParam, .F. , ""))
	If Empty(aRet[1])
		aRet[2] := "Nï¿½o foi especificado um diretï¿½rio para comunicaï¿½ï¿½o com Neogrid no parï¿½metro " + cParam + "."
	Else
		If !ExistDir(aRet[1])
			If MakeDir(aRet[1]) <> 0
				aRet[2] := "Nï¿½o foi possï¿½vel criar pasta " + cValToChar(FError())
			EndIf
		EndIf

		If SubStr(aRet[1], Len(aRet[1]), 1) <> "/" .And.  SubStr(aRet[1], Len(aRet[1]), 1) <> "\"
			aRet[1] += cBarra
		EndIf
	EndIf

Return aRet


User Function GA065TC20()

	Local cTotvsColab	:= SuperGetMV("MV_SPEDCOL", .F. , "N")
	Local cTotvsCol20	:= Alltrim( SuperGetMv("MV_TCNEW", .F.  ,"" ) )




	If cTotvsColab == "S" .And.  ( ("0" $ cTotvsCol20) .Or.  ("6" $ cTotvsCol20))
		Return .T.
	EndIf

Return .F.




User Function UGFE65IC()
	local cCidRem:= Posicione("GU3",1,xFilial("GU3")+M->GW3_CDREM,"GU3_NRCID")
	local cUFRem := Posicione("GU7",1,xFilial("GU7")+cCidRem,"GU7_CDUF")

	dbSelectArea("GUT")
	If dbSeek(xFilial("GUT")+cUFRem)
		Return GUT->GUT_ICMPDG
	EndIf

Return "2"


Static Function RetTipoCTE(cCTE)
	Local aCombo1  :={}
	Local aComboCte:={}
	Local cTPCTE   := ""
	Local nCT      := 0

	If SF1->(FieldPos("F1_TPCTE"))>0
		aCombo1:=x3CboxToArray("F1_TPCTE")[1]
		aSize(aComboCte,Len(aCombo1)+1)
		For nCT:=1 to Len(aComboCte)
			aComboCte[nCT]:=IIf(nCT==1," ",aCombo1[nCT-1])
		next
		nCT:=Ascan(aComboCTE, {|x| Substr(x,1,1) == cCTE})
		If nCT>0
			cTPCTE:=aComboCte[nCT]
		EndIf
	EndIf

Return cTPCTE













User Function UGFE5PRE()
	Local cOBNENT    := SuperGetMV("MV_OBNENT", .F. ,"1")
	Local cOBCOMP    := SuperGetMV("MV_OBCOMP", .F. ,"1")
	Local cOBREEN    := SuperGetMV("MV_OBREEN", .F. ,"1")
	Local cOBDEV     := SuperGetMV("MV_OBDEV" , .F. ,"1")
	Local cOBSERV    := SuperGetMV("MV_OBSERV", .F. ,"1")
	Local cOBREDE    := SuperGetMV("MV_OBREDE", .F. ,cOBNENT,cFilAnt)
	Local ChkObrigat := .F.
	Local lVldCalc   := .F.
	Local lVldSrv    := .F.
	Local lVerificado := .F.
	Local lExistCamp := GFXCP12116("GWF","GWF_CDESP") .And.  (SuperGetMV("MV_DPSERV", .F. , "1") == "1") .And.  (FindFunction("u_UGFVFIX") .And.  u_UGFVFIX())
	Local cCalcn
	Local nRecPriClc


	Do Case
		Case FwFldGet("GW3_TPDF") == "1"




		GVT->( dbSetOrder(1) )
		If GVT->( dbSeek(xFilial("GVT") + GW3->GW3_CDESP) )
			cCalcn := IIF(!Empty(GVT->GVT_CALCN),GVT->GVT_CALCN,"3")
			If cCalcn == "1" .Or.  (cCalcn == "3" .And.  cOBNENT == "1")
				ChkObrigat := .T.
			EndIf
		EndIf
		Case FwFldGet("GW3_TPDF") == "2" .OR.  FwFldGet("GW3_TPDF") == "3"
		If cOBCOMP $ "1S"
			ChkObrigat := .T.
		EndIf

		Case FwFldGet("GW3_TPDF") == "4"
		If cOBREEN $ "1S"
			ChkObrigat := .T.
		EndIf

		Case FwFldGet("GW3_TPDF") == "5"
		If cOBDEV $ "1S"
			ChkObrigat := .T.
		EndIf

		Case FwFldGet("GW3_TPDF") == "6"
		If cOBREDE $ "1S"
			ChkObrigat := .T.
		EndIf

		Case FwFldGet("GW3_TPDF") == "7"
		If cOBSERV $ "1S"
			ChkObrigat := .T.
		EndIf
	EndCase

	If ChkObrigat

		GW4->( dbSetOrder(1))
		If GW4->( dbSeek(xFilial("GW4")+FwFldGet("GW3_EMISDF")+FwFldGet("GW3_CDESP")+FwFldGet("GW3_SERDF")+FwFldGet("GW3_NRDF")+DTOS(FwFldGet("GW3_DTEMIS"))))

			While !Eof() .And.  xFilial("GW4")+GW4->GW4_EMISDF+GW4->GW4_CDESP+GW4->GW4_SERDF+GW4->GW4_NRDF+DTOS(GW4->GW4_DTEMIS) == FwFldGet("GW3_FILIAL")+FwFldGet("GW3_EMISDF")+FwFldGet("GW3_CDESP")+FwFldGet("GW3_SERDF")+FwFldGet("GW3_NRDF")+DTOS(FwFldGet("GW3_DTEMIS"))
				dbSetOrder(1)
				dbSeek(xFilial("GW1")+GW4->GW4_TPDC+GW4->GW4_EMISDC+GW4->GW4_SERDC+GW4->GW4_NRDC)

				GWH->( dbSetOrder(2) )
				If GWH->( dbSeek(xFilial("GWH")+GW1->GW1_CDTPDC+GW1->GW1_EMISDC+GW1->GW1_SERDC+GW1->GW1_NRDC) )

					While !Eof() .And.  xFilial("GWH")+GW1->GW1_CDTPDC+GW1->GW1_EMISDC+GW1->GW1_SERDC+GW1->GW1_NRDC == GWH->GWH_FILIAL+GWH->GWH_CDTPDC+GWH->GWH_EMISDC+GWH->GWH_SERDC+GWH->GWH_NRDC

						GWF->( dbSetOrder(1) )
						GWF->( dbSeek(xFilial("GWF")+GWH->GWH_NRCALC) )


						If lVldCalc <> .T.  .And.  FwFldGet("GW3_TPDF") == GWF->GWF_TPCALC
							lVldCalc := .T.
						EndIf

						If !lVerificado
							lVerificado := .T.
						EndIf



						If lVldCalc .And.  lExistCamp .And.  !Empty(GWF->(GWF_FILIAL+GWF_CDESP+GWF_EMISDF+GWF_SERDF+GWF_NRDF+DToS(GWF_DTEMDF))) .And.  GWF->(GWF_FILIAL+GWF_CDESP+GWF_EMISDF+GWF_SERDF+GWF_NRDF+DToS(GWF_DTEMDF)) <>  FwFldGet("GW4_FILIAL")+FwFldGet("GW4_CDESP")+FwFldGet("GW4_EMISDF")+FwFldGet("GW4_SERDF")+FwFldGet("GW4_NRDF")+DToS(FwFldGet("GW4_DTEMIS"))
							lVldCalc := .F.
							lVldSrv := .T.
						EndIf

						If GFXCP12117("GW3_CDTPSE") .And.  lVldCalc .And.  FwFldGet("GW3_TPDF") == "7"
							If Empty(nRecPriClc)
								nRecPriClc := GWF->(Recno())
							EndIf
							If FwFldGet("GW3_CDTPSE") <> GWF->GWF_CDTPSE
								lVldCalc := .F.
								lVldSrv := .F.
							Else
								lVldSrv := .T.
							EndIf
						EndIf

						dbSelectArea("GWH")
						dbSkip()
					EndDo

					If GFXCP12117("GW3_CDTPSE") .And.  lVldCalc == .F.  .And.  lVldSrv == .F.  .And.  !Empty(nRecPriClc)
						lVldCalc := .T.
						GWF->(dbGoTo(nRecPriClc))
					EndIf
				Else
					lVldCalc := .F.
				EndIf

				If !lVldCalc .And.  lVerificado
					Help( ,, "HELP",, "ï¿½ necessï¿½rio que haja um Cï¿½lculo de Frete dos Documentos de Carga que possua o mesmo Tipo do Documento de Frete, e Transportador do Cï¿½lculo igual ao Emissor do Documento de Frete.", 1, 0)
					Return .F.
				EndIf

				dbSelectArea("GW4")
				dbSkip()
			EndDo
		EndIf
	EndIf
Return .T.










User Function GFE65IPR(lInt,cOp,nOpc)
	Local oDlg
	Local nAlt := 350
	Local nLrg := 520
	Local cDsTransp
	Local oCombo
	Local cCombo
	Local lRet 	:= .F.
	Local cValores := ""
	Local aVlrs := {}

	Local cPritDF := GW3->GW3_PRITDF
	Local ccpdGFE := GW3->GW3_CPDGFE
	Local cTes := GW3->GW3_TES
	Local cConta := GW3->GW3_CONTA
	Local cItemCta := GW3->GW3_ITEMCT
	Local cCC := GW3->GW3_CC
	Local lCpoTES := u_GFE65INP()

	lInt := If( lInt == nil, .F. , lInt )
	cOp := If( cOp == nil, "0", cOp )
	nOpc := If( nOpc == nil, "", nOpc )

	Private cCadastro := "Integraï¿½ï¿½o Protheus"


	If (GW3->GW3_SITFIS == "4") .OR.  (GW3->GW3_SITREC == "4")
		If cOp == "1"
			Iif(FindFunction("APMsgAlert"), APMsgAlert("Documento estï¿½ com a situaï¿½ï¿½o de Integrado. Dados nï¿½o podem ser alterados",), MsgAlert("Documento estï¿½ com a situaï¿½ï¿½o de Integrado. Dados nï¿½o podem ser alterados",))
			Return .T.
		EndIf
	EndIf

	If !lCpoTES
		Iif(FindFunction("APMsgAlert"), APMsgAlert("Os campos de integraï¿½ï¿½o Protheus nï¿½o encontrados na tabela",), MsgAlert("Os campos de integraï¿½ï¿½o Protheus nï¿½o encontrados na tabela",))
		Return .T.
	EndIf

	If lInt




		If GFE065VCPO(nOpc, .F. , @aVlrs)
			If Len(aVlrs) > 0
				ccpdGFE	:= aVlrs[1]
				cPritDF 	:= aVlrs[2]
				cConta 	:= aVlrs[3]
				cItemCta 	:= aVlrs[4]
				cCC 		:= aVlrs[5]
				cTes 		:= aVlrs[6]
			EndIf
		EndIf
	EndIf

	CursorWait()




	oDlg = MsDialog():New( 00, 00, nAlt, nLrg, cCadastro,,,.F.,, 0, (225+(225*256)+(225*65536)),, oMainWnd,.T.,, ,.F. )
	oDlg:lEscClose := .F.

	oPnlA := tPanel():New(00,00,,oDlg,,,,,,30,135, .F. , .F. )
	oPnlA:Align := 5

	TSay():New( 07, 15,{||  "Cod.Produto"},oPnlA,,,.F.,.F.,.F.,.T., 0,,,,.F.,.F.,.F.,.F.,.F.,.F. )
	TGet():New( 05, 60, { | u | If( PCount() == 0, cPritDF, cPritDF := u ) },oPnlA, 100, 11, "@!",{||  u_UGFEVAL(@cConta,@cItemCta,@cCC,@cTes,cPritDF)},,,,.F.,,.T.,,.F.,{||  .T. },.F.,.F.,,.F.,.F. ,"SB1","cPritDF",,,, )

	TSay():New( 22, 15,{||  "Cond.Pagto"},oPnlA,,,.F.,.F.,.F.,.T., 0,,,,.F.,.F.,.F.,.F.,.F.,.F. )
	TGet():New( 20, 60, { | u | If( PCount() == 0, ccpdGFE, ccpdGFE := u ) },oPnlA, 100, 11, "@!",,,,,.F.,,.T.,,.F.,{||  .T. },.F.,.F.,,.F.,.F. ,"SE4","ccpdGFE",,,, )

	TSay():New( 37, 15,{||  "TES"},oPnlA,,,.F.,.F.,.F.,.T., 0,,,,.F.,.F.,.F.,.F.,.F.,.F. )
	TGet():New( 35, 60, { | u | If( PCount() == 0, cTes, cTes := u ) },oPnlA, 100, 11, "@!",,,,,.F.,,.T.,,.F.,{||  .T. },.F.,.F.,,.F.,.F. ,"SF4","cTes",,,, )

	TSay():New( 52, 15,{||  "Conta Contabil"},oPnlA,,,.F.,.F.,.F.,.T., 0,,,,.F.,.F.,.F.,.F.,.F.,.F. )
	TGet():New( 50, 60, { | u | If( PCount() == 0, cConta, cConta := u ) },oPnlA, 100, 11, "@!",,,,,.F.,,.T.,,.F.,{||  .T. },.F.,.F.,,.F.,.F. ,"CT1","cConta",,,, )

	TSay():New( 67, 15,{||  "Item Contabil"},oPnlA,,,.F.,.F.,.F.,.T., 0,,,,.F.,.F.,.F.,.F.,.F.,.F. )
	TGet():New( 65, 60, { | u | If( PCount() == 0, cItemCta, cItemCta := u ) },oPnlA, 100, 11, "@!",,,,,.F.,,.T.,,.F.,{||  .T. },.F.,.F.,,.F.,.F. ,"CTD","cItemCta",,,, )

	TSay():New( 82, 15,{||  "Centro de Custo"},oPnlA,,,.F.,.F.,.F.,.T., 0,,,,.F.,.F.,.F.,.F.,.F.,.F. )
	TGet():New( 80, 60, { | u | If( PCount() == 0, cCC, cCC := u ) },oPnlA, 100, 11, "@!",,,,,.F.,,.T.,,.F.,{||  .T. },.F.,.F.,,.F.,.F. ,"CTT","cCC",,,, )

	CursorArrow()

	oDlg:Activate( oDlg:bLClicked, oDlg:bMoved, oDlg:bPainted,.T.,,,{|Self|EnchoiceBar(ODlg,{||lRet:= .T. ,ODlg:End()},{||lRet:= .F. ,ODlg:End(),},,)}, oDlg:bRClicked, )


	cValores := AllTrim(cPritDF) + AllTrim(cTes) + AllTrim(ccpdGFE)

	If lInt .AND.  cValores == ""
		lRet := .F.
	EndIf

	If lRet
		lDlg := .T.
		RecLock( "GW3", .f.  )
		GW3->GW3_PRITDF := cPritDF
		GW3->GW3_CPDGFE := ccpdGFE
		GW3->GW3_TES := cTes
		GW3->GW3_CONTA := cConta
		GW3->GW3_ITEMCT := cItemCta
		GW3->GW3_CC := cCC
		MsUnlock("GW3")
		lDlg := .F.
	EndIf

Return lRet










User Function UGFEVAL(cConta,cItemCta,cCC,cTes,cPritDF)
	Local cPr := GW3->GW3_PRITDF

	If AllTrim(cPritDF) == AllTrim( cPr )
		Return .T.
	EndIf

	If !lDlg
		cConta		:= U_GFE065GAT( "1", "2", cPritDF )
		cItemCta	:= U_GFE065GAT( "2", "2", cPritDF )
		cCC			:= U_GFE065GAT( "3", "2", cPritDF )
		cTes		:= U_GFE065GAT( "4", "2", cPritDF )
	EndIf
Return .T.


User Function GFE065GAT(cCampo,cTipo,cPritDF)

	Local cConta    := ""
	Local cItemcta  := ""
	Local cCC       := ""
	Local cTes      := ""
	Local cRet      := ""
	Local cPrtDf    := ""
	cTipo := If( cTipo == nil, "1", cTipo )
	cPritDF := If( cPritDF == nil, "", cPritDF )

	If cTipo == "1"
		cPrtDf := M->GW3_PRITDF
	ElseIf cTipo == "2"
		cPrtDf := cPritDF
	EndIf

	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+cPrtDf))
		cConta   := SB1->B1_CONTA
		cItemCta := SB1->B1_ITEMCC
		cCC      := SB1->B1_CC
		cTes     := SB1->B1_TE
	EndIf

	If cCampo = "1"
		cRet := cConta
	ElseIf cCampo = "2"
		cRet := cItemCta
	ElseIf cCampo == "3"
		cRet := cCC
	ElseIf cCampo =="4"

		If ctes <> ""
			cRet := cTes
		else

			cTes := ""
		EndIf
	Else
		cRet := ""
	EndIf

Return (cRet)


Static Function GFE065VCPO(nOpc, lGrava, aVlrs, lPerg)
	Local lRet     := .F.
	Local cPritDF  := Iif(!Empty(GW3->GW3_PRITDF),GW3->GW3_PRITDF,SuperGetMV("MV_PRITDF", .F. ))
	Local lIntProt := SuperGetMV("MV_ERPGFE", .F. )
	Local cCpdGFE  := SuperGetMV("MV_CPDGFE", .F. )
	Local bBlock   := {|| .T. }

	aVlrs := If( aVlrs == nil, {}, aVlrs )
	lPerg := If( lPerg == nil, .T. , lPerg )
	
	

	If lPerg .And.  (SuperGetMV("MV_TESGFE", .F. , "1") == "2")
		bBlock := {|| Iif(FindFunction("APMsgYesNo"), APMsgYesNo("Deseja utilizar os dados do produto informados no parï¿½metro do GFE?", "Confirmaï¿½ï¿½o Dados do Produto"), (cMsgYesNo:="MsgYesNo", &cMsgYesNo.("Deseja utilizar os dados do produto informados no parï¿½metro do GFE?", "Confirmaï¿½ï¿½o Dados do Produto")))}
	EndIf

	If ( lIntProt == "2" ) .And.  ( (nOpc == "1") .Or.  (nOpc == "2") )

		If ( Empty(GW3->GW3_TES) .Or.  Empty(GW3->GW3_CPDGFE) .Or.  Empty(GW3->GW3_PRITDF) .Or.  Empty(GW3->GW3_CONTA) .Or.  Empty(GW3->GW3_ITEMCT) .Or.  Empty(GW3->GW3_CC) )

			If Eval(bBlock)

				If lGrava
					RecLock("GW3", .F. )
					GW3->GW3_CPDGFE  := cCpdGFE
					GW3->GW3_PRITDF  := cPritDF
					GW3->GW3_CONTA   := Iif(!Empty(GW3->GW3_CONTA)  ,GW3->GW3_CONTA  ,U_GFE065GAT( "1", "2", cPritDF ))
					GW3->GW3_ITEMCT := Iif(!Empty(GW3->GW3_ITEMCT),GW3->GW3_ITEMCT,U_GFE065GAT( "2", "2", cPritDF ))
					GW3->GW3_CC      := Iif(!Empty(GW3->GW3_CC)     ,GW3->GW3_CC     ,U_GFE065GAT( "3", "2", cPritDF ))
					GW3->GW3_TES     := Iif(!Empty(GW3->GW3_TES)    ,GW3->GW3_TES    ,U_GFE065GAT( "4", "2", cPritDF ))
					MsUnlock("GW3")
				Else
					aAdd( aVlrs, cCpdGFE )
					aAdd( aVlrs, cPritDF )
					aAdd( aVlrs, Iif(!Empty(GW3->GW3_CONTA)  ,GW3->GW3_CONTA  ,U_GFE065GAT( "1", "2", cPritDF )) )
					aAdd( aVlrs, Iif(!Empty(GW3->GW3_ITEMCT),GW3->GW3_ITEMCT,U_GFE065GAT( "2", "2", cPritDF )) )
					aAdd( aVlrs, Iif(!Empty(GW3->GW3_CC)     ,GW3->GW3_CC     ,U_GFE065GAT( "3", "2", cPritDF )) )
					aAdd( aVlrs, Iif(!Empty(GW3->GW3_TES)    ,GW3->GW3_TES    ,U_GFE065GAT( "4", "2", cPritDF )) )
				EndIf
				lRet := .T.
			EndIf
		Else
			lRet := .T.
		end
	end

Return (lRet)









User Function GFE065TES(cTes,cTpImp,cTrbImp,cCrdIcm,cCrdPc,aForLoj)
	Local cOper := ""


	Do Case
		Case cTpImp == "1"
		Do Case

			Case cTrbImp == "2" .And.  cCrdPc == "1"

			cOper := "T2"

			Case cTrbImp == "2" .And.  cCrdPc == "2"

			cOper := "T6"

			Case cTrbImp == "3" .And.  cCrdIcm == "1"

			cOper := "T3"

			Case cTrbImp == "3" .And.  cCrdIcm == "2"

			cOper := "T5"

			Case cTrbImp == "1" .And.  cCrdPc == "2"

			cOper := "T7"

			Case cTrbImp == "1" .And.  cCrdIcm == "2"


			cOper := "T8"

			Case cTrbImp == "6"

			cOper := "T8"
		EndCase

		Case cTpImp == "2"

		cOper := "T4"
		Case cTpImp == "3"

		cOper := "TA"
	EndCase

	If Empty(cOper)
		cOper := "T1"
	EndIf

	dbSelectArea("SFM")
	SFM->(dbSetOrder(1))
	SFM->(dbSeek(xFilial("SFM")+cOper))
	While !Eof() .AND.  SFM->FM_TIPO == cOper
		If aForLoj[1] == SFM->FM_FORNECE .AND.  aForLoj[2] == SFM->FM_LOJAFOR
			cTes := SFM->FM_TE
			Exit
		EndIf





		If Empty(SFM->FM_FORNECE) .AND.  Empty(SFM->FM_LOJAFOR)
			cTes := SFM->FM_TE
		EndIf
		SFM->(dbSkip())
	EndDo

	cOperPE := cOper

Return cTes


User Function UGFENPR(cTipo)
	Local cRet := SuperGetMV("MV_PRITDF", .F. ,TamSX3("B1_COD")[1])
	Local cPritDFa := ""

	If cTipo = 1
		cPritDFA := M->GW3_PRITDF
	Else
		cPritDFa := GW3->GW3_PRITDF
	EndIf

	If !Empty(cPritDFa)
		cRet := cPritDFa
	EndIf

Return cRet













User Function UGFVFIX()

	dbSelectArea("GW0")

	cFilGW0 := Space(Len(xFilial("GW0")))
	cTabela := PadR("GWF", TamSX3("GW0_TABELA")[1])
	cFun    := PadR("MV_DPSERV", TamSX3("GW0_CHAVE")[1])

	dbSelectArea("GW0")
	GW0->( dbSetOrder(1) )
	If !GW0->(dbSeek(cFilGW0+cTabela+cFun))
		If s_DPSERV == "1"
			GFEConout("INFO","Necessï¿½rio Execuï¿½ï¿½o de acerto de base u_GFEUPDCalc() ")
		EndIf

	EndIf

Return .T.


Static Function GFE065PreT(oModelGW4)
	Local cTpDc	  	:= FwFldGet("GW4_TPDC")
	Local cEmiDc	  	:= FwFldGet("GW4_EMISDC")
	Local cSerDc	  	:= FwFldGet("GW4_SERDC")
	Local cNrDc	  	:= FwFldGet("GW4_NRDC")
	Local cTipo      	:= FwFldGet("GW3_TPDF")
	Local oView     	:= FWViewActive()
	Local nLine     	:= oModelGW4:GetLine()
	Local aRet			:= {}

	If __lCpoSDoc == Nil
		__lCpoSDoc := Len(TamSX3("GW4_SDOCDC")) > 0
	EndIf

	If TamSx3("GW4_SERDC")[1] == 14
		aRet := GFE517TLDC( cNrDc , cTpDc , cEmiDc , cSerDc )

		If Len(aRet) > 0
			If !oModelGW4:IsDeleted()
				oModelGW4:GoLine( nLine )

				oModelGW4:LoadValue("GW4_TPDC"  , aRet[6])
				oModelGW4:LoadValue("GW4_EMISDC", aRet[2])
				oModelGW4:LoadValue("GW4_NMEMIS", POSICIONE("GU3", 1, xFilial("GU3") + aRet[2], "GU3_NMEMIT"))
				oModelGW4:LoadValue("GW4_SERDC" , aRet[4])
				oModelGW4:LoadValue("GW4_NRDC"  , aRet[5])
				If __lCpoSDoc
					oModelGW4:LoadValue("GW4_SDOCDC", Transform(aRet[4], "!!!") )
				EndIf
			EndIf

			If oView <> Nil .And.  oView:lActivate
				oView:Refresh()
			EndIf

		EndIf
	EndIf

Return Nil














User Function UGFE65DM()
	Local lRet := .T.
	Local nRecnoGW3 := GW3->(Recno())

	If !(GW3->GW3_SITMLA $ "3|4|7")
		Help(,,"HELP",,"Documento de Frete ainda nï¿½o foi integrado ao MLA.",1,0)
		lRet := .F.
	EndIf

	If lRet .And.  Iif(FindFunction("APMsgNoYes"), APMsgNoYes("Deseja desatualizar o Documento de Frete no MLA?", "Aviso"), (cMsgNoYes:="MsgNoYes", &cMsgNoYes.("Deseja desatualizar o Documento de Frete no MLA?", "Aviso")))
		GW3->(dbGoto(nRecnoGW3))
		RecLock("GW3", .F. )
		GW3->GW3_SITMLA := "5"
		MsUnlock("GW3")

		Iif(FindFunction("APMsgInfo"), APMsgInfo("Documento de Frete enviado para desatualizaï¿½ï¿½o no MLA.",), MsgInfo("Documento de Frete enviado para desatualizaï¿½ï¿½o no MLA.",))
	EndIf

Return lRet





User Function GFE65INP()
	Local lRet := .F.
	Local aArea := GetArea()














	If Select("SX2") > 0

		dbSelectArea("GW3")

		If GW3->(FieldPos("GW3_TES")) > 0
			dbSelectArea("SX3")
			dbSetOrder(2)
			If dbSeek("GW3_ACINT")
				If GW3->(FieldPos("GW3_ACINT")) > 0 .And.  At("1234", X3_VALID) > 0 .And.  At("PRE-NOTA",NoAcento(UPPER(X3_CBOX))) > 0
					lRet := .T.
				EndIf
			EndIf
		EndIf

	EndIf
	RestArea(aArea)
Return lRet












User Function GFE065DTVF()
	Local dDataVenc := CtoD("  /  /    ")

	GW6->(DbSetOrder(1))
	If !Inclui .And.  GW6->(DbSeek(GW3->GW3_FILFAT+GW3->GW3_EMIFAT+GW3->GW3_SERFAT+GW3->GW3_NRFAT))
		dDataVenc := GW6->GW6_DTVENC
	EndIf

Return dDataVenc












User Function SitFinGW6()
	Local aOldArea := GetArea()
	Local cPos
	cPos := Posicione("GW6",1,GW3->GW3_FILFAT+GW3->GW3_EMIFAT+GW3->GW3_SERFAT+GW3->GW3_NRFAT+DTOS(GW3->GW3_DTEMFA),"GW6_SITFIN")
	RestArea(aOldArea)
Return NGRETSX3BOX("GW6_SITFIN",cPos)













User Function SitFinGW6c()
	local oModel := FwModelActive()
	Local aOldArea := GetArea()
	Local cPos := ""
	If oModel == Nil
		Return ""
	Else
		Inclui := ( oModel:GetOperation() == 3 )
	EndIf
	If !Inclui
		cPos := Posicione("GW6",1,GW3->GW3_FILFAT+GW3->GW3_EMIFAT+GW3->GW3_SERFAT+GW3->GW3_NRFAT+DTOS(GW3->GW3_DTEMFA),"GW6_SITFIN")
	EndIf
	IF cPos == ""
		cPos := "1"
	EndIf
	RestArea(aOldArea)
Return cPos














User Function DtFinGW6()
	Local aOldArea := GetArea()
	Local cPos
	cPos := Posicione("GW6",1,GW3->GW3_FILFAT+GW3->GW3_EMIFAT+GW3->GW3_SERFAT+GW3->GW3_NRFAT+DTOS(GW3->GW3_DTEMFA),"GW6_DTFIN")
	RestArea(aOldArea)
Return cPos













User Function DtFinGW6c()
	local oModel := FwModelActive()
	Local aOldArea := GetArea()
	Local cPos := ""
	If oModel == Nil
		Return ""
	Else
		Inclui := ( oModel:GetOperation() == 3 )
	EndIf
	If !Inclui
		cPos := Posicione("GW6",1,GW3->GW3_FILFAT+GW3->GW3_EMIFAT+GW3->GW3_SERFAT+GW3->GW3_NRFAT+DTOS(GW3->GW3_DTEMFA),"GW6_DTFIN")
	EndIf
	RestArea(aOldArea)
Return cPos












User Function MotFinGW6()
	Local cPos := ""
	Local aOldArea := GetArea()
	cPos := Posicione("GW6",1,GW3->GW3_FILFAT+GW3->GW3_EMIFAT+GW3->GW3_SERFAT+GW3->GW3_NRFAT+DTOS(GW3->GW3_DTEMFA),"GW6_MOTFIN")
	RestArea(aOldArea)
Return cPos












User Function MotFinGW6c()
	local oModel := FwModelActive()
	Local aOldArea := GetArea()
	Local cPos := ""
	If oModel == Nil
		Return ""
	Else
		Inclui := ( oModel:GetOperation() == 3 )
	EndIf
	If !Inclui
		cPos := Posicione("GW6",1,GW3->GW3_FILFAT+GW3->GW3_EMIFAT+GW3->GW3_SERFAT+GW3->GW3_NRFAT+DTOS(GW3->GW3_DTEMFA),"GW6_MOTFIN")
	EndIf
	RestArea(aOldArea)
Return cPos
















Static Function GFEADOCPF()
	Local oDlg
	Local lRet
	Static cFil
	Static nPreFat

	If cFil == Nil
		cFil    := space(Len(GWJ->GWJ_FILIAL))
		nPreFat := space(Len(GWJ->GWJ_NRPF))
	EndIf

	oDlg = MsDialog():New( 4, 0, 100, 250, "Pesquisar Documentos de carga",,,.F.,,,,, oMainWnd,.T.,, ,.F. )

	TSay():New( 4, 020,{||  "Filial:"},oDlg,,,.F.,.F.,.F.,.T.,,, 70, 7,.F.,.F.,.F.,.F.,.F.,.F. )
	TSay():New( 19, 005,{||  "Nr. Prï¿½-Fatura:"},oDlg,,,.F.,.F.,.F.,.T.,,, 70, 7,.F.,.F.,.F.,.F.,.F.,.F. )

	TGet():New( 3, 040, { | u | If( PCount() == 0, cFil, cFil := u ) },oDlg, 45, 7,,,,,,.F.,,.T.,,.F.,{||  .T. },.F.,.F.,,.F.,.F. ,"SM0","cFil",,,,.T. )
	TGet():New( 18, 040, { | u | If( PCount() == 0, nPreFat, nPreFat := u ) },oDlg, 45, 7,,,,,,.F.,,.T.,,.F.,{||  .T. },.F.,.F.,,.F.,.F. ,"GWJPRE","nPreFat",,,,.T. )


	oButtonOK   := tButton():New(35,002,"OK",oDlg,{||IIf (!Empty(cFil) .And.  !Empty(nPreFat), (UGFEA065PF(cFil,nPreFat),	oDlg:End()), Help(,,"HELP",, "Favor preencher os campos de Filial e Prï¿½-Fatura.", 1, 0))  },25,10,,,, .T. )
	oButtonCanc := tButton():New(35,030,"Cancelar",oDlg,{||lRet:={},oDlg:End()},25,10,,,, .T. )

	oDlg:Activate( oDlg:bLClicked, oDlg:bMoved, oDlg:bPainted,,,,, oDlg:bRClicked, )

Return















Static Function UGFEA065PF(cFilp, cNrpf)
	Local oView     := FWViewActive()
	Local oModel    := oView:GetModel()
	Local oModelGW4 := oModel:GetModel("UGFEA065_GW4")
	Local aAreaGWH  := GWH->(GetArea())
	Local aAreaGWF  := GWF->(GetArea())
	Local aPosGWH
	Local nLineaUX
	Local nTotLen
	Local nPfv		:= 0
	Local nDC       := 0
	Local nChange   := 0
	Local aErroGW4
	Local aArea := GetArea()
	Local cGW3_TPDF
	Local cGW3_EMISDF
	Local nCalc := 0
	cGW3_TPDF 	:= FwFldGet("GW3_TPDF")
	cGW3_EMISDF	:= FwFldGet("GW3_EMISDF")

	If __lCpoSDoc == Nil
		__lCpoSDoc := Len(TamSX3("GW4_SDOCDC")) > 0
	EndIf

	lPrimeiro  := .F.

	dbSelectArea("GWJ")
	dbSetOrder(1)
	If !dbSeek(cFilp+cNrpf)
		Help(,,"HELP",, "Nï¿½o foi encontrada prï¿½-fatura com o nï¿½mero informado.", 1, 0)
		RestArea(aArea)
		Return .F.
	EndIf
	RestArea(aArea)

	nLineaUX := oModelGW4:GetLine()

	dbSelectArea("GWF")
	dbSetOrder(3)
	dbSeek(cFilp+cNrpf)
	While !GWF->(Eof()) .And.  cFilp+cNrpf == GWF->GWF_FILPRE+GWF->GWF_NRPREF
		If GWF->GWF_TPCALC == cGW3_TPDF .And.  GWF->GWF_TRANSP == cGW3_EMISDF
			nCalc++
			dbSelectArea("GWH")
			dbSetOrder(1)
			dbSeek(GWF->GWF_FILIAL+GWF->GWF_NRCALC)
			While !GWH->(Eof()) .And.  GWF->GWF_FILIAL+GWF->GWF_NRCALC == GWH->GWH_FILIAL+GWH->GWH_NRCALC

				dbSelectArea("GW1")
				GW1->( dbSetOrder(1) )
				If GW1->( dbSeek(xFilial("GW1") + GWH->GWH_CDTPDC + GWH->GWH_EMISDC + GWH->GWH_SERDC + GWH->GWH_NRDC) )


					If oModelGW4:SeekLine({{"GW4_TPDC", GW1->GW1_CDTPDC}, {"GW4_EMISDC", GW1->GW1_EMISDC}, {"GW4_SERDC", GW1->GW1_SERDC}, {"GW4_NRDC", GW1->GW1_NRDC}})

						GWH->( dbSetOrder(1) )
						GWH->( dbSkip() )
						Loop
					EndIf

					nTotLen := oModelGW4:Length() + 1




					If !Empty(  oModelGW4:GetValue("GW4_TPDC"  ,1)+ oModelGW4:GetValue("GW4_EMISDC",1)+ oModelGW4:GetValue("GW4_NMEMIS",1)+ oModelGW4:GetValue("GW4_SERDC" ,1)+ oModelGW4:GetValue("GW4_NRDC"  ,1))
						If oModelGW4:AddLine() <> nTotLen
							Help(,,"HELP",, oModel:GetErrorMessage()[6],1,0)
							Return .F.
						EndIf
					EndIf
					oModelGW4:LoadValue("GW4_TPDC"  , GW1->GW1_CDTPDC)
					oModelGW4:LoadValue("GW4_EMISDC", GW1->GW1_EMISDC)
					oModelGW4:LoadValue("GW4_NMEMIS", POSICIONE("GU3", 1, xFilial("GU3") + GW1->GW1_EMISDC, "GU3_NMEMIT"))
					oModelGW4:LoadValue("GW4_SERDC" , GW1->GW1_SERDC )
					oModelGW4:LoadValue("GW4_NRDC"  , GW1->GW1_NRDC  )
					If __lCpoSDoc
						oModelGW4:LoadValue("GW4_SDOCDC", GW1->GW1_SDOC)
					EndIf
					If !oModelGW4:VldLineData()
						aErroGW4 := oModel:GetErrorMessage()
						oModelGW4:DeleteLine()
					EndIf
					nDc++
				EndIf
				GWH->( dbSkip() )
			EndDo
		EndIf
		GWF->( dbSkip() )
	EndDo

	RestArea(aAreaGWF)
	RestArea(aAreaGWH)
	oModelGW4:GoLine(nLineaUX)
	oView:Refresh()

	If nCalc == 0
		Help(,,"HELP",, "Nï¿½o foram encontrados Cï¿½lculos do tipo " + GFEFldInfo("GW3_TPDF", FwFldGet("GW3_TPDF"), 2) + " para o emissor do conhecimento relacionados ï¿½ prï¿½-fatura.", 1, 0)
	ElseIf nDC == 0
		Help(,,"HELP",, "Nï¿½o foram encontrados outros Documentos de Carga para vincular ao Documento de Frete.", 1, 0)
	EndIf

Return

Static Function CORVALID(lCor)
	If lCor
		Return "BR_VERDE"
	Else
		Return "BR_VERMELHO"
	EndIf
Return

Static Function LEGVALID()
	Local aLegenda := {}
	Local cTitulo  := ""

	cTitulo  := "Status do registro"
	Aadd(aLegenda,{"BR_VERMELHO", "Invï¿½lido"})
	Aadd(aLegenda,{"BR_VERDE" , "Vï¿½lido"})
	BrwLegenda(cTitulo, "Legenda", aLegenda)
Return .T.
















User Function UGFEACTA()

Return SuperGetMv("MV_INTTMS", .F. , .F. ) == .T.  .And.  SuperGetMv("MV_GFEI21", .F. ,"3") $ "1;2"

























User Function UGFEA065CTP(cAcao,lExibeMsg)
	Local aCotacao   := {1,RecMoeda(Date(),2),RecMoeda(Date(),3),RecMoeda(Date(),4),RecMoeda(Date(),5)}



	Local aCmpVal    := {{"GWM_VLFRET","GWM_VLICMS","GWM_VLPIS","GWM_VLCOFI"}, {"GWM_VLFRE1","GWM_VLICM1","GWM_VLPIS1","GWM_VLCOF1"}, {"GWM_VLFRE2","GWM_VLICM2","GWM_VLPIS2","GWM_VLCOF2"}, {"GWM_VLFRE3","GWM_VLICM3","GWM_VLPIS3","GWM_VLCOF3"}}
	Local nCriRat    := Val(SuperGetMV("MV_CRIRAT",,"1"))
	Local aRet       :=  { .F. ,"","",NIL,"",""}
	Local lAtualiza, lExec := .F.

	Local aAreaGW3 := GW3->(GetArea())
	Local oModel := nil
	Local lMsgAviso := .F.
	Local nValor
	Local cQuery
	Local aForn
	lExibeMsg := If( lExibeMsg == nil, .F. , lExibeMsg )

	If !SuperGetMv("MV_INTTMS", .F. , .F. )
		aRet[2] := "Integraï¿½ï¿½o de valores de custo de transporte disponï¿½vel apenas para ambientes com SIGATMS implantado."
	ElseIf SuperGetMV("MV_GFEI21", .F. , "3") == "3"
		aRet[2] := "Parï¿½metro Custos de Transporte configurado para nï¿½o integrar custo de transporte com SIGATMS."
	ElseIf !(GW3->GW3_SIT $ "34") .And.  !(SubStr(cAcao,1,1) $ "P;E")
		aRet[2] := "Para integraï¿½ï¿½o de valores de custo de transporte com SIGATMS o documento de frete deve estar aprovado."
	Else
		Do Case
			Case Substr(cAcao,1,1) == "E"
			dbSelectArea("SDG")
			GWC->(dbSetOrder(1))
			GWC->(dbSeek(GW3->(GW3_FILIAL+GW3_CDESP+GW3_EMISDF+GW3_SERDF+GW3_NRDF+dToS(GW3_DTEMIS))))

			While !GWC->(Eof()) .And.  GWC->(GWC_FILIAL+GWC_CDESP+GWC_EMISDF+GWC_SERDF+GWC_NRDF+DTOS(GWC_DTEMIS)) == GW3->(GW3_FILIAL+GW3_CDESP+GW3_EMISDF+GW3_SERDF+GW3_NRDF+dToS(GW3_DTEMIS))

				lExec := .T.

				SDG->(dbSetOrder(1))
				SDG->(dbSeek(GWC->(GWC_FILIAL+GWC_DOC+GWC_CODDES+GWC_ITEM)))
				While !SDG->(Eof()) .And.  GWC->(GWC_FILIAL+GWC_DOC+GWC_CODDES+GWC_ITEM) == SDG->(DG_FILIAL+DG_DOC+DG_CODDES+DG_ITEM)
					TMSA070Bx("2", SDG->DG_NUMSEQ)

					RecLock("SDG", .F. )
					SDG->(dbDelete())
					SDG->(MsUnlock())
					SDG->(dbSkip())
				EndDo

				RecLock("GWC", .F. )
				GWC->(dbDelete())
				GWC->(MsUnlock())
				GWC->(dbSkip())
			EndDo


			If cAcao == "E"
				aRet[1] := .T.
				aRet[3] := "1"
				aRet[4] := SToD("")

				lMsgAviso := .T.
				If lExec
					aRet[2] := "Exclusï¿½o dos valores de custo de transporte com SIGATMS efetuada com sucesso."
				Else
					aRet[2] := "Nï¿½o foram encontrados valores de custo de transporte com SIGATMS para exclusï¿½o."
				EndIf
			EndIF
			Case cAcao == "P"
			lMsgAviso := .T.
			aRet[1] := .T.
			aRet[2] := "Situaï¿½ï¿½o de integraï¿½ï¿½o de valores de custo de frete com SIGATMS alterado para Pendente Atualizaï¿½ï¿½o."
			aRet[3] := "4"
			Case Substr(cAcao,1,1) == "I"

			lAtualiza := .F.

			If GW3->GW3_SITCUS == "2"
				aRet[2] := "Integraï¿½ï¿½o de valores de custo de transporte com SIGATMS jï¿½ efetuada para este documento de frete."
			Else
				Do Case
					Case cAcao == "ID"
					If SuperGetMv("MV_GFEI21", .F. , "3") $ "1,2"
						lAtualiza := .T.
					EndIf
					Case cAcao == "IA"
					If SuperGetMv("MV_GFEI21", .F. , "3") == "2"
						lAtualiza := .T.
					Else
						aRet[2] := "Custo de transporte do documento de frete nï¿½o pendente para integraï¿½ï¿½o automï¿½tica com SIGATMS."
					EndIf
					Case cAcao = "IL"
					lAtualiza := .T.
				EndCase
			EndIf

			If lAtualiza
				If AllTrim(GW3->GW3_DESCUS) == ""
					aRet[1] := .T.
					aRet[2] := "Cï¿½digo da Despesa de Frete nï¿½o informado no documento de frete."
					aRet[3] := "3"
				Else
					cQuery := "SELECT SUM(GWM." + aCmpVal[nCriRat][1] + ") VLFRET, SUM(GWM." + aCmpVal[nCriRat][2] + ") VLICMS, "
					cQuery += "SUM(GWM." + aCmpVal[nCriRat][3] + ") VLPIS, SUM(GWM." + aCmpVal[nCriRat][4] + ") VLCOFINS, "
					cQuery += "GWE.GWE_FILDT, GWE.GWE_NRDT, GWE.GWE_SERDT"
					cQuery += "FROM " + RetSQLName("GWM") + " GWM, " + RetSQLName("GWE") + " GWE"
					cQuery += "WHERE GWM.GWM_FILIAL = '" + GW3->GW3_FILIAL + "' "
					cQuery += "AND GWM.GWM_TPDOC = '2' "
					cQuery += "AND GWM.GWM_CDESP = '" + GW3->GW3_CDESP + "' "
					cQuery += "AND GWM.GWM_CDTRP = '" + GW3->GW3_EMISDF + "' "
					cQuery += "AND GWM.GWM_SERDOC = '" + GW3->GW3_SERDF + "' "
					cQuery += "AND GWM.GWM_NRDOC = '" + GW3->GW3_NRDF + "' "
					cQuery += "AND GWM.GWM_DTEMIS = '" + DToS(GW3->GW3_DTEMIS) + "' "
					cQuery += "AND GWM.D_E_L_E_T_ = ' ' "
					cQuery += "AND GWE.GWE_FILIAL = GWM.GWM_FILIAL "
					cQuery += "AND GWE.GWE_CDTPDC = GWM.GWM_CDTPDC "
					cQuery += "AND GWE.GWE_EMISDC = GWM.GWM_EMISDC "
					cQuery += "AND GWE.GWE_SERDC = GWM.GWM_SERDC "
					cQuery += "AND GWE.GWE_NRDC = GWM.GWM_NRDC "
					cQuery += "AND GWE.D_E_L_E_T_ = ' ' "
					cQuery += "GROUP BY GWE.GWE_FILDT, GWE.GWE_NRDT, GWE.GWE_SERDT"

					cQuery := ChangeQuery(cQuery)
					cAliasQry := GetNextAlias()
					DbUseArea( .T. ,"TOPCONN",TcGenQry(,,cQuery),cAliasQry, .F. , .T. )

					If (cAliasQry)->(EoF())
						aRet[1] := .T.
						aRet[2] := "Nï¿½o foram encontrados rateio contï¿½bil do documento de frete ou documentos de frete do TMS vinculados aos documentos de carga."
						aRet[3] := "3"
					Else
						nItem := 0


						If GW3->GW3_SITCUS == "4"
							u_UGFEA065CTP("EI")
						EndIf

						DT7->(DbSetOrder(1))
						DT7->(DbSeek(xFilial("DT7")+GW3->GW3_DESCUS))
						aForn := GFEA055GFL(GW3->GW3_EMISDF)

						While !(cAliasQry)->(EoF())
							nItem += 1
							nValor := (cAliasQry)->VLFRET - IIF(GW3->GW3_CRDICM == "1", (cAliasQry)->VLICMS, 0) - IIF(GW3->GW3_CRDPC == "1", (cAliasQry)->VLPIS + (cAliasQry)->VLCOFINS, 0)

							oModel := FWLoadModel("TMSA070")
							oModel:SetOperation( 3 )
							oModel:Activate()
							oModel:GetModel("MdFieldSDG"):SetValue("DG_DOC",    NextNumero("SDG",1,"DG_DOC", .T. ))
							oModel:GetModel("MdGridSDG"):SetValue("DG_ITEM",    StrZero(nItem, Len(SDG->DG_ITEM)))
							oModel:GetModel("MdGridSDG"):SetValue("DG_CODDES",  GW3->GW3_DESCUS)
							oModel:GetModel("MdGridSDG"):SetValue("DG_FILFRT",  (cAliasQry)->GWE_FILDT)
							oModel:GetModel("MdGridSDG"):SetValue("DG_DOCFRT",  (cAliasQry)->GWE_NRDT)
							oModel:GetModel("MdGridSDG"):SetValue("DG_SERFRT",  (cAliasQry)->GWE_SERDT)
							oModel:GetModel("MdGridSDG"):SetValue("DG_CODFOR",  aForn[1])
							oModel:GetModel("MdGridSDG"):SetValue("DG_LOJFOR",  aForn[2])

							oModel:GetModel("MdGridSDG"):SetValue("DG_TOTAL",   nValor)
							oModel:GetModel("MdGridSDG"):SetValue("DG_CUSTO1",  nValor)
							oModel:GetModel("MdGridSDG"):SetValue("DG_NUMPARC",  1)
							oModel:GetModel("MdGridSDG"):SetValue("DG_ORIGEM",  "GW3")
							oModel:GetModel("MdGridSDG"):SetValue("DG_HISTOR",  Substr(GW3->GW3_NRDF + " - " + GW3->GW3_SERDF + " - " + DToC(GW3->GW3_DTEMIS), 1, 40))
							oModel:GetModel("MdGridSDG"):SetValue("DG_VALCOB",  nValor)
							oModel:GetModel("MdGridSDG"):SetValue("DG_CLVL",    DT7->DT7_CLVL)
							oModel:GetModel("MdGridSDG"):SetValue("DG_ITEMCTA", DT7->DT7_ITEMCT)
							oModel:GetModel("MdGridSDG"):SetValue("DG_CONTA",   DT7->DT7_CONTA)
							oModel:GetModel("MdGridSDG"):SetValue("DG_CC",      DT7->DT7_CC)

							If oModel:VldData()
								oModel:CommitData()

								lMsgAviso := .T.
								aRet[1] := .T.
								aRet[2] := "Integraï¿½ï¿½o dos valores de custo de transporte com SIGATMS efetuada com sucesso."
								aRet[3] := "2"
								aRet[4] := dDatabase
								aRet[5] := cUserName
							Else

								u_UGFEA065CTP("EI")

								aRet[1] := .T.
								aRet[2] := oModel:GetErrorMessage( .F. )[6]
								aRet[3] := "3"
								aRet[4] := dDatabase
								aRet[5] := cUserName

								Exit
							EndIf

							RecLock("GWC", .T. )
							GWC->GWC_FILIAL := GW3->GW3_FILIAL
							GWC->GWC_CDESP := GW3->GW3_CDESP
							GWC->GWC_EMISDF := GW3->GW3_EMISDF
							GWC->GWC_SERDF := GW3->GW3_SERDF
							GWC->GWC_NRDF := GW3->GW3_NRDF
							GWC->GWC_DTEMIS := GW3->GW3_DTEMIS
							GWC->GWC_DOC := oModel:GetModel("MdFieldSDG"):GetValue("DG_DOC")
							GWC->GWC_CODDES := oModel:GetModel("MdGridSDG"):GetValue("DG_CODDES")
							GWC->GWC_ITEM := oModel:GetModel("MdGridSDG"):GetValue("DG_ITEM")
							MsUnlock("GWC")

							oModel:Deactivate()

							(cAliasQry)->(dbSkip())
						EndDo
					EndIf

					(cAliasQry)->(dbCloseArea())
				EndIf
			EndIf
		EndCase
	EndIf

	If aRet[1]
		RecLock("GW3", .F. )
		GW3->GW3_SITCUS := aRet[3]

		If !(cAcao == "P")
			GW3->GW3_DTCUS  := aRet[4]
			GW3->GW3_USUCUS := aRet[5]

			If lMsgAviso
				GW3->GW3_MOTCUS := ""
			Else
				GW3->GW3_MOTCUS := aRet[2]
			EndIf
		EndIf
		MsUnlock("GW3")
	EndIf

	If lExibeMsg
		If lMsgAviso
			Iif(FindFunction("APMsgInfo"), APMsgInfo(aRet[2],), MsgInfo(aRet[2],))
		Else
			Help( ,, "HELP",, aRet[2], 1, 0)
		EndIf
	EndIf

	RestArea(aAreaGW3)

Return aRet












User Function UGFEAGTP(cTpDF)

Return IIf (U_UGFEACTA(), SuperGetMv("MV_DESGFE" + AllTrim(cTpDF), .F. , ""), "")














Static Function IntegDef(cXml,nType,cTypeMsg)
	Local  aResult := {}
	aResult := GFEI065(cXml,nType,cTypeMsg)
Return aResult












Static Function UGFEA065PCD(cTpImp)
	local cRet

	GU3->( dbSetOrder(1) )
	GU3->(DBSeek(xFilial("GU3") + FwFldGet("GW3_EMISDF")))

	If cTpImp == "PIS"
		IF GU3->GU3_TPTRIB == "2" .AND.  SuperGetMv("MV_INTTMS", .F. , .F. ) == .T.  .AND.  SuperGetMv("MV_PISDIF", .F. ,0) <> 0
			cRet := SuperGetMv("MV_PISDIF", .F. ,0)
		ELSE
			cRet := SuperGetMv("MV_PCPIS", .F. ,1.65)
		ENDIF
	ELSE
		IF GU3->GU3_TPTRIB == "2" .AND.  SuperGetMv("MV_INTTMS", .F. , .F. ) == .T.  .AND.  SuperGetMv("MV_COFIDIF", .F. ,0) <> 0
			cRet := SuperGetMv("MV_COFIDIF", .F. ,0)
		ELSE
			cRet := SuperGetMv("MV_PCCOFI", .F. ,7.6)
		ENDIF
	ENDIF

Return cRet

User Function GFEUPDCalc()
	Local cQuery    := ""
	Local cUltDoc   := ""
	Local cAlias    := GetNextAlias()
	Local cVLCNPJ :=  SuperGetMV("MV_VLCNPJ",,"1")

	dbSelectArea("GW0")
	GW0->(dbSetOrder(1))







	If SuperGetMV("MV_DPSERV", .F. , "1") == "1"
		cQuery := " SELECT DISTINCT GWF.R_E_C_N_O_ RECNOGWF, GWF_NRCALC, GWF_TRANSP, GW4_TPDC, GW4_EMISDC, GW4_SERDC, GW4_NRDC,  "
		cQuery += "   GU3A.GU3_IDFED AS GU3A_IDFED, GU3B.GU3_IDFED AS GU3B_IDFED, GW3.GW3_CDESP, GW3.GW3_EMISDF, GW3.GW3_SERDF, GW3.GW3_NRDF, GW3.GW3_DTEMIS "
		cQuery += "   FROM "+RetSqlName("GW4")+" GW4 "
		cQuery += "  INNER JOIN "+RetSqlName("GW3")+" GW3 ON "
		cQuery += "        GW4.GW4_FILIAL = GW3.GW3_FILIAL "
		cQuery += "    AND GW4.GW4_EMISDF = GW3.GW3_EMISDF "
		cQuery += "    AND GW4.GW4_CDESP  = GW3.GW3_CDESP  "
		cQuery += "    AND GW4.GW4_SERDF  = GW3.GW3_SERDF  "
		cQuery += "    AND GW4.GW4_NRDF   = GW3.GW3_NRDF   "
		cQuery += "    AND GW4.GW4_DTEMIS = GW3.GW3_DTEMIS "
		cQuery += "  INNER JOIN "+RetSqlName("GU3")+" GU3A ON (GU3A.GU3_FILIAL = '" + xFilial("GU3") + "' AND GU3A.GU3_CDEMIT = GW3.GW3_EMISDF AND GU3A.D_E_L_E_T_ = ' ') "
		cQuery += "  INNER JOIN "+RetSqlName("GWH")+" GWH"
		cQuery += "     ON GWH.GWH_FILIAL = GW4.GW4_FILIAL"
		cQuery += "    AND GWH.GWH_CDTPDC = GW4.GW4_TPDC"
		cQuery += "    AND GWH.GWH_EMISDC = GW4.GW4_EMISDC"
		cQuery += "    AND GWH.GWH_SERDC  = GW4.GW4_SERDC"
		cQuery += "    AND GWH.GWH_NRDC   = GW4.GW4_NRDC"
		cQuery += "    AND GWH.D_E_L_E_T_ = ' '"
		cQuery += "  INNER JOIN "+RetSqlName("GWF")+" GWF "
		cQuery += "     ON GWF.GWF_FILIAL = GWH_FILIAL "
		cQuery += "    AND GWF.GWF_NRCALC = GWH_NRCALC "
		cQuery += "    AND GWF.GWF_TPCALC = GW3.GW3_TPDF "
		cQuery += "    AND GWF.GWF_CDESP  = '"+Space(TamSX3("GWF_CDESP")[1])+"'"
		cQuery += "    AND GWF.GWF_EMISDF = '"+Space(TamSX3("GWF_EMISDF")[1])+"'"
		cQuery += "    AND GWF.GWF_SERDF  = '"+Space(TamSX3("GWF_SERDF")[1])+"'"
		cQuery += "    AND GWF.GWF_NRDF   = '"+Space(TamSX3("GWF_NRDF")[1])+"'"
		cQuery += "    AND GWF.GWF_DTEMDF = '"+Space(TamSX3("GWF_DTEMDF")[1])+"'"
		If cVLCNPJ == "1"
			cQuery += " AND GWF.GWF_TRANSP = GW3.GW3_EMISDF "
		EndIf
		cQuery += "    AND GWF.D_E_L_E_T_ = ' '"
		cQuery += "  INNER JOIN "+RetSqlName("GU3")+" GU3B ON (GU3B.GU3_FILIAL = '" + xFilial("GU3") + "' AND GU3B.GU3_CDEMIT = GWF.GWF_TRANSP AND GU3B.D_E_L_E_T_ = ' ') "
		cQuery += "    WHERE GW4.D_E_L_E_T_ = ' '"
		cQuery += "	 AND GW3.GW3_SIT IN ('2','3','4') "
		cQuery += "	 AND GW3.D_E_L_E_T_ = ' ' "
		cQuery += "    ORDER BY GW4_TPDC, GW4_EMISDC, GW4_SERDC, GW4_NRDC, GWF_NRCALC"
		cQuery := ChangeQuery(cQuery)
		GFEConout("INFO",cQuery)
		DbUseArea( .T. ,"TOPCONN",TcGenQry(,,cQuery),cAlias, .F. , .T. )

		cUltDoc := ""
		While (cAlias)->(!EoF())
			If cUltDoc <> (cAlias)->(GW4_TPDC+GW4_EMISDC+GW4_SERDC+GW4_NRDC)
				If cVLCNPJ == "1" .Or.  SubStr((cAlias)->GU3A_IDFED, 1, 8) == SubStr((cAlias)->GU3B_IDFED, 1, 8)
					cUltDoc := (cAlias)->(GW4_TPDC+GW4_EMISDC+GW4_SERDC+GW4_NRDC)
					GWF->(dbGoTo((cAlias)->RECNOGWF))
					RecLock("GWF", .F. )
					GWF->GWF_CDESP := (cAlias)->GW3_CDESP
					GWF->GWF_EMISDF:= (cAlias)->GW3_EMISDF
					GWF->GWF_SERDF := (cAlias)->GW3_SERDF
					GWF->GWF_NRDF  := (cAlias)->GW3_NRDF
					GWF->GWF_DTEMDF:= SToD((cAlias)->GW3_DTEMIS)
					GFEConout("INFO","[RUP_GFE] - Doc. Frete " + (cAlias)->GW3_CDESP  + (cAlias)->GW3_EMISDF + (cAlias)->GW3_EMISDF + (cAlias)->GW3_SERDF + (cAlias)->GW3_NRDF + (cAlias)->GW3_DTEMIS + " relacionado ao calculo " + GWF->GWF_NRCALC)
					MsUnlock("GWF")
				EndIf
			EndIF
			(cAlias)->(dbSkip())
		EndDo
		(cAlias)->(dbCloseArea())
	ElseIf SuperGetMV("MV_DPSERV", .F. , "1") == "2"

		GWF->(dbGoTop())
		While GWF->(!EoF())
			RecLock("GWF", .F. )
			GWF->GWF_CDESP := ""
			GWF->GWF_EMISDF:= ""
			GWF->GWF_SERDF := ""
			GWF->GWF_NRDF  := ""
			GWF->GWF_DTEMDF:= STOD("")
			MsUnlock("GWF")
			GWF->(dbSkip())
		EndDo

	EndIf

	IF !GW0->( dbSeek(Space(Len(xFilial("GW0"))) + PadR("GWF", TamSX3("GW0_TABELA")[1]) + PadR("MV_DPSERV", TamSX3("GW0_CHAVE")[1])) )
		RecLock("GW0", .T. )
		GW0->GW0_TABELA := "GWF"
		GW0->GW0_CHAVE  := "MV_DPSERV"
		GW0->GW0_CHAR01 := GetComputerName()
		GW0->GW0_DATA01 := Date()
		GW0->( MSUnlock() )
	EndIf

Return .T.
