#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFCOM66
Autor...............: Totvs
Data................: 02/02/2018 
Descricao / Objetivo: Compras 
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: 
Obs.................: Rotina chamada pelo ponto de entrada MT100TOK
=====================================================================================
*/
User Function MGFCOM66()

Local aArea := {GetArea()}
Local lRet := .T.

If l103Class
	If Empty(SF1->F1_ZVLRTOT)
		lRet := .F.
		ApMsgAlert("Valor total Marfrig nao foi informado."+CRLF+;
		"Acesse a opcao 'Valor Total Marfrig', no menu 'Outras Acoes' e informe o valor total da nota.")
	Else
		If Empty(SF1->F1_ZBLQVAL) .or. SF1->F1_ZBLQVAL == "S" // somente valida valores totais se bloqueio estiver em branco ou como sim
			If !(MaFisFound() .and. MaFisRet(,"NF_TOTAL") == SF1->F1_ZVLRTOT) // se valores diferentes, bloqueia documento
				If Abs(MaFisRet(,"NF_TOTAL") - SF1->F1_ZVLRTOT) > GetMv("MGF_TOLNFE",,0) 
					lRet := .F.
					APMsgAlert("Valor total digitado nao � igual ao Valor total calculado pelo sistema ( aba Totais da nota )."+CRLF+;
					"Nao  sera possivel confirmar a Classificacao do documento e o mesmo ficara bloqueado aguardando aprovacao."+CRLF+;
					"Sera necessario sair da tela pelo botao 'Cancelar'.")
					If Empty(SF1->F1_ZBLQVAL)
						If APMsgYesNo("Confirma bloqueio do Documento ?"+CRLF+;
						CRLF+;
						"OBS: Apos esta operacao, nao sera mais possivel alterar o Valor Total Marfrig.")
							Com66Bloq()
						Endif		
					Endif	
				Endif	
			Endif
		Elseif SF1->F1_ZBLQVAL == "N" // avalia se valor total da nota foi alterado, com relacao ao valor encontrado na classificacao, o qual gerou o bloqueio do documento
			// mudanca de valores no documento
			//If !(MaFisFound() .and. MaFisRet(,"NF_TOTAL") == SF1->F1_ZVLTOCL)
			//	If Abs(MaFisRet(,"NF_TOTAL") - SF1->F1_ZVLTOCL) > GetMv("MGF_TOLNFE",,0) 
			//		lRet := .F.
			//	Endif
			//Endif
			
			// mudanca de valores no campo customizado de valor total marfrig		
			If lRet
				If !(MaFisFound() .and. MaFisRet(,"NF_TOTAL") == SF1->F1_ZVLRTOT) // se valores diferentes, bloqueia documento
					If Abs(MaFisRet(,"NF_TOTAL") - SF1->F1_ZVLRTOT) > GetMv("MGF_TOLNFE",,0) 
						lRet := .F.
					Endif
				Endif
			Endif			
				
			If !lRet	
				//APMsgAlert("Valor total calculado pelo sistema nesta classificacao nao � igual ao Valor total calculado pelo sistema na classificacao que gerou o bloqueio do documento."+CRLF+;
				//"Ou campo de Valor Total Marfrig foi alterado pelo usuario."+CRLF+;
				//"Utilize a mesma TES da classificacao anterior no(s) iten(s) e nao altere nenhum campo que mude o valor do documento, para que o valor total nao seja diferente."+CRLF+;
				//"Nao  sera possivel confirmar a Classificacao do documento e o mesmo ficara bloqueado aguardando aprovacao."+CRLF+;
				//"Sera necessario sair da tela pelo botao 'Cancelar'.")
				APMsgAlert("Valor total digitado nao � igual ao Valor total calculado pelo sistema ( aba Totais da nota )."+CRLF+;
				"Nao  sera possivel confirmar a Classificacao do documento e o mesmo ficara bloqueado aguardando aprovacao."+CRLF+;
				"Sera necessario sair da tela pelo botao 'Cancelar'.")
				
				If APMsgYesNo("Confirma bloqueio do Documento ?"+CRLF+;
				CRLF+;
				"OBS: Apos esta operacao, nao sera mais possivel alterar o Valor Total Marfrig.")
					Com66Bloq()
				Endif		
			Endif	
		Endif		
	Endif	
Endif

aEval(aArea,{|x| RestArea(x)})
			
Return(lRet)		


Static Function Com66Bloq()

Local aArea := {SY1->(GetArea()),SAL->(GetArea()),GetArea()}
Local cGrupo := ""
Local nPosTes := aScan(aHeader,{|x| Alltrim(x[2])=="D1_TES"})
Local nPosTesClas := aScan(aHeader,{|x| Alltrim(x[2])=="D1_TESACLA"})

cGrupo := GetMv("MGF_GRPNFE") //SuperGetMv("MV_NFAPROV")
					
//SY1->(dbSetOrder(3))
//SY1->(MsSeek(xFilial("SY1")+__cUserId))
						
//SAL->(dbSetOrder(3))
//If SAL->(MsSeek(xFilial("SAL")+RetCodUsr()))
//	cGrupo := IIf((SY1->(Found()) .and. !Empty(SY1->Y1_GRAPROV)),SY1->Y1_GRAPROV,cGrupo)
//EndIf
					
//��������������������������������������������������������������Ŀ
//� Ponto de entrada para alterar o Grupo de Aprovacao.          �
//����������������������������������������������������������������
//If ExistBlock("MT140APV")
//	cGrupo := ExecBlock("MT140APV",.F.,.F.,{cGrupo})
//EndIf
					
SAL->(dbSetOrder(2))
If !Empty(cGrupo) .And. SAL->(dbSeek(xFilial("SAL")+cGrupo))

	Begin Transaction 
	
	//cGrupo:= If(Empty(SF1->F1_APROV),cGrupo,SF1->F1_APROV)
	// estorna alcadas anteriores
	MaAlcDoc({SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+"_VALOR_NFE","NF",SF1->F1_VALBRUT,,,cGrupo,,IIf(Empty(SF1->F1_MOEDA),1,SF1->F1_MOEDA),SF1->F1_TXMOEDA,SF1->F1_EMISSAO},SF1->F1_EMISSAO,3)
	
	// inclui alcada
	MaAlcDoc({SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+"_VALOR_NFE","NF",SF1->F1_VALBRUT,,,cGrupo,,IIf(Empty(SF1->F1_MOEDA),1,SF1->F1_MOEDA),SF1->F1_TXMOEDA,SF1->F1_EMISSAO},SF1->F1_EMISSAO,1)
	
	SF1->(Reclock("SF1",.F.))
	SF1->F1_STATUS := "B"
	//If Empty(SF1->F1_APROV) // nao gravar, para nao conflitar com o grupo de tolerancia do padrao
	//	SF1->F1_APROV := cGrupo
	//Endif	
	If SF1->F1_ZBLQVAL != "S"
		SF1->F1_ZBLQVAL := "S"
	Endif
	If IsInCallStack("MATA103")	
		SF1->F1_ZVLTOCL := MaFisRet(,"NF_TOTAL") // atualiza novo valor para comparacao com o valor digitado
	Endif	
	SF1->(MsUnLock())
	
	End Transaction 
	
	If IsInCallStack("MATA103")
		// grava o tes a classificar
		aEval(aCols,{|x,y| IIf(!x[Len(x)],IIf(Empty(x[nPosTesClas]) .and. !Empty(x[nPosTes]),aCols[y][nPosTesClas]:=x[nPosTes],Nil),Nil) })
	Endif	

	APMsgInfo("Documento bloqueado com sucesso.")
Else
	If Empty(cGrupo)
		ApMsgAlert("Grupo de aprovacao para divergencia de valor da NFE nao informado no parametro 'MGF_GRPNFE'.")
	Else	
		APMsgAlert("Nao  foi possivel encontrar o cadastro do Grupo de Aprovacao para este documento x aprovador. Grupo: "+cGrupo+"."+CRLF+;
		"Verifique as regras de aprovacao.")
	Endif	
Endif	

aEval(aArea,{|x| RestArea(x)})
			
Return()		
