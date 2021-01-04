
// copiado da funcao padrao F3XX8FIL, para funcionar sem o TRB e sem unidade de negocio
User Function _F3XX8FIL

Local aArea	:= GetArea()
Local aCpos     := {}       //Array com os dados
Local lRet      := .T.		//Array do retorno da opcao selecionada
Local oDlgF3                  //Objeto Janela
Local oLbx                  //Objeto List box
Local cTitulo   := "Filiais"	//"Filiais"
Local cNoCpos   := ""   
Local cDescr    := "Filiais"	//"Filiais"
Local aRet		:= {}
	    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Procurar campo no SX3³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("XX8")
XX8->(dbSetOrder(1))
XX8->(dbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega o vetor com os campos da tabela selecionada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

While !XX8->(Eof())
   
   	If XX8_TIPO == "3"
		//If (AllTrim(XX8->XX8_EMPR) == If(TYPE("TMPFIL->FRX_EMPDES")=="U","",TMPFIL->FRX_EMPDES)  .or. AllTrim(XX8->XX8_EMPR) == If(TYPE("TMPRAT->FRY_EMPDES")=="U","",TMPRAT->FRY_EMPDES) .or. AllTrim(XX8->XX8_EMPR) ==  If(TYPE("TMPRAT->FRZ_EMPDES")=="U","",TMPRAT->FRZ_EMPDES))
		If AllTrim(XX8->XX8_EMPR) == cRetXX8
			//If (AllTrim(XX8->XX8_UNID) == If(TYPE("TMPFIL->FRX_UNDDES")=="U","",TMPFIL->FRX_UNDDES)  .or. AllTrim(XX8->XX8_UNID) == If(TYPE("TMPRAT->FRY_UNDDES")=="U","",TMPRAT->FRY_UNDDES) .or. AllTrim(XX8->XX8_UNID) ==  If(TYPE("TMPRAT->FRZ_UNDDES")=="U","",TMPRAT->FRZ_UNDDES))
				aAdd( aCpos, { XX8->XX8_EMPR, XX8->XX8_UNID, XX8->XX8_CODIGO, XX8->XX8_DESCRI } )
			//EndIf
		EndIf
	EndIf
   
	XX8->(DbSkip())
   
Enddo

If Len( aCpos ) > 0

	DEFINE MSDIALOG oDlgF3 TITLE cTitulo FROM 0,0 TO 240,500 PIXEL
	
	   @ 10,10 LISTBOX oLbx FIELDS HEADER "Empresas","Unidades","Filiais","Descrição"  SIZE 230,95 OF oDlgF3 PIXEL //"Empresas"###"Unidades"###"Filiais"###"Descrição" 
	
	   oLbx:SetArray( aCpos )
	   oLbx:bLine     := {|| {aCpos[oLbx:nAt,1], aCpos[oLbx:nAt,2], aCpos[oLbx:nAt,3], aCpos[oLbx:nAt,4]}}
	   oLbx:bLDblClick := {|| {oDlgF3:End(), aRet := {oLbx:aArray[oLbx:nAt,1],oLbx:aArray[oLbx:nAt,2],oLbx:aArray[oLbx:nAt,3],oLbx:aArray[oLbx:nAt,4]}}} 	                   

	DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (oDlgF3:End(), aRet := {oLbx:aArray[oLbx:nAt,1],oLbx:aArray[oLbx:nAt,2],oLbx:aArray[oLbx:nAt,3],oLbx:aArray[oLbx:nAt,4]})  ENABLE OF oDlgF3
	ACTIVATE MSDIALOG oDlgF3 CENTER
	
EndIf	             

cRetxx8Fil := AllTrim(iIF(Len(aRet) > 0, cRetxx8+aRet[3],""))
	
If Empty(cRetxx8Fil)
	lRet := .F.
EndIf

RestArea(aArea)
Return lRet
