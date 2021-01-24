#Include 'Protheus.ch'
#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FWMVCDEF.CH'
/*
=====================================================================================
Programa.:              BRWFIS02
Autor....:              Barbieri
Data.....:              19/01/2017
Descricao / Objetivo:   Browse Log Recebimento XML
Doc. Origem:            FIS02
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Programa para recebimento do xml do fornecedor
=====================================================================================
*/
User function BRWFIS02()

	Private oBrowse3
	Private cLinha := ""

	oBrowse3 := FWMBrowse():New()
	oBrowse3:SetAlias('SZ8')
	oBrowse3:SetDescription('Log recebimento XML')

	oBrowse3:AddLegend( "Z8_STATUS == '1' "  , "YELLOW"   , "Em Analise" )
	oBrowse3:AddLegend( "Z8_STATUS == '2' "  , "GREEN"    , "Reprocessado" )

	oBrowse3:Activate()

return NIL

Static function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar' 		ACTION 'VIEWDEF.BRWFIS02' 	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Reenviar' 		ACTION 'U_XPROCBF2()' 		OPERATION 4 ACCESS 0
	
Return aRotina

Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruSZ8 := FWFormStruct( 1, 'SZ8')
	Local oModel

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('XBRWFIS02',/**/ , , , /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'SZ8MASTER', /*cOwner*/, oStruSZ8, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	//Adiciona chave Primária
	oModel:SetPrimaryKey({"Z8_FILIAL","Z8_DOC","Z8_SERIE","Z8_FORNECE"})

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Log recebimento XML' )	

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'SZ8MASTER' ):SetDescription( 'Log Rec XML' )

Return oModel

Static Function ViewDef()

	// Cria a estrutura a ser usada na View
	Local oStruSZ8 := FWFormStruct( 2, 'SZ8') //,{ |x| ALLTRIM(x) $ 'ZP_CODREG, ZP_DESCREG, ZP_ATIVO' })

	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'BRWFIS02' )
	Local oView

	// Remove o campo Codigo Região do detalhe
	oStruSZ8:RemoveField( "Z8_STATUS" )

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_SZ8', oStruSZ8, 'SZ8MASTER' )

//	// Criar um "box" horizontal para receber algum elemento da view
//	oView:CreateHorizontalBox( 'SUPERIOR' , 20 )
//	oView:CreateHorizontalBox( 'INFERIOR' , 80 )
//
//	// Relaciona o ID da View com o "box" para exibicao
//	oView:SetOwnerView( 'VIEW_SZP', 'SUPERIOR' )
//	oView:SetOwnerView( 'VIEW_ZAP', 'INFERIOR' )

Return oView

User Function XPROCBF2()
	FwMsgRun(, {|| xPcArqXml() }, "Processando", "Aguarde. Movendo arquivos para processamento" )
return

Static Function xPcArqXml()

	Local aArea := GetArea()

	Local cDirArq := ""
	Local cDirXml := ""
	Local cDirPro := ""
	Local cDirRej := ""

	Local cPerg	  := 'SZ8ARQ'
	Local cNextAlias := GetNextAlias()

	Local cArqDe  := ''
	Local cArqAte := ''
	
	Local cBkpFil := cFilAnt
	
	IF Pergunte(cPerg,.T.)

		cArqDe  := MV_PAR01
		cArqAte := MV_PAR02

		If Select(cNextAlias) > 0
			(cNextAlias)->(DbClosearea())
		Endif

		BeginSql Alias cNextAlias

			SELECT *
			FROM 
				%Table:SZ8% SZ8
			WHERE 
				SZ8.%NotDel% AND
				SZ8.Z8_STATUS = '1' AND
				SZ8.Z8_DOC BETWEEN %Exp:cArqDe% AND %Exp:cArqAte%

		EndSql

		(cNextAlias)->(dbGoTop())
		
		While (cNextAlias)->(!EOF())
			
			cFilAnt := (cNextAlias)->Z8_FILIAL 
			
			cDirArq := SuperGetMv("MGF_XMLARQ",,"\AUTORIZADAS"	)
			cDirXml := SuperGetMv("MGF_XMLNFE",,"\XML"			)
			cDirPro := SuperGetMv("MGF_XMLEXC",,"\EXECUTADOS"		)
			cDirRej := SuperGetMv("MGF_XMLREJ",,"\REJEITADOS"		)

			//Cria diretórios automaticamente, caso não exista, conforme parametros acima
			MakeDir(cDirXml)
			MakeDir(cDirXml+cDirArq)
			MakeDir(cDirXml+cDirPro)
			MakeDir(cDirXml+cDirRej)
			
			cFilOri 	:= cDirXml + cDirRej + '\' + alltrim((cNextAlias)->Z8_ARQUIVO)
			cFilDest	:= cDirXml + cDirArq + '\' + alltrim((cNextAlias)->Z8_ARQUIVO)
			
			If	File( cFilOri )	
				If __CopyFile( cFilOri , cFilDest )
					fErase( cFilOri )
					
					dbSelectArea('SZ8')
					SZ8->(dbGoTo((cNextAlias)->R_E_C_N_O_))
					
					RecLock('SZ8',.F.)
						SZ8->Z8_STATUS := '2'
					SZ8->(MsUnLock())
					
				EndIf
			EndIf

			(cNextAlias)->(dbSkip())
		EndDo
	EndIf
	
	(cNextAlias)->(DbClosearea())
	
	cFilAnt := cBkpFil
	RestArea(aArea)
	
return


