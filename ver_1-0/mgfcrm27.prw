#Include "totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "FwBrowse.ch"
#Include "FwMvcDef.ch"
#Include "ParmType.ch"
#Include "FwMBrowse.ch"

//
//
//
//
//
/*/{Protheus.doc} MGFCRM27
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MGFCRM27()
	local oBrowse


	oBrowse := FWMBrowse():New()

	oBrowse:SetAlias("ZBI")

	oBrowse:SetDescription("Cadastro de Roteiro")

	oBrowse:Activate()

return nil


static function MenuDef()
	local aRotina := {}

	Aadd( aRotina, { "Pesquisar", "PesqBrw", 0, 1, 0,,, })
	Aadd( aRotina, { "Visualizar", "VIEWDEF.MGFCRM27", 0, 2, 0,,, })
	Aadd( aRotina, { "Incluir", "VIEWDEF.MGFCRM27", 0, 3, 0,,, })
	Aadd( aRotina, { "Alterar", "VIEWDEF.MGFCRM27", 0, 4, 0,,, })
	Aadd( aRotina, { "Excluir", "VIEWDEF.MGFCRM27", 0, 5, 0,,, })

return aRotina


Static Function ModelDef()

	Local oStruZBI := FWFormStruct( 1, "ZBI", , )
	Local oModel


	oModel := MPFormModel():New("CRM27MDL", , {| oModel | CRM27POS( oModel ) }, {| oModel | CRM27Commit( oModel ) }, )

	oStruZBI:setProperty("ZBI_DESCRI", 7, { |oMdl, cField, xValue, xOldValue| chkDescri(oMdl, cField, xValue, xOldValue) } )



	oModel:AddFields( "ZBIMASTER", , oStruZBI, , , )


	oModel:SetDescription( "Cadastro de Roteiro" )


	oModel:GetModel( "ZBIMASTER" ):SetDescription( "Dados de Roteiro" )

	oModel:SetPrimaryKey({})

Return oModel


Static Function ViewDef()

	Local oModel   := FWLoadModel( "MGFCRM27" )

	Local oStruZBI := FWFormStruct( 2, "ZBI" )
	Local oView


	oView := FWFormView():New()


	oView:SetModel( oModel )


	oView:AddField( "VIEW_ZBI", oStruZBI, "ZBIMASTER" )


	oView:CreateHorizontalBox( "TELA" , 100 )


	oView:SetOwnerView( "VIEW_ZBI", "TELA" )
Return oView



static function CRM27POS( oModel )
	local lRet		:= .T.
	local oModel	:= FWModelActive()
	local oModelZBI	:= oModel:GetModel("ZBIMASTER")
	local nOper		:= oModel:getOperation()
	local cQryZBI	:= ""
	local cQryZBJ	:= ""

	if nOper == 3 .OR.  nOper == 4
		cQryZBI := "SELECT *"																+ chr(13) + chr(10)
		cQryZBI += " FROM " + retSQLName("ZBI") + " ZBI"									+ chr(13) + chr(10)
		cQryZBI += " WHERE"																	+ chr(13) + chr(10)
		cQryZBI += "		ZBI.ZBI_REPRES	=	'" + oModelZBI:getValue("ZBI_REPRES") + "'"	+ chr(13) + chr(10)
		cQryZBI += "	AND"	+ chr(13) + chr(10)

		cQryZBI += "		("	+ chr(13) + chr(10)
		cQryZBI += "		ZBI.ZBI_CODIGO	<>	'" + oModelZBI:getValue("ZBI_CODIGO") + "'"	+ chr(13) + chr(10)
		cQryZBI += "	OR	ZBI.ZBI_SUPERV	<>	'" + oModelZBI:getValue("ZBI_SUPERV") + "'"	+ chr(13) + chr(10)
		cQryZBI += "	OR	ZBI.ZBI_REGION	<>	'" + oModelZBI:getValue("ZBI_REGION") + "'"	+ chr(13) + chr(10)
		cQryZBI += "	OR	ZBI.ZBI_TATICA	<>	'" + oModelZBI:getValue("ZBI_TATICA") + "'"	+ chr(13) + chr(10)
		cQryZBI += "	OR	ZBI.ZBI_NACION	<>	'" + oModelZBI:getValue("ZBI_NACION") + "'"	+ chr(13) + chr(10)
		cQryZBI += "	OR	ZBI.ZBI_DIRETO	<>	'" + oModelZBI:getValue("ZBI_DIRETO") + "'"	+ chr(13) + chr(10)
		cQryZBI += "		)"	+ chr(13) + chr(10)

		cQryZBI += "	AND	ZBI.ZBI_FILIAL	=	'" + xFilial("ZBI") + "'"					+ chr(13) + chr(10)
		cQryZBI += "	AND	ZBI.D_E_L_E_T_	<>	'*'"										+ chr(13) + chr(10)

		dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQryZBI), "QRYZBI" , .F. , .T. )

		if !QRYZBI->(EOF())
			Help( ,, "MGFCRM27",, "Este vendedor jï¿½ ï¿½ representante de outro Roteiro."+chr(13) + chr(10)+"Roteiro: " + allTrim(QRYZBI->ZBI_CODIGO) + " - " + allTrim(QRYZBI->ZBI_DESCRI), 1, 0 )
			lRet := .F.
		endif

		QRYZBI->(DBCloseArea())
	endif

	if nOper == 5
		cQryZBJ := "SELECT *"																+ chr(13) + chr(10)
		cQryZBJ += " FROM " + retSQLName("ZBJ") + " ZBJ"									+ chr(13) + chr(10)
		cQryZBJ += " WHERE"																	+ chr(13) + chr(10)

		cQryZBJ += " 		ZBJ.ZBJ_ROTEIR	=	'" + oModelZBI:getValue("ZBI_CODIGO")	+ "'"	+ chr(13) + chr(10)
		cQryZBJ += " 	AND	ZBJ.ZBJ_SUPERV	=	'" + oModelZBI:getValue("ZBI_SUPERV")	+ "'"	+ chr(13) + chr(10)
		cQryZBJ += " 	AND ZBJ.ZBJ_REGION	=	'" + oModelZBI:getValue("ZBI_REGION")	+ "'"	+ chr(13) + chr(10)
		cQryZBJ += " 	AND ZBJ.ZBJ_TATICA	=	'" + oModelZBI:getValue("ZBI_TATICA")	+ "'"	+ chr(13) + chr(10)
		cQryZBJ += " 	AND ZBJ.ZBJ_NACION	=	'" + oModelZBI:getValue("ZBI_NACION")	+ "'"	+ chr(13) + chr(10)
		cQryZBJ += " 	AND ZBJ.ZBJ_DIRETO	=	'" + oModelZBI:getValue("ZBI_DIRETO")	+ "'"	+ chr(13) + chr(10)

		cQryZBJ += "	AND	ZBJ.ZBJ_FILIAL	=	'" + xFilial("ZBJ") + "'"					+ chr(13) + chr(10)
		cQryZBJ += "	AND	ZBJ.D_E_L_E_T_	<>	'*'"										+ chr(13) + chr(10)

		dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQryZBJ), "QRYZBJ" , .F. , .T. )

		if !QRYZBJ->(EOF())
			Help( ,, "MGFCRM27_1",, "Este Roteiro jï¿½ estï¿½ em uso pela Estrutura de Cliente.", 1, 0 )
			lRet := .F.
		endif

		QRYZBJ->(DBCloseArea())
	Endif

return lRet



Static Function CRM27Commit( oModel )
	local lRet		:= .T.

	local oModelZBI	:= oModel:GetModel("ZBIMASTER")
	local nOper		:= oModel:getOperation()
	local cQr := ""
	Local cAliasTrb := GetNextAlias()
	local nBkpZBI	:= ZBI->(RECNO())
	local cQryZBJ	:= ""
	local aArea		:= getArea()
	local aAreaZBJ	:= ZBJ->(getArea())
	local aAreaSA1	:= SA1->(getArea())
	local cUpdTbl		:= ""

	DBSelectArea("ZBJ")
	DBSelectArea("SA1")

	Begin Sequence; BeginTran()

	If oModel:VldData()
		if nOper <> MODEL_OPERATION_DELETE
			oModel:setValue('ZBIMASTER' , 'ZBI_INTSFO' , 'P' )

			//-------------------------------------------------------------------------------
			// Atualiza clientes amarrados ao nivel atualizado
			//-------------------------------------------------------------------------------
			U_MGFUPZBJ( oModel:getValue('ZBIMASTER' , 'ZBI_DIRETO' ) + oModel:getValue('ZBIMASTER' , 'ZBI_NACION' ) + oModel:getValue('ZBIMASTER' , 'ZBI_TATICA' ) + oModel:getValue('ZBIMASTER' , 'ZBI_REGION' ) + oModel:getValue('ZBIMASTER' , 'ZBI_SUPERV' ) + oModel:getValue('ZBIMASTER' , 'ZBI_CODIGO' ) , 6 )
		else
			recLock( "ZBI" , .F. )
				ZBI->ZBI_INTSFO := 'P'
			ZBI->( msUnlock() )

			//-------------------------------------------------------------------------------
			// Atualiza clientes amarrados ao nivel atualizado
			//-------------------------------------------------------------------------------
			U_MGFUPZBJ( ZBI->ZBI_DIRETO + ZBI->ZBI_NACION + ZBI->ZBI_TATICA + ZBI->ZBI_REGION + ZBI->ZBI_SUPERV + ZBI->ZBI_CODIGO , 6 )
		endif

		cUpdTbl	:= ""

		cUpdTbl := "UPDATE " + retSQLName("SA3")												+ CRLF
		cUpdTbl += "	SET"																	+ CRLF
		cUpdTbl += " 		A3_XINTSFO = 'P'"													+ CRLF
		cUpdTbl += " WHERE"																		+ CRLF
		cUpdTbl += " 		A3_COD = '" + oModel:getValue('ZBIMASTER' , 'ZBI_REPRES' ) + "'"	+ CRLF

		if tcSQLExec( cUpdTbl ) < 0
			conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
		endif

		If nOper == 4
			If ZBI->ZBI_REPRES <> oModelZBI:getValue("ZBI_REPRES")
				cQryZBJ := "SELECT ZBJ.R_E_C_N_O_ ZBJRECNO, ZBJ_REPRES, ZBJ_CLIENT, ZBJ_LOJA"		+ chr(13) + chr(10)
				cQryZBJ += " FROM " + retSQLName("ZBJ") + " ZBJ"									+ chr(13) + chr(10)
				cQryZBJ += " WHERE"																	+ chr(13) + chr(10)
				cQryZBJ += "		ZBJ.ZBJ_REPRES	=	'" + ZBI->ZBI_REPRES	+ "'"				+ chr(13) + chr(10)
				cQryZBJ += "	AND	ZBJ.ZBJ_FILIAL	=	'" + xFilial("ZBJ")		+ "'"				+ chr(13) + chr(10)
				cQryZBJ += "	AND	ZBJ.D_E_L_E_T_	<>	'*'"										+ chr(13) + chr(10)

				dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQryZBJ), "QRYZBJ" , .F. , .T. )

				while !QRYZBJ->(EOF())
					ZBJ->(DBGoTo( QRYZBJ->ZBJRECNO ))

					recLock("ZBJ", .F. )
					ZBJ->ZBJ_REPRES := oModelZBI:getValue("ZBI_REPRES")
					ZBJ->(msUnlock())

					QRYZBJ->(DBSkip())
				enddo

				QRYZBJ->(DBCloseArea())




				cQrySA1 := "SELECT SA1.R_E_C_N_O_ SA1RECNO, ZBJ_REPRES, ZBJ_CLIENT, ZBJ_LOJA"		+ chr(13) + chr(10)
				cQrySA1 += " FROM "			+ retSQLName("ZBJ") + " ZBJ"							+ chr(13) + chr(10)

				cQrySA1 += " INNER JOIN "	+ retSQLName("SA1") + " SA1"							+ chr(13) + chr(10)
				cQrySA1 += " ON"																	+ chr(13) + chr(10)
				cQrySA1 += " 		ZBJ.ZBJ_CLIENT	=	SA1.A1_COD"									+ chr(13) + chr(10)
				cQrySA1 += " 	AND ZBJ.ZBJ_LOJA	=	SA1.A1_LOJA"								+ chr(13) + chr(10)

				cQrySA1 += " WHERE"																	+ chr(13) + chr(10)
				cQrySA1 += "		ZBJ.ZBJ_REPRES	=	'" + oModelZBI:getValue("ZBI_REPRES")	+ "'"				+ chr(13) + chr(10)
				cQrySA1 += "	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1") + "'"					+ chr(13) + chr(10)
				cQrySA1 += "	AND	ZBJ.ZBJ_FILIAL	=	'" + xFilial("ZBJ") + "'"					+ chr(13) + chr(10)
				cQrySA1 += "	AND	SA1.D_E_L_E_T_	<>	'*'"										+ chr(13) + chr(10)
				cQrySA1 += "	AND	ZBJ.D_E_L_E_T_	<>	'*'"										+ chr(13) + chr(10)

				dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQrySA1), "QRYSA1" , .F. , .T. )

				while !QRYSA1->(EOF())
					SA1->(DBGoTo( QRYSA1->SA1RECNO ))

					recLock("SA1", .F. )

					SA1->A1_VEND	:= oModelZBI:getValue("ZBI_REPRES")
					SA1->A1_XINTEGX	:= "P" // STATUS PARA O CLIENTE SER ENVIADO AO SFA
					SA1->A1_XINTECO	:= "0" // STATUS PARA O CLIENTE SER ENVIADO AO E-COMMERCE

					if SA1->A1_PESSOA == "J"
						SA1->A1_XINTSFO	:= "P" // STATUS PARA O CLIENTE SER ENVIADO AO SALESFORCE
					endif

					SA1->(msUnlock())

					QRYSA1->(DBSkip())
				enddo

				QRYSA1->(DBCloseArea())

				FwFormCommit(oModel)
				oModel:DeActivate()
			else
				FwFormCommit(oModel)
				oModel:DeActivate()
			Endif
		else
			FwFormCommit(oModel)
			oModel:DeActivate()
		Endif
	Else
		JurShowErro( oModel:GetModel():GetErrormessage() )
		lRet := .F.
		DisarmTransaction()
	EndIf

	EndTran(); end

	restArea(aAreaSA1)
	restArea(aAreaZBJ)
	restArea(aArea)

return(lRet)




static function chkDescri(oMdl, cField, xValue, xOldValue)
	local lRet := .T.

	if allTrim(cField) == "ZBI_DESCRI"
		if "/" $ xValue
			Help( ,, "MGFCRM27",, "Nï¿½o ï¿½ permitida o carecter / (barra) neste campo.", 1, 0 )
			lRet := .F.
		endif
	endif

return lRet
