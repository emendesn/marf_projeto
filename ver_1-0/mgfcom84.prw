#Include 'Protheus.ch'
#Include 'Rwmake.ch'

/*
=====================================================================================
Programa............: MGFCOM84
Autor...............: Tarcisio Galeano
Data................: 04/2018
Descrição / Objetivo: 
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/     

/// Função que apresenta a descrição do produto na solicitação de compras
User Function MGFCOM84() 

Local 	cDescri  := Space(500)
Local	Odlg
Local cQuery  := ""
Local cAlias                                  
Local aRet     := {}
Local lMark    := .F.                                    
Private lOk,lCancel

cAlias	:= GetNextAlias()

//cQuery := "SELECT  ZD5_CONTRA,ZD5_FILENT,ZD5_FORNEC "
cQuery := "SELECT  ZD5_FILENT "
cQuery += "  FROM " + RetSqlName("ZD5") +" ZD5 "
cQuery += " WHERE ZD5_CONTRA='"+SC3->C3_NUM+"' "
cQuery += " AND ZD5.D_E_L_E_T_<>'*' "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias, .F., .T.)

While !(cAlias)->(eof())
               
	//AADD (aRet, {(cAlias)->ZD5_CONTRA, (cAlias)->ZD5_FILENT ,(cAlias)->ZD5_FORNEC})
	 AADD(aret , {.F. , (cAlias)->ZD5_FILENT})

		
	(cAlias)->(DBSKIP())
Enddo

ListBoxMar(aRet)       
	
Return         

Static Function ListBoxMar(aVetor)

Local cVar     := Nil
Local oDlg     := Nil
Local cTitulo  := "Consulta Filiais do contrato"
Local oOk      := LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Local oNo      := LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
Local oChk     := Nil
Local lMarca   := .T. 
Local cNrom	   := ""
Local nLinha	:= 0  
Local nTotLinha	:= 0 
	Local oOK		:= LoadBitmap(GetResources(),"LBOK")
	Local oNO		:= LoadBitmap(GetResources(),"LBNO")
	Local nX		:= 0
	Local nLen		:= 0
	Local aBrowse	:= {}
	Local cMvPar01	:= AllTrim(SuperGetMv('MGF_DIRGER' , NIL , ""))
	Local cMvPar02	:= AllTrim(SuperGetMv('MGF_DIRENV' , NIL , ""))
	Local aDir01	:= {}
	Local aDir02	:= {}
	Local aSelected	:= {}
	Local lContinua	:= .F.
	Local cNomePar01:= 'MGF_DIRGER'
	Local cNomePar02:= 'MGF_DIRENV'
	Local oBtn01	:= NIL
	Local oBtn02	:= NIL
	Local cBcos		:= Upper(AllTrim(SuperGetMv('MGF_FILBCO' , NIL , "")))

                
Private cCadastro := "Consulta Filiais do contrato"
Private lChk   := .F.
Private oLbx   := Nil

aVetor1 := aVetor 

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
If Len( aVetor1 ) == 0
   Aviso( cTitulo, "Nao ha filial amarrada", {"Ok"} )
Else


//DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL
//dBselectArea("ZD5")   
//@ 10,10 LISTBOX oLbx VAR cVar FIELDS HEADER "Contrato", "Filial", "Fornecedor" SIZE 230,095 OF oDlg PIXEL ON dblClick(ZD5->(dBgoto(aVetor1[oLbx:nAt,6])),aXvisual("ZD5",aVetor1[oLbx:nAt,6],2))
//
//oLbx:SetArray( aVetor1 )
//oLbx:bLine := {|| {aVetor1[oLbx:nAt,1],;
//                   aVetor1[oLbx:nAt,2],;
//                   aVetor1[oLbx:nAt,3]}}
//DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
//ACTIVATE MSDIALOG oDlg CENTER

			DEFINE DIALOG oDlg TITLE "Consulta filiais do contrato" FROM 180,180 TO 550,700 PIXEL

				oBrowse := TWBrowse():New( 01 , 01, 260,164,,{'','F I L I A I S'},{20,30,30},;
				oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
				oBrowse:SetArray(aVetor1)
				oBrowse:bLine := {||{If(aVetor1[oBrowse:nAt,01],oOK,oNO),aVetor1[oBrowse:nAt,02] } }
				// Troca a imagem no duplo click do mouse
				oBrowse:bLDblClick := {|| aVetor1[oBrowse:nAt][1] := !aVetor1[oBrowse:nAt][1],;
				oBrowse:DrawSelect()}
				oBtn01	:= TButton():New( 170,150,'Excluir filiais', oDlg,{|| lContinua := .T. , oDlg:End() }  ,60, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
				oBtn02	:= TButton():New( 170,004,'Cancela', oDlg,{|| lContinua := .F. , oDlg:end() }  ,60, 011,,,.F.,.T.,.F.,,.F.,,,.F. )

			ACTIVATE DIALOG oDlg CENTERED

			If ( lContinua )
				For nX := 1 TO Len(aVetor1)
					//Grava em 'aSelected' somente os arquivos selecionados.
					If (aVetor1[nX , 1])
						AADD(aSelected , aVetor1[nX , 2])
					EndIf
				Next nX

				lContinua	:= ( Len(aSelected) > 0 )

				If ( lContinua )
					nLen	:= Len(aSelected)
					For nX := 1 TO nLen
			          	DbSelectArea("ZD5") 
   	      				ZD5->(dbSetOrder(1))   
          				ZD5->(dBGotop())
          				IF DbSeek(xFilial("ZD5")+SC3->C3_NUM+aSelected[nX]+SC3->C3_FORNECE+SC3->C3_LOJA)
                   			RecLock("ZD5",.F.)
			                	dbdelete()
			                MsUnLock() 
            		       	//IF EMPTY(SC3->C3_FILENT)
                   			//	RecLock("SC3",.F.)
                   		 	//SC3->C3_FILENT := aFilsAtu[I][2]
                   			//MsUnLock()     
                   			//ENDIF
          				ENDIF
						//msgalert("filial"+aSelected[nX]) //MGFINT18.PRW
					Next nX
				EndIf
			EndIf

                                                   
Endif                                       

Return



/*	DEFINE DIALOG oDlg TITLE "Amarração de filiais" FROM 180,180 TO 450,1000 PIXEL 

	@ 25,58 GET oDesc var cDescri memo SIZE 300,80 OF oDlg PIXEL
	@ 26,08 SAY "Descrição:" SIZE  260,80 OF oDlg PIXEL                                                                                                                  
	oTButton := TButton():New( 120, 270, "&OK",oDlg	,{|| lOk:= .T., oDlg:End() },40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	
	ACTIVATE DIALOG oDlg CENTERED
*/

//Return                                                                   


