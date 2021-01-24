#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF06R08	�Autor  � Geronimo Benedito Alves																	�Data �29/12/17	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: CONTAS A RECEBER - Recebimento Consolidado  (M�dulo 06-FIN)						���
//���			� Os dados sao obtidos e mostrados na tela atrav�z da execu��o de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Marfrig Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF06R08()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contas a Receber - Recebimento Consolidado"	)	//01-  _cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Recebimento Consolidado"						)	//02-  _cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Recebimento Consolidado"}					)	//03-  _cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Recebimento Consolidado"}					)	//04-  _cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}												)	//05-	Array de Arrays que define quais colunas ser�o mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, ser� mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }									)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser inclu�do naquela aba  

	_aCpoExce	:= {}
	_cTmp01		:= ""					
	
	
	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma fun��o (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que ser� transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 s�o sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos ser�o preservados.
	//					01			 02										 03							 04	 05	 	 06		07					 08		 09		
	Aadd(_aCampoQry, {"A1_FILIAL"	,"COD_FILIAL"							,"C�digo Filial"			,"C",006	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_FILIAL"							,"Nome da Filial"			,"C",041	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_COD"		,"COD_CLIENTE			as CODCLIENTE"	,"C�d. do Cliente"			,"C",006	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_CLIENTE			as NOMCLIENTE"	,"Nome do Cliente"			,"C",020	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"ZQ_DESCR"	,"DESC_REDE"							,"Descr. Rede"				,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"AOV_CODSEG"	,"COD_SEGMENTO			as CODSEGMENT"	,"C�d. Segmento"			,"C",006	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"AOV_DESSEG"	,"DESC_SEGMENTO			as DESCSEGMEN"	,"Descr. Segmento"			,"C",100	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E1_NATUREZ"	,"COD_NATUREZA			as CODNATUREZ"	,"C�d. Natureza"			,"C",010	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E1_PORTADO"	,"COD_PORTADOR			as CODPORTADO"	,"C�d. Portador"			,"C",003	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E1_VALOR"	,"VLR_TITULO"							,"Valor T�tulo"				,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"E1_VALOR"	,"VLR_DEVOLUCAO			as VLRDEVOLUC"	,"Valor Devolu��o"			,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"E1_DECRESC"	,"VLR_DESCONTO			as VLRDESCONT"	,"Valor Desconto"			,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"E5_VALOR"	,"VLR_DESCONTO_CONTRATO	as DESCCONTRA"	,"Vlr. Desconto Contrato"	,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"E1_VALJUR"	,"VLR_JUROS"							,"Valor Juros"				,"N",014	,2	,"@E 999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"E1_VALOR"	,"VLR_RECEBIDO			as VLRECEBIDO"	,"Valor Recebido"			,"N",014	,2	,"@E 999,999,999.99"	,""		,""	}) 

	aAdd(_aParambox,{1,"Data Pagto Inicio:"		,Ctod("")					,""		,""													,""		,""	,050,.T.})
	aAdd(_aParambox,{1,"Data Pagto Fim:"		,Ctod("")					,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Pagamento')"	,""		,""	,050,.T.})
	aAdd(_aParambox,{1,"Cod. Cliente Inicio:"	,Space(tamSx3("A1_COD")[1])	,"@!"	,""													,"CLI"	,	,050,.F.})  
	aAdd(_aParambox,{1,"Cod. Cliente Fim:"		,Space(tamSx3("A1_COD")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Cod. Cliente')"	,"CLI"	,	,050,.F.})		
	aAdd(_aParambox,{1,"Cod. Rede Inicio:"		,Space(tamSx3("ZQ_COD")[1])	,"@!"	,""													,"SZQ"	,	,050,.F.})  
	aAdd(_aParambox,{1,"Cod. Rede Fim:"			,Space(tamSx3("ZQ_COD")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Cod. Cliente')"	,"SZQ"	,	,050,.F.})													
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	Do While.T.													// La�o para obrigar a marca��o de ao menos um portador
		cQryPorPro	:= "SELECT ' ' as A6_COD, 'SEM PORTADOR' as A6_NOME FROM DUAL UNION ALL "
		cQryPorPro	+= "SELECT DISTINCT A6_COD, A6_NOME"
		cQryPorPro  +=" FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SA6") ) + " TMPSA6 " 
		cQryPorPro	+= "  WHERE TMPSA6.D_E_L_E_T_ = ' ' " 
		cQryPorPro	+= "  ORDER BY A6_COD"

		aCpoPorPro	:=	{	{ "A6_COD"		,U_X3Titulo("A6_COD")	,TamSx3("A6_COD")[1]	 } ,;
		aCpoPorPro	:=		{ "A6_NOME"	,U_X3Titulo("A6_NOME")	,TamSx3("A6_NOME")[1] }	} 
		cTituPorta	:= "Selecione os C�digos de Portadores a serem listados "
		nPosRetorn	:= 1	
		//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o bot�o cancelar da MarkGene.
		//.T. no _lCancProg, ap�s a Markgene, indica que realmente foi teclado o bot�o cancelar e que devo abandonar o programa. 
		//.F. no _lCancProg, ap�s a Markgene, indica que realmente n�o foi teclado o bot�o cancelar ou que mesmo ele teclado, n�o devo abandonar o programa (mas apenas "limpar/desconsiderar" a marca��o dos registro) 
		_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o bot�o cancelar da MarkGene										// Quero que seja retornado o primeiro campo: A6_COD
		cPortaProd	:= U_Array_In( U_MarkGene(cQryPorPro, aCpoPorPro, cTituPorta, nPosRetorn, @_lCancProg ) )

		Exit	// Mudan�a da l�gica. N�o tem mais MarkGene obrigat�ria. Se n�o marcar nenhum, ou marcar todos, prossigo e n�o incluo a condi��o no where

		//If empty(cPortaProd)
		//	MsgStop("� obrigatorio a sele�ao de ao menos um portador. ")
		//	Loop		// Se nao marcou nenhum portador, dou loop ao While para marca-lo 
		//Else
		//	Exit		// Se marcou ao menos um portador, dou exit neste la�o e continuo o processamento da rotina
		//Endif
	Enddo

	If _lCancProg
		Return
	Endif 
	_cQuery += " FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CR_RECEBIMENTO_CONSOLIDADO"  ) + " A "       + CRLF 
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),     " DT_PAGAMENTO_FILTRO  BETWEEN '" + _aRet[1]    + "' AND '" + _aRet[2] + "' " ) // OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),   " A.COD_FILIAL IN "               + _cCODFILIA	                            ) // OBRIGATORIO (SELE��O DO COMBO)  CAMPO FILIAL(06 posi��es)
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),     " A.COD_CLIENTE BETWEEN '"        + _aRet[3]    + "' AND '" + _aRet[4] + "' " ) // N�O OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),     " A.COD_REDE BETWEEN '"           + _aRet[5]    + "' AND '" + _aRet[6] + "' " ) // N�O OBRIGATORIO

	If Empty( cPortaProd )	// ZBD_DESCRI
		_cQuery +=  ""		// N�o incrementa a clausula Where
	ElseIF AT("' '", cPortaProd ) <> 0
		_cQuery += U_WhereAnd( .T. , " ( COD_PORTADOR IS NULL OR COD_PORTADOR IN " + cPortaProd + " )"  ) 
	Else	
		_cQuery += U_WhereAnd( .T. , " COD_PORTADOR IN " + cPortaProd                               ) 	
	Endif
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})		// Mostra mensagem, ao montar a tela de dados e tamb�m ao fecha-la
RETURN
