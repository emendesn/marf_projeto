#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF05R06	�Autor  � Geronimo Benedito Alves																	�Data �  02/07/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.     � Rotina que mostra na tela os dados da planilha: FATURAMENTO - Pedidos Bloqueados                               (Modulo 05-FAT)    ���
//���          � Os dados sao obtidos e mostrados na tela atraves da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso       � Cliente Global Foods                                                                                                              ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF05R06()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Faturamento - Pedidos Bloqueados"	)	//01-  _cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Pedidos Bloqueados"				)	//02-  _cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Pedidos Bloqueados"}				)	//03-  _cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Pedidos Bloqueados"}				)	//04-  _cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  )									//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } )							//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02											 03								 04		 05	  06	07		08	09		
	Aadd(_aCampoQry, {"C5_FILIAL"	,"EMPRESA"									,"Cod. Empresa"					,""		,""	,"" 	,""		,""	,""	})
	AAdd(_aCampoQry, {"C5_NUM"		,"PEDIDO"									,"N� Pedido"					,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_EMISSAO"	,"DATA_EMISSAO				as DT_EMISSAO"	,"Data Emissao"					,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_CLIENTE"	,"CLIENTE"									,"Cod. Cliente"					,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_LOJACLI"	,"LOJA_CLIENTE				as LJ_CLIENTE"	,"Loja Cliente"					,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_LOJAENT"	,"LOJA_ENTREGA				as LJ_ENTREGA"	,"Loja Entrega"					,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_XCGCCPF"	,"CNPJ"										,"CPF/CNPJ Cliente"				,"C"	,018,0		,"@!"	,"","@!"	})
	Aadd(_aCampoQry, {"C5_ZBLQRGA"	,"STATUS"									,"Status"						,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_ZTIPPED"	,"ESPECIE_PEDIDO			as ESPECIEPED"	,"Especie Pedido"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_CONDPAG"	,"COD_CONDICAO				as CDCONDICAO"	,"Cod. Condicao"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_TABELA"	,"TABELA_PRECO				as TAB_PRECO" 	,"Tabela Preco"					,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_FECENT"	,"DATA_ENTREGA				as DT_ENTREGA"	,"Data Entrega"					,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_ZDTEMBA"	,"DATA_EMBARQU				as DTEMBRAQUE"	,"Data Embarque"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_ZIDEND"	,"COD_ENDERECO				as CDENDERECO"	,"Cod. Endereco"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_ZENDER"	,"ENDERECO"									,"Endereco"						,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_CLIENTE				as NOM_CLIENT"	,"Nome Cliente"					,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZP_CODREG"	,"COD_REGIAO"								,"Cod. da Regiao"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZP_DESCREG"	,"REGIAO"									,"Nome da Regiao"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A3_COD"		,"CODIGO_VENDEDOR			as COD_VENDED"	,"Cod. Vendedor"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A3_NOME"		,"NOME_VENDEDOR				as NOM_VENDED"	,"Nome Vendedor"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_MUN"		,"CIDADE"									,"Cidade"						,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_EST"		,"ESTADO"									,"Estado"						,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_ZCROAD"	,"COD_ROTEIRIZACAO			as CD_ROTEIRI"	,"Cod. Roteirizacao"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_PRODUTO"	,"COD_PRODUTO				as CD_PRODUTO"	,"Cod. Produto"					,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_DESCRI"	,"DESCRICAO"								,"Descr. Produto"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_QTDVEN"	,"QUANT_SOLICITADA			as QTDESOLICI"	,"Qtde Solicitada"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_PRCVEN"	,"PRECO_VENDA  				as PRECOVENDA"	,"Preco da Venda"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_PRUNIT"	,"PRECO_TABELA 				as PRECOTABEL"	,"Preco de Tabela"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_VALOR"	,"VALOR"									,"Valor"						,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_DESCONT"	,"DESCONTO"									,"Desconto"						,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_DATFAT"	,"DATA_FATURAMENTO			as DT_FATURAM"	,"Data Faturamento"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_NOTA"		,"N_NF"										,"N� Nota Fiscal"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_SERIE"	,"N_SERIE"									,"Serie NF"						,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_QTDENT"	,"QUANT_ATENDIDA 			as QTDEATENDI"	,"Qtde Atendida"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_ZDTMIN"	,"DATA_MINIMA				as DT_MINIMA" 	,"Data Minima"					,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_ZDTMAX"	,"DATA_MAXIMA				as DT_MAXIMA" 	,"Data Maxima"					,""		,""	,"" 	,""		,""	,""	})
	AAdd(_aCampoQry, {"Z9_ZREGIAO"	,"COD_REG_ENTREGA			as CD_ENTREGA"	,"Cod. Reg. Entrega"			,""		,""	,"" 	,""		,""	,""	})
	AAdd(_aCampoQry, {"ZP_DESCREG"	,"REG_ENTREGA				as RG_ENTREGA"	,"Descr. Registro de Entrega"	,""		,""	,"" 	,""		,""	,""	})
	AAdd(_aCampoQry, {"Z9_ZMUNIC"	,"CID_ENTREGA				as CID_ENTREG"	,"Cidade Entrega"				,""		,""	,"" 	,""		,""	,""	})
	AAdd(_aCampoQry, {"Z9_ZEST"		,"UF_ENTREGA"								,"UF Entrega"					,""		,""	,"" 	,""		,""	,""	})
	AAdd(_aCampoQry, {"C5_ZROAD"	,"PEDIDO_ROTEIRIZADO 		as PEDIDOROTE"	,"Pedido Roteirizado"			,"C"	,006,000	,""		,""	,""	})
	AAdd(_aCampoQry, {"XXTIPOFRET"	,"TIPO_FRETE"								,"Tipo Frete"					,"C"	,020,000	,""		,""	,""	})
	AAdd(_aCampoQry, {"C5_ZCROAD"	,"COD_ROTEIRIZACAO_ENTREGA 	as CODROTEENT"	,"Cod Rote Entrega"				,""		,""	,"" 	,""		,""	,""	})
	AAdd(_aCampoQry, {"DA3_PLACA"	,"PLACA"									,"Placa"						,""		,""	,"" 	,""		,""	,""	})
	AAdd(_aCampoQry, {"ZBD_DESCRI"	,"DIRETORIA"								,"Diretoria"					,""		,""	,"" 	,""		,""	,""	})
	AAdd(_aCampoQry, {"ZV_DTBLQ"	,"DATA_BLOQUEIO"							,"Data Bloqueio"				,""		,""	,"" 	,""		,""	,""	})
	AAdd(_aCampoQry, {"ZT_DESCRI"	,"DESCRICAO_BLOQUEIO"						,"Descricao Bloqueio"			,""		,""	,"" 	,""		,""	,""	})
	AAdd(_aCampoQry, {"XXZV_DTAPR"	,"STATUS_BLOQUEIO"							,"Status Bloqueio"				,"C"	,030,000	,""		,""	,""	})
	AAdd(_aCampoQry, {"CN9_ZDESCF"	,"PER_DESCONTO_CONTRATO"					,"% Desconto Contrato"			,""		,""	,"" 	,""		,""	,""	})
	AAdd(_aCampoQry, {"CN9_ZACORD"	,"PER_ACORDO_CONTRATO"						,"% Acordo Contrato"			,""		,""	,"" 	,""		,""	,""	})
	AAdd(_aCampoQry, {"ZV_DTBLQ"	,"DATA_REEMBARQUE"							,"Data Reembarque"				,""		,""	,"" 	,""		,""	,""	})
	AAdd(_aCampoQry, {"C5_ZCODUSU"	,"COD_USUARIO"								,"Cod Usuario"					,""		,""	,"" 	,""		,""	,""	})//Rafael 30/07/19
	AAdd(_aCampoQry, {"C5_ZNOMUSU"	,"NOME_USUARIO"								,"Nome Usuario"					,""		,""	,"" 	,""		,""	,""	})//Rafael 30/07/19

	
	aAdd(_aParambox,{1,"Data Entrega Inicial"	,Ctod("")						,""		,""													,""		,,050,.F.})
	aAdd(_aParambox,{1,"Data Entrega Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Entrega')"	,""		,,050,.F.})
	aAdd(_aParambox,{1,"Data Emissao Inicial"	,Ctod("")						,""		,""													,""		,,050,.F.})
	aAdd(_aParambox,{1,"Data Emissao Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Data Emissao')"	,""		,,050,.F.})
	aAdd(_aParambox,{1,"Cod. Produto Inicial:"	,Space(tamSx3("C6_PRODUTO")[1])	,""		,""													,"SB1"	,,050,.F.})
	aAdd(_aParambox,{1,"Cod. Produto Final:"	,Space(tamSx3("C6_PRODUTO")[1])	,""		,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Cod. Produto')"	,"SB1"	,,050,.F.})
	aAdd(_aParambox,{1,"Cod. Vendedor Inicial:",Space(tamSx3("A3_COD")[1])		,""		,""													,"SA3"	,,050,.F.})
	aAdd(_aParambox,{1,"Cod. Vendedor Final:"	,Space(tamSx3("A3_COD")[1])		,""		,"U_VLFIMMAI(MV_PAR07, MV_PAR08, 'Cod. Vendedor')"	,"SA3"	,,050,.F.})
	aAdd(_aParambox,{1,"Especie Pedido:"		,Space(tamSx3("C5_ZTIPPED")[1])	,"@!"	,""													,"SZJ2"	,,050,.F.})
	aAdd(_aParambox,{1,"Cod. Cliente Inicial:"	,Space(tamSx3("A1_COD")[1])		,""		,""													,"CLI"	,,050,.F.})
	aAdd(_aParambox,{1,"Cod. Cliente Final:"	,Space(tamSx3("A1_COD")[1])		,""		,"U_VLFIMMAI(MV_PAR10, MV_PAR11, 'Cod. Cliente')"	,"CLI"	,,050,.F.})
	aAdd(_aParambox,{1,"Data Embarque Inicial"	,Ctod("")						,""		,""													,""		,,050,.F.})
	aAdd(_aParambox,{1,"Data Embarque Final"	,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR12, MV_PAR13, 'Data Embarque')"	,""		,,050,.F.})
	aAdd(_aParambox,{1,"N� do Pedido:"			,Space(tamSx3("C5_NUM")[1])		,"@!"	,""													,""		,,050,.F.})
	aAdd(_aParambox,{1,"Data Reembarque Inicial",Ctod("")						,""		,""													,""		,,050,.F.})
	aAdd(_aParambox,{1,"Data Reembarque Final"	,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR15, MV_PAR16, 'Data Reembarque')",""		,,050,.F.})


////aAdd(_aParambox,{1,"Tipo Produto Final"		,Space(tamSx3("X5_CHAVE")[1])	,""		,"U_VLFIMMAI(MV_PAR07,MV_PAR08,'Tipo de Produto')"	,"02"	,"",070,.F.})

	aAdd(_aParambox,{3,"Status do Pedido"		,Iif(Set(_SET_DELETED),1,2), 	{"TODOS","FATURADO","NAO FATURADO" }, 100, "",.F.})
	
	//aAdd(_aParambox,{3,"Listar Fornecedor ou Cliente"	,Iif(Set(_SET_DELETED),1,2), {"Fornecedor","Cliente","Ambos" }, 100, "",.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	//Status Pedido � usuario digita, sem consulta gen�rica e nao obrigatorio
	//Pedido� usuario digita, sem consulta gen�rica e nao obrigatorio
 
	If _aRet[17] <> 1	// 1=Todos
		_cStatPedi	:= If(_aRet[17] == 2, "FATURADO" , "NAO FATURADO" )
	Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	
//	IF Empty(_aRet[2]) .and. Empty(_aRet[4])
//		MsgStop("� obrigatorio o preenchimento do parametro data de Entrega Final e/ou do parametro data de Emissao Final.")
//		Return.F.
//	Endif

	If _aRet[1] > _aRet[2]
		MsgStop("A Data de Entrega Inicial, nao pode ser maior que a data de Entrega Final.")
		Return.F.
	Endif
	If _aRet[3] > _aRet[4]
		MsgStop("A Data de Emissao Inicial, nao pode ser maior que a data de Emissao Final.")
		Return.F.
	Endif
	
	//===		S E L E C I O N A	D I R E T O R I A
	cQryDireto	:= "SELECT ' Nao Informado' as ZBD_CODIGO, '" +SPACE(TamSx3("ZBD_DESCRI")[1])+ "' as ZBD_DESCRI FROM DUAL UNION ALL "	// Coloco um espaco no come�o de " Nao Informado" para este registro aparecer na 1� linha do Browse 
	cQryDireto	+= "SELECT DISTINCT ZBD_CODIGO, ZBD_DESCRI "
	cQryDireto  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("ZBD")) + " TMPZBD " 
	cQryDireto	+= "  WHERE TMPZBD.D_E_L_E_T_ = ' ' " 
	cQryDireto	+= "  ORDER BY ZBD_CODIGO, ZBD_DESCRI"
	aCpoDireto	:=	{	{ "ZBD_CODIGO"	,"Codigo"		,TamSx3("ZBD_CODIGO")[1] + 50	}	,;
						{ "ZBD_DESCRI"	,"Diretoria"	,TamSx3("ZBD_DESCRI")[1] 		}	 } 
	cTitDireto	:= "Pa�ses dos portos de Destinos a serem listados: "
	nPosRetorn	:= 2		// Quero que seja retornado o primeiro campo: A6_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o Botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o Botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
	_cDiretori	:= U_Array_In( U_MarkGene(cQryDireto, aCpoDireto, cTitDireto, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif
	
	//_cNacional := 	 AND NACIONAL IN ('NOVOS NEGOCIOS', 'FOOD & VAREJO', 'NAO INFORMADO')  --NAO OBRIGATORIO, USUARIO SELECIONA VARIAS OP��ES (COLOQUEI NAO INFORMADO)
	//SELECT ZBE_DIRETO ,ZBE_CODIGO ,ZBE_DESCRI FROM ZBE010 WHERE D_E_L_E_T_ = ' ' ORDER BY ZBE_FILIAL, ZBE_CODIGO, ZBE_DIRETO 
	//cQryDireto	:= "SELECT ' Nao Informado' as ZBD_CODIGO, '" +SPACE(TamSx3("ZBD_DESCRI")[1])+ "' as ZBD_DESCRI FROM DUAL UNION ALL "	// Coloco um espaco no come�o de " Nao Informado" para este registro aparecer na 1� linha do Browse 
	//===		S E L E C I O N A 	   N A C I O N A L
	/*
	cQryNacion	:= "SELECT '" +SPACE(TamSx3("ZBE_DIRETO")[1])+ "' as ZBE_DIRETO ,'" +SPACE(TamSx3("ZBE_CODIGO")[1])+ "' as ZBE_CODIGO ,'NAO INFORMADO' as ZBE_DESCRI ,'      ' as ZBE_REPRES FROM DUAL UNION ALL "
	cQryNacion	+= "SELECT DISTINCT ZBE_DIRETO ,ZBE_CODIGO ,ZBE_DESCRI ,ZBE_REPRES "
	cQryNacion  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("ZBE") ) + " TMPZBE " 
	cQryNacion	+= "  WHERE TMPZBE.D_E_L_E_T_ = ' ' " 
	cQryNacion	+= "  ORDER BY ZBE_DIRETO ,ZBE_CODIGO "
	aCpoNacion	:=	{	{ "ZBE_DIRETO"	,"Diretoria"	,TamSx3("ZBE_DIRETO")[1] + 30	}	,;
						{ "ZBE_CODIGO"	,"Codigo"		,TamSx3("ZBE_CODIGO")[1] + 30	}	,;
						{ "ZBE_DESCRI"	,"Descricao"	,TamSx3("ZBE_DESCRI")[1] + 30	}	,;
						{ "ZBE_REPRES"	,"Representante",TamSx3("ZBE_REPRES")[1] 		}	 } 
	cTitNacion	:= "Descri��es das operacoes Nacionais a serem listadas: "
	nPosRetorn	:= 3		// Quero que seja retornado o primeiro campo: A6_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o Botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o Botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
	_cNacional	:= U_Array_In( U_MarkGene(cQryNacion, aCpoNacion, cTitNacion, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif
	*/

	//===		S E L E C I O N A 	   T A T I C O 
	cQryTatico	:= "SELECT 'SEM PORTADOR' as ZBF_DESCRI FROM DUAL UNION ALL "
	cQryTatico	+= "SELECT DISTINCT ZBF_DESCRI"
	cQryTatico  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("ZBF")  ) + " TMPZBF "
	cQryTatico	+= "  WHERE TMPZBF.D_E_L_E_T_ = ' ' " 
	cQryTatico	+= "  ORDER BY ZBF_DESCRI"

	aCpoTatico	:=	{	{ "ZBF_DESCRI"	,U_X3Titulo("ZBF_DESCRI")	,TamSx3("ZBF_DESCRI")[1] }	} 
	cTitTatico	:= "Marque os Cod. Tatico a serem listadas: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: ZBF_DESCRI
	
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o Botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o Botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
	_cTatico	:= U_Array_In( U_MarkGene(cQryTatico, aCpoTatico, cTitTatico, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 

	_cQuery += " FROM " + U_IF_BIMFR( "IF_BIMFR",   "V_FAT_PEDIDOSBLOQUEADOS" )        + CRLF 
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),     " EMPRESA IN "                     + _cCODFILIA	                         	  ) // OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),       " DATA_ENTREGA_FILTRO BETWEEN '"   + _aRet[1]  + "' AND '" + _aRet[2] + "'  " ) // NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),       " DATA_EMISSAO_FILTRO BETWEEN '"   + _aRet[3]  + "' AND '" + _aRet[4] + "'  " ) // NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),       " COD_PRODUTO BETWEEN '"           + _aRet[5]  + "' AND '" + _aRet[6] + "'  " ) // NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[8] ),       " CODIGO_VENDEDOR BETWEEN '"       + _aRet[7]  + "' AND '" + _aRet[8] + "'  " ) // NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[9] ),       " ESPECIE_PEDIDO LIKE '%"          + _aRet[9]  + "%' "	                      ) // NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[11] ),      " COD_CLIENTE_FILTRO BETWEEN '"    + _aRet[10] + "' AND '" + _aRet[11] + "' " ) // NAO OBRIGATORIO
	If !Empty(_aRet[04])
		_cQuery += U_WhereAnd( !empty(_aRet[4] ),       " DATA_EMISSAO_FILTRO BETWEEN '"   + _aRet[3]  + "' AND '" + _aRet[4] + "'  " ) // NAO OBRIGATORIO
	EndIf
	
	If !Empty(_aRet[13])
		_cQuery += U_WhereAnd( !empty(_aRet[13] ),      " DATA_EMBARQUE_FILTRO BETWEEN '"  + _aRet[12] + "' AND '" + _aRet[13] + "' " ) // NAO OBRIGATORIO - SEM TRAVA
	EndIf
	
	If !Empty(_aRet[16])
		_cQuery += U_WhereAnd( !empty(_aRet[16] ),      " DATA_REEMBARQUE_FILTRO BETWEEN '"+ _aRet[15] + "' AND '" + _aRet[16] + "' " ) // NAO OBRIGATORIO - SEM TRAVA
	EndIf


	If Empty( _cDiretori )	// ZBD_DESCRI
		_cQuery +=  ""		// Nao incrementa a clausula Where
	ElseIF AT("' '", _cDiretori ) <> 0 
		_cQuery += U_WhereAnd(  .T. , " ( DIRETORIA IS NULL OR DIRETORIA IN " + _cDiretori + " )"                                 )
	Else	
		_cQuery += U_WhereAnd(  .T. , " DIRETORIA IN "                        + _cDiretori                                        )	
	Endif
	
	_cQuery += U_WhereAnd( !empty(_aRet[14] ),      " PEDIDO LIKE '%"                       + _aRet[14]  + "%' "                  ) // NAO OBRIGATORIO
	
	If _aRet[17] <> 1	// 1=Todos
		_cQuery += U_WhereAnd(  .T.  ,              " STATUS_PEDIDO = '"          		    + _cStatPedi + "' "	                  ) // NAO OBRIGATORIO
	Endif 
		
//	_cQuery += U_WhereAnd( !empty(_cNacional ),              " NACIONAL IN " + _cNacional	                                        )	// NAO OBRIGATORIO	


	If empty(_cTatico)
		_cQuery +=  ""		// Nao incrementa a clausula Where
	ElseIF AT("' '", _cTatico ) <> 0
		_cQuery += U_WhereAnd(  .T. , " ( TATICO IS NULL OR TATICO IN " + _cTatico + " )"                             ) 
	Else	
		_cQuery += U_WhereAnd(  .T. , " TATICO IN " + _cTatico                                                              ) 	
	Endif

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()	})

RETURN