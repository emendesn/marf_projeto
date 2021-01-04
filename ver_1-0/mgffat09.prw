#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"

/*
=====================================================================================
Programa............: MGFFAT09
Autor...............: Joni Lima       
Data................: 06/10/2016 
Descricao / Objetivo: Cadastro de Aprovadores vs Regra
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Tela de Aprovadores vs Regra
=====================================================================================
*/
User Function MGFFAT09()
	
	Local oMBrowse := nil
	
	oMBrowse:= FWmBrowse():New() 
	oMBrowse:SetAlias("SZU")
	oMBrowse:SetDescription('Aprovadores vs Regra')  
	oMBrowse:Activate()	
	
Return

/*
=====================================================================================
Programa............: MenuDef
Autor...............: Joni Lima       
Data................: 06/10/2016 
Descricao / Objetivo: MenuDef da rotina
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Definicao do Menu      
=====================================================================================
*/
Static Function MenuDef()    

	Local	aRotina	:= {}
	
	ADD OPTION aRotina TITLE "Pesquisar"  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0	
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MGFFAT09" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.MGFFAT09" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.MGFFAT09" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.MGFFAT09" OPERATION MODEL_OPERATION_DELETE ACCESS 0

Return(aRotina)

/*
=====================================================================================
Programa............: ModelDef
Autor...............: Joni Lima       
Data................: 06/10/2016 
Descricao / Objetivo: ModelDef
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Definicao do Modelo de Dados para cadastro de Aprovadores vs Regra      
=====================================================================================
*/
Static Function ModelDef()

	Local oModel	 := Nil
	Local oSTRSZS := FWFormStruct(1,"SZS")
	Local oSTRSZT := FWFormStruct(1,"SZT")
	Local oStrSZU := FWFormStruct(1,"SZU")
	Local bPos	  := {|oModel|V1alteste(oModel)}
	oModel := MPFormModel():New("XMGFFAT09", /*bPreValidacao*/,/*bPosValidacao*/,/*bCommit*/,/*bCancel*/ )
	
	If (IsInCallStack('U_xMF07Vinc') .or. IsInCallStack('U_xjMF07Vinc')) //Vinculo com Aprovadores 

		oSTRSZU:SetProperty('ZU_CODAPR',MODEL_FIELD_OBRIGAT,.F.)
		oModel:AddFields("CABMASTER",/*cOwner*/,oSTRSZS,/*bPreValidacao*/, bPos/*bPosValidacao*/, /*bCarga*/ )
		oModel:SetPrimaryKey({'ZS_FILIAL','ZS_CODIGO'})
	
	ElseIf (IsInCallStack('U_xMF08Vinc')) //Vinculo com Regras
		
		oSTRSZU:SetProperty('ZU_CODRGA',MODEL_FIELD_OBRIGAT,.F.)
		oModel:AddFields("CABMASTER",/*cOwner*/,oSTRSZT,/*bPreValidacao*/, bPos/*bPosValidacao*/, /*bCarga*/ )
		oModel:SetPrimaryKey({'ZT_FILIAL','ZT_CODIGO'})
	
	EndIf
	
	oModel:AddGrid("SZUDETAIL", "CABMASTER",oStrSZU,/*bPreValidacao*/, /*bPosValidacao*/,/*bCarga*/)
	
	If (IsInCallStack('U_xMF07Vinc') .or. IsInCallStack('U_xjMF07Vinc')) //Vinculo com Aprovadores 

		oModel:SetRelation("SZUDETAIL",{{"ZU_FILIAL","xFilial('SZU')"},{"ZU_CODAPR", "ZS_CODIGO"}},SZU->(IndexKey(2)))
		oModel:GetModel( 'SZUDETAIL' ):SetUniqueLine({ 'ZU_CODRGA' })
		oModel:SetDescription('Regra vs Aprovadores')
	
	Elseif (IsInCallStack('U_xMF08Vinc')) //Vinculo com Regras

		oModel:SetRelation("SZUDETAIL",{{"ZU_FILIAL","xFilial('SZU')"},{"ZU_CODRGA", "ZT_CODIGO"}},SZU->(IndexKey(1)))
		oModel:GetModel( 'SZUDETAIL' ):SetUniqueLine({ 'ZU_CODAPR' })
		oModel:SetDescription('Aprovador vs Regras')

	EndIf

	oModel:GetModel('CABMASTER'):SetOnlyView(.T.)	
	oModel:GetModel('CABMASTER'):SetOnlyQuery(.T.)
	  
	oModel:GetModel('SZUDETAIL'):SetOptional(.T.)
	
Return(oModel)

Static Function V1alteste(oModel)

return .T.

/*
=====================================================================================
Programa............: ViewDef
Autor...............: Joni Lima       
Data................: 06/10/2016 
Descricao / Objetivo: ViewDef
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Definicao da visualizacao da tela      
=====================================================================================
*/
Static Function Viewdef()

	Local oModel   	:= FWLoadModel( 'MGFFAT09' )
	Local oSTRSZS 	:= FWFormStruct(2,"SZS")
	Local oSTRSZT 	:= FWFormStruct(2,"SZT")
	Local oStrSZU 	:= FWFormStruct(2,"SZU")
	Local oView    	:= FWFormView():New()
	
	oView:SetModel( oModel )

	If (IsInCallStack('U_xMF07Vinc') .or. IsInCallStack('U_xjMF07Vinc') ) //Vinculo com Aprovadores 

		oStrSZU:RemoveField( 'ZU_CODAPR' )
		oStrSZU:RemoveField( 'ZU_NOMAPR' )

		oView:AddField('VIEW_CABMAST',oSTRSZS,'CABMASTER')

	Elseif (IsInCallStack('U_xMF08Vinc')) //Vinculo com Regras

		oStrSZU:RemoveField( 'ZU_CODRGA' )
		oStrSZU:RemoveField( 'ZU_DESRGA' )

		oView:AddField('VIEW_CABMAST',oSTRSZT,'CABMASTER')
			
	EndIf	

	oView:AddGrid('VIEW_DETSZU',oStrSZU,'SZUDETAIL' )
	
	oView:CreateHorizontalBox('SUPERIOR',20)
	oView:CreateHorizontalBox('INFERIOR',80)
	
	oView:SetOwnerView('VIEW_CABMAST','SUPERIOR')
	oView:SetOwnerView('VIEW_DETSZU','INFERIOR')
	oView:AddUserButton( 'Replica Filiais', '', { |oView| FAT09RepFilial() } )
	oView:AddUserButton( 'Visualiza Filiais', '', { |oView| FAT09VisFilial() } )
	
Return oView


Static Function FAT09RepFilial()

Local aArea := {SZU->(GetArea()),GetArea()}
Local aFil := {}
Local nCnt := 0
Local cQ := ""
Local cAliasTrb := GetNextAlias()

//ADMGETFIL(lTodasFil,lSohFilEmp,cAlias,lSohFilUn,lHlp, lExibTela)
aFil := ADMGETFIL()
//AdmSelecFil("",0,.F.,@aFil,"",.F.)
If !Empty(aFil)
	If APMsgYesNo("Deseja replicar a regra atual para todas as filiais marcadas ?")
		If (IsInCallStack('U_xMF07Vinc') .or. IsInCallStack('U_xjMF07Vinc')) //Vinculo com Aprovadores 
			cQ := "SELECT SZU.*,R_E_C_N_O_ SZU_RECNO "
			cQ += "FROM "+RetSqlName("SZU")+" SZU "
			cQ += "WHERE SZU.D_E_L_E_T_ = ' ' "
			cQ += "AND ZU_FILIAL = '"+xFilial("SZU")+"' "
			cQ += "AND ZU_CODAPR = '"+SZS->ZS_CODIGO+"' "
			cQ += "ORDER BY ZU_FILIAL,ZU_CODAPR,ZU_CODRGA "
						     
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)
			
			tcSetField(cAliasTrb,"ZU_DTINCLU","D",8,0)
						
			SZU->(dbSetOrder(2))
			While (cAliasTrb)->(!Eof())
				For nCnt:=1 To Len(aFil)
					If !aFil[nCnt] == cFilAnt
						If SZU->(!dbSeek(aFil[nCnt]+(cAliasTrb)->ZU_CODAPR+(cAliasTrb)->ZU_CODRGA))
							SZU->(RecLock("SZU",.T.))
							SZU->ZU_FILIAL := aFil[nCnt] // filial marcada pelo usuario
							SZU->ZU_CODRGA := (cAliasTrb)->ZU_CODRGA
							SZU->ZU_CODAPR := (cAliasTrb)->ZU_CODAPR
							SZU->ZU_DTINCLU := (cAliasTrb)->ZU_DTINCLU
							SZU->ZU_MSBLQL := (cAliasTrb)->ZU_MSBLQL
							SZU->(MsUnLock())
						Endif	
					Endif	
				Next
				(cAliasTrb)->(dbSkip())
			Enddo
			(cAliasTrb)->(dbCloseArea())
		ElseIf (IsInCallStack('U_xMF08Vinc')) //Vinculo com Regras
			cQ := "SELECT SZU.*,R_E_C_N_O_ SZU_RECNO "
			cQ += "FROM "+RetSqlName("SZU")+" SZU "
			cQ += "WHERE SZU.D_E_L_E_T_ = ' ' "
			cQ += "AND ZU_FILIAL = '"+xFilial("SZU")+"' "
			cQ += "AND ZU_CODRGA = '"+SZT->ZT_CODIGO+"' "
			cQ += "ORDER BY ZU_FILIAL,ZU_CODRGA,ZU_CODAPR "
						     
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

			tcSetField(cAliasTrb,"ZU_DTINCLU","D",8,0)
				
			SZU->(dbSetOrder(1))					
			While (cAliasTrb)->(!Eof())
				For nCnt:=1 To Len(aFil)
					If !aFil[nCnt] == cFilAnt				
						If SZU->(!dbSeek(aFil[nCnt]+(cAliasTrb)->ZU_CODRGA+(cAliasTrb)->ZU_CODAPR))
							SZU->(RecLock("SZU",.T.))
							SZU->ZU_FILIAL := aFil[nCnt] // filial marcada pelo usuario
							SZU->ZU_CODRGA := (cAliasTrb)->ZU_CODRGA
							SZU->ZU_CODAPR := (cAliasTrb)->ZU_CODAPR
							SZU->ZU_DTINCLU := (cAliasTrb)->ZU_DTINCLU
							SZU->ZU_MSBLQL := (cAliasTrb)->ZU_MSBLQL
							SZU->(MsUnLock())
						Endif	
					Endif	
				Next
				(cAliasTrb)->(dbSkip())
			Enddo
			(cAliasTrb)->(dbCloseArea())
		Endif	
		APMsgInfo("Regra gravada nas filiais.")
	Endif
Endif	
				
aEval(aArea,{|x| RestArea(x)})

Return()


Static Function FAT09VisFilial()

Local aArea := {SZU->(GetArea()),GetArea()}
local aSeek	:= {}
local oDlg	:= nil
local aCoors :=	FWGetDialogSize( oMainWnd )
local bOk := { || oDlg:end() }
local bClose := { || oDlg:end() }
Local aMat := {}
Local cQ := ""
Local cAliasTrb := GetNextAlias()
Local cTitulo := ""
Local oMark

//Pesquisa que sera exibido
If (IsInCallStack('U_xMF07Vinc') .or. IsInCallStack('U_xjMF07Vinc')) //Vinculo com Aprovadores 
	cTitulo := "Aprovadores x Regras"
	cQ := "SELECT SZU.*,R_E_C_N_O_ SZU_RECNO "
	cQ += "FROM "+RetSqlName("SZU")+" SZU "
	cQ += "WHERE SZU.D_E_L_E_T_ = ' ' "
	cQ += "AND ZU_CODAPR = '"+SZS->ZS_CODIGO+"' "
	cQ += "ORDER BY ZU_FILIAL,ZU_CODAPR,ZU_CODRGA "
						     
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

	tcSetField(cAliasTrb,"ZU_DTINCLU","D",8,0)
	
	GrvTempSZU(@aMat,cAliasTrb)
	(cAliasTrb)->(dbCloseArea())
	
ElseIf (IsInCallStack('U_xMF08Vinc')) //Vinculo com Regras
	cTitulo := "Regras x Aprovadores"
	cQ := "SELECT SZU.*,R_E_C_N_O_ SZU_RECNO "
	cQ += "FROM "+RetSqlName("SZU")+" SZU "
	cQ += "WHERE SZU.D_E_L_E_T_ = ' ' "
	cQ += "AND ZU_CODRGA = '"+SZT->ZT_CODIGO+"' "
	cQ += "ORDER BY ZU_FILIAL,ZU_CODRGA,ZU_CODAPR "
						     
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

	tcSetField(cAliasTrb,"ZU_DTINCLU","D",8,0)
	
	GrvTempSZU(@aMat,cAliasTrb)
	(cAliasTrb)->(dbCloseArea())	
Endif	
	
DEFINE MSDIALOG oDlg TITLE cTitulo FROM aCoors[1], aCoors[2] TO aCoors[3], aCoors[4] PIXEL

oMark := fwBrowse():New()
oMark:setDataArray()
oMark:setArray(aMat)
oMark:disableConfig()
oMark:disableReport()
oMark:setOwner(oDlg)

oMark:addColumn({"Filial"			, {||aMat[oMark:nAt,1]}		, "C", pesqPict("SZU","ZU_FILIAL")	, 1, tamSx3("ZU_FILIAL")[1]	,, .F.})
oMark:addColumn({"Cod. Regra"		, {||aMat[oMark:nAt,2]}		, "C", pesqPict("SZU","ZU_CODRGA")	, 1, tamSx3("ZU_CODRGA")[1]	,, .F.})
oMark:addColumn({"Desc. Regra"		, {||aMat[oMark:nAt,3]}		, "C", pesqPict("SZU","ZU_DESRGA")	, 1, tamSx3("ZU_DESRGA")[1]	,, .F.})
oMark:addColumn({"Cod. Aprovador"	, {||aMat[oMark:nAt,4]}		, "C", pesqPict("SZU","ZU_CODAPR")	, 1, tamSx3("ZU_CODAPR")[1]	,, .F.})
oMark:addColumn({"Nome Aprovador"	, {||aMat[oMark:nAt,5]}		, "C", pesqPict("SZU","ZU_NOMAPR")	, 1, tamSx3("ZU_NOMAPR")[1]	,, .F.})
oMark:addColumn({"Data Inclusao"	, {||aMat[oMark:nAt,6]}		, "C", pesqPict("SZU","ZU_DTINCLU")	, 1, tamSx3("ZU_DTINCLU")[1],, .F.})
oMark:addColumn({"Bloqueado"		, {||aMat[oMark:nAt,7]}		, "C", pesqPict("SZU","ZU_MSBLQL")	, 1, tamSx3("ZU_MSBLQL")[1],, .F.})
		
/* add(Column
[n][01] Titulo da coluna
[n][02] Code-Block de carga dos dados
[n][03] Tipo de dados
[n][04] Mascara
[n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
[n][06] Tamanho
[n][07] Decimal
[n][08] Indica se permite a edicao
[n][09] Code-Block de validacao da coluna apos a edicao
[n][10] Indica se exibe imagem
[n][11] Code-Block de execucao do duplo clique
[n][12] Variavel a ser utilizada na edicao (ReadVar)
[n][13] Code-Block de execucao do clique no header
[n][14] Indica se a coluna esta deletada
[n][15] Indica se a coluna sera exibida nos detalhes do Browse
[n][16] Opcoes de carga dos dados (Ex: 1=Sim, 2=Nao)
[n][17] Id da coluna
[n][18] Indica se a coluna � virtual
*/

oMark:activate(.T.)

enchoiceBar(oDlg, bOk , bClose)
ACTIVATE MSDIALOG oDlg CENTER

aEval(aArea,{|x| RestArea(x)})

Return()


Static Function GrvTempSZU(aMat,cAliasTrb)

While (cAliasTrb)->(!Eof())
	aAdd(aMat,{(cAliasTrb)->ZU_FILIAL,(cAliasTrb)->ZU_CODRGA,Posicione("SZT",1,Padr(Subs((cAliasTrb)->ZU_FILIAL,1,2),TamSX3("ZT_FILIAL")[1])+(cAliasTrb)->ZU_CODRGA,"ZT_DESCRI"),(cAliasTrb)->ZU_CODAPR,Posicione("SZS",1,Padr(Subs((cAliasTrb)->ZU_FILIAL,1,2),TamSX3("ZS_FILIAL")[1])+(cAliasTrb)->ZU_CODAPR,"ZS_NOME"),(cAliasTrb)->ZU_DTINCLU,(cAliasTrb)->ZU_MSBLQL})
	(cAliasTrb)->(dbSkip())
Enddo

Return()
