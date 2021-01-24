/*
=====================================================================================
Programa............: MGFFIN60
Autor...............: Atilio Amarilla
Data................: 26/09/2017
Descricao / Objetivo: Estornar baixa para ocorrência H4 Retorno de Crédito não pago
Doc. Origem.........: Contrato - GAP CNAB
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Chamado por PE FA430OCO
=====================================================================================
*/

User Function MGFFIN60()

	local aArea		:= GetArea()
	local aAreaSE2	:= SE2->( GetArea() )
	local aAreaSE5	:= SE5->( GetArea() )
	local aAreaFK5	:= FK5->( GetArea() )

	local aTitBxEst	:= {}
	local cOcorrEst	:= GetMv("MGF_FIN60A",,"H4/")

	local nTamPre	:= TamSX3("E1_PREFIXO")[1]
	local nTamNum	:= TamSX3("E1_NUM")[1]
	local nTamPar	:= TamSX3("E1_PARCELA")[1]
	local nTamTit	:= nTamPre+nTamNum+nTamPar

	local nI
	local nOpBaixa	:= 0

	// Variáveia necessárias para Sel080Baixa()
	local nTotAdto		:= 0
	local lBaixaAbat	:= .F.
	local lBxCEC		:= .F.  //Verificador de existencia de baixa por compensacao entre carteiras
	local lNotBax		:= .F.
	local nTotImpost	:= 0  //Valores de baixas de por geracao de impostos
	local lAglImp		:= .F.
	local lFina379		:= IsInCallStack("FINA379")
	local nTotaIRPF		:= 0
	local lBxLiq		:= .F.
	local aBaixa		:=	{}
	Private aBaixaSE5	:=	{}

	Private _dCancBx	:= dDataBase
	Private lMsErroAuto := .F.

	if SEB->EB_OCORR $ "03" .And. AllTrim( SEB->EB_REFBAN ) $ cOcorrEst

		dbSelectArea("SE2")
		dbSetOrder(11)  // Filial+IdCnab
		if !DbSeek(xFilial("SE2")+	Substr(cNumTit,1,nTamTit))
			dbSetOrder(1)
			dbSeek(xFilial()+Pad(cNumTit,nTamTit)+cEspecie) // Filial+Prefixo+Numero+Parcela+Tipo
		endif

		dbSelectArea("SEA")
		dbSetOrder(1)
		dbSeek(xFilial()+SE2->E2_NUMBOR+SE2->E2_PREFIXO+;
			SE2->E2_NUM+SE2->E2_PARCELA+;
			SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)
		if ( SEA->(Found()) .And. SE2->E2_SALDO == 0 ) .or. ( SEA->(Found()) .And. SE2->E2_SALDO > 0 .AND. SE2->E2_TIPO='PA')
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cancelamento da Baixa										  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAdd( aTitBxEst , { "E2_PREFIXO"	, SE2->E2_PREFIXO	, NIL	} )
			aAdd( aTitBxEst , { "E2_NUM"		, SE2->E2_NUM		, NIL	} )
			aAdd( aTitBxEst , { "E2_PARCELA"	, SE2->E2_PARCELA	, NIL	} )
			aAdd( aTitBxEst , { "E2_TIPO"		, SE2->E2_TIPO		, NIL	} )
			aAdd( aTitBxEst , { "E2_FORNECE"	, SE2->E2_FORNECE	, NIL	} )
			aAdd( aTitBxEst , { "E2_LOJA"		, SE2->E2_LOJA		, NIL	} )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Procura pelas baixas deste titulo                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// GDN 05/09/2018 - Correcao para Tratar caso o TIPODOC for PA.

			aBaixa := Sel080Baixa("VL /BA /CP /PA ",SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,@nTotAdto,;
				@lBaixaAbat,SE2->E2_FORNECE,SE2->E2_LOJA,@lBxCec,.T.,@lNotBax,@nTotImpost,@lAglImp;
				,if((Funname() == "FINA450" .or. Funname() == "FINA703") .and. Type("lF080Auto")<>"U",.T.,.F.) ,lFina379,@nTotaIRPF,SE2->E2_IDENTEE,@lBxLiq) // Recalculo do PCC (FINA379))

			//ordena array de abaixa pelo sequencia E5_SEQ
			aSort(aBaixa,,,{|x,y| SubStr(x,Len(x)-1,Len(x)) < SubStr(y,Len(y)-1,Len(y))})
			aSort(aBaixaSE5,,, {|x,y| x[9] < y[9] } )

			if aBaixaSE5[Len(aBaixaSE5),8] > 0 // Valor da Baixa
				nOpBaixa	:= Len(aBaixaSE5)
			else
				For nI := Len(aBaixaSE5) to 1 Step -1
					if aBaixaSE5[Len(aBaixaSE5),8] > 0 .And. nOpBaixa	== 0
						nOpBaixa	:= nI
					endif
				Next ni

			endif

			if nOpBaixa	> 0

				// GAP - Retirar Bordero, Cancelar Baixa e limpar IDCNAB para Títulos PA
				// GDN 05/09/2018
				// Com (erick): Se for tipo PA e motivo de baixa diferente de NOR
				// and o LA tem que estar em branco, buscar no FK5 e no SE5 e
				// deletar estes registros.
				if ALLTRIM(SE2->E2_TIPO) = 'PA'
					// Posicionar no SE5 deste Título
					SE5->(dbSetOrder(7))
					SE5->(dbSeek(xFilial("SE5")+SE2->E2_PREFIXO+SE2->E2_NUM+;
						SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA+'  '))
					if SE5->(Found()) .AND. SE5->E5_MOTBX = 'NOR'
						// Posicionar no FK5 desta baixa pelo ID
						FK5->(dbSetOrder(1))
						FK5->(dbSeek(xFilial("FK5")+SE5->E5_IDORIG))
						if FK5->(Found())
							// Apagar o Lançamento do FK5
							if FK5->(RecLock("FK5",.F.))
								FK5->(dbDelete())
								FK5->(MsUnLock())
							endif
						endif
						// Apagar o Lançamento do SE5
						if SE5->(RecLock("SE5",.F.))
							SE5->(dbDelete())
							SE5->(MsUnLock())
						endif

						// Chamada Função FA590Canc para que o Título seja retirado corretamente do borderô Imp.
						FA590Canc()

						// GDN 12/09/2018 - Limpar o IDCNAB
						if !Empty(SE2->E2_IDCNAB)
							SE2->(RecLock("SE2",.F.))
							SE2->E2_IDCNAB := ""
							SE2->(MsUnlock())
						endif
					else
						MsgInfo(" Título: "+SE2->E2_PREFIXO+"/"+SE2->E2_NUM+"/"+SE2->E2_PARCELA+" não tem SE5/FK5 !","Atenção")
					endif
				endif

				// Chamada da rotina automatica Baixa Pagar MANUAL
				MsExecAuto({|w,x,y,z| FINA080(w,x,y,z)},aTitBxEst,5,.F.,nOpBaixa)

				// Mostra Erro na geracao de Rotinas automaticas
				if !lMsErroAuto .And. SE2->E2_SALDO > 0
					_dCancBx	:=	cTod(SUBS(ABAIXA[1], 41, 10))
					
					// Chamada Função FA590Canc para que o Título seja retirado corretamente do borderô Imp.
					FA590Canc()

					//Rafael Garcia 11/04 - limmpa ID_CNAB para novo processamento
					if !Empty(SE2->E2_IDCNAB)
						SE2->(RecLock("SE2",.F.))
						SE2->E2_IDCNAB := ""
						SE2->(MsUnlock())

						//muda a data da disponibilidade na SE5
						SE5->(RecLock("SE5",.F.))
						SE5->E5_DTDISPO :=	_dCancBx
						SE5->(MsUnlock())
					endif
				endif
				// retorna perguntas da rotina chamadora
				if IsInCallStack("FINA430")
					Pergunte("AFI430",.F.)
				endif
			endif
		endif

		SE2->( RestArea( aAreaSE2 ) )
		SE5->( RestArea( aAreaSE5 ) )
		FK5->( RestArea( aAreaFK5 ) )

		RestArea( aArea )

	endif


Return( NIL )
