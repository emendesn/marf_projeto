#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "MSGRAPHI.CH" 
#INCLUDE "COLORS.CH"

#DEFINE CRLF ( chr(13) + chr(10) )
/*/   {Protheus.doc} MGFFINX9

Descri��o : Fun��o para efetuar compensa��o do contas a receber
	a. MGFFINX9 : Tela dever� mostrar duas grids
       : Primeira com t�tulos principais 
	   : Segunda com t�tulos disponiveis de serem compensados a partir do t�tulo selecionado na 1� Grid. 

@author Henrique Vidal
@since 06/08/2020
@return Null
/*/

User Function MGFFINX9()

	Local aSizeAut    := MsAdvSize(,.F.,400)
	Local oBtn
	Local oBtn1
	Local oBold
	Local nCol      := 0
	Private dEmisDe	:= ctod('  /  /    ')
	Private dEmisAt	:= ctod('  /  /    ')
	Private cClide	:= Space(TamSx3("A1_COD")[1])
	Private cCliAt	:= Space(TamSx3("A1_COD")[1] + TamSx3("A1_LOJA")[1])
	Private cLjde	:= Space(TamSx3("A1_LOJA")[1])
	Private cLjAt	:= Space(TamSx3("A1_LOJA")[1])
	Private cFilde	:= Space(TamSx3("A1_FILIAL")[1])
	Private cFilat	:= Space(TamSx3("A1_FILIAL")[1])
	Private cGrpCli	:= Space(TamSx3("A1_ZREDE")[1])

	Private oDlcsv     	:= Nil               
	Private aBrowse    	:= {} 
	Private aBrwCmp    	:= {} 
	Private oBrowPrc	// Browser 1 - T�tulos principais 
	Private oBrwCmp		// Browser 2 - T�tulos a serem compensados 
	Private aObjects
	Private aInfo
	Private aPosObj
	Private bSair      := .F.   
	Private nColOrder  := 1
	Private nTipoOrder := 1  
	Private oOK        := LoadBitmap(GetResources(),'LBOK')
	Private oNO        := LoadBitmap(GetResources(),'LBNO')
	Private oTotal
	Private nTotal     := 0 
	Private nTitPrc	   := 0 
	
	#DEFINE cCSSButton	"QPushButton { color: #808080; "+;
	"    border-image: url(rpo:fwstd_btn_nml.png) 3 3 3 3 stretch; "+;
	"    border-top-width: 3px; "+;
	"    border-left-width: 3px; "+;
	"    border-right-width: 3px; "+;
	"    border-bottom-width: 3px }"+;
	"QPushButton:pressed {	color: #808080; "+;
	"    border-image: url(rpo:fwstd_btn_prd.png) 3 3 3 3 stretch; "+;
	"    border-top-width: 3px; "+;
	"    border-left-width: 3px; "+;
	"    border-right-width: 3px; "+;
	"    border-bottom-width: 3px }"

	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	
	aObjects := {}
	AAdd( aObjects, { 100, 30, .T., .F. } )
	AAdd( aObjects, { 100, 35, .T., .T. } )
	AAdd( aObjects, { 100, 35, .T., .T. } )
	aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )

	DEFINE MSDIALOG oDlcsv FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE "COMPENSA��O CONTAS � RECEBER"  PIXEL

		@ aPosObj[2][1] - 8 , 004 SAY "T�tulo Principal..: "       SIZE 369, 011 OF oDlcsv FONT oBold COLOR CLR_RED   PIXEL 
		oBrowPrc := TWBrowse():New( aPosObj[2][1] ,4, aPosObj[2,4]-aPosObj[2,2] , aPosObj[2][3] - aPosObj[1][3] - 20 ,;
								  ,,,oDlcsv, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
		oBrowPrc:SetArray(aBrowse)                                    
		oBrowPrc:bLine := {|| aEval(aBrowse[oBrowPrc:nAt],{|z,w| aBrowse[oBrowPrc:nAt,w] } ) }
	    oBrowPrc:bLDblClick  := {|| aBrowse[oBrowPrc:nAt][1] := IIF(aBrowse[oBrowPrc:nAt][1]==oOK,oNO,oOK) , MarcaUm(oBrowPrc:nAt) , IIF(aBrowse[oBrowPrc:nAt][1]==oOK,LoadTCmp(),"") }

		oBrowPrc:bHeaderClick:= {|oBrwG1,nCol| OrdenaCab(nCol,.T., aBrowse , 1)}

		oBrowPrc:addColumn(TCColumn():new('',{||aBrowse[oBrowPrc:nAt][1]},"@!"             ,,,"LEFT"    ,1,.T.,.F.,,,,,))   
		oBrowPrc:addColumn(TCColumn():new('Filial'			,{||aBrowse[oBrowPrc:nAt][2]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowPrc:addColumn(TCColumn():new('Prefixo'			,{||aBrowse[oBrowPrc:nAt][3]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowPrc:addColumn(TCColumn():new('Numero'			,{||aBrowse[oBrowPrc:nAt][4]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowPrc:addColumn(TCColumn():new('Parcela'			,{||aBrowse[oBrowPrc:nAt][5]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowPrc:addColumn(TCColumn():new('Tipo'			,{||aBrowse[oBrowPrc:nAt][6]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowPrc:addColumn(TCColumn():new('Cliente'			,{||aBrowse[oBrowPrc:nAt][7]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowPrc:addColumn(TCColumn():new('Loja'			,{||aBrowse[oBrowPrc:nAt][8]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowPrc:addColumn(TCColumn():new('Raz�o Social'			,{||aBrowse[oBrowPrc:nAt][15]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowPrc:addColumn(TCColumn():new('Valor'			,{||aBrowse[oBrowPrc:nAt][9]}	,"@e 9,999,999,999,999.99"�,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowPrc:addColumn(TCColumn():new('Saldo do T�tulo' ,{||aBrowse[oBrowPrc:nAt][10]}	,"@e 9,999,999,999,999.99"�,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowPrc:addColumn(TCColumn():new('Emiss�o'			,{||aBrowse[oBrowPrc:nAt][11]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowPrc:addColumn(TCColumn():new('Vencimento'		,{||aBrowse[oBrowPrc:nAt][12]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowPrc:addColumn(TCColumn():new('Recno'			,{||aBrowse[oBrowPrc:nAt][13]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowPrc:addColumn(TCColumn():new('Hist�rico'		,{||aBrowse[oBrowPrc:nAt][14]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowPrc:Setfocus() 

		@ aPosObj[3][1] - 8 , 004 SAY "� Compensar..: "       SIZE 369, 009 OF oDlcsv FONT oBold COLOR CLR_RED   PIXEL //CLR_BLUE
		 oBrwCmp:= TWBrowse():New( aPosObj[3][1],4,aPosObj[2,4]-aPosObj[2,2],aPosObj[3][3] - aPosObj[2][3],;
								  ,,,oDlcsv, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
		 oBrwCmp:SetArray( aBrwCmp)                                    
		 oBrwCmp:bLine := {|| aEval( aBrwCmp[ oBrwCmp:nAt],{|z,w|  aBrwCmp[ oBrwCmp:nAt,w] } ) }
		 oBrwCmp:bLDblClick  := {|| ValGrid2() }
		 oBrwCmp:bHeaderClick:=  {|oBrwG2,nCol| OrdenaCab(nCol,.T. , aBrwCmp, 2)}
		 
		oBrwCmp:addColumn(TCColumn():new(''					,{||aBrwCmp[oBrwCmp:nAt][1]}	,"@!"     ,,,"LEFT"    ,1,.T.,.F.,,,,,))   
		oBrwCmp:addColumn(TCColumn():new('Filial'			,{||aBrwCmp[oBrwCmp:nAt][2]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrwCmp:addColumn(TCColumn():new('Prefixo'			,{||aBrwCmp[oBrwCmp:nAt][3]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrwCmp:addColumn(TCColumn():new('Numero'			,{||aBrwCmp[oBrwCmp:nAt][4]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrwCmp:addColumn(TCColumn():new('Parcela'			,{||aBrwCmp[oBrwCmp:nAt][5]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrwCmp:addColumn(TCColumn():new('Tipo'				,{||aBrwCmp[oBrwCmp:nAt][6]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrwCmp:addColumn(TCColumn():new('Cliente'			,{||aBrwCmp[oBrwCmp:nAt][7]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrwCmp:addColumn(TCColumn():new('Loja'				,{||aBrwCmp[oBrwCmp:nAt][8]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrwCmp:addColumn(TCColumn():new('Raz�o Social'			,{||aBrwCmp[oBrwCmp:nAt][15]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrwCmp:addColumn(TCColumn():new('Saldo do T�tulo'	,{||aBrwCmp[oBrwCmp:nAt][9]}	,"@e 9,999,999,999,999.99"�,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrwCmp:addColumn(TCColumn():new('Valor � compensar',{||aBrwCmp[oBrwCmp:nAt][10]}	,"@e 9,999,999,999,999.99"�,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrwCmp:addColumn(TCColumn():new('Emiss�o'			,{||aBrwCmp[oBrwCmp:nAt][11]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrwCmp:addColumn(TCColumn():new('Vencimento'		,{||aBrwCmp[oBrwCmp:nAt][12]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrwCmp:addColumn(TCColumn():new('Recno'			,{||aBrwCmp[oBrwCmp:nAt][13]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrwCmp:addColumn(TCColumn():new('Hist�rico'		,{||aBrwCmp[oBrwCmp:nAt][14]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrwCmp:Setfocus() 

		DEFINE FONT oBold NAME "Arial" SIZE 0, -14 BOLD
			
		@ 004 , aPosObj[1][2]		SAY "FILTROS : "       	SIZE 369, 009 OF oDlcsv FONT oBold COLOR CLR_RED   PIXEL //CLR_BLUE
		@ 019 , aPosObj[1][2] 	   	SAY "Cliente de : "     SIZE 369, 009 OF oDlcsv FONT oBold   PIXEL //CLR_BLUE
		@ 019 , aPosObj[1][2] + 50 	MSGET cCliDe 			SIZE 50, 09 OF oDlcsv  PIXEL F3 "SA1" //VALID ExistCpo("SA1",cClide) .or. Empty(cClide)
		
		@ 019 , aPosObj[1][2] + 110 SAY "Loja de : "    	SIZE 369, 009 OF oDlcsv FONT oBold   PIXEL //CLR_BLUE
		@ 019 , aPosObj[1][2] + 146 MSGET cLjde 			SIZE 20, 09 OF oDlcsv  PIXEL

		@ 035 , aPosObj[1][2] 		SAY "Cliente at� : "    SIZE 369, 009 OF oDlcsv FONT oBold   PIXEL  //CLR_BLUE
		@ 035 , aPosObj[1][2] + 50 	MSGET cCliAt 			SIZE 50, 09 OF oDlcsv  PIXEL F3 "SA1" VALID ExistCpo("SA1",cClide) .or. Empty(cClide)

		@ 035 , aPosObj[1][2] + 110 SAY "Loja at� : "    	SIZE 369, 009 OF oDlcsv FONT oBold   PIXEL //CLR_BLUE
		@ 035 , aPosObj[1][2] + 146 MSGET cLjAt 			SIZE 20, 09 OF oDlcsv  PIXEL 
			
		@ 019 , aPosObj[1][2] + 185 SAY "Emiss�o de : "     SIZE 369, 009 OF oDlcsv FONT oBold   PIXEL //CLR_BLUE
		@ 019 , aPosObj[1][2] + 235 MSGET dEmisDe 			SIZE 50,09  OF oDlcsv PIXEL

		@ 035 , aPosObj[1][2] + 185 SAY "Emiss�o at� : "    SIZE 369, 009 OF oDlcsv FONT oBold   PIXEL //CLR_BLUE
		@ 035 , aPosObj[1][2] + 235 MSGET dEmisAt 			SIZE 50,09  OF oDlcsv PIXEL 
		
		@ 019 , aPosObj[1][2] + 300 SAY "Filial de : "      SIZE 369, 009 OF oDlcsv FONT oBold    PIXEL //CLR_BLUE
		@ 019 , aPosObj[1][2] + 340 MSGET cFilde 			SIZE 50,09  OF oDlcsv PIXEL F3 "SM0" 

		@ 035 , aPosObj[1][2] + 300 SAY "Filial at� : "     SIZE 369, 009 OF oDlcsv FONT oBold  PIXEL //CLR_BLUE
		@ 035 , aPosObj[1][2] + 340 MSGET cFilat 			SIZE 50,09 OF oDlcsv PIXEL F3 "SM0" 

		@ 019 , aPosObj[1][2] + 400 SAY "Grupo/Cliente: "   SIZE 369, 009 OF oDlcsv FONT oBold   PIXEL //CLR_BLUE
		@ 019 , aPosObj[1][2] + 455 MSGET cGrpCli 		 	SIZE 50,09 OF oDlcsv PIXEL F3 "SZQ" VALID ExistCpo("SZQ",cGrpCli) .or. Empty(cGrpCli)

		@ 019, aPosObj[1][2] + 510 SAY "Saldo dispon�vel :"		 SIZE 369, 009 OF oDlcsv FONT oBold  PIXEL
		@ 019, aPosObj[1][2] + 590 MSGET nTitPrc  SIZE 50, 09 OF oDlcsv WHEN .F. PICTURE "@E 99,999,999.99"   PIXEL

		@ 035, aPosObj[1][2] + 510 SAY "Total Selecionado :" SIZE 369, 009 OF oDlcsv FONT oBold   PIXEL
		@ 035, aPosObj[1][2] + 590 MSGET oTotal  VAR nTotal  SIZE 50, 09 OF oDlcsv WHEN .F. PICTURE "@E 99,999,999.99"   PIXEL
		/*
		oBtn1 := TButton():New( 019	, aPosObj[1][4] - 250,'Processar'	, oDlcsv,{|| MGFFINXZ() , MarcaUm(,.T.) , LoadTPrc() }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		oBtn1:SetCss(cCSSButton)
		oBtn := TButton():New( 033 	, aPosObj[1][4] - 250,'Cancelar'	, oDlcsv,{|| RollbackSX8(),oDlcsv:End()}  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		oBtn := TButton():New( 019	, aPosObj[1][4] - 300,'Pesquisar'	, oDlcsv,{|| MarcaUm(,.T.) ,  LoadTPrc()  }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )   
		*/
		
		oBtn1 := TButton():New( 019	, aPosObj[1][4] - 050,'Processar'	, oDlcsv,{|| MGFFINXZ() , MarcaUm(,.T.) , LoadTPrc() }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		oBtn1:SetCss(cCSSButton)	
		oBtn := TButton():New( 033 	, aPosObj[1][4] - 050,'Cancelar'	, oDlcsv,{|| RollbackSX8(),oDlcsv:End()}  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		oBtn := TButton():New( 019	, aPosObj[1][4] - 300,'Pesquisar'	, oDlcsv,{|| MarcaUm(,.T.) ,  LoadTPrc()  }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )   
		oBtn2 := TButton():New( 245	, aPosObj[1][4] - 050,'Marcar/(Des) Todos'	, oDlcsv,{|| MarcaAll()  }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )   	
		oBtn2:SetCss(cCSSButton)
	ACTIVATE MSDIALOG oDlcsv CENTERED
	
Return 

/*/   {Protheus.doc} LoadTPrc : Carrega os t�tulos principais dispon�veis na primeira Grid.
		a. Filtra conforme par�metros
		b. S� permite sele��o de um t�tulo principal por vez
		c. Atualiza ap�s processamento, ou clique do bot�o pesquisar
@author Henrique Vidal
@since 06/08/2020
/*/	

Static Function LoadTPrc()

	Local lContinua	:= .T.
	Local aDados	:= {}
	Local cQryPrc	:= ""

	If Empty(cClide) .and. Empty(cCliAt) .and. Empty(dEmisDe) .and. Empty(dEmisAt) .and. Empty(cGrpCli)
		MsgAlert("Informe o cliente, grupo de cliente, filtro de emiss�o, ou combina��o de filtros para continuar.")
		Return
	EndIf 

	cQryPrc := " SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_VALOR, E1_SALDO, E1_EMISSAO, E1_VENCTO, E1_HIST, SE1.R_E_C_N_O_ RECSE1 , E1_NOMCLI" + CRLF
	cQryPrc += " FROM " + RetSqlName("SE1") + " SE1 " 					+ CRLF
	cQryPrc += " WHERE SE1.D_E_L_E_T_ = ' ' "							+ CRLF
	cQryPrc += " AND SE1.E1_SITUACA NOT IN ('I','J') "					+ CRLF
	cQryPrc += " AND SE1.E1_TIPO NOT IN ('AB-','CF-','CS-','FU-','I2-','IN-','IR-','IS-','PI-','FC-','FE-') " + CRLF
	cQryPrc += " AND SE1.E1_SALDO > 0 "									+ CRLF
	cQryPrc += " AND SE1.E1_EMISSAO <= '" + dToS(dDatabase)+ "' " 		+ CRLF

	If !Empty(cFilde)
		cQryPrc += " AND SE1.E1_FILIAL  >= '" + cFilde + "' " 			+ CRLF
	EndIf

	If !Empty(cFilAt)
		cQryPrc += " AND SE1.E1_FILIAL  <= '" + cFilAt + "' " 			+ CRLF
	EndIf

	If !Empty(cClide) 
		cQryPrc += " AND SE1.E1_CLIENTE >= '" + cClide + "' " 			+ CRLF
	EndIf

	If !Empty(cCliAt)
		cQryPrc += " AND SE1.E1_CLIENTE <= '" + cCliAt + "' " 			+ CRLF
	EndIf

	If !Empty(dEmisDe) 
		cQryPrc += " AND SE1.E1_EMISSAO >= '" + dtoS(dEmisDe) + "' " 	+ CRLF
	EndIf

	If !Empty(dEmisAt)
		cQryPrc += " AND SE1.E1_EMISSAO <= '" + dToS(dEmisAt) + "' " 	+ CRLF
	EndIf

	If !Empty(cGrpCli)
		cQryPrc += " AND SE1.E1_CLIENTE <= '" + cGrpCli + "' " 			+ CRLF
		cQryPrc += " AND EXISTS ( SELECT * FROM " +  RetSqlName("SA1") + " SA1 " + " WHERE A1_FILIAL = '" + xFilial('SA1') +  "' AND A1_ZREDE ='" + cGrpCli + "' AND A1_COD = E1_CLIENTE AND SA1.D_E_L_E_T_ =' ' ) " + CRLF
	EndIf

	cQryPrc += " ORDER BY E1_FILIAL,E1_NUM,E1_PREFIXO,E1_PARCELA,E1_TIPO " + CRLF

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +'TITPRINC'+".TXT",cQryPrc)
	cQryPrc  := ChangeQuery(cQryPrc)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryPrc),"TITPRINC",.T.,.F.)
	dbSelectArea("TITPRINC")
	TITPRINC->(dbGoTop())

	If TITPRINC->(Eof())
		MsgInfo('N�o h� t�tulos para os par�metros informados.')
	EndIf 

	While TITPRINC->(!Eof())
		aAdd(aDados,{oNO, E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_VALOR, E1_SALDO,;
		Subst(E1_EMISSAO,7,2)+'/'+Subst(E1_EMISSAO,5,2)+'/'+Subst(E1_EMISSAO,1,4),; 
		Subst(E1_VENCTO,7,2)+'/'+Subst(E1_VENCTO,5,2)+'/'+Subst(E1_VENCTO,1,4),;
		RECSE1, E1_HIST , E1_NOMCLI})
		TITPRINC->(dbSkip())
	EndDo

	TITPRINC->(dbCloseArea())

	aBrowse := aDados

	oBrowPrc:SetArray(aBrowse)  

Return(lContinua)

/*/   {Protheus.doc} LoadTCmp : Carrega os t�tulos dispon�veis � serem compensados na segunda Grid.
		a. Filtra a partir do t�tulo selecionado na primeira Grig
		b. Descarta loja, considerando somente codigo do cliente seleciona na Grid 1.
@author Henrique Vidal
@since 06/08/2020
/*/	
Static Function LoadTCmp()

	Local lContinua	:= .T.
	Local aDados	:= {}

	cQryCMP := " SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_SALDO, E1_SALDO, E1_EMISSAO, E1_VENCTO, E1_HIST, SE1.R_E_C_N_O_ RECSE1 , E1_NOMCLI " + CRLF
	cQryCMP += " FROM " + RetSqlName("SE1") + " SE1 " 		+ CRLF
	cQryCMP += " LEFT JOIN " + RetSqlName("SA1") + " SA1 " + " ON (SE1.E1_LOJA = SA1.A1_LOJA) AND (SE1.E1_CLIENTE = SA1.A1_COD)  " 	+ CRLF
	cQryCMP += " WHERE SE1.D_E_L_E_T_ = ' ' AND SA1.D_E_L_E_T_ = ' '  "		+ CRLF

	cQryCMP += " AND SA1.A1_FILIAL  = '" + xFilial('SA1') +  "'"  	+ CRLF

	If !Empty(cFilde)
		cQryCMP += " AND SE1.E1_FILIAL  >= '" + cFilde + "' " 		+ CRLF
	EndIf

	If !Empty(cFilAt)
		cQryCMP += " AND SE1.E1_FILIAL  <= '" + cFilAt + "' " 		+ CRLF
	EndIf

	cQryCMP += " AND SE1.E1_CLIENTE = '" + aBrowse[oBrowPrc:nAt][7] + "' "  + CRLF
	//cQryCMP += " AND SE1.E1_LOJA 	= '" + aBrowse[oBrowPrc:nAt][8] + "' "  + CRLF

	cQryCMP += " AND  SE1.E1_SITUACA IN ('0','1','2','3','4','5','6','7','F','G','H','I','J','K','')  " 		+ CRLF
	cQryCMP += " AND SE1.E1_SITUACA NOT IN ('I','J') " 							+ CRLF
	cQryCMP += " AND SE1.E1_TIPO NOT IN ('AB-','CF-','CS-','FU-','I2-','IN-','IR-','IS-','PI-','FC-','FE-') " 	+ CRLF
	cQryCMP += " AND SE1.E1_SALDO > 0 " 										+ CRLF
	cQryCMP += " AND SE1.E1_EMISSAO <= '" + dToS(dDatabase)+ "' "	 			+ CRLF

	If aBrowse[oBrowPrc:nAt][6] $ 'RA /PR /NCC'
		cQryCMP += " AND SE1.E1_TIPO NOT IN ('NCC','RA ','PR ') " 				+ CRLF
	Else
		cQryCMP += " AND  ( SE1.E1_TIPO IN ('RA ') OR  SE1.E1_TIPO IN ('NCC')) "+ CRLF
	EndIf

	cQryCMP += " ORDER BY E1_FILIAL,E1_NUM,E1_PREFIXO,E1_PARCELA,E1_TIPO " 		+ CRLF
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +'TITCOMPS'+".TXT",cQryCMP)
	cQryCMP  := ChangeQuery(cQryCMP)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryCMP),"TITCOMPS",.T.,.F.)
	dbSelectArea("TITCOMPS")
	TITCOMPS->(dbGoTop())

	While TITCOMPS->(!Eof())
		aAdd(aDados,{oNO, E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_SALDO, 0,;
		Subst(E1_EMISSAO,7,2)+'/'+Subst(E1_EMISSAO,5,2)+'/'+Subst(E1_EMISSAO,1,4),; 
		Subst(E1_VENCTO,7,2)+'/'+Subst(E1_VENCTO,5,2)+'/'+Subst(E1_VENCTO,1,4),;
		RECSE1, E1_HIST , E1_NOMCLI})
		TITCOMPS->(dbSkip())
	EndDo

	TITCOMPS->(dbCloseArea())

	aBrwCmp := aDados

	oBrwCmp:SetArray(aBrwCmp)  
	oBrwCmp:Setfocus()
	oBrwCmp:Refresh()  

Return(lContinua)

/*/   {Protheus.doc} MGFFINXZ : Chamada para efetiva��o da compensa��o.
		a. Acionada a partir do bot�o processar
@author Henrique Vidal
@since 06/08/2020
/*/	
Static Function MGFFINXZ()
	If MsgYesNo("Confirma processamento da compensa��o ?")
		fwMsgRun(, {|oSay| COMPCR( oSay ) }, "Processando arquivo", "Aguarde. Processando arquivo..." )
	EndIF
Return

/*/   {Protheus.doc} OrdenaCab : Orderna as grids 1 e 2
		a. Recebe par�metro de qual Grid est� chamando
		b. Regras: Quando ordernado pelo campo filial , orderna Filial + T�tulos. 
		           Demais campos oderna��o simples. 
@author Henrique Vidal
@since 06/08/2020
/*/	
Static Function OrdenaCab(nCol,bMudaOrder,_aTemp, nGrid)
	Local aOrdena := {}       
	
	aOrdena := AClone(_aTemp)                                         
	If nTipoOrder == 1                              
		If bMudaOrder
				nTipoOrder := 2
		EndIf  

		If nCol == 2                                                           
			aOrdena := aSort(aOrdena,,,{|x,y| x[nCol] + x[4] < y[nCol] + y[4] })   
		Else   
			aOrdena := aSort(aOrdena,,,{|x,y| x[nCol] < y[nCol]})   
		EndIf              
	Else              
		If bMudaOrder
				nTipoOrder := 1
		EndIf                                                                                                
		
		If nCol == 2                                                           
			aOrdena := aSort(aOrdena,,,{|x,y| x[nCol] + x[4] > y[nCol] + y[4] })   
		Else   
			aOrdena := aSort(aOrdena,,,{|x,y| x[nCol] > y[nCol]})   
		EndIf                     
	EndIf     

	If nGrid == 1
		aBrowse    := aOrdena
		nColOrder  := nCol
		oBrowPrc:DrawSelect()
		oBrowPrc:Refresh()          
		oBrowPrc:SetFocus()
	Else
		aBrwCmp    := aOrdena 
		nColOrder  := nCol
		oBrwCmp:DrawSelect()
		oBrwCmp:Refresh()          
		oBrwCmp:SetFocus()
	EndIf 
Return

/*/   {Protheus.doc} MarcaUm : Utilizada para tratar as sele��es das Grids
		a. Grid 1 - Permite sele��o de um t�tulo por vez.
		b. Grid 2 - Permite sele��o de multiplos t�tulos a serem compensados com t�tulo principal.
		c. Atualiza Grids ap�s processamento inclusive, recompondo o saldo
@author Henrique Vidal
@since 06/08/2020
/*/	
Static Function MarcaUm(nAt_ , lzeraPrc)

Default lzeraPrc := .F.

	If lzeraPrc
		nTitPrc := 0
	EndIf
	
	nTotal 	:= 0

	For nI:= 1 TO LEN(aBrowse)
		If nAt_ <> nI
			aBrowse[nI][1] :=  oNO
		Else
			nTitPrc := Iif( aBrowse[nI][1] ==  oOk ,  aBrowse[nI][10] , 0 )
		EndIf 
	Next nI
	
	oBrowPrc:DrawSelect()
	oBrowPrc:Refresh()          
	oBrowPrc:SetFocus()

	aBrwCmp := {}
	oBrwCmp:SetArray(aBrwCmp)  
	oBrwCmp:Setfocus()
	oBrwCmp:Refresh()  
Return

/*/   {Protheus.doc} MarcaAll : Utilizada para tratar marcar / desmarcar todos os itens da grid 2
@author Henrique Vidal
@since 31/08/2020
/*/	
Static Function MarcaAll()

	Local nSumTits := 0  // Soma dos t�tulos selecionados na Grid 2

	For nI:= 1 TO LEN(aBrwCmp)
		If nTotal > 0
			aBrwCmp[nI][1] 	:=  oNO
			aBrwCmp[nI][10] := 0
		Else
			aBrwCmp[nI][1] 	:=  oOK
			aBrwCmp[nI][10] := aBrwCmp[nI][9]
			nSumTits += aBrwCmp[nI][10] 
		EndIf 
	Next nI

	If nTotal > 0
		nTitPrc := 0
		nTotal 	:= 0
	EndIf 

	If nSumTits > 0
		nTotal 	:= nSumTits
		nTitPrc := aBrowse[oBrowPrc:nAt][10]
	EndIf 
	
	oTotal:Refresh()

	oBrowPrc:DrawSelect()
	oBrowPrc:Refresh()          
	oBrowPrc:SetFocus()
	
	oBrwCmp:SetArray(aBrwCmp)  
	oBrwCmp:Setfocus()
	oBrwCmp:Refresh()  


Return

/*/   {Protheus.doc} ValGrid2 : Utilizada para tratar valore menores na grid2
		a. Permite edi��o do valor a ser compensado
		b. Quando digitado valor zerado, ou clicado no bot�o canacelar desmarca o t�tulo e atualiza saldo a ser compebsado.
@author Henrique Vidal
@since 06/08/2020
/*/
Static Function  ValGrid2() 

	Local oSay
	Local oGrp1
	Local oDlg2
	Local oBtn                                              
	Local bConfirma 	:= .F.
	Local nVRbk    		:= 0	// Valor remarcado
	Private nVSaldo     := aBrwCmp[oBrwCmp:nAt][9]
	Private nVBaixa     := aBrwCmp[oBrwCmp:nAt][10]

	If aBrwCmp[oBrwCmp:nAt][01] == oOK
		nVRbk     := aBrwCmp[oBrwCmp:nAt][10]
	EndIf

	oDlg2      := MSDialog():New( 092,232,488,581,"Entre com os Valores",,,.F.,,,,,,.T.,,,.T. )
	oGrp1      := TGroup():New( 005,005,188,168,"Valores da Baixa",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oSay := TSay():New( 033,020,{||"Saldo Atual"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,007)
	oSay := TSay():New( 049,020,{||"Valor � compensar"}      ,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,070,007)

	@ 033,076 MSGET nVSaldo       SIZE 060,008 OF oGrp1 WHEN .F. PICTURE '@E 99,999,999.99'  PIXEL 
	@ 049,076 MSGET nVBaixa       SIZE 060,008 OF oGrp1 PICTURE '@E 99,999,999.99'  PIXEL  VALID IIF( nVBaixa <= nVSaldo , .T. , Alert("Valor inv�lido, superior ao saldo!") .and. .F. )


	oBtn := TButton():New( 160, 034 ,'Cancela'  , oDlg2,{|| oDlg2:End()   }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )                                                                                            
	oBtn := TButton():New( 160, 089 ,'Confirma' , oDlg2,{|| bConfirma := .T., oDlg2:End()   }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )                                                                                            

	oDlg2:Activate(,,,.T.)
	IF bConfirma  .and. nVBaixa > 0
		IF nTotal == 0                          
			nTotal += nVBaixa - nVRbk 
		Else
			nTotal := nTotal  - nVRbk + nVBaixa 
		EndIF
		oTotal:Refresh()
		aBrwCmp[oBrwCmp:nAt][01] := oOK
		aBrwCmp[oBrwCmp:nAt][10] := nVBaixa 
		oBrwCmp:DrawSelect()
		oBrwCmp:Refresh()
	Else
		aBrwCmp[oBrwCmp:nAt][01] := oNO
		aBrwCmp[oBrwCmp:nAt][10] := 0
		nTotal := nTotal - nVRbk
		oTotal:Refresh()                  
		oBrwCmp:DrawSelect()
		oBrwCmp:Refresh()
	EndIF

Return

/*/   {Protheus.doc} COMPCR : Efetiva��o da compensa��o
		a. A Rotina Fina330 n�o possui execauto. Para tentar aproveitar processos padr�es evitando problemas em atualiza��es futuras, 
		   foi utilizado a rotina MaIntBxCR() para realizar a compensa��o. 
		   Essa rotina � utilizada em uma Api padr�o do financeiro, executa as mesmas valida��es, por�m n�o da o mesmo retorno 
		   quando executada. Retorna .T. e .F.
@author Henrique Vidal
@since 06/08/2020
/*/
Static Function COMPCR()

	Local lRetOK 	:= .T.
	Local aArea  	:= GetArea()
	Local nTaxaCM 	:= 0
	Local aTxMoeda	:= {}
	Local aDCRED	:= {}

	If nTitPrc <= 0 .Or. nTotal <= 0
		MsgAlert("Necess�rio selecionar t�tulos � serem compensados!")
		Return
	EndIf 

	If nTitPrc < nTotal 
		MsgAlert("Valor selecionado maior que o saldo dispon�vel. Corrija para seguir!")
		Return
	EndIf 

	dbSelectArea("SE1")
	dbSetOrder(2) 

	PERGUNTE("AFI340",.F.)
	lContabiliza  	:= MV_PAR11 == 1
	lAglutina   	:= MV_PAR08 == 1
	lDigita   		:= MV_PAR09 == 1
	nTaxaCM 		:= RecMoeda(dDataBase,"01")

	aAdd(aTxMoeda, {1, 1} )
	aAdd(aTxMoeda, {2, nTaxaCM} )

	SE1->(dbSetOrder(1))

	cFilAnt := aBrowse[oBrowPrc:nAt][2]

	aTitPrc := { aBrowse[oBrowPrc:nAt][13] }

	/* Fun��o MaIntBxCR: 
		1 - 2� Parametro: Passar sempre os t�tulos do tipo (Nf) , independente de qual Grid foi selecionado , conforme documenta��o Totvs. 
		2 - 4� Parametro: Passar sempre os t�tulos dos tipos compensa��o (RA / ncc / Pr) conforme documenta��o Totvs. 

		3 - A rotina MaIntBxCR est� com erro para conpensar v�rios t�tulos de vez. Montado la�o para compensar t�tulo a t�tulo, 
		   at� a corre��o da FNC #9577369. Ap�s corre��o logica pode ser mudada. At� essa data, n�o existe execauto para rotina.
	*/
	If aBrowse[oBrowPrc:nAt][6] $ ('NCC,RA ,PR ')  

		For _x := 1 to Len(aBrwCmp)
			IF aBrwCmp[_x][1] ==  oOK
				If !MaIntBxCR(3, {aBrwCmp[_x][13]} ,, aTitPrc,,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.}, , , , , aBrwCmp[_x][10])
					Help("XAFCMPAD",1,"HELP","Compensa��o Marfrig","N�o foi poss�vel a compensa��o"+CRLF+" do titulo do adiantamento",1,0)
					lRetOK := .F.
				EndIf
			EndIf
		Next _x 
	
	Else
	
		For _x := 1 to Len(aBrwCmp)
			IF aBrwCmp[_x][1] ==  oOK
				If !MaIntBxCR(3, aTitPrc ,, { aBrwCmp[_x][13] },,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.}, , , , , aBrwCmp[_x][10])
					Help("XAFCMPAD",1,"HELP","Compensa��o Marfrig","N�o foi poss�vel a compensa��o"+CRLF+" do titulo do adiantamento",1,0)
					lRetOK := .F.
				EndIf
			EndIf
		Next _x 
	
	EndIf
	
	If lRetOK //Aten��o: Desabilitar chamada quando a FNC9655365 for corrigida pela Totvs
		If !ExisteSx6("MGF_FX901")
        	CriarSX6("MGF_FX901", "L", "Habilita corre��o customizada do campo E5_LOJAADT pela rotina Mgffinx9.prw",'.F.' )
    	Endif

		If GetMv("MGF_FX901")
			CorrigeE5()
		EndIf 
	EndIf 
	
	If lRetOK
		Help("Totvs",1,"HELP","Compensa��o Marfrig","Compensa��o Marfrig "+CRLF+" realizada com sucesso.",1,0)
	EndIf
	
	SE1->(dbCloseArea())
	SE5->(dbCloseArea())

	RestArea(aArea)

Return lRetOK

/*/   {Protheus.doc} CorrigeE5 : Corre��o da loja do cliente de adto na SE5
		a. A Rotina MaIntBxCR() est� gravando campo E5_LOJAADT errado gerando erro no cancelamento da baixa. 
		   ATEN��O: Rotina dever� ser utilizada preventivamente, desabilitar chamada quando a FNC9655365  
		   for corrigida pela Totvs.
		b. Utilizado corre�� da E5 via Query, devido a E5 n�o conter chave unica, os indices possiveis de serem usados 
		   2 e (10 E5_DOCUMEN) - quando o mesmo t�tulo j� tinha ocorrido baixas, posicionava sem no primeiro. 
		   Por se tratar de uma fun��o para corre��o paliativa, optamos por n�o criar indice especifico.
@author Henrique Vidal
@since 08/08/2020
/*/
Static Function CorrigeE5()

Local _it
Local nRecE5
Local cQryE5 := ""

	For _it := 1 to Len(aBrwCmp)
		IF aBrwCmp[_it][1] ==  oOK
			dbSelectArea("SE1")
			dbGoto(aBrwCmp[_it][13])
			//cChvSE5 := cFilAnt+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_LOJA
			cChvSE5 := SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_LOJA
			
			cQryE5 := " SELECT SE5X.R_E_C_N_O_ RECSE5  "							+ CRLF
			cQryE5 += " FROM " + RetSqlName("SE5") + " SE5X " 						+ CRLF
			cQryE5 += " WHERE SE5X.D_E_L_E_T_ = ' '  "								+ CRLF

			cQryE5 += " AND SE5X.E5_FILIAL  = '" + cFilAnt +  "'"  				+ CRLF
			cQryE5 += " AND SE5X.E5_DOCUMEN = '" + cChvSE5 + "' "  				+ CRLF
			cQryE5 += " AND SE5X.E5_DATA = '" + dToS(dDatabase)+ "' "	 		+ CRLF
			cQryE5 += " AND SE5X.E5_ORIGEM = '" + Funname() + "' "		 		+ CRLF

			MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +'CORRECE5'+".TXT",cQryE5)
			cQryE5  := ChangeQuery(cQryE5)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryE5),"CORRECE5",.T.,.F.)
			dbSelectArea("CORRECE5")
			CORRECE5->(dbGoTop())

			While CORRECE5->(!Eof())
				nRecE5 := RECSE5

				dbSelectArea('SE5')
				dbGoto(nRecE5)
				If E5_ORIGEM == Funname()
					SE5->(RecLock("SE5",.F.))
						SE5->E5_LOJAADT := SE1->E1_LOJA
					SE5->(MsUnLock())
				EndIF
								
				CORRECE5->(dbSkip())
			EndDo

			CORRECE5->(dbCloseArea())
		EndIf

	Next _it 

Return 
