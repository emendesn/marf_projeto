#include "protheus.ch"                           

#define ITENSGETD 9999

/*
=====================================================================================
Programa............: MGFFIS03
Autor...............: Mauricio Gresele
Data................: 19/10/2016 
Descricao / Objetivo: Rotina chamada pelo ponto de entrada MA020ROT, para amarracao de fornecedores X series da NFE
Doc. Origem.........: Fiscal-FIS13
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFFIS03(aRetorno)

//Local aRetorno := {}

Aadd(aRetorno,{"Relacionar Espécie NFE Talonário", "U_Fis03Amar()",0,4,2,.F.})

Return(aRetorno)


// rotina de cadastro da tabela ZZ1
User Function Fis03Cad()

Local cVldAlt := "U_Fis03ACad()" // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := "U_Fis03ECad()" // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "ZZ1"

dbSelectArea(cString)
dbSetOrder(1)

//AxCadastro(cString,"Cadastro de Séries da NFE Talonário",cVldExc,cVldAlt)
AxCadastro(cString,"Cadastro de Especies da NFE Talonário",cVldExc,cVldAlt)

Return()


// valida alteracao de serie de NFE talonario
User Function Fis03ACad()

Local lRet := .T.
Local aArea := {ZZ1->(GetArea())}

If Altera
	lRet := .F.
	//APMsgStop("Alteração não permitida, exclua e inclua a Série.")
	APMsgStop("Alteração não permitida, exclua e inclua a Espécie.")
Else
	If ZZ1->(dbSeek(xFilial("ZZ1")+M->ZZ1_SERIE))
		While ZZ1->(!Eof()) .and. xFilial("ZZ1")+M->ZZ1_SERIE == ZZ1->ZZ1_FILIAL+ZZ1->ZZ1_SERIE
			If ZZ1->ZZ1_ESPECI == M->ZZ1_ESPECI
				lRet := .F.
				APMsgStop("Chaves (Espécie/Série) já cadastrada.")
				Exit
			Endif
			ZZ1->(dbSkip())
		Enddo
	Endif			 		
Endif	

aEval(aArea,{|x| RestArea(x)})

Return(lRet)


// valida exclusao de serie de NFE talonario
User Function Fis03ECad()

Local aArea := {GetArea()}
Local cAliasTrb := GetNextAlias()
Local cQ := "" 
Local lRet := .T.

cQ := "SELECT ZW_FORNECE,ZW_LOJA "
cQ += "FROM "+RetSqlName("SZW")+ " SZW "
cQ += "WHERE ZW_FILIAL = '"+xFilial("SZW")+"' "
cQ += "AND ZW_SERIE = '"+ZZ1->ZZ1_SERIE+"' "
cQ += "AND ZW_ESPECIE = '"+ZZ1->ZZ1_ESPECI+"' "
cQ += "AND SZW.D_E_L_E_T_ = ' ' "
	
cQ := ChangeQuery(cQ)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQ),cAliasTrb,.F.,.T.)

While (cAliasTrb)->(!Eof())
	lRet := .F.
	APMsgStop("Série não poderá ser excluída, utilizada no Fornecedor/Loja: "+(cAliasTrb)->ZW_FORNECE+"/"+(cAliasTrb)->ZW_LOJA)
	APMsgStop("Espécie não poderá ser excluída, utilizada no Fornecedor/Loja: "+(cAliasTrb)->ZW_FORNECE+"/"+(cAliasTrb)->ZW_LOJA)
	Exit
Enddo	
	 
(cAliasTrb)->(dbCloseArea())	

aEval(aArea,{|x| RestArea(x)})

Return(lRet)


// rotina de amarracao do fornecedor a serie NFE
User Function Fis03Amar()

Local aArea := {GetArea()}
Local cCposGetd := "ZW_ESPECIE" +", "+ "ZW_SERIE"
Local aCposGetd := {"ZW_ESPECIE","ZW_SERIE"}
Local aPosObj := {}
Local aObjects := {}
Local aSize := {}
Local aPosGet := {}
Local aInfo := {}
Local lContinua:= .T.
Local nOpcA := 0
Local nUsado := 0
Local nCntFor := 0
Local oDlg
Local lInclui := .F.
Local lVisual := .F.
Local lAltera := .F.
Local cQ := ""
Local nOpc := 0
Local aHeadSav := IIf(Type("aHeader")<>"U",aClone(aHeader),Nil)
Local aColsSav := IIf(Type("aCols")<>"U",aClone(aCols),Nil)
Local nNSav := IIf(Type("n")<>"U",n,Nil)
Local cDesc := SA2->A2_NOME

Private cFor := SA2->A2_COD
Private cLoja := SA2->A2_LOJA
Private aHeader := {}
Private aCols := {}
Private n := 1
Private oGetD

// somente cadastra as series se o fornecedor estiver configurado para emitir a nota fiscal eletronica
If SA2->A2_ZEMINFE != "1"
	lContinua := .F.
	APMsgStop("Fornecedor não está configurado para emissão de Nota Fiscal Eletrônica."+CRLF+;
	"Verifique campo customizado 'Emite NFE'.")
Endif	

If lContinua	   
	//cQ := "SELECT ZW_SERIE "
	cQ := "SELECT ZW_ESPECIE, ZW_SERIE "
	cQ += "FROM "+RetSqlName("SZW")+ " SZW "
	cQ += "WHERE ZW_FILIAL = '"+xFilial("SZW")+"' "
	cQ += "AND ZW_FORNECE = '"+cFor+"' "
	cQ += "AND ZW_LOJA = '"+cLoja+"' "
	cQ += "AND SZW.D_E_L_E_T_ = ' ' "
//	cQ += "ORDER BY ZW_SERIE "
	cQ += "ORDER BY ZW_ESPECIE, ZW_SERIE "
		
	cQ := ChangeQuery(cQ)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQ),'_TRA',.F.,.T.)
	
	While !Eof()
		lAltera := .T.
		nOpc := 4
		Exit
	Enddo   
	
	If IsInCallStack("A020VISUAL")
		lVisual := .T.
		lAltera := .F.
		nOpc := 2     
	Endif	
	
	If !lAltera .and. !lVisual
		lInclui := .T.
		nOpc := 3
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa a Variaveis da Enchoice.                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RegToMemory("SZW",.F.,.F.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do aHeader                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SZW")
	While (!Eof() .And. (SX3->X3_ARQUIVO == "SZW"))
		If (X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL .and. AllTrim(SX3->X3_CAMPO) $ cCposGetd)
			nUsado++
			Aadd(aHeader,{TRIM(X3Titulo()),;
						SX3->X3_CAMPO,;
						SX3->X3_PICTURE,;
						SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL,;
						SX3->X3_VALID,;
						SX3->X3_USADO,;
						SX3->X3_TIPO,;
						SX3->X3_ARQUIVO,;
						SX3->X3_CONTEXT } )
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do aCols                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("_TRA")	
	dbGotop()
	
	If lAltera .or. lVisual
	
		dbSelectArea("_TRA")	
		
		While !Eof()
			aadd(aCols,Array(nUsado+1))
		
			For nCntFor	:= 1 To nUsado
				If Alltrim(aHeader[nCntFor,2]) == "ZW_SERIE"
				aCols[Len(aCols)][nCntFor] := _TRA->ZW_SERIE    
				nCntFor++
					If Alltrim(aHeader[nCntFor,2]) == "ZW_ESPECIE"
						aCols[Len(aCols)][nCntFor] := _TRA->ZW_ESPECIE
					Endif	
				EndIf	
			Next nCntFor
			aCols[Len(aCols)][Len(aHeader)+1] := .F.
			
			dbSkip()
		Enddo	
	Elseif lInclui	
		aadd(aCols,Array(nUsado+1))
	
		For nCntFor	:= 1 To nUsado
			If aHeader[nCntFor,8] == "C"
				aCols[1,nCntFor] := Space(aHeader[nCntFor,4])
			ElseIf aHeader[nCntFor,8] == "N"
				aCols[1,nCntFor] := 0
			ElseIf aHeader[nCntFor,8] == "D"
				aCols[1,nCntFor] := cTod("")
			ElseIf aHeader[nCntFor,8] == "M"
				aCols[1,nI] := ""
			Else
				aCols[1,nI] := .F.
			EndIf
		Next nCntFor
		
		aCols[1][Len(aHeader)+1] := .F.
	Endif	
	
	_TRA->(dbCloseArea())
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso nao ache nenhum item , abandona rotina.         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (Len(aCols) == 0)
		//MsgInfo("Não foi encontrada nenhuma Série de NFE Talonário cadastrada.","Atenção")
		MsgInfo("Não foi encontrada nenhuma Espécie de NFE Talonário cadastrada.","Atenção")
		lContinua := .F.
	EndIf
	
	If ( lContinua )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz o calculo automatico de dimensoes de objetos     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aSize := MsAdvSize()
		aObjects := {}
		AAdd( aObjects, {100,15,.T.,.F.})
		AAdd( aObjects, {100,100,.T.,.T.})
	
		aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
		aPosObj := MsObjSize(aInfo,aObjects)
	
		aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{10,25,50,60,80,090}})
		    
		DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

		@ aPosObj[1][1],aPosObj[1][2] TO aPosObj[1][3],aPosObj[1][4] LABEL '' OF oDlg PIXEL
		@ 035,aPosGet[1,1] SAY OemToAnsi("Fornecedor: ") OF oDlg PIXEL SIZE 030,006 
		@ 035,aPosGet[1,2] MSGET cFor PICTURE PesqPict('SA2','A2_COD') WHEN .F. OF oDlg PIXEL SIZE 030,006 
		@ 035,aPosGet[1,3] SAY OemToAnsi("Loja : ") OF oDlg PIXEL SIZE 030,006 
		@ 035,aPosGet[1,4] MSGET cLoja PICTURE PesqPict('SA2','A2_LOJA') WHEN .F. OF oDlg PIXEL SIZE 015,006
		@ 035,aPosGet[1,5] SAY OemToAnsi("Nome: ") OF oDlg PIXEL SIZE 030,006 
		@ 035,aPosGet[1,6] MSGET cDesc WHEN .F. OF oDlg PIXEL SIZE 200,006 
			
		dbSelectArea("SZW")
		dbSetOrder(1)	
	   	oGetd := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"U_Fis03LOk","U_Fis03TOk",,.T.,aCposGetd,,.T.,ITENSGETD,/*"U_Fis03Cpo"*/)
//		oGetd:oBrowse:bEditCol := { || oGetd:oBrowse:nColPos:= 1 }
		
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||If(oGetd:TudoOk(),(nOpcA:=1,oDlg:End()),nOpcA:=0)},{|| oDlg:End()},,)
	EndIf
	
	If nOpcA == 1  .and. (lInclui .or. lAltera)
		Processa({||U_Fis03Grava(cFor,cLoja,.F.)},"Aguarde, gravando dados ...")
	Endif
Endif
	
If Type("aHeadSav")<>"U"
	aHeader := aClone(aHeadSav)
Endif	
If Type("aColsSav")<>"U"
	aCols := aClone(aColsSav)
Endif	
If Type("nNSav")<>"U"
	n := nNSav
Endif	

aEval(aArea,{|x| RestArea(x)})

Return()

// validacao de linha Ok
User Function Fis03LOk() 
                               
Local lRet := .T.
Local x := 0

If !aCols[n,Len(aHeader)+1]
	If Empty(aCols[n][1])
		//ApMsgAlert("Falta informar a Série.","Alerta")
		ApMsgAlert("Falta informar a Espécie.","Alerta")
		lRet := .F.
	Endif	
	If lRet
		// valida se esta serie jah foi informada
		For x := 1 To Len(aCols)
			If !aCols[x,Len(aHeader)+1]
				If x <> n
					If aCols[x][1]+aCols[x][2] == aCols[n][1]+aCols[n][2] //aCols[x][2] == aCols[n][2]
						ApMsgAlert("Chaves (Espécie/Série) iguais nos itens.","Alerta")
						//ApMsgAlert("Espécies iguais nos itens.","Alerta")
						lRet := .F.
						Exit
					Endif	
				Endif
			Endif
		Next x
	Endif
Endif	

Return(lRet)


// validacao do Tudo Ok
User Function Fis03TOk()

Local lRet := .T.
Local x := 0
Local y := 0

For x := 1 To Len(aCols)
	If !aCols[x,Len(aHeader)+1]
		For y := 1 To Len(aCols)
			If !aCols[y,Len(aHeader)+1]
				If x <> y
					If aCols[x][1]+aCols[x][2] == aCols[y][1]+aCols[y][2] //aCols[x][1] == aCols[y][1]
						ApMsgAlert("Chaves (Espécie/Série) iguais nos itens.","Alerta")
						//ApMsgAlert("Espécies iguais nos itens.","Alerta")
						lRet := .F.
						Exit
					Endif	
				Endif
			Endif
		Next y			
	Endif	
Next x

Return(lRet)


// processa a gravacao
User Function Fis03Grava(cFor,cLoja,lSoExclui)

Local aArea := {GetArea()}
Local x := 0

Begin Transaction 

SZW->(dbSetOrder(1))
If SZW->(dbSeek(xFilial("SZW")+cFor+cLoja))
	If !lSoExclui		
		ProcRegua(Len(aCols))
	Endif	
	While SZW->(!Eof()) .and. xFilial("SZW")+cFor+cLoja == SZW->ZW_FILIAL+SZW->ZW_FORNECE+SZW->ZW_LOJA
		If !lSoExclui		
			IncProc()
		Endif	
	   // deleta item para regrava-lo abaixo
		SZW->(RecLock("SZW",.F.))
		SZW->(dbDelete())
		SZW->(MsUnlock())
		
		SZW->(dbSkip())
	Enddo
Endif	

If !lSoExclui		
	ProcRegua(Len(aCols))
	For x := 1 To Len(aCols)
		IncProc()
		If !aCols[x,Len(aHeader)+1]
			SZW->(RecLock("SZW",.T.))
			SZW->ZW_FILIAL := xFilial("SZW")
			SZW->ZW_FORNECE := cFor
			SZW->ZW_LOJA := cLoja
			SZW->ZW_ESPECIE := aCols[x][2]
			SZW->ZW_SERIE 	:= aCols[x][1]
			SZW->(MsUnlock())
		Endif
	Next x	
Endif
	
End Transaction	

aEval(aArea,{|x| RestArea(x)})
		
Return()


// validacao da inclusao da nfe
User Function Fis03VldNfe(ParamIxb,cFornece,cLoja,cTipoNFe,cEspNFe,cSerNFe)

Local aArea := {GetArea(),SA2->(GetArea())}
Local lRet := ParamIxb[1]
Local lContinua := .T.
Local cQ := ""
Local cAliasTrb := GetNextAlias()
Local cE_Esps  := SuperGetMV('MGF_FIS03E',.T.,'SPED,CTE') //Espécies para documentos eletrônicos. Quando o cliente emite NF-e.
Local cMGFTipo := SuperGetMV('MGF_FIS03T',.T.,'D,B')      //Tipo de Documentos que não precisam passar pela Regra.

// nao passou na validacao do padrao
If !lRet
	Return(lRet)
Endif

// Formulario Proprio retorna.
If CFORMUL = "S"
	Return(lRet)
EndIf

// se estiver na exclusao, nao valida este ponto
If !Inclui .and. !Altera
	Return(lRet)
Endif

If cTipoNFe $ cMGFTipo
	Return(lRet)
Endif

If Empty(cSerNFe)
	lContinua := .F.
	lRet := .F.	
	APMsgStop("Informar Série de Documento de Entrada!")
Endif

If Empty(cEspNFe)
	lContinua := .F.
	lRet := .F.	
	APMsgStop("Informar Espécie de Documento de Entrada!")
Endif

If lContinua	
	// se a inclusao da NFE estiver sendo feita pela rotina customizada de importacao de XML, nao precisa validar este ponto
	//If FindFunction("U_IMPXML???")
	//	If IsInCallStack("")
	//		lContinua := .F.
	//	Endif
	//Endif	
	
	If lContinua
		If cFornece <> SA2->A2_COD .or. cLoja <> SA2->A2_LOJA
			SA2->(dbSetOrder(1))
			If SA2->(!dbSeek(xFilial("SA2")+cFornece+cLoja))
				lContinua := .F.
			ElseIf IsInCallStack("U_MGFINT09") .And. SA2->A2_ZEMINFE != "1"
				RecLock("SA2",.F.)
				SA2->A2_ZEMINFE := "1"
				SA2->( msUnlock() ) 
			Endif	
		Endif	
		
		If lContinua			
			// Se fornecedor esta cadastrado para emitir NFE, nao precisa validar este ponto			
			If SA2->A2_ZEMINFE = "1" .And. Alltrim(cEspNFe) $ cE_Esps
				lContinua := .F.
			Endif
			
			// Imporatação de XML., nao precisa validar este ponto			
			If IsInCallStack("U_MGFINT09")
				lContinua := .F.
			Endif
			
			// Obs: a partir deste ponto, se nao passar na validacao, alterar a variavel lRet para .F.	
			If lContinua
				If Alltrim(cEspNFe) $ cE_Esps
					lContinua := .F.
					lRet := .F.
					APMsgStop("Espécie " + Alltrim(cEspNFe) + " não permitida para entrada manual para este fornecedor.")
				Endif
			Endif
				
			// se fornecedor nao esta cadastrado para emitir NFE, nao precisa validar este ponto			
			If SA2->A2_ZEMINFE != "1"
				lContinua := .F.
			Endif

			If lContinua
				cQ := "SELECT 1 "
				cQ += "FROM "+RetSqlName("SZW")+ " SZW "
				cQ += "WHERE ZW_FILIAL = '"+xFilial("SZW")+"' "
				cQ += "AND ZW_FORNECE = '"+SA2->A2_COD+"' "
				cQ += "AND ZW_LOJA = '"+SA2->A2_LOJA+"' "
				cQ += "AND ZW_SERIE = '"+cSerNFe+"' "
				cQ += "AND ZW_ESPECIE = '"+cEspNFe+"' "
				cQ += "AND SZW.D_E_L_E_T_ = ' ' "
					
				cQ := ChangeQuery(cQ)
				dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQ),cAliasTrb,.F.,.T.)
				
				If (cAliasTrb)->(Eof())
					lContinua := .F.
					lRet := .F.
					//APMsgStop("Série deste documento não está cadastrada para este Fornecedor na tabela de 'Amarração de Fornecedor x Especie x Série NFE Talonário'.")
					APMsgStop("Espécie deste documento não está cadastrada para este Fornecedor na tabela de 'Amarração de Fornecedor x Especie NFE Talonário'.")
				Endif	
				
				(cAliasTrb)->(dbCloseArea())
			Endif
		Endif		
	Endif
Endif		
				
aEval(aArea, {|x| RestArea(x)})

Return(lRet)