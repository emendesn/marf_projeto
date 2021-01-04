#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
=====================================================================================
Programa.:              MGFFIN45
Autor....:              Atilio Amarilla
Data.....:              22/12/2017
Descricao / Objetivo:   Opcao de busca de titulos na grid
Doc. Origem:            Contrato - GAP CRE019/20/21
Solicitante:            Cliente
Uso......:              
Obs......:              Transacoes referentes a Banco/Carteira FIDC
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
	[2] : Descricao
	[3] : String contendo o inicializador do campo
	[4] : String contendo a Picture do campo
	[5] : String contendo a validacao
	[6] : Consulta F3
	[7] : String contendo a validacao When
	[8] : Tamanho do MsGet
	[9] : Flag .T./.F. Parametro Obrigatorio ?
	2 - Combo
	[2] : Descricao
	[3] : Numerico contendo a opcao inicial do combo
	[4] : Array contendo as opcoes do Combo
	[5] : Tamanho do Combo
	[6] : Validacao
	[7] : Flag .T./.F. Parametro Obrigatorio ?
	*/
	
	//While lContinua
	
	aPergs := {}
	
	aAdd( aPergs ,{1,"Filial do Titulo ",cFilRec,"@!",'.T.'	,'SM0','.T.',30,.T.})
	aAdd( aPergs ,{1,"Numero do Titulo ",cNumTit,"@!",'.T.'	,,'.T.',50,.T.})
	aAdd( aPergs ,{1,"Parcela do Titulo ",cParTit,"@!",'.T.'	,,'.T.',30,.F.})
	
	If !ParamBox(aPergs ,"Parametros FIDC - Busca de Titulo",aRet)
		Aviso("FIDC - Busca de Titulo","Processamento Cancelado!",{'Ok'})
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
		
			Aviso("FIDC - Busca de Titulo","Filial/Titulo/Parcela nao encontrado!",{'Ok'})
			
		EndIf
	EndIf
	
	
	
Return

