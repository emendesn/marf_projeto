#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"

Static _nOpcDesp := 0

/*
=====================================================================================
Programa............: MGFFAT08
Autor...............: Joni Lima
Data................: 06/10/2016
Descricao / Objetivo: Cadastro de Regras
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Tela de Cadastro de Regras
=====================================================================================
*/
User Function MGFFAT08()

	Local aArea		:= GetArea()
	Local aAreaSZT	:= GetArea('SZT')
	Local oMBrowse := nil
	
	dbselectArea('SZT')
	SZT->(dbSetOrder(1))
	
	If !(SZT->(dbSeek(xFilial('SZT'))))
		Processa({|| xMF08CadPDR()},"Aguarde...","Cadastrando Regras...",.F.)
	EndIf
		
	oMBrowse:= FWmBrowse():New()
	oMBrowse:SetAlias("SZT")
	oMBrowse:SetDescription('Regras')
	oMBrowse:Activate()
	
Return

/*
=====================================================================================
Programa............: MenuDef
Autor...............: Joni Lima
Data................: 06/10/2016
Descricao / Objetivo: MenuDef da rotina
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Definicao do Menu
=====================================================================================
*/
Static Function MenuDef()
	
	Local	aRotina	:= {}
	
	ADD OPTION aRotina TITLE "Pesquisar"  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MGFFAT08" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.MGFFAT08" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.MGFFAT08" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.MGFFAT08" OPERATION MODEL_OPERATION_DELETE ACCESS 0
	ADD OPTION aRotina TITLE "Vincular"   ACTION "U_xMF08Vinc()"    OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	
Return(aRotina)

/*
=====================================================================================
Programa............: ModelDef
Autor...............: Joni Lima
Data................: 06/10/2016
Descricao / Objetivo: ModelDef
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Definicao do Modelo de Dados para cadastro de Regras
=====================================================================================
*/
Static Function ModelDef()
	
	Local oModel	:= Nil
	Local oStrSZT 	:= FWFormStruct(1,"SZT")
	Local bTdOk     := {|oModel|xMF08TdOk(oModel)}
	Local bCommit	:= {|oModel|xMF08Cmt(oModel)}
	
	oModel := MPFormModel():New("XMGFFAT08", /*bPreValidacao*/,bTdOk/*bPosValidacao*/,bCommit/*bCommit*/,/*bCancel*/ )
	oModel:AddFields("SZTMASTER",/*cOwner*/,oStrSZT, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	
	oModel:SetDescription('Regras')
	oModel:SetPrimaryKey({"ZT_FILIAL","ZT_CODIGO"})
	
Return(oModel)

/*
=====================================================================================
Programa............: ViewDef
Autor...............: Joni Lima
Data................: 06/10/2016
Descricao / Objetivo: ViewDef
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Definicao da visualizacao da tela
=====================================================================================
*/
Static Function ViewDef()
	
	Local oView		:= Nil
	Local oModel	:= FWLoadModel( 'MGFFAT08' )
	Local oStrSZT	:= FWFormStruct( 2,"SZT")
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	oView:AddField( 'VIEW_SZT' , oStrSZT, 'SZTMASTER' )
	
	oView:CreateHorizontalBox( 'TELA' , 100 )
	oView:SetOwnerView( 'VIEW_SZT', 'TELA' )
	
Return oView

/*
=====================================================================================
Programa............: xMF08TdOk
Autor...............: Joni Lima
Data................: 06/10/2016
Descricao / Objetivo: Validacao pos validacao do Modelo
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Faz a validacao do Modelo de Dados
=====================================================================================
*/
Static Function xMF08TdOk(oModel)
	
	Local aArea 	:= GetArea()
	Local aAreaSZU 	:= SZU->(GetArea())
	Local oMdlSZT 	:= oModel:GetModel('SZTMASTER')
	Local lRet 		:= .T.
	
	If oModel:GetOperation() == MODEL_OPERATION_DELETE
		dbSelectArea('SZU')
		SZU->(dbSetOrder(1))//ZU_FILIAL+ZU_CODRGA+ZU_CODAPR
		If SZU->(DbSeek(xFilial('SZU') + oMdlSZT:GetValue('ZT_CODIGO')))
			lRet := .F.
			Help("",1,"Regra Vinculada",,"Nao sera possivel excluir essa Regra, pois a mesma encontra se vinculada a um ou mais Aprovadores,Caso necessario, � possivel realizar o bloqueio da mesma",1,0)
		EndIf
	EndIf
	
	If lRet .and. oModel:GetOperation() == MODEL_OPERATION_UPDATE .and. oMdlSZT:GetValue('ZT_MSBLQL') <> SZT->ZT_MSBLQL
		If !(xMF08VSZV(oMdlSZT:GetValue('ZT_CODIGO')))
			dbSelectArea('SZU')
			SZU->(dbSetOrder(1))//ZU_FILIAL+ZU_CODRGA
			If SZU->(dbSeek(xFilial('SZU') + oMdlSZT:GetValue('ZT_CODIGO')))
				If oMdlSZT:GetValue('ZT_MSBLQL')=='1'
					If 	Aviso("Bloqueio de Regra", "Foi encontrado vinculo dessa Regra com aprovador(es), caso continue sera efetuado o bloqueio DESSA REGRA para todo(s) o(s) aprovador(es)",;
							{ "Continuar", "Cancelar" }, 1) == 2
						Help(" ",1,"Cancelamento",,"Operacao cancelada pelo usuario",1,0)
						lRet := .F.
					EndIf
				Else
					_nOpcDesp := Aviso("Desbloqueio de Regra", "Foi encontrado vinculo dessa regra com Aprovador(es), deseja que seja desbloqueada a regra para todos o(s) Aprovadore(s)?",;
						{ "Desbloquear", "Nao Desbloquear", "Cancelar" }, 2)
					If _nOpcDesp == 3
						Help(" ",1,"Cancelamento",,"Operacao cancelada pelo usuario",1,0)
						lRet := .F.
					EndIf
				EndIf
			EndIf
		ElseIf oMdlSZT:GetValue('ZT_MSBLQL')=='1'
			Help(" ",1,"Pendencias",,"Existe Pendencias de Liberacao para Essa Regra, Nao sera possivel Bloquear a Mesma",1,0)
			lRet := .F.
		EndIf
	EndIf
	
	RestArea(aAreaSZU)
	RestArea(aArea)
	
Return lRet

/*
=====================================================================================
Programa............: xMF08VSZV
Autor...............: Joni Lima
Data................: 25/10/2016
Descricao / Objetivo: Verifica se Tem Itens Aberto para essa Regra
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Faz a verificacao se existe Itens aberto para essa Regra na Tabela SZV
=====================================================================================
*/
Static Function xMF08VSZV(cRegra)
	Local aArea      := GetArea()
	Local cNextAlias := GetNextAlias()
	Local lRet		 := .F.
	
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	
	BeginSql Alias cNextAlias
		
		SELECT 
			ZV_PEDIDO
		FROM 
			%Table:SZV% SZV
		WHERE
			SZV.%notdel% AND
			SZV.ZV_FILIAL =  %xFilial:SZV% AND
			SZV.ZV_CODRGA =  %exp:cRegra% AND
			SZV.ZV_CODAPR = '      '	
	EndSql
	
	(cNextAlias)->(DbGoTop())
	
	While (cNextAlias)->(!EOF())
		lRet := .T.
		If lRet
			Exit
		EndIf
		(cNextAlias)->(dbSkip())
	EndDo 

	(cNextAlias)->(DbCloseArea())
	
	RestArea(aArea)

Return lRet

/*
=====================================================================================
Programa............: xMF08Cmt
Autor...............: Joni Lima
Data................: 06/10/2016
Descricao / Objetivo: Realizar o Commit do modelo
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Para o desbloqueio ou Bloqueio da SZU.
=====================================================================================
*/
Static Function xMF08Cmt(oModel)
	
	Local aArea 	:= GetArea()
	Local aAreaSZU 	:= SZU->(GetArea())
	Local lRet 		:= .T.
	Local oMdlSZT 	:= oModel:GetModel('SZTMASTER')
	
	dbSelectArea('SZU')
	SZU->(dbSetOrder(1))//ZU_FILIAL+ZU_CODRGA
	
	Begin Transaction
		
		If lRet .and. oModel:GetOperation() == MODEL_OPERATION_UPDATE .and. oMdlSZT:GetValue('ZT_MSBLQL') <> SZT->ZT_MSBLQL
			If SZU->(dbSeek(xFilial('SZU') + oMdlSZT:GetValue('ZT_CODIGO')))
				If oMdlSZT:GetValue('ZT_MSBLQL')=='1'
					While SZU->(!Eof()) .and. SZU->ZU_CODRGA == oMdlSZT:GetValue('ZT_CODIGO')
						If SZU->ZU_MSBLQL <> '1' 
							RecLock('SZU',.F.)
							SZU->ZU_MSBLQL := '1'
							SZU->(MsUnLock())
							SZU->(dbSkip())
						EndIf
					EndDo
				Else
					If _nOpcDesp == 1
						While SZU->(!Eof()) .and. SZU->ZU_CODRGA == oMdlSZT:GetValue('ZT_CODIGO')
							If SZU->ZU_MSBLQL <> '2'
								RecLock('SZU',.F.)
								SZU->ZU_MSBLQL := '2'
								SZU->(MsUnLock())
								SZU->(dbSkip())
							EndIf
						EndDo
					EndIf
				EndIf
			EndIf
		EndIf

		If lRet
			If oModel:VldData()
				FwFormCommit(oModel)
				oModel:DeActivate()
			Else
				JurShowErro( oModel:GetModel():GetErrormessage() )
				lRet := .F.
				DisarmTransaction()
			EndIf
		EndIf
		
	End Transaction
	
	RestArea(aAreaSZU)
	RestArea(aArea)
	
Return lRet
/*
=====================================================================================
Programa............: xMF08VldFn
Autor...............: Joni Lima
Data................: 17/10/2016
Descricao / Objetivo: Realiza a Validacao da funcao
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Faz a validacao da funcao digitada
=====================================================================================
*/
User Function xMF08VldFn(cForm)
	
	Local lRet 		:= .T.
	
	Default cForm 	:= ''
	
	cForm := AllTrim(UPPER(cForm))
	
	If lRet .and. !Empty(cForm)
		bBlock := ErrorBlock( { |e| ChecErro(e) } )
		BEGIN SEQUENCE
			xResult := &cForm
		RECOVER
			lRet := .F.
		END SEQUENCE
		ErrorBlock(bBlock)
	EndIf
	
Return lRet

/*
=====================================================================================
Programa............: xMF08CadPDR
Autor...............: Joni Lima
Data................: 17/10/2016
Descricao / Objetivo: Realiza o cadastro das Regras criadas
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Gera Regra da 01 a 39.
=====================================================================================
*/
Static Function xMF08CadPDR()
	
	Local aArea 	:= GetArea()
	Local aAreaSZT	:= SZT->(GetArea())
	Local aCadastr	:={	{'01','Cliente Suspenso','2'},;
						{'02','Cliente com duplicatas em atraso','2'},;
						{'03','Cliente com dias de atraso medio atingido','2'},;
						{'04','Cliente sem limite de credito','2'},;
						{'05','Endereco de entrega bloqueado','1'},;
						{'06','Alteracao da condicao de pagamento','2'},;
						{'07','Total do pedido maior que o limite de credito','2'},;
						{'08','Valor total abaixo do manimo','2'},;
						{'09','Condicao de Pagamento Antecipada','2'},;
						{'73','Preco maximo de venda atingido','3'},;
						{'11','Saldo minimo em estoque atingido','3'},;
						{'74','Bloqueio Valor Abaixo Desconto Progressivo','1'},;
						{'72','Preco abaixo do preco da lista','3'},;
						{'71','Preco manimo de venda atingido','3'},;
						{'15','Data de limite de credito vencida','2'},;
						{'16','Pedido aguardando transferencia','3'},;
						{'17','Bloqueio Fiscal Nao Contribuinte DIFAL','2'},;
						{'18','Bloqueio por Tipo de Pedido (Bonificacao, Doacao, Amostra)','2'},;
						{'90','Bloqueio Receita Federal','1'},;
						{'91','Indisponibilidade Receita Federal','1'},;
						{'92','Bloqueio Sintegra','1'},;
						{'93','Indisponibilidade Sintegra','1'},;
						{'94','Bloqueio Suframa','1'},;
						{'95','Indisponibilidade Suframa','1'},;			
						{'96','Aguardando Consulta Receita Federal','1'},;
						{'97','Aguardando Consulta Sintegra','1'},;						
						{'98','Aguardando Consulta Suframa','1'},;
						{'99','Pedido de Perda','1'}}
	Local ni		:= 0
	Local oModMF08	:= nil
	Local oMdlSZT	:= nil
	
	ProcRegua(Len(aCadastr))
	
	For ni := 1 to Len(aCadastr)
		DbSelectArea('SZT')
		SZT->(dbSetOrder(1))//ZT_FILIAL, ZT_CODIGO
		IncProc()
		If !(SZT->(dbSeek(xFilial('SZT') + '0000' + aCadastr[ni,1])))
			
			oModMF08:= FWLoadModel( 'MGFFAT08' )
			oModMF08:SetOperation( MODEL_OPERATION_INSERT )
			
			If oModMF08:Activate()
				
				oMdlSZT := oModMF08:GetModel('SZTMASTER')
				
				//If Alltrim(aCadastr[ni,1]) $'90|91|92|93|94|95|96|97|98|99'//Item de Perda
				oMdlSZT:SetValue('ZT_CODIGO',STRZERO(val(aCadastr[ni,1]),6,0))
				//EndIf
				
				oMdlSZT:SetValue('ZT_DESCRI',Alltrim(aCadastr[ni,2])	)
				oMdlSZT:SetValue('ZT_TIPO'	,aCadastr[ni,3]	)
				oMdlSZT:SetValue('ZT_FUNCAO','U_MGFFAT16("' + aCadastr[ni,1] + '")'	)
				
				If oModMF08:VldData()
					lRet := FwFormCommit(oModMF08)
					oModMF08:DeActivate()
					oModMF08:Destroy()
				Else
					JurShowErro( oModMF08:GetModel():GetErrormessage() )
					lRet := .F.
				EndIf
			EndIf
		EndIf
	Next ni
	
	RestArea(aAreaSZT)
	RestArea(aArea)
	
Return

/*
=====================================================================================
Programa............: xMF08Vinc
Autor...............: Joni Lima
Data................: 07/10/2016
Descricao / Objetivo: Realiza o vinculo do Aprovador com as Regras
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Faz o vinculo do Aprovador com as Regras
=====================================================================================
*/
User Function xMF08Vinc()
	
	Local aArea := GetArea()
	Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}
	
	If SZT->ZT_MSBLQL <> '1'
		FWExecView("Alteracao", "MGFFAT09", MODEL_OPERATION_UPDATE,, {|| .T.}, , ,aButtons)	//"Alteracao"
	Else
		Help(" ",1,"Regra Bloqueado",,"Nao sera possivel realizar vinculo com nenhum Aprovador pois a regra encontra-se bloqueada",1,0)
	EndIf
	
	RestArea(aArea)
	
Return