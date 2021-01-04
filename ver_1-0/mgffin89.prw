#include "protheus.ch"

/*
=======================================================================================
Programa.:              MGFFIN89
Autor....:              Totvs
Data.....:              Marco/2018
Descricao / Objetivo:   Funcao chamada pelo ponto de entrada F200VAR
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              Funcao chamada pelos P.E's F200VAR(FINA200) e FR650FIL(FINR650)
=======================================================================================
*/

// OBS:
// CONCENTRAR TODOS OS TRATAMENTOS PARA POSICIONAMENTO DA SE1 E FILTROS NESTE PE, NAO USAR OUTROS PE�S PARA ESTE TRATAMENTO EM HIPOTESE NENHUMA, 
// PARA NAO CONFLITAREM AS REGRAS.

User Function MGFFIN89()

local aArea		:= getArea()
local aAreaSE1	:= SE1->( getArea() )
local nRecnoX	:= 0
Local lAchouTit := .F.
Local nConta := 0
Local lEOFSA1	:= .F.

Private lFina200	:= IsInCallStack("FINA200")
Private lFinR650	:= IsInCallStack("FINR650")	.OR. FUNNAME() == "MGFINR650"
/*
CNAB - Verifica se possui E1_ZIDCNAB, 24 posicoes (titulo importado, chave/Id CNAB com origem no Logix)
*/

If lFinR650 .And. MV_PAR07 == 2
	Return(.T.)
Endif

If lFina200 .Or. lFinR650
	If cNumTit == "." // tratamento feito na variavel no PE f200var, retira o tratamento aqui 
		cNumTit := ""
	Endif
Endif
		
If !Empty( cNumTit )
	if len( allTrim( cNumTit ) ) > 10
		SE1->( DBOrderNickName('MGFXIDCNAB') )
		if SE1->( DBSeek( cNumTit ) )
			cFilAnt		:= SE1->E1_FILIAL
			nRecnoX		:= SE1->(RECNO())
			cNumTit := SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA // grava esta chave, para o padrao encontrar o titulo
		endif
	else
		SE1->( DBSetOrder( 19 ) ) // IdCnab
		if SE1->( DBSeek( Substr( cNumTit, 1 , 10 ) ) )
			cFilAnt		:= SE1->E1_FILIAL
			nRecnoX		:= SE1->(RECNO())

			If !Empty(SE1->E1_IDCNAB)
				cNumTit	:= SE1->E1_IDCNAB
			EndIf
		endif
	endif
Else // regra para quando o idcnab nao vem no titulo
	nRecnoX := Fin89SemID(@lEOFSA1)
Endif	

restArea(aAreaSE1)
restArea(aArea)

if nRecnoX > 0
	dbSelectArea("SE1")
	lAchouTit := .T.
	SE1->( DBGoTo( nRecnoX ) )

	If !Empty(cNumTit)
		If IIf(lFina200,mv_par06 != "237",IIf(lFinR650,mv_par03 != "237",.F.))
			If Alltrim(cTipo) == "NF" .or. Empty(cTipo) .or. cTipo == "00"
				ctipo := "01"
			Endif
		Endif
	Endif		
	
	// tratamentos para gravacao de campo na SE1, para nao processar o retorno do titulo
	If lFina200 .Or. lFinR650
		If !Subs(ParamIXB[1][14],1,2) $ "02/03/" // 02 - Entrada Confirmada / 03 - Entrada Rejeitada //Tipo do processamento
			nConta := SE1->E1_SALDO + SE1->E1_SDACRES - SE1->E1_SDDECRE
			
			If nConta <> ParamIXB[1][08] //Valor total
				If !Empty(ParamIXB[1][06]) // Desconto financeiro
					If Abs((ParamIXB[1][08] - nConta)) == Abs((ParamIXB[1][06] + ParamIXB[1][05])) // Valor total //Desconto Financeiro
						If Round((SE1->E1_VALOR * SE1->E1_DESCFIN / 100),2) == ParamIXB[1][06] // Desconto Financeiro
							// nao faz nada
						Else
							SE1->(RecLock("SE1",.F.))
							SE1->E1_ZNBXCNB := IIF(lFina200,"S",IIF(Empty(SE1->E1_ZNBXCNB),"D",SE1->E1_ZNBXCNB))
							SE1->(MsUnlock())
							lAchouTit := IIF(lFina200,.F.,.T.)
						EndIf		
					ElseIf ParamIXB[1][08] > nConta .And. Empty(ParamIXB[1][09]) .And. Empty(ParamIXB[1][10])
							SE1->(RecLock("SE1",.F.))
							SE1->E1_ZNBXCNB := IIF(lFina200,"S",IIF(Empty(SE1->E1_ZNBXCNB),">",SE1->E1_ZNBXCNB))
							SE1->(MsUnlock())
							lAchouTit := IIF(lFina200,.F.,.T.)
					ElseIf ParamIXB[1][08] < nConta
							SE1->(RecLock("SE1",.F.))
							SE1->E1_ZNBXCNB := IIF(lFina200,"S",IIF(Empty(SE1->E1_ZNBXCNB),"<",SE1->E1_ZNBXCNB))
							SE1->(MsUnlock())
							lAchouTit := IIF(lFina200,.F.,.T.)
					EndIf	
				ElseIf ParamIXB[1][08] > nConta .And. Empty(ParamIXB[1][09]) .And. Empty(ParamIXB[1][10])
						SE1->(RecLock("SE1",.F.))
						SE1->E1_ZNBXCNB := IIF(lFina200,"S",IIF(Empty(SE1->E1_ZNBXCNB),">",SE1->E1_ZNBXCNB))
						SE1->(MsUnlock())
						lAchouTit := IIF(lFina200,.F.,.T.)
				ElseIf ParamIXB[1][08] < nConta .And. Empty(ParamIXB[1][06]) .And. Empty(ParamIXB[1][05])
						SE1->(RecLock("SE1",.F.))
						SE1->E1_ZNBXCNB := IIF(lFina200,"S",IIF(Empty(SE1->E1_ZNBXCNB),"<",SE1->E1_ZNBXCNB))
						SE1->(MsUnlock())
						lAchouTit := IIF(lFina200,.F.,.T.)
				Endif	
			EndIf
		EndIf
	Endif	
endif

If lFinR650 .And. lAchouTit .And. Empty(cNumTit)
	cEspecie := IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO)				
	cNumTit := IIF(mv_par07==1,SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA),SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA))
	cCliFor	:= IIF(mv_par07==1,SE1->E1_CLIENTE+" "+SE1->E1_LOJA,SE2->E2_FORNECE+" "+SE2->E2_LOJA)
Endif

RestArea(aAreaSE1)
RestArea(aArea)

return(lAchouTit)


// regra para posicionamento quanto nao tem idcnab no arquivo retorno
Static Function Fin89SemID(lEOFSA1)
Local aArea 		:= {SA1->(GetArea()),SE1->(GetArea()),GetArea()}
Local cLinha 		:= IIf(lFina200,ParamIxb[1][16],IIf(lFinR650,ParamIxb[1][14],""))
Local cNum 			:= ParamIxb[1][1]
Local cNumMarfrig 	:= "" // numero do titulo digitado pelo usuario no site do banco
Local cParcMarfrig 	:= "" // parcela do titulo digitada pelo usuario no site do banco
Local cTitNumAux 	:= ""
Local cParNumAux 	:= ""
Local cTitLogix	 	:= ""
Local cParLogix  	:= ""

Local cQ 			:= ""
Local cAliasTrb 	:= GetNextAlias()                                    
Local cQAux 		:= ""
Local cNomeCli 		:= ""
Local cCodCli	   	:= ""
Local cLojCli	   	:= ""
Local nRecno 		:= 0
// variavel criada para obter a primeira parte do nome do cliente. Necessario pois em boletos criados manualmente no site do banco 
// foi encontrado titulos no retorno do CNAB que o nome do cliente diverge do cadastro do Protheus(A1_NOME ou A1_NREDUZ)
Local cPalavra		:= ""
		
// somente faz o tratamento se a linha veio sem o idcnab
If Empty(cNum)
	cNumMarfrig := Padl(Alltrim(Subs(cLinha,117,6)),Len(SE1->E1_NUM),"0")
	cParcMarfrig := Padl(Alltrim(Subs(cLinha,123,2)),Len(SE1->E1_PARCELA),"0")
	// as variaveis abaixo para numero do titulo e parcela se deve a ainda existir remessas com a regra de 8 posicoes para titulo e 2 para parcela
	cTitNumAux := Padl(Alltrim(Subs(cLinha,117,8)),Len(SE1->E1_NUM),"0")
	cParNumAux := Padl(Alltrim(Subs(cLinha,125,2)),Len(SE1->E1_PARCELA),"0")
	// as variaveis abaixo para numero do titulo e parcela se deve ao legado LOGIX
	cTitLogix  := Padl(Alltrim(Subs(cLinha,119,6)),Len(SE1->E1_NUM),"0")
	cParLogix  := Padl(Alltrim(Subs(cLinha,125,2)),Len(SE1->E1_PARCELA),"0")

	cNomeCli := AllTrim(Subs(cLinha,325,40))
	SA1->(dbSetOrder(2))
   	If SA1->(dbSeek(xFilial("SA1")+cNomeCli))
   		cNomeReduz := SA1->A1_NREDUZ
   		cCodCli	   := SA1->A1_COD
   		cLojCli	   := SA1->A1_LOJA
   	Else
   		SA1->(dbSetOrder(5))
	   	If SA1->(dbSeek(xFilial("SA1")+Left(cNomeCli,20)))
	   		cNomeReduz := SA1->A1_NREDUZ
	   		cCodCli	   := SA1->A1_COD
	   		cLojCli	   := SA1->A1_LOJA
	   	Else
	   		lEOFSA1	   := .T.
	   		cNomeReduz := ""
	   		cCodCli	   := ""
	   		cLojCli	   := ""
	   		cPalavra   := AllTrim(SubStr(cNomeCli,1,AT(" ",cNomeCli)))
	   	Endif
   	Endif
   	// obtem as 20 posicoes devido ao tamanho do campo E1_NOMCLI
   	cNomeCli := Left(cNomeCli,20)
	If !Empty(cNumMarfrig) .and. !Empty(cParcMarfrig)
		cQAux := "FROM "+RetSqlName("SE1")+" SE1 "
		cQAux += "WHERE SE1.D_E_L_E_T_ = ' ' "
		If (IsInCallStack("FINA200") .and. mv_par13 == 1) .or. IsInCallStack("FINR650")  // filial atual
			cQAux += "AND E1_FILIAL = '"+xFilial("SE1")+"' "
		Else // todas as filiais desta Empresa
			cQAux += "AND SUBSTRING(E1_FILIAL,1,2) = '"+FWCompany('SE1')+"' "                   
		Endif	
		cQAux += "AND ((E1_NUM = '"+cNumMarfrig+"' AND E1_PARCELA = '"+cParcMarfrig+"') "		// cenario cnab atual
		cQAux += " OR (E1_NUM = '"+cTitNumAux+"' AND E1_PARCELA = '"+cParNumAux+"') "			// cenario inicial e ignorado porem possui titulos em aberto
		cQAux += " OR (E1_NUM = '"+cTitLogix+"' AND E1_PARCELA = '"+cParLogix+"')) "			// cenario LOGIX
		cQAux += "AND E1_TIPO = '"+MVNOTAFIS+"' "
		If !Empty(cCodcli)
			cQAux += "AND E1_CLIENTE = '" + cCodCli + "'
		Else
			If Empty(cNomeReduz)
				cQAux += "AND (E1_NOMCLI LIKE '%"+AllTrim(cNomeCli)+"%' OR E1_NOMCLI LIKE '%" + cPalavra + "%') "
			Else
				cQAux += "AND (E1_NOMCLI LIKE '%"+AllTrim(cNomeCli)+"%' OR E1_NOMCLI LIKE '%" + AllTrim(cNomeReduz) + "%') "
			Endif
		Endif
		cQ := "SELECT COUNT(*) NREG "
		cQ := cQ+cQAux
		
		cQ := ChangeQuery(cQ)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)
		
		If (cAliasTrb)->(!Eof())
			nRet := (cAliasTrb)->NREG
		Endif
		
		(cAliasTrb)->(dbCloseArea())
		
	    If nRet == 1 // se tiver uma ocorrencia soh no SE1, busca somente pelo numero e parcela do titulo
			cQ := "SELECT R_E_C_N_O_ SE1_RECNO "
			cQ := cQ+cQAux
			
			cQ := ChangeQuery(cQ)
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)
			
		    SE1->(dbGoto((cAliasTrb)->SE1_RECNO))
		    If SE1->(Recno()) == (cAliasTrb)->SE1_RECNO
		    	cNumTit := SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
		    	nRecno := SE1->(Recno())
		    	cFilAnt := SE1->E1_FILIAL
		    Endif

			(cAliasTrb)->(dbCloseArea())
		Endif 	 	
		If nRet > 1 .And. Empty(cPalavra)				// se tiver mais de 1 ocorrencia no SE1, alem do SE1, verifica tambem o nome do cliente
			cQ := "SELECT R_E_C_N_O_ SE1_RECNO "
			cQ := cQ+cQAux
			
			cQ := ChangeQuery(cQ)
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)
			TcSetField(cAliasTrb,"SE1_RECNO","N",10,0)
			(cAliasTrb)->(dbGoTop())
									
			SA1->(dbSetOrder(2))
			While (cAliasTrb)->(!Eof())			                                    
				SE1->(dbGoto((cAliasTrb)->SE1_RECNO))
			    If SE1->(Recno()) == (cAliasTrb)->SE1_RECNO
			    	cNumTit := SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
			    	nRecno := SE1->(Recno())
			    	cFilAnt := SE1->E1_FILIAL
			    	Exit
				Endif
			   (cAliasTrb)->(dbSkip())
			Enddo
			(cAliasTrb)->(dbCloseArea())
		Endif	
	Endif
Endif		
			
aEval(aArea,{|x| RestArea(x)})

Return(nRecno)


User Function FIN89200Var()
// rotina para tratar a variavel cNumTit quando esta estah em branco no arquivo de retorno
// este tratamento eh necessario, pois no fonte padrao fina200, logo apos a chamada do ponto de entrada f200var tem o tratamento abaixo:
/*
			// Template GEM
			If lF200Var
				uRet := ExecBlock("F200VAR",.F.,.F.,{aValores})
				If ValType( uRet ) == 'A'
					aValores := aClone(uRet)
				Endif
			ElseIf lGEMBaixa
				ExecTemplate("GEMBaixa",.F.,.F.,)
			Endif

			If Empty(cNumTit)
				nLidos += nTamDet
				Loop
			EndIf
*/
// ou seja, a rotina fina200 nao prossegue o processamento da linha se a variavel cNumTit estiver em branco

If Empty(cNumTit)
	cNumTit := "."
Endif

Return()

/*
User Function FIN89650Tp()

If IsInCallStack("FINR650")
	If mv_par03 != "237"
		If Alltrim(cTipo) == "NF" .or. Empty(cTipo)
			cTipo := "01"
		Endif
	Endif
Endif

Return()	
*/
