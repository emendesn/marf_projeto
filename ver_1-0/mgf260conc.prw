#INCLUDE "rwMake.ch"                        
#INCLUDE "PROTHEUS.CH" 
#INCLUDE "topconn.CH" 

/*

{Protheus.doc} MGF260Conc	 
Concilia��o de Informa��es DDA 
processamento de arquivo de retorno DDA com os dados dos regitros de t�ulos de
@type function

@author Anderson Reis - History
@since 
@version P12
@history Inclusao     Nao encontrado informa��es
@history Altera��o 28/08 - feature/RTASK0011084_DDA  Anderson Reis
   **  Adicionado a grava��o do tipo de valor para mais ou menos conforme valores do Boleto e T�tulo
   **  Utiliza��o da fun��o datavalida, para que seja autom�tica a busca pellos dias �teis ,feriados ...
   ** nao tem mais funcionalidade os parametros de avan�ar e retroceder . pois est� contemplado na fun��o acima
   
*/


Static oTrabFig
Static oTrabSE2

User Function MGF260Conc()
Local aArea		:= GetArea()
Local lOk		:= .F.
Local aSays		:= {}
Local aButtons	:= {}
Local cPerg		:= "FIN260"
Local lAutomato	   := .F.

Pergunte("FIN260",.F.)

If !lAutomato
	aADD(aSays,"MARFRIG - Esta rotina tem como objetivo a concilia��es das informa��es importadas atrav�s de") 	//
	aADD(aSays,"processamento de arquivo de retorno DDA com os dados dos regitros de t��tulos de  ") 	//
	aADD(aSays,"contas a pagar(tabela SE2) para obten��o dos c�digos de barra dos boletos banc�rios.") 	//
	
	aADD(aButtons, { 5,.T.,{|| Pergunte("FIN260",.T. ) } } )
	aADD(aButtons, { 1,.T.,{|| lOk := .T.,FechaBatch()}} )
	aADD(aButtons, { 2,.T.,{|| FechaBatch() }} )
	FormBatch( cCadastro, aSays, aButtons ,,,535)
Else
	lOk := .T.
Endif			

If lOk
	Processa({|lEnd| MGF260Gera(lAutomato)})   
Endif

RestArea(aArea)

Return(.T.)

Static Function MGF260Gera(lAutomato)
Local lPanelFin := IsPanelFin()
Local cRecTRB
Local nSavRecno:= Recno()
Local nPos		:= 0
Local aTabela 	:= {}
Local cIndex	:= " "
Local nSeq		:= 0
Local lSaida	:= .F.
Local nOpca		:= 0
Local aCores 	:= {}
Local nCont		:= 0
Local li
Local cVarTRB := "  "
Local cVarSE2 := "  "
Local oBtn
Local dDtIni	:= CTOD("01/01/1980","ddmmyy")
Local dDtFin	:= CTOD("01/01/1980","ddmmyy")
Local nTamCodBar	:= TAMSX3("FIG_CODBAR")[1]
Local nTamIdCnab	:= TAMSX3("E2_IDCNAB")[1]
Local lQuery	:= .T.
Local cQuery 	:= ""
Local cAliasFIG := ""
Local cAliasSE2 := ""
Local cCampos 	:= ""
Local nX 		:= 0
Local cFilSE2 	:= ""
Local cFornece	:= ""
Local cLoja		:= ""
Local cNum		:= ""
Local cTipo		:= ""
Local cVencto	:= ""
Local cVencMin	:= ""
Local cVencMax	:= ""
Local cValor	:= ""
Local cValorMin	:= ""
Local cValorMax	:= ""
Local nValpis := 0
Local nValCof := 0
Local nValCsl := 0
Local nValIrf := 0
Local nValIns := 0
Local nValIss := 0
Local nvalACR := 0
Local nvalDCR := 0
Local nValImp	:= 0
Local cTitSE2	:= ""
Local cSeqSe2  	:= ""
Local nValor	:= 0
Local nValorMin:= 0
Local nValorMax:= 0
Local nRecSe2	:= 0
Local nRecDDA	:= 0
Local nRecTrbSE2  := 0
Local dVencMin	:= CTOD("//")
Local dVencMax	:= CTOD("//")
Local cChave	:= ""
Local cCPNEG	:=	MV_CPNEG

Local oOk	:= LoadBitmap( GetResources(), "ENABLE"		)	//Nivel 1 - Verde
Local oN2	:= LoadBitmap( GetResources(), "BR_AZUL"	)	//Nivel 2 - Azul
Local oN3	:= LoadBitmap( GetResources(), "BR_PRETO"	)	//Nivel 3 - Preto
Local oN4	:= LoadBitmap( GetResources(), "BR_CINZA"	)	//Nivel 4 - Cinza
Local oN5	:= LoadBitmap( GetResources(), "BR_BRANCO"	)	//Nivel 5 - Branco 
Local oN6	:= LoadBitmap( GetResources(), "BR_AMARELO"	)	//Nivel 6 - Amarelo 
Local oN7	:= LoadBitmap( GetResources(), "BR_LARANJA"	)	//Nivel 7 - Laranja
Local oN8	:= LoadBitmap( GetResources(), "BR_PINK"	)	//Nivel 8 - Rosa
Local oNo	:= LoadBitmap( GetResources(), "DISABLE"	)	//Nivel 9 - Vermelhor

Local oMark	  := LoadBitmap( GetResources(), "LBOK"	)	 
Local oNoMark := LoadBitmap( GetResources(), "LBNO"	)		 

Local nScan := 0
Local lOk := nil
Local aTab := {}
Local lDup := .F.
Local nNivel:= 9 
Local lChave := .F. //para verificar se a conc será usado a condicional de filial de filial de origem.
Local cFilOSE2 := ""
Local nRecFIG := 0
Local aAreaFIG := {}
Local cLojaFIG := ""
Local aConcil:={}
Local aAnalise:={}
Local nrets := 0 // boleto para 2 titulos
Local cQy := " "
Local cvaloraux := 0
Local aAreas   := GetArea()
Local aAreaE2  := SE2->(GetArea())
Local aAreaFG  := FIG->(GetArea())
Local ldt      := .F.
Local cqy      := " "
Local nValPP   := 0

Aadd(aCores,oOk)
Aadd(aCores,oN2)
Aadd(aCores,oN3)
Aadd(aCores,oN4)
Aadd(aCores,oN5)
Aadd(aCores,oN6)
Aadd(aCores,oN7)
Aadd(aCores,oN8)
Aadd(aCores,oNo)

// Variaveis referente a Impostos
Private lPCCBaixa  	:= SuperGetMv("MV_BX10925",.T.,"2") == "1"
Private lInssBx		:= SuperGetMv("MV_INSBXCP",.F.,"2") == "1"
Private lCalcIssBx	:= SuperGetMV("MV_MRETISS",.T.,"1") == "2"
Private lIRPFBaixa := IIf( ! Empty( SA2->( FieldPos( "A2_CALCIRF" ) ) ), SA2->A2_CALCIRF == "2", .F.) .And. ;
		 !Empty( SE2->( FieldPos( "E2_VRETIRF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETIRF" ) ) ) .And. ;
		 !Empty( SE5->( FieldPos( "E5_VRETIRF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETIRF" ) ) ) 


//Array que conterao os registros lockados com o usuario
Private aRLocksSE2 := {}
Private aRLocksFIG := {}
Private cMarca		:= GetMark()
Private oDlg

Private oTitulo
Private oDadosFig

Private nTotConcil :=0 
Private nTotAnalise :=0 
Private nTotGeral :=0 
Private oTotGeral
Private oTotConcil
Private oTotAnalise

Default lAutomato		:= .F.

Private aCampos:={}

//Tratamento para adiantamento tipo NCC
If "|" $ cCPNEG
	cCPNEG	:=	StrTran(MV_CPNEG,"|","")
ElseIf "," $ cCPNEG
	cCPNEG	:=	StrTran(MV_CPNEG,",","")
Endif
If Mod(Len(cCPNEG),3) > 0
	cCPNEG	+=	Replicate(" ",3-Mod(Len(cCPNEG) ,3))
Endif

//Verifico se o parametro Vencto de/Ate nao esta vazio
dDtIni	:= Max(dDtIni,Iif(Empty(mv_par09),dDtIni,mv_par09))
dDtFin	:= Max(dDtFin,Iif(Empty(mv_par10),dDtFin,mv_par10))

// Acrescento/diminuo das variaveis para abrir periodo
dDtIni	:= dDtIni - mv_par14
dDtFin	:= dDtFin + mv_par13

// Criar arquivo de Trabalho temporário TRB
MGF260CRIARQ()

FIG->(dbSetOrder(2)) //Filial+Fornecedor+Loja+Vencto+Titulo
cChave		:= FIG->(IndexKey())
cAliasFIG	:= GetNextAlias()
aStru		:= FIG->(dbStruct())
cCampos		:= ""
cFilIn 		:= MGF260Filial()

aEval(aStru,{|x| cCampos += ","+AllTrim(x[1])})
cQuery := "SELECT "+SubStr(cCampos,2) + ", R_E_C_N_O_ RECNOFIG "
cQuery += "FROM " + RetSqlName("FIG") + " FIG  WHERE "
// Considerar ou Não a FILIAL no FIG ? (Email p/ Eric)
//cQuery +=		"FIG_FILIAL IN "  + FormatIn(cFilIn,"/") + " AND "		
cQuery += 		"FIG_FORNEC  <> ' ' AND "
cQuery += 		"FIG_FORNEC  >= '"+ mv_par04 + "' AND "
cQuery += 		"FIG_FORNEC  <= '"+ mv_par05 + "' AND "
cQuery += 		"FIG_LOJA >= '"	+ mv_par06 + "' AND "
cQuery += 		"FIG_LOJA <= '"	+ mv_par07 + "' AND "
cQuery +=		"FIG_VENCTO >= '"	+ DTOS(dDtIni) + "' AND "
cQuery +=		"FIG_VENCTO <= '"	+ DTOS(dDtFin) + "' AND "
cQuery +=		"FIG_DATA >= '"	+ DTOS(mv_par11) + "' AND "
cQuery +=		"FIG_DATA <= '"	+ DTOS(mv_par12) + "' AND "
cQuery += 		"FIG_VALOR > 0 AND "
cQuery +=		"FIG_CONCIL = '2' AND "									// Não Conciliado
cQuery +=		"FIG_CODBAR <> '"	+ Space(nTamCodbar) + "' AND " 		// Com código de Barra
cQuery +=		"D_E_L_E_T_ = ' ' "
cQuery +=	"ORDER BY " + SqlOrder(cChave)

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasFIG,.T.,.T.)

// Preenche a tabela com os dados da estrutura.
For nX :=  1 To Len(aStru)
	If aStru[nX][2] <> "C" .And. FieldPos(aStru[nX][1]) > 0
		TcSetField(cAliasFIG,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
	EndIf
Next nX
		
If ((cAliasFIG)->(Bof()) .or. (cAliasFIG)->(Eof())) .and. !lAutomato 
	Help(" ",1,"NORECFIG",,"Nenhum registro DDA encontrado"+CHR(10)+"Por favor, verifique parametriza��o",1,0) //###
	lSaida := .T.
Else
	While !((cAliasFIG)->(Eof()))
	
		// Testa se alguns dos campos da tabela FIG estão em Branco
		// Se estiver em branco não adiciona no TRB
		If !MgF260Verif(cAliasFIG)
			DbSelectArea("TRB")
			RecLock("TRB",.T.)
			// Recno do TRB para sequencia de Movientaçao
			cRecTRB := STRZERO(TRB->(Recno()))
			
			nRecFIG := If(lQuery,(cAliasFIG)->RECNOFIG,(cAliasFIG)->(Recno())) 
			cLojaFIG := (cAliasFIG)->FIG_LOJA
			
			TRB->SEQMOV 	:= SUBSTR(cRecTRB,-5)
			TRB->SEQCON		:= ""
			TRB->FIL_DDA	:= (cAliasFIG)->FIG_FILIAL
			TRB->FOR_DDA	:= (cAliasFIG)->FIG_FORNEC
			TRB->NOM_DDA	:= (cAliasFIG)->FIG_NOMFOR
			TRB->LOJ_DDA	:= cLojaFIG
			TRB->TIT_DDA	:= (cAliasFIG)->FIG_TITULO
			TRB->TIP_DDA	:= (cAliasFIG)->FIG_TIPO
			TRB->DTV_DDA	:= (cAliasFIG)->FIG_VENCTO
			TRB->VLR_DDA	:= Transform((cAliasFIG)->FIG_VALOR,"@E 999,999,999,999.99")
			TRB->REC_DDA	:= nRecFIG
			TRB->OK     	:= 9		// NAO CONCILIADO
			TRB->CODBAR		:= (cAliasFIG)->FIG_CODBAR
			nTotGeral++

			MsUnlock()
		Endif
		(cAliasFIG)->(dbSkip())
	Enddo
Endif


//Filtra dados do SE2 - Contas a Pagar - TRATAMENTO PARA BUSCAR o SE2
If !lSaida

	//Filtra dados do SE2 - Conciliacao DDA
	cAliasSE2 := GetNextAlias()
	aStru  := SE2->(dbStruct())
	cCampos := ""
	cFilIn := MGF260Filial()

	// GDN - Ajuste na Performance 30/10/18
	cQuery := "SELECT "
	cQuery +=		"E2_FILIAL,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA,E2_NOMFOR,E2_EMISSAO,"
	cQuery +=		"E2_VENCTO,E2_VENCREA,E2_VALOR,E2_EMIS1,E2_HIST,E2_SALDO,E2_ACRESC,E2_ORIGEM,E2_TXMOEDA,"
	cQuery +=		"E2_SDACRES,E2_DECRESC,E2_SDDECRE,E2_IDCNAB,E2_FILORIG,E2_CODBAR,E2_STATUS,E2_DTBORDE,"
	cQuery +=		"E2_PIS,E2_COFINS,E2_CSLL,E2_IRRF,E2_INSS,E2_ISS,E2_ACRESC,E2_DECRESC,"
	cQuery +=		"SE2.R_E_C_N_O_ RECNOSE2 "
	cQuery += " FROM " + RetSqlName("SE2")+ " SE2"		//+",  "+RetSqlName("FIG")+" FIG "
	cQuery += " WHERE "
	cQuery +=		"SE2.E2_FILIAL IN "	+ FormatIn(cFilIn,"/") + " AND "
	cQuery += 		"SE2.E2_FORNECE  >= '"+ mv_par04 + "' AND "
	cQuery += 		"SE2.E2_FORNECE  <= '"+ mv_par05 + "' AND "
	cQuery += 		"SE2.E2_LOJA >= '"	+ mv_par06 + "' AND "
	cQuery += 		"SE2.E2_LOJA <= '"	+ mv_par07 + "' AND "
	//Considera Vencto do titulo
	If mv_par08 == 1
		cQuery +=	"SE2.E2_VENCTO >= '"	+ DTOS(dDtIni) + "' AND "
		cQuery +=	"SE2.E2_VENCTO <= '"	+ DTOS(dDtFin) + "' AND "
		cChave := 	"SE2.E2_FORNECE+SE2.E2_LOJA+DTOS(SE2.E2_VENCTO)+SE2.E2_PREFIXO+SE2.E2_NUM+SE2.E2_PARCELA+SE2.E2_TIPO"
	//Considera Vencto REAL do titulo
	Else
		cQuery +=	"SE2.E2_VENCREA >= '"	+ DTOS(dDtIni) + "' AND "
		cQuery +=	"SE2.E2_VENCREA <= '"	+ DTOS(dDtFin) + "' AND "
		cChave := "SE2.E2_FORNECE+SE2.E2_LOJA+DTOS(SE2.E2_VENCREA)+SE2.E2_PREFIXO+SE2.E2_NUM+SE2.E2_PARCELA+SE2.E2_TIPO"
	Endif
	cQuery += 		"SE2.E2_SALDO > 0 AND "
	cQuery += 		"SE2.E2_TIPO NOT IN " + FORMATIN(cCPNEG+MVPAGANT,,3) + " AND "
	cQuery += 		"SE2.E2_TIPO NOT IN " + FORMATIN(MVABATIM,'|') + " AND "
	cQuery += 		"SE2.E2_TIPO NOT IN " + FORMATIN(MVTXA+"INA",,3) + " AND "
	cQuery += 		"SE2.E2_TIPO NOT IN " + FORMATIN(MVTAXA,,3) + " AND "
	cQuery += 		"SE2.E2_TIPO NOT IN " + FORMATIN(MVPROVIS,,3) + " AND "
	cQuery +=		"SE2.E2_CODBAR = '"	+ Space(nTamCodbar) + "' AND "				
	cQuery +=		"SE2.E2_IDCNAB = '"	+ Space(nTamIdCnab) + "' AND "
	cQuery +=		"SE2.D_E_L_E_T_ = ' ' "
	// GDN - Arramar SE2 com FIG para melhorar a Performance.
	//cQuery +=		" AND FIG.FIG_FORNEC = SE2.E2_FORNECE "
	//cQuery +=		" AND FIG.FIG_LOJA = SE2.E2_LOJA "
	//cQuery +=		" AND FIG.FIG_VENCTO >= '"+ DTOS(dDtIni) + "' " 
	//cQuery +=		" AND FIG.FIG_VENCTO <= '"+ DTOS(dDtFin) + "' " 
	//cQuery +=		" AND FIG.FIG_DATA >= '"+ DTOS(mv_par11) + "' " 
	//cQuery +=		" AND FIG.FIG_DATA <= '"+ DTOS(mv_par12) + "' " 
	//cQuery +=		" AND FIG.FIG_VALOR > 0 "
	//cQuery +=		" AND FIG.FIG_CONCIL = '2' " 
	//cQuery +=		" AND FIG.FIG_CODBAR <> '                                            ' " 
	//cQuery +=		" AND FIG.D_E_L_E_T_ = ' '  "
	cQuery +=	"ORDER BY " + SqlOrder(cChave)

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE2,.T.,.T.)

	For nX :=  1 To Len(aStru)
		If aStru[nX][2] <> "C" .And. FieldPos(aStru[nX][1]) > 0
			TcSetField(cAliasSE2,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
		EndIf
	Next nX

	// Monto a regua de Processamento 
	ProcRegua((cAliasSE2)->(RecCount()))

	(cAliasSE2)->(dbGoTop())
	If ((cAliasSE2)->(Bof()) .or. (cAliasSE2)->(Eof())) .and. !lAutomato
		Help(" ",1,"NORECSE2",,"Nenhum registro encontrado no arquivo de contas a pagar (SE2)"+CHR(10)+"Por favor, verifique parametriza��o",1,0)		//###
		lSaida := .T.
	Else
		dbSelectArea(cAliasSE2)
		dbGoTop()
		// Varrer a Query do SE2 e Grava no TRBSE2
		// Neste ponto avaliar se existe algum título do TRBSE2 que se encaixa no Registro do TRB(FIG)
		While !((cAliasSE2)->(Eof()))
			
			// Grava dados do SE2 no arquivo de trabalho
			// Lembrar: Não devo Adicionar novas linhas no TRB
			// uma vez que ele é apenas referente ao FIG.
			// Para o browse inferior preciso adicionar os dados
			// da tabela SE2 no TRBSE2.
			
			DbSelectArea("TRBSE2")
			// 14/11/2018 - GDN - Correção para pesquisar se a chave KEYSE2 já existe no TRB
			// Não adicionar novo registro.
			dbSetOrder(2)
			dbSeek((cAliasSE2)->(E2_FORNECE+E2_PREFIXO+E2_NUM+E2_PARCELA))
			//dbSeek((cAliasSE2)->(E2_FORNECE+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_LOJA))
			
			// Se este título não existe no TRBSE2, então adicionar a tabela do Browse Inferior.
			If !Found()
						
				// Adiciono no TRB do SE2 uso no MarkBrowse
				RecLock("TRBSE2",.T.)
				// Armazeno Recno da TRB SE2
				cRecTRB := STRZERO(TRBSE2->(Recno()))
	
				TRBSE2->SEQMOV 	:= SUBSTR(cRecTRB,-5)
				TRBSE2->SEQCON	:= ""
	
				// Campos de Chave do Titulo 
				TRBSE2->FIL_SE2	:= (cAliasSE2)->E2_FILIAL
				TRBSE2->FOR_SE2	:= (cAliasSE2)->E2_FORNECE
				TRBSE2->NOM_SE2	:= (cAliasSE2)->E2_NOMFOR
				TRBSE2->LOJ_SE2	:= (cAliasSE2)->E2_LOJA
				TRBSE2->TIT_SE2	:= (cAliasSE2)->(E2_PREFIXO+"-"+E2_NUM+"-"+E2_PARCELA)
				TRBSE2->KEY_SE2	:= (cAliasSE2)->(E2_PREFIXO+E2_NUM+E2_PARCELA)
				TRBSE2->TIP_SE2	:= (cAliasSE2)->E2_TIPO
				
				// Data Conforme o Parametro informado
				TRBSE2->DTV_SE2	:= If(mv_par08 == 1,(cAliasSE2)->E2_VENCTO,(cAliasSE2)->E2_VENCREA )
				TRBSE2->VLR_SE2	:= Transform((cAliasSE2)->E2_VALOR,"@E 999,999,999,999.99")
				
				// Campos de Imposto
				TRBSE2->PIS_SE2	:= (cAliasSE2)->E2_PIS
				TRBSE2->COF_SE2	:= (cAliasSE2)->E2_COFINS
				TRBSE2->CSL_SE2	:= (cAliasSE2)->E2_CSLL
				TRBSE2->IRF_SE2	:= (cAliasSE2)->E2_IRRF
				TRBSE2->INS_SE2	:= (cAliasSE2)->E2_INSS
				TRBSE2->ISS_SE2	:= (cAliasSE2)->E2_ISS
				TRBSE2->ACR_SE2	:= (cAliasSE2)->E2_ACRESC
				TRBSE2->DCR_SE2	:= (cAliasSE2)->E2_DECRESC
	
				// Valor na MarkBrow desconsiderando o PCC conforme definição.
				// 17/10/2018 - Conforme definição do modelo de tela, não cons/iderar os demais impostos E2_IRRF+E2_INSS+E2_ISS
				TRBSE2->VLQ_SE2	:= Transform((cAliasSE2)->E2_SALDO-(cAliasSE2)->(E2_PIS+E2_COFINS+E2_CSLL)-(cAliasSE2)->E2_DECRESC + (cAliasSE2)->E2_ACRESC ,"@E 999,999,999,999.99")
				TRBSE2->REC_SE2	:= If(lQuery,(cAliasSE2)->RECNOSE2,(cAliasSE2)->(Recno()))
	
				// FLAG de Registro não conciliado
				TRBSE2->OK     	:= 9		// NAO CONCILIADO
				nNivel			:= 9		// Controle do Nivel da Conciliação quando Identificado no TRB FIG
				nDifVlr:=0
				nDifDtv:=0
				 //-----------------------------------------------------//			
				 // Armazena variaveis parametros dos registros do SE2  //
				 //-----------------------------------------------------//
		         cFilSE2 	:= TRBSE2->FIL_SE2
		         cFornece	:= TRBSE2->FOR_SE2
		         cLoja		:= TRBSE2->LOJ_SE2
		         cNum		:= TRBSE2->KEY_SE2
		         cTipo		:= TRBSE2->TIP_SE2
		         cVencto	:= DTOS(TRBSE2->DTV_SE2)
	
				 // Armazena SALDO DO TITULO dos registros do SE2
	 			 nValImp 	:= (cAliasSE2)->E2_SALDO
		         
				 // Data de Vencimento mais / menos a quantidade de dias do SE2
				 dVencMin	:= TRBSE2->DTV_SE2 - mv_par14
				 dVencMax	:= TRBSE2->DTV_SE2 + mv_par13
				 cVencMin	:= DTOS(dVencMin)
				 cVencMax	:= DTOS(dVencMax)
					
		         // Impostos do Titulo para serem desconsiderados conforme MV_PAR PCC/IRPF/ISS do SE2
		         nValpis 	:= TRBSE2->PIS_SE2
		         nValCof 	:= TRBSE2->COF_SE2
		         nValCsl 	:= TRBSE2->CSL_SE2
		         nValIrf 	:= TRBSE2->IRF_SE2
		         nValIns 	:= TRBSE2->INS_SE2
		         nValIss 	:= TRBSE2->ISS_SE2  
		       
				 nvalACR    := TRBSE2->ACR_SE2
				 nvalDCR    := TRBSE2->DCR_SE2
		         nValImp -= IIF(lPccBaixa,nValpis+nValCof+nValCsl,0) 
		         nValImp -= IIF(lIRPFBaixa,nValIrf,0)
		         nValImp -= IIf(lCalcIssBx,nValIss,0)
		         nValImp -= IIF(lInssBx,nValIns,0)
		         
				 nValImp += nvalACR
		         nValImp -= nvalDCR
		         // Valor a ser apresentado na Tela do SE2 sem os IMPOSTOS
		         cValor := Transform(nValImp,"@E 999,999,999,999.99")
	         
	         	 // SALDO mais / menos o valor informado no parametro para diferença do SE2 
				 //nValorMin:= (cAliasSE2)->E2_SALDO - mv_par15
				 //nValorMax:= (cAliasSE2)->E2_SALDO + mv_par16

				 nValorMin:= nValImp - mv_par15  //tarcisio galeano 16/01/19
				 nValorMax:= nValImp + mv_par16  //tarcisio galeano 16/01/19
				 
				 				 
				 //msgalert("valor "+cFornece+" "+cNum+" "+trans(nValorMin,"9999999.99"))
				 
				 cValorMin:= Transform(nValorMin,"@E 999,999,999,999.99")
				 cValorMax:= Transform(nValorMax,"@E 999,999,999,999.99")
	
				 // Chaves de controle na tabela TRBSB2
				 cTitSE2  	:= TRBSE2->TIT_SE2
				 cKeySE2	:= TRBSE2->KEY_SE2
		         nRecSe2  	:= TRBSE2->REC_SE2
		         cSeqSe2  	:= TRBSE2->SEQMOV
		         nRecTrbSE2 := TRBSE2->(Recno())
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Tento pre-reconciliacao dentro da tabela TRB (FIG)			³
				//³ Fornecedor + Loja + Data Vencto + Valor + Ttulo     		³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("TRB")
				DbSetOrder(1)					//FOR_DDA+DTV_DDA+TIT_DDA - Removido a loja do fornecedor, conforme chamado RITM0017555
				
				nRecno := TRB->(Recno())
	
				// Buscar TRB por Fornecedor, Loja Vencimento
				// Valor DDA com Valor Titulo (descontando o PCC-Impostos)
				// e conseguiu fazer o LOCK dos registros nas tabelas
				// DDA e SE2 comparação  
				// O NIVEL será 1
				
				// Busco esse FORNECEDOR+LOJA no TRB FIG para verificar se tem conciliação
				// para este título SE2.
				/*Removido o campo loja da busca, conforme chamado RITM0017555
				If TRB->(DbSeek(cFornece+cLoja))*/
				If TRB->(DbSeek(cFornece))  
					
					// Salva posição do TRB FIG
					nRecno := TRB->(Recno())
	
					// Enquanto for mesmo Fornecedor FIG e Fornecedor SE2
					// Compara os campos para identificar a conciliação por VENCIMENTO e VALOR (SALDO)
					/*Removido o campo loja da busca, conforme chamado RITM0017555
					While !(TRB->(Eof())) .and. TRB->(FOR_DDA+LOJ_DDA) == cFornece+cLoja*/
					While !(TRB->(Eof())) .and. TRB->(FOR_DDA) == cFornece
	
						nNivel:= 9 //DEFAULT - IDENTIFICADO COMO Nao conciliado

						//Data Vencto - OK
						//Valor (SALDO) - OK 
						//Conciliar Automático e colocar [X] na MarkBrowse.
						//msgalert("aqui "+TRB->VLR_DDA+" "+TRB->TIT_DDA+" "+DTOS(TRB->DTV_DDA))
						
						If cVencto >  DTOS(TRB->DTV_DDA)             .AND.  ;
						    TRB->VLR_DDA == cValor                   .AND.  ;
							DataValida(TRB->DTV_DDA) = TRB->DTV_DDA   
							
							nNivel := 9
							nRecno := Recno()
							Exit
						Endif  

						If cVencto <  DTOS(TRB->DTV_DDA)           
						   							
							nNivel := 9
							nRecno := Recno()
							Exit
						Endif  
						
						If  TRB->DTV_DDA  <  STOD(cVencto)              .AND. ;
						     DataValida(TRB->DTV_DDA) == STOD(CVENCTO)   .AND. ;
 							 TRB->VLR_DDA == cValor 
							
							cValoraux := cvalor

							cValoraux := STRTRAN(cValoraux,".","")
							cValoraux := STRTRAN(cValoraux,",",".")
						
					   
							// Fazer query para verificar 1 boleto para v�rios titulos
								
							//If  nNivel = 1

								aAreaS   := GetArea()
								aAreaE2 := SE2->(GetArea())

								cQy := " SELECT E2_VENCREA,E2_VALOR "
								cQy += " FROM "+RetSqlName("SE2")+" SE2 "
								cQy += " WHERE  SE2.E2_FORNECE   = '" + cFornece+ "'        AND "
								cQy += "       SE2.E2_VALOR     = " + cvaltochar(cValoraux) + "         AND "
								cQy += "        SE2.E2_VENCREA   = '" + cvaltochar(cVencto) + "'   "
								cQy += "       AND SE2.D_E_L_E_T_   = ' '  "
 
								TCQuery cQy New Alias "cSE2"
														
								Count To nRets
						
								If nRets > 1 // Analisar 1 boleto para mais de uma titulo
									nnivel := 6
								Else
									nnivel := 1
								Endif

								dbCloseArea ("cSe2")
								RestArea(aAreaE2)
								RestArea(aAreas)

							//Endif


							
							//nNivel := 1
							nRecno := Recno()
							Exit
						Endif

						
											
						If 	TRB->VLR_DDA == cValor .and. DTOS(TRB->DTV_DDA) == cVencto
							// Verificar se por acaso este Registro já foi conciliado neste processamento.
							If TRB->RECTRBSE2 > 0						//TRB->OK==1
								nNivel := 6
							Else
								nNivel := 1
							Endif
							
							nRecno := Recno()
							Exit
						//------------------------------------------------
						//Data Vencto - OK
						//Valor - Intervalo
						ElseIf DTOS(TRB->DTV_DDA) == cVencto .and.  ;
								TRB->VLR_DDA >= cValorMin .and. ;
								TRB->VLR_DDA <= cValorMax
								nTotAnalise++
								nNivel := 6
								nDifVlr:=1
							nRecno := Recno()
							Exit
	
						//------------------------------------------------
						//Data Vencto - Intervalo
						//Valor - OK
						ElseIf DTOS(TRB->DTV_DDA) >= cVencMin .and.;
								DTOS(TRB->DTV_DDA) <= cVencMax .and.;
								TRB->VLR_DDA == cValor
								nTotAnalise++
							nNivel := 6
							nDifDtv:=1
							nRecno := Recno()
							Exit
	
						//------------------------------------------------
						//Data Vencto - Intervalo
						//Valor - Intervalo
						ElseIf 	DTOS(TRB->DTV_DDA) >= cVencMin .and.;
								DTOS(TRB->DTV_DDA) <= cVencMax .and.;
								TRB->VLR_DDA >= cValorMin .and.;
								TRB->VLR_DDA <= cValorMax
								nTotAnalise++
							nNivel := 6
							nDifVlr:=1
							nDifDtv:=1
							nRecno := Recno()
							Exit
	
						Else
							TRB->(dbSkip())
							Loop
						Endif
	
					Enddo
					
					IIF(nNivel < 9 .and. Type('lOk')=="U", lOk:=.T., Nil)
	
					//Caso houve algum tipo de possibilidade de conciliacao
					If nNivel < 9
	
						//Tenta travar os registros originais do SE2 e FIG
						If MgF260Lock(.T.,aRLocksSE2,aRLocksFIG,nRecSe2,TRB->REC_DDA);
							   .and. lOk
							   
							// Posiciona no registro do TRBSE2
							TRBSE2->(DbGoTo(nRecTrbSE2))
							// Posiciona no registro do TRB
							TRB->(dbGoto(nRecno))
	
							// Marcar o REGISTRO do TRBSE2 como Título que foi 
							// IDENTIFICADO para Conciliação com este TRB (FIG)
							If (TRB->OK==1 .or. TRB->OK==9)
								RecLock("TRBSE2",.F.)
								TRBSE2->MARK := iif(nNivel==1,cMarca," ")				// Coloco uma Marca nesse Titulo
								MsUnlock()
						 	Endif				
						 	
						 	// Se Já existe alguma marcação no TRBSE2 para este FORN, Valor e DATA limpo a MARCA
						 	If nNivel == 6
						 		If TRB->RECTRBSE2 > 0 
							 		TRBSE2->(dbGoTo(TRB->RECTRBSE2))
							 		If !Empty(TRBSE2->MARK)
							 			RecLock("TRBSE2",.F.)
							 				TRBSE2->MARK := ' '
							 			MsUnLock()
							 			RecLock("TRB",.F.)
							 				TRB->REC_SE2	:= 0
							 			MsUnLock()
							 		Endif
									TRBSE2->(DbGoTo(nRecTrbSE2))
							 	Endif

						 	Endif			

							// Gravo o RECNO do FIG no TRBSE2 para uso do FILTRO.
							RecLock("TRBSE2",.F.)
								TRBSE2->REC_CONC := strzero(TRB->REC_DDA,15)
								TRBSE2->DIFVLR := nDifVlr
								TRBSE2->DIFDTV := nDifDtv
							MsUnlock()
	

							// Posiciona no Registro do TRB
							// e identifico em qual NIVEL esta conciliação do 
							// SE2 com o DDA está classificada de 1 a 8
							// fazendo a associação do NIVEL IDENTIFICADO
							RecLock("TRB",.F.)
							// Armazena o numero fisico da tabela SE2
							TRB->REC_SE2	:= If(lQuery,(cAliasSE2)->RECNOSE2,(cAliasSE2)->(Recno()))
							// Armazena O numero do TRBSE2 da Tela.
							TRB->RECTRBSE2  := TRBSE2->(RECNO())
							TRB->OK     	:= nNivel					// NIVEL DE CONCILIACAO
							TRB->OKINI     	:= nNivel			
							TRB->FIL_DDA	:= (cAliasSE2)->E2_FILIAL	// Filial do Título
							TRB->DTC_DDA 	:= dDataBase				// Data da Conciliação 

							MsUnlock()

							If TRB->OK == 1
								If Ascan(aConcil,{|z|z==TRB->(RECNO())}) == 0
									aadd(aConcil,TRB->(RECNO()))
								Endif
							ElseIF TRB->OK == 6
								If Ascan(aAnalise,{|z|z==TRB->(RECNO())}) == 0
									aadd(aAnalise,TRB->(RECNO()))
								Endif
							Endif
						Endif
						
						lOk := .T.
					Endif
	
				Endif
				
	/*---------- 30/10/2018 - Gilson - pensar se devo DELETAR o TRBSE2 não CONCILIADO */
				// Se este título TRBSE2 não foi conciliado ou identificado, excluir da TELA da MarkBrowse
				If nNivel == 9 
					dbSelectArea('TRBSE2')
					RecLock('TRBSE2',.F.)
					TRBSE2->(dbDelete())
					MsUnLock()	 
				Endif
	/*------------------------------------------------------------------------------------------------------------*/
				
				// Libera o Registro do TRB
				dbSelectArea('TRB')
				MsUnlock()
				
			Endif
	
			IncProc("Processando T��tulo: "+(cAliasSE2)->(E2_PREFIXO+"-"+E2_NUM+"-"+E2_PARCELA))

			// Próximo registro da VIEW do SE2 dentro dos parâmetros
			(cAliasSE2)->(dbSkip())

		Enddo
		
		nTotConcil  := Len(aConcil)
		nTotAnalise := Len(aAnalise)
				
		// Apresentar ao usuário mensagem informando sobre necessidade de Conciliação MANUAL
		// Pois todos os registros do TRB DDA e foram processados e existem duplicidades
		// para ser analisada no SE2 ( Tomada de Decisão )
		If !lAutomato
			Alert("Existe mais de uma chave possivel para a concilia��o autom�tica por este motivo a concilia��o de alguns t��tulos dever� ser feita de forma manual.")
		EndIf
	
		// Browse de Marcação do SE2 para Seleção do Título
		dbSelectArea("TRBSE2")
		DbSetOrder(1)	 
		dbGoTop()

		// Browse dos registros DDA a sergilsonem conciliados Manualmente
		dbSelectArea("TRB")
		DbSetOrder(1)	 
		dbGoTop()
		
		If !lAutomato //Abre interface só caso não for processo automatico 
		
			// Faz o calculo automatico de dimensoes de objetos    
			aSize := MSADVSIZE()
			
			DEFINE MSDIALOG oDlg TITLE "MARFRIG-"+cCadastro From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
			oDlg:lMaximized := .T.
	
			oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,30,30,.T.,.T. )

			// 30/11/2018 - Colocar Informação sobre quantidade de títulos-------------------------------------
    		oTBitmap1 := TBitmap():New(10,30,10,10,"DISABLE",,.T.,oPanel,{||.T.},,.F.,.F.,,,.F.,,.T.,,.F.)
			@ 10,040 Say OemToAnsi("Geral:")           FONT oDlg:oFont PIXEL Of oPanel	
			@ 10,058 Say oTotGeral    VAR nTotGeral    Picture "@E 999,999"     FONT oDlg:oFont PIXEL Of oPanel

    		oTBitmap1 := TBitmap():New(10,90,10,10,"ENABLE",,.T.,oPanel,{||.T.},,.F.,.F.,,,.F.,,.T.,,.F.)
			@ 10,100 Say OemToAnsi("Conciliado:")      FONT oDlg:oFont PIXEL Of oPanel	
			@ 10,128 Say oTotConcil   VAR nTotConcil   Picture "@E 999,999"     FONT oDlg:oFont PIXEL Of oPanel

    		oTBitmap1 := TBitmap():New(10,170,10,10,"BR_AMARELO",,.T.,oPanel,{||.T.},,.F.,.F.,,,.F.,,.T.,,.F.)
			@ 10,180 Say OemToAnsi("Analisar:")        FONT oDlg:oFont PIXEL Of oPanel	
			@ 10,204 Say oTotAnalise  VAR nTotAnalise  Picture "@E 999,999"     FONT oDlg:oFont PIXEL Of oPanel
			
			//--------------------------------------------------------------------------------------------------
			
			DEFINE SBUTTON FROM 10,250 TYPE 1 ACTION (nOpca := 1,oDlg:End()) 			ENABLE OF oPanel
			DEFINE SBUTTON FROM 10,280 TYPE 2 ACTION (nOpca := 0,oDlg:End()) 			ENABLE OF oPanel
			DEFINE SBUTTON oBtn  FROM 10,310 TYPE 15 ACTION (MGF260Pesq(oDadosFig,oTitulo))		ENABLE OF oPanel
			DEFINE SBUTTON oBtn2 FROM 10,340 TYPE 11 ACTION (MGF260LEGTRB())			ENABLE PIXEL OF oPanel
	
			oBtn:cToolTip	:= "Pesquisa DDA"
			oBtn:cCaption	:= "Pesq.DDA"

			oBtn2:cToolTip	:= "Legenda"
			oBtn2:cCaption	:= "Legenda"
			oPanel:Align	:= CONTROL_ALIGN_BOTTOM

			// Browse dos registros DDA a serem conciliados Manualmente
			dbSelectArea("TRB")
			//DbSetOrder(1)	//SEQMOV+FOR_DDA+LOJ_DDA+DTV_DDA+TIT_DDA"
			DbSetOrder(5)	//SEQMOV+FOR_DDA+LOJ_DDA+DTV_DDA+TIT_DDA"		-- GDN 30/11/2018 colocar TRB por ordem OK (Verde primeiro)

			dbGoTop()
	
			// Browse para apresentação da tabela FIG filtrada pelos PARAMETROS	
			@ .5,.5 LISTBOX oDadosFig VAR cVarTRB FIELDS ;
					 		HEADER 	" ",;
					 				"C�digo",;	
							 		"Fornecedor",;	
									"Loja",;	
									"Titulo",;	
									"Vencto",;	
									"Valor",;	
									"Cod.Barra",;	
									"Concilia��o",;   
									"Filial Titulo", ;   
							 COLSIZES    GetTextWidth(0,"BB"),;
							 			 GetTextWidth(0,"BBBBBBB"),;		
										 GetTextWidth(0,"BBBBBBBBBBBBBB"),;
										 GetTextWidth(0,"BBBB"),;			
										 GetTextWidth(0,"BBBBBBBB"),;		
										 GetTextWidth(0,"BBBBBB"),;		
										 GetTextWidth(0,"BBBBBBBBBBBB"),;		
										 GetTextWidth(0,"BBBBBBBBBBBBBBBB"),;		
										 GetTextWidth(0,"BBBBBBBB"),;		
						 	 			 GetTextWidth(0,"BBBBBBB") ; 			
			SIZE 670,160  NOSCROLL
	
			oDadosFig:bLine := { || {aCores[TRB->OK] ,;
								TRB->FOR_DDA	,;
								TRB->NOM_DDA	,;
								TRB->LOJ_DDA	,;
								TRB->TIT_DDA	,;
								TRB->DTV_DDA	,;
								PADR(TRB->VLR_DDA,18),;
								TRB->CODBAR		,;
								TRB->DTC_DDA	,;
								TRB->FIL_DDA }}

			oDadosFig:bChange := {|| MgfFilter(oTitulo,TRB->FOR_DDA,TRB->DTV_DDA,TRB->VLR_DDA,TRB->FIL_DDA,strzero(TRB->REC_DDA,15)) } 	

			// Browse de Marcação do SE2 para Seleção do Título
			dbSelectArea("TRBSE2")
			DbSetOrder(1)	//SEQMOV+FOR_DDA+LOJ_DDA+DTV_DDA+TIT_DDA"
			dbGoTop()

			@ 13,.5	LISTBOX oTitulo VAR cVarSE2 FIELDS ;
					 		HEADER  	" ",;		//
					 					"Filial",;	//
										"C�digo",;	//
										"Fornecedor",;	//
										"Titulo",;	//
										"Vencto",;	//
										"Valor",;	//
										"PIS",;	//
										"COFINS",;	//
										"CSLL",;	//
										"ACR",;	//
										"DCR",;	//
										"Valor Liq",;   //		SALDO -  (PCC )
							 COLSIZES 	 GetTextWidth(0,"BB"),;
							 			 GetTextWidth(0,"BBBB"),;			//Filial
										 GetTextWidth(0,"BBBBB"),;			//Fornecedor
										 GetTextWidth(0,"BBBBBBBBBBB"),;	//Titulo
										 GetTextWidth(0,"BBBBBBBBBBB"),;	//Titulo
										 GetTextWidth(0,"BBBBBB"),;			//Vencto
										 GetTextWidth(0,"BBBBBBBBB"),;		//Valor
										 GetTextWidth(0,"BBBBBBBBB"),;		//PIS
										 GetTextWidth(0,"BBBBBBBBB"),;		//COFINS
										 GetTextWidth(0,"BBBBBBBBB"),;		//CSLL
										 GetTextWidth(0,"BBBB"),;		//ACR
										 GetTextWidth(0,"BBBB"),;		//DCR
										 GetTextWidth(0,"BBBBBBBBB") ;		//Valor Liq
			SIZE 670,100 ON DBLCLICK (MGF260Marca(oTitulo),oTitulo:DrawSelect(),oTitulo:Refresh(.T.)) NOSCROLL
	
			oTitulo:bLine := { ||   {Iif(Empty(TRBSE2->MARK),oNoMark,oMark)  ,;
									TRBSE2->FIL_SE2	,;
									TRBSE2->FOR_SE2	,;
									TRBSE2->NOM_SE2	,;
									TRBSE2->TIT_SE2	,;
									TRBSE2->DTV_SE2	,;
									PADR(TRBSE2->VLR_SE2,18),;
									TRBSE2->PIS_SE2,;
									TRBSE2->COF_SE2,;
									TRBSE2->CSL_SE2,;																		
									TRBSE2->ACR_SE2,;
									TRBSE2->DCR_SE2,;																				
									PADR(TRBSE2->VLQ_SE2,18) }}
 	
			ACTIVATE MSDIALOG oDlg ON INIT (oDadosFig:GoDown(),oDadosFig:GoUp(),oTitulo:GoPosition(1),oTitulo:DrawSelect(),oTitulo:Refresh(.T.)) CENTERED 
        Else
          nOpca := 1
        Endif     

		// Ao confirmar a tela, processar a atualização dos campos nas tabelas 
		// DDA e SE2 Originais.
		If nOpca == 1 .or. lAutomato

			BEGIN TRANSACTION

			dbSelectArea("TRBSE2")
			dbClearFilter()
			
			dbSelectArea("TRB")
			dbGoTop()
			// Monto a regua de Processamento 
			ProcRegua(RecCount())
			
			While !(TRB->(Eof()))
				IncProc("Processando Concilia��es: "+TRB->TIT_DDA) 
				If TRB->RECTRBSE2>0
					TRBSE2->(dbGoTo(TRB->RECTRBSE2))
					
					// Se estiver marcado para processar,
					IF !Empty(TRBSE2->MARK)			
						nRecSE2 := TRB->REC_SE2
						nRecDDA := TRB->REC_DDA
		
						//Se houve cociliacao
						//Gravo os dados do codigo de barras no SE2
						//Gravo os dados do titulo SE2 na tabela DDA (FIG)
						If nRecSE2 > 0 .and. nRecDDA > 0
							// Atualizar a tabela FISICA do SE2 e do FIG
							dbSelectArea("SE2")
							dbGoto(nRecSE2)
							If RecLock("SE2",.F.) 
								SE2->E2_CODBAR	:= TRB->CODBAR
								cTitSE2			:= SE2->E2_FILIAL+"|"+;
													SE2->E2_PREFIXO+"|"+;
													SE2->E2_NUM+"|"+;
													SE2->E2_PARCELA+"|"+;
													SE2->E2_TIPO+"|"+;
													SE2->E2_FORNECE+"|"+;
													SE2->E2_LOJA+"|"
		
							Endif
		
							dbSelectArea("FIG")
							dbGoto(nRecDDA)
							If RecLock("FIG",.F.)
								FIG->FIG_DDASE2	:= cTitSE2		//Chave do SE2 com o qual foi conciliado
								FIG->FIG_CONCIL	:= "1" 			//Conciliado
								FIG->FIG_DTCONC	:= dDatabase	//Data da Conciliacao
								FIG->FIG_USCONC	:= cUsername	//Usuario responsavel pela conciliacao
							Endif
							// History - Gravar dados na ZDS
							nValPP := STRTRAN(TRBSE2->VLQ_SE2,".","")
							nValPP := STRTRAN(nValPP,",",".")
							nValPP := VAL(nValPP)

							If nValPP  <>  FIG->FIG_VALOR 
							   //( (FIG->FIG_VALOR - TRBSE2->VLQ_SE2 ) <= mv_par15  .OR.  ;
							   //  (FIG->FIG_VALOR - TRBSE2->VLQ_SE2 ) <= mv_par16 )
								
								dbSelectArea('ZDS')
								ZDS->(dbSetOrder(1))
								ZDS->(dbSeek(SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA))
							
								//dbSelectArea('ZDS')
								//ZDS->(dbSetOrder(1)) 
								Reclock("ZDS",.T.)
			
									ZDS->ZDS_FILIAL := SE2->E2_FILIAL
									ZDS->ZDS_PREFIX := SE2->E2_PREFIXO
									ZDS->ZDS_NUM    := SE2->E2_NUM
									ZDS->ZDS_PARCEL := SE2->E2_PARCELA
									ZDS->ZDS_TIPO   := SE2->E2_TIPO
									ZDS->ZDS_FORNEC := SE2->E2_FORNECE
									ZDS->ZDS_LOJA   := SE2->E2_LOJA
									ZDS->ZDS_HISTOR := 'AJUSTE DE ARREDONDAMENTO INCLUIDO PELA CONCILIACAO DDA'


									// Estipulado pelo Mauricio estas 2 situa��e (001/503)
									If  FIG->FIG_VALOR  > nValPP
										ZDS->ZDS_COD    := "001" 
										ZDS->ZDS_VALOR  := (FIG->FIG_VALOR  - nValPP )  
									Else
										ZDS->ZDS_COD    := "503" 
										ZDS->ZDS_VALOR  := ( nValPP  - FIG->FIG_VALOR)   
									Endif
							
								ZDS->(MsUnlock()) 

								dbSelectArea("SE2")
								dbGoto(nRecSE2)
								If RecLock("SE2",.F.)
									If  FIG->FIG_VALOR > nValPP
										SE2->E2_ACRESC	:=  SE2->E2_ACRESC   + ( FIG->FIG_VALOR  - nValPP )
										SE2->E2_SDACRES	:=  SE2->E2_SDACRES  + ( FIG->FIG_VALOR  - nValPP )
									Else
										SE2->E2_DECRESC :=  SE2->E2_DECRESC  + ( nValPP - FIG->FIG_VALOR )
										SE2->E2_SDDECRE	:=  SE2->E2_SDDECRE  + ( nValPP - FIG->FIG_VALOR )
									
									Endif
								ENDIF
							Endif

							
							//Endif

							// Fim History  
						EndIf
					Endif
				Endif
				dbSelectArea("TRB")
				dbSkip()
 			Enddo

			END TRANSACTION

		EndIf
	Endif
Endif

//Destravar os registros do SE2 e FIG antes de sair
MgF260Lock(.F.,aRLocksSE2,aRLocksFIG,,,,.T.)

//Finalizar o arquivo de trabalho
dbSelectArea("TRBSE2")
Set Filter To
dbCloseArea()

dbSelectArea("TRB")
Set Filter To
dbCloseArea()

//Deleta tabela temporária criada no banco de dados
If oTrabFig <> Nil
	oTrabFig:Delete()
	oTrabFig := Nil
Endif

IF SELECT("NEWFIG") != 0
   dbSelectArea( "NEWFIG" )
   dbCloseArea()
   If !Empty(cIndex)
	   FErase (cIndex+OrdBagExt())
   Endif
ENDIF

IF SELECT("NEWSE2") != 0
   dbSelectArea( "NEWSE2" )
   dbCloseArea()
   If !Empty(cIndex)
	   FErase (cIndex+OrdBagExt())
   Endif
ENDIF

dbSelectArea("FIG")
dbSetOrder(1)

Return(.T.)

Static Function MGF260Filial()
Local cFilIn	:= ""
Local nInc		:= 0
Local aSM0		:=  MgAdmAbreSM0()

//Considero filiais do intervalo e arquivos exclusivos
If mv_par01 == 1 .and. !Empty(xFilial("SE2"))
	//Arquivos Exclusivos
	For nInc := 1 To Len( aSM0 )
		If aSM0[nInc][2] >= mv_par02 .and. aSM0[nInc][2] <= mv_par03
			cFilIn += aSM0[nInc][2] + "/"
		EndIf
	Next
Else
	cFilIn := xFilial("SE2")
Endif

Return cFilIn

Static Function MgF260Lock(lLock,aRLocksSE2,aRLocksFIG,nRecnoSE2,nRecnoFIG,lHelp,lTodos)
Local aArea	:= GetArea()
Local nPosRec
Local lSE2	:= .F.
Local	lFIG	:= .F.
Local lRet	:= .F.

DEFAULT lLock := .F.		//Travamento ou destravamento dos registros
DEFAULT lHelp := .F.		//Mostra help ou nao
DEFAULT lTodos:= .F.		//Libera todos os registros
DEFAULT aRLocksSE2:={}		//Array de registros do SE2 lockados com o usuario
DEFAULT aRLocksFIG:={}		//Array de registros do FIG lockados com o usuario

If lTodos
	//Destrava todos os registros - Final do processamento
	AEval(aRLocksSE2,{|x,y| SE2->(MsRUnlock(x))})
	aRLocksSE2:={}

	AEval(aRLocksFIG,{|x,y| FIG->(MsRUnlock(x))})
	aRLocksFIG:={}

Else
	//Controle de marcacao ou desmarcaao dos titulos
	If nRecnoSE2 <> Nil
		SE2->(MsGoto(nRecnoSE2))
		lSE2	:= .T.
	Endif

	If nRecnoFIG <> Nil
		FIG->(MsGoto(nRecnoFIG))
		lFIG	:= .T.
	Endif

	If lLock //Rotina chamada para travamento dos registros do SE2 e FIG

		//A conciliacao somente sera permitida quando os registros do SE2 e FIG puderem ser travados
		//Caso um deles esteja em uso por outro terminal, nao sera permitida a conciliacao
		If lSE2 .and. lFIG
			If SE2->(MsRLock()) .and. FIG->(MsRLock())
				AAdd(aRLocksSE2, SE2->(Recno()))
				AAdd(aRLocksFIG, FIG->(Recno()))
				lRet	:=	.T.
			ElseIf lHelp
				MsgAlert("Um dos registros relacionados est� sendo utilizado em outro terminal e não pode ser utilizado na Concilia��o DDA")		//
			Endif
		Endif
	Else
		If lSE2 .and. lFIG
			//Destravo registro no SE2
			SE2->(MsRUnlock(SE2->(Recno())))
			If (nPosRec:=Ascan(aRlocksSE2,SE2->(Recno()))) > 0
				Adel(aRlocksSE2,nPosRec)
				aSize(aRlocksSE2,Len(aRlocksSE2)-1)
			Endif
			//Destravo registro no FIG
			FIG->(MsRUnlock(FIG->(Recno())))
			If (nPosRec:=Ascan(aRlocksFIG,FIG->(REcno()))) > 0
				Adel(aRlocksFIG,nPosRec)
				aSize(aRlocksFIG,Len(aRlocksFIG)-1)
			Endif
		Endif
	Endif
Endif

If aArea <> Nil
	RestArea(aArea)
Endif

Return lRet

Static Function MgAdmAbreSM0()
	Local aArea			:= SM0->( GetArea() )
	Local aAux			:= {}
	Local aRetSM0		:= {}
	Local lFWLoadSM0	:= .T.
	Local lFWCodFilSM0 	:= .T.

	If lFWLoadSM0
		aRetSM0	:= FWLoadSM0()
	Else
		DbSelectArea( "SM0" )
		SM0->( DbGoTop() )
		While SM0->( !Eof() )
			aAux := { 	SM0->M0_CODIGO,;
						IIf( lFWCodFilSM0, FWGETCODFILIAL, SM0->M0_CODFIL ),;
						"",;
						"",;
						"",;
						SM0->M0_NOME,;
						SM0->M0_FILIAL }

			aAdd( aRetSM0, aClone( aAux ) )
			SM0->( DbSkip() )
		End
	EndIf

	RestArea( aArea )
Return aRetSM0

Static Function MGF260CriArq()  
Local aDbStru := {}
Local aDbStruSE2 := {}
Local nTamFil := TamSX3("E2_FILIAL")[1]
Local nTamTip := TamSX3("E2_TIPO")[1]
Local nTamFor := TamSX3("E2_FORNECE")[1]
Local nTamLoj := TamSX3("E2_LOJA")[1]
//Ao tamanho do titulo serão somados os separadores
Local nTamTit := TamSX3("E2_PREFIXO")[1]+TamSX3("E2_NUM")[1]+TamSX3("E2_PARCELA")[1]+nTamFil+5
Local nTamKey := TamSX3("E2_PREFIXO")[1]+TamSX3("E2_NUM")[1]+TamSX3("E2_PARCELA")[1]+nTamTip+nTamFil
Local nTamNom := TamSX3("E2_NOMFOR")[1]

//Arquivo de reconciliacao
//Campos de sequencia de conciliacao
aadd(aDbStru,{"SEQMOV    ","C",05,0})
aadd(aDbStru,{"SEQCON    ","C",05,0})

//Campos do FIG - Conciliacao DDA
aadd(aDbStru,{"FIL_DDA   ","C",nTamFil,0})
aadd(aDbStru,{"FOR_DDA   ","C",nTamFor,0})
aadd(aDbStru,{"NOM_DDA   ","C",nTamNom,0})
aadd(aDbStru,{"LOJ_DDA   ","C",nTamLoj,0})
aadd(aDbStru,{"TIT_DDA   ","C",15,0})
aadd(aDbStru,{"DTV_DDA   ","D",08,0})
aadd(aDbStru,{"VLR_DDA   ","C",18,0})
aadd(aDbStru,{"CODBAR	 ","C",44,0})
aadd(aDbStru,{"DTC_DDA   ","D",08,0})
aadd(aDbStru,{"TIP_DDA   ","C",nTamTip,0})

//Campos auxiliares TRB
aadd(aDbStru,{"REC_DDA   ","N",09,0})
aadd(aDbStru,{"REC_SE2   ","N",09,0})
aadd(aDbStru,{"RECTRBSE2 ","N",09,0})
aadd(aDbStru,{"OK        ","N",01,0})
aadd(aDbStru,{"OKINI     ","N",01,0})
aadd(aDbStru,{"MARK      ","C",02,0})

//Campos auxiliares SE2
aadd(aDbStruSE2,{"REC_DDA   ","N",09,0})
aadd(aDbStruSE2,{"REC_SE2   ","N",09,0})
aadd(aDbStruSE2,{"OK        ","N",01,0})
aadd(aDbStruSE2,{"MARK      ","C",02,0})

aadd(aDbStruSE2,{"SEQMOV    ","C",05,0})
aadd(aDbStruSE2,{"SEQCON    ","C",05,0})


//Campos do SE2 - Cadastro Conta a Pagar
aadd(aDbStruSE2,{"FIL_SE2   ","C",nTamFil,0})
aadd(aDbStruSE2,{"FOR_SE2   ","C",nTamFor,0})
aadd(aDbStruSE2,{"NOM_SE2   ","C",nTamNom,0})
aadd(aDbStruSE2,{"LOJ_SE2   ","C",nTamLoj,0})
aadd(aDbStruSE2,{"PRF_SE2   ","C",03,0})
aadd(aDbStruSE2,{"NUM_SE2   ","C",09,0})
aadd(aDbStruSE2,{"DTV_SE2   ","D",08,0})
aadd(aDbStruSE2,{"VENCTO    ","D",08,0})
aadd(aDbStruSE2,{"REC_CONC  ","C",15,0})
aadd(aDbStruSE2,{"VLR_SE2   ","C",18,0})
aadd(aDbStruSE2,{"PIS_SE2   ","N",18,2})
aadd(aDbStruSE2,{"COF_SE2   ","N",18,2})
aadd(aDbStruSE2,{"CSL_SE2   ","N",18,2})
aadd(aDbStruSE2,{"SLD_SE2   ","N",18,2})
aadd(aDbStruSE2,{"IRF_SE2   ","N",18,2})
aadd(aDbStruSE2,{"INS_SE2   ","N",18,2})
aadd(aDbStruSE2,{"ISS_SE2   ","N",18,2})
aadd(aDbStruSE2,{"ACR_SE2   ","N",18,2})
aadd(aDbStruSE2,{"DCR_SE2   ","N",18,2})
aadd(aDbStruSE2,{"DIFVLR    ","N",1,0})
aadd(aDbStruSE2,{"DIFDTV    ","N",1,0})
aadd(aDbStruSE2,{"VLQ_SE2   ","C",18,0})
aadd(aDbStruSE2,{"KEY_SE2   ","C",nTamKey,0})  //Numero do titulo sem separadores (para comparacao)
aadd(aDbStruSE2,{"TIT_SE2   ","C",nTamTit,0})  //Numero do titulo com separadores (para visualizacao)
aadd(aDbStruSE2,{"TIP_SE2   ","C",nTamTip,0})

//----------------------------
//Criação da tabela temporaria 
//----------------------------
If oTrabFig <> Nil
	oTrabFig:Delete()
	oTrabFig := Nil
Endif

If oTrabSE2 <> Nil
	oTrabSE2:Delete()
	oTrabSE2 := Nil
Endif

// Temporária para uso no Browse Superior ( TRB da DDA )

oTrabFig := FWTemporaryTable():New( "TRB" )  
oTrabFig:SetFields(aDbStru)
/* Loja removido, conforme chamado Marfrig RITM0017555. Onde um unico CPF pode estar cadastrado em mais de uma loja do fornecedor.
oTrabFig:AddIndex("1", {"FOR_DDA","LOJ_DDA","DTV_DDA","TIT_DDA"}) 	
oTrabFig:AddIndex("2", {"FOR_DDA","LOJ_DDA","TIT_DDA","DTV_DDA"})
oTrabFig:AddIndex("1", {"FOR_DDA","DTV_DDA","TIT_DDA","LOJ_DDA"}) 	
oTrabFig:AddIndex("2", {"FOR_DDA","TIT_DDA","DTV_DDA","LOJ_DDA"})*/
oTrabFig:AddIndex("1", {"FOR_DDA","DTV_DDA","TIT_DDA"}) 	
oTrabFig:AddIndex("2", {"FOR_DDA","TIT_DDA","DTV_DDA"})
oTrabFig:AddIndex("3", {"TIT_DDA"}) 	
oTrabFig:AddIndex("4", {"SEQMOV","FOR_DDA","LOJ_DDA","DTV_DDA","TIT_DDA"}) 	
oTrabFig:AddIndex("5", {"OK","FOR_DDA","LOJ_DDA","DTV_DDA","TIT_DDA"}) 	

oTrabFig:Create()	

// Temporária para uso no Browse Inferior Marcação ( TRB da SE2 )
oTrabSE2 := FWTemporaryTable():New( "TRBSE2" )  
oTrabSE2:SetFields(aDbStruSE2) 	
/* Loja removido, conforme chamado Marfrig RITM0017555. Onde um unico CPF pode estar cadastrado em mais de uma loja do fornecedor.
oTrabSE2:AddIndex("1", {"FOR_SE2","LOJ_SE2","DTV_SE2","KEY_SE2"}) 	
oTrabSE2:AddIndex("2", {"FOR_SE2","LOJ_SE2","KEY_SE2","DTV_SE2"})
oTrabSE2:AddIndex("1", {"FOR_SE2","DTV_SE2","KEY_SE2","LOJ_SE2"})	
oTrabSE2:AddIndex("2", {"FOR_SE2","KEY_SE2","DTV_SE2","LOJ_SE2"})*/
oTrabSE2:AddIndex("1", {"FOR_SE2","DTV_SE2","KEY_SE2"})	
oTrabSE2:AddIndex("2", {"FOR_SE2","KEY_SE2","DTV_SE2"})
oTrabSE2:AddIndex("3", {"KEY_SE2"}) 	
oTrabSE2:Create()	

Return

Static Function MGF260Marca(oTitulo)
Local nRec:=TRBSE2->(Recno())
Local cOldMark:=TRBSE2->MARK
Local nOldOK := TRB->OKINI
TRBSE2->(dbGoTop())
While !TRBSE2->(Eof())
	RecLock("TRBSE2",.F.)
	TRBSE2->MARK 	:= ' '
	MsUnLock()
	TRBSE2->(dbSkip())
End
TRBSE2->(dbGoTo(nRec))
// Só pode marcar se o valor Bater
If (TRBSE2->(VLQ_SE2) == TRB->VLR_DDA) .or. (TRBSE2->DIFVLR == 1 .and. TRBSE2->(VLQ_SE2) <> TRB->VLR_DDA)
	RecLock("TRBSE2",.F.)
	TRBSE2->MARK 	 := iif(Empty(cOldMark),cMarca,' ')
	TRBSE2->REC_DDA  := TRB->REC_DDA
	MsUnLock()
	// Gravar o Recno do TRBSE2 no TRB para usar na confirmação se estiver MARCADO com [X]
	RecLock("TRB",.F.)
	TRB->REC_SE2   := iif(Empty(TRBSE2->MARK),0,TRBSE2->REC_SE2)
	TRB->DTC_DDA   := iif(Empty(TRBSE2->MARK),STOD('  /  /  '),dDataBase)
	TRB->OK        := iif(Empty(TRBSE2->MARK),nOldOK,1)
	TRB->RECTRBSE2 := iif(Empty(TRBSE2->MARK),0,TRBSE2->(Recno()))

	MsUnLock()
Endif
TRBSE2->(dbGoTo(nRec))

// Mostra os Contadores
//oTotGeral:Refresh()
//oTotConcil:Refresh()
//oTotAnalise:Refresh()

// Atualize tela de Browse.
TRB->(oDadosFig:DrawSelect())
TRB->(oDadosFig:Refresh(.T.))

Return()

Static Function MGF260Verif(cAliasFIG)
Local lRet := .F.
DEFAULT cAliasFIG := "FIG"
If Empty((cAliasFIG)->FIG_FORNEC) .OR. Empty((cAliasFIG)->FIG_CODBAR) .OR. ;
	Empty((cAliasFIG)->FIG_TITULO) .OR. Empty((cAliasFIG)->FIG_VENCTO) .OR. ;
	Empty((cAliasFIG)->FIG_VALOR)  .OR. Empty((cAliasFIG)->FIG_CNPJ)
	lRet := .T.
Endif
Return lRet	


Static Function MgfFilter(oTitulo,cFORDDA,dDTVDDA,cVLRDDA,cFilDDA,cRegDDA)
Local aArea:=GetArea()

dbSelectArea("TRBSE2")
dbClearFilter()
//DbSetFilter({|| FIL_SE2+FOR_SE2+dtos(DTV_SE2)+VLR_SE2 = cFilDDA+cForDDA+dtos(dDTVDDA)+cVLRDDA }, "FIL_SE2+FOR_SE2+dtos(DTV_SE2)+VLR_SE2 = cFilDDA+cForDDA+dtos(dDTVDDA)+cVLRDDA")
//DbSetFilter({|| FOR_SE2+dtos(DTV_SE2)+VLQ_SE2 = cForDDA+dtos(dDTVDDA)+cVLRDDA }, "FOR_SE2+dtos(DTV_SE2)+VLQ_SE2 = cForDDA+dtos(dDTVDDA)+cVLRDDA")
DbSetFilter({|| FOR_SE2+REC_CONC = cForDDA+cRegDDA }, "FOR_SE2+REC_CONC = cForDDA+cRegDDA")
TRBSE2->(dbGoTop())

// Estabilizar os Browses
TRBSE2->(oTitulo:ResetLen())
TRBSE2->(oTitulo:GoPosition(1))
TRBSE2->(oTitulo:GoBottom())
TRBSE2->(oTitulo:GoTop())
TRBSE2->(oTitulo:DrawSelect())
TRBSE2->(oTitulo:Refresh(.T.))

TRB->(oDadosFig:DrawSelect())
TRB->(oDadosFig:Refresh(.T.))

RestArea(aArea)

Return()

Static Function MGF260LegTrb()

Local aLegenda := {}
Local nY     	:= 0
Local nX     	:= 0
Local aBmp[9]
Local aSays[9]
Local oDlgLeg

Aadd(aLegenda, {"ENABLE"		, "Conciliado"})	
Aadd(aLegenda, {"BR_AMARELO"	, "Verificar Dados"})
Aadd(aLegenda, {"DISABLE"		, "N�o Conciliado"})

DEFINE MSDIALOG oDlgLeg FROM 0,0 TO (Len(aLegenda)*20)+110, 500 TITLE cCadastro OF oMainWnd PIXEL

	oDlgLeg:bLClicked:= {||oDlgLeg:End()}

	DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
	DEFINE FONT oBold2 NAME "Arial" SIZE 0, -11 BOLD

	@ 0, 0 BITMAP RESNAME "PROJETOAP" OF oDlgLeg SIZE 35,155 NOBORDER WHEN .F. PIXEL

	@ 11,35 TO 013,400 LABEL '' OF oDlgLeg PIXEL
	@ 03,37 SAY "Legenda" OF oDlgLeg PIXEL SIZE 150,009 FONT oBold		//
	For nX := 1 to Len(aLegenda)
		@ 20+((nX-1)*10),43 BITMAP aBmp[nX] RESNAME aLegenda[nX][1] OF oDlgLeg SIZE 20,10 PIXEL NOBORDER
		@ 20+((nX-1)*10),53 SAY If((nY+=1)==nY,aLegenda[nY][2]+If(nY==Len(aLegenda),If((nY:=0)==nY,"",""),""),"") OF oDlgLeg PIXEL
	Next nX
	nY := 0

ACTIVATE MSDIALOG oDlgLeg CENTERED

Return(NIL)

Static Function MGF260Pesq(oDadosFig,oTitulo)

Local nRecno		:= 0
Local aPesqui		:={}
Local cSeek			:= ""
Local nIndex		:= 1
dbSelectArea("TRB")
nRecno	:= Recno()
nIndex	:= IndexOrd()
aAdd(aPesqui,{"Fornecedor DDA + Loja DDA + Vencto. DDA + Titulo DDA",1})
WndxPesqui(,aPesqui,cSeek,.F.)
dbSelectArea("TRB")
dbSetOrder(nIndex)
//Caso não tenha achado, volto para o registro de partida
IF TRB->(EOF())
	MsgStop(" N�o foi poss��vel identificar a pesquisa. ")
	TRB->(dbgoto(nRecno))
Endif

// Estabilizar os Browses
TRBSE2->(oTitulo:ResetLen())
TRBSE2->(oTitulo:GoPosition(1))
TRBSE2->(oTitulo:GoBottom())
TRBSE2->(oTitulo:GoTop())
TRBSE2->(oTitulo:DrawSelect())
TRBSE2->(oTitulo:Refresh(.T.))
		 	
TRB->(Eval(oDadosFig:bChange))
TRB->(oDadosFig:DrawSelect())
TRB->(oDadosFig:Refresh(.T.))


Return Nil
