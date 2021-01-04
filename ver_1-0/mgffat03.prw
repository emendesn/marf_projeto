#include "protheus.ch"
#include "rwmake.ch"
#include "TOTVS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "DBSTRUCT.CH"
#INCLUDE "MSGRAPHI.CH"
#include "FWMVCDEF.CH"
#include "TOPCONN.CH"

/*
=====================================================================================
Programa............: MGFFAT03
Autor...............: Marcos Andrade         
Data................: 15/09/2016 
Descricao / Objetivo: Cadastro de Tipos de pedido
Doc. Origem.........: Contrato - GAP FAT01
Solicitante.........: Cliente
Uso.................: 
Obs.................: Tela para cadastro tipos de pedido utilizada na tabela de preco
=====================================================================================
*/

User Function MGFFAT03() 
Local aArea		:= GetArea()
Local aIndex 	:= {} 
Local cFiltro 	:= ""	//ZA_CODFORN == '" + SA2->A2_COD + "' " 

//Expressao do Filtro 
Private aRotina := {	{ "Pesquisar" 	, "PesqBrw" 	, 0 , 1 },; 
						{ "Visualizar" 	, "AxVisual" 	, 0 , 2 },; 
						{ "Incluir" 	, "AxInclui" 	, 0 , 3 },; 
						{ "Alterar" 	, "AxAltera" 	, 0 , 4 },; 
						{ "Excluir" 	, "u_FT03Del" 	, 0 , 5 }} 

Private bFiltraBrw 	:= { || FilBrowse( "SZJ" , @aIndex , @cFiltro ) } //Determina a Expressao do Filtro 
Private cCadastro 	:= "Cadastro de Tipo de Pedido" 

Eval( bFiltraBrw ) 							//Efetiva o Filtro antes da Chamada a 

mBrowse( 6 , 1 , 22 , 75 , "SZJ" ) 

EndFilBrw( "SZJ" , @aIndex ) 				

//Finaliza o Filtro         
RestArea(aArea)

Return( NIL ) 
                     

/*
=====================================================================================
Programa............: MGFFAT03
Autor...............: Marcos Andrade         
Data................: 15/09/2016 
Descricao / Objetivo: Cadastro de Tipos de pedido
Doc. Origem.........: Contrato - GAP FAT01
Solicitante.........: Cliente
Uso.................: 
Obs.................: Exclusao de tipo de pedido
=====================================================================================
*/

User Function FT03Del()                
Local aArea		:= GetArea()
Local _cAlias	:= GetNextAlias()  
Local lRet 		:= .T.

DbSelectArea("SZK")
DbSetOrder(2)
If DbSeek(xFilial("SZK")+SZJ->ZJ_COD)
	Msginfo("Nao � possivel excluir este tipo de pedido porque possui relacionamento com tabela de preco!","Atencao")
	lRet := .F.
Else                                                       
	//-----------------------------------------------------------
	//Query Busca se tem relacionamento com pedido de venda
	//-----------------------------------------------------------
	cQuery := " SELECT C5_NUM "
	cQuery += " FROM "+RetSQLName("SC5") + " SC5  "
	cQuery += " WHERE SC5.C5_FILIAL  = '" + xFilial("SC5") 	+ "' "
	cQuery += " AND   SC5.C5_ZTIPPED = '" + SZJ->ZJ_COD		+ "'" 
	cQuery += " AND SC5.D_E_L_E_T_= ' ' "
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), _cAlias)
	 
	If !(_cAlias)->( Eof() )
		Aviso( "Atencao", "Existe pedido de venda amarrado a este codigo. Registro nao pode ser excluido!", {"Ok"} )
		lRet := .F.
	Endif
Endif

If lRet
	DbSelectArea("SZJ")
	RecLock("SZJ")
		SZJ->(DbDelete())
	SZJ->(MsUnlock())        
Endif                           

DbCloseArea(_cAlias)	        

RestArea(aArea)

Return  

/*
=====================================================================================
Programa.:              FAT01ImpTab
Autor....:              Tiago Barbieri
Data.....:              05/09/2016
Descricao / Objetivo:   Importacao de cadastros
Doc. Origem:            Contrato - GAP MGFIMP01
Solicitante:            Cliente
Uso......:              
Obs......:              Tela de Importacao de cadastros
=====================================================================================
*/

User Function FAT01ImpTab() 
Local _cTabela	 := ""
Local cArq	     := ""
Local cArqd	     := ""
Local cLogDir    := ""
Local cLogFile   := ""
Local cTime      := ""
Local aLog       := {}
Local cLogWrite  := ""
Local cLogWritet := ""
Local nHandle
Local cLinha     := ''
Local cLinhad    := ''
Local lPrim      := .T.
Local lPrimd     := .T.
Local aCampos    := {}
Local aCamposd   := {}
Local aDados     := {}
Local aDadosd    := {}
Local cBKFilial  := cFilAnt
Local nCampos    := 0
Local nCamposd   := 0
Local cSQL       := ''
Local cSQLd      := ''
Local aExecAuto  := {}
Local aExecAutod := {}
Local aExecAutol := {}
Local aTipoImp   := {}
Local aTipoImpd  := {}
Local nTipoImp   := 0
Local nTipoImpd  := 0
Local cTipo      := ''
Local cTipod     := ''
Local cTab       := ''
Local cTabd      := ''
Local nI
Local nId
Local nX
Local cNiv
Local cCod
Local cBemN1
Local cBemN3
Local cItemN1                                   
Local cItemN3
Local cTabItens 		:= "DA1_CODTAB"  	//"DA1_ITEM/DA1_CODPRO/DA1_PRCVEN"


Private lMsErroAuto    := .F.
Private lMsHelpAuto	   := .F.
Private lAutoErrNoFile := .T.
Private aTabExclui     := {	{'DA0',{"DA0"} },;
							{'DA1',{"DA1"} } }

//Arquivo Cabeaalho
MsgAlert("Essa opcao precisa de 2 arquivos, o primeiro � o arquivo de CABE�ALHO!","ATENCAO")
cArq := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diretorio onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)

If !File(cArq)
	MsgStop("O arquivo " +cArq + " nao foi selecionado. A importacao sera abortada!","ATENCAO")
	Return
EndIf
	
FT_FUSE(cArq)
FT_FGOTOP()
cLinha    := FT_FREADLN()
aTipoImp  := Separa(cLinha,";",.T.)
cTipo     := SUBSTR(aTipoImp[1],1,3)

IF !(cTIPO $('DA0'))
	MsgAlert('Nao � possivel importar a tabela: '+cTipo+ '  !!')
	Return
ENDIF

dbSelectArea("SX3")
DbSetOrder(2)
For nI := 1 To Len(aTipoImp)
	IF cTipo <> SUBSTR(aTipoImp[nI],1,2)
		MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
		Return
	ENDIF
	IF !SX3->(dbSeek(Alltrim(aTipoImp[nI])))
		MsgAlert('Campo nao encontrado na tabela :'+aTipoImp[nI]+' !!')
		Return
	ELSEIF (SX3->X3_VISUAL $ ('V') ) .OR. (SX3->X3_CONTEXT == "V"  )
		MsgAlert('Campo marcado na tabela como visual :'+aTipoImp[nI]+' !!')
		Return
	ENDIF
Next nI

ProcRegua(FT_FLASTREC())
FT_FGOTOP()

While !FT_FEOF()
	IncProc("Lendo arquivo texto...")
	cLinha := FT_FREADLN()
	If lPrim
		aCampos := Separa(cLinha,";",.T.)
		lPrim := .F.
	Else
		AADD(aDados,Separa(cLinha,";",.T.))
	EndIf
	FT_FSKIP()
EndDo
	
//Arquivo Itens
//MsgAlert("Agora � o arquivo de ITENS!","ATENCAO")
cArqd := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diretorio onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)
	
If !File(cArqd)
	MsgStop("O arquivo " +cArqd + " nao foi selecionado. A importacao sera abortada!","ATENCAO")
	Return
EndIf
	
FT_FUSE(cArqd)
FT_FGOTOP()
cLinhad    := FT_FREADLN()
aTipoImpd  := Separa(cLinhad,";",.T.)
cTipod     := SUBSTR(aTipoImpd[1],1,3)

IF !(cTIPOd $('DA1'))
	MsgAlert('Nao � possivel importar a tabela: '+cTipod+ '  !!')
	Return
ENDIF

dbSelectArea("SX3")
DbSetOrder(2)
For nI := 1 To Len(aTipoImpd)
	IF cTipod <> SUBSTR(aTipoImpd[nI],1,2)
		MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
		Return
	ENDIF
	IF !SX3->(dbSeek(Alltrim(aTipoImpd[nI])))
			MsgAlert('Campo nao encontrado na tabela :'+aTipoImpd[nId]+' !!')
		Return
	ELSEIF (SX3->X3_CONTEXT == "V"  )
		MsgAlert('Campo marcado na tabela como visual :'+aTipoImpd[nId]+' !!')
		Return
	ENDIF
Next nId

ProcRegua(FT_FLASTREC())
FT_FGOTOP()
While !FT_FEOF()
	IncProc("Lendo arquivo texto...")
	cLinhad := FT_FREADLN()
	If lPrimd
		aCamposd := Separa(cLinhad,";",.T.)
		lPrimd := .F.
	Else
		AADD(aDadosd,Separa(cLinhad,";",.T.))
	EndIf
	FT_FSKIP()
EndDo
	
cTabD0    := ""
cTabD1    := ""
//cTabItens := ""

//Monta array do cabecalho
ProcRegua(Len(aDados))
For nI:=1 to  Len(aDados)
	IncProc("Importando arquivos...")
	aExecAuto  := {}
	aExecAutod := {}
	For nCampos := 1 To Len(aCampos)
		IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
			IF !EMpty(aDados[nI,nCampos])
				cFilAnt := aDados[nI,nCampos]
			ENDIF
		ELSEIF  Upper(aCampos[nCampos])=='DA0_CODTAB'
			//_cTabela		:= GetSXENum("DA0","DA0_CODTAB")
			//ConfirmSX8()
			//aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	_cTabela 	,Nil})
		Else
			IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
				aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
			ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
				aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
			ELSE
				aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
			ENDIF
		ENDIF
	Next nCampos
	cTabD0  := aDados[nI][1]
	
	//Monta array dos itens
	For nId:=1 to  Len(aDadosd)
		cTabD1  := aDadosd[nId][1]
		aExecAutol := {}
		IF cTabD1 == cTabD0
			For nCamposd := 1 To Len(aCamposd)   
			
				If !(Alltrim(aCamposd[nCamposd]) $ cTabItens)
					IF  SUBSTR(Upper(aCamposd[nCamposd]),4,6)=='FILIAL'
						IF !EMpty(aDadosd[nId,nCamposd])
							cFilAnt := aDadosd[nId,nCamposd]
						ENDIF
					ELSEIF  Upper(aCamposd[nCamposd])=='DA1_CODTAB'
						//aAdd(aExecAutol ,{Upper(aCamposd[nCamposd]), 	_cTabela 	,Nil})
					Else
						IF  TamSx3(Upper(aCamposd[nCamposd]))[3] =='N'
							aAdd(aExecAutol ,{Upper(aCamposd[nCamposd]), 	VAL(aDadosd[nId,nCamposd] )	,Nil})
						ELSEIF TamSx3(Upper(aCamposd[nCamposd]))[3] =='D'
							aAdd(aExecAutol ,{Upper(aCamposd[nCamposd]),  CTOD(aDadosd[nId,nCamposd] )	,Nil})
						ELSE
							aAdd(aExecAutol ,{Upper(aCamposd[nCamposd]), 	aDadosd[nId,nCamposd] 	,Nil})
						ENDIF
					ENDIF
				Endif
			Next nCamposd
			aAdd(aExecAutod, aExecAutol)
		ENDIF
	Next nId
	
	// Executa MSEXECAUTO
	lMsErroAuto := .F.
	Begin Transaction
		
		Omsa010( aExecAuto, aExecAutod, 3 ) // SD0/SD1 Tabela de preco
	
		//Caso ocorra erro, verifica se ocorreu antes ou depois dos primeiros 100 registros do arquivo
		If lMsErroAuto
			aLog := {}
			aLog := GetAutoGRLog()
			If nI <= 100
				DisarmTransaction()
				cLogWritet += "Linha do erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
				//MostraErro()
				For nX :=1 to Len(aLog)
					cLogWritet += aLog[nX]+CRLF
				next nX
				MsgAlert(StrTran(cLogWritet,"< --","-->"),"Erro no arquivo!")
				cFilAnt := cBKFilial
				Return
			Else
				cLogWrite += "Linha com o erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
				For nX :=1 to Len(aLog)
					cLogWrite += aLog[nX]+CRLF
				next nX
			Endif
		EndIF
	End Transaction
Next nI

//Grava arquivo de LOG caso o erro ocorra depois do 100o registro
If !Empty(cLogWrite)
	cTime     := Time()
	cLogDir   := cGetFile("Arquivo |*.log", OemToAnsi("Informe o diretorio para gravar o LOG."), 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY ,.F.)
	cLogFile  := cLogDir+"IMP_"+substr(cTime,1,2)+substr(cTime,4,2)+substr(cTime,7,2)+".LOG"
	nHandle   := MSFCreate(cLogFile,0)
	FWrite(nHandle,cLogWrite)
	FClose(nHandle)
	msgAlert("LOG de erro gerado em "+cLogFile)
Else
	MsgInfo("Arquivo importado com sucesso!!")
Endif
FT_FUSE()
cFilAnt := cBKFilial

Return
                                                                                

/*
=====================================================================================
Programa.:              T03GrvAux
Autor....:              Marcos Andrade
Data.....:              26/09/2016
Descricao / Objetivo:   Importacao de cadastros
Doc. Origem:            Contrato - GAP MGFIMP01
Solicitante:            Cliente
Uso......:              
Obs......:              Tela de Importacao de cadastros
=====================================================================================
*/

User Function T03GrvAux()    

If lCopia

	Alert("Copia de Tabela concluida!")         

Endif

Return


// rotina de inclusao ou alteracao de tabela de preco, de dentro da tela de manutencao da tabela de preco
User Function FAT01IImpTab(oObj,nOperation) 
Local _cTabela	 := ""
Local cArq	     := ""
Local cArqd	     := ""
Local cLogDir    := ""
Local cLogFile   := ""
Local cTime      := ""
Local aLog       := {}
Local cLogWrite  := ""
Local cLogWritet := ""
Local nHandle
Local cLinha     := ''
Local cLinhad    := ''
Local lPrim      := .T.
Local lPrimd     := .T.
Local aCampos    := {}
Local aCamposd   := {}
Local aDados     := {}
Local aDadosd    := {}
Local cBKFilial  := cFilAnt
Local nCampos    := 0
Local nCamposd   := 0
Local cSQL       := ''
Local cSQLd      := ''
Local aExecAuto  := {}
Local aExecAutod := {}
Local aExecAutol := {}
Local aTipoImp   := {}
Local aTipoImpd  := {}
Local nTipoImp   := 0
Local nTipoImpd  := 0
Local cTipo      := ''
Local cTipod     := ''
Local cTab       := ''
Local cTabd      := ''
Local nI
Local nId
Local nX
Local cNiv
Local cCod
Local cBemN1
Local cBemN3
Local cItemN1                                   
Local cItemN3
Local cTabItens 		:= "DA1_CODTAB"  	//"DA1_ITEM/DA1_CODPRO/DA1_PRCVEN"
Local nPosCod := 0
Local nPosPrc := 0
Local nPosAti := 0
Local nCnt := 0
Local oModelDA1 := oObj:GetModel("DA1DETAIL")
Local nCnt1 := 0
Local cConteudo := ""
Local lContinua := .T.
Local nArq := 0
Local cDir := "c:\temp\"
Local cArqTxt := cDir+"importa_tab_preco_venda_"+dTos(dDataBase)+"_"+StrTran(Time(),":","")+".txt"
Local nDet := 0
Local cItem := ""
Local lGravou := .F.
Local lErro := .F.

Private lMsErroAuto    := .F.
Private lMsHelpAuto	   := .F.
Private lAutoErrNoFile := .T.
Private aTabExclui     := {	{'DA0',{"DA0"} },;
							{'DA1',{"DA1"} } }
/*
//Arquivo Cabeaalho
MsgAlert("Essa opcao precisa de 2 arquivos, o primeiro � o arquivo de CABE�ALHO!","ATENCAO")
cArq := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diretorio onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)

If !File(cArq)
	MsgStop("O arquivo " +cArq + " nao foi selecionado. A importacao sera abortada!","ATENCAO")
	Return
EndIf
	
FT_FUSE(cArq)
FT_FGOTOP()
cLinha    := FT_FREADLN()
aTipoImp  := Separa(cLinha,";",.T.)
cTipo     := SUBSTR(aTipoImp[1],1,3)

IF !(cTIPO $('DA0'))
	MsgAlert('Nao � possivel importar a tabela: '+cTipo+ '  !!')
	Return
ENDIF

dbSelectArea("SX3")
DbSetOrder(2)
For nI := 1 To Len(aTipoImp)
	IF cTipo <> SUBSTR(aTipoImp[nI],1,2)
		MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
		Return
	ENDIF
	IF !SX3->(dbSeek(Alltrim(aTipoImp[nI])))
		MsgAlert('Campo nao encontrado na tabela :'+aTipoImp[nI]+' !!')
		Return
	ELSEIF (SX3->X3_VISUAL $ ('V') ) .OR. (SX3->X3_CONTEXT == "V"  )
		MsgAlert('Campo marcado na tabela como visual :'+aTipoImp[nI]+' !!')
		Return
	ENDIF
Next nI

ProcRegua(FT_FLASTREC())
FT_FGOTOP()

While !FT_FEOF()
	IncProc("Lendo arquivo texto...")
	cLinha := FT_FREADLN()
	If lPrim
		aCampos := Separa(cLinha,";",.T.)
		lPrim := .F.
	Else
		AADD(aDados,Separa(cLinha,";",.T.))
	EndIf
	FT_FSKIP()
EndDo
*/	
If nOperation == 4
	If !Empty(oModelDA1:GetValue("DA1_CODPRO",oModelDA1:nLine))
		MsgAlert("Posicione no �ltimo item da tabela e insira um novo item em branco, para importar a Tabela de Preco.")
		Return()
	Endif
Endif		

//Arquivo Itens
//MsgAlert("Agora � o arquivo de ITENS!","ATENCAO")
//MsgAlert("Arquivo de ITENS!","ATENCAO")
cArqd := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diretorio onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)
	
If !File(cArqd)
	MsgStop("O arquivo " +cArqd + " nao foi selecionado. A importacao sera abortada!","ATENCAO")
	Return
EndIf
	
FT_FUSE(cArqd)
FT_FGOTOP()
cLinhad    := FT_FREADLN()
aTipoImpd  := Separa(cLinhad,";",.T.)
cTipod     := SUBSTR(aTipoImpd[1],1,3)

IF !(cTIPOd $('DA1'))
	MsgAlert('Nao � possivel importar a tabela: '+cTipod+ '  !!')
	Return
ENDIF

dbSelectArea("SX3")
DbSetOrder(2)
For nI := 1 To Len(aTipoImpd)
	IF cTipod <> SUBSTR(aTipoImpd[nI],1,2)
		MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
		Return
	ENDIF
	IF !SX3->(dbSeek(Alltrim(aTipoImpd[nI])))
			MsgAlert('Campo nao encontrado na tabela :'+aTipoImpd[nId]+' !!')
		Return
	ELSEIF (SX3->X3_CONTEXT == "V"  )
		MsgAlert('Campo marcado na tabela como visual :'+aTipoImpd[nId]+' !!')
		Return
	ENDIF
Next nId

//ProcRegua(FT_FLASTREC())
FT_FGOTOP()
While !FT_FEOF()
	//IncProc("Lendo arquivo texto...")
	cLinhad := FT_FREADLN()
	If lPrimd
		aCamposd := Separa(cLinhad,";",.T.)
		lPrimd := .F.
	Else
		AADD(aDadosd,Separa(cLinhad,";",.T.))
	EndIf
	FT_FSKIP()
EndDo
	
cTabD0    := ""
cTabD1    := ""
//cTabItens := ""

MakeDir(cDir)
If File(cArqTxt)
	If fErase(cArqTxt) <> 0
		APMsgStop("Nao foi possivel apagar o arquivo de log gerado anteriormente pela rotina: "+cArqTxt+CRLF+;
		"Verifique se o mesmo esta aberto por outro aplicativo e feche o arquivo.")
		Return()
	Endif
End   

nArq := fCreate(cArqTxt,0)

/*
//Monta array do cabecalho
ProcRegua(Len(aDados))
For nI:=1 to  Len(aDados)
	IncProc("Importando arquivos...")
	aExecAuto  := {}
	aExecAutod := {}
	For nCampos := 1 To Len(aCampos)
		IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
			IF !EMpty(aDados[nI,nCampos])
				cFilAnt := aDados[nI,nCampos]
			ENDIF
		ELSEIF  Upper(aCampos[nCampos])=='DA0_CODTAB'
			//_cTabela		:= GetSXENum("DA0","DA0_CODTAB")
			//ConfirmSX8()
			//aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	_cTabela 	,Nil})
		Else
			IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
				aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
			ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
				aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
			ELSE
				aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
			ENDIF
		ENDIF
	Next nCampos
	cTabD0  := aDados[nI][1]
*/	
	//ProcRegua(Len(aDadosd))

	//Monta array dos itens
	For nId:=1 to  Len(aDadosd)
		//IncProc("Importando arquivos...")

		//If !Empty(cTabD1) .and. cTabD1 != aDadosd[nId][1]
		//	APMsgAlert("Foi identificado que existem itens de tabelas de preco diferentes neste arquivo, somente serao considerados os itens da primeira tabela cadastrada.")
		//	Exit
		//Endif	

		cTabD1  := aDadosd[nId][1]
		aExecAutol := {}
		//IF cTabD1 == cTabD0

/*
Upper(aCamposd[nCamposd])
"DA1_CODPRO"
aDadosd[nId,nCamposd]
"000129"
*/
		if chkSB1( aDadosd[ nId, 1 ] )
			For nCamposd := 1 To Len(aCamposd)
				//If !(Alltrim(aCamposd[nCamposd]) $ cTabItens)
					//IF  SUBSTR(Upper(aCamposd[nCamposd]),4,6)=='FILIAL'
					//	IF !EMpty(aDadosd[nId,nCamposd])
					//		cFilAnt := aDadosd[nId,nCamposd]
					//	ENDIF
					//ELSEIF  Upper(aCamposd[nCamposd])=='DA1_CODTAB'
					//	//aAdd(aExecAutol ,{Upper(aCamposd[nCamposd]), 	_cTabela 	,Nil})
					//Else
						IF  TamSx3(Upper(aCamposd[nCamposd]))[3] =='N'
							aAdd(aExecAutol ,{Upper(aCamposd[nCamposd]), 	VAL(aDadosd[nId,nCamposd] )	,Nil})
						ELSEIF TamSx3(Upper(aCamposd[nCamposd]))[3] =='D'
							aAdd(aExecAutol ,{Upper(aCamposd[nCamposd]),  CTOD(aDadosd[nId,nCamposd] )	,Nil})
						ELSE
							aAdd(aExecAutol ,{Upper(aCamposd[nCamposd]), 	aDadosd[nId,nCamposd] 	,Nil})
						ENDIF
					//ENDIF
				//Endif
			Next nCamposd
			aAdd(aExecAutod, aExecAutol)
		endif
		//ENDIF
	Next nId

	nPosCod := aScan(aExecAutol,{|x| x[1]=="DA1_CODPRO"})
	nPosPrc := aScan(aExecAutol,{|x| x[1]=="DA1_PRCVEN"})
	//nPosAti := aScan(aExecAutol,{|x| x[1]=="DA1_ATIVO"})

	ProcRegua(Len(aExecAutod))
			
	For nCnt:=1 To Len(aExecAutod)
		IncProc("Importando arquivo...")
		If nOperation == 3
			If nCnt == 1
				If oModelDA1:Length() > 1
					APMsgStop("Para executar a importacao da tabela de preco, nao deve existir nenhum item j� cadastrado.")
					lContinua := .F.
					Exit
				Endif
			Endif	
		Endif		
		lContinua := .F.
		//If IIf(nOperation == 4,oModelDA1:SeekLine({{"DA1_CODPRO",aExecAutod[nCnt][nPosCod][2]}}),oModelDA1:AddLine()>=Length())
		oModelDA1:GoLine(1)
		If oModelDA1:SeekLine({{"DA1_CODPRO",aExecAutod[nCnt][nPosCod][2]}})
			lContinua := .T.
		Elseif oModelDA1:AddLine() >= oModelDA1:Length()
			lContinua := .T.
		Endif
		If lContinua	
			//For nCnt1:=1 To Len(aExecAutod[nCnt])
				If IIf(nOperation==3,oModelDA1:SetValue("DA1_ITEM",StrZero(nCnt,TamSX3("DA1_ITEM")[1])),.T.)
					If oModelDA1:SetValue("DA1_CODPRO",aExecAutod[nCnt][nPosCod][2])
						If oModelDA1:SetValue("DA1_PRCVEN",aExecAutod[nCnt][nPosPrc][2])
							//If !oModelDA1:SetValue("DA1_ATIVO",aExecAutod[nCnt][nPosAti][2])
							//	lContinua := .F.	
							//	cConteudo := aExecAutod[nCnt][nPosAti][2]
							//Endif
							//oModelDA1:SetValue("DA1_DESCRI",Posicione("SB1",1,xFilial("SB1")+aExecAutod[nCnt][nPosCod][2],"B1_DESC"))
						Else
							//lContinua := .F.
							cConteudo := aExecAutod[nCnt][nPosPrc][2]
							cItem := oObj:GetErrorMessage()[6]+" - Conte�do do campo: "+cConteudo+chr(13)+chr(10)
							If !GravItem(@nDet,@cItem,@lGravou,nArq,@lErro)
								CloseTemp(nArq)
								Return()
							Endif
						Endif
					Else
						//lContinua := .F.	
						cConteudo := aExecAutod[nCnt][nPosCod][2]
						cItem := oObj:GetErrorMessage()[6]+" - Conte�do do campo: "+cConteudo+chr(13)+chr(10)
						If !GravItem(@nDet,@cItem,@lGravou,nArq,@lErro)
							CloseTemp(nArq)
							Return()
						Endif	
					Endif	
				Else
					//lContinua := .F.	
					cConteudo := StrZero(nCnt,TamSX3("DA1_ITEM")[1])
					cItem := oObj:GetErrorMessage()[6]+" - Conte�do do campo: "+cConteudo+chr(13)+chr(10)
					If !GravItem(@nDet,@cItem,@lGravou,nArq,@lErro)
						CloseTemp(nArq)
						Return()
					Endif	
				Endif	
			//Next			
			//If !lContinua
			//	Help( ,, 'Help',, oObj:GetErrorMessage()[6]+" - Conte�do do campo: "+cConteudo, 1, 0 )
			//	Exit
			//Endif	
		Else
				Help( ,, 'Help',, "Problemas na localizacao ou inclusao de novas linhas na Tabela de Pre�os", 1, 0 )
				Exit
		Endif
	Next	
		
	/*
	// Executa MSEXECAUTO
	lMsErroAuto := .F.
	//Begin Transaction
		
		Omsa010( aExecAuto, aExecAutod, 3 ) // SD0/SD1 Tabela de preco
	
		//Caso ocorra erro, verifica se ocorreu antes ou depois dos primeiros 100 registros do arquivo
		If lMsErroAuto
			aLog := {}
			aLog := GetAutoGRLog()
			If nI <= 100
				DisarmTransaction()
				cLogWritet += "Linha do erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
				//MostraErro()
				For nX :=1 to Len(aLog)
					cLogWritet += aLog[nX]+CRLF
				next nX
				MsgAlert(StrTran(cLogWritet,"< --","-->"),"Erro no arquivo!")
				cFilAnt := cBKFilial
				Return
			Else
				cLogWrite += "Linha com o erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
				For nX :=1 to Len(aLog)
					cLogWrite += aLog[nX]+CRLF
				next nX
			Endif
		EndIF
	//End Transaction
	*/
//Next nI

CloseTemp(nArq)

//Grava arquivo de LOG caso o erro ocorra depois do 100o registro
If !Empty(cLogWrite)
	cTime     := Time()
	cLogDir   := cGetFile("Arquivo |*.log", OemToAnsi("Informe o diretorio para gravar o LOG."), 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY ,.F.)
	cLogFile  := cLogDir+"IMP_"+substr(cTime,1,2)+substr(cTime,4,2)+substr(cTime,7,2)+".LOG"
	nHandle   := MSFCreate(cLogFile,0)
	FWrite(nHandle,cLogWrite)
	FClose(nHandle)
	msgAlert("LOG de erro gerado em "+cLogFile)
Else
	If lContinua
		If lErro
			APMsgAlert("Foram encontradas inconsist�ncias durante a importacao do arquivo .CSV."+CRLF+;
			"Consulte o arquivo de LOG: "+CRLF+;
			cArqTxt+CRLF+;
			CRLF+;
			"O arquivo foi importado parcialmente.")
		Else	
			MsgInfo("Arquivo importado com sucesso.")
		Endif	
	Else
		ApMsgStop("Problemas na atualizacao da Tabela de Pre�os. Saia da rotina sem Gravar as informacoes e verifique o arquivo usado na importacao!")
	Endif	
Endif
FT_FUSE()
cFilAnt := cBKFilial

Return


// rotina chamada pelo ponto de entrada M410STTS
User Function Fat03UsuAlt()

SC5->(RecLock("SC5",.F.))
SC5->C5_ZUSRALT := Alltrim(cUserName)+" - "+dToc(dDataBase)
SC5->(MsUnLock())

Return()


Static Function GravItem(nDet,cItem,lGravou,nArq,lErro)

Local lRet := .T.

lRet := ChkGrvFile(@nDet,@cItem,@lGravou,nArq,@lErro)	

Return(lRet)       


Static Function ChkGrvFile(nDet,cItem,lGravou,nArq,lErro)

nDet := Len(cItem)
lGravou := IIf(fWrite(nArq,cItem) == nDet,.T.,.F.)

If !lGravou
	APMsgStop("Erro ao gravar linha no arquivo de saida" + chr(13) + ;
	"Codigo do erro: " + AllTrim(Str(fError())), "ATENCAO" )
	Return(.F.)
Else
	lErro := .T.	
EndIf
         
Return(.T.)


Static Function CloseTemp(nArq)

If nArq <> Nil
	If nArq <> 0
		If !fClose(nArq) 
			APMsgStop("Nao foi possivel finalizar o arquivo de saida! Codigo do erro: " + AllTrim(Str(fError())),"Stop")
		EndIf
	Endif	
Endif
	
Return()

//----------------------------------------------------------
// Verifica se Produto existe e nao esta bloqueado
//----------------------------------------------------------
static function chkSB1( cB1Prod )
	local lRetSB1	:= .F.
	local cQrySB1	:= ""
	local aArea		:= getArea()
	local aAreaDA0	:= DA0->(getArea())
	local aAreaDA1	:= DA1->(getArea())

	cQrySB1 := "SELECT B1_COD"
	cQrySB1 += " FROM " + retSQLName("SB1") + " SB1"
	cQrySB1 += " WHERE"
	cQrySB1 += " 		SB1.B1_MSBLQL	<>	'1'"
	cQrySB1 += " 	AND	SB1.B1_COD		=	'" + cB1Prod		+ "'"
	cQrySB1 += " 	AND	SB1.B1_FILIAL	=	'" + xFilial("SB1")	+ "'"
	cQrySB1 += " 	AND	SB1.D_E_L_E_T_	<>	'*'"

	tcQuery cQrySB1 New Alias "QRYSB1"

	if !QRYSB1->(EOF())
		lRetSB1 := .T.
	endif

	QRYSB1->(DBCloseArea())

	restArea(aAreaDA1)
	restArea(aAreaDA0)
	restArea(aArea)
return lRetSB1

/*==================================================================================+
|  Funcao de Usuario ..:   VldTpOpPV( cTpOper )                                     |
|  Autor ..............:   johnny.osugi@totvspartners.com.br                        |
|  Data ...............:   19/10/2018                                               |
|  Descricao / Objetivo:   Funcao que valida o tipo de operacao de acordo com o     |
|                          campo do PV "Tipo". Valida se o codigo do tipo de opera- |
|                          cao esta' de acordo com o tipo do PV.                    |
|  Observacao .........:   Funcao de validacao de usuario do campo C5_ZTPOPER.      |
+==================================================================================*/
User Function VldTpOpPV( cTpOper )
Local aArea := GetArea()
Local lRet  := .T.

/*------------------------------------+
| Checa a existencia do cadastro ZBL  |
+------------------------------------*/
ZBL->( DbGoTop() ) // Posiciona no topo do ZBL
If ZBL->( EoF() ) // Se for EoF e' porque o ZBL esta' vazio e devera' pegar a tabela DJ para alimentar o ZBL.
   Apd_ZBL()
EndIf

If .not. Empty( cTpOper )
   ZBL->( DbSetOrder ( 1 ) ) // ZBL_FILIAL + ZBL_TPOPER
   If ZBL->( DbSeek( xFilial( "ZBL" ) + cTpOper ) )
      If ZBL->ZBL_TIPOPV <> M->C5_TIPO
         MsgAlert( OEMToANSI( "O Tipo de Operacao selecionado alimenta estoque em terceiro. Favor alterar o Tipo Pedido para: B � Utiliza Fornecedor." ) )
         lRet := .F.         
      EndIf
   Else
      MsgAlert( OEMToANSI( "Tipo de Operacao nao encontrado. Favor verificar." ) )
      lRet := .F.
   EndIf
EndIf

RestArea( aArea )
Return( lRet )

/*===================================================================================+
|  Programa............:   Apd_ZBL                                                   |
|  Autor...............:   johnny.osugi@totvspartners.com.br                         |
|  Data................:   16/10/2018                                                |
|  Descricao / Objetivo:   "Append" da tabela DJ para a ZBL.                         | 
|  Doc. Origem.........:                                                             |
|  Solicitante.........:                                                             |
|  Uso.................:                                                      |
|  Obs.................:                                                             |
+===================================================================================*/
Static Function Apd_ZBL()
Local aArea  := GetArea()
Local aTpOp  := {}
Local aTpOp1 := {}

/*---------------------------------------------------------------------------------------+
| Array aTpOp cujos codigos de Tipo de Operacao para o Tipo de PV "B-Utiliza Fornecedor" |
+---------------------------------------------------------------------------------------*/
aAdd( aTpOp,  { "AH","AP","AQ","AR","AS","AT","AU","AV","BS","CA","CS" } )

/*---------------------------------------------------------------------------------------+
| Array aTpOp1 cujos codigos de Tipo de Operacao para o Tipo de PV "N-Normal"            |
+---------------------------------------------------------------------------------------*/
aAdd( aTpOp1, { "01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25",;
                "26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50",;
                "51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75",;
                "76","AA","AB","AC","AD","AE","AF","AG","AI","AJ","AK","AL","AM","AN","AO","AX","AY","AZ","BA","BB","BC","BD","BE","BF","BG",;
                "BH","BI","BJ","BK","BL","BM","BN","BO","BP","BQ","BR","BT","BU","BV","BW","BX","BY","BZ","CB","CC","CD","CE","CF","CG","CH",;
                "CI","CJ","CK","CL","CM","CN","CO","CP","CQ","CR","T1","T2","T3","T4","T5","T7","T8","T9" } )

DbSelectArea( "SX5" )
SX5->( DbSetOrder( 1 ) ) // X5_FILIAL + X5_TABELA + X5_CHAVE

If SX5->( DbSeek( xFilial( "SX5" ) + "DJ" ) )
   Do While SX5->( .not. EoF() ) .and. SX5->( X5_FILIAL + X5_TABELA ) == xFilial( "SX5" ) + "DJ"
      RecLock( "ZBL", .T. ) // Inclusao de registro no ZBL
      Replace ZBL->ZBL_FILIAL With xFilial( "ZBL" )
      Replace ZBL->ZBL_TPOPER With SX5->X5_CHAVE
      Replace ZBL->ZBL_DESCOP With Upper( SX5->X5_DESCRI )
      ZBL->( MsUnlock() ) // Grava e libera o registro incluido
      SX5->( DbSkiP() ) // Avanca SX5
   EndDo

   /*------------------------------------------------------+
   | Area de ajustes do campo ZBL_TIPOPV para as operacoes |
   | do tipo PV "B-Utiliza Fornecedor".                    |
   +------------------------------------------------------*/
   ZBL->( DbSetOrder( 1 ) ) // ZBL_FILIAL + ZBL_TPOPER
   For nX := 1 To Len( aTpOp[ 1 ] )
       If DbSeek(  xFilial( "ZBL" ) + aTpOp[ 1 ][ nX ]  )
          RecLock( "ZBL", .F. ) // Bloqueio de registro do ZBL
          Replace ZBL->ZBL_TIPOPV With "B" // B-Utiliza Fornecedor
          ZBL->( MsUnlock() ) // Grava e libera o registro incluido
       EndIf
   NexT

   /*------------------------------------------------------+
   | Area de ajustes do campo ZBL_TIPOPV para as operacoes |
   | do tipo PV "N-Normal".                                |
   +------------------------------------------------------*/
   ZBL->( DbSetOrder( 1 ) ) // ZBL_FILIAL + ZBL_TPOPER
   For nX := 1 To Len( aTpOp1[ 1 ] )
       If DbSeek(  xFilial( "ZBL" ) + aTpOp1[ 1 ][ nX ]  )
          RecLock( "ZBL", .F. ) // Bloqueio de registro do ZBL
          Replace ZBL->ZBL_TIPOPV With "N" // N-Normal
          ZBL->( MsUnlock() ) // Grava e libera o registro incluido
       EndIf
   NexT
EndIf

RestArea( aArea )
Return( Nil )
