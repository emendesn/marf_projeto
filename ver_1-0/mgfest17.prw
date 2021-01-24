#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)
//-------------------------------------------------------------------
/*/{Protheus.doc} MGFEST17

Gera PrÃ© NF de Entrada das NFs de SaÃ­da validadas pela Inventti

@author Gustavo Ananias Afonso - TOTVS Campinas
@since 08/09/2016
/*/
//-------------------------------------------------------------------
user function MGFEST17(cChaveNFS)
local nI			:= 0
local cQrySZ5		:= ""
local aSZ5			:= {}
Local aTables
//Local cTes
Local cOper := ""

Private _lJob	:= .F. // IIf(GetRemoteType() == -1, .T., .F.)

Default cChaveNFS := ""

If Type("cFilAnt") == "U"

	_lJob	:= .T.
	// Seta job para nao consumir licenças
	RpcSetType(3)

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Preparação do Ambiente.                                                                                  |
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	RpcSetEnv( "01" , "010001" , Nil, Nil, "EST", Nil )//, aTables )

	SetFunName("MGFEST17")
	
EndIf

cQrySZ5 := "SELECT Z5_FILIAL, Z5_LOCDEST, Z4_CODFOR, Z4_LOJAFOR, Z5_UNIDADE, Z5_EMPRESA, Z5_NUMPV, Z5_NUM, Z5_NUMNF, Z4_CODCLI, Z4_LOJACLI, Z5_NFREMOR ,  "	+ CRLF
cQrySZ5 += "		Z5_TESVEN, Z4_TESVENE, Z5_TESTRAN, Z4_TESTRNE, Z5_TESREM, Z4_TESREME, Z5_TESRET, Z4_TESRETE, Z4_CLIRET, Z4_LJCLIRE, Z4_FORRET, Z4_LJFORRE, "	+ CRLF
cQrySZ5 += "		Z4_OPEVENE, Z4_OPETRNE, Z4_OPEREME, Z4_OPERETE "	+ CRLF
cQrySZ5 += "FROM "			+ retSQLName("SZ5") + " SZ5 "	+ CRLF
cQrySZ5 += "INNER JOIN "	+ retSQLName("SZ4") + " SZ4 ON SZ4.D_E_L_E_T_ = '' "	+ CRLF
//cQrySZ5 += "	AND SZ4.Z4_FILIAL = SZ5.Z5_UNIDADE "	+ CRLF
cQrySZ5 += "	AND SZ4.Z4_UNIDADE = SZ5.Z5_UNIDADE "	+ CRLF
//cQrySZ5 += "	AND SZ4.Z4_LOCAL = SZ5.Z5_LOCDEST "	+ CRLF
cQrySZ5 += "	AND SZ4.Z4_LOCDEST = SZ5.Z5_LOCDEST "	+ CRLF
cQrySZ5 += "	AND SZ4.Z4_EMPRESA = SZ5.Z5_EMPRESA  "	+ CRLF
cQrySZ5 += " INNER JOIN "	+ retSQLName("SF2") + " SF2"	+ CRLF
cQrySZ5 += " ON"											+ CRLF
If tcGetDb() == "ORACLE"
	cQrySZ5 += " 	SZ5.Z5_NUMNF = (SF2.F2_FILIAL || SF2.F2_DOC || SF2.F2_SERIE || SF2.F2_CLIENTE || SF2.F2_LOJA)"	+ CRLF
Else
	cQrySZ5 += " 	SZ5.Z5_NUMNF = (SF2.F2_FILIAL + SF2.F2_DOC + SF2.F2_SERIE + SF2.F2_CLIENTE + SF2.F2_LOJA)"		+ CRLF
Endif
cQrySZ5 += " WHERE"													+ CRLF
cQrySZ5 += " 		SZ5.Z5_NUMNFEN  =	''" 						+ CRLF // Pre notas NAO geradas
cQrySZ5 += " 	AND	SF2.F2_CHVNFE  	<>	''" 						+ CRLF // Notas validadas
If Empty(cChaveNFS) // gera a nota de entrada para todos os registros pendentes
	cQrySZ5 += " 	AND	SZ5.Z5_NUMNF  	<>	''" 						+ CRLF // Notas geradas
Else // gera somente para o registro posicionado
	cQrySZ5 += " 	AND	SZ5.Z5_NUMNF  	=	'"+cChaveNFS+"' " 			+ CRLF // Notas geradas
Endif	
//cQrySZ5 += " 	AND	SF2.F2_FILIAL	=	'" + xFilial("SF2") + "'"	+ CRLF
//cQrySZ5 += " 	AND	SZ5.Z5_FILIAL	=	'" + xFilial("SZ5") + "'"	+ CRLF
//If !_lJob
//	cQrySZ5 += " 	AND	SZ5.Z5_UNIDADE	=	'" + xFilial("SZ5") + "'"	+ CRLF
//EndIf
cQrySZ5 += " 	AND	SF2.D_E_L_E_T_	<>	'*'"						+ CRLF
cQrySZ5 += " 	AND	SZ5.D_E_L_E_T_	<>	'*'"						+ CRLF

TcQuery changeQuery(cQrySZ5) New Alias "QRYSZ5"

MemoWrite("c:\temp\MGFEST17.txt", changeQuery(cQrySZ5))

if !QRYSZ5->(EOF())
	while !QRYSZ5->(EOF())
		/*
		cTes	:= ""
		If	!Empty( QRYSZ5->Z5_TESVEN )
			cTes := QRYSZ5->Z4_TESVENE
		ElseIf	!Empty( QRYSZ5->Z5_TESTRAN )
			cTes := QRYSZ5->Z4_TESTRNE
		ElseIf	!Empty( QRYSZ5->Z5_TESREM )
			cTes := QRYSZ5->Z4_TESREME
		ElseIf	!Empty( QRYSZ5->Z5_TESRET )
			cTes := QRYSZ5->Z4_TESRETE
		EndIf	
		*/
		cOper := ""
		If	!Empty( QRYSZ5->Z5_TESVEN )
			cOper := QRYSZ5->Z4_OPEVENE
		ElseIf	!Empty( QRYSZ5->Z5_TESTRAN )
			cOper := QRYSZ5->Z4_OPETRNE
		ElseIf	!Empty( QRYSZ5->Z5_TESREM )
			cOper := QRYSZ5->Z4_OPEREME
		ElseIf	!Empty( QRYSZ5->Z5_TESRET )
			cOper := QRYSZ5->Z4_OPERETE
		EndIf	
		
		//			1					2					3					4					5					6					7				8				9					10					11					12		13					14					15					16					17					
		aadd(aSZ5, {QRYSZ5->Z5_LOCDEST, QRYSZ5->Z4_CODFOR, QRYSZ5->Z4_LOJAFOR, QRYSZ5->Z5_UNIDADE, QRYSZ5->Z5_EMPRESA, QRYSZ5->Z5_NUMPV, QRYSZ5->Z5_NUM, QRYSZ5->Z5_NUMNF, QRYSZ5->Z4_CODCLI, QRYSZ5->Z4_LOJACLI, QRYSZ5->Z5_NFREMOR , cOper , QRYSZ5->Z5_FILIAL , QRYSZ5->Z4_CLIRET , QRYSZ5->Z4_LJCLIRE , QRYSZ5->Z4_FORRET , QRYSZ5->Z4_LJFORRE })
		
		QRYSZ5->(DBSkip())
	enddo
else
	if !isBlind()
		msgAlert( "Nota Fiscal de Saída não transmita. Não poderá ser emitida a Nota de Entrada no destino." )
	endif
endif

QRYSZ5->(DBCloseArea())

for nI := 1 to len(aSZ5)
	BEGIN TRANSACTION

	MGFInputNF(nil, aSZ5[nI, 6], .T., aSZ5[nI, 7], aSZ5[nI], aSZ5[nI, 12])

	END TRANSACTION
next

If _lJob
	RpcClearEnv()
EndIf

return

//-------------------------------------------------------------
// Gera NF de Entrada para a Empresa/Filial que receberÃ¡ o material
//-------------------------------------------------------------
Static Function MGFInputNF(oSay, cC5Num, lSchedule, cSZ5Num, aSZ5, cOperD1)

local nI		:= 0
local aLine 	:= {}
local aSF1		:= {}
local aSD1		:= {}
local cF1Num	:= ""
local cNFItem	:= strZero( 0 , tamSX3("D1_ITEM")[1] )
Local cOriFiNum := ""
Local cOriF1Serie := ""
Local cOriF1Item := ""

local cBkpEmp	:= cEmpAnt
local cBkpFil	:= cFilAnt
local lChgEnv	:= .F.

local aArea		:= getArea()
local aAreaSC9	:= SC9->(getArea())
Local cTipo := "N"
Local cIdentB6 := ""
Local nCnt := 0
Local cTes := ""
Local cMsg := ""
Local cChaveNFS := GetAdvFVal("SF2","F2_CHVNFE",aSZ5[8],1,"")

local aAreaSF2 := SF2->(getArea())

default lSchedule	:= .F.

private lMsHelpAuto     := .T.
private lMsErroAuto     := .F.
private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

cC5Chave := aSZ5[13] + cC5Num
cD2Chave := Subs( aSZ5[8] , 1 , FWSizeFilial()+tamSx3("F2_DOC")[1]+tamSx3("F2_SERIE")[1]+tamSx3("F2_CLIENTE")[1]+tamSx3("F2_LOJA")[1] )

SC5->(dbSetOrder(1))
SC6->(dbSetOrder(1))

DBSelectArea("SD2")
dbSetOrder(3) // D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
SD2->(DBGoTop())

if cFilAnt <> aSZ5[4] .OR. cEmpAnt <> aSZ5[5]
	lChgEnv := .T.
	cFilAnt := aSZ5[4]
endif

If SC5->(dbSeek(cC5Chave))
	cF1Num		:= Subs( aSZ5[8], FWSizeFilial() + 1							, tamSx3("F2_DOC")[1]	)
	cF1Serie	:= Subs( aSZ5[8], FWSizeFilial() + tamSx3("F2_DOC")[1] + 1		, tamSx3("F2_SERIE")[1]	)

//	If SC5->C5_ZTPTRAN == "3" // Remessa
//		cTipo := "B" // beneficiamento
//
//		cOriFiNum	:= Subs( aSZ5[8], FWSizeFilial() + 1						,tamSx3("F2_DOC")[1])
//		cOriF1Serie	:= Subs( aSZ5[8], FWSizeFilial() + tamSx3("F2_DOC")[1] + 1	,tamSx3("F2_SERIE")[1])
//	else
		cOriF1Serie	:= Subs(aSZ5[11],FWSizeFilial()+tamSx3("F1_DOC")[1]+1,tamSx3("F1_SERIE")[1])
		cOriFiNum	:= Subs(aSZ5[11],FWSizeFilial()+1,tamSx3("F1_DOC")[1])
//	Endif
	If SD2->(DbSeek(cD2Chave))
		While SD2->(!Eof()) .AND. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == cD2Chave
			aLine := {}
			cNFItem := soma1(cNFItem)
			If cTipo == "B"
				cTes := MaTesInt(1,aSZ5[12],aSZ5[14],aSZ5[15],"C",SD2->D2_COD)  
			Else
				cTes := MaTesInt(1,aSZ5[12],aSZ5[2],aSZ5[3],"F",SD2->D2_COD)  
			Endif				
			If Empty(cTes)
				cMsg := "Pelas regras cadastradas de 'TES inteligente', não foi encontrado 'TES' para os dados abaixo: "+CRLF+;
				"Tipo de Operação: "+aSZ5[12]+CRLF+;
				IIf(cTipo=="B","Cliente: "+aSZ5[14],"Fornecedor: "+aSZ5[2])+CRLF+;
				IIf(cTipo=="B","Loja: "+aSZ5[15],"Loja: "+aSZ5[3])+CRLF+;
				"Produto: "+SD2->D2_COD
				if !_lJob
					APMsgStop(cMsg)
				Else
					ConOut(cMsg)
				Endif		

				Return()
			Endif	

			aadd(aLine, {'D1_COD'  	, SD2->D2_COD							, NIL})
			//aadd(aLine, {'D1_ITEM' 	, cNFItem							, NIL})
			aadd(aLine, {'D1_ITEM' 	, SD2->D2_ITEM							, NIL})
			aadd(aLine, {'D1_QUANT' , SD2->D2_QUANT							, NIL})
			aadd(aLine, {'D1_VUNIT' , SD2->D2_PRCVEN 						, NIL})
			aadd(aLine, {'D1_TOTAL' , SD2->D2_TOTAL  						, NIL})
			aadd(aLine, {'D1_LOCAL' , aSZ5[1]								, NIL})

			If SD1->( FieldPos('D1_ZTES') ) > 0
				aadd(aLine, {'D1_ZTES' 	, cTes/*aSZ5[12]*/					, ".T."})
			EndIf

			If !Empty( SD2->D2_LOTECTL )
				aadd(aLine, {'D1_LOTECTL' , SD2->D2_LOTECTL  							, NIL})
				aadd(aLine, {'D1_DTVALID' , SD2->D2_DTVALID  							, NIL})
			EndIf

			if SC5->C5_ZTPTRAN == "3" .OR. SC5->C5_ZTPTRAN == "4"
				cOriF1Item := SD2->D2_ITEM
				If SC5->C5_ZTPTRAN == "4"
					cIdentB6 := IdentB6(aSZ5,SD2->D2_SERIORI,SD2->D2_NFORI,SD2->D2_COD)//cOriF1Serie,cOriFiNum)
				else
					cIdentB6 := IdentB6(aSZ5,SD2->D2_SERIE,SD2->D2_DOC,SD2->D2_COD)//cOriF1Serie,cOriFiNum)
				endif

				If Empty(cIdentB6)
					cMsg := "Não foi possível consultar o identificador do poder de terceiro. Verifique se há saldo em poder de terceiro para esta nota de saída."
					if !_lJob
						APMsgStop(cMsg)
					Else
						ConOut(cMsg)
					Endif		

					Return()
				Endif

				if SC5->C5_ZTPTRAN == "4"
					aadd(aLine, {'D1_NFORI' 	, SD2->D2_NFORI					, NIL})
					aadd(aLine, {'D1_SERIORI' 	, SD2->D2_SERIORI				, NIL})
					aadd(aLine, {'D1_ITEMORI' 	, SD2->D2_ITEMORI				, NIL})
					aadd(aLine, {'D1_IDENTB6' 	, cIdentB6						, NIL})
				endif
			endif

			aadd(aLine, {'D1_OPER' 	, cOperD1		, NIL})

			aadd(aSD1, aLine)
			SD2->(DbSkip())
		EndDo
	EndIf

	DBSelectArea("SF2")
	SF2->(DBSetOrder(1))
	SF2->(DBGoTop())

	if SF2->( DBSeek( cD2Chave ) )
		aadd(aSF1, {'F1_DOC'  	, cF1Num	   		, NIL})
		aadd(aSF1, {'F1_SERIE' 	, cF1Serie	   		, NIL})
		aadd(aSF1, {'F1_EMISSAO', SF2->F2_EMISSAO	, NIL})
		aadd(aSF1, {'F1_ESPECIE', "SPED"			, NIL})

		If cTipo == "B"
			aadd(aSF1, {'F1_FORNECE', aSZ5[14] 		, NIL})
			aadd(aSF1, {'F1_LOJA'	, aSZ5[15]		, NIL})
		Else
			aadd(aSF1, {'F1_FORNECE', aSZ5[2] 		, NIL})
			aadd(aSF1, {'F1_LOJA'	, aSZ5[3]		, NIL})
		Endif

		aadd(aSF1, {'F1_TIPO'	, cTipo				, NIL})
		//aadd(aSF1, {'F1_CHVNFE'	, cChaveNFS			, NIL})
		aadd(aSF1, {'F1_CHVNFE'	, SF2->F2_CHVNFE	, NIL})

		aadd(aSF1, {'F1_TPFRETE', SF2->F2_TPFRETE	, NIL})
		aadd(aSF1, {'F1_TRANSP'	, SF2->F2_TRANSP	, NIL})

		lMsErroAuto := .F.

		MsExecAuto({|x,y,z| MATA140(x,y,z)}, aSF1, aSD1, 3)

		if lMsErroAuto

			aErro := GetAutoGRLog() // Retorna erro em array
			cErro := ""
			
			for nI := 1 to len(aErro)
				cErro += aErro[nI] + CRLF
			next nI
			
			if !_lJob // isBlind()
				APMsgStop("Erro - Inclusao da Pré-Nota Entrada"+CRLF+;
				cErro)
			Else
				ConOut(	"Erro - Inclusao do Pré-Nota Entrada: "+ cErro)
			endif
		else
			if !_lJob //isBlind()
				//oSay:cCaption := ("Pré-Nota de Entrada gerada!")
				APMsgInfo("Pré-Nota de Entrada " + allTrim( SF1->F1_DOC ) + " gerada!")
			Else
				ConOut(	"Pré-Nota de Entrada gerada!" )
			endif

			// SALVA CHAVE SF1 -> F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
			//u_updateSZ5(cSZ5Num, 3, xFilial("SF1") + aSF1[1, 2] + aSF1[2, 2] + aSF1[4, 2] + aSF1[7, 2] + aSF1[6, 2])
			u_updateSZ5( cSZ5Num, 3, SF1->( F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA + F1_TIPO ) )
		endif
	else
		msgAlert("Não encontrada Nota de Saída")
	endif

	restArea(aAreaSF2)
Endif

if lChgEnv
	//RESET ENVIRONMENT
	//PREPARE ENVIRONMENT EMPRESA cBkpEmp FILIAL cBkpFil
	cEmpAnt := cBkpEmp
	cFilAnt := cBkpFil
endif

restArea(aAreaSC9)
restArea(aArea)
return


Static Function IdentB6(aSZ5,cOriF1Serie,cOriFiNum,cCodPro)

Local aArea := {GetArea()}
Local cAliasTrb := GetNextAlias()
Local cQ := ""
Local cRet := ""
local aAreaSF2 := SF2->(getArea())

DBSelectArea("SF2")
SF2->(DBSetOrder(1))
SF2->(DBGoTop())

if SF2->( DBSeek( SD2->( D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA  ) ) )

	If SC5->C5_ZTPTRAN == "3" // Remessa
		cQ := "SELECT B6_IDENT "
		cQ += "FROM " + RetSqlName("SB6") + " SB6 "
		cQ += "WHERE SB6.D_E_L_E_T_ =	' ' "
		cQ += "AND B6_FILIAL		=	'" + aSZ5[13]		+ "' "
	
		if SF2->F2_TIPO == "B"
			cQ += "AND B6_CLIFOR		=	'" + aSZ5[16]		+ "' "
			cQ += "AND B6_LOJA			=	'" + aSZ5[17]		+ "' "
			cQ += "AND B6_TPCF			=	'F' "
		else
			cQ += "AND B6_CLIFOR		=	'" + aSZ5[9]		+ "' "
			cQ += "AND B6_LOJA			=	'" + aSZ5[10]		+ "' "
			cQ += "AND B6_TPCF			=	'C' "
		endif
	
		cQ += "AND B6_PRODUTO		=	'" + cCodPro		+ "' "
		cQ += "AND B6_DOC			=	'" + cOriFiNum		+ "' "
		cQ += "AND B6_SERIE			=	'" + cOriF1Serie	+ "' "
		cQ += "AND B6_TIPO			=	'E' "
		cQ += "AND B6_SALDO			>	0 "
		cQ += "AND B6_PODER3		=	'R' "
		cQ += "AND B6_ATEND			<>	'S' "
	elseif SC5->C5_ZTPTRAN == "4" // Retorno
		cQ := "SELECT B6_IDENT "
		cQ += "FROM " + RetSqlName("SB6") + " SB6 "
		cQ += "WHERE SB6.D_E_L_E_T_	=	' ' "
		cQ += "AND B6_FILIAL		=	'" + aSZ5[4]		+ "' "
		cQ += "AND B6_PRODUTO		=	'" + cCodPro		+ "' "
		cQ += "AND B6_DOC			=	'" + cOriFiNum		+ "' "
		cQ += "AND B6_SERIE			=	'" + cOriF1Serie	+ "' "
		cQ += "AND B6_TIPO			=	'E' "

		if SF2->F2_TIPO == "B"
			cQ += "AND B6_CLIFOR		=	'" + aSZ5[2]		+ "' "
			cQ += "AND B6_LOJA			=	'" + aSZ5[3]		+ "' "
			cQ += "AND B6_TPCF			=	'F' "
		else
			/*
			cQ += "AND B6_CLIFOR		=	'" + aSZ5[14]		+ "' "
			cQ += "AND B6_LOJA			=	'" + aSZ5[15]		+ "' "
			cQ += "AND B6_TPCF			=	'C' "
			*/
			cQ += "AND B6_CLIFOR		=	'" + aSZ5[2]		+ "' "
			cQ += "AND B6_LOJA			=	'" + aSZ5[3]		+ "' "
			cQ += "AND B6_TPCF			=	'F' "
		endif

		cQ += "AND B6_SALDO			>	0 "
		cQ += "AND B6_PODER3		=	'R' "
		cQ += "AND B6_ATEND			<>	'S' "
	else
		cQ := "SELECT B6_IDENT "
		cQ += "FROM " + RetSqlName("SB6") + " SB6 "
		cQ += "WHERE SB6.D_E_L_E_T_	=	' ' "
		cQ += "AND B6_FILIAL		=	'" + aSZ5[4]		+ "' "
		cQ += "AND B6_CLIFOR		=	'" + aSZ5[14]		+ "' "
		cQ += "AND B6_LOJA			=	'" + aSZ5[15]		+ "' "
		cQ += "AND B6_PRODUTO		=	'" + cCodPro		+ "' "
		cQ += "AND B6_DOC			=	'" + cOriFiNum		+ "' "
		cQ += "AND B6_SERIE			=	'" + cOriF1Serie	+ "' "
		cQ += "AND B6_TIPO			=	'E' "
		cQ += "AND B6_TPCF			=	'C' "
		cQ += "AND B6_SALDO			>	0 "
		cQ += "AND B6_PODER3		=	'R' "
		cQ += "AND B6_ATEND			<>	'S' "
	endif
	
	cQ := ChangeQuery(cQ)
	MemoWrite( "C:\TEMP\MGFEST17.SQL",cQ )
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)
	
	If (cAliasTrb)->(!Eof())
		cRet := (cAliasTrb)->B6_IDENT
	Endif
	
	(cAliasTrb)->(dbCloseArea())
else
	msgAlert("Não encontrada Nota de Saída")
endif

restArea(aAreaSF2)
aEval(aArea,{|x| RestArea(x)})

Return(cRet)
