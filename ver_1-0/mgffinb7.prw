#include "protheus.ch"
#include 'parmtype.ch'
#INCLUDE "FINA550.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "rwmake.ch"

Static lPmsInt:= IsIntegTop(,.T.)
//Permite reposição manual do caixinha com valores acima do limite: 1 - Permite; 2 - Não permite.
STATIC lRpMnAcLim	:= SuperGetMV("MV_RPCXMN",.T.,"1") == "1"
//Permite que sejam realizadas reposições acima do valor do caixinha: T - Permite; F - Não Permite
STATIC lRpAcVlCx	:= SuperGetMV("MV_RPVLMA",.T.,.F.)


//----------------------------------------------------------------------
/*/{Protheus.doc} ºFA550RCan()
Realiza o Estorno da Reposição e retorna o saldo ao banco.

@author Daniel Ferraz Lacerda
@since 27/12/2016
@version 11
@param cAlias, Alias ativo
@param nReg, Registro
@param nOpc, Chamada do Menudef
@param lAutomato. T. ou .F. Automatico ou não.
@return Nill
/*/
//----------------------------------------------------------------------
User Function FA550RCan(cAlias,nReg,nOpc,lAutomato)
	Local aAreaAnt 	:= GetArea()
	Local cCaixa 	:= SEU->EU_CAIXA
	Local cNumSeq 	
	Local lRet 		:= .T.
	Local Cquery 	:= ""
	Local aEstor 	:= {}
	Local cAliasQry := ""
	Local oDlg := Nil
	Local aTel :={}
	Local nTN := TAMSX3("EU_NUM")[1]
	Local aBco := {}
	Local nCanRep := 0
	Local aAreaSEU := {}
	Local aAreaSEF := {}
	Local cLiberado := GetMV("MV_LIBCHEQ")
	Local lPadrao57E := VerPadrao("57E")
	Local lGeraLanc  := .T. //O Estorno da reposição ocorrerá somente On-line
	Local nHdlPrv := 0
	local _nX    := 0
	Local lUsaFlag := SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
	Local aFlagCTB := {}
	Local _aVetRet := {}
	Local cArquivo := ""
	Local nTotal := 0
	Local lDigita := Iif(mv_par01 ==1,.T.,.F.)
	Local lAglutina := Iif(mv_par02 ==1,.T.,.F.)
	Local cBanco := ""
	Local nValor := 0
	Local cNumero := "" 
	Local cAgen := ""
	Local cConta := ""
	Local cCheque := ""
	Local dDtDigit := CTOD("//")
	Local cText := ""
	Local cCxaDes
	Local _cHist	:= ""
	Local _cMsgHis	:= ""
	Local cNumTit 	:= ""
	Local cHis		:= ""
	Local cNrc		:= ""
	Local cZco		:= ""
	Local cZlo		:= ""
	Local cCcd		:= ""
	Local cNat		:= ""
	Local cNap		:= ""
	Local _nEtSaldo := 0

	#DEFINE CRLF CHR(13)+CHR(10) //FINAL DE LINHA
	Private aDiario := {}
	Private cLote := ""
	Private lEsModII := Iif( SuperGetMV( "MV_FINCTMD", .T., 1 ) == 1, .F., .T. ) //Solo aplica para modelo II
	DEFAULT lAutomato := .F.

	Private aReposi:={}
	lBaixa := .F.  // Baixa movimentos
	lRepor := .F.  // Repoe
	lOriMv := .F.  // Reposicao originada pela entrada de movimento (atingiu limite)
	lFecha := .F.  // Baixa movimentos

	nMoedaBco := IIf( Type('nMoedaBco') == 'U',0,nMoedaBco )

	If lRepor .and. cPaisLoc $'ARG|BRA' .and. lRpMnAcLim
		If !Fa550BcRep(cCaixa,,@aReposi,0,,lLimite)
			Return(0) /*Function Fa550Rep20*/
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Solicita aprovação para reposição de saldo do caixinha.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//Se configurado para aprovação de alçadas
		If ( cTipoLib == "2" )
			nOpcLib := Fa550Libera(aReposi)

			//Se não foi aprovado termina
			If nOpcLib == 0
				Return 0
			EndIf

		EndIf
	Endif

	LoteCont("FIN")


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona-se no caixinha                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SET")
	dbSetOrder(1)
	dbSeek( xFilial()+cCaixa)
	nSalAnt := SET->ET_SALANT
	dUltRep := SET->ET_ULTREP

	cAliasQry := GetNextAlias()

	cQuery := "SELECT EU_FILIAL, EU_TIPO, EU_CAIXA, EU_NUM,EU_VALOR,EU_TITULO,"
	cQuery += "EU_HISTOR,EU_BANCO,EU_AGENCI,EU_DTDIGIT, EU_CONTARE, EU_SEQCXA, D_E_L_E_T_"
	cQuery += " FROM " + RetSQLTAB('SEU')
	cQuery += " WHERE"  
	cQuery += " EU_FILIAL = '" + FWxFilial('SEU') + "' AND"
	cQuery += " EU_TIPO = '10' AND EU_CAIXA ='" + cCaixa
	cQuery += "' AND EU_SLDADIA = '0' AND D_E_L_E_T_ = '' " // AND ROWNUM <= 1 "
	cQuery += " ORDER BY EU_NUM DESC "
	cQuery := ChangeQuery(cQuery)

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)

	If !(cAliasQry)->(Eof())
		// While !(cAliasQry)->(Eof()) // Retirado o laço para se ter apenas a última reposição
		AADD( aEstor,{(cAliasQry)->EU_NUM,(cAliasQry)->(EU_VALOR),(cAliasQry)->(EU_HISTOR),(cAliasQry)->(EU_DTDIGIT),;
		(cAliasQry)->(EU_BANCO),(cAliasQry)->(EU_AGENCI),(cAliasQry)->(EU_CONTARE),(cAliasQry)->(EU_TITULO)} )

		cTel := CVALTOCHAR((cAliasQry)->EU_NUM) + "   " + CVALTOCHAR((cAliasQry)->EU_VALOR) + "      " + dtoc(stod((cAliasQry)->EU_DTDIGIT))

		AADD(aTel,cTel)
		//(cAliasQry)->(DbSkip())
		
		cNumSeq:= STRZERO((VAL((cAliasQry)->EU_SEQCXA) - 1),6)
		cCxaDes:= STRZERO((Val((cAliasQry)->EU_SEQCXA)+1),6)
		cNumTit:= SUBSTR((cAliasQry)->EU_HISTOR,1,9)
		
		//EndDo
	Else
		Alert(STR0108)
		lRet := .F.
	Endif

	(cAliasQry)->(dbCloseArea())


	If lRet
		If Len(aTel) >= 1 //Mais de uma reposição, o usuário escolhe
			cListBox := aTel[Len(aTel)]
			nOpbaixa := 0

			DEFINE MSDIALOG oDlg FROM 5, 5 TO 14, 56 TITLE "Última Reposição Disponível" // STR0109 //"Escolha A Baixa"

			@  .5, 2 LISTBOX cListBox ITEMS aTel SIZE 171 , 40 Font oDlg:oFont
			DEFINE SBUTTON FROM 055,137 TYPE 1 ACTION (nOpbaixa := 1,oDlg:End()) ENABLE OF oDlg
			DEFINE SBUTTON FROM 055,164 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

			ACTIVATE MSDIALOG oDlg CENTERED
			If nOpBaixa == 1
				nCanRep := Ascan(aTel,PADR(cListBox,nTN))
			Endif

			If nOpBaixa == 0
				lRet := .F.
			Endif
		Endif

		If lRet

			//**************************************************************************************
			// Consistir para que só possa haver Devolução/Estorno de Reposição de Não houver
			// Título no Contas a Pagar
			//**************************************************************************************

			_cHist:= "CXA-" + AllTrim(cCaixa) + " - REPOSICAO"
			cAliasQry := GetNextAlias()

			cQuery := "SELECT E2_HIST, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_BAIXA "
			cQuery += " FROM " + RetSQLTAB('SE2')
			cQuery += " WHERE"  
			cQuery += " E2_FILIAL = '" + FWxFilial('SE2') + "' AND"
			cQuery += " E2_NUM = '" + cNumTit + "' AND"
			cQuery += " E2_PREFIXO = 'CXA' AND E2_HIST LIKE '" + _cHist +"%' "
			cQuery += " AND D_E_L_E_T_ = '' "
			cQuery := ChangeQuery(cQuery)

			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)

			If !(cAliasQry)->(Eof())
				_cMsgHis:= (cAliasQry)->E2_NUM + "/" + (cAliasQry)->E2_PREFIXO  
				If !Empty((cAliasQry)->E2_BAIXA)
					_cMsgHis+=" Baixado "
				Else
					_cMsgHis+=" Aberto "
				EndIf
				_cMsgHis+= "no Contas a Pagar!"
				lRet := .F.
				MsgAlert("Estorno na Reposição Não permitido! Há Título: "+ _cMsgHis)
			Endif

			(cAliasQry)->(dbCloseArea())	

		EndIf


		If lRet
			DbSelectArea("SEU")
			If lPadrao57E .And. lGeraLanc
				If nHdlPrv <= 0
					LoteCont("FIN")
					//Inicializa Lancamento Contabil
					nHdlPrv := HeadProva( cLote,"FINA550" /*cPrograma*/,Substr( cUsuario, 7, 6 ),@cArquivo )
				Endif
			EndIf

			If Len(aTel) > 0 //Se for somente uma Reposição, apresenta tela para ser cancelada.
				if Empty(nCanRep)
					cNumero := aEstor[1][1]	
					nValor := aEstor[1][2]
					cBanco := aEstor[1][5]
					cAgen := aEstor[1][6]
					cConta := aEstor[1][7]
					cCheque := aEstor[1][8]
					dDtDigit := aEstor[1][4]
				Else	
					cNumero := aEstor[nCanRep][1]	
					nValor := aEstor[nCanRep][2]
					cBanco := aEstor[nCanRep][5]
					cAgen := aEstor[nCanRep][6]
					cConta := aEstor[nCanRep][7]
					cCheque := aEstor[nCanRep][8]
					dDtDigit := aEstor[nCanRep][4]
				Endif	

				cText := STR0110 + CRLF + CRLF
				cText += STR0111 + cNumero + CRLF
				cText += STR0112 + CVALTOCHAR(nValor) + CRLF
				if !Empty(cBanco)
					cText += STR0113 + cBanco + CRLF
					cText += STR0114 + cAgen + CRLF
					cText += STR0115 + cConta + CRLF
				Endif
				if !Empty(cCheque)
					cText+= STR0116 + cCheque + CRLF
				Endif	

				If MSGYESNO(ctext,STR0117)

					//IF STOD(dDtDigit) == dDataBase

					If !Empty(cCheque) .and. cLiberado == "N" //Verifica se o Cheque já foi liberado
						DbSelectArea("SEF")
						aAreaSEF := SEF->( GetArea() )
						SEF->( DbSetOrder(1) )
						If SEF->( DbSeek(FWxFilial("SEF")+ cBanco + cAgen + cConta + cCheque ) )
							IF SEF->EF_LIBER = "S"
								lRet := .F.
							Endif
						Endif
						RestArea(aAreaSEF)
					Endif						

					IF SET->ET_SALDO >= nValor .and. lRet

						If  nHdlPrv > 0
							//Prepara Lancamento Contabil
							If lUsaFlag  //Armazena em aFlagCTB para atualizar no modulo Contabil 
								aAdd( aFlagCTB, {"EU_LA", "S", "SEU", SEU->( Recno() ), 0, 0, 0} )
							Endif
							nTotal += DetProva( nHdlPrv, "57E" /*cPadrao*/,"FINA550" /*cPrograma*/,cLote,/*nLinha*/,/*lExecuta*/,/*cCriterio*/,/*lRateio*/,/*cChaveBusca*/,/*aCT5*/,/*lPosiciona*/,@aFlagCTB,/*aTabRecOri*/,/*aDadosProva*/ )				 
						Endif

						Begin Transaction

							//Criar o movimento de Estorno
							If!Empty(cBanco)
								aadd(aBco,cBanco)
								aadd(aBco,cAgen)
								aadd(aBco,cConta)
							Endif

							//Retorna o Saldo da Reposição para diferenciar
							DbSelectArea("SEU")
							aAreaSEU := SEU->( GetArea() )
							SEU->( DbSetOrder(1) )
							If SEU->( DbSeek(xFilial("SEU") + cNumero) )
								RecLock("SEU",.F.)
								Replace EU_SLDADIA With nValor
								SEU->( MsUnlock() )
							Endif								

							Fa550Mov(cCaixa, "11",nValor,"Est. Reposicao" + CVALTOCHAR(cNumero) ,aBco,,, )

							//Alterar o saldo do caixinha
							AtuSalCxa(cCaixa, dDataBase , nValor )
							U_Fa550SLCR(cCaixa,.T.,nValor)

							If Empty(cCheque)
								//Alterar o saldo do Banco e cria registro na SE5
								FA550MvBco("E",nValor,STR0118,,cNumero,aBco)
							Else //Cancelar o Cheque
								DbSelectArea("SEF")
								aAreaSEF := SEF->( GetArea() )
								SEF->( DbSetOrder(1) )
								If SEF->( DbSeek(xFilial("SEF")+ cBanco + cAgen + cConta + cCheque ) )
									RecLock("SEF",.F.)
									SEF->( dbDelete() )
									SEF->( MsUnlock() )
									If 	cLiberado == "S"
										FA550MvBco("E",nValor,STR0119,cCheque,cNumero,aBco)
									Endif
								Endif
								RestArea( aAreaSEF )
							Endif


							//**************************************************************************************
							// Excluir todas as Despesas do SEU, refrente a Reposição Estornada
							//**************************************************************************************

							cAliasQry := GetNextAlias()

							cQuery := "SELECT EU_HISTOR, EU_NRCOMP, EU_ZCODF, EU_ZLOJF, EU_CCD, EU_ZNATUR, EU_ZNUMAPR, EU_VALOR, R_E_C_N_O_  RECSEU "
							cQuery += " FROM " + RetSQLTAB('SEU')
							cQuery += " WHERE EU_FILIAL = '" + FWxFilial('SEU') 
							cQuery += "' AND EU_TIPO = '00' AND EU_CAIXA ='" + cCaixa
							cQuery += "' AND EU_SEQCXA = '"  + cNumSeq
							cQuery += "' AND D_E_L_E_T_ = '' "
							cQuery += "  ORDER BY EU_NUM "
							cQuery := ChangeQuery(cQuery)

							DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)


							If !(cAliasQry)->(Eof())
								/*
								cHis:= (cAliasQry)->EU_HISTOR 
								cNrc:= (cAliasQry)->EU_NRCOMP
								cZco:= (cAliasQry)->EU_ZCODF
								cZlo:= (cAliasQry)->EU_ZLOJF
								cCcd:= (cAliasQry)->EU_CCD
								cNat:= (cAliasQry)->EU_ZNATUR
								cNap:= (cAliasQry)->EU_ZNUMAPR
								*/
								While !(cAliasQry)->(Eof())
								
								 	aAdd(_aVetRet,{(cAliasQry)->EU_HISTOR,;
								 	(cAliasQry)->EU_NRCOMP,;
								 	(cAliasQry)->EU_ZCODF,;
								 	(cAliasQry)->EU_ZLOJF,;
								 	(cAliasQry)->EU_CCD,;
								 	(cAliasQry)->EU_ZNATUR,;
								 	(cAliasQry)->EU_ZNUMAPR})
								
									SEU->(dbGoTo((cAliasQry)->RECSEU))
									_nEtSaldo += (cAliasQry)->EU_VALOR
									RecLock("SEU",.F.)
									SEU->( dbDelete() )
									SEU->( MsUnlock() )
									(cAliasQry)->(DbSkip())
								EndDo
							Endif

							(cAliasQry)->(dbCloseArea())

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Posiciona-se no caixinha para devolver a soma dos valores das Despesas   ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							
							dbSelectArea("SET")
							dbSetOrder(1)
							dbSeek( xFilial()+cCaixa)
							RecLock("SET",.F.)
								SET->ET_SALDO:=_nEtSaldo
							SET->( MsUnlock() )

							//**************************************************************************************
							// Abrir Novamente as Despesas para Aprovação
							//**************************************************************************************
							for _nX := 1 to len(_aVetRet)
								cAliasQry := GetNextAlias()
	
								cQuery := "SELECT R_E_C_N_O_  RECZE0 "
								cQuery += " FROM " + RetSQLTAB('ZE0')
								cQuery += " WHERE ZE0_FILIAL = '" + FWxFilial('ZE0')
								
								cQuery += "' AND ZE0_CAIXA ='" 		+ cCaixa
								cQuery += "' AND ZE0_HISTOR = '"  	+ _aVetRet[_nX][1]
								cQuery += "' AND ZE0_NRCOMP = '"  	+ _aVetRet[_nX][2]
								cQuery += "' AND ZE0_ZCODF = '"  	+ _aVetRet[_nX][3]
								cQuery += "' AND ZE0_ZLJFUN = '"  	+ _aVetRet[_nX][4]
								cQuery += "' AND ZE0_CCD = '"  		+ _aVetRet[_nX][5]
								cQuery += "' AND ZE0_NATURE = '"  	+ _aVetRet[_nX][6]
								cQuery += "' AND ZE0_NAPRCP = '"  	+ _aVetRet[_nX][7] 
								/*
								cQuery += "' AND ZE0_CAIXA ='" 		+ cCaixa
								cQuery += "' AND ZE0_HISTOR = '"  	+ cHis
								cQuery += "' AND ZE0_NRCOMP = '"  	+ cNrc
								cQuery += "' AND ZE0_ZCODF = '"  	+ cZco
								cQuery += "' AND ZE0_ZLJFUN = '"  	+ cZlo
								cQuery += "' AND ZE0_CCD = '"  		+ cCcd
								cQuery += "' AND ZE0_NATURE = '"  	+ cNat
								cQuery += "' AND ZE0_NAPRCP = '"  	+ cNap
								*/
								cQuery += "' AND D_E_L_E_T_ = '' "
								cQuery += "  ORDER BY ZE0_CAIXA "
								cQuery := ChangeQuery(cQuery)
	
								DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	
								If !(cAliasQry)->(Eof())
									While !(cAliasQry)->(Eof()) 
										ZE0->(dbGoTo((cAliasQry)->RECZE0))
										RecLock("ZE0",.F.)
										ZE0->ZE0_NAPRCP 	:= " "
										ZE0->ZE0_NAPRUN 	:= " "
										ZE0->ZE0_MARKCP		:= .F.
										ZE0->ZE0_MARKUN		:= .F.
										ZE0->ZE0_DTBAIX     := CTOD("  /  /  ")
										ZE0->ZE0_APRCPA		:= " "
										ZE0->ZE0_APRUNI		:= " "
										ZE0->( MsUnlock() )
										(cAliasQry)->(DbSkip())
									EndDo
								Endif
	
								(cAliasQry)->(dbCloseArea())
							next _nX


						End Transaction

						If nHdlPrv > 0 .and. lPadrao57E  .And. lGeraLanc
							//Efetiva Lan‡amento Contabil
							RodaProva( nHdlPrv, nTotal )

							If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
								cCodDiario := CTBAVerDia()
								AADD(aDiario,{"SEU",SEU->(recno()),cCodDiario,"EU_NODIA","EU_DIACTB"})
							Endif

							If lUsaFlag .And. !EMPTY(SEU->EU_NUM) //Armazena em aFlagCTB para atualizar no modulo Contabil
								aAdd( aFlagCTB, {"EU_LA", "S", "SEU", SEU->( Recno() ), 0, 0, 0} )
							Endif                            
							cA100Incl( cArquivo,nHdlPrv,3 /*nOpcx*/,cLote,lDigita,lAglutina /*lAglut*/,/*cOnLine*/,/*dData*/,/*dReproc*/,@aFlagCTB,/*aDadosProva*/,aDiario )
							aFlagCTB := {}  //Limpa o coteudo apos a efetivacao do lancamento

							If !lUsaflag .And. !Empty(SEU->EU_NUM)
								Reclock("SEU",.F.)
								Replace EU_LA	With "S"
								MsUnLock()
							EndIf
						EndIf

						MSGINFO(STR0120)
						RestArea( aAreaSEU )

					ELSE

						If lRet
							Alert(STR0121 +  CVALTOCHAR(aEstor[1][1]))
						Else
							Alert(STR0122 + CRLF + STR0111 + cCheque + CRLF + STR0123)
						Endif

					Endif
					//Else
					//	Alert(STR0124)
					//Endif
				Endif			
			EndIF
		Endif
	Endif

	RestArea( aAreaAnt )
	Return Nil



	//----------------------------------------------------------------------
	/*/{Protheus.doc} Fa550SLCR()
	Atualiza saldo da SET após o Estorno da reposição

	@author Daniel Ferraz Lacerda
	@since 27/12/2016
	@version 11
	@param nCaixa, Número do Caixinha a ser atualizado
	@param lAtu, se o Saldo deve ou não ser atualizado
	@param nValor, valor a ser reduzido do Saldo do Caixinha
	@return lRet Boolean
	/*/
//----------------------------------------------------------------------
User Function Fa550SLCR(cCaixa,lAtu,nValor)
	Local aAreaSET := {}
	Local lOk := .F.

	If lAtu
		DbSelectArea("SET")
		aAreaSET := SET->( GetArea() )
		SET->( DbSetOrder( 1 ) )
		If SET->( DbSeek( FWxFilial("SET") + cCaixa ) )
			RecLock( "SET", .F. )
			Replace ET_SALDO With ET_SALDO - nValor
			SET->( MsUnlock() )
			lOk := .T.
		Endif
		RestArea( aAreaSET )
	Endif
Return lOk