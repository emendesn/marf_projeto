#INCLUDE 'PROTHEUS.CH'
#include "TOPCONN.CH"

#define CRLF chr(13) + chr(10)

//-----------------------------------------------------------------------------------
/*/{Protheus.doc}MGFINT02 
Execução de importação Protheus x RH Evolution
@author  Atilio Amarilla
@since 19/08/2016
*/
User Function MGFINT02( cTpInt , aDados )

	Local aCampos	:= {}
	Local aRetDados	:= {}
	Local _alista   := {}
	Local aTables	:= { "SA1" , "SA2" , "SM0" , "SE2" , "SED" }
	Default cTpint := "C"

	U_MFCONOUT("Inicializando integração de RH Evolution - Protheus...")


	RPCSetType( 3 )
	RpcSetEnv( "01" , "010001" , Nil, Nil, "FIN", Nil, aTables )

	ZH3->(Dbgotop())

	If 		cTpInt	== "C"	// Colaborador

			U_MFCONOUT("Carregando cadastros pendentes...")	
			_alista := MGFINT02Z3() //Carrega integrações pendentes
			
			For _nni := 1 to len(_alista)

				aRetDados := {}
				U_MFCONOUT("Integrando cadastro " + strzero(_nni,6) + " de " +  strzero(len(_alista),6) + "...")	
				MGFINT02CL( _alista[_nni] , @aRetDados )

				
				ZH3->(Dbgoto(_alista[_nni][42]))

				_ccliente := ""
				_clojac := ""
				_cfornece := ""
				_clojaf := ""

				SA2->(DbSetOrder(3))	// A2_FILIAL+A2_CGC
				SA2->(DbGoTop())

				If SA2->( dbSeek( xFilial("SA2") + alltrim(ZH3->ZH3_CNPJ) ) )
					_cfornece := SA2->A2_COD
					_clojaf := SA2->A2_LOJA
				Endif

				SA1->(DbSetOrder(3))	// A1_FILIAL+A1_CGC
				SA1->(DbGoTop())

				If SA1->( dbSeek( xFilial("SA1") + alltrim(ZH3->ZH3_CNPJ) ) )
					_ccliente := SA1->A1_COD
					_clojac := SA1->A1_LOJA
				Endif
				
				Reclock("ZH3",.F.)
				
				ZH3->ZH3_STATUS := IIF(ARETDADOS[3][1]=="S","3","4")
				ZH3->ZH3_DTPROC := dtoc(DATE())
				ZH3->ZH3_HRPROC := TIME()
				ZH3->ZH3_CLIENT := _ccliente
				ZH3->ZH3_LOJAC  := _clojac
				ZH3->ZH3_FORNEC := _cfornece
				ZH3->ZH3_LOJAF  := _clojac
				ZH3->ZH3_RESULT := ARETDADOS[6][1]

				ZH3->(Msunlock())


			Next

			U_MFCONOUT("Completou integração de cadastros pendentes...")	

	ElseIf 	cTpInt	== "P"	// Titulos a Pagar
			MGFINT02PG( aDados , @aRetDados )
	EndIf

Return aRetDados

//-----------------------------------------------------------------------------------
/*/{Protheus.doc}MGFINT02Z3 
Le registros pendentes da tabela intermediaria
@author  Atilio Amarilla
@since 19/08/2016
*/
Static Function MGFINT02Z3()

Local _alista := {}
Local cAliasTRB := GetNextAlias()
Local cQuery

cQuery := "SELECT R_E_C_N_O_ REC "+CRLF
cQuery += "FROM "+RetSqlName("ZH3")+" ZH3 "+CRLF
cQuery += "WHERE ZH3.D_E_L_E_T_ = ' ' "+CRLF
cQuery += "	AND ZH3_STATUS = ' ' "

If select(cAliasTRB) > 0
	cAliasTRB->(Dbclosearea())
Endif

DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasTRB, .T., .F. )

Do while (cAliasTRB)->(!Eof())

	ZH3->(Dbgoto((cAliasTRB)->REC))

	aadd( _alista, {	alltrim(ZH3->ZH3_OPER)			,; //01
						alltrim(ZH3->ZH3_TIPO)			,; //02
						alltrim(ZH3->ZH3_CNPJ)			,; //03
						alltrim(ZH3->ZH3_IE)			,; //04
						alltrim(ZH3->ZH3_IM)			,; //05
						alltrim(ZH3->ZH3_NOME)			,; //06
						alltrim(ZH3->ZH3_NREDUZ)		,; //07
						alltrim(ZH3->ZH3_CONTAT)		,; //08
						alltrim(ZH3->ZH3_ENDERE)		,; //09
						alltrim(ZH3->ZH3_BAIRRO)		,; //10
						alltrim(ZH3->ZH3_CODMUN)		,; //11
						alltrim(ZH3->ZH3_CEP)			,; //12
						alltrim(ZH3->ZH3_TELEFO)		,; //13
						alltrim(ZH3->ZH3_FAX)			,; //14
						alltrim(ZH3->ZH3_MICROE)		,; //15
						alltrim(ZH3->ZH3_DATAME)		,; //16
						alltrim(ZH3->ZH3_EMAIL)			,; //17
						alltrim(ZH3->ZH3_ORIGEM)		,; //18
						alltrim(ZH3->ZH3_OBS)			,; //19
						alltrim(ZH3->ZH3_ESTADO)		,; //20
						alltrim(ZH3->ZH3_CCUSTO)		,; //21
						alltrim(ZH3->ZH3_DTNASC)		,; //22
						alltrim(ZH3->ZH3_CODMGF)		,; //23
						alltrim(ZH3->ZH3_CONTDE) 		,; //24
						alltrim(ZH3->ZH3_PAISBC)		,; //25
						alltrim(ZH3->ZH3_GRPTRI)		,; //26
						alltrim(ZH3->ZH3_CONTCL)		,; //27
						alltrim(ZH3->ZH3_GRPTRC)		,; //28
						alltrim(ZH3->ZH3_NATCLI)		,; //29
						alltrim(ZH3->ZH3_NATFOR)		,; //30
						alltrim(ZH3->ZH3_PAIS)			,; //31
						alltrim(ZH3->ZH3_COMP)			,; //32
						alltrim(ZH3->ZH3_DDD)			,; //33
						alltrim(ZH3->ZH3_DDI)			,; //34
						alltrim(ZH3->ZH3_CFILIA)		,; //35
						alltrim(ZH3->ZH3_NACION)		,; //36
						alltrim(ZH3->ZH3_SETOR)			,; //37
						alltrim(ZH3->ZH3_DSETOR) 		,; //38
						alltrim(ZH3->ZH3_UNIDAD)		,; //39
						alltrim(ZH3->ZH3_DTADMI)		,; //40
						alltrim(ZH3->ZH3_DTDEMI)		,; //41
						ZH3->(Recno())		} ) //42
	
	(cAliasTRB)->(Dbskip())

Enddo


Return _alista

//-----------------------------------------------------------------------------------
/*/{Protheus.doc}MGFINT02CL 
Criação de cliente e fornecedor
@author  Atilio Amarilla
@since 19/08/2016
*/

Static Function MGFINT02CL( aDados , aRetDados )

	Local ColabOper		:= aDados[01]
	Local ColabTipo		:= aDados[02]
	Local ColabCNPJ		:= aDados[03]
	Local ColabInscEst	:= aDados[04]
	Local ColabInscMun	:= aDados[05]
	Local ColabNome		:= aDados[06]
	Local ColabNReduz	:= aDados[07]
	Local ColabContato	:= aDados[08]
	Local ColabEndereco	:= aDados[09]
	Local ColabBairro	:= aDados[10]
	Local ColabCodMun	:= aDados[11]
	Local ColabCEP		:= aDados[12]
	Local ColabTelefone	:= aDados[13]
	Local ColabFax		:= aDados[14]
	Local ColabMicroEmp	:= aDados[15]
	Local ColabDataME	:= aDados[16]
	Local ColabEmail	:= aDados[17]
	Local ColabOrigem	:= aDados[18]
	Local ColabObs		:= aDados[19]
	Local ColabEst		:= aDados[20]
	Local ColabCCusto	:= aDados[21]
	Local ColabDTNasc	:= aDados[22]
	Local ColabZCodMGF  := aDados[23]
	Local ColabContDeb	:= aDados[24]
	Local ColabPaisBC	:= aDados[25]
	Local ColabGrpTrib	:= aDados[26]
	Local ColabContCli	:= aDados[27]
	Local ColabGTrbCli	:= aDados[28]
	Local ColabNatCli	:= aDados[29]
	Local ColabNatFor	:= aDados[30]
	Local ColabPais		:= aDados[31]
	Local ColabComp		:= aDados[32]
	Local ColabDDD		:= aDados[33]
	Local ColabDDI		:= aDados[34]
	Local ColabFilial	:= aDados[35]
	Local ColabNacion	:= aDados[36]

	Local ColabSetor    := aDados[37]
	Local ColabDescSet  := aDados[38]
	Local ColabUnidade  := aDados[39]
	Local ColabDtAdmiss := aDados[40]
	Local ColabDtDemiss := aDados[41]
	Local ColabDescUnid := substr(alltrim(FWFilialName(cEmpAnt,ColabUnidade,2)),1,45)

	Local cPaisNacio
	Local ColabFCnae	:= "0000-0/02"
	Local ColabCCnae	:= "0000-0/01"
	Local ColabPropri	:= "01"

	Local cValForne		:= "S" 
	Local lFilExst		:= FWFilExist( cEmpAnt, ColabFilial )

	Local cSA1GrpTrib	:= Alltrim(GetNewPar("MGF_INT02L","CNC"	))
	Local cSA1Contrib	:= Alltrim(GetNewPar("MGF_INT02M","2"	))
	Local cCondPagSA1	:= Alltrim(GetNewPar("MGF_INT02N","011"	))
	Local nLimCredSA1	:= GetNewPar("MGF_INT02O",700)
	Local czBoletoSA1	:= Alltrim(GetNewPar("MGF_INT02P","S"	))
	Local cGrpTribSA2	:= Alltrim(GetNewPar("MGF_INT02Q","FFI"	))
	Local cContribSA2	:= Alltrim(GetNewPar("MGF_INT02R","2"	))

	Local aMatA020	:= {} // Array para execauto. Fornecedores
	Local aMatA030	:= {} // Array para execauto. Cliente
	Local cCodCli	:= cCodFor	:= cLojCli := cLojFor := ""
	Local cStatus	:= "S"
	Local cObserv	:=	""

	Local lCodBen
	Local nOpc 		:= IIF( ColabOper == "I" , 3 , IIF( ColabOper $ "A/B" , 4 , 5 ) )

	Local nContador := 0
	Local cDocori	:= Alltrim(ColabCNPJ)
	Local nRecnoDoc := 0
	Local dDatIni	:= Date()
	Local cHorIni	:= Time()
	Local cHorOrd
	Local aErro		:= {}, cErro := "", cArqLog := ""
	Local aCampos 	:= {}
	Local aCamposSA1:= {}
	Local aCamposSA2:= {}

	Local aLogSA1	:= {}
	Local aLogSA2	:= {}

	Local nAte      := 0
	Local cNome     := ""
	Local nAchei    := 1
	Local aErrRet   := {}
	Local nJK       := 1
	Local aObrig_SA1:= {}
	Local aObrig_SA2:= {}
	Local nRecGRVSA1:= 0
	Local lExec     := .T. 
	Local cUnit  	:= AllTrim( SuperGetMv( "MGF_INT39E" , , "010001/010065/010041/010039/010042/010045/020003/010069/010068/010070/010067" ) ) 
	Local cFrase    := ""

	Local cDia      := ""
	Local cMes      := ""
	Local cAno      := ""
	Local dData     := CtoD(Space(08))
	
	Private lMsErroAuto    := .F. //necessario a criacao, pois sera //atualizado quando houver
	Private lAutoErrNoFile := .T.
	Private lMsHelpAuto    := .F.
	Private l030Auto       := .T.

	//Relação de Campos WebService - Controle para campos Obrigatorios
	//
	//                  variavel        conteudo         SA1           SA2      OBRIG.SA1/SA2  Dados: 1=SA1, 2=SA2, 3=Ambos
	//
	aadd( aCampos,  {  "ColabOper",	    ColabOper,  	"noCAMPO",    "noCAMPO",		0,	0,	0   ,"Operacao " }  )
	aadd( aCampos,  {  "ColabTipo",     ColabTipo,		"A1_TIPO",    "A2_TIPO",		0,	0,	0   ,"Tipo " }  )
	aadd( aCampos,  {  "ColabCNPJ",     ColabCNPJ,		"A1_CGC",     "A2_CGC",			0,	0,	3   ,"CNPJ " }  )
	aadd( aCampos,  {  "ColabInscEst",  ColabInscEst,	"A1_INSCR",   "A2_INSCR",		0,	0,	3   ,"Inscricao Estadual " }  )
	aadd( aCampos,  {  "ColabInscMun",  ColabInscMun,	"A1_INSCRM",  "A2_INSCRM",		0,	0,	3   ,"Inscricao Municipal " }  )
	aadd( aCampos,  {  "ColabNome",     ColabNome,		"A1_NOME",    "A2_NOME",		0,	0,	3	,"Nome " }  )
	aadd( aCampos,  {  "ColabNReduz",   ColabNReduz,	"A1_NREDUZ",  "A2_NREDUZ",		0,	0,	3	,"Nome reduzido " }  )
	aadd( aCampos,  {  "ColabContato",  ColabContato,	"A1_CONTATO", "A2_CONTATO",		0,	0,	3	,"Contato " }  )
	aadd( aCampos,  {  "ColabEndereco", ColabEndereco,	"A1_END", 	  "A2_END",			0,	0,	3	,"Endereco " }  )
	aadd( aCampos,  {  "ColabBairro",   ColabBairro,	"A1_BAIRRO",  "A2_BAIRRO",		0,	0,	3   ,"Bairro " }  )
	aadd( aCampos,  {  "ColabCodMun",   ColabCodMun,	"A1_COD_MUN", "A2_COD_MUN",		0,	0,	3	,"Cod. Municipio " }  )
	aadd( aCampos,  {  "ColabCEP",      ColabCEP,		"A1_CEP",     "A2_CEP",			0,	0,	3	,"CEP " }  )
	aadd( aCampos,  {  "ColabTelefone", ColabTelefone,	"A1_TEL",     "A2_TEL",			0,	0,	3	,"Telefone " }  )
	aadd( aCampos,  {  "ColabFax",      ColabFax,		"A1_FAX",     "A2_FAX",			0,	0,	3	,"Fax " }  )
	aadd( aCampos,  {  "ColabMicroEmp", ColabMicroEmp,	"noCAMPO",    "noCAMPO",		0,	0,	0	,"Micro Empresa "}  )
	aadd( aCampos,  {  "ColabDataME",   ColabDataME,	"noCAMPO",    "noCAMPO",		0,	0,	0	,"Data ME "}  )
	aadd( aCampos,  {  "ColabEmail",    ColabEmail,		"A1_EMAIL",   "A2_EMAIL",		0,	0,	3	,"Email "}  )
	aadd( aCampos,  {  "ColabOrigem",   ColabOrigem,	"noCAMPO",    "noCAMPO",		0,	0,	0	,"Colab. Origem "}  )
	aadd( aCampos,  {  "ColabObs",      ColabObs,		"A1_OBSERV",  "A2_ZOBSERV",		0,	0,	3	,"Observacao "}  )
	aadd( aCampos,  {  "ColabEst",      ColabEst,		"A1_EST",     "A2_EST",			0,	0,	3	,"Estado "}  )
	aadd( aCampos,  {  "ColabCCusto",   ColabCCusto,	"noCAMPO",    "A2_ZCCD",		0,	0,	2	,"Centro de Custo "}  )

	aadd( aCampos,  {  "ColabDTNasc",   ColabDTNasc,	"A1_DTNASC",  "A2_DTNASC",		0,	0,	3	,"Data Nacimento "}  )
	aadd( aCampos,  {  "ColabDTNasc",   ColabDTNasc,	"noCAMPO",	  "A2_ZDTNASC",		0,	0,	3	,"Fax "}  )

	aadd( aCampos,  {  "ColabZCodMGF",  ColabZCodMGF,	"A1_ZCODMGF", "A2_ZCODMGF",		0,	0,	3	,"Cod. MGF "}  )
	aadd( aCampos,  {  "ColabContDeb",  ColabContDeb,	"noCAMPO",    "A2_CONTA",		0,	0,	2	,"Conta Debito "}  )
	aadd( aCampos,  {  "ColabPaisBC",   ColabPaisBC,	"noCAMPO",    "A2_CODPAIS",		0,	0,	2	,"Codigo Pais "}  )

	aadd( aCampos,  {  "ColabGrpTrib",  ColabGrpTrib,	"noCAMPO",    "noCAMPO",		0,	0,	0	,"Grp. Tributacao Forn "}  )
	aadd( aCampos,  {  "ColabGrpTrib",  cGrpTribSA2,	"noCAMPO",    "A2_GRPTRIB",		0,	0,	2	,"Grp. Tributacao Forn"}  )

	aadd( aCampos,  {  "ColabContCli",  ColabContCli,	"A1_CONTA",   "noCAMPO",		0,	0,	1	,"Conta Contabil "}  )

	aadd( aCampos,  {  "ColabGTrbCli",  ColabGTrbCli,	"noCAMPO",	  "noCAMPO",		0,	0,	0	,"Grp. Tributacao Clie "}  )
	aadd( aCampos,  {  "ColabGTrbCli",  cSA1GrpTrib,	"A1_GRPTRIB", "noCAMPO",		0,	0,	1	,"Grp. Tributacao Clie "}  )

	aadd( aCampos,  {  "ColabNatCli",   ColabNatCli,	"A1_NATUREZ", "noCAMPO",		0,	0,	1	,"Natureza Clie "}  )
	aadd( aCampos,  {  "ColabNatFor",   ColabNatFor,	"noCAMPO",    "A2_NATUREZ",		0,	0,	2	,"Natureza Forn "}  )
	aadd( aCampos,  {  "ColabPais",     ColabPais,		"A1_PAIS",    "A2_PAIS",		0,	0,	3	,"Pais "}  )
	aadd( aCampos,  {  "ColabComp",     ColabComp,		"A1_COMPLEM", "A2_COMPLEM",		0,	0,	3	,"Complemento "}  )
	aadd( aCampos,  {  "ColabDDD",      ColabDDD,		"A1_DDD",     "A2_DDD",			0,	0,	3	,"DDD "}  )
	aadd( aCampos,  {  "ColabDDI",      ColabDDI,		"A1_DDI",     "A2_DDI",			0,	0,	3	,"DDI "}  )

	aadd( aCampos,  {  "ColabFilial",   ColabFilial,	"A1_ZCFIL",   "noCAMPO",		0,	0,	1	,"Filial "}  )
	aadd( aCampos,  {  "ColabFilial",   ColabFilial,	"A1_FILIAL",  "A2_FILIAL",		0,	0,	1	,"Filial "}  )

	aadd( aCampos,  {  "ColabNacion",   ColabNacion,	"noCAMPO",    "noCAMPO",		0,	0,	0	,"Nacionalidade "}  )

	aadd( aCampos,  {  "ColabFCnae",    ColabFCnae,		"noCAMPO",    "A2_CNAE",		0,	0,	2	,"CNAE Clie "}  )  // Fixo "0000-0/02"
	aadd( aCampos,  {  "ColabCCnae",    ColabCCnae,		"A1_CNAE",    "noCAMPO",		0,	0,	1	,"CNAE Forn "}  )  // Fixo "0000-0/01"

	aadd( aCampos,  {  "ColabSetor"  	, ColabSetor	,"A1_ZSETFUN", "A2_ZSETFUN",	0,	0,	3	,"Setor "}  )
	aadd( aCampos,  {  "ColabDescSet"	, ColabDescSet	,"A1_ZDSCFUN", "A2_ZDSCFUN",	0,	0,	3	,"Descricao "}  )
	aadd( aCampos,  {  "ColabUnidade"	, ColabUnidade	,"A1_ZUNFUNC", "A2_ZUNFUNC",	0,	0,	3	,"Unidade "}  )
	aadd( aCampos,  {  "ColabDescUnid"	, ColabDescUnid	,"A1_ZUNDFUN", "A2_ZUNDFUN",	0,	0,	3	,"Descricao "}  )
	aadd( aCampos,  {  "ColabDtAdmiss"	, ColabDtAdmiss	,"A1_ZDTAFUN", "A2_ZDTAFUN",	0,	0,	3	,"Dt. Admissao "}  )
	aadd( aCampos,  {  "ColabDtDemiss"	, ColabDtDemiss	,"A1_ZDTDFUN", "A2_ZDTDFUN",	0,	0,	3	,"Dt. Demissao "}  )
	
	aadd( aCampos,  {  "semEntrada",    "TRATAMENTO",	"A1_COD",     "A2_COD",		    0,	0,	3	,"Codigo "}  )  // Fixo "0000-0/01"
	aadd( aCampos,  {  "semEntrada",    "FIXO_01",		"A1_LOJA",    "A2_LOJA",		0,	0,	3	,"Loja "}  )  // Fixo "0000-0/01"
	aadd( aCampos,  {  "semEntrada",    "TRATAMENTO",	"A1_MUN",     "A2_MUN",	        0,	0,	3	,"Nome Municipio "}  )  // Fixo "0000-0/01"
	aadd( aCampos,  {  "semEntrada",    "FIXO_PF",		"noCAMPO",    "A2_TPESSOA",	    0,	0,	2	,"Tp. Pessoa "}  )  // Fixo "0000-0/01"
	aadd( aCampos,  {  "semEntrada",    "TRATAMENTO",	"noCAMPO",    "A2_ZNASCIO",	    0,	0,	2	,"Nascionalidade "}  )


	lCodBen	:= GetNewPar("MGF_INT02A",.T.)	// Criação de Código diferenciado por tipo de colaborador:
	//	- Funcionário: F00001, F00002,...
	//  - Beneficiario: B00001, B00002,...
	//  - Empresa: E00001, E00002,...

	U_MFCONOUT("== Integracao RH Evolution - Colaborador ==")

	/*
	ColabTipo
	B - Beneficiário - Fornecedor – pensão judicial / pensão alimentícia;
	F - Funcionário	 - Fornecedor e Cliente
	E - Empresa 	 - Fornecedor
	*/

	ColabCNPJ	:= Stuff( Space( TamSX3("A1_CGC")[1] ) 		, 1 , Len(AllTrim(ColabCNPJ)) , Alltrim(ColabCNPJ) )
	ColabNatCli	:= Stuff( Space( TamSX3("A1_NATUREZ")[1] ) 	, 1 , Len(AllTrim(ColabNatCli)) , Alltrim(ColabNatCli) )
	ColabNatFor	:= Stuff( Space( TamSX3("A2_NATUREZ")[1] ) 	, 1 , Len(AllTrim(ColabNatFor)) , Alltrim(ColabNatFor) )

	If Empty(ColabOper) .Or. !ColabOper $ "I/A/B/E" // Inclusão / Alteração / Bloqueio / Exclusão
		cStatus	:= "N"
		cObserv	:=	"["+ColabOper+"] OPERACAO INVALIDA."
	EndIf

	If cStatus == "S" .And. (Empty(ColabTipo) .Or. !ColabTipo $ "F/B/E") // Funcionário / Beneficiário / Empresa
		cStatus	:= "N"
		cObserv	:=	"["+ColabTipo+"] TIPO DE COLABORADOR INVALIDO."
	EndIf

	If cStatus == "S" .And. ( (Empty(ColabNatCli).And.ColabTipo $ "F/") .Or. Empty(ColabNatFor) ) // Funcionário / Beneficiário / Empresa
		cStatus	:= "N"
		If (Empty(ColabNatCli).And.ColabTipo $ "F/")
			cObserv	:=	"["+AllTrim(ColabNatCli)+"] NATUREZA DO CLIENTE INVALIDA."
		EndIf
		If Empty(ColabNatFor)
			cObserv	:=	IIF(!Empty(cObserv),cObserv+CRLF,"")+"["+AllTrim(ColabNatFor)+"] NATUREZA DO FORNECEDOR INVALIDA."
		EndIf
	ElseIf cStatus == "S"
		If Empty( GetAdvFVal("SED","ED_CODIGO",xFilial("SED")+ColabNatCli,1,"") ) .And.ColabTipo $ "F/"
			cStatus	:= "N"
			cObserv	:=	"["+AllTrim(ColabNatCli)+"] NATUREZA DO CLIENTE INVALIDA."
		EndIf
		If Empty(GetAdvFVal("SED","ED_CODIGO",xFilial("SED")+ColabNatFor,1,""))
			cStatus	:= "N"
			cObserv	:=	IIF(!Empty(cObserv),cObserv+CRLF,"")+"["+AllTrim(ColabNatFor)+"] NATUREZA DO FORNECEDOR INVALIDA."
		EndIf
	EndIf

	If cStatus  == "S" .And.  ( Empty(ColabPais) .Or. Empty( GetAdvFVal("SYA","YA_CODGI",xFilial("SYA")+ColabPais,1,"") ))
		cStatus	:= "N"
		cObserv	:=	"["+AllTrim(ColabPais)+"] CODIGO DE PAIS INVALIDO."
	EndIf

	If cStatus == "S"
		If Empty(ColabFilial) .Or. lFilExst == .F. // Verifica se a Filial do Colaborador está vazia OU se existe no cadastro de Filial.
			cStatus	:= "N"
			cObserv	:=	"["+ColabFilial+"] FILIAL DO COLABORADOR INVALIDA."
		EndIf
	EndIf

	//Verifica se o codigo enviado é valido e  converte o código enviado pelo barramento pela descrição
	cPaisNacio := Posicione("SYA",1,xFilial("SYA")+Alltrim(ColabNacion),"YA_NASCIO")

	If cStatus == "S" .AND. Empty(cPaisNacio)
		cStatus	:= "N"
		cObserv	:= "["+AllTrim(ColabNacion)+"] CODIGO DE NACIONALIDADE INVALIDA."
	EndIf

	//Valida duplicidade de cliente e fornecedor
	SA1->(DbSetOrder(3))	// A1_FILIAL+A1_CGC
	SA2->(DbSetOrder(3))	// A2_FILIAL+A2_CGC
	
	_nnc := 0
	_nnf := 0

	If SA1->( dbSeek( xFilial("SA1") + ColabCNPJ ) )

		_nnc := 0

		Do while  alltrim(ColabCNPJ) == alltrim(SA1->A1_CGC)  
			_nnc++
			SA1->(Dbskip())
		Enddo
	
	Endif

	If SA2->( dbSeek( xFilial("SA2") + ColabCNPJ ) )

		_nnf := 0

		Do while  alltrim(ColabCNPJ) == alltrim(SA2->A2_CGC)  
			_nnf++
			SA2->(Dbskip())
		Enddo
	
	Endif

	If cstatus == "S" .and. (_nnc > 1 .or. _nnf > 1)
		cStatus	:= "N"
		cObserv	:= "["+AllTrim(ColabNacion)+"] Cadastro duplicado."
	Endif

	U_MFCONOUT(" - Atencao: Status = "+cStatus+If(!Empty(cObserv)," Observacao = "+cObserv,""),"")
	
	Begin Transaction
	BEGIN SEQUENCE

		If  cStatus == "S"

			If CGC(ColabCNPJ) .And. !SubStr(ColabCNPJ,1,9) $ "000000000/"+Space(09)

				If ColabTipo == "F" // Funcionário

					U_MFCONOUT("== Iniciou cadastro do Colaborador : "+AllTrim(ColabNome)+;
							   " CPF : "+Alltrim(ColabCNPJ))

					dbSelectArea("SA1")
					SA1->(DbSetOrder(3))	// A1_FILIAL+A1_CGC
					SA1->(DbGoTop())

					If SA1->( dbSeek( xFilial("SA1") + ColabCNPJ ) )

						cCodCli := SA1->A1_COD
						cLojCli := SA1->A1_LOJA

						If ColabOper == "I"	// Inclusão

							cStatus	:= "S"
							cObserv	:=	"[SA1]["+ColabOper+"] CLIENTE JA EXISTE."

							dbSelectArea("SA2")
							SA2->(DbSetOrder(3))	// A1_FILIAL+A1_CGC
							SA2->(DbGoTop())

							If SA2->( dbSeek( xFilial("SA2") + ColabCNPJ ) )
								cObserv   += CRLF + "[SA2]["+ColabOper+"] FORNECEDOR JA EXISTE."
								cCodFor   := SA2->A2_COD
								cLojFor   := SA2->A2_LOJA
								cValForne := "S" 
								ColabOper := "A"
							Else
								cObserv += CRLF + "[SA2]["+ColabOper+"] FORNECEDOR NAO EXISTE."
								cValForne := "S" 
							EndIf
						Endif

						If !Empty(cObserv)
   						   U_MFCONOUT(" Colaborador : "+AllTrim(ColabNome)+" CPF : "+Alltrim(ColabCNPJ)+;
							   		  " - Observacao = "+cObserv)
						EndIf

					Else
						//Como Alteração caso o Cliente não exista realiza a inclusão do mesmo
						If ColabOper $ "I|A"	// Inclusão/alteração
							cCodCli := GetSXENum("SA1","A1_COD")  //SA1->A1_COD
							nOpc := 3
						Else
							cStatus	:= "N"
							cObserv	:=	"[SA1]["+ColabOper+"] CLIENTE NAO EXISTE."
						Endif
					Endif

					aAdd( aMatA030 , { "A1_FILIAL",  xFILIAL("SA1")  , NIL } )
					aAdd( aMatA030 , { "A1_COD", 	 cCodCli  	     , NIL } )
					aAdd( aMatA030 , { "A1_LOJA", 	 "01"  	     	 , NIL } )
					aAdd( aMatA030 , { "A1_ZCODMGF", iif( Empty(ColabZCodMGF),SA1->A1_ZCODMGF,ColabZCodMGF) , NIL } )
					aAdd( aMatA030 , { "A1_MSBLQL",  iif(ColabOper == "B" ,"1" ,"2"), NIL } )
					aAdd( aMatA030 , { "A1_TIPO",	"F" , NIL } )
					aAdd( aMatA030 , { "A1_PESSOA", IIF(Len(AllTrim(ColabCNPJ))==14,"J","F") , NIL } )
					aAdd( aMatA030 , { "A1_CGC"	, iif( Empty(ColabCNPJ)  	 ,SA1->A1_CGC,   ColabCNPJ)		, NIL } )
					aAdd( aMatA030 , { "A1_INSCR", 	 iif( Empty(ColabInscEst) , iif( Empty(SA1->A1_INSCR),"ISENTO", SA1->A1_INSCR ),  ColabInscEst) , NIL } )
					aAdd( aMatA030 , { "A1_INSCRM",  iif( Empty(ColabInscMun) , SA1->A1_INSCRM, ColabInscMun) , NIL } )
					aAdd( aMatA030 , { "A1_NOME"	, iif( Empty(ColabNome)  ,SA1->A1_NOME,  ColabNome)	, NIL } )
					aAdd( aMatA030 , { "A1_NREDUZ"	, iif( Empty(ColabNReduz),SA1->A1_NREDUZ,  ColabNReduz)	, NIL } )
					aAdd( aMatA030 , { "A1_CONTATO"	, iif( Empty(ColabContato)  ,SA1->A1_CONTATO,ColabContato)	, NIL } )
					aAdd( aMatA030 , { "A1_END"		, iif( Empty(ColabEndereco),SA1->A1_END,  ColabEndereco), NIL } )
					aAdd( aMatA030 , { "A1_BAIRRO"	, iif( Empty(ColabBairro),SA1->A1_BAIRRO,ColabBairro)	, NIL } )
					aAdd( aMatA030 , { "A1_EST"		, iif( Empty(ColabEst)	 ,SA1->A1_EST,  ColabEst)		, NIL } )
					aAdd( aMatA030 , { "A1_COD_MUN"	, iif( Empty(ColabCodMun),SA1->A1_COD_MUN,  ColabCodMun) , NIL } )

					cMUNICIPIO := FwCutOFF( Trim( fDesc('CC2', ColabEst + ColabCodMun, 'CC2_MUN',, ColabFilial ) ), .T.)

					aAdd( aMatA030 , { "A1_MUN"		, iif( Empty(ColabCodMun),SA1->A1_MUN,  cMUNICIPIO) 	, NIL } )
					aAdd( aMatA030 , { "A1_CEP"		, iif( Empty(ColabCEP)	 ,SA1->A1_CEP,  ColabCEP)  		, NIL } )
					aAdd( aMatA030 , { "A1_TEL"		, iif( Empty(ColabTelefone),SA1->A1_TEL,  ColabTelefone) , NIL } )
					aAdd( aMatA030 , { "A1_FAX"		, iif( Empty(ColabFax)	 ,SA1->A1_FAX,  ColabFax)		, NIL } )
					aAdd( aMatA030 , { "A1_EMAIL"	, iif( Empty(ColabEmail) ,SA1->A1_EMAIL,ColabEmail) 	, NIL } )
					aAdd( aMatA030 , { "A1_OBSERV"	, iif( Empty(ColabObs) 	 ,SA1->A1_OBSERV,ColabObs)		, NIL } )
					aAdd( aMatA030 , { "A1_CONTA"	, iif( Empty(ColabContCli),SA1->A1_CONTA,ColabContCli) , NIL } )

					If !Empty( ColabDTNasc )
						aAdd( aMatA030 , { "A1_DTNASC"	, STOD(StrTran(ColabDTNasc,"-")) , NIL } )
					Else
						aAdd( aMatA030 , { "A1_DTNASC"	, IIF(Empty(SA1->A1_DTNASC), STOD("19800101"), SA1->A1_DTNASC), NIL } )
					EndIf

					If SA1->(FieldPos( "A1_ZTPRHE") ) > 0 //Valid se o campo existe
						aAdd( aMatA030 , { "A1_ZTPRHE"	, iif( Empty(ColabTipo) ,SA1->A1_ZTPRHE, ColabTipo)	, NIL } )
					EndIf

					aAdd( aMatA030 , { "A1_GRPTRIB", iif( Empty(cSA1GrpTrib),SA1->A1_GRPTRIB,cSA1GrpTrib) , NIL } )
					aAdd( aMatA030 , { "A1_CONTRIB", iif( Empty(cSA1Contrib),SA1->A1_CONTRIB,cSA1Contrib) , NIL } )
					aAdd( aMatA030 , { "A1_NATUREZ", iif( Empty(ColabNatCli),SA1->A1_NATUREZ,ColabNatCli) , NIL } )
					aAdd( aMatA030 , { "A1_PAIS"   , iif( Empty(ColabPais)  ,SA1->A1_PAIS,ColabPais)      , NIL } )
					aAdd( aMatA030 , { "A1_COMPLEM", iif( Empty(ColabComp)  ,SA1->A1_COMPLEM,ColabComp)   , NIL } )
					aAdd( aMatA030 , { "A1_DDD",     iif( Empty(ColabDDD)   ,iif( Empty(SA1->A1_DDD), "00", SA1->A1_DDD), ColabDDD)  	  , NIL } )
					aAdd( aMatA030 , { "A1_DDI"	,    iif( Empty(ColabDDI)   ,iif( Empty(SA1->A1_DDI), "55", SA1->A1_DDI), ColabDDI)  	  , NIL } )
					aAdd( aMatA030 , { "A1_ZCFIL",   iif( Empty(ColabFilial),SA1->A1_ZCFIL,ColabFilial)	  , NIL } )
					aAdd( aMatA030 , { "A1_CNAE",    iif( Empty(ColabCCnae) ,SA1->A1_CNAE,ColabCCnae)	  , NIL } )

					// Inclusão dos novos campos (a ser alterado para gravação em tabela específica)
					aAdd( aMatA030,{"A1_ZSETFUN",If(Empty(ColabSetor)	 , SA1->A1_ZSETFUN,ColabSetor)  		, NIL } )
					aAdd( aMatA030,{"A1_ZDSCFUN",If(Empty(ColabDescSet)	 , SA1->A1_ZDSCFUN,ColabDescSet)    	, NIL } )
					aAdd( aMatA030,{"A1_ZUNFUNC",If(Empty(ColabUnidade)	 , SA1->A1_ZUNFUNC,ColabUnidade)  	  	, NIL } )
					aAdd( aMatA030,{"A1_ZUNDFUN",If(Empty(ColabDescUnid) , SA1->A1_ZUNDFUN,ColabDescUnid)  	  	, NIL } )
					aAdd( aMatA030,{"A1_ZDTAFUN",If(Empty(ColabDtAdmiss) , SA1->A1_ZDTAFUN,StoD(ColabDtAdmiss)) , NIL } )

					//Se o conteudo do parametro estiver em branco
					If !Empty( cCondPagSA1 )
						aAdd( aMatA030 , { "A1_COND", cCondPagSA1 , NIL } )
					EndIf

					If !Empty( nLimCredSA1 )
						aAdd( aMatA030 , { "A1_LC", nLimCredSA1 , NIL } )
					EndIf

					If !Empty( czBoletoSA1 )
						aAdd( aMatA030 , { "A1_ZBOLETO", czBoletoSA1 , NIL } )
					EndIf

					// Regra para Definição da Data do Limite de Credito
					// Entre 01/01 e 30/06 - 31/12
					// Entre 01/07 e 31/12 - 30/06
                    If Empty(ColabDtDemiss)

						If  dDataBase <= cToD("30/06/" + Alltrim(str(Year(Date() ) )))
							aAdd( aMatA030 , { "A1_VENCLC", cToD("30/06/" + Alltrim(str(Year(Date()) + 1 )))   , NIL } )
						Else
							aAdd( aMatA030 , { "A1_VENCLC", cToD("31/12/" + Alltrim(str(Year(Date()) + 1 )))  , NIL } )
						Endif

					Else // Se o campo de Data de Demissão não estiver vazio, o funcionário é bloqueado   					
					   	If ColabOper == "B"
					      
						   aAdd( aMatA030 , { "A1_ZDTDFUN",StoD(ColabDtDemiss), NIL } )
						  
						   cDia := U_fUltDMes(Month(StoD(ColabDtDemiss)))
						   cMes := AllTrim(StrZero(Month(StoD(ColabDtDemiss)),2))
						   cAno := AllTrim(StrZero(Year(StoD(ColabDtDemiss)),4))
						  
						   dData := CtoD(cDia+"/"+cMes+"/"+cAno)

						   aAdd( aMatA030 , { "A1_VENCLC", dData   , NIL } )

						EndIf  

					EndIf

				ElseIf ColabOper $ "I/A"	// Inclusão / Alteração

					If ColabOper == "A" // Alteração, mudar nOpc para Inclusão
						nOpc := 3
					Else
						cCodCli := GetSXENum("SA1","A1_COD")  //SA1->A1_COD
					EndIf

					aAdd( aMatA030 , { "A1_FILIAL",  xFILIAL("SA1")  , NIL } )
					aAdd( aMatA030 , { "A1_COD", 	 cCodCli  	     , NIL } )
					aAdd( aMatA030 , { "A1_LOJA", 	 "01"            , NIL } )
					aAdd( aMatA030 , { "A1_ZCODMGF", iif( Empty(ColabZCodMGF),SA1->A1_ZCODMGF,ColabZCodMGF) , NIL } )
					aAdd( aMatA030 , { "A1_MSBLQL",  iif(ColabOper == "B" ,"1" ,"2"), NIL } )
					aAdd( aMatA030 , { "A1_TIPO",	"F" , NIL } )
					aAdd( aMatA030 , { "A1_PESSOA", IIF(Len(AllTrim(ColabCNPJ))==14,"J","F") , NIL } )

					If SA1->(FieldPos( "A1_ZTPRHE") ) > 0
						aAdd( aMatA030 , { "A1_ZTPRHE"	, iif( Empty(ColabTipo) ,SA1->A1_ZTPRHE, ColabTipo)	, NIL } )
					EndIf

					aAdd( aMatA030 , { "A1_CGC"	, iif( Empty(ColabCNPJ)  	 ,SA1->A1_CGC,   ColabCNPJ)		, NIL } )
					aAdd( aMatA030 , { "A1_INSCR", 	 iif( Empty(ColabInscEst),SA1->A1_INSCR,  ColabInscEst) , NIL } )
					aAdd( aMatA030 , { "A1_INSCRM",  iif( Empty(ColabInscMun),SA1->A1_INSCRM, ColabInscMun) , NIL } )
					aAdd( aMatA030 , { "A1_NOME"	, iif( Empty(ColabNome)  ,SA1->A1_NOME,  ColabNome)	, NIL } )
					aAdd( aMatA030 , { "A1_NREDUZ"	, iif( Empty(ColabNReduz),SA1->A1_NREDUZ,  ColabNReduz)	, NIL } )
					aAdd( aMatA030 , { "A1_CONTATO"	, iif( Empty(ColabContato)  ,SA1->A1_CONTATO,ColabContato)	, NIL } )
					aAdd( aMatA030 , { "A1_END"		, iif( Empty(ColabEndereco),SA1->A1_END,  ColabEndereco), NIL } )
					aAdd( aMatA030 , { "A1_BAIRRO"	, iif( Empty(ColabBairro),SA1->A1_BAIRRO,ColabBairro)	, NIL } )
					aAdd( aMatA030 , { "A1_EST"		, iif( Empty(ColabEst)	 ,SA1->A1_EST,  ColabEst)		, NIL } )
					aAdd( aMatA030 , { "A1_COD_MUN"	, iif( Empty(ColabCodMun),SA1->A1_COD_MUN,  ColabCodMun) , NIL } )

					cMUNICIPIO := FwCutOFF( Trim( fDesc('CC2', ColabEst + ColabCodMun, 'CC2_MUN',, ColabFilial ) ), .T.)

					aAdd( aMatA030 , { "A1_MUN"		, iif( Empty(ColabCodMun),SA1->A1_MUN,  cMUNICIPIO) 	, NIL } )
					aAdd( aMatA030 , { "A1_CEP"		, iif( Empty(ColabCEP)	 ,SA1->A1_CEP,  ColabCEP)  		, NIL } )
					aAdd( aMatA030 , { "A1_TEL"		, iif( Empty(ColabTelefone),SA1->A1_TEL,  ColabTelefone) , NIL } )
					aAdd( aMatA030 , { "A1_FAX"		, iif( Empty(ColabFax)	 ,SA1->A1_FAX,  ColabFax)		, NIL } )
					aAdd( aMatA030 , { "A1_EMAIL"	, iif( Empty(ColabEmail) ,SA1->A1_EMAIL,ColabEmail) 	, NIL } )
					aAdd( aMatA030 , { "A1_OBSERV"	, iif( Empty(ColabObs) 	 ,SA1->A1_OBSERV,ColabObs)		, NIL } )
					aAdd( aMatA030 , { "A1_CONTA"	, iif( Empty(ColabContCli),SA1->A1_CONTA,ColabContCli) , NIL } )

					If !Empty( ColabDTNasc )
						aAdd( aMatA030 , { "A1_DTNASC"	, STOD(StrTran(ColabDTNasc,"-")) , NIL } )
					Else
						aAdd( aMatA030 , { "A1_DTNASC"	, IIF(Empty(SA1->A1_DTNASC), STOD("19800101"), SA1->A1_DTNASC), NIL } )
					EndIf

					aAdd( aMatA030 , { "A1_GRPTRIB", iif( Empty(cSA1GrpTrib),SA1->A1_GRPTRIB,cSA1GrpTrib) , NIL } )
					aAdd( aMatA030 , { "A1_CONTRIB", iif( Empty(cSA1Contrib),SA1->A1_CONTRIB,cSA1Contrib) , NIL } )
					aAdd( aMatA030 , { "A1_NATUREZ", iif( Empty(ColabNatCli),SA1->A1_NATUREZ,ColabNatCli) , NIL } )
					aAdd( aMatA030 , { "A1_PAIS"   , iif( Empty(ColabPais)  ,SA1->A1_PAIS,ColabPais)      , NIL } )
					aAdd( aMatA030 , { "A1_COMPLEM", iif( Empty(ColabComp)  ,SA1->A1_COMPLEM,ColabComp)   , NIL } )
					aAdd( aMatA030 , { "A1_DDD",     iif( Empty(ColabDDD)   ,iif( Empty(SA1->A1_DDD), "00", SA1->A1_DDD), ColabDDD )  	  , NIL } )
					aAdd( aMatA030 , { "A1_DDI"	,    iif( Empty(ColabDDI)   ,iif( Empty(SA1->A1_DDI), "55", SA1->A1_DDI), ColabDDI )  	  , NIL } )
					aAdd( aMatA030 , { "A1_ZCFIL",   iif( Empty(ColabFilial),SA1->A1_ZCFIL,ColabFilial)	  , NIL } )
					aAdd( aMatA030 , { "A1_CNAE",    iif( Empty(ColabCCnae) ,SA1->A1_CNAE,ColabCCnae)	  , NIL } )

					//Se o conteudo do parametro estiver em branco
					If !Empty( cCondPagSA1 )
						aAdd( aMatA030 , { "A1_COND", cCondPagSA1 , NIL } )
					EndIf

					If !Empty( nLimCredSA1 )
						aAdd( aMatA030 , { "A1_LC", nLimCredSA1 , NIL } )
					EndIf

					If !Empty( czBoletoSA1 )
						aAdd( aMatA030 , { "A1_ZBOLETO", czBoletoSA1 , NIL } )
					EndIf

					//Regra para Definição da Data do Limite de Credito
					//Entre 01/01 e 30/06 - 31/12
					//Entre 01/07 e 31/12 - 30/06
					If  dDataBase <= cToD("30/06/" + Alltrim(str(Year(Date() ) )))
						aAdd( aMatA030 , { "A1_VENCLC", cToD("30/06/" + Alltrim(str(Year(Date()) + 1 )))  , NIL } )
					Else
						aAdd( aMatA030 , { "A1_VENCLC", cToD("31/12/" + Alltrim(str(Year(Date()) + 1 )))  , NIL } )
					Endif

				Else

					If ColabOper != "E"	// Exclusão
						cStatus	:= "S"
					EndIf

					cObserv	:=	"[SA1]["+ColabOper+"] CLIENTE NAO EXISTE." + CRLF

				EndIf

				cErro := ""

				If cStatus	== "S" .And. !Empty( aMatA030 )

					lMsErroAuto := .F.

					If nOpc == 3
					   SA1->(dbSetOrder(3))
					   If SA1->( dbSeek( xFilial("SA1") + ColabCNPJ ) )

  						  U_MFCONOUT(" Colaborador : "+AllTrim(ColabNome)+" CPF : "+Alltrim(ColabCNPJ)+;
						             " JÁ EXISTE NO CADASTRO DE CLIENTES [SA1]")

					      lExec := .F.

					   EndIf
				
					EndIf

					_lbloq := .T.

					If nopc == 4

						SA1->(dbSetOrder(3))
					   If SA1->( dbSeek( xFilial("SA1") + ColabCNPJ ) )	

					   		If SA1->A1_MSBLQL != '1'
						  	 _lbloq := .F.
							Endif

						Endif

					Endif					

					If lExec 

					   If     nOpc == 3
					          cFrase := "== Cadastrando cliente para o colaborador : "
					   ElseIf nOpc == 4  
					          cFrase := "== Alterando o cadastro de cliente para o colaborador : "
					   EndIf

						U_MFCONOUT(cFrase+AllTrim(ColabNome)+" - CPF : "+Alltrim(ColabCNPJ))

						MSExecAuto({|x,y| Mata030(x,y)}, aMatA030,nOpc)

						If lMsErroAuto

							aErrRet  := {}
							aErrRet  := GetAutoGRLog()
							aAVISO   := {}
							cObserv  := ""

							For nJK := 1 to Len( aErrRet)
							    // severidade, campo, msg
								aAdd(aAVISO,{'ERRO','EXECAUTO',aErrRet[nJK]})
								cObserv := cObserv + aErrRet[nJK] + CRLF
							Next nJK

							cStatus	:= "N"

							//Recupera os erros que ocorreram
							aErro := GetAutoGRLog()
							cErro := ""
							cErro += FunName() +" - ExecAuto MatA030" + CRLF

							cErro += "Nome       - "+ ColabNome + CRLF
							cErro += "CPF/CNPJ   - "+ ColabCNPJ + CRLF
							cErro += "Natureza   - "+ ColabNatCli + CRLF
							cErro += "Nascimento - "+ ColabDTNasc + CRLF
							cErro += " " + CRLF

							cValForne := "N" //Alterado Rafael 07/11/2018

							RollBackSX8()
							cHorOrd	:= Time()
							cTempo	:= ElapTime(cHorIni,cHorOrd)
							nRecnoDoc := 0

							aLogSA1 := {cFilAnt,iif(cStatus=="N",'2','1'),Alltrim(GetMv("MGF_INT02F"))/*cCodint*/,GetMv("MGF_INT02G")/*cCodtpint*/,iif(Len(cErro)>0,FunName() +" - ExecAuto Mata030",cObserv),cDocori,cTempo,cObserv+CRLF+cErro,nRecnoDoc,"",.F.,{cEmpAnt,cFilAnt}}

							U_MFCONOUT("Erros apresentados [SA1 - Cadastro de Clientes] - Colaborador : "+;
										AllTrim(ColabNome)+" - CPF : "+Alltrim(ColabCNPJ)+" - "+;
										AllTrim(cObserv))

							Disarmtransaction()
							Break
	                    							
						Else
				
							iif( ColabOper == "I", ConfirmSX8(), "" )
							cObserv 	+= "[SA1]["+ColabOper+"] Operação finalizada com sucesso." + CRLF
							nRecnoDoc 	:= SA1->(Recno())
							nRecGRVSA1	:= SA1->(Recno())
							cHorOrd		:= Time()
							cTempo		:= ElapTime(cHorIni,cHorOrd)

							aLogSA1 := {cFilAnt,iif(cStatus=="N",'2','1'),GetMv("MGF_INT02F")/*cCodint*/,GetMv("MGF_INT02G")/*cCodtpint*/,iif(Len(cErro)>0,FunName() +" - ExecAuto Mata030",cObserv),cDocori,cTempo,cObserv+CRLF+cErro,nRecnoDoc,"",.F.,{cEmpAnt,cFilAnt}}
							cCodCli := SA1->A1_COD
							cLojCli := SA1->A1_LOJA

							// [SA1] - Desbloqueia o cadastro, quando a filial tem loja Montana
							If ColabOper $ "IA" .And. (nOpc == 3 .or. nopc == 4) .And. ColabTipo == "F" 
								SA1->(RecLock("SA1",.F.))
								SA1->A1_MSBLQL := If(AllTrim(ColabFilial)$cUnit,"2","1")
								SA1->(MsUnLock())
							EndIf

							// [SA1] - Na alteração, deixa desbloqueado se vier por integração e já estava desbloqueado 
							If ColabOper == "A" .And. nOpc == 4 .And. ColabTipo == "F" .and. !(_lbloq)
								SA1->(RecLock("SA1",.F.))
								SA1->A1_MSBLQL := "2"
								SA1->(MsUnLock())
							EndIf

							//Se estiver com data de demissão preenchida bloqueia sempre
							If !empty(SA1->A1_ZDTDFUN) .or. !empty(ColabDtDemiss)
								SA1->(RecLock("SA1",.F.))
								SA1->A1_MSBLQL := "1"
								SA1->A1_ZDTDFUN := IIF(EMPTY(SA1->A1_ZDTDFUN),STOD(ColabDtDemiss),SA1->A1_ZDTDFUN)
								SA1->(MsUnLock())
							Else
								//Se não está demitido sempre ajusta a data de limite de crédito
								SA1->(RecLock("SA1",.F.))
								//Regra para Definição da Data do Limite de Credito
								//Entre 01/01 e 30/06 - 31/12
								//Entre 01/07 e 31/12 - 30/06
								If  dDataBase <= cToD("30/06/" + Alltrim(str(Year(Date() ) )))
									SA1->A1_VENCLC := cToD("30/06/" + Alltrim(str(Year(Date()) + 1 )))
								Else
									SA1->A1_VENCLC := cToD("31/12/" + Alltrim(str(Year(Date()) + 1 )))
								Endif

								SA1->(MsUnLock())
				
							Endif
						

							U_MFCONOUT("Completou o Cadastro de Clientes] - Colaborador : "+;
										AllTrim(ColabNome)+" CPF : "+Alltrim(ColabCNPJ)+" - "+;
										"com sucesso")

						EndIf
					Endif
				EndIf

			EndIf

			If  cStatus == "S" .OR. cValForne == "S"

				cObserv := ""
				dbSelectArea("SA2")
				SA2->(DbSetOrder(3))	// A1_FILIAL+A1_CGC
				SA2->(DbGoTop())

				If SA2->( dbSeek( xFilial("SA2") + ColabCNPJ ) )

					cCodFor := SA2->A2_COD
					cLojFor := SA2->A2_LOJA

					If ColabOper == "I"	// Inclusão
						ColabOper := "A"
						nopc := 4
					Endif
				Else
					//na alteração caso não exontre o fornecedor ira cadastrar o mesmo
					If ColabOper $ "I|A"	// Inclusão
						nOpc := 3
						cCodFor := GetSXENum("SA2","A2_COD")  //SA2->A2_COD
					Else
						cStatus	:= "N"
						cObserv	:=	"[SA1]["+ColabOper+"] CLIENTE NAO EXISTE."
					Endif
				Endif

				aAdd( aMatA020 , { "A2_FILIAL",  xFILIAL("SA2") , NIL } )
				aAdd( aMatA020 , { "A2_ZCODMGF", iif( Empty(ColabZCodMGF),SA2->A2_ZCODMGF,ColabZCodMGF) , NIL } )
				aAdd( aMatA020 , { "A2_MSBLQL",  iif(ColabOper == "B" ,"1" ,"2"), NIL } )

				IF nOpc == 3 //Inclusão
					aAdd( aMatA020 , { "A2_TIPO",	"F" , NIL } )
					aAdd( aMatA020 , { "A2_CGC"	,    iif( Empty(ColabCNPJ) 	 ,SA2->A2_CGC,    ColabCNPJ)	, NIL } )
				Else
					aAdd( aMatA020 , { "A2_COD", 	 cCodFor 	    , NIL } )
					aAdd( aMatA020 , { "A2_LOJA", 	 "01"	        , NIL } )
				EndIF

				If SA2->(FieldPos( "A2_ZTPRHE") ) > 0
					aAdd( aMatA020 , { "A2_ZTPRHE"	, iif( Empty(ColabTipo)  ,SA2->A2_ZTPRHE, ColabTipo)	, NIL } )
				EndIf

				aAdd( aMatA020 , { "A2_INSCR", 	 iif( Empty(ColabInscEst), iif( Empty(SA2->A2_INSCR),"ISENTO", SA2->A2_INSCR ),  ColabInscEst) , NIL } )
				aAdd( aMatA020 , { "A2_INSCRM",  iif( Empty(ColabInscMun),SA2->A2_INSCRM, ColabInscMun) , NIL } )
				aAdd( aMatA020 , { "A2_NOME"	, iif( Empty(ColabNome)  ,SA2->A2_NOME,  substr(alltrim(ColabNome),1,40))		, NIL } )
				aAdd( aMatA020 , { "A2_NREDUZ"	, iif( Empty(ColabNReduz),SA2->A2_NREDUZ,  ColabNReduz)	, NIL } )
				aAdd( aMatA020 , { "A2_CONTATO"	, iif( Empty(ColabNome)  ,SA2->A2_CONTATO,ColabContato)	, NIL } )
				aAdd( aMatA020 , { "A2_END"		, iif( Empty(ColabEndereco),SA2->A2_END,  substr(alltrim(ColabEndereco),1,40)), NIL } )
				aAdd( aMatA020 , { "A2_BAIRRO"	, iif( Empty(ColabBairro),SA2->A2_BAIRRO,substr(alltrim(ColabBairro),1,20))	, NIL } )
				aAdd( aMatA020 , { "A2_EST"		, iif( Empty(ColabEst)	 ,SA2->A2_EST,  ColabEst)		, NIL } )
				aAdd( aMatA020 , { "A2_COD_MUN"	, iif( Empty(ColabCodMun),SA2->A2_COD_MUN,  ColabCodMun) , NIL } )

				cMUNICIPIO := FwCutOFF( Trim( fDesc('CC2', ColabEst + ColabCodMun, 'CC2_MUN',, ColabFilial ) ), .T.)

				aAdd( aMatA020 , { "A2_MUN"		, iif( Empty(ColabCodMun),SA2->A2_MUN,  cMUNICIPIO) 	, NIL } )
				aAdd( aMatA020 , { "A2_CEP"		, iif( Empty(ColabCEP)	 ,SA2->A2_CEP,  ColabCEP)  		, NIL } )
				aAdd( aMatA020 , { "A2_TEL"		, iif( Empty(ColabTelefone),SA2->A2_TEL,  ColabTelefone), NIL } )
				aAdd( aMatA020 , { "A2_FAX"		, iif( Empty(ColabFax)	 ,SA2->A2_FAX,  ColabFax)		, NIL } )
				aAdd( aMatA020 , { "A2_EMAIL"	, iif( Empty(ColabEmail) ,iif(Empty(SA2->A2_EMAIL),"sem_email@marfrig.com.br",SA2->A2_EMAIL),  ColabEmail) 	, NIL } )
				aAdd( aMatA020 , { "A2_ZOBSERV"	, "Integrado via RH Evolution"		, NIL } )
				aAdd( aMatA020 , { "A2_CONTA"	, iif( Empty(ColabContDeb),SA2->A2_CONTA,ColabContDeb)  , NIL } )

				If !Empty( ColabDTNasc )
					aAdd( aMatA020 , { "A2_DTNASC"	, STOD(StrTran(ColabDTNasc,"-")) , NIL } )
					aAdd( aMatA020 , { "A2_ZDTNASC"	, STOD(StrTran(ColabDTNasc,"-")) , NIL } )
				Else
					aAdd( aMatA020 , { "A2_DTNASC"	, IIF(Empty(SA2->A2_DTNASC), STOD("19800101"), SA2->A2_DTNASC), NIL } )
					aAdd( aMatA020 , { "A2_ZDTNASC"	, IIF(Empty(SA2->A2_DTNASC), STOD("19800101"), SA2->A2_DTNASC), NIL } )
				EndIf

				aAdd( aMatA020 , { "A2_GRPTRIB", iif( Empty(cGrpTribSA2),SA2->A2_GRPTRIB,cGrpTribSA2) , NIL } )
				aAdd( aMatA020 , { "A2_CONTRIB", iif( Empty(cContribSA2),SA2->A2_CONTRIB,cContribSA2) , NIL } )
				aAdd( aMatA020 , { "A2_NATUREZ", iif( Empty(ColabNatFor),SA2->A2_NATUREZ,ColabNatFor) , NIL } )
				aAdd( aMatA020 , { "A2_PAIS"   , iif( Empty(ColabPais)  ,SA2->A2_PAIS,ColabPais)      , NIL } )
				aAdd( aMatA020 , { "A2_COMPLEM", iif( Empty(ColabComp)  ,SA2->A2_COMPLEM,ColabComp)   , NIL } )
				aAdd( aMatA020 , { "A2_DDD",     iif( Empty(ColabDDD)   ,iif( Empty(SA2->A2_DDD), "00", SA2->A2_DDD), substr(ColabDDD,1,3))  	  , NIL } )
				aAdd( aMatA020 , { "A2_DDI"	,    iif( Empty(ColabDDI)   ,iif( Empty(SA2->A2_DDI), "55", SA2->A2_DDI), substr(ColabDDI,1,3))  	  , NIL } )
				aAdd( aMatA020 , { "A2_CNAE",    iif( Empty(ColabFCnae) ,SA2->A2_CNAE,ColabFCnae)	  , NIL } )
				aAdd( aMatA020 , { "A2_ZPROPRI", iif( Empty(ColabPropri),iif(Empty(SA2->A2_ZPROPRI),".",SA2->A2_ZPROPRI), ColabPropri)  , NIL } )
				aAdd( aMatA020 , { "A2_ZCCD"	, iif( Empty(ColabCCusto) ,SA2->A2_ZCCD, ColabCCusto), NIL } )
				aAdd( aMatA020 , { "A2_CODPAIS"	, iif( Empty(ColabpaisBC) ,SA2->A2_CODPAIS,ColabpaisBC), NIL } )
				aAdd( aMatA020 , { "A2_ZNASCIO"	, iif( Empty(cPaisNacio) ,SA2->A2_ZNASCIO,cPaisNacio), NIL } )
				aAdd( aMatA020 , { "A2_TPESSOA"	, "PF" , NIL } )

				// Inclusão dos novos campos (a ser alterado para gravação em tabela específica)
				aAdd( aMatA020,{"A2_ZSETFUN",If(Empty(ColabSetor)	 , SA2->A2_ZSETFUN , ColabSetor)  		  , NIL } )
				aAdd( aMatA020,{"A2_ZDSCFUN",If(Empty(ColabDescSet)	 , SA2->A2_ZDSCFUN , ColabDescSet)    	  , NIL } )
				aAdd( aMatA020,{"A2_ZUNFUNC",If(Empty(ColabUnidade)	 , SA2->A2_ZUNFUNC , ColabUnidade)  	  , NIL } )
				aAdd( aMatA020,{"A2_ZUNDFUN",If(Empty(ColabDescUnid) , SA2->A2_ZUNDFUN , ColabDescUnid)  	  , NIL } )
				aAdd( aMatA020,{"A2_ZDTAFUN",If(Empty(ColabDtAdmiss) , SA2->A2_ZDTAFUN , StoD(ColabDtAdmiss)) , NIL } )

				// Se o campo de Data de Demissão não estiver vazio, bloqueio
				If ColabTipo == "F" // Funcionário
					If !Empty(ColabDtDemiss)
				   		If ColabOper == "B"
					   		aAdd( aMatA020 , { "A2_ZDTDFUN",StoD(ColabDtDemiss), NIL } )
						EndIf
					EndIf
				EndIf	

			EndIf

			If  cStatus	== "S" .And. !Empty( aMatA020 )

				lAutoErrNoFile 	:= .T.
				lMsHelpAuto		:= .T.
				lMsErroAuto 	:= .F.
                
			    If     nOpc == 3
				       cFrase := "== Cadastrando fornecedor para o colaborador : "
					   PRIVATE INCLUI := .T.
					   PRIVATE ALTERA := .F.
				ElseIf nOpc == 4  
				       cFrase := "== Alterando o cadastro de fornecedor para o colaborador : "
					   PRIVATE INCLUI := .F.
					   PRIVATE ALTERA := .T.
				EndIf

	            U_MFCONOUT(cFrase+AllTrim(ColabNome)+" CPF : "+Alltrim(ColabCNPJ))

				MSExecAuto({|x,y| MatA020(x,y)},aMatA020,nOpc)

				SA2->(Dbsetorder(3)) //A2_FILIAL+A2_CGC

				If lMsErroAuto .OR. !(SA2->(Dbseek(xfilial("SA2")+Alltrim(ColabCNPJ))))

					aErrRet  := {}
					aErrRet  := GetAutoGRLog()
					aAVISO   := {}
					cObserv  := ""

					For nJK := 1 to Len( aErrRet)
						If  "VALID" $  UPPER( aErrRet[ nJK ] )   .Or. "OBRIGAT" $  UPPER( aErrRet[ nJK ] )
							aAdd( aAVISO,  { 'ERRO', 'EXECAUTO', aErrRet[nJK ]  } )   //severidade, campo, msg
							cObserv += aErrRet[nJK ] +CRLF
						Endif
					Next nJK

					If Len(aAVISO) > 0

						cStatus	:= "N"

						// Recupera os erros que ocorreram
						cErro := ""
						cErro += FunName() +" - ExecAuto MatA020" + CRLF

						cErro += "Nome       - "+ ColabNome + CRLF
						cErro += "CPF/CNPJ   - "+ ColabCNPJ + CRLF
						cErro += "Natureza   - "+ ColabNatCli + CRLF
						cErro += "Nascimento - "+ ColabDTNasc + CRLF
						cErro += " " + CRLF

						RollBackSX8()
						cHorOrd	:= Time()
						cTempo	:= ElapTime(cHorIni,cHorOrd)

						nRecnoDoc := 0
						aLogSA2   := {cFilAnt,iif(cStatus=="N",'2','1'),GetMv("MGF_INT02F")/*cCodint*/,GetMv("MGF_INT02G")/*cCodtpint*/,iif(Len(cErro)>0,FunName() +" - ExecAuto Mata020",cObserv),cDocori,cTempo,cObserv+CRLF+cErro,nRecnoDoc,"",.F.,{cEmpAnt,cFilAnt}}

                   		U_MFCONOUT("Erros apresentados [SA2 - Cadastro de Fornecedores] - Colaborador : "+;
								   AllTrim(ColabNome)+" CPF : "+Alltrim(ColabCNPJ)+" - "+;
								   AllTrim(cObserv))

						Disarmtransaction()
						Break


					Else
						iif( ColabOper == "I", ConfirmSX8(), "" )
						cObserv += "[SA2]["+ColabOper+"] Operação finalizada com sucesso."

						cHorOrd	:= Time()
						cTempo	:= ElapTime(cHorIni,cHorOrd)
						nRecnoDoc := SA2->(Recno())

						aLogSA2 := {cFilAnt,iif(cStatus=="N",'2','1'),GetMv("MGF_INT02F")/*cCodint*/,GetMv("MGF_INT02G")/*cCodtpint*/,iif(Len(cErro)>0,FunName() +" - ExecAuto Mata020",cObserv),cDocori,cTempo,cObserv+CRLF+cErro,nRecnoDoc,"",.F.,{cEmpAnt,cFilAnt}}
						cCodFor := SA2->A2_COD
						cLojFor := SA2->A2_LOJA

						U_MFCONOUT("Completou o Cadastro de Fornecedores - Colaborador : "+;
						           AllTrim(ColabNome)+" CPF : "+Alltrim(ColabCNPJ)+" - "+;
								   "com sucesso")
					Endif
				Else
					iif( ColabOper == "I", ConfirmSX8(), "" )
					cObserv += "[SA2]["+ColabOper+"] Operação finalizada com sucesso."

					cHorOrd	:= Time()
					cTempo	:= ElapTime(cHorIni,cHorOrd)
					nRecnoDoc := SA2->(Recno())

					aLogSA2 := {cFilAnt,iif(cStatus=="N",'2','1'),GetMv("MGF_INT02F")/*cCodint*/,GetMv("MGF_INT02G")/*cCodtpint*/,iif(Len(cErro)>0,FunName() +" - ExecAuto Mata020",cObserv),cDocori,cTempo,cObserv+CRLF+cErro,nRecnoDoc,"",.F.,{cEmpAnt,cFilAnt}}
					cCodFor := SA2->A2_COD
					cLojFor := SA2->A2_LOJA

					// [SA2] - Desbloqueia o cadastro, quando a filial tem loja Montana
					If ColabOper == "I" .And. nOpc == 3 .And. ColabTipo == "F"
					   SA2->(RecLock("SA2",.F.))
					   SA2->A2_MSBLQL := If(AllTrim(ColabFilial)$cUnit,"2","1")
					   SA2->(MsUnLock())
					EndIf

					// [SA2] - Na alteração, deixa desbloqueado se vier por integração 
					If ColabOper == "A" .And. nOpc == 4 .And. ColabTipo == "F"
						SA2->(RecLock("SA2",.F.))
						SA2->A2_MSBLQL := "2"
						SA2->(MsUnLock())
					EndIf

					U_MFCONOUT("Completou o Cadastro de Fornecedores - Colaborador : "+;
					           AllTrim(ColabNome)+" CPF : "+Alltrim(ColabCNPJ)+" - "+;
					           "com sucesso")
				
				EndIf

			EndIf

		EndIf

	End Sequence

	End Transaction

	aAdd(aRetDados ,{ColabCNPJ})			// 1
	aAdd(aRetDados ,{ColabOper})			// 2
	aAdd(aRetDados ,{cStatus})				// 3
	aAdd(aRetDados ,{cCodCli+cLojCli})		// 4
	aAdd(aRetDados ,{cCodFor+cLojFor})  	// 5
	aAdd(aRetDados ,{cObserv})				// 6

Return aRetDados

//-----------------------------------------------------------------------------------
/*/{Protheus.doc}MGFINT02PG 
Criação de título a pagar
@author  Atilio Amarilla
@since 19/08/2016
*/

Static Function MGFINT02PG( aDados , aRetDados )

	Local PagarOper		:= aDados[01]
	Local PagarCNPJ		:= aDados[02]
	Local PagarIDProc	:= aDados[03]
	Local PagarNatur	:= aDados[04]
	Local PagarEmiss	:= aDados[05]
	Local PagarVcto		:= aDados[06]
	Local PagarValor	:= aDados[07]
	Local PagarPort		:= aDados[08]
	Local PagarCCont	:= aDados[09]
	Local PagarEmp		:= aDados[10]
	Local PagarHist		:= aDados[11]
	Local PagarCCusto	:= aDados[12]

	Local dDatIni	:= Date()
	Local cHorIni	:= Time()
	Local cHorOrd
	Local aErro, cErro, cArqLog

	Local cPrfNum		:= ""

	Local aFinA050	:= {} // Array para execauto. Contas a Pagar
	Local cLojFor	:= cCodFor	:= ""
	Local cStatus	:= "S"
	Local cObserv	:=	""

	Local lCodTit, cCodPrf,	cCodTip

	Local nOpc 		:= IIF( PagarOper == "I" , 3 , 5 )
	Local nRecnoDoc := 0
	Local nContador := 0
	
	Private lMsErroAuto    := .F. //necessario a criacao, pois sera //atualizado quando houver
	Private lMsHelpAuto    := .F.
	Private lAutoErrNoFile := .T.
	Private l030Auto       := .T.

	U_MFCONOUT("== Integração RH Evolution - Contas a Pagar ==")

	If Empty( SM0->M0_CODIGO )
		cErro := ""
		cStatus	:= "N"
		cObserv	:=	"["+PagarEmp+"] ERRO NA PREPARACAO DO  AMBIENTE."
		U_MGFMONITOR(cFilAnt,iif(cStatus=="N",'2','1'),GetMv("MGF_INT02F")/*cCodint*/,GetMv("MGF_INT02I")/*cCodtpint*/,iif(Len(cErro)>0,FunName() +" - ExecAuto FinA050",cObserv),cDocori,cTempo,cObserv+CRLF+cErro,0,"",.F.,{cEmpAnt,cFilAnt})
	Else

		If Empty(PagarEmp)
			cStatus	:= "N"
			cObserv	:=	"["+PagarEmp+"] EMPRESA INVALIDA."
		EndIf

		If cStatus	== "S" .And. SM0->( dbSeek( "01" + Stuff( Space( Len(SM0->M0_CODFIL) ) , 1 , Len(PagarEmp) , PagarEmp ) ) )
			If PagarEmp <> cFilAnt
				cFilAnt := PagarEmp
			EndIf
		Else
			cStatus	:= "N"
			cObserv	:=	"["+PagarEmp+"] EMPRESA INVALIDA."
		EndIf

		cCodPrf	:= GetNewPar("MGF_INT02H","RHE")
		cCodPrf	:= Stuff( Space( TamSX3("E2_PREFIXO")[1] ) , 1 , Len(AllTrim(cCodPrf)) , Alltrim(cCodPrf) )

		/*
		ColabTipo
		B - Beneficiário - Fornecedor – pensão judicial / pensão alimentícia;
		F - Funcionário	 - Fornecedor e Cliente
		E - Empresa 	 - Fornecedor
		*/

		PagarCNPJ	:= Stuff( Space( TamSX3("A1_CGC")[1] ) , 1 , Len(AllTrim(PagarCNPJ)) , Alltrim(PagarCNPJ) )
		PagarNatur	:= Stuff( Space( TamSX3("E2_NATUREZ")[1] ) , 1 , Len(AllTrim(PagarNatur)) , Alltrim(PagarNatur) )
		PagarIDProc	:= Stuff( Space( TamSX3("E2_NUM")[1] ) , 1 , Len(AllTrim(PagarIDProc)) , Alltrim(PagarIDProc) )

		If SED->( FieldPos( "ED_ZTPTRHE" ) ) > 0
			cCodTip	:= GetAdvFVal("SED","ED_ZTPTRHE",xFilial("SED")+PagarNatur,1,"")
		EndIf

		If Empty( cCodTip )
			cCodTip	:= GetNewPar("MGF_INT02K","DP")
		EndIf

		cCodTip	:= Stuff( Space( TamSX3("E2_TIPO")[1] ) , 1 , Len(AllTrim(cCodTip)) , Alltrim(cCodTip) )

		If cStatus	== "S" .And. ( Empty(PagarOper) .Or. !PagarOper $ "IE" ) // Inclusão / Exclusão
			cStatus	:= "N"
			cObserv	:=	"["+PagarOper+"] OPERACAO INVALIDA."
		EndIf

		If cStatus	== "S"

			// Validação das Regras para Cadastro de Titulo a Pagar no Protheus
			If !CGC(PagarCNPJ) .And. Subs(PagarCNPJ,1,9) $ "000000000/         "
				cStatus	:= "N"
				cObserv	+=	"CPF/CNPJ INVALIDO."  + CRLF
				nRecnoDoc := 0
			Else
				dbSelectArea("SA2")
				SA2->(DbSetOrder(3))	// A1_FILIAL+A1_CGC
				SA2->(DbGoTop())
				If !SA2->( dbSeek( xFilial("SA2") + PagarCNPJ ) )
					cStatus	:= "N"
					cObserv	+=	"FORNECEDOR NAO EXISTE." + CRLF
					nRecnoDoc := 0
				ElseIf SA2->A2_MSBLQL == '1' // BLOQUEIO
					cStatus	:= "N"
					cObserv	+=	"FORNECEDOR BLOQUEADO PARA USO." + CRLF
					nRecnoDoc := 0
				Else
					cCodFor := SA2->A2_COD
					cLojFor := SA2->A2_LOJA

					dbSelectArea("SE2")
					SE2->(DbSetOrder(1))	// E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
					SE2->(DbGoTop())

					If SE2->( dbSeek( xFilial("SE2") + cCodPrf + PagarIDProc + Space(Len(E2_PARCELA)) + cCodTip + cCodFor + cLojFor ) )
						If PagarOper == "I"
							cStatus	:= "N"
							cObserv	+=	"TITULO JA EXISTE." + CRLF
							nRecnoDoc := SE2->(Recno())
						EndIf
					Else
						If PagarOper == "E"
							cStatus	:= "N"
							cObserv	+=	"TITULO NAO EXISTE." + CRLF
							nRecnoDoc := 0
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf

		//Validação de Dados após satisfazer parte 1 das regras
		DbSelectArea("SX5")
		DbSetOrder(1)
		If SX5->(!DbSeek(xFilial("SX5")+"05"+cCodTip))
			cStatus	:= "N"
			cObserv	+=	"TIPO DO TITULO NÃO EXISTE." + CRLF
			nRecnoDoc := 0
		EndIf

		DbSelectArea("SED")
		DbSetOrder(1)
		If SED->(!DbSeek(xFilial("SED")+PagarNatur))
			cStatus	:= "N"
			cObserv	+=	"NATUREZA NÃO EXISTE." + CRLF
			nRecnoDoc := 0
		ElseIf SED->ED_MSBLQL == '1' // BLOQUEADA
			cStatus	:= "N"
			cObserv	+=	"NATUREZA BLOQUEADA PARA USO." + CRLF
			nRecnoDoc := 0
		EndIf

		If cStatus	== "S"

			aAdd( aFinA050 , { "E2_PREFIXO"	, cCodPrf , NIL } )
			aAdd( aFinA050 , { "E2_NUM"		, PagarIDProc , NIL } )
			aAdd( aFinA050 , { "E2_TIPO"	, cCodTip , NIL } )
			aAdd( aFinA050 , { "E2_NATUREZ"	, PagarNatur , NIL } )
			aAdd( aFinA050 , { "E2_FORNECE"	, cCodFor , NIL } )
			aAdd( aFinA050 , { "E2_LOJA"	, cLojFor , NIL } )
			aAdd( aFinA050 , { "E2_HIST"	, PagarHist , NIL } )

			If PagarOper == "I"
				If !Empty( PagarEmiss )
					aAdd( aFinA050 , { "E2_EMISSAO"	, STOD(STRTRAN(PagarEmiss,'-','')) , NIL } )
				EndIf
				aAdd( aFinA050 , { "E2_VENCTO"	, STOD(STRTRAN(PagarVcto,'-','')) , NIL } )
				aAdd( aFinA050 , { "E2_VALOR"	, PagarValor , NIL } )

				If !Empty( PagarPort )
					aAdd( aFinA050 , { "E2_PORTADO"	, PagarPort , NIL } )
				EndIf

				If !Empty( PagarCCont )
					aAdd( aFinA050 , { "E2_CONTAD"	, PagarCCont , NIL } )
				EndIf
				If !Empty( PagarCCusto )
					aAdd( aFinA050 , { "E2_CCUSTO"	, PagarCCusto	 , NIL } )
				Else
					PagarCCusto	:= GetAdvFVal("SED","ED_CCD",xFilial("SED")+PagarNatur,1,"")
					If !Empty( PagarCCusto )
						aAdd( aFinA050 , { "E2_CCUSTO"	, PagarCCusto	 , NIL } )
					EndIf
				EndIf
				If !Empty(SA2->A2_BANCO)
					aAdd( aFinA050 , { "E2_FORBCO"	, SA2->A2_BANCO		, ".T." } )
					aAdd( aFinA050 , { "E2_FORAGE"	, SA2->A2_AGENCIA	, ".T." } )
					aAdd( aFinA050 , { "E2_FAGEDV"	, SA2->A2_DVAGE		, ".T." } )
					aAdd( aFinA050 , { "E2_FORCTA"	, SA2->A2_NUMCON	, ".T." } )
					aAdd( aFinA050 , { "E2_FCTADV"	, SA2->A2_DVCTA		, ".T." } )
				EndIf
			EndIf
		EndIf
	EndIf

	//Verificação se algo está com bloqueio no cadastro
	If !Empty( PagarPort )
		DbSelectArea("SA6")
		DbSetOrder(1)
		If SA6->(DbSeek(xFilial("SA6")+PagarPort)) .AND. SA6->A6_BLOCKED == '1'
			cStatus	:= "N"
			cObserv	+=	"BANCO BLOQUEADO." + CRLF
			nRecnoDoc := 0
		EndIf
	EndIf

	If !Empty( PagarCCont )
		DbSelectArea("CT1")
		DbSetOrder(1)
		If CT1->(DbSeek(xFilial("CT1")+PagarCCont)) .AND. CT1->CT1_BLOQ == '1'
			cStatus	:= "N"
			cObserv	+=	"CONTA CONTABIL BLOQUEADA." + CRLF
			nRecnoDoc := 0
		EndIf
	EndIf

	If !Empty( PagarCCusto )
		DbSelectArea("CTT")
		DbSetOrder(1)
		If CTT->(DbSeek(xFilial("CTT")+PagarCCusto)) .AND. CTT->CTT_BLOQ == '1'
			cStatus	:= "N"
			cObserv	+=	"CENTRO DE CUSTO BLOQUEADO." + CRLF
			nRecnoDoc := 0
		EndIf
	EndIf

	cDocori := AllTrim(PagarIDProc)
	cErro := ""

	If cStatus	== "S" .And. !Empty( aFinA050 )

		lMsErroAuto    := .F. //necessario a criacao, pois sera //atualizado quando houver
		lAutoErrNoFile := .T.
		Begin Transaction

			MSExecAuto({|x,y,z| FinA050(x,y,z)},aFinA050,nOpc,nOpc)
			cErro := ""

			If lMsErroAuto
				
				cStatus	:= "N"

				//Recupera os erros que ocorreram

				aErro := GetAutoGRLog()
				cErro := ""
				cErro += FunName() +" - ExecAuto FinA050" + CRLF

				cErro += "Filial        - "+ cFilAnt + CRLF
				cErro += "Titulo        - "+ PagarIDProc + CRLF
				cErro += "Prefixo       - "+ cCodPrf + CRLF
				cErro += "Tipo          - "+ cCodTip + CRLF
				cErro += "Natureza      - "+ PagarNatur + CRLF
				cErro += "Fornecedor    - "+ cCodFor + CRLF
				cErro += "Historico     - "+ AllTrim(PagarHist) + CRLF
				cErro += "Emissao       - "+ PagarEmiss + CRLF
				cErro += "Vencimento    - "+ PagarVcto + CRLF
				cErro += "Valor         - "+ Alltrim(Str(PagarValor)) + CRLF
				cErro += " " + CRLF

				nRecnoDoc := 0

				// Grava Codigo + Descrição
				For nContador := 1 To Len(aErro)
					//Concateno as variáveis
					cObserv += aErro[nContador] + CRLF
				Next nContador

			EndIf

			If !lMsErroAuto
				cObserv := "[SE2]["+PagarOper+"] Operação finalizada com sucesso."
				nRecnoDoc := SE2->(Recno())
			EndIf
			//Grava dados na Tabela de Log
		End Transaction

	EndIf

	cPrfNum	:=	cCodPrf	+ PagarIDProc

	aAdd(aRetDados ,{PagarCNPJ})	// 1
	aAdd(aRetDados ,{PagarOper})	// 2
	aAdd(aRetDados ,{cStatus})		// 3
	aAdd(aRetDados ,{PagarIDProc})	// 4
	aAdd(aRetDados ,{cPrfNum})		// 5
	aAdd(aRetDados ,{cObserv}) 		// 6

	cHorOrd	:= Time()
	cTempo	:= ElapTime(cHorIni,cHorOrd)

	U_MGFMONITOR(cFilAnt,iif(cStatus=="N",'2','1'),GetMv("MGF_INT02F")/*cCodint*/,GetMv("MGF_INT02I")/*cCodtpint*/,iif(Len(cErro)>0,FunName() +" - ExecAuto FinA050",cObserv),cDocori,cTempo,cObserv+CRLF+cErro,nRecnoDoc,"",.F.,{cEmpAnt,cFilAnt})

Return aRetDados
