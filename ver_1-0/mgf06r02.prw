#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF06R02	�Autor  �Geronimo Benedito Alves																	�Data �08/12/17	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: Financeiro - Contas a Receber - Clientes por Condicao de Pagamento (Modulo 06-FIN)���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF06R02()
	Local	_nI
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "CONTA A RECEBER - Clientes por Condicao de Pagamento" )	//01-  _cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Clientes por Condicao Pagamento"						)	//02-  _cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Clientes por Condicao Pagamento"}					)	//03-  _cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Clientes por Condicao Pagamento"}					)	//04-  _cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}														)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }											)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  

	_aCpoExce	:= {}
	_cTmp01		:= ""					
	
	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02												 03								 04	 05		 06	 07						 08 09		
	Aadd(_aCampoQry, {"A1_COD"		,"COD_CLIENTE					as CODCLIENTE"	,"Cod. do Cliente"				,"C",006	,0	,""						,""	,""	 })
	Aadd(_aCampoQry, {"A1_LOJA"		,"COD_LOJA"										,"Cod. da Loja"					,"C",002	,0	,""						,""	,""	 })
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_CLIENTE					as NOMCLIENTE"	,"Nome do Cliente"				,"C",Space(tamSx3("A1_NOME")[1])	,0	,""						,""	,""	 })
	Aadd(_aCampoQry, {"A2_CGC"		,"CNPJ_CLIENTE 				as CNPJCLIENT"	, "CNPJ do Cliente"				,"C",018	,0	,"@!"					,""	,"@!"	 })
	Aadd(_aCampoQry, {"NOM_MUNICIPIO"		,"NOM_MUNICIPIO"  , "Municipio"				,"C",60	,0	,"@!"					,""	,"@!"	 })
	Aadd(_aCampoQry, {"NOM_ESTADO"	    	,"NOM_ESTADO"	  , "Estado"				,"C",20	,0	,"@!"					,""	,"@!"	 })
 	Aadd(_aCampoQry, {"AOV_CODSEG"	,"COD_SEGMENTO				as CODSEGMENT"	,"Cod. do Segmento"				,"C",006	,0	,""						,""	,""	 })
	Aadd(_aCampoQry, {"AOV_DESSEG"	,"DESC_SEGMENTO				as DESCSEGMEN"	,"Descricao do Segmento"			,"C",040	,0	,""						,""	,""	 }) 
	Aadd(_aCampoQry, {"E4_CODIGO"	,"COD_COND_PGTO				as CODCONDPGT"	,"Condicao de Pagamento"			,"C",003	,0	,""						,""	,""	 })
	Aadd(_aCampoQry, {"E4_DESCRI"	,"DESC_COND_PGTO				as DESCCONDPG"	,"Descricao Condicao de Pagto"	,"C",015	,0	,""						,""	,""	 })
	//Aadd(_aCampoQry, {"ZQ_COD"	,"COD_REDE"										,"Cod. Rede"						,"C",003	,0	,""						,""	,""	 })
	Aadd(_aCampoQry, {"ZQ_DESCR"	,"DESC_REDE"										,"Descricao Rede"					,"C",040	,0	,""						,""	,""	 })
	Aadd(_aCampoQry, {"EXPOSICAO"	,"EXPOSICAO"										,"Exposi��o"					,"N",13	,2	,""						,""	,""	 })
	//Aadd(_aCampoQry, {"CT2_TAXA"	,"PERC_DESCONTO					as PERCDESCON"	,"% Desconto"					,"N",006	,2	,"@E 999.99"			,""	,""	 }) 
	Aadd(_aCampoQry, {"A1_LC"		,"VLR_LIMITE_CREDITO_CLIENTE as VLRLIMICLI"	,"Vlr. Limite Credito Cliente"	,"N",017	,2	,"@E 99,999,999,999.99"	,""	,""	 })
	Aadd(_aCampoQry, {"A1_VENCLC"	,"DT_VENC_LIMITE_CREDITO		as DTVENCLIMI"	,"Data Limite Credito Cliente"	,"D",008	,0	, ""					,""	,""	 })
	Aadd(_aCampoQry, {"A1_DTCAD"	,"DT_CADASTRO					as DTCADASTRO"	,"Data de Cadastro"				,"D",008	,0	, ""					,""	,""	 })
	Aadd(_aCampoQry, {"A1_MSBLQL"	,"STATUS_CLIENTE				as STATUSCLIE"	,"Status do Cliente"				,"C",010	,0	,""						,""	,""	 })
	Aadd(_aCampoQry, {"A1_ZGDERED"	,"FLG_GRANDES_REDES			as FLGGRNDRED"	,"Flg. Grandes Redes"			,"C",002	,0	,""						,""	,""	 })
	Aadd(_aCampoQry, {"YA_DESCR"	,"NOM_PAIS						as NOMEDOPAIS"	,"Nome do Pais"					,"C",020	,0	,""						,""	,""	 })
	Aadd(_aCampoQry, {"A1_VACUM"	,"VLR_ACUMULADO 				as VLRACUMULA"	,"Vlr. Acumulado"					,"N",017	,2	,"@E 99,999,999,999.99"	,""	,""	 })
	Aadd(_aCampoQry, {"A1_MCOMPRA"	,"VLR_MAIOR_COMPRA			as VLRMAIORCM"	,"Vlr. Maior Compra"				,"N",017	,2	,"@E 99,999,999,999.99"	,""	,""	 })
	Aadd(_aCampoQry, {"F2_VALFAT"	,"VLR_ULT_180_D				as VLRULT180D"  ,"VLR_ULT_180_D"					,"N",017	,2	,"@E 99,999,999,999.99"	,""	,""	 })//Rafael 30/07/19
	
	
	aAdd(_aParambox,{1,"Cod. Cliente Inicial"			,Space(tamSx3("A1_COD")[1])		,"@!", 														,"SA1"	,,070,.F.})  	//01
	aAdd(_aParambox,{1,"Cod. Cliente Final"				,Space(tamSx3("A1_COD")[1])		,"@!","U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Cod. Cliente')"		,"SA1"	,,070,.F.})		//02										
	aAdd(_aParambox,{1,"Cod. Municipio"					,Space(tamSx3("CC2_CODMUN")[1])	,"@!", 														,"CC2"	,,050,.F.})  	//03
	aAdd(_aParambox,{3,"Status Clientes" 				,iif(Set(_SET_DELETED),1,2)		, {'Ativo','Inativo','Ambos'}								,100,"",.T.})			//04
	aAdd(_aParambox,{3,"Grandes Redes" 					,iif(Set(_SET_DELETED),1,2)		, {'Sim','Nao','Todos'}										,100,"",.T.})			//05
	aAdd(_aParambox,{1,"Data Ult. Compra De"			,Ctod("")						,""		,""													,""		,""	,050,.F.})	//06
	aAdd(_aParambox,{1,"Data Ult. Compra Ate"			,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR06, MV_PAR07, 'Data Ult Comp')"	,""		,""	,050,.F.})	//07
	aAdd(_aParambox,{1,"Data Venc. Limite Credito De"	,Ctod("")						,""		,""													,""		,""	,050,.F.})	//08
	aAdd(_aParambox,{1,"Data Venc. Limite Credito Ate"	,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR08, MV_PAR09, 'Data Venc Cred')"	,""		,""	,050,.F.})	//09
	

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif
	
	//===		C O N D I � � O 		D E 	P A G A M E N T O  -- Bruno Tamanaka - Filtros 04/06/2019
	cQryCondPg	:= "SELECT '	' as E4_CODIGO, '	' as E4_DESCRI FROM DUAL UNION ALL "
	cQryCondPg	+= "SELECT DISTINCT E4_CODIGO, E4_DESCRI "
	//cQryCondPg  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SE4")  ) + " TMPSE4 "
	cQryCondPg  += "  FROM " +   RetSqlName("SE4")   + " TMPSE4 "
	cQryCondPg	+= "  WHERE TMPSE4.D_E_L_E_T_ = ' ' " 
	cQryCondPg	+= "  ORDER BY E4_CODIGO"

	aCpoCondPg	:=	{	{ "E4_CODIGO"	,U_X3Titulo("E4_CODIGO")	,TamSx3("E4_CODIGO")[1] },;
	aCpoCondPg	:=		{ "E4_DESCRI"	,U_X3Titulo("E4_DESCRI")	,TamSx3("E4_DESCRI")[1] }	} 
	cTitCondPg	:= "Condicao de Pagamento: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: E4_CODIGO
	
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o Botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o Botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
	_cCondPg	:= U_Array_In( U_MarkGene(cQryCondPg, aCpoCondPg, cTitCondPg, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 
	
		//===		C � D I G O 		R E D E
	cQryCodRed	:= "SELECT '	' as ZQ_COD, '	' as ZQ_DESCR FROM DUAL UNION ALL "
	cQryCodRed	+= "SELECT DISTINCT ZQ_COD, ZQ_DESCR "
	//cQryCodRed  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SZQ")  ) + " TMPSZQ "
	cQryCodRed  += "  FROM " +   RetSqlName("SZQ")   + " TMPSZQ "
	cQryCodRed	+= "  WHERE TMPSZQ.D_E_L_E_T_ = ' ' " 
	cQryCodRed	+= "  ORDER BY ZQ_COD"

	aCpoCodRed	:=	{	{ "ZQ_COD"		,U_X3Titulo("ZQ_COD")	,TamSx3("ZQ_COD")[1] },;
	aCpoCodRed	:=		{ "ZQ_DESCR"	,U_X3Titulo("ZQ_DESCR")	,TamSx3("ZQ_DESCR")[1] }	} 
	cTitCodRed	:= "Codigo Rede: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: ZQ_COD
	
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o Botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o Botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
	_cCodRed	:= U_Array_In( U_MarkGene(cQryCodRed, aCpoCodRed, cTitCodRed, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 
	
		//===		U F		C L I E N T E
	cQryUfClie	:= "SELECT '	' as X5_TABELA, '	' as X5_CHAVE, '	' as X5_DESCRI FROM DUAL UNION ALL "
	cQryUfClie	+= "SELECT X5_TABELA, X5_CHAVE, X5_DESCRI "
	//cQryUfClie	+= "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SX5")) + " TMPSX5 " 
	cQryUfClie	+= "  FROM " +  RetSqlName("SX5") + " TMPSX5 "
	cQryUfClie	+= "  WHERE TMPSX5.X5_TABELA	= '12' "
	cQryUfClie	+= "  AND	TMPSX5.D_E_L_E_T_  <>  '*' " 
	aCpoUfClie	:=	{	{ "X5_CHAVE"	,U_X3Titulo("X5_CHAVE")	, TamSx3("X5_CHAVE")[1]  } , ;
						{ "X5_DESCRI"	,U_X3Titulo("X5_DESCRI"), TamSx3("X5_DESCRI")[1] }	} 
	cTitUfClie	:= "UF Cliente: "
	nPosRetorn	:= 1		// Quero que seja retornado o segundo campo: X5_CHAVE

	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o Botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o Botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
	aUfClie	:= U_MarkGene(cQryUfClie, aCpoUfClie, cTitUfClie, nPosRetorn, @_lCancProg )
	If _lCancProg
		Return
	Endif 
	For _nI := 1 to len(aUfClie)
		aUfClie[_nI] := Alltrim(aUfClie[_nI]) 
	Next
	_cUfClie	:= U_Array_In( aUfClie )
	
	
			//===		C � D I G O 		S E G M E N T O
	cQryCodSeg	:= "SELECT '	' as AOV_CODSEG, '	' as AOV_DESSEG FROM DUAL UNION ALL "
	cQryCodSeg	+= "SELECT DISTINCT AOV_CODSEG, AOV_DESSEG "
	//cQryCodSeg  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("AOV")  ) + " TMPAOV "
	cQryCodSeg  += "  FROM " +   RetSqlName("AOV")   + " TMPAOV "
	cQryCodSeg	+= "  WHERE TMPAOV.D_E_L_E_T_ = ' ' " 
	cQryCodSeg	+= "  ORDER BY AOV_CODSEG"

	aCpoCodSeg	:=	{	{ "AOV_CODSEG"	,U_X3Titulo("AOV_CODSEG")	,TamSx3("AOV_CODSEG")[1] },;
	aCpoCodSeg	:=		{ "AOV_DESSEG"	,U_X3Titulo("AOV_DESSEG")	,TamSx3("AOV_DESSEG")[1] }	} 
	cTitCodSeg	:= "Codigo Segmento: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: ZQ_COD
	
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o Botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o Botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
	_cCodSeg	:= U_Array_In( U_MarkGene(cQryCodSeg, aCpoCodSeg, cTitCodSeg, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 
	
	
	//===		S T A T U S		C L I E N T E
	_Status 	:= " ( 'ATIVO' , 'INATIVO') "
	If 		_aRet[4] == 1
		_Status := " ('ATIVO') "
	ElseIf 	_aRet[4] == 2
		_Status := " ('INATIVO') "	
	EndIf
	
	//===		G R A N D E S 		R E D E S
	_GrdRed := ""
	If _aRet[5] <> 3
		If 		_aRet[5] == 1
			_GrdRed := "S"
		ElseIf 	_aRet[5] == 2
			_GrdRed := "N"
		EndIf
	EndIf
	
	cEnviroSrv	:= AllTrim(UPPER(GETENVSERVER()))
	IF cEnviroSrv $ 'PRODUCAO/PRE_RELEASE'                 
	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CR_CLIENTE_COND_PGTO" ) + ' A ' + CRLF 
	Else
	_cQuery += "  FROM V_CR_CLIENTE_COND_PGTO A"  + CRLF 

	EndIF

	_cQuery += U_WhereAnd( !Empty(_cCondPg ),      " A.COD_COND_PGTO IN "        + _cCondPg + "  " ) 
	_cQuery += U_WhereAnd( !Empty(_aRet[2] ),      " A.COD_CLIENTE BETWEEN '"    + _aRet[1] + "' AND '" + _aRet[2] + "' " ) 
	_cQuery += U_WhereAnd( !Empty(_cCodRed ),      " A.COD_REDE IN "        	 + _cCodRed + "  " ) 
	_cQuery += U_WhereAnd( !Empty(_cUfClie ),      " A.UF_CLIENTE IN "       	 + _cUfClie + "  " ) 
	_cQuery += U_WhereAnd( !Empty(_aRet[3] ),      " A.COD_MUNICIPIO_FILTRO = '" + _aRet[3] + "' " ) 
	_cQuery += U_WhereAnd( !Empty(_cCodSeg ),      " A.COD_SEGMENTO IN "         + _cCodSeg + "  " ) 
	_cQuery += U_WhereAnd( !Empty(_Status ) ,      " A.STATUS_CLIENTE IN "       + _Status  + "  " )
	_cQuery += U_WhereAnd( !Empty(_GrdRed ) ,      " A.FLG_GRANDES_REDES =  '"   + _GrdRed  + "' " )
	
	If Empty(_aRet[9])
		_cQuery += U_WhereAnd( !Empty(_aRet[7] ),      " A.DT_ULT_COMPRA_FILTRO BETWEEN '"    			+ _aRet[6] + "' AND '" + _aRet[7] + "' " ) 
	Else
		_cQuery += U_WhereAnd( !Empty(_aRet[9] ),      " A.DT_VENC_LIMITE_CREDITO_FILTRO BETWEEN '"    	+ _aRet[8] + "' AND '" + _aRet[9] + "' " ) 	
	EndIf

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN

