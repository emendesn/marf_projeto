#Include "Protheus.ch"
#Include "fwbrowse.ch"
#Include "fwmvcdef.ch"

/*/{Protheus.doc} MGFCOM96
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MGFCOM96()


	Local bPassou := .F.
	local xfil := SPACE(06)
	local scde  := SPACE(06)
	local scate := SPACE(06)
	local Itde  := SPACE(04)
	local Itate := SPACE(04)


	oDLG2 = MsDialog():New( 000, 000, 200, 395, "Filtro para Solicitações",,,.F.,, 0, 16777215,,,.T.,, ,.F. )



	TSay():New( 008, 002,{||  "SC       :"},oDLG2,,,.F.,.F.,.F.,.T., 0, 16777215, 028, 009,.F.,.F.,.F.,.F.,.F.,.F. )
	TGet():New( 007, 030, { | u | If( PCount() == 0, SCDE, SCDE := u ) },oDLG2, 50, 010, "@!",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"SCDE",,,, )




	TSay():New( 028, 002,{||  "Item de  :"},oDLG2,,,.F.,.F.,.F.,.T., 0, 16777215, 028, 009,.F.,.F.,.F.,.F.,.F.,.F. )
	TGet():New( 027, 030, { | u | If( PCount() == 0, itde, itde := u ) },oDLG2, 50, 010,,, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"itde",,,, )

	TSay():New( 048, 002,{||  "Item ate :"},oDLG2,,,.F.,.F.,.F.,.T., 0, 16777215, 028, 009,.F.,.F.,.F.,.F.,.F.,.F. )
	TGet():New( 047, 030, { | u | If( PCount() == 0, itATE, itATE := u ) },oDLG2, 50, 010,,, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"itATE",,,, )




	oBtn := TButton():New( 088, 145 ,"Confirma"    , oDlg2,{|| bPassou := .T. , oDLG2:End() }  ,50, 011,,, .F. , .T. , .F. ,, .F. ,,, .F.  )

	oDLG2:Activate( oDLG2:bLClicked, oDLG2:bMoved, oDLG2:bPainted,.T.,,,, oDLG2:bRClicked, )

	if bPassou

		MsAguarde({|| cancsc(scde,scate,itde,itate)},"Cancelamento de Solicitação de compras, aguarde...")
	endif

Return()

Static Function cancsc(scde,scate,itde,itate)

	Local cQuery  := " "
	Local cNumsol := " "
	Local cItem   := " "


	cQuery := " SELECT C1_FILIAL,C1_NUM,C1_ITEM "
	cQuery += "	FROM " + RetSqlName("SC1") + " SC1"

	cQuery += "	WHERE SC1.D_E_L_E_T_<>'*' AND C1_NUM ='"+SCDE+"' "
	cQuery += "	AND C1_ITEM >='"+ITDE+"' AND C1_ITEM <= '"+ITATE+"' AND C1_FILIAL='"+xFilial("SC1")+"' "
	cQuery += "	AND C1_QUANT > C1_QUJE "
	cQuery += "	ORDER BY C1_FILIAL,C1_NUM "
	If Select("TEMP1") > 0
		TEMP1->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea( .T. ,"TOPCONN",TcGenQry(,,cQuery),"TEMP1", .T. , .F. )
	dbSelectArea("TEMP1")
	TEMP1->(dbGoTop())


	While TEMP1->(!Eof())


		cNumsol := TEMP1->C1_NUM

		dbSelectArea("SC1")
		dbSetOrder(1)
		dbSeek(xFilial("SC1")+TEMP1->C1_NUM+TEMP1->C1_ITEM)

		RecLock("SC1", .F. )
		SC1->C1_ZCANCEL := "S"
		SC1->C1_ZUSRCAN := UsrFullName(RETCODUSR())
		SC1->C1_RESIDUO := "S"
		SC1->(MsUnLock())

		dbSelectArea("TEMP1")

		TEMP1->(dbSKIP())
		

	EndDo
Return
