#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM41
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              04/07/2017
Descricao / Objetivo:   Importa CSV das Metas
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:

Layout esperado do CSV:

COD_VENDEDOR;COD_CATEGORIA;ATIVO;VALOR;DT_INICIO;DT_FIM
000001;000004;S;11200;01/07/2017;28/07/2017
=====================================================================================
*/
user function MGFCRM41()
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

return paramBox(aParambox, "Importação de Metas"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)

//-----------------------------------------------------
//-----------------------------------------------------
static function procArq()
	local aArea		:= getArea()
	local aAreaSA3	:= SA3->(getArea())
	local aAreaZBQ	:= ZBQ->(getArea())
	local aAreaZBI	:= ZBI->(getArea())
	local cLinha	:= ""
	local nNewStr	:= ""
	local nOpen		:= FT_FUSE(AllTrim(MV_PAR01))
	local nLast		:= 0
	local nLinAtu	:= 0
	local aLinha	:= {}

	local nI		:= 0
	local cVendAtu	:= ""
	local cVendSeek	:= ""
	local aCampos	:= {}
	local aCposDet	:= {}
	local aAux		:= {}
	local cCateg    := ""
	local aCoors	:= 	FWGetDialogSize( oMainWnd )
	local oPanel1
	Private cErroZBQ:= ""

	DBSelectArea("ZBI")
	DBSelectArea("ZBQ")
	DBSelectArea("SA3")

	SA3->( DBSetOrder( 1 ) )
	ZBQ->( DBSetOrder( 2 ) ) //ZBQ_FILIAL + ZBQ_VENDED

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
				cVendAtu := aLinha[1]
				while !FT_FEOF() .and. cVendAtu == aLinha[1]
					//ZBQ_VENDED, A3_NOME VENDEDOR, ZBQ_CATEGO, ZBP_DESCRI DESCATEG, ZBQ_VALOR, ZBQ_ATIVO, ZBQ_DTINIC, ZBQ_DTFIM
					cCateg :=  PADL(aLinha[2], TAMSX3("ZBQ_CATEGO")[1],"0")
					cVendSeek := PADL(cVendAtu,TAMSX3("A3_COD")[1],"0")

					
					ZBQ->( DBGoTop() )
					if ZBQ->( DBSeek( xFilial("ZBQ") + cVendSeek ) )
						lAchou := .F.

						While ZBQ->(!EOF()) .AND. cVendSeek == ZBQ->ZBQ_VENDED
							if ctod(aLinha[5]) == ZBQ->ZBQ_DTINIC .AND. ctod(aLinha[6]) == ZBQ->ZBQ_DTFIM .AND. cCateg == ZBQ->ZBQ_CATEGO
								RecLock("ZBQ",.F.)
									ZBQ->ZBQ_VALOR := val(aLinha[4])
								ZBQ->( MsUnlock() )
								lAchou := .T.
								exit
							endif

							ZBQ->(dbskip())
						enddo

						if !lAchou

							aAux := {}

							aAdd( aAux, { 'ZBQ_CATEGO'	, cCateg							} )
							aAdd( aAux, { 'ZBQ_ATIVO'	, iif( upper( aLinha[ 3 ] ) == "SIM", "1", "2")	} )
							aAdd( aAux, { 'ZBQ_VALOR'	, val(aLinha[4])					} )
							aAdd( aAux, { 'ZBQ_DTINIC'	, cToD( aLinha[5] )					} )
							aAdd( aAux, { 'ZBQ_DTFIM'	, cToD( aLinha[6] )					} )

							aAdd( aCposDet, aAux )
						endif
					else

						aAux := {}

						aAdd( aAux, { 'ZBQ_CATEGO'	, cCateg							} )
						aAdd( aAux, { 'ZBQ_ATIVO'	, iif( upper( aLinha[ 3 ] ) == "SIM", "1", "2")	} )
						aAdd( aAux, { 'ZBQ_VALOR'	, val(aLinha[4])					} )
						aAdd( aAux, { 'ZBQ_DTINIC'	, cToD( aLinha[5] )					} )
						aAdd( aAux, { 'ZBQ_DTFIM'	, cToD( aLinha[6] )					} )

						aAdd( aCposDet, aAux )

					endif

					FT_FSKIP()

					cLinha := ""
					cLinha := FT_FREADLN()
					aLinha := {}
					aLinha := strTokArr(cLinha, ";")
				enddo
			else
				FT_FSKIP()
			endif

			if len(aCposDet) > 0			
				/*
				SA3->( DBGoTop() )
				if SA3->(DBSeek( xFilial("SA3") + PADL(cVendSeek,TAMSX3("A3_COD")[1],"0") ))
					importZBQ(aCposDet)
				endif
				*/
				nRecnoZBI := 0
				nRecnoZBI := getRecZBI(cVendSeek)
				if nRecnoZBI > 0
					ZBI->( DBGoTop() )
					ZBI->( DBGoTo( nRecnoZBI ) )
					importZBQ( aCposDet )
				endif
			endif
		enddo

		if !empty( cErroZBQ )
			DEFINE MSDIALOG oDlg TITLE 'Erros de importação' FROM aCoors[1]/2, aCoors[2]/2 TO aCoors[3]/2, aCoors[4]/2 PIXEL 
		
			@ 005,005 GET oMemo VAR cErroZBQ MEMO SIZE 325,100 OF oPanel1 PIXEL
			ACTIVATE MSDIALOG oDlg CENTER
		endif

	endif

	restArea(aAreaZBI)
	restArea(aAreaZBQ)
	restArea(aAreaSA3)
	restArea(aArea)
return

//-----------------------------------------------------
// Retorna o recno da ZBI a ser posicionada
//-----------------------------------------------------
static function getRecZBI(cVendSeek)
	local cQryZBI	:= ""
	local nRecZBI	:= 0

	cQryZBI := "SELECT ZBI.R_E_C_N_O_ ZBIRECNO"
	cQryZBI += " FROM " + retSQLName("ZBI") + " ZBI"
	cQryZBI += " WHERE"
	cQryZBI += " 		ZBI.ZBI_REPRES	=	'" + cVendSeek		+ "'"
	cQryZBI += " 	AND	ZBI.ZBI_FILIAL	=	'" + xFilial("ZBI") + "'"
	cQryZBI += " 	AND	ZBI.D_E_L_E_T_	<>	'*'"

	tcQuery cQryZBI New Alias "QRYZBI"

	if !QRYZBI->( EOF() )
		nRecZBI := QRYZBI->ZBIRECNO
	endif

	QRYZBI->( DBCloseArea() )

return nRecZBI

//-----------------------------------------------------
//-----------------------------------------------------
static function importZBQ(aCpoDetail)
	local oModel, oAux, oStruct
	local nI			:= 0
	local nJ			:= 0
	local nPos			:= 0
	local lRet			:= .T.
	local aAux			:= {}
	local aC			:= {}
	local aH			:= {}
	local aCoors	:= 	FWGetDialogSize( oMainWnd )
	local nItErro		:= 0
	local lAux			:= .T.
	local aCampos		:= {}
	local nGridLegth	:= 0
	local lFirstLine		:= .F.

	// Aqui ocorre o instanciamento do modelo de dados (Model)
	// Neste exemplo instanciamos o modelo de dados do fonte COMP022_MVC
	// que é a rotina de manutenção de musicas
	oModel := FWLoadModel( 'MGFCRM39' )

	// Temos que definir qual a operação deseja: 3 – Inclusão / 4 – Alteração / 5 - Exclusão
	oModel:SetOperation( 4 )

	// Antes de atribuirmos os valores dos campos temos que ativar o modelo
	oModel:Activate()

	// Intanciamos apenas a parte do modelo referente aos dados do item
	oAux     := oModel:GetModel( 'ZBQDETAIL' )

	// Obtemos a estrutura de dados do item
	oStruct  := oAux:GetStruct()
	aAux	 := oStruct:GetFields()

	nItErro  := 0
	lFirstLine	:= .F.

	For nI := 1 To Len( aCpoDetail )
		if nI == 1 .and. oAux:Length() == 1 .and. empty(oAux:getValue("ZBQ_CATEGO", 1))

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

				If !( lAux := oModel:SetValue( 'ZBQDETAIL', aCpoDetail[nI][nJ][1], aCpoDetail[nI][nJ][2] ) )

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
	
/*		AutoGrLog( "Id do formulário de origem:" + ' [' + AllToChar( aErro[1]  ) + ']' )
		AutoGrLog( "Id do campo de origem:     " + ' [' + AllToChar( aErro[2]  ) + ']' )
		AutoGrLog( "Id do formulário de erro:  " + ' [' + AllToChar( aErro[3]  ) + ']' )
		AutoGrLog( "Id do campo de erro:       " + ' [' + AllToChar( aErro[4]  ) + ']' )
		AutoGrLog( "Id do erro:                " + ' [' + AllToChar( aErro[5]  ) + ']' )
		AutoGrLog( "Mensagem do erro:          " + ' [' + AllToChar( aErro[6]  ) + ']' )
		AutoGrLog( "Mensagem da solução:       " + ' [' + AllToChar( aErro[7]  ) + ']' )
		AutoGrLog( "Valor atribuido:           " + ' [' + AllToChar( aErro[8]  ) + ']' )
		AutoGrLog( "Valor anterior:            " + ' [' + AllToChar( aErro[9]  ) + ']' )
*/
		If nItErro > 0
	//		AutoGrLog( "Erro no Item:              " + ' [' + AllTrim( AllToChar( nItErro  ) ) + ']' )
			//cErroZBQ += AlltoChar(aErro[4])+" "+ AllToChar( aErro[7]) + CRLF
			If aErro[4] == "ZBQ_CATEGO"
				cErroZBQ += " Categoria Inválida! "+ "Valor atribuido: "+AllToChar( aErro[8]) + CRLF
			Else
				cErroZBQ += "Campo com erro: " + AlltoChar(aErro[4])+" Valor inserido "+ AllToChar( aErro[8]) + CRLF
			EndIf
			
		EndIf

		//MostraErro()
	ELSE
		conout("MGFCRM41 -> Registro incluido")
	EndIf

	// Desativamos o Model
	oModel:DeActivate()

return
