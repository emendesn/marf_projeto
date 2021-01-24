#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM43
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              05/07/2017
Descricao / Objetivo:   Importa CSV Categoria de Produtos
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:

Layout esperado do CSV:

COD_CATEGORIA;DESC_CATEGORIA;TIPO;DT_INICIO;DT_FIM;COD_PRODUTO;DESC_PRODUTO

=====================================================================================
*/
user function MGFCRM43()
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

return paramBox(aParambox, "Importação - Categoria de Produtos"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)

//-----------------------------------------------------
//-----------------------------------------------------
static function procArq()
	local aArea		:= getArea()
	local aAreaZBP	:= ZBP->(getArea())
	local cLinha	:= ""
	local nNewStr	:= ""
	local nOpen		:= FT_FUSE(AllTrim(MV_PAR01))
	local nLast		:= 0
	local nLinAtu	:= 0
	local aLinha	:= {}

	local nI		:= 0
	local cCategAtu	:= ""
	local aCampos	:= {}
	local aCposDet	:= {}
	local aAux		:= {}

	DBSelectArea("ZBP")
	ZBP->(DBSetOrder(1))

	if nOpen < 0
		Alert("Falha na abertura do arquivo.")
	else
		FT_FGOTOP()
		nLast := FT_FLastRec()
		FT_FGOTOP()

		while !FT_FEOF()
			nLinAtu++
			cLinha := ""
			cLinha := FT_FREADLN()
			aLinha := {}
			aLinha := strTokArr(cLinha, ";")

			if nLinAtu >= 2

				aCposDet := {}
				cCategAtu := padL( aLinha[1], tamSx3("ZBP_CODIGO")[1], "0")
				while !FT_FEOF() .and. cCategAtu == padL( aLinha[1], tamSx3("ZBP_CODIGO")[1], "0")
					//COD_CATEGORIA;DESC_CATEGORIA;TIPO;DT_INICIO;DT_FIM;COD_PRODUTO;DESC_PRODUTO

					aAux := {}

					aAdd( aAux, { 'ZBR_PRODUT'	, padL( aLinha[2], 6, "0" ) } )

					aAdd( aCposDet, aAux )

					FT_FSKIP()

					cLinha := ""
					cLinha := FT_FREADLN()
					aLinha := {}
					aLinha := strTokArr(cLinha, ";")
				enddo

				if len(aCposDet) > 0
					ZBP->(DBGoTop())
					if ZBP->(DBSeek( xFilial("ZBP") + cCategAtu ))
						importZBP(aCposDet)
					endif
				endif
			else
				FT_FSKIP()
			endif
		enddo
	endif

	restArea(aAreaZBP)
	restArea(aArea)
return

//-----------------------------------------------------
//-----------------------------------------------------
static function importZBP(aCpoDetail)
	local oModel, oAux, oStruct
	local nI			:= 0
	local nJ			:= 0
	local nPos			:= 0
	local lRet			:= .T.
	local aAux			:= {}
	local aC			:= {}
	local aH			:= {}
	local nItErro		:= 0
	local lAux			:= .T.
	local aCampos		:= {}
	local nGridLegth	:= 0
	local lFirstLine		:= .F.
    local cError        := ''

	// Aqui ocorre o instanciamento do modelo de dados (Model)
	// Neste exemplo instanciamos o modelo de dados do fonte COMP022_MVC
	// que é a rotina de manutenção de musicas
	oModel := FWLoadModel( 'MGFCRM38' )

	// Temos que definir qual a operação deseja: 3 – Inclusão / 4 – Alteração / 5 - Exclusão
	oModel:SetOperation( 4 )

	// Antes de atribuirmos os valores dos campos temos que ativar o modelo
	oModel:Activate()

	// Intanciamos apenas a parte do modelo referente aos dados do item
	oAux     := oModel:GetModel( 'ZBRDETAIL' )

	// Obtemos a estrutura de dados do item
	oStruct  := oAux:GetStruct()
	aAux	 := oStruct:GetFields()

	nItErro		:= 0
	lFirstLine	:= .F.

	For nI := 1 To Len( aCpoDetail )
		if nI == 1 .and. oAux:Length() == 1 .and. empty(oAux:getValue("ZBR_PRODUT", 1))

			// Incluímos uma linha nova
			// ATENCAO: O itens são criados em uma estrura de grid (FORMGRID), portanto já é criada uma primeira linha
			//branco automaticamente, desta forma começamos a inserir novas linhas a partir da 2ª vez	

			lFirstLine := .T.
		else
			if !lFirstLine				
				nGridLegth := 0
				nGridLegth := oAux:Length()

				oAux:AddLine()

				If  nGridLegth == oAux:Length()

					// Se por algum motivo o metodo AddLine() não consegue incluir a linha,
					// ele retorna a quantidade de linhas já
					// existem no grid. Se conseguir retorna a quantidade mais 1
					lRet    := .F.
					Exit
				endif			
			endif
		endif

		lFirstLine:= .F.

		For nJ := 1 To Len( aCpoDetail[nI] )

		// Verifica se os campos passados existem na estrutura de item
			If ( nPos := aScan( aAux, { |x| AllTrim( x[3] ) ==  AllTrim( aCpoDetail[nI][nJ][1] ) } ) ) > 0

				If !( lAux := oModel:SetValue( 'ZBRDETAIL', aCpoDetail[nI][nJ][1], aCpoDetail[nI][nJ][2] ) )

					// Caso a atribuição não possa ser feita, por algum motivo (validação, por exemplo)
					// o método SetValue retorna .F.
					lRet    := .F.
					nItErro := nI
					Exit

				EndIf
			EndIf
		Next

		If !lRet
			Exit
		EndIf

	Next


	If lRet
		// Faz-se a validação dos dados, note que diferentemente das tradicionais "rotinas automáticas"
		// neste momento os dados não são gravados, são somente validados.
		If ( lRet := oModel:VldData() )
			// Se o dados foram validados faz-se a gravação efetiva dos dados (commit)
			lRet := oModel:CommitData()
		EndIf
	EndIf

	If !lRet
		// Se os dados não foram validados obtemos a descrição do erro para gerar LOG ou mensagem de aviso
		aErro   := oModel:GetErrorMessage()
		// A estrutura do vetor com erro é:
		//  [1] Id do formulário de origem
		//  [2] Id do campo de origem
		//  [3] Id do formulário de erro
		//  [4] Id do campo de erro
		//  [5] Id do erro
		//  [6] mensagem do erro
		//  [7] mensagem da solução
		//  [8] Valor atribuido
		//  [9] Valor anterior
	
		AutoGrLog( "Id do formulário de origem:" + ' [' + AllToChar( aErro[1]  ) + ']' )
		AutoGrLog( "Id do campo de origem:     " + ' [' + AllToChar( aErro[2]  ) + ']' )
		AutoGrLog( "Id do formulário de erro:  " + ' [' + AllToChar( aErro[3]  ) + ']' )
		AutoGrLog( "Id do campo de erro:       " + ' [' + AllToChar( aErro[4]  ) + ']' )
		AutoGrLog( "Id do erro:                " + ' [' + AllToChar( aErro[5]  ) + ']' )
		AutoGrLog( "Mensagem do erro:          " + ' [' + AllToChar( aErro[6]  ) + ']' )
		AutoGrLog( "Mensagem da solução:       " + ' [' + AllToChar( aErro[7]  ) + ']' )
		AutoGrLog( "Valor atribuido:           " + ' [' + AllToChar( aErro[8]  ) + ']' )
		AutoGrLog( "Valor anterior:            " + ' [' + AllToChar( aErro[9]  ) + ']' )

		If nItErro > 0
			AutoGrLog( "Erro no Item:              " + ' [' + AllTrim( AllToChar( nItErro  ) ) + ']' )
		EndIf

		If (!IsBlind()) // COM INTERFACE GRÁFICA
		MostraErro()
	    Else // EM ESTADO DE JOB
	        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
	
	        ConOut(PadC("Automatic routine ended with error", 80))
	        ConOut("Error: "+ cError)
	    EndIf
	ELSE
		conout("MGFCRM41 -> Registro incluido")
	EndIf

	// Desativamos o Model
	oModel:DeActivate()

return
