#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
=====================================================================================
Programa.:              MGFFIN45
Autor....:              Atilio Amarilla
Data.....:              22/12/2017
Descricao / Objetivo:   Opção de busca de títulos na grid
Doc. Origem:            Contrato - GAP CRE019/20/21
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Transações referentes a Banco/Carteira FIDC
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
	[2] : Descrição
	[3] : String contendo o inicializador do campo
	[4] : String contendo a Picture do campo
	[5] : String contendo a validação
	[6] : Consulta F3
	[7] : String contendo a validação When
	[8] : Tamanho do MsGet
	[9] : Flag .T./.F. Parâmetro Obrigatório ?
	2 - Combo
	[2] : Descrição
	[3] : Numérico contendo a opção inicial do combo
	[4] : Array contendo as opções do Combo
	[5] : Tamanho do Combo
	[6] : Validação
	[7] : Flag .T./.F. Parâmetro Obrigatório ?
	*/
	
	//While lContinua
	
	aPergs := {}
	
	aAdd( aPergs ,{1,"Filial do Título ",cFilRec,"@!",'.T.'	,'SM0','.T.',30,.T.})
	aAdd( aPergs ,{1,"Número do Título ",cNumTit,"@!",'.T.'	,,'.T.',50,.T.})
	aAdd( aPergs ,{1,"Parcela do Título ",cParTit,"@!",'.T.'	,,'.T.',30,.F.})
	
	If !ParamBox(aPergs ,"Parametros FIDC - Busca de Título",aRet)
		Aviso("FIDC - Busca de Título","Processamento Cancelado!",{'Ok'})
		lContinua	:= .F.
	Else
		lNumTit := .F.
		
		aSaveLine  := FWSaveRows()
		
		For nI := 1  to oMdlZA8:Length()
			oMdlZA8:GoLine(nI)
			If aRet[1] == oMdlZA8:GetValue('ZA8_FILORI') .And. aRet[2] == oMdlZA8:GetValue('ZA8_NUM') .And. aRet[3] == oMdlZA8:GetValue('ZA8_PARCEL')
				lNumTit := .T.
				Exit
			EndIf
		Next nI
		
		If !lNumTit
		
			Aviso("FIDC - Busca de Título","Filial/Título/Parcela não encontrado!",{'Ok'})
			
		EndIf
	EndIf
	
	
	
Return

