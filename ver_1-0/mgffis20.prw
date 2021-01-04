#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: MGFFIS20
Autor...............: Flavio Dentello
Data................: Outubro/2017 
Descricao / Objetivo: Fiscal
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: 
Obs.................: Cadastro de Aliqtuota Efetiva de ICMS
=====================================================================================
*/

User Function MGFFIS20()

	Local oMBrowse := nil
	Local aAux := {}
	Private lGravaincl := .F.
	Private lGravaAlt  := .F.
	Private lGravaExc  := .F.

	oMBrowse:= FWmBrowse():New()

	oMBrowse:SetAlias("ZD6")
	oMBrowse:SetDescription("Cadastro de Aliquota Efetiva")

	oMBrowse:Activate()

return oMBrowse

Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFFIS20" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	  ACTION "VIEWDEF.MGFFIS20" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	  ACTION "VIEWDEF.MGFFIS20" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	  ACTION "VIEWDEF.MGFFIS20" OPERATION MODEL_OPERATION_DELETE ACCESS 0
	ADD OPTION aRotina TITLE "Importar.csv"	  ACTION 'U_MGFFISIMP'	    OPERATION 8 ACCESS 0

Return aRotina


Static Function ModelDef()

	Local oStruZD6 := FWFormStruct( 1, 'ZD6', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel
	Local cHora := TIME()

	oModel := FWModelActive()
	oModel := MPFormModel():New('XMGFFIS20', /*bPreValidacao*/, /*bPosValidacao*/, {|oModel|LogCommit(oModel)} /*bCommit*/, /*bCancel*/ )


	oModel:AddFields( 'ZD6MASTER', /*cOwner*/, oStruZD6, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oModel:SetDescription( 'Cadastro de Aliquota Efetiva' )

	oModel:SetPrimaryKey({"ZD6_FILIAL"})

	oModel:GetModel( 'ZD6MASTER' ):SetDescription( 'Cadastro de Aliquota Efetiva' )

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFFIS20' )

	Local oStruZD6 := FWFormStruct( 2, 'ZD6' )

	Local oView
	Local cCampos := {}


	oView := FWFormView():New()

	oView:SetModel( oModel )

	oView:AddField( 'VIEW_ZD6', oStruZD6, 'ZD6MASTER' )

	oView:CreateHorizontalBox( 'TELA' , 100 )

	oView:SetOwnerView( 'VIEW_ZD6', 'TELA' )

Return oView


//// Grava Logs do cadastro na tabela ZD7.

static Function LogCommit(oModel)

	Local lRet		:= .T.
	Local oStruZBV	:= oModel:GetModel('ZBVMASTER')


	///Alteracao
	If oModel:GetOperation() == 4

		RecLock("ZD7",.T.)
		ZD7->ZD7_FILIAL := XFILIAL("ZD6")
		ZD7->ZD7_OPER	:= '2'
		ZD7->ZD7_COD 	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_COD')
		ZD7->ZD7_TES   	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_TES')
		ZD7->ZD7_DESTES	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_DESTES')
		ZD7->ZD7_UF    	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_UF')
		ZD7->ZD7_DESCUF	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_DESCUF')
		ZD7->ZD7_GRPTRB	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_GRPTRB')
		ZD7->ZD7_DESCGT := oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_DESCGT')
		ZD7->ZD7_ALIQ  	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_ALIQ')
		ZD7->ZD7_BASCAL := oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_BASCAL')
		ZD7->ZD7_INIVIG	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_INIVIG')
		ZD7->ZD7_FIMVIG := oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_FIMVIG')
		ZD7->ZD7_CODUSR	:= RetCodUsr()
		ZD7->ZD7_NMUSR 	:= cUserName
		ZD7->ZD7_DTINCL	:= DDATABASE
		ZD7->ZD7_HRLOG  := TIME()
		ZD7->(MsUnlock())

		//Inclusao		
	ElseIf oModel:GetOperation() == 3


		RecLock("ZD7",.T.)
		ZD7->ZD7_FILIAL := XFILIAL("ZD6")
		ZD7->ZD7_OPER	:= '1'
		ZD7->ZD7_COD 	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_COD')
		ZD7->ZD7_TES   	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_TES')
		ZD7->ZD7_DESTES	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_DESTES')
		ZD7->ZD7_UF    	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_UF')
		ZD7->ZD7_DESCUF	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_DESCUF')
		ZD7->ZD7_GRPTRB	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_GRPTRB')
		ZD7->ZD7_DESCGT := oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_DESCGT')
		ZD7->ZD7_ALIQ  	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_ALIQ')
		ZD7->ZD7_BASCAL := oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_BASCAL')
		ZD7->ZD7_INIVIG	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_INIVIG')
		ZD7->ZD7_FIMVIG := oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_FIMVIG')
		ZD7->ZD7_CODUSR	:= RetCodUsr()
		ZD7->ZD7_NMUSR 	:= cUserName
		ZD7->ZD7_DTINCL	:= DDATABASE
		ZD7->ZD7_HRLOG  := TIME()
		ZD7->(MsUnlock())

		//Exclusao
	ElseIf oModel:GetOperation() == 5


		RecLock("ZD7",.T.)
		ZD7->ZD7_FILIAL := XFILIAL("ZD6")
		ZD7->ZD7_OPER	:= '3'
		ZD7->ZD7_COD 	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_COD')
		ZD7->ZD7_TES   	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_TES')
		ZD7->ZD7_DESTES	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_DESTES')
		ZD7->ZD7_UF    	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_UF')
		ZD7->ZD7_DESCUF	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_DESCUF')
		ZD7->ZD7_GRPTRB	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_GRPTRB')
		ZD7->ZD7_DESCGT := oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_DESCGT')
		ZD7->ZD7_ALIQ  	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_ALIQ')
		ZD7->ZD7_BASCAL := oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_BASCAL')
		ZD7->ZD7_INIVIG	:= oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_INIVIG')
		ZD7->ZD7_FIMVIG := oModel:GetModel( 'ZD6MASTER'):GetValue('ZD6_FIMVIG')
		ZD7->ZD7_CODUSR	:= RetCodUsr()
		ZD7->ZD7_NMUSR 	:= cUserName
		ZD7->ZD7_DTINCL	:= DDATABASE
		ZD7->ZD7_HRLOG  := TIME()
		ZD7->(MsUnlock())

	EndIf

	//Grava��o comum do commit
	If oModel:VldData()
		FwFormCommit(oModel)
		oModel:DeActivate()
	Else
		JurShowErro( oModel:GetModel():GetErrormessage() )
		lRet := .F.
		DisarmTransaction()
	EndIf

return lRet


///// Importacao CSV.

user function MGFFISIMP()
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

return paramBox(aParambox, "Importacao Aliquota Efetiva"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)

//-----------------------------------------------------
//-----------------------------------------------------
static function procArq()
	local aArea		:= getArea()
	local aAreaZD6	:= ZD6->(getArea())
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
	local aCposZD6	:= {}
	local aAux		:= {}
	local cCateg    := ""
	Local cFil		:= cFilant
	local aCoors	:= 	FWGetDialogSize( oMainWnd )
	local oPanel1
	Private cErroZD6:= ""

	DBSelectArea("ZD6")

	ZD6->( DBSetOrder( 1 ) )

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

				aCposZD6 := {}

				aAux := {}
				If Len(aLinha)> 0	

					cFilant := PADL(aLinha[1], TAMSX3("ZD6_FILIAL")[1],"0")

					aAdd( aAux, { 'ZD6_FILIAL'	, PADL(aLinha[1], TAMSX3("ZD6_FILIAL")[1],"0")	} )
					aAdd( aAux, { 'ZD6_COD'	    , GETSXENUM("ZD6", "ZD6_COD")					} )
					aAdd( aAux, { 'ZD6_TES'	    , PADL(aLinha[2], TAMSX3("ZD6_TES")[1],"0")		} )
					aAdd( aAux, { 'ZD6_UF'		, aLinha[3]										} )
					aAdd( aAux, { 'ZD6_GRPTRB'	, PADL(aLinha[4], TAMSX3("ZD6_GRPTRB")[1],"0")  } )
					aAdd( aAux, { 'ZD6_ALIQ'	, val(Transform(aLinha[5] ,"@E 9.99"))			} )
					aAdd( aAux, { 'ZD6_BASCAL'	, aLinha[6]										} )									
					aAdd( aAux, { 'ZD6_INIVIG'	, cToD( aLinha[7] )								} )					
					aAdd( aAux, { 'ZD6_FIMVIG'	, cToD( aLinha[8] )								} )

					aAdd( aCposZD6, aAux )


					cLinha := ""
					cLinha := FT_FREADLN()
					aLinha := {}
					aLinha := strTokArr(cLinha, ";")

					importZD6( aCposZD6 )

					FT_FSKIP()	
				Else
					MsgAlert("Arquivo com linhas em branco! Importacao sera abortada!")
					cFilant := cFil
					restArea(aAreaZD6)
					restArea(aArea)	

					Return
				EndIf

			else
				FT_FSKIP()
			endif

		enddo
	EndIf

	If !empty(cErroZD6)
		DEFINE MSDIALOG oDlg TITLE 'Erros de importacao' FROM aCoors[1]/2, aCoors[2]/2 TO aCoors[3]/2, aCoors[4]/2 PIXEL 

		@ 005,005 GET oMemo VAR cErroZD6 MEMO SIZE 325,100 OF oPanel1 PIXEL
		ACTIVATE MSDIALOG oDlg CENTER
	Else
		MsgInfo("Arquivo importado com sucesso!")
		cFilant := cFil
	EndIf	

	restArea(aAreaZD6)
	restArea(aArea)
return

//-----------------------------------------------------
//-----------------------------------------------------
static function importZD6(aCpoDetail)
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
	// que � a rotina de manutencao de musicas
	oModel := FWLoadModel( 'MGFFIS20' )

	// Temos que definir qual a operacao deseja: 3 � Inclusao / 4 � Alteracao / 5 - Exclusao
	oModel:SetOperation( 3 )

	// Antes de atribuirmos os valores dos campos temos que ativar o modelo
	oModel:Activate()

	// Intanciamos apenas a parte do modelo referente aos dados do item
	oAux     := oModel:GetModel( 'ZD6MASTER' )

	// Obtemos a estrutura de dados do item
	oStruct  := oAux:GetStruct()
	aAux	 := oStruct:GetFields()

	nItErro  := 0
	lFirstLine	:= .F.

	For nI := 1 To Len( aCpoDetail )
		lFirstLine := .T.

		lFirstLine:= .F.

		For nJ := 1 To Len( aCpoDetail[nI] )

			// Verifica se os campos passados existem na estrutura de item
			If ( nPos := aScan( aAux, { |x| AllTrim( x[3] ) ==  AllTrim( aCpoDetail[nI][nJ][1] ) } ) ) > 0

				If !( lAux := oModel:SetValue( 'ZD6MASTER', aCpoDetail[nI][nJ][1], aCpoDetail[nI][nJ][2] ) )

					// Caso a atribuicao nao possa ser feita, por algum motivo (validacao, por exemplo)
					// o metodo SetValue retorna .F.
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
		// Faz-se a validacao dos dados, note que diferentemente das tradicionais "rotinas automaticas"
		// neste momento os dados nao sao gravados, sao somente validados.
		If ( lRet := oModel:VldData() )
			ConfirmSx8()
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

		/*		AutoGrLog( "Id do formulario de origem:" + ' [' + AllToChar( aErro[1]  ) + ']' )
		AutoGrLog( "Id do campo de origem:     " + ' [' + AllToChar( aErro[2]  ) + ']' )
		AutoGrLog( "Id do formulario de erro:  " + ' [' + AllToChar( aErro[3]  ) + ']' )
		AutoGrLog( "Id do campo de erro:       " + ' [' + AllToChar( aErro[4]  ) + ']' )
		AutoGrLog( "Id do erro:                " + ' [' + AllToChar( aErro[5]  ) + ']' )
		AutoGrLog( "Mensagem do erro:          " + ' [' + AllToChar( aErro[6]  ) + ']' )
		AutoGrLog( "Mensagem da solucao:       " + ' [' + AllToChar( aErro[7]  ) + ']' )
		AutoGrLog( "Valor atribuido:           " + ' [' + AllToChar( aErro[8]  ) + ']' )
		AutoGrLog( "Valor anterior:            " + ' [' + AllToChar( aErro[9]  ) + ']' )
		*/
		If nItErro > 0

			If aErro[4] == "ZD6_FILIAL"
				cErroZD6 += " Categoria Inv�lida! "+ "Valor atribuido: "+AllToChar( aErro[8]) + CRLF
			Else
				cErroZD6 += "Campo com erro: " + AlltoChar(aErro[4])+" Valor inserido "+ AllToChar( aErro[8]) + CRLF
			EndIf

		EndIf

		//MostraErro()
	ELSE
		conout("MGFFIS20 -> Registro incluido")
	EndIf

	// Desativamos o Model
	oModel:DeActivate()

	freeObj( oModel )
	freeObj( oAux )
	freeObj( oStruct )
return
