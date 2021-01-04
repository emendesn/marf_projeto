#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF06R07	�Autor  �Geronimo Benedito Alves																	�Data �  18/12/17  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: Financeiro - Contas a Pagar - Relacao Fatura					(Modulo 06-FIN).   ���
//���			� Criado a partir do relatorio padrao FinR295. Este relatorio padrao Mostra as faturas. Adicionando � ela, query que mostra tambem ���
//���			� Os titulos que nao geraram faturas, e tambem os titulos que compoem cada fatura												   ���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���  Obs		� As secoes ReportDef e ReportPrint foram mantidas para manter compatibilidade com o fonte padrao FinR295, facilitando em futuras  ���
//���			� atualizacoes, a comparacao e a evolucao deste fonte, com o fonte padrao														   ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																											  ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF06R07()
	MsgRun("Aguarde!!! Lendo as faturas e seus titulos"	,,{ || Processar() })
Return

Static Function Processar()

	Local cQuery		:= ""
	Local cAliasQry1	:= GetNextAlias()
	Local cAliasQry2	:= GetNextAlias()
	Local cAliasQry3	:= ""
	//Local cFilterUser := oSection1:GetSqlExp()

	Local lGestao	:= ( FWSizeFilial() > 2 ) 	// Indica se usa Gestao Corporativa
	Local aTmpFil	:= {}
	Local cTmpSE2Fil := ""
	Local nX 		:= 1
	Local cFilSE2	:= ""
	Local nRegSM0	:= SM0->(Recno())
	Local cRngFilSE2 := ""
	Local cFilSel := ""

	Local cFilQry1 := ""
	Local cPreQry1 := ""
	Local cNumQry1 := ""
	Local cForQry1 := ""
	Local cLojQry1 := ""
	Local cTipQry1 := ""
	Local cParQry1 := ""
	Local cMdaQry1 := ""
	Local cPreAux  := ""
	Local cTipAux  := ""
	Local cNumAux  := ""
	Local cFilOrg  := ""

	Local nVlAbat := 0
	Local cLojas := ""
	Local aFilFat := {}
	Local lFilOrig := SE5->( FieldPos( "E5_FILORIG" ) ) >0 .And. SE2->( FieldPos( "E2_FILORIG" ) ) > 0

	Local aCampos		:= {}
	Local cCodFil		:= cFilAnt
	Local lQuery		:= IfDefTopCTB() // verificar se pode executar query (TOPCONN)
	Local lSE2Excl		:= Iif( lGestao, FWModeAccess("SE2",1) == "E", FWModeAccess("SE2",3) == "E")
	//Local cQueryEmb1	:= " "
	//Local cQueryEmb2	:= " "
	//Local cQueryEmb3	:= " "
	Local _E2FORNEWH	:= " "
	Local _E2LOJAWH		:= " "
	Local _E2EMIS1WH	:= " "
	Local _E2PREFIWH	:= " "
	Local _E2NATURWH	:= " "
	Local _E2VENCTWH	:= " "  


	//If oSection1:GetOrder()==1
	//	cOrder := "E2_FILIAL,E2_FORNECE,E2_LOJA,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO"
	//Else
	//	cOrder := "E2_FILIAL,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA"
	//EndIf


	//Local cChave	:= "E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
	Local cOrder	:= "E2_FILIAL,E2_FORNECE,E2_LOJA,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO"
	DbSelectArea("SE2")
	DbSetOrder(6)		//  E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
	DbGotop()

	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""
	Private _aRetBKP	:= {}  , _Desc_Stat

	Aadd(_aDefinePl, "Contas a Pagar - Relacao Fatura"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Relacao Fatura"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {}									)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel

//	_aDefinePl[3]	:=  {"Relacao Fatura" , "Titulos" }		//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
//	Aadd(_aDefinePl, {}									)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
//	_aDefinePl[4]	:=  {"Relacao Fatura" , "Titulos" }		//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
//	Aadd(_aDefinePl, {}									)	//05-	Array das Arrays que contem as colunas serao mostradas em cada aba da planilha. Se a Array _aDefinePl e/ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry
//	Aadd(_aDefinePl, { {} , {} }  )							//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  

	_aDefinePl[3]	:=  {"Relacao Fatura" ,"Titulos em Fatura"  ,"Titulos Sem Fatura" }		//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {}									)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	_aDefinePl[4]	:=  {"Relacao Fatura" ,"Titulos em Fatura"  ,"Titulos Sem Fatura"  }		//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}									)	//05-	Array das Arrays que contem as colunas serao mostradas em cada aba da planilha. Se a Array _aDefinePl e/ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry
	Aadd(_aDefinePl, {   {} , {} , {}   }  				)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  

	//_aDefinePl[6,1]	:=  { ||  AllTrim(FATURTITUL) == "TITULO EM FATURA" .OR. AllTrim(FATURTITUL) == "FATURA"  }		// [06,01]  
	//_aDefinePl[6,2]	:=  { ||  AllTrim(FATURTITUL) == "TITULO SEM FATURA"  }											// [06,02]  
	_aDefinePl[6,1]	:=  { || AllTrim(FATURTITUL) == "FATURA"  }														// [06,01]  
	_aDefinePl[6,2]	:=  { || AllTrim(FATURTITUL) == "TITULO EM FATURA" }											// [06,02]  
	_aDefinePl[6,3]	:=  { || AllTrim(FATURTITUL) == "TITULO SEM FATURA" }											// [06,02]  
`
	_nInterval	:= 35										//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""
	
	Private _cCODFILIA
	Private NumRegistr	:= 0

	Private cNomArq	:= CriaTrab(,.F.)

	AFILFAT		:= {}
	cTipAux		:= ""
	cFilSE2		:= ""
	cPreAux  := ""
	cNumAux  := ""
	cCodFil	:= cFilAnt

	_Desc_Stat := " CASE "	+CRLF
	_Desc_Stat += "	WHEN A.STATUS_TITULO = 1 "	+CRLF
	_Desc_Stat += "			THEN 'TITULO EM ABERTO' "	+CRLF
	_Desc_Stat += "	WHEN A.STATUS_TITULO = 2 "	+CRLF
	_Desc_Stat += "			THEN 'BAIXADO PARCIALMENTE' "	+CRLF
	_Desc_Stat += "	WHEN A.STATUS_TITULO = 3 "	+CRLF
	_Desc_Stat += "			THEN 'TITULO BAIXADO' "	+CRLF
	_Desc_Stat += "	WHEN A.STATUS_TITULO = 4 "	+CRLF
	_Desc_Stat += "			THEN 'TITULO EM BORDERO' "	+CRLF
	_Desc_Stat += "	WHEN A.STATUS_TITULO = 5 "	+CRLF
	_Desc_Stat += "			THEN 'ADIANTAMENTO COM SALDO'
	_Desc_Stat += "	WHEN A.STATUS_TITULO = 6 "	+CRLF
	_Desc_Stat += "			THEN 'TITULO BAIXADO PARCIALMENTE E EM BORDERO' "	+CRLF
	_Desc_Stat += "	ELSE NULL "	+CRLF
	_Desc_Stat += " END					AS DESCSTATUS "	+CRLF

	_E2_VLCRUZ := " CASE "											+CRLF
	_E2_VLCRUZ += "	WHEN A.TX_MOEDA = 0 "							+CRLF
	_E2_VLCRUZ += "			THEN A.VLR_TITULO "						+CRLF
	_E2_VLCRUZ += "	ELSE "											+CRLF
	_E2_VLCRUZ += "			A.VLR_TITULO * COALESCE(A.TX_MOEDA,1) "	+CRLF  
	_E2_VLCRUZ += " END				AS E2_VLCRUZ "					+CRLF
	
	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			02											 03							 04	 05		06	 07					 08	 09		
	AADD(_aCampoQry, {"E2_FILIAL"	,"COD_FILIAL				as E2_FILIAL"	,"Filial"					,"C",006	,0	,""						,	,})
	AADD(_aCampoQry, {"A1_NOME"		,"NOM_FILIAL				as A1_NOME"		,"Nome da Filial"			,"C",041	,0	,""						,	,})
	AADD(_aCampoQry, {"A1_NOME"		,_Desc_Stat 								,"Status Titulo"			,"C",040	,0	,""						,	,})
	AADD(_aCampoQry, {"E2_FORNECE"	,"COD_FORNECEDOR			as E2_FORNECE"	,"Codigo Fornecedor"		,"C",006	,0	,""						,	,})
	AADD(_aCampoQry, {"E2_LOJA"		,"COD_LOJA					as E2_LOJA"		,"Loja"						,"C",002	,0	,""						,	,})
	AADD(_aCampoQry, {"E2_NOMFOR"	,"NOM_FORNECEDOR			as E2_NOMFOR"	,"Nome do Fornecedor"		,"C",020	,0	,""						,	,})
	AADD(_aCampoQry, {"E2_NATUREZ"	,"NATUREZA					as E2_NATUREZ"	,"Natureza"					,"C",010	,0	,""						,	,})
	AADD(_aCampoQry, {"A1_NREDUZ"	,"FATURTITUL"								,"Fatura/Titulo"			,"C",017	,0	,""						,	,})
	AADD(_aCampoQry, {"E2_PREFIXO"	,"PREFIXO					as E2_PREFIXO"	,"Prefixo"					,"C",003	,0	,""						,	,})
	AADD(_aCampoQry, {"E2_NUM"		,"NUM_TITULO				as E2_NUM"		,"N� Titulo"				,"C",009	,0	,""						,	,})
	AADD(_aCampoQry, {"E2_PARCELA"	,"NUM_PARCELA				as E2_PARCELA"	,"Parcela"					,"C",002	,0	,""						,	,})
	AADD(_aCampoQry, {"E2_TIPO"		,"E2_TIPO"									,"Tipo do Titulo"			,"C",003	,0	,""						,	,})
	AADD(_aCampoQry, {"E2_VENCREA"	,"DT_VENCIMENTO_REAL		as E2_VENCREA"	,"Vencimento Real"			,"D",008	,0	,""						,	,})
	AADD(_aCampoQry, {"E2_FATPREF"	,"E2_FATPREF"								,"Prefixo Fatura"			,"C",003	,0	,""						,	,})
	AADD(_aCampoQry, {"E2_FATURA"	,"E2_FATURA"								,"N� da Fatura"				,"C",009	,0	,""						,	,})
	AADD(_aCampoQry, {"E2_TIPOFAT"	,"E2_TIPOFAT"	  `							,"Tipo da Fatura"			,"C",003	,0	,""						,	,})
	AADD(_aCampoQry, {"E2_MOEDA"	,"COD_MOEDA					as E2_MOEDA"	,"Cod. Moeda"				,"N",004	,0	,"@E 9999", 					,})
	AADD(_aCampoQry, {"AFK_GRTDE"	,"NOM_MOEDA"								,"Nome Moeda"				,"C",005	,0	,""						,	,})
	AADD(_aCampoQry, {"E2_VALOR"	,"VLR_TITULO				as E2_VALOR"	,"Vlr.Titulo"				,"N",017	,2	,"@E 99,999,999,999.99"	,	,})
	AADD(_aCampoQry, {"E2_VLCRUZ"	,_E2_VLCRUZ									,"Vlr Titulo em R$"			,"N",017	,2	,"@E 99,999,999,999.99"	,	,})
	AADD(_aCampoQry, {"E2_ACRESC"	,"VLR_ACRESCIMO				as E2_ACRESC"	,"Acrescimo"				,"N",017	,2	,"@E 99,999,999,999.99"	,	,})
	AADD(_aCampoQry, {"E2_DECRESC"	,"VLR_DECRESCIMO			as E2_DECRESC"	,"Decrescimo"				,"N",017	,2	,"@E 99,999,999,999.99"	,	,})
	AADD(_aCampoQry, {"E2_ISS"		,"VLR_ISS					as E2_ISS"		,"Iss"						,"N",017	,2	,"@E 99,999,999,999.99"	,	,})
	AADD(_aCampoQry, {"E2_IRRF"		,"VLR_IRRF					as E2_IRRF"		,"Irpf"						,"N",017	,2	,"@E 99,999,999,999.99"	,	,})
	AADD(_aCampoQry, {"E2_INSS"		,"VLR_INSS					as E2_INSS"		,"Inss"						,"N",017	,2	,"@E 99,999,999,999.99"	,	,})
	AADD(_aCampoQry, {"E2_COFINS"	,"VLR_COFINS				as E2_COFINS"	,"Cofins"					,"N",017	,2	,"@E 99,999,999,999.99"	,	,})
	AADD(_aCampoQry, {"E2_PIS"		,"VLR_PIS					as E2_PIS"		,"Pis"						,"N",017	,2	,"@E 99,999,999,999.99"	,	,})
	AADD(_aCampoQry, {"E2_CSLL"		,"VLR_CSLL					as E2_CSLL"		,"Csll"						,"N",017	,2	,"@E 99,999,999,999.99"	,	,})
	AADD(_aCampoQry, {"E2_JUROS"	,"VLR_JUROS					as E2_JUROS"	,"Juros"					,"N",017	,2	,"@E 99,999,999,999.99"	,	,})
	AADD(_aCampoQry, {"E2_DESCONT"	,"VLR_DESCONT				as E2_DESCONT"	,"Desconto"					,"N",017	,2	,"@E 99,999,999,999.99"	,	,})
	AADD(_aCampoQry, {"E2_MULTA"	,"VLR_MULTA					as E2_MULTA"	,"Multa"					,"N",017	,2	,"@E 99,999,999,999.99"	,	,})
	AADD(_aCampoQry, {"E2_VALLIQ"	,"VLR_LIQUIDADO				as E2_VALLIQ"	,"Valor Liquido da Baixa"	,"N",017	,2	,"@E 99,999,999,999.99"	,	,})
	AADD(_aCampoQry, {"E2_SALDO"	,"VLR_SALDO					as E2_SALDO"	,"Saldo"					,"N",017	,2	,"@E 99,999,999,999.99"	,	,})
	AADD(_aCampoQry, {"E2_BAIXA"	,"DT_PAGAMENTO				as E2_BAIXA"	,"Data da Baixa"			,"D",008	,0	,""						,	,})
	AADD(_aCampoQry, {"E2_FORBCO"	,"COD_BANCO_FORNECEDOR		as E2_FORBCO"	,"Banco do Fornecedor"		,"C",003	,0	,""						,	,})
	AADD(_aCampoQry, {"E2_FORAGE"	,"COD_AGENCIA_FORNECEDOR	as E2_FORAGE"	,"Agencia Bancaria Fornec."	,"C",005	,0	,""						,	,})
	AADD(_aCampoQry, {"E2_FORCTA"	,"COD_CONTA_FORNECEDOR		as E2_FORCTA"	,"Conta do Fornecedor"		,"C",010	,0	,""						,	,})
	AADD(_aCampoQry, {"E2_FCTADV"	,"COD_DV_CONTA_FORNECEDOR 	as E2_FCTADV"	,"Digito Verificador Conta"	,"C",002	,0	,""						,	,})
	AADD(_aCampoQry, {"E2_FAGEDV"	,"COD_DV_AGENCIA_FORNECEDOR	as E2_FAGEDV"	,"Digito Verif. Agencia"	,"C",001	,0	,""						,	,})
	AADD(_aCampoQry, {"E2_EMISSAO"	,"DT_EMISSAO				as E2_EMISSAO"	,"Data Emissao"				,"D",008	,0	,""						,	,})
	AADD(_aCampoQry, {"E2_EMIS1"	,"E2_EMIS1"									,"Data Contabilizacao"		,"D",008	,0	,""						,	,})
	AADD(_aCampoQry, {"E2_VENCTO"	,"E2_VENCIMENTO 			as E2_VENCTO "	,"Data Vencimento"			,"D",008	,0	,""						,	,})
	AADD(_aCampoQry, {"D2_DOC"		," '999999999' 				as SEQUENCIA "	,"Numero Sequencial"		,"C",009	,0	,""						,	,})

	aAdd(_aParambox,{1,"Cod. Fornecedor Inicial"			,Space(tamSx3("A2_COD")[1])		,"@!"	,"" 													,"CF8A2"	,"",050,.F.})  
	aAdd(_aParambox,{1,"Loja Fornecedor Inicial"			,Space(tamSx3("A2_LOJA")[1])	,"@!"	,"" 													,"	"		,"",050,.F.})  
	aAdd(_aParambox,{1,"Cod. Fornecedor Final"				,Space(tamSx3("A2_COD")[1])		,"@!"	,"U_VLFIMMAI(MV_PAR01, MV_PAR03, 'Cod.Fornecedor')"		,"CF8A2"	,"",050,.F.})
	aAdd(_aParambox,{1,"Loja Fornecedor Final"				,Space(tamSx3("A2_LOJA")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR02, MV_PAR04, 'Loja Fornecedor')"	,"	"		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Emissao Inicial"				,Ctod("")						,""		,"" 													,""			,"",050,.F.})
	aAdd(_aParambox,{1,"Data Emissao Final"					,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Data Emissao')"	,""			,"",050,.F.})
	aAdd(_aParambox,{1,"Prefixo Inicial"					,Space(tamSx3("E2_PREFIXO")[1])	,"@!"	,""														,"	"		,"",050,.F.})  
	aAdd(_aParambox,{1,"Prefixo Final"						,Space(tamSx3("E2_PREFIXO")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR07, MV_PAR08, 'Prefixo')"	,"	"		,"",050,.F.})  
	aAdd(_aParambox,{1,"Natureza Inicial"					,Space(tamSx3("E2_NATUREZ")[1])	,"@!"	,""														,"SED"		,"",050,.F.})  
	aAdd(_aParambox,{1,"Natureza Final"						,Space(tamSx3("E2_NATUREZ")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR09, MV_PAR10, 'Natureza')"	,"SED"		,"",050,.F.})  
	aAdd(_aParambox,{3,"Imprime baixadas?(Saldo Zerado)"	,Iif(Set(_SET_DELETED),1,2), {"Sim","Nao" }	,100, "",.F.})
	aAdd(_aParambox,{3,"Seleciona Filiais ?"				,Iif(Set(_SET_DELETED),1,2), {"Sim","Nao" }	,100, "",.F.})
	aAdd(_aParambox,{1,"Vencimento Real Inicial Fatura"		,Ctod("")						,""		,"" 													,""			,"",050,.F.})
	aAdd(_aParambox,{1,"Vencimento Real Final Fatura"			,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR13, MV_PAR14, 'Data Vencimento')"	,""			,"",050,.F.})
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif
	
	cQuery	:= ""		// Limpo variavel para nao conflitar com a parte do fonte migrada do relatorio padrao finr295
	
	//_bCpoExce2	:= U_CpoExcel(_aCampoQry, 2)	// Funcao que cria o code block que ira gerar as linhas de detalhe da planilha excel, baseado no registro da tabela temporaria sobre a qual o ponteiro esteja posicionado.

	If Empty(_aRet[4])
		_aRet[4]	:= "ZZ"
	Endif

	_aRetBKP	:= aclone(_aRet)

	IF Empty(_aRetBKP[6]) .and. Empty(_aRetBKP[14])
		MsgStop("� obrigatorio o preenchimento do parametro data de emissao final e/ou do parametro data de vencimento real final.")
		Return.F.

	ElseIf ( !Empty(_aRetBKP[6]) .and.  !U_VLDTINIF(stod(_aRetBKP[5]), stod(_aRetBKP[6]), _nInterval) ) .or. ( !Empty(_aRetBKP[14]) .and.  !U_VLDTINIF(stod(_aRetBKP[13]), stod(_aRetBKP[14]), _nInterval) )
		Return.F.

	ElseIf _aRetBKP[5] > _aRetBKP[6]
		MsgStop("A Data de Emissao Inicial, nao pode ser maior que a data de emissao Final.")
		Return.F.

	ElseIf _aRetBKP[13] > _aRetBKP[14]
		MsgStop("A Data de Vencimento Real Inicial, nao pode ser maior que a data de Vencimento Real Final.")
		Return.F.
	Endif

	//If _aRetBKP[15] == 1	// Parametro que define a ordem em que a planilha sera gerada
	//	cOrder := "E2_FILIAL,E2_FORNECE,E2_LOJA,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO"
	//	cChave := "E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
	//Else
	//	cOrder := "E2_FILIAL,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA"
	//	cChave := "E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA"
	//EndIf

	AADD( aCampos , { "E2_FILIAL"	,"C", TamSX3("E2_FILIAL")[1]	,TamSX3("E2_FILIAL")[2]		} )
	AADD( aCampos , { "A1_NOME"	,"C", 040						,000							} )
	AADD( aCampos , { "DESCSTATUS"	,"C", 040						,000							} )
	AADD( aCampos , { "E2_FORNECE"	,"C", TamSX3("E2_FORNECE")[1]	,TamSX3("E2_FORNECE")[2]		} )
	AADD( aCampos , { "E2_LOJA"	,"C", TamSX3("E2_LOJA")[1]		,TamSX3("E2_LOJA")[2]		} )
	AADD( aCampos , { "E2_NOMFOR"	,"C", TamSX3("E2_NOMFOR")[1]	,TamSX3("E2_NOMFOR")[2]		} )
	AADD( aCampos , { "E2_NATUREZ"	,"C", TamSX3("E2_NATUREZ")[1]	,TamSX3("E2_NATUREZ")[2]		} )
	AADD( aCampos , { "FATURTITUL"	,"C", 017						,000							} )
	AADD( aCampos , { "E2_PREFIXO"	,"C", TamSX3("E2_PREFIXO")[1]	,TamSX3("E2_PREFIXO")[2]		} )
	AADD( aCampos , { "E2_NUM"		,"C", TamSX3("E2_NUM")[1]		,TamSX3("E2_NUM")[2]			} )
	AADD( aCampos , { "E2_PARCELA"	,"C", TamSX3("E2_PARCELA")[1]	,TamSX3("E2_PARCELA")[2]		} )
	AADD( aCampos , { "E2_TIPO"	,"C", TamSX3("E2_TIPO")[1]		,TamSX3("E2_TIPO")[2]		} )
	AADD( aCampos , { "E2_FATPREF"	,"C", TamSX3("E2_FATPREF")[1]	,TamSX3("E2_FATPREF")[2]		} )
	AADD( aCampos , { "E2_FATURA"	,"C", TamSX3("E2_FATURA")[1]	,TamSX3("E2_FATURA")[2]		} )
	AADD( aCampos , { "E2_TIPOFAT"	,"C", TamSX3("E2_TIPOFAT")[1]	,TamSX3("E2_TIPOFAT")[2]		} )
	AADD( aCampos , { "E2_VENCREA"	,"C", TamSX3("E2_VENCREA")[1]	,TamSX3("E2_VENCREA")[2]		} )
	AADD( aCampos , { "E2_MOEDA"	,"N", TamSX3("E2_MOEDA")[1]		,TamSX3("E2_MOEDA")[2]		} )
	AADD( aCampos , { "NOM_MOEDA"	,"C", 005						,000							} )
	AADD( aCampos , { "E2_VALOR"	,"N", TamSX3("E2_VALOR")[1]		,TamSX3("E2_VALOR")[2]		} )
	AADD( aCampos , { "E2_VLCRUZ"	,"N", TamSX3("E2_VLCRUZ")[1]	,TamSX3("E2_VLCRUZ")[2]		} )
	AADD( aCampos , { "E2_ACRESC"	,"N", TamSX3("E2_ACRESC")[1]	,TamSX3("E2_ACRESC")[2]		} )
	AADD( aCampos , { "E2_DECRESC"	,"N", TamSX3("E2_DECRESC")[1]	,TamSX3("E2_DECRESC")[2]		} )
	AADD( aCampos , { "E2_ISS"		,"N", TamSX3("E2_ISS")[1]		,TamSX3("E2_ISS")[2]			} )
	AADD( aCampos , { "E2_IRRF"	,"N", TamSX3("E2_IRRF")[1]		,TamSX3("E2_IRRF")[2]		} )
	AADD( aCampos , { "E2_INSS"	,"N", TamSX3("E2_INSS")[1]		,TamSX3("E2_INSS")[2]		} )
	AADD( aCampos , { "E2_COFINS"	,"N", TamSX3("E2_COFINS")[1]	,TamSX3("E2_COFINS")[2]		} )
	AADD( aCampos , { "E2_PIS"		,"N", TamSX3("E2_PIS")[1]		,TamSX3("E2_PIS")[2]			} )
	AADD( aCampos , { "E2_CSLL"	,"N", TamSX3("E2_CSLL")[1]		,TamSX3("E2_CSLL")[2]		} )
	AADD( aCampos , { "E2_JUROS"	,"N", TamSX3("E2_JUROS")[1]		,TamSX3("E2_JUROS")[2]		} )
	AADD( aCampos , { "E2_DESCONT"	,"N", TamSX3("E2_DESCONT")[1]	,TamSX3("E2_DESCONT")[2]		} )
	AADD( aCampos , { "E2_MULTA"	,"N", TamSX3("E2_MULTA")[1]		,TamSX3("E2_MULTA")[2]		} )
	AADD( aCampos , { "E2_VALLIQ"	,"N", TamSX3("E2_VALLIQ")[1]	,TamSX3("E2_VALLIQ")[2]		} )
	AADD( aCampos , { "E2_SALDO"	,"N", TamSX3("E2_SALDO")[1]		,TamSX3("E2_SALDO")[2]		} )
	AADD( aCampos , { "E2_BAIXA"	,"C", TamSX3("E2_BAIXA")[1]		,TamSX3("E2_BAIXA")[2]		} )
	AADD( aCampos , { "E2_FORBCO"	,"C", TamSX3("E2_FORBCO")[1]	,TamSX3("E2_FORBCO")[2]		} )
	AADD( aCampos , { "E2_FORAGE"	,"C", TamSX3("E2_FORAGE")[1]	,TamSX3("E2_FORAGE")[2]		} )
	AADD( aCampos , { "E2_FORCTA"	,"C", TamSX3("E2_FORCTA")[1]	,TamSX3("E2_FORCTA")[2]		} )
	AADD( aCampos , { "E2_FCTADV"	,"C", TamSX3("E2_FCTADV")[1]	,TamSX3("E2_FCTADV")[2]		} )
	AADD( aCampos , { "E2_FAGEDV"	,"C", TamSX3("E2_FAGEDV")[1]	,TamSX3("E2_FAGEDV")[2]		} )
	AADD( aCampos , { "E2_EMISSAO"	,"C", TamSX3("E2_EMISSAO")[1]	,TamSX3("E2_EMISSAO")[2]		} )
	AADD( aCampos , { "E2_EMIS1"	,"C", TamSX3("E2_EMIS1")[1]		,TamSX3("E2_EMIS1")[2]		} )
	AADD( aCampos , { "E2_VENCTO"	,"C", TamSX3("E2_VENCTO")[1]	,TamSX3("E2_VENCTO")[2]		} )
	AADD( aCampos , { "SEQUENCIA"	,"C", 9							,0		} )	

	DbSelectArea("SE2")
	DbSetOrder(6)		//  E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
	DbGotop()

	If Select("TRB") > 0 ; dbSelectArea("TRB") ; dbCloseArea() ; EndIf
	cNomArq := CriaTrab(,.F.)
	dbCreate( cNomArq , aCampos , "TOPCONN" )
	dbUseArea(.T. , "TOPCONN" , cNomArq , "TRB" ,.T. ,.F. )
	//dbCreateIndex( cNomArq , cChave )
	dbSelectArea( "TRB" )
	//dbSetOrder(1)

	nRegSM0 := SM0->(Recno())
	If (lQuery .and. lSE2Excl .and. _aRetBKP[12] == 1)
		If FindFunction("FwSelectGC")
			_aSelFil := FwSelectGC()
		Else
			_aSelFil := AdmGetFil(.F.,.F.,"SA2")
		Endif
	Endif
	If Empty(_aSelFil)
		_aSelFil := {cCodFil}
	Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	SM0->(DbGoTo(nRegSM0))

	If Len(_aSelFil) > 1
		cRngFilSE2 := GetRngFil(_aSelFil,"SE2",.T.,@cTmpSE2Fil)
		aAdd(aTmpFil,cTmpSE2Fil)
		aSM0 := FWLoadSM0()
		nTamEmp := Len(FWSM0LayOut(,1))
		nTamUnNeg := Len(FWSM0LayOut(,2))
		For nX := 1 To Len(_aSelFil)
			nLinha := Ascan(aSM0,{|sm0|,sm0[SM0_CODFIL] == _aSelFil[nX]})
			If nLinha > 0
				cFilSel := Substr(aSM0[nLinha,SM0_CODFIL],1,nTamEmp)
				cFilSel += " "
				cFilSel += Substr(aSM0[nLinha,SM0_CODFIL],nTamEmp + 1,nTamUnNeg)
				cFilSel += " "
				cFilSel += Substr(aSM0[nLinha,SM0_CODFIL],nTamEmp + nTamUnNeg + 1)
				//			oSecFil:PrintLine()
			Endif
		Next
		cFilSE2 := " E2_FILIAL "+ cRngFilSE2 + " AND "
	Else
		cFilSE2 := " E2_FILIAL = '"+ xFilial("SE2",_aSelFil[1]) + "' AND "
	Endif

	If !empty(_aRetBKP[3])
		_E2FORNEWH	:= " E2_FORNECE	between '" + AllTrim(_aRetBKP[01]) + "' AND '" + AllTrim(_aRetBKP[03]) + "' AND "
	Endif
	If !empty(_aRetBKP[4])
		_E2LOJAWH	:= " E2_LOJA		between '" + AllTrim(_aRetBKP[02]) + "' AND '" + AllTrim(_aRetBKP[04]) + "' AND "
	Endif
	If !empty(_aRetBKP[6])
		_E2EMIS1WH	:= " E2_EMIS1  	between '" + AllTrim(_aRetBKP[05]) + "' AND '" + AllTrim(_aRetBKP[06]) + "' AND "
	Endif
	If !empty(_aRetBKP[8])
		_E2PREFIWH	:= " E2_PREFIXO	between '" + AllTrim(_aRetBKP[07]) + "' AND '" + AllTrim(_aRetBKP[08]) + "' AND "
	Endif
	If !empty(_aRetBKP[10])
		_E2NATURWH	:= " E2_NATUREZ	between '" + AllTrim(_aRetBKP[09]) + "' AND '" + AllTrim(_aRetBKP[10]) + "' AND "
	Endif
	If !empty(_aRetBKP[14])
		_E2VENCTWH	:= " E2_VENCREA		between '" + AllTrim(_aRetBKP[13]) + "' AND '" + AllTrim(_aRetBKP[14]) + "' AND "
	Endif

	cFilSE2 := "%"+ cFilSE2 +_E2FORNEWH +_E2LOJAWH +_E2EMIS1WH +_E2PREFIWH +_E2NATURWH +_E2VENCTWH  +"%"

	//Baixados?
	If _aRetBKP[11] == 1
		cQuery += " AND E2_SALDO = 0 "
	Else
		cQuery += " AND E2_SALDO <> 0 "	
	EndIf

	cQuery += " ORDER BY "+cOrder
	cQuery := "%" + cQuery + "%"
	cLojas := "% between " + Iif(AllTrim(_aRetBKP[02]) == "", "''", "'"+_aRetBKP[02]+"'") + " AND " +;
	Iif(AllTrim(_aRetBKP[04]) == "", "''", "'"+_aRetBKP[04]+"'") + "%" 

	IF !Empty( Select( cAliasQry1 ) )
		DbSelectArea( cAliasQry1 )
		DbCloseArea()
	ENDIF

	BeginSql Alias cAliasQry1
		SELECT SE2.*
		FROM  %table:SE2% SE2
		WHERE	%exp:cFilSE2%

		E2_FATURA = 'NOTFAT' AND
		SE2.%NotDel% 
		%Exp:cQuery%
	EndSql

	aQuery := getLastQuery()
	cQueryEmb1 := aQuery[2]		// obtem a query do embebed
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +"query1_faturas.TXT",cQueryEmb1)

	cFilQry1	:= (cAliasQry1)->E2_FILIAL
	cA1_NOME	:= FWFilialName( , (cAliasQry1)->E2_FILIAL )
	cForQry1	:= (cAliasQry1)->E2_FORNECE
	cLojQry1	:= (cAliasQry1)->E2_LOJA
	cNaturQry1	:= (cAliasQry1)->E2_NATUREZ			// Secao 01
	cNomFoQry1	:= (cAliasQry1)->E2_NOMFOR			// Secao 01
	cPreQry1	:= (cAliasQry1)->E2_PREFIXO
	cNumQry1	:= (cAliasQry1)->E2_NUM
	cParQry1	:= (cAliasQry1)->E2_PARCELA
	cTipQry1	:= (cAliasQry1)->E2_TIPO
	dDContQry1	:= (cAliasQry1)->E2_EMIS1			// Secao 01
	dVRealQry1	:= (cAliasQry1)->E2_VENCREA			// Secao 01
	nVCruzQry1	:= (cAliasQry1)->E2_VLCRUZ			// Secao 01
	cMdaQry1	:= (cAliasQry1)->E2_MOEDA
	nValorQry1	:= (cAliasQry1)->E2_VALOR			// Secao 01
	nSaldoQry1	:= (cAliasQry1)->E2_SALDO			// Secao 01

	(cAliasQry1)->(DbGoTop())
	While !(cAliasQry1)->(Eof())

		If lFilOrig
			cFilOrg := (cAliasQry1)->E2_FILORIG
		EndIf 

		If (cFilQry1+cForQry1+cLojQry1+cPreQry1+cNumQry1+cTipQry1);
		== ((cAliasQry1)->E2_FILIAL+	(cAliasQry1)->E2_FORNECE+(cAliasQry1)->E2_LOJA;
		+  (cAliasQry1)->E2_PREFIXO+(cAliasQry1)->E2_NUM;
		+  (cAliasQry1)->E2_TIPO) .Or.;
		(cFilQry1+cPreQry1+cNumQry1+cTipQry1+cForQry1+cLojQry1);
		== ((cAliasQry1)->E2_FILIAL+	(cAliasQry1)->E2_PREFIXO+(cAliasQry1)->E2_NUM;
		+  (cAliasQry1)->E2_TIPO+(cAliasQry1)->E2_FORNECE+(cAliasQry1)->E2_LOJA)

			DbSelectArea("TRB")
			Reclock("TRB",.T.)
			TRB->E2_FILIAL	:= (cAliasQry1)->E2_FILIAL			// Secao Filial
			TRB->A1_NOME	:= FWFilialName(  , (cAliasQry1)->E2_FILIAL )						// Secao Filial
			TRB->DESCSTATUS	:= DESCSTATUS(cAliasQry1) 
			TRB->E2_FORNECE	:= (cAliasQry1)->E2_FORNECE			// Secao 01
			TRB->E2_LOJA	:= (cAliasQry1)->E2_LOJA			// Secao 01 
			TRB->E2_NOMFOR	:= (cAliasQry1)->E2_NOMFOR			// Secao 01
			TRB->E2_NATUREZ	:= (cAliasQry1)->E2_NATUREZ			// Secao 01
			TRB->FATURTITUL	:= "FATURA"
			TRB->E2_PREFIXO	:= (cAliasQry1)->E2_PREFIXO			// Secao 01
			TRB->E2_NUM		:= (cAliasQry1)->E2_NUM				// Secao 01
			TRB->E2_PARCELA	:= (cAliasQry1)->E2_PARCELA			// Secao 01
			TRB->E2_TIPO	:= (cAliasQry1)->E2_TIPO			// Secao 01
			TRB->E2_FATPREF	:= "  "			// Secao 01
			TRB->E2_FATURA	:= "  "			// Secao 01
			TRB->E2_TIPOFAT	:= "  "			// Secao 01
			TRB->E2_VENCREA	:= (cAliasQry1)->E2_VENCREA			// Secao 01
			TRB->E2_MOEDA	:= (cAliasQry1)->E2_MOEDA			// Secao 01
			TRB->NOM_MOEDA	:= NOM_MOEDA( (cAliasQry1)->E2_MOEDA ) 
			TRB->E2_VALOR	:= (cAliasQry1)->E2_VALOR			// Secao 01
			TRB->E2_VLCRUZ	:= (cAliasQry1)->E2_VLCRUZ			// Secao 01
			TRB->E2_ACRESC	:= (cAliasQry1)->E2_ACRESC
			TRB->E2_DECRESC	:= (cAliasQry1)->E2_DECRESC
			TRB->E2_ISS		:= (cAliasQry1)->E2_ISS
			TRB->E2_IRRF	:= (cAliasQry1)->E2_IRRF
			TRB->E2_INSS	:= (cAliasQry1)->E2_INSS
			TRB->E2_COFINS	:= (cAliasQry1)->E2_COFINS
			TRB->E2_PIS		:= (cAliasQry1)->E2_PIS
			TRB->E2_CSLL	:= (cAliasQry1)->E2_CSLL
			TRB->E2_JUROS	:= (cAliasQry1)->E2_JUROS
			TRB->E2_DESCONT	:= (cAliasQry1)->E2_DESCONT
			TRB->E2_MULTA	:= (cAliasQry1)->E2_MULTA
			TRB->E2_VALLIQ	:= (cAliasQry1)->E2_VALLIQ
			TRB->E2_SALDO	:= (cAliasQry1)->E2_SALDO
			TRB->E2_BAIXA	:= (cAliasQry1)->E2_BAIXA
			TRB->E2_FORBCO	:= (cAliasQry1)->E2_FORBCO
			TRB->E2_FORAGE	:= (cAliasQry1)->E2_FORAGE
			TRB->E2_FORCTA	:= (cAliasQry1)->E2_FORCTA
			TRB->E2_FCTADV	:= (cAliasQry1)->E2_FCTADV
			TRB->E2_FAGEDV	:= (cAliasQry1)->E2_FAGEDV
			TRB->E2_EMISSAO	:= (cAliasQry1)->E2_EMISSAO
			TRB->E2_EMIS1	:= (cAliasQry1)->E2_EMIS1			// Secao 01
			TRB->E2_VENCTO	:= (cAliasQry1)->E2_VENCTO			// Secao 01
			TRB->SEQUENCIA	:= StrZero(++NumRegistr, 9)
			TRB->( msUnlock() )

			DbSelectArea(  (cAliasQry1) )
			(cAliasQry1)->(dBSkip())

		EndIf

		If (cFilQry1+cForQry1+cLojQry1+cPreQry1+cNumQry1+cTipQry1);
		<> ((cAliasQry1)->E2_FILIAL+	(cAliasQry1)->E2_FORNECE+(cAliasQry1)->E2_LOJA;
		+  (cAliasQry1)->E2_PREFIXO+(cAliasQry1)->E2_NUM;
		+  (cAliasQry1)->E2_TIPO) .Or.;
		(cFilQry1+cPreQry1+cNumQry1+cTipQry1+cForQry1+cLojQry1);
		<> ((cAliasQry1)->E2_FILIAL+	(cAliasQry1)->E2_PREFIXO+(cAliasQry1)->E2_NUM;
		+  (cAliasQry1)->E2_TIPO+(cAliasQry1)->E2_FORNECE+(cAliasQry1)->E2_LOJA) .Or.;
		(cAliasQry1)->(Eof())

			cQuery := "%" + " ORDER BY " + cOrder + "%"

			IF !Empty( Select( cAliasQry2 ) )
				DbSelectArea( cAliasQry2 )
				DbCloseArea()
			ENDIF

				//WHERE 	E2_FILIAL  = %exp:cFilQry1% AND		// Geronimo 07/12/2018 - Entre o SE2 e o SE5, tirei do relacionamento o campo FILIAL, pois posso gerar em uma filial, bordero com titulo de outra filial.
			BeginSql Alias cAliasQry2
				SELECT SE2.*
				FROM  %table:SE2% SE2
				WHERE 
				E2_FATPREF = %exp:cPreQry1% AND
				E2_FATURA  = %exp:cNumQry1% AND
				E2_TIPOFAT = %exp:cTipQry1% AND
				E2_FORNECE = %exp:cForQry1% AND
				E2_LOJA %exp:cLojas% AND
				SE2.%NotDel%
				%Exp:cQuery%
			EndSql

			cPreAux := cPreQry1
			cTipAux := cTipQry1
			cNumAux := cNumQry1

			aQuery := getLastQuery()
			cQueryEmb2 := aQuery[2]		// obtem a query do embebed
			MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +"query2.TXT",cQueryEmb2)

			While !(cAliasQry2)->(Eof())

				cPreQry1 := (cAliasQry2)->E2_PREFIXO
				cNumQry1 := (cAliasQry2)->E2_NUM
				cTipQry1 := (cAliasQry2)->E2_TIPO

				nVlAbat :=SomaAbat(cPreQry1,cNumQry1,cParQry1,"P",cMdaQry1	,,cForQry1)
				cAliasQry3	:= GetNextAlias()

				cAlias := Alias()

				IF !Empty( Select( cAliasQry3 ) )
					DbSelectArea( cAliasQry3 )
					DbCloseArea()
				ENDIF


				//WHERE 	E5_FILIAL	= %exp:xFilial("SE5",cFilQry1)% AND     // Geronimo 07/12/2018 - Entre o SE2 e o SE5, tirei do relacionamento o campo FILIAL, pois posso gerar em uma filial, bordero com titulo de outra filial.
				BeginSql Alias cAliasQry3
					SELECT SE5.E5_VALOR
					FROM  %table:SE5% SE5
					WHERE 	
					E5_PREFIXO = %exp:cPreQry1% AND
					E5_NUMERO	= %exp:cNumQry1% AND
					E5_TIPO	= %exp:cTipQry1% AND
					E5_CLIFOR	= %exp:cForQry1% AND
					E5_FORNECE	= %exp:cForQry1% AND
					E5_LOJA %exp:cLojas% AND
					E5_MOTBX	= 'FAT' AND
					E5_RECPAG	= 'P' AND
					SE5.%NotDel%
				EndSql

				aQuery := getLastQuery()
				cQueryEmb3 := aQuery[2]		// obtem a query do embebed
				MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +"query3_Titulo_em_faturas.TXT",cQueryEmb3)		

				DbSelectArea("TRB")
				Reclock("TRB",.T.)
				TRB->E2_FILIAL	:= (cAliasQry2)->E2_FILIAL			// Secao Filial
				TRB->A1_NOME	:= FWFilialName( , (cAliasQry2)->E2_FILIAL )						// Secao Filial
				TRB->DESCSTATUS	:= DESCSTATUS(cAliasQry2)  
				TRB->E2_FORNECE	:= (cAliasQry2)->E2_FORNECE			// Secao 01
				TRB->E2_LOJA	:= (cAliasQry2)->E2_LOJA			// Secao 01 
				TRB->E2_NOMFOR	:= (cAliasQry2)->E2_NOMFOR			// Secao 01
				TRB->E2_NATUREZ	:= (cAliasQry2)->E2_NATUREZ			// Secao 01
				TRB->FATURTITUL	:= "TITULO EM FATURA"
				TRB->E2_PREFIXO	:= (cAliasQry2)->E2_PREFIXO			// Secao 01
				TRB->E2_NUM		:= (cAliasQry2)->E2_NUM				// Secao 01
				TRB->E2_PARCELA	:= (cAliasQry2)->E2_PARCELA			// Secao 01
				TRB->E2_TIPO	:= (cAliasQry2)->E2_TIPO			// Secao 01
				TRB->E2_FATPREF	:= (cAliasQry2)->E2_FATPREF			// Secao 01
				TRB->E2_FATURA	:= (cAliasQry2)->E2_FATURA			// Secao 01
				TRB->E2_TIPOFAT	:= (cAliasQry2)->E2_TIPOFAT			// Secao 01
				TRB->E2_VENCREA	:= (cAliasQry2)->E2_VENCREA			// Secao 01
				TRB->E2_MOEDA	:= (cAliasQry2)->E2_MOEDA			// Secao 01
				TRB->NOM_MOEDA	:= NOM_MOEDA( (cAliasQry2)->E2_MOEDA ) 
				TRB->E2_VALOR	:= (cAliasQry2)->E2_VALOR			// Secao 01
				TRB->E2_VLCRUZ	:= (cAliasQry2)->E2_VLCRUZ			// Secao 01
				TRB->E2_ACRESC	:= (cAliasQry2)->E2_ACRESC
				TRB->E2_DECRESC	:= (cAliasQry2)->E2_DECRESC
				TRB->E2_ISS		:= (cAliasQry2)->E2_ISS
				TRB->E2_IRRF	:= (cAliasQry2)->E2_IRRF
				TRB->E2_INSS	:= (cAliasQry2)->E2_INSS
				TRB->E2_COFINS	:= (cAliasQry2)->E2_COFINS
				TRB->E2_PIS		:= (cAliasQry2)->E2_PIS
				TRB->E2_CSLL	:= (cAliasQry2)->E2_CSLL
				TRB->E2_JUROS	:= (cAliasQry2)->E2_JUROS
				TRB->E2_DESCONT	:= (cAliasQry2)->E2_DESCONT
				TRB->E2_MULTA	:= (cAliasQry2)->E2_MULTA
				TRB->E2_VALLIQ	:= (cAliasQry2)->E2_VALLIQ
				TRB->E2_SALDO	:= (cAliasQry2)->E2_SALDO
				TRB->E2_BAIXA	:= (cAliasQry2)->E2_BAIXA
				TRB->E2_FORBCO	:= (cAliasQry2)->E2_FORBCO
				TRB->E2_FORAGE	:= (cAliasQry2)->E2_FORAGE
				TRB->E2_FORCTA	:= (cAliasQry2)->E2_FORCTA
				TRB->E2_FCTADV	:= (cAliasQry2)->E2_FCTADV
				TRB->E2_FAGEDV	:= (cAliasQry2)->E2_FAGEDV
				TRB->E2_EMISSAO	:= (cAliasQry2)->E2_EMISSAO
				TRB->E2_EMIS1	:= (cAliasQry2)->E2_EMIS1			// Secao 01
				TRB->E2_VENCTO	:= (cAliasQry2)->E2_VENCTO			// Secao 01
				TRB->SEQUENCIA	:= StrZero(++NumRegistr, 9)

				MsUnlock()
				DbSelectArea(  (cAliasQry2) )

				(cAliasQry3)->(DbCloseArea())
				dBSelectArea(cAlias)
				(cAliasQry2)->(dBSkip())
			EndDo

			//Busca os titulos da fatura em outras filiais		//Inicio
			If lFilOrig .AND. .F.		// Geronimo 07/12/2018	// Comentei todo o tratamento abaixo para encontrar titulos de faturas em outras filiais, pois no laco acima, retirei o campo filial do relacionamento entre a fatura e os titulos que a compoe
				cAliasQry3 := GetNextAlias()

				BeginSql Alias cAliasQry3
					SELECT SE5.E5_FILORIG
					FROM  %table:SE5% SE5
					WHERE 	E5_FILIAL	= %exp:xFilial("SE5",cFilOrg)% AND
					E5_CLIFOR	= %exp:cForQry1% AND
					E5_FORNECE	= %exp:cForQry1% AND
					E5_LOJA %exp:cLojas% AND
					E5_MOTBX	= 'FAT' AND
					E5_RECPAG	= 'P' AND
					E5_FILORIG <> %exp:cFilOrg% AND
					SE5.%NotDel%
				EndSql

				While !(cAliasQry3)->( Eof() )
					If aScan( aFilFat , (cAliasQry3)->E5_FILORIG  ) == 0
						aAdd( aFilFat , (cAliasQry3)->E5_FILORIG )
					EndIf
					(cAliasQry3)->( dbSkip() )
				EndDo

				(cAliasQry3)->( dbCloseArea() )

				For nX := 1 To Len( aFilFat )

					IF !Empty( Select( cAliasQry2 ) )
						DbSelectArea( cAliasQry2 )
						DbCloseArea()
					ENDIF

					BeginSql Alias cAliasQry2
						SELECT SE2.*
						FROM  %table:SE2% SE2
						WHERE 	E2_FILIAL  <> %exp:cFilQry1% AND
						E2_FATPREF = %exp:cPreAux% AND
						E2_FATURA  = %exp:cNumAux% AND
						E2_TIPOFAT = %exp:cTipAux% AND
						E2_FORNECE = %exp:cForQry1% AND
						E2_LOJA %exp:cLojas% AND
						E2_FILORIG = %exp:aFilFat[ nX ]% AND
						SE2.%NotDel%
						%Exp:cQuery%
					EndSql

					While !(cAliasQry2)->(Eof())

						cPreQry1	:= (cAliasQry2)->E2_PREFIXO
						cNumQry1	:= (cAliasQry2)->E2_NUM
						cTipQry1	:= (cAliasQry2)->E2_TIPO
						nVlAbat	:= SomaAbat(cPreQry1,cNumQry1,cParQry1,"P",cMdaQry1	,,cForQry1)
						cAliasQry3 := GetNextAlias()	
						cAlias		:= Alias()

						BeginSql Alias cAliasQry3
							SELECT SE5.E5_VALOR
							FROM  %table:SE5% SE5
							WHERE 	E5_FILIAL	= %exp:xFilial("SE5",cFilOrg)% AND
							E5_PREFIXO = %exp:cPreQry1% AND
							E5_NUMERO	= %exp:cNumQry1% AND
							E5_TIPO	= %exp:cTipQry1% AND
							E5_CLIFOR	= %exp:cForQry1% AND
							E5_FORNECE	= %exp:cForQry1% AND
							E5_LOJA %exp:cLojas% AND
							E5_MOTBX	= 'FAT' AND
							E5_RECPAG	= 'P' AND
							E5_FILORIG <> %exp:cFilOrg% AND
							SE5.%NotDel%
						EndSql
						aQuery := getLastQuery()
						cQueryEmb4 := aQuery[2]		// obtem a query do embebed
						MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +"query3B.TXT",cQueryEmb4)		

						DbSelectArea("TRB")
						Reclock("TRB",.T.)
						TRB->E2_FILIAL	:= (cAliasQry2)->E2_FILIAL			// Secao Filial
						TRB->A1_NOME	:= FWFilialName( , (cAliasQry2)->E2_FILIAL )	// Secao Filial
						TRB->DESCSTATUS	:= DESCSTATUS(cAliasQry2) 
						TRB->E2_FORNECE	:= (cAliasQry2)->E2_FORNECE			// Secao 01
						TRB->E2_LOJA	:= (cAliasQry2)->E2_LOJA			// Secao 01 
						TRB->E2_NOMFOR	:= (cAliasQry2)->E2_NOMFOR			// Secao 01
						TRB->E2_NATUREZ	:= (cAliasQry2)->E2_NATUREZ			// Secao 01
						TRB->FATURTITUL	:= "TITULO EM FATURA"
						TRB->E2_PREFIXO	:= (cAliasQry2)->E2_PREFIXO			// Secao 01
						TRB->E2_NUM		:= (cAliasQry2)->E2_NUM				// Secao 01
						TRB->E2_PARCELA	:= (cAliasQry2)->E2_PARCELA			// Secao 01
						TRB->E2_TIPO	:= (cAliasQry2)->E2_TIPO			// Secao 01
						TRB->E2_FATPREF	:= (cAliasQry2)->E2_FATPREF			// Secao 01
						TRB->E2_FATURA	:= (cAliasQry2)->E2_FATURA			// Secao 01
						TRB->E2_TIPOFAT	:= (cAliasQry2)->E2_TIPOFAT			// Secao 01
						TRB->E2_VENCREA	:= (cAliasQry2)->E2_VENCREA			// Secao 01
						TRB->E2_MOEDA	:= (cAliasQry2)->E2_MOEDA			// Secao 01
						TRB->NOM_MOEDA	:= NOM_MOEDA( (cAliasQry2)->E2_MOEDA ) 
						TRB->E2_VALOR	:= (cAliasQry2)->E2_VALOR			// Secao 01
						TRB->E2_VLCRUZ	:= (cAliasQry2)->E2_VLCRUZ			// Secao 01
						TRB->E2_ACRESC	:= (cAliasQry2)->E2_ACRESC
						TRB->E2_DECRESC	:= (cAliasQry2)->E2_DECRESC
						TRB->E2_ISS		:= (cAliasQry2)->E2_ISS
						TRB->E2_IRRF	:= (cAliasQry2)->E2_IRRF
						TRB->E2_INSS	:= (cAliasQry2)->E2_INSS
						TRB->E2_COFINS	:= (cAliasQry2)->E2_COFINS
						TRB->E2_PIS		:= (cAliasQry2)->E2_PIS
						TRB->E2_CSLL	:= (cAliasQry2)->E2_CSLL
						TRB->E2_JUROS	:= (cAliasQry2)->E2_JUROS
						TRB->E2_DESCONT	:= (cAliasQry2)->E2_DESCONT
						TRB->E2_MULTA	:= (cAliasQry2)->E2_MULTA
						TRB->E2_VALLIQ	:= (cAliasQry2)->E2_VALLIQ
						TRB->E2_SALDO	:= (cAliasQry2)->E2_SALDO
						TRB->E2_BAIXA	:= (cAliasQry2)->E2_BAIXA
						TRB->E2_FORBCO	:= (cAliasQry2)->E2_FORBCO
						TRB->E2_FORAGE	:= (cAliasQry2)->E2_FORAGE
						TRB->E2_FORCTA	:= (cAliasQry2)->E2_FORCTA
						TRB->E2_FCTADV	:= (cAliasQry2)->E2_FCTADV
						TRB->E2_FAGEDV	:= (cAliasQry2)->E2_FAGEDV
						TRB->E2_EMISSAO	:= (cAliasQry2)->E2_EMISSAO
						TRB->E2_EMIS1	:= (cAliasQry2)->E2_EMIS1			// Secao 01
						TRB->E2_VENCTO	:= (cAliasQry2)->E2_VENCTO			// Secao 01
						TRB->SEQUENCIA	:= StrZero(++NumRegistr, 9)

						MsUnlock()
						DbSelectArea(  (cAliasQry2) )

						(cAliasQry3)->(DbCloseArea())
						dBSelectArea(cAlias)
						(cAliasQry2)->(dBSkip())
					EndDo

				Next nX
			EndIf
			//Busca os titulos da fatura em outras filiais		//Fim

		EndIf

		//(cAliasQry1)->(DbSkip())

		cFilQry1	:= (cAliasQry1)->E2_FILIAL
		cA1_NOME	:= FWFilialName( , (cAliasQry1)->E2_FILIAL )			// NomeFilial( (cAliasQry1)->E2_FILIAL )
		cForQry1	:= (cAliasQry1)->E2_FORNECE
		cLojQry1	:= (cAliasQry1)->E2_LOJA
		cNaturQry1	:= (cAliasQry1)->E2_NATUREZ
		cNomFoQry1	:= (cAliasQry1)->E2_NOMFOR
		cPreQry1	:= (cAliasQry1)->E2_PREFIXO
		cNumQry1	:= (cAliasQry1)->E2_NUM
		cParQry1	:= (cAliasQry1)->E2_PARCELA
		cTipQry1	:= (cAliasQry1)->E2_TIPO
		dDContQry1	:= (cAliasQry1)->E2_EMIS1
		dVRealQry1	:= (cAliasQry1)->E2_VENCREA
		nVCruzQry1	:= (cAliasQry1)->E2_VLCRUZ
		cMdaQry1	:= (cAliasQry1)->E2_MOEDA
		nValorQry1	:= (cAliasQry1)->E2_VALOR
		nSaldoQry1	:= (cAliasQry1)->E2_SALDO

	EndDo

	For nX := 1 TO Len(aTmpFil)
		CtbTmpErase(aTmpFil[nX])	
	Next

	aSize( aFilFat , 0 )
	aFilFat := Nil

	DbSelectArea("TRB")
	DbGotop()

	If Eof()
		MsgStop("Nao foi encontrado Faturas e os Titulos que comp�e as faturas. Sera listado somente os titulos nao incluso nas faturas. (Se existirem). ")
	Endif
	MGF06R07TL()

	If Select("TRB") > 0 ; dbSelectArea("TRB") ; dbCloseArea() ; EndIf
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  �MGF06R07TL� Autor � Geronimo Benedito Alves � Data�  20.03.08���
��������������������������������������������������������������������������Ĵ��
���Descricao �Esta rotina configura as variaveis e os objetos p/ mostrar	���
���			�os dados na tela, e posteriormente em planilha excel			���
��������������������������������������������������������������������������Ĵ��
���Retorno	�Nenhum														���
��������������������������������������������������������������������������Ĵ��
���Parametros�																���
��������������������������������������������������������������������������Ĵ��
���	DATA	� Programador	�Manutencao efetuada							���
��������������������������������������������������������������������������Ĵ��
���			�				�												���
���������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function MGF06R07TL()

	_cQuery		:= ""
	_cQuery	:= "SELECT E2_FILIAL,A1_NOME,DESCSTATUS,E2_FORNECE,E2_LOJA,E2_NOMFOR,E2_NATUREZ,FATURTITUL,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FATPREF,E2_FATURA,E2_TIPOFAT,E2_VENCREA,E2_MOEDA,NOM_MOEDA,E2_VALOR,E2_VLCRUZ,E2_ACRESC,E2_DECRESC,E2_ISS,E2_IRRF,E2_INSS,E2_COFINS,E2_PIS,E2_CSLL,E2_JUROS,E2_DESCONT,E2_MULTA,E2_VALLIQ,E2_SALDO,E2_BAIXA,E2_FORBCO,E2_FORAGE,E2_FORCTA,E2_FCTADV,E2_FAGEDV,E2_EMISSAO,E2_EMIS1,E2_VENCTO,SEQUENCIA, ' ' as X  " +CRLF
	_cQuery	+= " FROM " + U_IF_BIMFR( "PROTHEUS", cNomArq  )  + " "	+CRLF
	_cQuery	+= " UNION ALL  "  +CRLF
	_cQuery		+= U_CpoQuery(_aCampoQry)	// FUNCAO QUE cria a parte da query referente � selecao dos campos. A query � complementada abaixo 

	_cQuery += " FROM " + U_IF_BIMFR( "IF_BIMFR",  "V_CP_RELACAO_FATURAS" ) + " A "   + CRLF 
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),    " A.COD_FILIAL IN "                + _cCODFILIA                                     ) // OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[3] ),      " COD_FORNECEDOR  BETWEEN '"       + _aRetBKP[1]  + "' AND '" + _aRetBKP[3]  + "' " ) // NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),      " COD_LOJA BETWEEN '"              + _aRetBKP[2]  + "' AND '" + _aRetBKP[4]  + "' " ) // NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),      " DT_EMISSAO_FILTRO  BETWEEN '"    + _aRetBKP[5]  + "' AND '" + _aRetBKP[6]  + "' " ) // OBRIGATORIO, COM A VALIDACAO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_aRet[10] ),     " NATUREZA BETWEEN '"              + _aRetBKP[9]  + "' AND '" + _aRetBKP[10] + "' " ) // NAO OBRIGATORIO

    //Comentado. O filtro por Data Vencto Real nao se aplica aqui. Somente na leitura das faturas. (Nao se aplica nos titulos "Em Fatura" e nem "Sem Fatura")
	//_cQuery += U_WhereAnd( !empty(_aRet[14] ),     " DT_VENCIMENTO_FILTRO  BETWEEN '" + _aRetBKP[13] + "' AND '" + _aRetBKP[14] + "' " ) // NAO OBRIGATORIO
	
	_cQuery += " ORDER BY  SEQUENCIA, E2_FORNECE, E2_LOJA, FATURTITUL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO  "
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  �NomeFilial� Autor � Geronimo Benedito Alves � Data�  07/02/18���
��������������������������������������������������������������������������Ĵ��
���Descricao � Retorna o nome da filial (CAMPO M0_FILIAL)					���
��������������������������������������������������������������������������Ĵ��
���Retorno	�nome da filial												���
��������������������������������������������������������������������������Ĵ��
���Parametros�																���
��������������������������������������������������������������������������Ĵ��
���	DATA	� Programador	�Manutencao efetuada							���
��������������������������������������������������������������������������Ĵ��
���			�				�												���
���������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//Static Function NomeFilial( FILIAL )
//	Local aArea			:= GetArea()
//	Local cM0_FILIAL	:= " "
//
//	DbSelectArea("SM0")
//	DbSetOrder(1)
//	DbSeek(FILIAL)
//	cM0_FILIAL	:= SM0->M0_FILIAL 
//
//	RestArea(aArea)
//Return cM0_FILIAL
/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  �NOM_MOEDA� Autor � Geronimo Benedito Alves � Data�  07/02/18 ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Retorna o nome da moeda (E2_MOEDA)							���
��������������������������������������������������������������������������Ĵ��
���Retorno	�nome da moeda												���
��������������������������������������������������������������������������Ĵ��
���Parametros�																���
��������������������������������������������������������������������������Ĵ��
���	DATA	� Programador	�Manutencao efetuada							���
��������������������������������������������������������������������������Ĵ��
���			�				�												���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

Static Function NOM_MOEDA( nE2_MOEDA )
	Local cNOM_MOEDA	:= "Indef"
	Local aMoeda := { 'REAL', 'DOLAR', 'UFIR', 'EURO', 'IENE' }

	If nE2_MOEDA > 0 .and. nE2_MOEDA < 6
		cNOM_MOEDA := aMoeda[nE2_MOEDA]
	Endif

Return cNOM_MOEDA

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  �DESCSTATUS� Autor � Geronimo Benedito Alves � Data�  07/02/18���
��������������������������������������������������������������������������Ĵ��
���Descricao � Retorna o texto da Descricao de status do titulo			���
���			�os dados na tela, e posteriormente em planilha excel			���
��������������������������������������������������������������������������Ĵ��
���Retorno	�Nenhum														���
��������������������������������������������������������������������������Ĵ��
���Parametros�																���
��������������������������������������������������������������������������Ĵ��
���	DATA	� Programador	�Manutencao efetuada							���
��������������������������������������������������������������������������Ĵ��
���			�				�												���
���������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function DESCSTATUS( cAlias )
	Local cRet	:= 'TITULO EM ABERTO'				// 1

	If (cAlias)->E2_SALDO <> (cAlias)->E2_VALOR	.AND. (cAlias)->E2_SALDO <> 0
		cRet	:= 'BAIXADO PARCIALMENTE'			// 2

	ElseIf (cAlias)->E2_BAIXA <> ' '
		cRet	:= 'TITULO BAIXADO'					// 3

	ElseIf (cAlias)->E2_NUMBOR <> '' .AND. (cAlias)->E2_BAIXA = '' 
		cRet	:= 'TITULO EM BORDER�'				// 4

	ElseIf (cAlias)->E2_NUMBOR <> '' .AND. (cAlias)->E2_SALDO > 0 .AND.  (cAlias)->E2_SALDO <> (cAlias)->E2_VALOR
		cRet	:= 'ADIANTAMENTO COM SALDO'				// 5

	ElseIf (cAlias)->E2_TIPO = 'PA' .AND. (cAlias)->E2_SALDO > 0 
		cRet	:= 'TITULO BAIXADO PARCIALMENTE E EM BORDERO' // 6
	Endif		

Return cRet		

