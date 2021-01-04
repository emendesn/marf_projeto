#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM10
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              05/04/2017
Descricao / Objetivo:   Importacao de Metas para ACU
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              
Obs......:              

Layout do arquivo a ser importado:
COD CATEGORIA|META1|META2|META3|META4|META5|META6|META7|META8|META9|META10
000001|1500|X|X|2000|6000|X|X|X|3000|X

COD CATEGORIA;META1;META2;META3;META4;META5;META6;META7;META8;META9;META10
000001;1500;X;X;2000;6000;X;X;X;3000;X

Metas nao informadas devem ser substituidas por X
=====================================================================================
*/
user function MGFCRM10()
	if getParam()
		fwMsgRun(, {|oSay| procArq( oSay ) }, "Processando arquivo", "Aguarde. Processando arquivo..." )
	endif
return

//-----------------------------------------------------
//-----------------------------------------------------
static function getParam()
	local aRet			:= {}
	local aParambox		:= {}

	aadd(aParambox, {6, "Selecione o arquivo"	, space(100), "@!"	, ""	, ""	, 070, .T., "Arquivos .CSV |*.CSV", GetTempPath(), GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE, .F. /*NAO MOSTRA SERVIDOR*/})

return paramBox(aParambox, "Importacao de Metas"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)

//-----------------------------------------------------
//-----------------------------------------------------
static function procArq()
	local aArea		:= getArea()
	local aAreaACU	:= ACU->(getArea())
	local cLinha	:= ""
	local nNewStr	:= ""
	local nOpen		:= FT_FUSE(AllTrim(MV_PAR01))
	local nLast		:= 0
	local nLinAtu	:= 0
	local aLinha	:= {}

	local nI		:= 0

	DBSelectArea("ACU")

	ACU->(DBSetOrder(1))

	if nOpen < 0
		Alert("Falha na abertura do arquivo.")
	else
		FT_FGOTOP()
		nLast := FT_FLastRec()
		FT_FGOTOP()

		do while !FT_FEOF()
			nLinAtu++
			cLinha := ""
			cLinha := FT_FREADLN()
			aLinha := {}
			aLinha := strTokArr(cLinha, ";")

			ACU->(DBGoTop())
			if ACU->(DBSeek( xFilial("ACU") + aLinha[1] ))
				importACU(aLinha)
			else
				// gera log
			endif

			FT_FSKIP()
		enddo
	endif

	restArea(aAreaACU)
	restArea(aArea)
return

//-----------------------------------------------------
//-----------------------------------------------------
static function importACU(aLinha)
	local oModel, oAux, oStruct
	local nI		:= 0
	local nJ		:= 0
	local nPos		:= 0
	local lRet		:= .T.
	local aAux		:= {}
	local aC		:= {}
	local aH		:= {}
	local nItErro	:= 0
	local lAux		:= .T.
	local aCampos	:= {}
    local cError    := ''

	aCampos := {}

	for nI := 2 to len(aLinha)
		if nI == 2
			if aLinha[nI] <> "X"
				aadd( aCampos, { 'ACU_ZMETA1'	, val(aLinha[nI]) } )
			endif
		elseif nI == 3
			if aLinha[nI] <> "X"
				aadd( aCampos, { 'ACU_ZMETA2'	, val(aLinha[nI]) } )
			endif
		elseif nI == 4
			if aLinha[nI] <> "X"
				aadd( aCampos, { 'ACU_ZMETA3'	, val(aLinha[nI]) } )
			endif
		elseif nI == 5
			if aLinha[nI] <> "X"
				aadd( aCampos, { 'ACU_ZMETA4'	, val(aLinha[nI]) } )
			endif
		elseif nI == 6
			if aLinha[nI] <> "X"
				aadd( aCampos, { 'ACU_ZMETA5'	, val(aLinha[nI]) } )
			endif
		elseif nI == 7
			if aLinha[nI] <> "X"
				aadd( aCampos, { 'ACU_ZMETA6'	, val(aLinha[nI]) } )
			endif
		elseif nI == 8
			if aLinha[nI] <> "X"
				aadd( aCampos, { 'ACU_ZMETA7'	, val(aLinha[nI]) } )
			endif
		elseif nI == 9
			if aLinha[nI] <> "X"
				aadd( aCampos, { 'ACU_ZMETA8'	, val(aLinha[nI]) } )
			endif
		elseif nI == 10
			if aLinha[nI] <> "X"
				aadd( aCampos, { 'ACU_ZMETA9'	, val(aLinha[nI]) } )
			endif
		elseif nI == 11
			if aLinha[nI] <> "X"
				aadd( aCampos, { 'ACU_ZMET10'	, val(aLinha[nI]) } )
			endif
		endif
	next

	// Aqui ocorre o instanciamento do modelo de dados (Model)
	// Neste exemplo instanciamos o modelo de dados do fonte COMP022_MVC
	// que � a rotina de manutencao de musicas
	oModel := FWLoadModel( 'FATA140' )

	// Temos que definir qual a operacao deseja: 3 � Inclusao / 4 � Alteracao / 5 - Exclusao
	oModel:SetOperation( 4 )

	// Antes de atribuirmos os valores dos campos temos que ativar o modelo
	oModel:Activate()

	// Instanciamos apenas a parte do modelo referente aos dados de cabecalho
	oAux    := oModel:GetModel( 'ACUMASTER' )

	// Obtemos a estrutura de dados do cabecalho
	oStruct := oAux:GetStruct()
	aAux	:= oStruct:GetFields()

	For nI := 1 To Len( aCampos )
		// Verifica se os campos passados existem na estrutura do cabecalho
		If ( nPos := aScan( aAux, { |x| AllTrim( x[3] ) ==  AllTrim( aCampos[nI][1] ) } ) ) > 0

			If !( lAux := oModel:SetValue( 'ACUMASTER', aCampos[nI][1], aCampos[nI][2] ) )
				lRet    := .F.
				Exit
			EndIf
		EndIf
	Next

	If lRet
		// Faz-se a validacao dos dados, note que diferentemente das tradicionais "rotinas automaticas"
		// neste momento os dados nao sao gravados, sao somente validados.
		If ( lRet := oModel:VldData() )
			// Se o dados foram validados faz-se a gravacao efetiva dos dados (commit)
			lRet := oModel:CommitData()
		EndIf
	EndIf

	If !lRet
		// Se os dados nao foram validados obtemos a descricao do erro para gerar LOG ou mensagem de aviso
		aErro   := oModel:GetErrorMessage()
		// A estrutura do vetor com erro �:
		//  [1] Id do formulario de origem
		//  [2] Id do campo de origem
		//  [3] Id do formulario de erro
		//  [4] Id do campo de erro
		//  [5] Id do erro
		//  [6] mensagem do erro
		//  [7] mensagem da solucao
		//  [8] Valor atribuido
		//  [9] Valor anterior
	
		AutoGrLog( "Id do formulario de origem:" + ' [' + AllToChar( aErro[1]  ) + ']' )
		AutoGrLog( "Id do campo de origem:     " + ' [' + AllToChar( aErro[2]  ) + ']' )
		AutoGrLog( "Id do formulario de erro:  " + ' [' + AllToChar( aErro[3]  ) + ']' )
		AutoGrLog( "Id do campo de erro:       " + ' [' + AllToChar( aErro[4]  ) + ']' )
		AutoGrLog( "Id do erro:                " + ' [' + AllToChar( aErro[5]  ) + ']' )
		AutoGrLog( "Mensagem do erro:          " + ' [' + AllToChar( aErro[6]  ) + ']' )
		AutoGrLog( "Mensagem da solucao:       " + ' [' + AllToChar( aErro[7]  ) + ']' )
		AutoGrLog( "Valor atribuido:           " + ' [' + AllToChar( aErro[8]  ) + ']' )
		AutoGrLog( "Valor anterior:            " + ' [' + AllToChar( aErro[9]  ) + ']' )

		If nItErro > 0
			AutoGrLog( "Erro no Item:              " + ' [' + AllTrim( AllToChar( nItErro  ) ) + ']' )
		EndIf

		If (!IsBlind()) // COM INTERFACE GRAFICA
		MostraErro()
	    Else // EM ESTADO DE JOB
	        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
	
	        ConOut(PadC("Automatic routine ended with error", 80))
	        ConOut("Error: "+ cError)
	    EndIf
	ELSE
		conout("MGFCRM10 -> Registro incluido")
	EndIf

	// Desativamos o Model
	oModel:DeActivate()

return
