#INCLUDE "rwmake.ch"       

/*
=====================================================================================
Programa.:              MGFFINX3
Autor....:              Flávio Dentello
Data.....:              07/11/2016
Descricao / Objetivo:   AO REALIZAR A BAIXAR DO TÍTULO, GRAVAR NO CAMPO E5_HISTOR O;
NOME DO BANCO SELECIONADO 
Doc. Origem:            GAP FIN_CRE003_V2
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
User Function MGFFINX3()  

Local cHist := ""
Local _cAlias := GetArea()
Local cAliasSA6 := SA6->(GetArea())
Local cAliasSE5 := SE5->(GetArea())              
Local cChave    := SE5->E5_FILIAL+SE5->E5_IDORIG

DbSelectArea("SA6")
SA6->(DbSetOrder(1)) //A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON
SA6->(DbSeek(xFilial("SA6")+ cBanco+cAgencia+cConta))
cNome := SA6->A6_ZNOME
	
    
If IsInCallStack("U_MGFFIN66")
	cQuery := " Update "+RetSqlName("SE5")
	cQuery += " Set E5_ZNOME   = '"+cNome+"',"
	cQuery += "     E5_ZLOTEBX = '"+SubSTR(cHist070,20,10)+"'"
	cQuery += " Where E5_FILIAL  = '"+SE5->E5_FILIAL+"'"
	cQuery += "   AND E5_IDORIG  = '"+SE5->E5_IDORIG+"'"
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	IF (TcSQLExec(cQuery) < 0)
		conOut(TcSQLError())
	EndIF
Else
	cHist := ""
	cHist := ALLTRIM(cHist070) + SPACE(1) +"/" + SPACE(1) +ALLTRIM(SA6->A6_ZNOME)
	DbSelectArea("SE5")
	SE5->(DbSetOrder(21)) //E5_FILIAL+E5_IDORIG+E5_TIPODOC
	If SE5->(dbSeek(SE5->E5_FILIAL+SE5->E5_IDORIG))
		While SE5->(!EOF()) .AND. SE5->E5_FILIAL+SE5->E5_IDORIG == cChave
			IF Alltrim(SE5->E5_ORIGEM) <>'MGFFIN66' // Colocado por Carneiro
				RecLock('SE5',.F.)
				SE5->E5_HISTOR := cHist
				SE5->E5_ZNOME := cNome
				SE5->(MsUnlock())
			EndIF
			SE5->(DbSkip())
		Enddo
	Endif
EndIF
RestArea(cAliasSE5)
RestArea(cAliasSA6)
RestArea(_cAlias)

Return  

///****************************************************************///
///Função que retorna o nome do Banco para o campo virtual da SE1  ///
///****************************************************************///

User Function MGFNOME()  

	/*Local cNome := ""

	dBselectArea("SEA")
	SEA->(dbSetOrder(1))//EA_FILIAL+EA_NUMBOR+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA
	If SEA->(dbSeek(xFilial("SEA") + SE1->E1_NUMBOR + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO))
		dbSelectArea('SA6')
		SA6->(dbSetOrder(1))//A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON
		If SA6->(dbSeek(xFilial("SA6") + SEA->EA_PORTADO + SEA->EA_AGEDEP + SEA->EA_NUMCON)) 
			cNome := Alltrim(SA6->A6_ZNOME)
		EndIf
	Else 
		dbSelectArea('SA6')
		SA6->(dbSetOrder(1))//A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON
		If SA6->(dbSeek(xFilial("SA6") + SE1->E1_PORTADO + SE1->E1_AGEDEP + SE1->E1_CONTA)) 
			cNome := Alltrim(SA6->A6_ZNOME)
		EndIf
	EndIf*/

Return POSICIONE('SA6',1,xFilial("SA6",SE1->E1_FILIAL) + SE1->(E1_PORTADO + E1_AGEDEP + E1_CONTA),'A6_ZNOME')//cNome                     


///******************************************************************///
///Função que retorna a agência e dígito para o campo virtual da SE1 ///
///******************************************************************///

User Function MGFAGEN()  

	Local cAgenc := ""

	dBselectArea('SEA')
	SEA->(dbSetOrder(1))//EA_FILIAL+EA_NUMBOR+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA
	If SEA->(dbSeek(xFilial("SEA")+SE1->E1_NUMBOR+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO))

		dBselectArea('SA6')
		SE6->(dbSetOrder(1))//A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON
		If SA6->(dbSeek(xFilial("SA6")+SEA->EA_PORTADO+SEA->EA_AGEDEP+SEA->EA_NUMCON)) 

			cAgenc := SA6->A6_AGENCIA + "-" +SA6->A6_DVAGE
			E1_ZAGENCI := cAgenc 

		EndIf

	Else

		dBselectArea('SA6')
		SE6->(dbSetOrder(1))//A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON
		If SA6->(dbSeek(xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA)) 

			cAgenc := SA6->A6_AGENCIA + "-" +SA6->A6_DVAGE
			E1_ZAGENCI := cAgenc 

		EndIf
	EndIf

Return cAgenc

///****************************************************************///
///Função que retorna a Conta e dígito para o campo virtual da SE1 ///
///****************************************************************///

User Function MGFCONTA()  

	Local cConta := ""

	dBselectArea('SEA')
	SEA->(dbSetOrder(1))//EA_FILIAL+EA_NUMBOR+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA
	If SEA->(dbSeek(xFilial("SEA")+SE1->E1_NUMBOR+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO))

		dBselectArea('SA6')
		SE6->(dbSetOrder(1))//A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON
		If SA6->(dbSeek(xFilial("SA6")+SEA->EA_PORTADO+SEA->EA_AGEDEP+SEA->EA_NUMCON)) 

			cConta := SA6->A6_NUMCON + "-" + SA6->A6_DVCTA

		EndIf

	Else

		dBselectArea('SA6')
		SE6->(dbSetOrder(1))//A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON
		If SA6->(dbSeek(xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA)) 

			cConta := SA6->A6_NUMCON + "-" + SA6->A6_DVCTA        

		EndIf
	EndIf

Return cConta

/*              
//********************************************************************************************
//Chamada do ponto de entrada FC010bxHe que retorna o nome da conta na consulta do cliente////
//********************************************************************************************
*/  

User Function U_MGFIN43()

	LOCAL aHeader :=ParamIxb
	LOCAL aArea:=GETAREA()

	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("E5_ZNOME")

	aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )

	RestArea(aArea)

Return aHeader