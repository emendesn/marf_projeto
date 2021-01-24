#Include "Protheus.ch"
#Include "totvs.ch"
#Include "rwmake.ch"

/*/{Protheus.doc} MGFALTPLQ
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}
@param cAlias, characters, descricao
@param nReg, numeric, descricao
@param nOpc, numeric, descricao
@type function
/*/
User Function MGFALTPLQ(cAlias,nReg,nOpc)

	Local nRet  := 0
	Local lAltr := .F.
	Local cPrograma := ""
	Local cBaseAltEx  := ""
	Local cItemAltEx  := ""
	Local nNumpl := SPACE(15)
	Local cQuery := ""
	Local nTotReg
	Local oDlg
	Local cChapa := SN1->N1_CHAPA
	Local aAlias := getnextalias()
	Local cAcesso := IIF(substr(cUsuario,64,1) == "N" .OR.  substr(cUsuario,65,1) == "N", .F. , .T. )


	If cAcesso
		oDlg = MsDialog():New( 200, 0, 362, 500, "Alteração de numero de plaqueta",,,.F.,,,,,,.T.,, ,.F. )

		TSay():New( 010, 010,{||  "Cod Base"},oDlg,,,.F.,.F.,.F.,.T.,,,,,.F.,.F.,.F.,.F.,.F.,.F. )
		TGroup():New( 008, 055, 19, 220,, oDlg,,,.T., )
		TSay():New( 010, 060,{||  SN1->N1_CBASE},oDlg,,,.F.,.F.,.F.,.T.,,,,,.F.,.F.,.F.,.F.,.F.,.F. )
		TSay():New( 024, 010,{||  "Item"},oDlg,,,.F.,.F.,.F.,.T.,,,,,.F.,.F.,.F.,.F.,.F.,.F. )
		TGroup():New( 022, 055, 33, 220,, oDlg,,,.T., )
		TSay():New( 024, 060,{||  SN1->N1_ITEM},oDlg,,,.F.,.F.,.F.,.T.,,,,,.F.,.F.,.F.,.F.,.F.,.F. )
		TSay():New( 038, 010,{||  "Descrição"},oDlg,,,.F.,.F.,.F.,.T.,,,,,.F.,.F.,.F.,.F.,.F.,.F. )
		TGroup():New( 036, 055, 47, 220,, oDlg,,,.T., )
		TSay():New( 038, 060,{||  SN1->N1_DESCRIC},oDlg,,,.F.,.F.,.F.,.T.,,,,,.F.,.F.,.F.,.F.,.F.,.F. )
		TSay():New( 052, 010,{||  "Plaqueta atual"},oDlg,,,.F.,.F.,.F.,.T.,,,,,.F.,.F.,.F.,.F.,.F.,.F. )
		TGroup():New( 050, 055, 61, 220,, oDlg,,,.T., )
		TSay():New( 052, 060,{||  SN1->N1_CHAPA},oDlg,,,.F.,.F.,.F.,.T.,,,,,.F.,.F.,.F.,.F.,.F.,.F. )
		TSay():New( 066, 010,{||  "Nova Plaqueta"},oDlg,,,.F.,.F.,.F.,.T.,,,,,.F.,.F.,.F.,.F.,.F.,.F. )
		TGet():New( 066, 060, { | u | If( PCount() == 0, nNumpl, nNumpl := u ) },oDlg, 55, 11,,,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"nNumpl",,,,.T. )

		PIXEL := SButton():New( 066, 150,1,{||  (oDlg:End())}, oDlg,.T.,,)

		oDlg:Activate( oDlg:bLClicked, oDlg:bMoved, oDlg:bPainted,.T.,,,, oDlg:bRClicked, )






		If nOpc == 19
			nOpc := 4
			lAltDesc := .T.
		EndIf

		cPrograma    := "ATFA012"
		oModel       := FWLoadModel( cPrograma )

		oModel:SetOperation( nOpc )
		oModel:Activate( .T. )

		If !Empty( nOpc )
			lAltr := ( nOpc == 4 )
		EndIf
		IF Empty(nNumpl)
			Alert("Nova Plaqueta não preenchida, será mantida a chapa atual")
			nNumpl := SN1->N1_CHAPA
		else


			cQuery := "SELECT COUNT(N1_CBASE) AS REG FROM " +Retsqlname("SN1")+ " where N1_FILIAL = '"+ xFilial("SN1") + "' AND N1_CHAPA = '" + alltrim(nNumpl) + "'"
			cQuery      := ChangeQuery(cQuery)
			dbUseArea( .T. ,"TOPCONN",TcGenQry(,,cQuery),aAlias, .F. , .T. )
			nTotReg := (aAlias)->REG

			If MV_PAR02 = 2 .AND.  nTotReg > 0
				Alert("A Plaqueta informada já existe para essa filial")

			else

				If SN1->N1_STATUS $ "2|3"
					Help(" ",1,"AF010BLOQ")
				Else
					SN1->(RecLock("SN1"))
					SN1->N1_CHAPA	:= nNumpl
					MsUnlock()
				EndIf
			Endif
		Endif
	Else
		Alert("Usuário sem acesso a alteração de de itens do ativo")
	Endif
	Return()
	

	IIF(substr(cUsuario,64,1) == "N" .OR.  substr(cUsuario,65,1) == "N", .F. , .T. )
