#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
=====================================================================================
Programa.:              MGFFIN45
Autor....:              Atilio Amarilla
Data.....:              22/12/2017
Descricao / Objetivo:   Op��o de busca de t�tulos na grid
Doc. Origem:            Contrato - GAP CRE019/20/21
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Transa��es referentes a Banco/Carteira FIDC
=====================================================================================
*/

User Function MGFFIN71()
	
	Local cFilRec	:= Space(TamSX3("E1_FILIAL")[1])
	Local cNumTit	:= Space(TamSX3("E1_NUM")[1])
	Local cParTit	:= Space(TamSX3("E1_PARCELA")[1])
	
	Local aRet		:= {}
	Local cQuery, nI
	Local aArea		//:= GetArea()
	local lContinua	:= .T.
	Local cAlias	:= GetNextAlias()
	
	Local oModel	:= FwModelActive()
	Local oMdlZA7	:= oModel:GetModel('ZA7MASTER')
	Local oMdlZA8	:= oModel:GetModel('ZA8GRID')
	Local nLinha	:= oMdlZA8:Length()
	
	Local nI, lNumTit
	
	Local aPergs	:= {}
	
	Local aSaveLines
	
	aArea	:= GetArea()
	/*
	1 - MsGet
	[2] : Descri��o
	[3] : String contendo o inicializador do campo
	[4] : String contendo a Picture do campo
	[5] : String contendo a valida��o
	[6] : Consulta F3
	[7] : String contendo a valida��o When
	[8] : Tamanho do MsGet
	[9] : Flag .T./.F. Par�metro Obrigat�rio ?
	2 - Combo
	[2] : Descri��o
	[3] : Num�rico contendo a op��o inicial do combo
	[4] : Array contendo as op��es do Combo
	[5] : Tamanho do Combo
	[6] : Valida��o
	[7] : Flag .T./.F. Par�metro Obrigat�rio ?
	*/
	
	//While lContinua
	
	aPergs := {}
	
	aAdd( aPergs ,{1,"Filial do T�tulo ",cFilRec,"@!",'.T.'	,'SM0','.T.',30,.T.})
	aAdd( aPergs ,{1,"N�mero do T�tulo ",cNumTit,"@!",'.T.'	,,'.T.',50,.T.})
	aAdd( aPergs ,{1,"Parcela do T�tulo ",cParTit,"@!",'.T.'	,,'.T.',30,.F.})
	
	If !ParamBox(aPergs ,"Parametros FIDC - Busca de T�tulo",aRet)
		Aviso("FIDC - Busca de T�tulo","Processamento Cancelado!",{'Ok'})
		lContinua	:= .F.
	Else
		lNumTit := .F.
		
		aSaveLine  := FWSaveRows()
		
		For nI := 1� to oMdlZA8:Length()
			oMdlZA8:GoLine(nI)
			If aRet[1] == oMdlZA8:GetValue('ZA8_FILORI') .And. aRet[2] == oMdlZA8:GetValue('ZA8_NUM') .And. aRet[3] == oMdlZA8:GetValue('ZA8_PARCEL')
				lNumTit := .T.
				Exit
			EndIf
		Next nI
		
		If !lNumTit
		
			Aviso("FIDC - Busca de T�tulo","Filial/T�tulo/Parcela n�o encontrado!",{'Ok'})
			
		EndIf
	EndIf
	
	
	
Return

