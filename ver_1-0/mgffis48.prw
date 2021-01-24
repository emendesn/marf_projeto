#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH' 

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFFIS48 - Função chamado pelo PE MTA103OK
RITM0020720 ST 33722 - Melhorias nota técnica 2018.005 - Validação CST60 no Doc de Entrada.

Nas operações de Entrada em que ICMS foi recolhido anteriormente e não existe 
destaque na nota recebida, o usuário deverá preencher manualmente os campos 
do documento de entrada (D1_BASNDES, D1_ALQNDES e D1_ICMNDES). Como estes 
valores são obrigatórios na saída, a área fiscal solicita verificar a possibilidade 
de ser obrigatório o preenchimento destes campos no registro da nota fiscal de 
entrada quando a TES tiver o CST de entrada 60

@author Natanael Simões
@since 26/04/2019
@version P12.1.17
/*/
//-------------------------------------------------------------------
User Function MGFFIS48()
	
	Local lRet			:= .T.
	Local aRotInc 		:= STRTOKARR(SuperGetMV('MGF_FIS48R',.F.,''),';') //Rotinas de entrada que NÃO passarão pela validação. Separados por ponto e virgula ';'.
	Local _lClassif 	:= SuperGetMV('MGF_FIS48C',.F.,.T.) 	//Define se a validação será apenas para classificação (.T.) do Documento ou para todas as entradas (.F.).
	Local lContinua 	:= .T. // Define se a função deve continuar sendo executada.
		
	Local cTitHelp		:= "Campos não preenchidos." //Título para o help
	Local cPrbHelp		:= "Campos não informados ou zerados: D1_BASNDES, D1_ALQNDES e D1_ICMNDES." //Descrição do problema do help
	Local cSolHelp		:= "Nas operações de Entrada em que ICMS foi recolhido anteriormente e não existe " + ; //Descrição do problema do help	
							"destaque na nota recebida, o usuário deverá preencher manualmente os campos "  + ;
							"do documento de entrada." 
	
	Local nPosCST		:= 0 //Posição D1_CLASFIS no aCols
	Local nPosBase		:= 0 //Posição D1_BASNDES no aCols
	Local nPosAliq		:= 0 //Posição D1_ALQNDES no aCols
	Local nPosICM		:= 0 //Posição D1_ICMNDES no aCols
	
	//Verifica se as rotinas que devem passar pela validação estão na pilha de chamada para continuar
	For nCnt := 1 To Len(aRotInc)
		If IsInCallStack(Alltrim(aRotInc[nCnt]))
			lContinua := .F. //Se não estiver na pilha, retorna o array sem alterações
			EXIT
		Else
			lContinua := .T.
		EndIf
	Next
	
	//Verifica se validará apenas as classificação do Doc.
	If lContinua .AND. _lClassif .AND. !(l103Class)
		lContinua := .F.
	EndIf
		
	
	//Define se a validação será executada após analise dos parâmetros.
	If !lContinua
		Return lRet
	EndIf
	
	//Localiza a posição de cada campo D1_CLASFIS,D1_BASNDES,D1_ALQNDES e D1_ICMNDES
	nPosCST		:= aScan(aHeader,{|x|AllTrim(x[2])=="D1_CLASFIS"})
	nPosBase	:= aScan(aHeader,{|x|AllTrim(x[2])=="D1_BASNDES"})
	nPosAliq	:= aScan(aHeader,{|x|AllTrim(x[2])=="D1_ALQNDES"})
	nPosICM		:= aScan(aHeader,{|x|AllTrim(x[2])=="D1_ICMNDES"})
	
	//Aplica a regra de validação.
	If nPosCST > 0 .AND. nPosBase > 0 .AND. nPosAliq > 0 .AND. nPosICM > 0
		If Right(aCols[n][nPosCST],2) = "60"
			If aCols[n][nPosBase] = 0;
				.OR. aCols[n][nPosAliq] = 0;
				.OR. aCols[n][nPosICM] = 0
				
				lRet := .F.
				If isBlind() //Verifica se a rotina está sendo executada por interface gráfica
					conOut(cTitHelp)
					conOut(cPrbHelp)
					conOut(cSolHelp)
				Else
					Help( ,, cTitHelp, , cPrbHelp, 1, 0, , , , , , {cSolHelp})
				EndIf
			EndIf
		EndIf
	EndIf
Return lRet