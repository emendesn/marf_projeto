#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH' 

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFFIS48 - Fun��o chamado pelo PE MTA103OK
RITM0020720 ST 33722 - Melhorias nota t�cnica 2018.005 - Valida��o CST60 no Doc de Entrada.

Nas opera��es de Entrada em que ICMS foi recolhido anteriormente e n�o existe 
destaque na nota recebida, o usu�rio dever� preencher manualmente os campos 
do documento de entrada (D1_BASNDES, D1_ALQNDES e D1_ICMNDES). Como estes 
valores s�o obrigat�rios na sa�da, a �rea fiscal solicita verificar a possibilidade 
de ser obrigat�rio o preenchimento destes campos no registro da nota fiscal de 
entrada quando a TES tiver o CST de entrada 60

@author Natanael Sim�es
@since 26/04/2019
@version P12.1.17
/*/
//-------------------------------------------------------------------
User Function MGFFIS48()
	
	Local lRet			:= .T.
	Local aRotInc 		:= STRTOKARR(SuperGetMV('MGF_FIS48R',.F.,''),';') //Rotinas de entrada que N�O passar�o pela valida��o. Separados por ponto e virgula ';'.
	Local _lClassif 	:= SuperGetMV('MGF_FIS48C',.F.,.T.) 	//Define se a valida��o ser� apenas para classifica��o (.T.) do Documento ou para todas as entradas (.F.).
	Local lContinua 	:= .T. // Define se a fun��o deve continuar sendo executada.
		
	Local cTitHelp		:= "Campos n�o preenchidos." //T�tulo para o help
	Local cPrbHelp		:= "Campos n�o informados ou zerados: D1_BASNDES, D1_ALQNDES e D1_ICMNDES." //Descri��o do problema do help
	Local cSolHelp		:= "Nas opera��es de Entrada em que ICMS foi recolhido anteriormente e n�o existe " + ; //Descri��o do problema do help	
							"destaque na nota recebida, o usu�rio dever� preencher manualmente os campos "  + ;
							"do documento de entrada." 
	
	Local nPosCST		:= 0 //Posi��o D1_CLASFIS no aCols
	Local nPosBase		:= 0 //Posi��o D1_BASNDES no aCols
	Local nPosAliq		:= 0 //Posi��o D1_ALQNDES no aCols
	Local nPosICM		:= 0 //Posi��o D1_ICMNDES no aCols
	
	//Verifica se as rotinas que devem passar pela valida��o est�o na pilha de chamada para continuar
	For nCnt := 1 To Len(aRotInc)
		If IsInCallStack(Alltrim(aRotInc[nCnt]))
			lContinua := .F. //Se n�o estiver na pilha, retorna o array sem altera��es
			EXIT
		Else
			lContinua := .T.
		EndIf
	Next
	
	//Verifica se validar� apenas as classifica��o do Doc.
	If lContinua .AND. _lClassif .AND. !(l103Class)
		lContinua := .F.
	EndIf
		
	
	//Define se a valida��o ser� executada ap�s analise dos par�metros.
	If !lContinua
		Return lRet
	EndIf
	
	//Localiza a posi��o de cada campo D1_CLASFIS,D1_BASNDES,D1_ALQNDES e D1_ICMNDES
	nPosCST		:= aScan(aHeader,{|x|AllTrim(x[2])=="D1_CLASFIS"})
	nPosBase	:= aScan(aHeader,{|x|AllTrim(x[2])=="D1_BASNDES"})
	nPosAliq	:= aScan(aHeader,{|x|AllTrim(x[2])=="D1_ALQNDES"})
	nPosICM		:= aScan(aHeader,{|x|AllTrim(x[2])=="D1_ICMNDES"})
	
	//Aplica a regra de valida��o.
	If nPosCST > 0 .AND. nPosBase > 0 .AND. nPosAliq > 0 .AND. nPosICM > 0
		If Right(aCols[n][nPosCST],2) = "60"
			If aCols[n][nPosBase] = 0;
				.OR. aCols[n][nPosAliq] = 0;
				.OR. aCols[n][nPosICM] = 0
				
				lRet := .F.
				If isBlind() //Verifica se a rotina est� sendo executada por interface gr�fica
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