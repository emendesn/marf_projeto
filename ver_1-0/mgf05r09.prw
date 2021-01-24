#include "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³ MGF05R09	ºAutor  ³ Geronimo Benedito Alves																	ºData ³  06/12/18  º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.		³ Rotina que mostra na tela os dados da planilha: FATURAMENTO - Pedidos empenhados   (Módulo 05-FAT)                               º±±
//±±º			³ Os dados sao obtidos e mostrados na tela atravéz da execução de query, e depois, o usuario pode gerar uma planilha excel com elesº±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso		³ Marfrig Global Foods																											   º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

User Function MGF05R09()
	 
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Faturamento - Pedidos Empenhados"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerá na regua de processamento.
	Aadd(_aDefinePl, "Pedidos Empenhados"				)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Pedidos Empenhados"}				)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Pedidos Empenhados"}				)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}									)	//05-	Array de Arrays que define quais colunas serão mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, será mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }						)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluído naquela aba  
	
	_aCpoExce	:= {}
	_cTmp01		:= ""

	// 1-Campo Base (existente no SX3), 2-Nome campo, 3-Titulo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture P/ Transform, 8-Apelido, 9-PictVar 
	// O nome do campo está no elemento 2, mas, se é usado alguma função (Sum,Count,max,Coalesc,etc), ou o nome do campo tem mais de 10 letras é  
	// dado a ele um apelido indicado pela clausula "as" que será transportado para o elemento 8.
	// Se o campo do elemento 1 existir no SX3, as propriedades do registro do SX3 são sobrepostos aos elemntos do Array, não precisando declara-los.		
	// As unicas exceções são os elemento 2-Nome campo que sempre deve ser declarado, e o campo 3-Titúlo, que se no array _aCampoQry, estiver preenchido,
	// é preservado, não sendo sobreposto pelo X3_DESCRIC 
	//					01			 02					 03							 04		 05	 06	 07		 08	 09
	Aadd(_aCampoQry, {"C5_FILIAL"	,"COD_FILIAL"		,"Código Filial"			,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"M0_FILIAL"	,"DESC_FILIAL"		,"Nome Filial"				,"C"	,40	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"C5_NUM"		,"PEDIDO"			,"Pedido"					,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"C5_CLIENTE"	,"COD_CLIENTE"		,"Cód Cliente"				,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"C5_LOJACLI"	,"LOJA_CLIENTE"		,"Loja Cliente"				,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_CLIENTE"		,"Nome Cliente"				,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"C5_XCGCCPF"	,"CNPJ_CLIENTE"		,"CNPJ Cliente"				,"C"	,22	,0	,"@!"	,""		,"@!" })
	Aadd(_aCampoQry, {"C6_ITEM"		,"ITEM_PEDIDO"		,"Item"						,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"C6_PRODUTO"	,"COD_PRODUTO"		,"Cód. Produto"				,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"C6_DESCRI"	,"DESCRICAO"		,"Descrição"				,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"C5_EMISSAO"	,"DATA_EMISSAO"		,"Emissão"					,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"C9_QTDLIB"	,"QUANT_EMPRENHADA"	,"Quant. Empenhada"			,""		,""	,""	,""		,""		,""	})

	aAdd(_aParambox,{1,"Data Emissão Inicial"	,Ctod("")						,""		,""													,""		,,050,.T.})
	aAdd(_aParambox,{1,"Data Emissão Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Emissão')"	,""		,,050,.T.})
	aAdd(_aParambox,{1,"Pedido Inicial:"		,Space(tamSx3("C5_NUM")[1])		,""		,""													,""		,,050,.F.})
	aAdd(_aParambox,{1,"Pedido Final:"			,Space(tamSx3("C5_NUM")[1])		,""		,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Pedido de Venda')",""		,,050,.F.})

	SetKey(K_CTRL_F8,{||U_BIEmlini("Bi_e_Protheus")}) ;SetKey(K_CTRL_F9,{||U_BIEmlini("Protheus")})	// CTRL+F8 (Codigo inkey -27), executa a funcão que irá alimentar a array, para o envio do email com a query do relatório para a equipe de desenvolvimento do B.I. e do Protheus.            // CTRL+F9 (Codigo inkey -28), envia o email somente para a equipe de desenvolvimento do Protheus.
	If Len(_aParambox) > 0
		_lRet := ParamBox(_aParambox, _aDefinePl[2], @_aRet	,,	,,	,,	,,.T.,.T. )	// PARAMBOX obtêm os parametros da query que gerará o relatorio
	Endif
	SetKey(K_CTRL_F8,{||}) ; SetKey(K_CTRL_F9,{||})	// Cancela a associação das teclas CTRL+F8 (Codigo inkey -27) e CTRL+F9 (Codigo inkey -28)
	If ! U_ParameR2(_aParambox, _bParameRe, @_aRet ,_lRet ) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecão das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR",	"V_FAT_PEDIDOSEMPENHADO"  )	+ CRLF
	_cQuery += U_WhereAnd( .T.,						" COD_FILIAL IN "			+ _cCODFILIA	                           ) //OBRIGATORIO (SELEÇÃO DO COMBO)  CAMPO FILIAL(06 posições)
	_cQuery += U_WhereAnd( .T. ,      				" DATA_EMISSAO BETWEEN '" 	+ _aRet[1]  + "' AND '" + _aRet[2]  + "' " ) //OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),		" PEDIDO BETWEEN '" 		+ _aRet[3]  + "' AND '" + _aRet[4]  + "' " ) //NAO OBRIGATORIO

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN

