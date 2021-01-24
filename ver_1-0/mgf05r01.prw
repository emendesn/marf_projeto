#INCLUDE "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³ MGF05R01	ºAutor  ³ Geronimo Benedito Alves																	ºData ³  10/04/18  º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.		³ Rotina que mostra na tela os dados da planilha: FATURAMENTO - Saida NF Unidades							(Módulo 05-FAT)			º±±
//±±º			³ Os dados sao obtidos e mostrados na tela atraves da execução de query, e depois, o usuario pode gerar uma planilha excel com eles º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso		³ Marfrig Global Foods																												º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

User Function MGF05R01()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Faturamento - Saída NF Unidades"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerá na regua de processamento.
	Aadd(_aDefinePl, "Saída NF Unidades"				)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Saída NF Unidades"}				)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Saída NF Unidades"}				)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  )									//05-	Array de Arrays que define quais colunas serão mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, será mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } )							//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluído naquela aba  
	_nInterval	:= 35										//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou é usado alguma função (Sum,Count,max,Coalesc,etc), é dado a ele um apelido indicado    
	//pela clausula "as" que será transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 são sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serão preservados.
	//					01			 02											 03						 04		 05	 06		 07		 08	 09		
	Aadd(_aCampoQry, {"F2_FILIAL"	,"CODIGO_FILIAL				as COD_FILIAL"	,"Cód. Filial"			,""		,""	,"" 	,""		,""	,""	})		
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_FILIAL				as NOM_FILIAL"	,"Nome Filial"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_NUM"		,"NUMERO_PEDIDO				as NUMEPEDIDO"	,"Nº Pedido"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_EMISSAO"	,"DATA_EMISSAO_PEDIDO		as DTEMISSAOP"	,"Data Emissão Pedido"	,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_ZDTEMBA"	,"DATA_EMBARQUE				as DATAEMBARQ"	,"Data de Embarque"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ACT_DESCPG"	,"STATUS_PEDIDO				as STATPEDIDO"	,"Status do Pedido"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_CLIENTE				as NOMECLIENT"	,"Nome Cliente"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_CGC"		,"CNPJ_CLIENTE				as CNPJCLIENT"	,"CNPJ Cliente"			,""		,18	,"" 	,"@!"	,""	,"@!"	})
	Aadd(_aCampoQry, {"A3_NOME"		,"NOME_VENDEDOR				as NMVENDEDOR"	,"Nome Vendedor"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_NOTA"		,"NUMERO_NFS				as NUMERO_NFS"	,"Numero NFS"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_SERIE"	,"SERIE_NFS					as SERIE_NFS"	,"Série NFS"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_DATFAT"	,"DATA_EMISSAO_NFS			as DATAEMISSA"	,"Dt. Emissao NFS"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_UM"		,"UNIDADE_MEDIDA			as UNI_MEDIDA"	,"Unidade Medida"		,""		,""	,"" 	,""		,""	,""	})
	AAdd(_aCampoQry, {"C6_QTDVEN"	,"QUANTIDADE"								,"Quantidade"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_PRODUTO"	,"CODIGO_ITEM				as CODI_ITEM"	,"Cód. Item"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_DESCRI"	,"NOME_ITEM"								,"Nome Item"			,""		,""	,"" 	,""		,""	,""	})
	AAdd(_aCampoQry, {"C5_PESOL"	,"VALOR_PESO_LIQ_TOT_PEDIDO	as VLRPESOPED"	,"Peso Liq. Pedido"		,""		,""	,"" 	,""		,""	,""	})		 
	AAdd(_aCampoQry, {"F2_PLIQUI"	,"VALOR_PESO_LIQ_NFS		as VLRPESONFS"	,"Peso Liq. NFS"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A4_COD"		,"CODIGO_TRANSPORTADORA		as CODTRANSPO"	,"Cód. Transportadora"	,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A4_NOME"		,"NOME_TRANSPORTADORA		as NOMTRANSPO"	,"Nome Transportadora"	,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"DA3_PLACA"	,"PLACA_VEICULO				as PLCVEICULO"	,"Placa do Veículo"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E1_HIST"		,"OBS_PEDIDO"								,"Observação do Pedido"	,""		,""	,"" 	,""		,""	,""	})

	aAdd(_aParambox,{1,"Data Emissão Inicial"	,Ctod("")						,""		,"" 											,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Emissão Final"		,Ctod("")						,""		,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"	,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Embarque Inicial"	,Ctod("")						,""		,"" 											,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Embarque Final"	,Ctod("")						,""		,"U_VLDTINIF(MV_PAR03, MV_PAR04, _nInterval)"	,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Nº do Pedido"			,Space(tamSx3("C5_NUM")[1])		,"@!"	,""												,""		,"",050,.F.})	// Não Posso usar a consulta SXB SC5. A tabela é exclusiva e o relatorio é multi-filial  
	aAdd(_aParambox,{1,"Nº da Nota Fiscal"		,Space(tamSx3("C6_NOTA")[1])	,"@!"	,""												,""		,"",050,.F.})	// Não Posso usar a consulta SXB SF2. A tabela é exclusiva e o relatorio é multi-filial  
	aAdd(_aParambox,{1,"Especie de Pedido "		,Space(tamSx3("C5_ZTIPPED")[1])	,"@!"	,""												,"SZJ2"	,"",050,.F.})	// Não Posso usar a consulta SXB SF2. A tabela é exclusiva e o relatorio é multi-filial  
	aAdd(_aParambox,{1,"Cod. Cliente Inicial:"	,Space(tamSx3("A1_COD")[1])		,""		,""												,"CLI"	,,050,.F.}) //Rafael 30/07/2019
	aAdd(_aParambox,{1,"Cod. Cliente Final:"	,Space(tamSx3("A1_COD")[1])		,""		,"U_VLFIMMAI(MV_PAR08, MV_PAR09, 'Cod. Cliente')"	,"CLI"	,,050,.F.})//Rafael 30/07/2019
	
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecão das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	
	IF Empty(_aRet[2]) .and. Empty(_aRet[4])
		MsgStop("É obrigatório o preenchimento do parâmetro data de Emissão Final e/ou do parâmetro data de Embarque Final.")
		Return.F.

	ElseIf ( !Empty(_aRet[2]) .and.  !U_VLDTINIF(stod(_aRet[1]), stod(_aRet[2]), _nInterval) ) .or. ( !Empty(_aRet[4]) .and.  !U_VLDTINIF(stod(_aRet[3]), stod(_aRet[4]), _nInterval) )
		Return.F.

	ElseIf _aRet[1] > _aRet[2]
		MsgStop("A Data de Emissão Inicial, não pode ser maior que a data de Emissão Final.")
		Return.F.

	ElseIf _aRet[3] > _aRet[4]
		MsgStop("A Data de Embarque Inicial, não pode ser maior que a data de Embarque Final.")
		Return.F.
	Endif

//===		S E L E C I O N A    F A M I L I A    B I
	cQryFamiBI	:= "SELECT '" +SPACE(TamSx3("ZDD_COD")[1])+ "' as ZDD_COD, 'Não Informado' as ZDD_DESCR, ' ' as ZDD_SUBGRP, ' ' as ZDD_DESGRP, ' ' as ZDD_STATUS  FROM DUAL UNION ALL "
	cQryFamiBI	+= "SELECT DISTINCT ZDD_COD, ZDD_DESCR, ZDD_SUBGRP, ZDD_DESGRP, ZDD_STATUS "
	cQryFamiBI  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("ZDD")) + " TMPZDD " 
	cQryFamiBI	+= "  WHERE TMPZDD.D_E_L_E_T_ = ' ' " 
	cQryFamiBI  += "  ORDER BY ZDD_COD " 

	aCpoFamiBI	:=	{	{"ZDD_COD"		,U_X3Titulo("ZDD_COD")		,TamSx3("ZDD_COD")[1]}	 ,; 
						{"ZDD_DESCR"	,U_X3Titulo("ZDD_DESCR")	,TamSx3("ZDD_DESCR")[1]}	 ,; 
						{"ZDD_SUBGRP"	,U_X3Titulo("ZDD_SUBGRP")	,TamSx3("ZDD_SUBGRP")[1]}	 ,; 
						{"ZDD_DESGRP"	,U_X3Titulo("ZDD_DESGRP")	,TamSx3("ZDD_DESGRP")[1]}	 ,; 
						{"ZDD_STATUS"	,U_X3Titulo("ZDD_STATUS")	,TamSx3("ZDD_STATUS")[1]}	 } 
	cTitFamiBI	:= "Marque as familias BI a serem listadas: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: A6_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botão cancelar da MarkGene.
	//.T. no _lCancProg, após a Markgene, indica que realmente foi teclado o botão cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, após a Markgene, indica que realmente não foi teclado o botão cancelar ou que mesmo ele teclado, não devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcação dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botão cancelar da MarkGene
	_cFamiliBi	:= U_Array_In( U_MarkGene(cQryFamiBI, aCpoFamiBI, cTitFamiBI, nPosRetorn, @_lCancProg ) )
	
	If _lCancProg
		Return
	Endif 
 
	// SÃO DUAS DATAS (EMISSÃO E EMBARQUE, É OBRIGATORIO A SELEÇÃO DE UMA DAS DATAS) - INCLUIR A VALIDAÇÃO DOS 35 DIAS
	_cQuery += " FROM " + U_IF_BIMFR("IF_BIMFR", "V_FAT_SAIDANFUNIDADES") +" V "  + CRLF 
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),  " CODIGO_FILIAL IN "             + _cCODFILIA	) // OBRIGATORIO (SELEÇÃO DO COMBO)  CAMPO FILIAL(06 posições)
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),    " DT_EMISSAO_FILTRO  BETWEEN '"  + _aRet[1] + "' AND '" + _aRet[2] + "' " ) // OBRIGATORIO, COM A VALIDAÇÃO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),    " DT_EMBARQUE_FILTRO  BETWEEN '" + _aRet[3] + "' AND '" + _aRet[4] + "' " ) // OBRIGATORIO, COM A VALIDAÇÃO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_aRet[5] ),    " NUMERO_PEDIDO = '"             + _aRet[5] + "' "	                       ) 
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),    " NUMERO_NFS = '"                + _aRet[6] + "' "	                       ) 
	_cQuery += U_WhereAnd( !empty(_aRet[7] ),    " ESPECIE_FILTRO = '"            + _aRet[7] + "' "	                       ) // NÃOO OBRIGATORIO **NOVO FILTRO**
	_cQuery += U_WhereAnd( !empty(_aRet[9] ),    " COD_CLIENTE_FILTRO BETWEEN '"         + _aRet[8] + "' AND '" + _aRet[9] + "' " ) // NÃO OBRIGATORIO Rafael 30/07/2019
	If Empty(_cFamiliBi)
		_cQuery +=  ""		// Não incrementa a clausula Where
	ElseIF AT("' '", _cFamiliBi ) <> 0
		_cQuery += U_WhereAnd(  .T. ,            " ( FAMILIA_FILTRO IS NULL OR FAMILIA_FILTRO IN " + _cFamiliBi + " )"     ) 
	Else	
		_cQuery += U_WhereAnd(  .T. ,            " FAMILIA_FILTRO IN " + _cFamiliBi	                                       ) 	
	Endif

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()	})

RETURN

