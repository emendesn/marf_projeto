#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM09
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              30/03/2017
Descricao / Objetivo:   Importação de vendedores para AO4
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFCRM09()
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

return paramBox(aParambox, "Importação de Vendedores"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)

//-----------------------------------------------------
//-----------------------------------------------------
static function procArq()
	local aArea		:= getArea()
	local aAreaSA1	:= SA1->(getArea())
	local aAreaAO4	:= AO4->(getArea())
	local cIDSA1	:= ""
	local cIDSA3	:= ""
	local cCodSA3	:= ""
	local aCodSA1	:= {}
	local cLinha	:= ""
	local nOpen		:= FT_FUSE(AllTrim(MV_PAR01))
	local nLast		:= 0
	local nLinAtu	:= 0

	DBSelectArea("SA1")

	SA1->(DBSetOrder())

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

			cIDSA3 := subStr(cLinha, 1, at("|", cLinha)-1)
			cIDSA1 := subStr(cLinha, at("|", cLinha)+1, len(cLinha))

			cCodSA3 := getCodSA3(cIDSA3)
			aCodSA1 := getCodSA1(cIDSA1)

			conout("MGFCRM09 -> SA3 ARQUIVO " + cIDSA3)
			conout("MGFCRM09 -> COD USUARIO VENDEDOR " + cCodSA3)

			conout("MGFCRM09 -> SA1 ARQUIVO " + cIDSA1)
			conout("MGFCRM09 -> COD CLIENTE " + aCodSA1[1] + "/" + aCodSA1[2])

			if !empty(cCodSA3) .and. !empty(aCodSA1)
				importAO4(cCodSA3, aCodSA1, nLinAtu, nLast)
			else
				// gera log
				conout("MGFCRM09 ->Nao encontrado vendedor " + cIDSA3)
				conout("MGFCRM09 ->Nao encontrado cliente " + cIDSA1)
			endif

			FT_FSKIP()
		enddo
	endif

	restArea(aAreaAO4)
	restArea(aAreaSA1)
	restArea(aArea)
return

//-----------------------------------------------------
//-----------------------------------------------------
static function importAO4(cCodSA3, aCodSA1, nLinAtu, nLast)
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
	Local cError    := ''

	SA1->( DBGoTop() )

	conout("MGFCRM09 ->Antes seek SA1 " + aCodSA1[1] + aCodSA1[2])

	if SA1->( DBSeek( xFilial("SA1") + aCodSA1[1] + aCodSA1[2] ) )
		DBSelectArea("AO4")
		AO4->( DBGoTop() )

		cSeekAO4 := getRecAO4( aCodSA1[1] + aCodSA1[2] )

		AO4->( DBSeek( cSeekAO4 ) )

		conout("MGFCRM09 ->Depois seek SA1 " + SA1->A1_NOME)
		aCampos := {}
		aadd( aCampos, { 'AO4_CODUSR'	, cCodSA3	} )
		aadd( aCampos, { 'AO4_CTRLTT'	, .T.		} )
		aadd( aCampos, { 'AO4_USRCOM'	, "000000"	} )

		DBSelectArea( "AO4" )
		DBSetOrder( 1 )

		// Aqui ocorre o instanciamento do modelo de dados (Model)
		// Neste exemplo instanciamos o modelo de dados do fonte COMP022_MVC
		// que é a rotina de manutenção de musicas
		oModel := FWLoadModel( 'CRMA200' )

		// Temos que definir qual a operação deseja: 3 – Inclusão / 4 – Alteração / 5 - Exclusão
		oModel:SetOperation( 4 )

		// Antes de atribuirmos os valores dos campos temos que ativar o modelo
		oModel:Activate()

		// Instanciamos apenas a parte do modelo referente aos dados de cabeçalho
		oAux    := oModel:GetModel( 'AO4DETUSR' )
		
		oAux1    := oModel:GetModel( 'AO4MASTER' )

		// Obtemos a estrutura de dados do cabeçalho
		oStruct := oAux:GetStruct()
		aAux	:= oStruct:GetFields()

		oAux:GoLine( oAux:Length() )
		if !empty(oAux:getValue("AO4_CODUSR"))
			nNewline := oAux:AddLine()
			oAux:GoLine(nNewline)
		endif

		For nI := 1 To Len( aCampos )
			// Verifica se os campos passados existem na estrutura do cabeçalho
			If ( nPos := aScan( aAux, { |x| AllTrim( x[3] ) ==  AllTrim( aCampos[nI][1] ) } ) ) > 0

				If !( lAux := oModel:SetValue( 'AO4DETUSR', aCampos[nI][1], aCampos[nI][2] ) )
					lRet    := .F.
					Exit
				EndIf
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

			AutoGrLog( "AO4_CHVREG:                " + ' [' + oAux1:getValue("AO4_CHVREG")	+ ']' )
			AutoGrLog( "AO4_CODUSR:                " + ' [' + cCodSA3	+ ']' )

			AutoGrLog( "AO4_CTRLTT:                " + ' [' + cValToChar(oAux:getValue("AO4_CTRLTT"))	+ ']' )
			AutoGrLog( "AO4_PERVIS:                " + ' [' + cValToChar(oAux:getValue("AO4_PERVIS"))	+ ']' )
			AutoGrLog( "AO4_PEREDT:                " + ' [' + cValToChar(oAux:getValue("AO4_PEREDT"))	+ ']' )
			AutoGrLog( "AO4_PEREXC:                " + ' [' + cValToChar(oAux:getValue("AO4_PEREXC"))	+ ']' )
			AutoGrLog( "AO4_PERCOM:                " + ' [' + cValToChar(oAux:getValue("AO4_PERCOM"))	+ ']' )
			//AutoGrLog( "AO4_PROPRI:                " + ' [' + cValToChar(oAux:getValue("AO4_PROPRI"))	+ ']' )

			AutoGrLog( "AO4_USRCOM:                " + ' [000000]' )

			conout( "MGFCRM09 -> Id do formulário de origem:" + ' [' + AllToChar( aErro[1]  ) + ']' )
			conout( "MGFCRM09 -> Id do campo de origem:     " + ' [' + AllToChar( aErro[2]  ) + ']' )
			conout( "MGFCRM09 -> Id do formulário de erro:  " + ' [' + AllToChar( aErro[3]  ) + ']' )
			conout( "MGFCRM09 -> Id do campo de erro:       " + ' [' + AllToChar( aErro[4]  ) + ']' )
			conout( "MGFCRM09 -> Id do erro:                " + ' [' + AllToChar( aErro[5]  ) + ']' )
			conout( "MGFCRM09 -> Mensagem do erro:          " + ' [' + AllToChar( aErro[6]  ) + ']' )
			conout( "MGFCRM09 -> Mensagem da solução:       " + ' [' + AllToChar( aErro[7]  ) + ']' )
			conout( "MGFCRM09 -> Valor atribuido:           " + ' [' + AllToChar( aErro[8]  ) + ']' )
			conout( "MGFCRM09 -> Valor anterior:            " + ' [' + AllToChar( aErro[9]  ) + ']' )

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

			conout("MGFCRM09 -> Registro incluido")

		EndIf

		// Desativamos o Model
		oModel:DeActivate()
	else
		conout("MGFCRM09 ->Nao encontrado seek SA1 " + aCodSA1[1] + aCodSA1[2])
	endif

return

//-----------------------------------------------------
//-----------------------------------------------------
static function getRecAO4(cCodLjCli)
	local nAO4Rec	:= 0
	local cRetAO4	:= ""
	local cQryAO4	:= ""

	cQryAO4 := "SELECT AO4_FILIAL, AO4_ENTIDA, AO4_CHVREG, AO4_CODUSR"
	cQryAO4 += " FROM " + retSQLName("AO4") + " AO4"
	cQryAO4 += " WHERE"
	cQryAO4 += " 		AO4.AO4_CHVREG	LIKE	'%" + cCodLjCli+ "%'"
	cQryAO4 += " 	AND	AO4.AO4_FILIAL	=		'" + xFilial("AO4") + "'"
	cQryAO4 += " 	AND	AO4.D_E_L_E_T_	<>		'*'"
	cQryAO4 += " ORDER BY R_E_C_N_O_ DESC"

	TcQuery cQryAO4 New Alias "QRYAO4"

	if !QRYAO4->(EOF())
		cRetAO4 := QRYAO4->(AO4_FILIAL+AO4_ENTIDA+AO4_CHVREG+AO4_CODUSR)
	endif

	QRYAO4->(DBCloseArea())
return cRetAO4

//-----------------------------------------------------
//-----------------------------------------------------
static function getCodSA3(cIDSA3)
	local cRetCod	:= ""
	local cQrySA3	:= ""

	cQrySA3 += "SELECT A3_CODUSR"
	cQrySA3 += " FROM " + retSQLName("SA3") + " SA3"
	cQrySA3 += " WHERE"
	cQrySA3 += " 		SA3.A3_CGC		=	'" + cIDSA3			+ "'"
	cQrySA3 += " 	AND	SA3.A3_FILIAL	=	'" + xFilial("SA3")	+ "'"
	cQrySA3 += " 	AND	SA3.D_E_L_E_T_	<>	'*'"

	TcQuery cQrySA3 New Alias "QRYSA3"

	if !QRYSA3->(EOF())
		cRetCod := QRYSA3->A3_CODUSR
	endif

	QRYSA3->(DBCloseArea())
return cRetCod

//-----------------------------------------------------
//-----------------------------------------------------
static function getCodSA1(cIDSA1)
	local aRetCod	:= ""
	local cQrySA1	:= ""

	cQrySA1 += "SELECT A1_COD, A1_LOJA"
	cQrySA1 += " FROM " + retSQLName("SA1") + " SA1"
	cQrySA1 += " WHERE"
	cQrySA1 += " 		SA1.A1_CGC		=	'" + cIDSA1			+ "'"
	cQrySA1 += " 	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1")	+ "'"
	cQrySA1 += " 	AND	SA1.D_E_L_E_T_	<>	'*'"

	TcQuery cQrySA1 New Alias "QRYSA1"

	if !QRYSA1->(EOF())
		aRetCod := {QRYSA1->A1_COD, QRYSA1->A1_LOJA}
	endif

	QRYSA1->(DBCloseArea())
return aRetCod