#Include "Protheus.ch"
#Include "FWMVCDEF.ch"
#Include "FWMBROWSE.ch"
#Include "TOPCONN.ch"

/*/{Protheus.doc} MGFCOM98
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MGFCOM98()


	Local bPassou := .F.
	local xfil := SPACE(06)
	local pcde  := SPACE(06)
	local pcate := SPACE(06)
	local Itde  := SPACE(04)
	local Itate := SPACE(04)


	oDLG2 = MsDialog():New( 000, 000, 200, 395, "Filtro para Pedidos",,,.F.,, 0, 16777215,,,.T.,, ,.F. )



	TSay():New( 008, 002,{||  "PC       :"},oDLG2,,,.F.,.F.,.F.,.T., 0, 16777215, 028, 009,.F.,.F.,.F.,.F.,.F.,.F. )
	TGet():New( 007, 030, { | u | If( PCount() == 0, PCDE, PCDE := u ) },oDLG2, 50, 010, "@!",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"PCDE",,,, )




	TSay():New( 028, 002,{||  "Item de  :"},oDLG2,,,.F.,.F.,.F.,.T., 0, 16777215, 028, 009,.F.,.F.,.F.,.F.,.F.,.F. )
	TGet():New( 027, 030, { | u | If( PCount() == 0, itde, itde := u ) },oDLG2, 50, 010,,, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"itde",,,, )

	TSay():New( 048, 002,{||  "Item ate :"},oDLG2,,,.F.,.F.,.F.,.T., 0, 16777215, 028, 009,.F.,.F.,.F.,.F.,.F.,.F. )
	TGet():New( 047, 030, { | u | If( PCount() == 0, itATE, itATE := u ) },oDLG2, 50, 010,,, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"itATE",,,, )




	oBtn := TButton():New( 088, 145 ,"Confirma"    , oDlg2,{|| bPassou := .T. , oDLG2:End() }  ,50, 011,,, .F. , .T. , .F. ,, .F. ,,, .F.  )

	oDLG2:Activate( oDLG2:bLClicked, oDLG2:bMoved, oDLG2:bPainted,.T.,,,, oDLG2:bRClicked, )

	if bPassou

		MsAguarde({|| cancpc(pcde,pcate,itde,itate)},"Cancelamento de Pedido de compras, aguarde...")
	endif

Return()

Static Function cancpc(pcde,pcate,itde,itate)

	Local cQueryp  := " "
	Local cNumpc   := " "
	Local cItemp   := " "
	LOCAL cQuery   := ""

	
	cQueryp := " SELECT C7_FILIAL,C7_NUM,C7_ITEM "
	cQueryp += "	FROM " + RetSqlName("SC7") + " SC7"

	cQueryp += "	WHERE SC7.D_E_L_E_T_<>'*' AND C7_NUM ='"+PCDE+"' "
	cQueryp += "	AND C7_ITEM >='"+ITDE+"' AND C7_ITEM <= '"+ITATE+"' AND C7_FILIAL='"+xFilial("SC7")+"' "
	cQueryp += "	AND C7_QUANT > C7_QUJE "
	cQueryp += "	ORDER BY C7_FILIAL,C7_NUM "
	If Select("TEMP1") > 0
		TEMP1->(dbCloseArea())
	EndIf
	cQueryp  := ChangeQuery(cQueryp)
	dbUseArea( .T. ,"TOPCONN",TcGenQry(,,cQueryp),"TEMP1", .T. , .F. )
	dbSelectArea("TEMP1")
	TEMP1->(dbGoTop())


	While TEMP1->(!Eof())


		dbSelectArea("SC7")
		dbSetOrder(1)
		dbSeek(xFilial("SC7")+TEMP1->C7_NUM+TEMP1->C7_ITEM)

		RecLock("SC7", .F. )
		SC7->C7_ZCANCEL := "S"
		SC7->C7_ZUSRCAN := UsrFullName(RETCODUSR())
//		SC7->C7_RESIDUO := "S" ALTERADO RAFAEL 07/11/2019 
		SC7->(MsUnLock())
	
		dbSelectArea("TEMP1")


		TEMP1->(dbSKIP())

	EndDo
	//ALTERADO RAFAEL 07/11/2019  - CHAMANDO ROTINA PADRÃO PARA ELIMINAÇÃO DE RESIDUO	
	MA235PC(100,1,stod("20100101"),stod("20491231"),PCDE,PCDE," " ,"ZZZZZZZZZZ" ," " ,"ZZZZZZ" ,stod("20100101"),stod("20491231"),ITDE,ITATE , )
Return
