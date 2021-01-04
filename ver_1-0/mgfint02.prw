#INCLUDE 'PROTHEUS.CH'
#include "TOPCONN.CH"

#define CRLF chr(13) + chr(10)

/*
===============================================================================================
Programa.:              MGFINT02
Autor....:              Atilio Amarilla
Data.....:              19/08/2016
Descricao / Objetivo:   Integração PROTHEUS x RH Evolution
Doc. Origem:            Contrato - GAP MGFINT01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Importação de Colaboradores (Fornecedores e Clientes) e Titulos a Pagar
===============================================================================================
*/
User Function MGFINT02( cTpInt , aDados )

	Local aCampos	:= {}
	Local aRetDados	:= {}
	Local aTables	:= { "SA1" , "SA2" , "SM0" , "SE2" , "SED" }

	RPCSetType( 3 )
	RpcSetEnv( "01" , "010001" , Nil, Nil, "FIN", Nil, aTables )

	If 		cTpInt	== "C"	// Colaborador
			MGFINT02CL( aDados , @aRetDados )
	ElseIf 	cTpInt	== "P"	// Titulos a Pagar
			MGFINT02PG( aDados , @aRetDados )
	EndIf

Return aRetDados

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
	Local ColabDescUnid := FWFilialName(cEmpAnt,ColabUnidade,2)

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

	/* 
	Paulo da Mata - 07/01/2020 
	Variáveis para bloqueio SA1 ou SA2, se não existe loja MONTANA no local da Unidade 
	*/

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


	//Amostra
	//Campos obrigatorio na tabela SA1 - Clientes (Total: 23 campos obrigatorios)
	//
	// A1_COD      ok
	// A1_LOJA     ok
	// A1_TIPO     ok "F"
	// A1_NOME     ok
	// A1_NREDUZ   ok
	// A1_MUN      -faltou-
	// A1_END      ok
	// A1_EST      ok
	// A1_DDD      ok
	// A1_BAIRRO   ok
	// A1_DDI      ok
	// A1_NATUREZ  ok
	// A1_TEL      ok
	// A1_PAIS     ok
	//

	//
	// Campos obrigatorio na tabela SA2 - Fornecedor (Total: 23 campos obrigatorios)
	//
	// A2_COD
	// A2_LOJA
	// A2_TIPO
	// A2_NOME
	// A2_NREDUZ
	// A2_MUN
	// A2_END
	// A2_EST
	//
	// A2_BAIRRO
	//
	// A2_NATUREZ
	// A2_TEL
	// A2_PAIS
	//
	// A2_COD_MUN
	// A2_CEP
	// A2_INSCR   Inscricao Estadual
	// A2_CONTA   Conta Contabil    (debito)
	// A2_CODPAIS Codigo Pais       (ColabPaisBC)
	// A2_GRPTRIB Grupo Tributario  (cGrpTribSA2)
	// A2_TPESSOA Tipo de Pessoa    Fixo = "PF"
	// A2_CNAE
	// A2_ZOBSERV

	// Campos obrigatorios no dicionário

	If  cStatus <> 'N'
		aObrig_SA1 := {}
		u_MGSX3OBR("SA1", @aObrig_SA1 )
		aCamposSA1 := aClone( aObrig_SA1 )

		nAte := Len( aCamposSA1 )
		For nJK:= 1 to nAte
			cNome  := aCamposSA1[nJK]
			nAchei := aScan( aCampos, { |x| x[3] == cNome  } )
			if nAchei > 0
				aCampos[nAchei][5] := 1
			Else
				cStatus	:= "N"
				cObserv	:=	"["+cNome+"] Campo obrigatorio e sem definicao no WebService"
				nJK     := nAte +1
			Endif
		Next

	Endif

	If  cStatus <>'N'
		aObrig_SA2 := {}
		u_MGSX3OBR("SA2", @aObrig_SA2 )
		aCamposSA2 := aClone( aObrig_SA2 )

		nAte := Len( aCamposSA2 )
		For nJK := 1 to nAte
			cNome  :=  aCamposSA2[nJK]
			nAchei := aScan( aCampos, { |x| x[4] == cNome  } )
			if nAchei > 0
				aCampos[nAchei][6] := 1
			Else
				cStatus	:= "N"
				cObserv	:=	"["+cNome+"] Campo obrigatorio e sem definicao no WebService"
				nJK     := nAte +1
			Endif
		Next
	Endif

	//Campos obrigatorios verifica se estão preenchidos
	if  cStatus <> 'N'
		nAte := Len( aCampos )
		For nJK := 1 to nAte
			If ( aCampos[nJK][5] + aCampos[nJK][6] ) > 0
				If Empty( aCampos[nJK][2] )
					If ( aCampos[nJK][4] ==  "A2_INSCR"      .And. aCampos[nJK][6] = 1 )
						//campo vazio sera ajustado na gravacao como conteudo "ISENTO"
					ElseIf ( aCampos[nJK][4] ==  "A2_EMAIL"                            )
						//campo vazio ajustado
						aCampos[nJK][2] := "sem_email@marfrig.com.br"
					Else
						cNome   := aCampos[nJK][1]  + iif( Empty( aCampos[nJK][3] ), ", " +aCampos[nJK][3], "") +  iif( Empty( aCampos[nJK][4] ), ", " +aCampos[nJK][4], "" )
						cStatus	:= "N"
						cObserv	:=	"[?] " + cNome+ "/" + aCampos[nJK][8] + "=> Campo obrigatorio vazio"
						nJK     := nAte +1
					Endif
				Endif
			endif
		Next
	Endif

	lCodBen	:= GetNewPar("MGF_INT02A",.T.)	// Criação de Código diferenciado por tipo de colaborador:
	//	- Funcionário: F00001, F00002,...
	//  - Beneficiario: B00001, B00002,...
	//  - Empresa: E00001, E00002,...

	U_MFCONOUT("== Integracao RH Evolution - Colaborador ==")

	If lCodBen
		AtuSX6("C")
	EndIf

	AtuSX6A()
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

	U_MFCONOUT(" - Atencao: Status = "+cStatus+If(!Empty(cObserv)," Observacao = "+cObserv,""),"")
	
	Begin Transaction

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

							cStatus	:= "N"
							cObserv	:=	"[SA1]["+ColabOper+"] CLIENTE JA EXISTE."

							dbSelectArea("SA2")
							SA2->(DbSetOrder(3))	// A1_FILIAL+A1_CGC
							SA2->(DbGoTop())

							If SA2->( dbSeek( xFilial("SA2") + ColabCNPJ ) )
								cObserv   += CRLF + "[SA2]["+ColabOper+"] FORNECEDOR JA EXISTE."
								cCodFor   := SA2->A2_COD
								cLojFor   := SA2->A2_LOJA
								cValForne := "N" //Alterado Rafael 07/11/2018
							Else
								cObserv += CRLF + "[SA2]["+ColabOper+"] FORNECEDOR NAO EXISTE."
								cValForne := "S" //Alterado Rafael 07/11/2018
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

						If dDataBase >= CtoD("01/01/" + Alltrim(str(Year(Date() ) ))) .And. dDataBase <= cToD("30/06/" + Alltrim(str(Year(Date() ) )))
							aAdd( aMatA030 , { "A1_VENCLC", cToD("31/12/" + Alltrim(str(Year(Date()))))  , NIL } )
						Else
							aAdd( aMatA030 , { "A1_VENCLC", cToD("30/06/" + Alltrim(str(Year(Date()) + 1 )))  , NIL } )
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
					If dDataBase >= cToD("01/01/" + Alltrim(str(Year(Date() ) ))) .and. dDataBase <= cToD("30/06/" + Alltrim(str(Year(Date() )  )))
						aAdd( aMatA030 , { "A1_VENCLC", cToD("31/12/" + Alltrim(str(Year(Date()))))  , NIL } )
					Else
						aAdd( aMatA030 , { "A1_VENCLC", cToD("30/06/" + Alltrim(str(Year(Date()) + 1 )))  , NIL } )
					Endif

				Else

					If ColabOper != "E"	// Exclusão
						cStatus	:= "N"
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

							If Len(aAVISO) > 0

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
	                    		
								DisarmTransaction()
								break
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

	                    		U_MFCONOUT("Completou o Cadastro de Clientes] - Colaborador : "+;
										AllTrim(ColabNome)+" - CPF : "+Alltrim(ColabCNPJ)+" - "+;
										"com sucesso")
							Endif
							
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
							If ColabOper == "I" .And. nOpc == 3 .And. ColabTipo == "F" 
								SA1->(RecLock("SA1",.F.))
								SA1->A1_MSBLQL := If(AllTrim(ColabFilial)$cUnit,"2","1")
								SA1->(MsUnLock())
							EndIf

							// [SA1] - Na alteração, deixa desbloqueado se vier por integração 
							If ColabOper == "A" .And. nOpc == 4 .And. ColabTipo == "F"
								SA1->(RecLock("SA1",.F.))
								SA1->A1_MSBLQL := "2"
								SA1->(MsUnLock())
							EndIf

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
						cStatus	:= "N"
						cObserv	:=	"[SA2]["+ColabOper+"] FORNECEDOR JA EXISTE."
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
					aAdd( aMatA020 , { "A2_PESSOA", IIF(Len(AllTrim(ColabCNPJ))==14,"J","F") , NIL } )
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
				aAdd( aMatA020 , { "A2_NOME"	, iif( Empty(ColabNome)  ,SA2->A2_NOME,  ColabNome)		, NIL } )
				aAdd( aMatA020 , { "A2_NREDUZ"	, iif( Empty(ColabNReduz),SA2->A2_NREDUZ,  ColabNReduz)	, NIL } )
				aAdd( aMatA020 , { "A2_CONTATO"	, iif( Empty(ColabNome)  ,SA2->A2_CONTATO,ColabContato)	, NIL } )
				aAdd( aMatA020 , { "A2_END"		, iif( Empty(ColabEndereco),SA2->A2_END,  ColabEndereco), NIL } )
				aAdd( aMatA020 , { "A2_BAIRRO"	, iif( Empty(ColabBairro),SA2->A2_BAIRRO,ColabBairro)	, NIL } )
				aAdd( aMatA020 , { "A2_EST"		, iif( Empty(ColabEst)	 ,SA2->A2_EST,  ColabEst)		, NIL } )
				aAdd( aMatA020 , { "A2_COD_MUN"	, iif( Empty(ColabCodMun),SA2->A2_COD_MUN,  ColabCodMun) , NIL } )

				cMUNICIPIO := FwCutOFF( Trim( fDesc('CC2', ColabEst + ColabCodMun, 'CC2_MUN',, ColabFilial ) ), .T.)

				aAdd( aMatA020 , { "A2_MUN"		, iif( Empty(ColabCodMun),SA2->A2_MUN,  cMUNICIPIO) 	, NIL } )
				aAdd( aMatA020 , { "A2_CEP"		, iif( Empty(ColabCEP)	 ,SA2->A2_CEP,  ColabCEP)  		, NIL } )
				aAdd( aMatA020 , { "A2_TEL"		, iif( Empty(ColabTelefone),SA2->A2_TEL,  ColabTelefone), NIL } )
				aAdd( aMatA020 , { "A2_FAX"		, iif( Empty(ColabFax)	 ,SA2->A2_FAX,  ColabFax)		, NIL } )
				aAdd( aMatA020 , { "A2_EMAIL"	, iif( Empty(ColabEmail) ,iif(Empty(SA2->A2_EMAIL),"sem_email@marfrig.com.br",SA2->A2_EMAIL),  ColabEmail) 	, NIL } )
				aAdd( aMatA020 , { "A2_ZOBSERV"	, iif( Empty(ColabObs) 	 ,SA2->A2_ZOBSERV,ColabObs)		, NIL } )
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
				aAdd( aMatA020 , { "A2_DDD",     iif( Empty(ColabDDD)   ,iif( Empty(SA2->A2_DDD), "00", SA2->A2_DDD), ColabDDD)  	  , NIL } )
				aAdd( aMatA020 , { "A2_DDI"	,    iif( Empty(ColabDDI)   ,iif( Empty(SA2->A2_DDI), "55", SA2->A2_DDI), ColabDDI)  	  , NIL } )
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
				ElseIf nOpc == 4  
				       cFrase := "== Alterando o cadastro de fornecedor para o colaborador : "
				EndIf

	            U_MFCONOUT(cFrase+AllTrim(ColabNome)+" CPF : "+Alltrim(ColabCNPJ))

				MSExecAuto({|x,y| MatA020(x,y)},aMatA020,nOpc)

				If lMsErroAuto

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

						DisarmTransaction()
						break

						//***************************************************
						//Desfazer gravaçao anterior do ExecAuto SA1/Cliente
						//***************************************************
						If nRecGRVSA1 > 0
							SA1->(dbGoto(nRecGRVSA1))
							SA1->(RecLock("SA1",.F.))
							SA1->(DbDelete())
							SA1->(MsUnLock())
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

	End Transaction

	aAdd(aRetDados ,{ColabCNPJ})			// 1
	aAdd(aRetDados ,{ColabOper})			// 2
	aAdd(aRetDados ,{cStatus})				// 3
	aAdd(aRetDados ,{cCodCli+cLojCli})		// 4
	aAdd(aRetDados ,{cCodFor+cLojFor})  	// 5
	aAdd(aRetDados ,{cObserv})				// 6

	If !Empty(aLogSA1)
		U_MGFMONITOR(aLogSA1[1],aLogSA1[2],aLogSA1[3]/*cCodint*/,aLogSA1[4]/*cCodtpint*/,aLogSA1[5],aLogSA1[6],aLogSA1[7],aLogSA1[8],aLogSA1[9],aLogSA1[10],aLogSA1[11],aLogSA1[12])
	EndIf

	If !Empty(aLogSA2)
		U_MGFMONITOR(aLogSA2[1],aLogSA2[2],aLogSA2[3]/*cCodint*/,aLogSA2[4]/*cCodtpint*/,aLogSA2[5],aLogSA2[6],aLogSA2[7],aLogSA2[8],aLogSA2[9],aLogSA2[10],aLogSA2[11],aLogSA2[12])
	Endif

	If nRecnoDoc == 0
		cHorOrd	:= Time()
		cTempo	:= ElapTime(cHorIni,cHorOrd)
		nRecnoDoc := 0
		U_MGFMONITOR(cFilAnt,iif(cStatus=="N",'2','1'),GetMv("MGF_INT02F")/*cCodint*/,GetMv("MGF_INT02G")/*cCodtpint*/,iif(Len(cErro)>0,FunName() +" - ExecAuto Mata020",cObserv),cDocori,cTempo,cObserv+CRLF+cErro,nRecnoDoc,"",.F.,{cEmpAnt,cFilAnt})
	EndIf

Return aRetDados


/*/{Protheus.doc} MGFINT02PG
//TODO Descrição auto-gerada.
@author eadonato
@since 14/01/2019
@version 1.0
@return ${return}, ${return_description}
@param aDados, array, description
@param aRetDados, array, description
@type function
@description Função responsável para gravação dos dados do Título a Pagar no Protheus vindo do RHEvolution
/*/
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

				DisarmTransaction()
				break
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

Static Function AtuSX6(cTipo)

	If cTipo == "C"
		If SX6->(!DbSeek(xFilial()+"MGF_INT02B"))
			RecLock("SX6",.T.)
			SX6->X6_FIL    := ""
			SX6->X6_VAR    := "MGF_INT02B"
			SX6->X6_TIPO   := "C"
			SX6->X6_DESCRIC:= "Integração RH Evolution - Sequencial para A1_COD "
			SX6->X6_DESC1  := "Funcionário (Gerar A1_COD F00001, F00002,...     "
			//12345678901234567890123456789012345678901234567890
			SX6->X6_CONTEUD:= Strzero(1,TamSX3("A1_COD")[1]-1) //"00001"
			SX6->X6_PROPRI := "U"
			SX6->X6_PYME   := "S"
			MsUnlock()
		Endif

		If SX6->(!DbSeek(xFilial()+"MGF_INT02C"))
			RecLock("SX6",.T.)
			SX6->X6_FIL    := ""
			SX6->X6_VAR    := "MGF_INT02C"
			SX6->X6_TIPO   := "C"
			SX6->X6_DESCRIC:= "Integração RH Evolution - Sequencial para A2_COD "
			SX6->X6_DESC1  := "Funcionário (Gerar A2_COD F00001, F00002,...     "
			//12345678901234567890123456789012345678901234567890
			SX6->X6_CONTEUD:= Strzero(1,TamSX3("A1_COD")[1]-1)
			SX6->X6_PROPRI := "U"
			SX6->X6_PYME   := "S"
			MsUnlock()
		Endif

		If SX6->(!DbSeek(xFilial()+"MGF_INT02D"))
			RecLock("SX6",.T.)
			SX6->X6_FIL    := ""
			SX6->X6_VAR    := "MGF_INT02D"
			SX6->X6_TIPO   := "C"
			SX6->X6_DESCRIC:= "Integração RH Evolution - Sequencial para A2_COD "
			SX6->X6_DESC1  := "Beneficiario (Gerar A2_COD B00001, B00002,...    "
			//12345678901234567890123456789012345678901234567890
			SX6->X6_CONTEUD:= Strzero(1,TamSX3("A1_COD")[1]-1)
			SX6->X6_PROPRI := "U"
			SX6->X6_PYME   := "S"
			MsUnlock()
		Endif

		If SX6->(!DbSeek(xFilial()+"MGF_INT02E"))
			RecLock("SX6",.T.)
			SX6->X6_FIL    := ""
			SX6->X6_VAR    := "MGF_INT02E"
			SX6->X6_TIPO   := "C"
			SX6->X6_DESCRIC:= "Integração RH Evolution - Sequencial para A2_COD "
			SX6->X6_DESC1  := "Empresa (Gerar A2_COD E00001, E00002,...    "
			//12345678901234567890123456789012345678901234567890
			SX6->X6_CONTEUD:= Strzero(1,TamSX3("A1_COD")[1]-1)
			SX6->X6_PROPRI := "U"
			SX6->X6_PYME   := "S"
			MsUnlock()
		Endif

		If SX6->(!DbSeek(xFilial()+"MGF_INT02H"))
			RecLock("SX6",.T.)
			SX6->X6_FIL    := ""
			SX6->X6_VAR    := "MGF_INT02H"
			SX6->X6_TIPO   := "C"
			SX6->X6_DESCRIC:= "Integração RH Evolution - Prefixo Titulo "
			SX6->X6_DESC1  := " "
			//12345678901234567890123456789012345678901234567890
			SX6->X6_CONTEUD:= "RHE"
			SX6->X6_PROPRI := "U"
			SX6->X6_PYME   := "S"
			MsUnlock()
		Endif

		If SX6->(!DbSeek(xFilial()+"MGF_INT02K"))
			RecLock("SX6",.T.)
			SX6->X6_FIL    := ""
			SX6->X6_VAR    := "MGF_INT02K"
			SX6->X6_TIPO   := "C"
			SX6->X6_DESCRIC:= "Integração RH Evolution - Tipo Titulo "
			SX6->X6_DESC1  := " "
			//12345678901234567890123456789012345678901234567890
			SX6->X6_CONTEUD:= "DP"
			SX6->X6_PROPRI := "U"
			SX6->X6_PYME   := "S"
			MsUnlock()
		Endif

	EndIf

Return


Static Function AtuSX6A()

	If SX6->(!DbSeek(xFilial()+"MGF_INT02F"))
		_nSZ2 := U_GETSZ2()
		RecLock("SX6",.T.)
		SX6->X6_FIL    := ""
		SX6->X6_VAR    := "MGF_INT02F"
		SX6->X6_TIPO   := "C"
		SX6->X6_DESCRIC:= "Cod Integração RH Revolution Monitor"
		SX6->X6_DESC1  := ""
		//12345678901234567890123456789012345678901234567890
		SX6->X6_CONTEUD:= strzero(_nSZ2,3)
		SX6->X6_PROPRI := "U"
		SX6->X6_PYME   := "S"
		MsUnlock()
	Endif

	If SX6->(!DbSeek(xFilial()+"MGF_INT02G"))
		_nSZ3 := U_GETSZ3(strzero(_nSZ2,3))
		RecLock("SX6",.T.)
		SX6->X6_FIL    := ""
		SX6->X6_VAR    := "MGF_INT02G"
		SX6->X6_TIPO   := "C"
		SX6->X6_DESCRIC:= "Cod do Tipo Integração RH Revolution Cadastro"
		SX6->X6_DESC1  := ""
		//12345678901234567890123456789012345678901234567890
		SX6->X6_CONTEUD:= strzero(_nSZ3,3)
		SX6->X6_PROPRI := "U"
		SX6->X6_PYME   := "S"
		MsUnlock()
	Endif

	If SX6->(!DbSeek(xFilial()+"MGF_INT02I"))
		_nSZ3 := U_GETSZ3(strzero(_nSZ2,3))
		RecLock("SX6",.T.)
		SX6->X6_FIL    := ""
		SX6->X6_VAR    := "MGF_INT02I"
		SX6->X6_TIPO   := "C"
		SX6->X6_DESCRIC:= "Cod do Tipo Integração RH Revolution Titulo"
		SX6->X6_DESC1  := ""
		//12345678901234567890123456789012345678901234567890
		SX6->X6_CONTEUD:= "DP"
		SX6->X6_PROPRI := "U"
		SX6->X6_PYME   := "S"
		MsUnlock()
	Endif

Return

Static Function AtuSZ2()

	If SZ2->(!DbSeek(xFilial("SZ2")+Get("MGF_INT02F")))
		RecLock("SZ2",.T.)
		SZ2->Z2_FILIAL := xFilial("SZ2")
		SZ2->Z2_CODIGO := Get("MGF_INT02F")
		SZ2->Z2_NOME   := "RH Revolution"
		MsUnlock()
	EndIf
Return

Static Function AtuSZ3()

	If SZ3->(!DbSeek(xFilial("SZ3")+Get("MGF_INT02F")+Get("MGF_INT02G")))
		RecLock("SZ3",.T.)
		SZ3->Z3_FILIAL := xFilial("SZ3")
		SZ3->Z3_CODINTG := Get("MGF_INT02F")
		SZ3->Z3_CODTINT := Get("MGF_INT02G")
		SZ3->Z3_TPINTEG := 'Integracao Cadastro RH Revolution'
		SZ3->Z3_EMAIL	:= ''
		SZ3->Z3_FUNCAO	:= ''
		MsUnlock()
	EndIf

	If SZ3->(!DbSeek(xFilial("SZ3")+Get("MGF_INT02F")+Get("MGF_INT02I")))
		RecLock("SZ3",.T.)
		SZ3->Z3_FILIAL := xFilial("SZ3")
		SZ3->Z3_CODINTG := Get("MGF_INT02F")
		SZ3->Z3_CODTINT := Get("MGF_INT02I")
		SZ3->Z3_TPINTEG := 'Integracao Titulos RH Revolution'
		SZ3->Z3_EMAIL	:= ''
		SZ3->Z3_FUNCAO	:= ''
		MsUnlock()
	EndIf


Return


User Function teste022()

	u_MGFX3OBR("SA1")

	u_MGFX3OBR("SA2")

	MsgAlert("Processamento encerrado normalmente")

Return



/*
=====================================================================================
Programa............: MGFINT38
Autor...............: Marcelo Carneiro
Data................: 28/03/2017
Descricao / Objetivo: Integração De Cadastros
Doc. Origem.........: Contrato GAPS - MIT044- BLOQUEIO DE CADASTROS
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Pontos de Entrada para a Gravação das Tabelas ZB3 ZB2 ZB5
=====================================================================================
*/

User Function MGSX3OBR(cALIAS, aCamposOBR)
	Local   cTab := ""
	Default aCamposObr := {}

	cTab := cAlias

	If Empty( cAlias)
		U_MFCONOUT("Nao foi informado o Alias da tabela desejada")
		Return .T.
	Endif


	dbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	SX3->(dbSeek(cTab))

	If SX3->(EOF())
	    U_MFCONOUT("- Nome do alias não encontrado no dicionario")
		Return .T.
	EndIf

	While ( SX3->(!EOF()) .And. SX3->X3_ARQUIVO == cTab )

		If X3OBRIGAT(SX3->X3_CAMPO)  //.AND. X3USO(SX3->X3_USADO)
			aadd( aCamposOBR, UPPER( Trim(SX3->X3_CAMPO)  )  )
		EndIF
		SX3->(dbSkip())
	EndDo

Return Nil


User Function teste022()

	u_MGX3OBR_("SA1")

	u_MGX3OBR_("SA2")

	MsgAlert("Processamento encerrado normalmente")

Return


User Function testeSX3()

	u_MGSX3DIC("SA1")

	u_MGSX3DIC("SA2")

	MsgAlert("Processamento encerrado normalmente")

Return


/*
=====================================================================================
Programa............: MGFINT38
Autor...............: Marcelo Carneiro
Data................: 28/03/2017
Descricao / Objetivo: Integração De Cadastros
Doc. Origem.........: Contrato GAPS - MIT044- BLOQUEIO DE CADASTROS
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Pontos de Entrada para a Gravação das Tabelas ZB3 ZB2 ZB5
=====================================================================================
*/

User Function MGX3OBR_(cALIAS)
	Local nCampos   := 0

	Local nHandle
	Local cArqTxt := Criatrab(Nil, .F.)
	Local cArqGera:= "C:\temp\" + cArqTxt + ".txt"

	nHandle := MsfCreate( cArqGera, 0 )

	cTab := cAlias

	If Empty( cAlias)
		MsgAlert("Nao foi informado o Alias da tabela desejada")
		Return .T.
	Endif

	If !(nHandle > 0)
		MsgAlert("Arquivo texto nao foi criado! Verifique o erro apresentado " + chr( nHandle) )
		Return .T.
	Endif

	FWRITE( nHandle, "Campos obrigatorio na tabela " + cAlias +chr(13)+chr(10) +chr(13)+chr(10) )
	dbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	SX3->(dbSeek(cTab))

	If SX3->(EOF())
		MsgAlert("Nome do alias não encontrado no dicionario")
		Return .T.
	EndIf

	While ( SX3->(!EOF()) .And. SX3->X3_ARQUIVO == cTab )

		If X3OBRIGAT(SX3->X3_CAMPO) // .AND. X3USO(SX3->X3_USADO) .AND. !(SX3->X3_VISUAL $ ('V') ) .AND. (SX3->X3_CONTEXT <> "V"  )
			FWRITE( nHandle, SX3->X3_CAMPO +chr(13)+chr(10) )
			nCampos++
		EndIF

		SX3->(dbSkip())
	EndDo

	If nCampos > 0
		FWRITE( nHandle, "" +chr(13)+chr(10) )
	Else
		FWRITE( nHandle, "Nenhum campo encontrado! " +chr(13)+chr(10) )
	Endif

	fClose(nHandle)

	cNome := "C:\temp\" + cALIAS + "X3OBR.txt"

	If file( cNOME )
		FERASE( cNOME )
	Endif

	FRENAME( cArqGera, cNome  )

Return .T.


User Function MGSX3DIC(cALIAS)

	Local nCampos   := 0

	Local nHandle
	Local cArqTxt := Criatrab(Nil, .F.)
	Local cArqGera:= "C:\temp\" + cArqTxt + ".txt"

	nHandle := MsfCreate( cArqGera, 0 )

	cTab := cAlias

	If Empty( cAlias)
		MsgAlert("Nao foi informado o Alias da tabela desejada")
		Return .T.
	Endif

	If !(nHandle > 0)
		MsgAlert("Arquivo texto nao foi criado! Verifique o erro apresentado " + chr( nHandle) )
		Return .T.
	Endif

	FWRITE( nHandle, "Campos obrigatorio na tabela " + cAlias +chr(13)+chr(10) +chr(13)+chr(10) )
	dbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	SX3->(dbSeek(cTab))

	If SX3->(EOF())
		MsgAlert("Nome do alias não encontrado no dicionario")
		Return .T.
	EndIf

	While ( SX3->(!EOF()) .And. SX3->X3_ARQUIVO == cTab )

		If X3USO(SX3->X3_USADO) .AND. !(SX3->X3_VISUAL $ ('V') ) .AND. (SX3->X3_CONTEXT <> "V"  )  // .AND. X3OBRIGAT(SX3->X3_CAMPO)
			FWRITE( nHandle, SX3->X3_CAMPO +chr(13)+chr(10) )
			nCampos++
		EndIF

		SX3->(dbSkip())
	EndDo

	If nCampos > 0
		FWRITE( nHandle, "" +chr(13)+chr(10) )
	Else
		FWRITE( nHandle, "Nenhum campo encontrado! " +chr(13)+chr(10) )
	Endif

	fClose(nHandle)

	cNome := "C:\temp\" + cALIAS + "X3OBR.txt"

	If file( cNOME )
		FERASE( cNOME )
	Endif

	FRENAME( cArqGera, cNome  )

Return .T.