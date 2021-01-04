#INCLUDE "totvs.ch" 
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"                            
#include "parmtype.ch"
#include "rwmake.ch"

/*
{Protheus.doc} MGF05R03 
Rotina que mostra na tela os dados da planilha: FATURAMENTO - Carregamento e Pedidos					

@author Geronimo Benedito Alves
@since 24/04/18  
@menu Faturamento->Relatorios->Especificos->Carregamento e pedidos
*/

User Function MGF05R03()

	Private _aRet		:= {}, _aParambox := {}, _bParameRe
	Private _aDefinePl 	:= {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil	:= {}
	Private _cWhereAnd	:= ""
	Private _aEmailQry	:= {}

	AADD(_aDefinePl, "Faturamento - Carregamento e Pedidos"	)	//01-  _cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	AADD(_aDefinePl, "Carregamento e Pedidos"				)	//02-  _cArqName  - Nome da planilha Excel a ser criada
	AADD(_aDefinePl, {"Carregamento e Pedidos"}				)	//03-  _cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	AADD(_aDefinePl, {"Carregamento e Pedidos"}				)	//04-  _cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	AADD(_aDefinePl, {}  )										//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	AADD(_aDefinePl, { {||.T.} } )								//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02											 03								 04		05	 06	 07		 08	 09		
	AADD(_aCampoQry, {"C5_FILIAL"	,"EMPRESA"									,"Cod. Empresa"					,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C5_NUM"		,"PEDIDO"									,"N� Pedido"					,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C5_EMISSAO"	,"DATA_EMISSAO			 	as DT_EMISSAO"	,"Data Emissao"					,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C5_CLIENTE"	,"CLIENTE"									,"Cod. Cliente"					,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C5_LOJACLI"	,"LOJA_CLIENTE			 	as LJ_CLIENTE"	,"Loja Cliente"					,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C5_LOJAENT"	,"LOJA_ENTREGA			 	as LJ_ENTREGA"	,"Loja Entrega"					,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C5_XCGCCPF"	,"CNPJ"										,"CPF/CNPJ Cliente"				,"C"	,18	,0	,"@!"	,""	,"@!"})
	AADD(_aCampoQry, {"C5_ZTMSINT"	,"INTEGRAD_TMS"	    						,"Integrado TMS"				,""		,	, 	,""		,""	,""	}) // Paulo Henrique - TOTVS - 09/09/2019 - RTASK0010017
	AADD(_aCampoQry, {"C5_ZBLQRGA"	,"STATUS"									,"Status"						,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C5_ZTIPPED"	,"ESPECIE_PEDIDO			as ESPECIEPED"	,"Especie Pedido"				,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C5_CONDPAG"	,"COD_CONDICAO			 	as CDCONDICAO"	,"Cod. Condicao"				,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C5_TABELA"	,"TABELA_PRECO			 	as TAB_PRECO" 	,"Tabela Preco"					,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C5_FECENT"	,"DATA_ENTREGA			 	as DT_ENTREGA"	,"Data Entrega"					,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C5_ZDTEMBA"	,"DATA_EMBARQUE			 	as DTEMBRAQUE"	,"Data Embarque"				,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"F2_CARGA"	,"ORDEM_EMBARQUE"							,"Ordem Embarque"				,""		,	, 	,""		,""	,""	}) // 30/10/2019 - RTAKS0010337
	AADD(_aCampoQry, {"C5_ZIDEND"	,"COD_ENDERECO			 	as CDENDERECO"	,"Cod. Endereco"				,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C5_ZENDER"	,"ENDERECO"									,"Endereco"						,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"A1_NOME"		,"NOME_CLIENTE				as NOM_CLIENT"	,"Nome Cliente"					,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"ZP_CODREG"	,"COD_REGIAO"								,"Cod. da Regiao"				,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"ZP_DESCREG"	,"REGIAO"									,"Nome da Regiao"				,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"A3_COD"		,"CODIGO_VENDEDOR			as COD_VENDED"	,"Cod. Vendedor"				,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"A3_NOME"		,"NOME_VENDEDOR				as NOM_VENDED"	,"Nome Vendedor"				,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"A1_MUN"		,"CIDADE"									,"Cidade"						,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"A1_EST"		,"ESTADO"									,"Estado"						,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"A1_ZCROAD"	,"COD_ROTEIRIZACAO  		as CD_ROTEIRI"	,"Cod. Roteirizacao"			,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C6_PRODUTO"	,"COD_PRODUTO				as CD_PRODUTO"	,"Cod. Produto"					,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C6_DESCRI"	,"DESCRICAO"								,"Descr. Produto"				,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C6_QTDVEN"	,"QUANT_SOLICITADA  		as QTDESOLICI"	,"Qtde Solicitada"				,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C6_PRCVEN"	,"PRECO_VENDA  			 	as PRECOVENDA"	,"Preco da Venda"				,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C6_PRUNIT"	,"PRECO_TABELA 			 	as PRECOTABEL"	,"Preco de Tabela"				,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C6_VALOR"	,"VALOR"									,"Valor"						,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C6_DESCONT"	,"DESCONTO"									,"Desconto"						,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C6_DATFAT"	,"DATA_FATURAMENTO  		as DT_FATURAM"	,"Data Faturamento"				,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C6_NOTA"		,"N_NF"										,"N� Nota Fiscal"				,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C6_SERIE"	,"N_SERIE"									,"Serie NF"						,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C6_QTDENT"	,"QUANT_ATENDIDA 			as QTDEATENDI"	,"Qtde Atendida"				,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C6_ZQTDPEC"	,"QUANT_PECA_CAIXA"							,"Qtde Pe�a Caixa"				,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C6_ZDTMIN"	,"DATA_MINIMA				as DT_MINIMA" 	,"Data Minima"					,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C6_ZDTMAX"	,"DATA_MAXIMA				as DT_MAXIMA" 	,"Data Maxima"					,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"Z9_ZREGIAO"	,"COD_REG_ENTREGA			as CD_ENTREGA"	,"Cod. Reg. Entrega"			,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"ZP_DESCREG"	,"REG_ENTREGA				as RG_ENTREGA"	,"Descr. Registro de Entrega"	,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"Z9_ZMUNIC"	,"CID_ENTREGA				as CID_ENTREG"	,"Cidade Entrega"				,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"Z9_ZEST"		,"UF_ENTREGA"								,"UF Entrega"					,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C5_ZROAD"	,"PEDIDO_ROTEIRIZADO 		as PEDIDOROTE"	,"Pedido Roteirizado"			,"C"	,6	,0	,""		,""	,""	})
	AADD(_aCampoQry, {"XXTIPOFRET"	,"TIPO_FRETE"								,"Tipo Frete"					,"C"	,20	,0	,""		,""	,""	})
	AADD(_aCampoQry, {"C5_ZCROAD"	,"COD_ROTEIRIZACAO_ENTREGA	as CODROTEENT"	,"Cod Rote Entrega"				,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"DA3_PLACA"	,"PLACA"									,"Placa"						,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"XXC6DATFAT"	,"STATUS_PEDIDO				as STATUSPEDI"	,"Status Pedido"				,"C"	,12	,0	,""		,""	,""	})
	AADD(_aCampoQry, {"ZBD_DESCRI"	,"DIRETORIA"								,"Diretoria"					,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C6_BLQ"		,"STATUS_BLOQUEIO"							,"Status do Bloqueio Pedido"	,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C5_ZCODUSU"	,"COD_USUARIO"								,"Codigo do Usuario"			,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"C5_ZNOMUSU"	,"NOME_USUARIO"								,"Nome do Usuario"				,""		,	, 	,""		,""	,""	})
	AADD(_aCampoQry, {"ZV_DTBLQ"	,"DATA_REEMBARQUE"							,"Data Reembarque"				,""		,""	,"" ,""		,""	,""	})
	//RVBJ
	AADD(_aCampoQry, {"C5_PBRUTO"	,"C5_PBRUTO"								,"Peso Bruto"					,""		,""	,"" ,""		,""	,""	})
	AADD(_aCampoQry, {"C5_XVLDESC"	,"C5_XVLDESC"								,"Valor da Descarga"			,""		,""	,"" ,""		,""	,""	})

	AADD(_aCampoQry, {"SA1.A1_CEP"				,"CEP_CLIENTE"					,"CEP Cliente"					,""		,""	,"" ,""		,""	,""	})
	AADD(_aCampoQry, {"SA1.A1_END"				,"ENDERECO_CLIENTE"				,"Endereco Cliente"				,""		,""	,"" ,""		,""	,""	})
	AADD(_aCampoQry, {"SA1.A1_COMPLEM"			,"COMPLEMENTO_CLIENTE"			,"Complemento Cliente"			,""		,""	,"" ,""		,""	,""	})
	AADD(_aCampoQry, {"SA1.A1_BAIRRO"			,"BAIRRO_CLIENTE"				,"Bairro Cliente"				,""		,""	,"" ,""		,""	,""	})
	AADD(_aCampoQry, {"SA1.A1_DDD || SA1.A1_TEL","TELEFONE_CLIENTE"				,"Telefone Cliente"				,""		,18	,"" ,""		,""	,""	})
	AADD(_aCampoQry, {"PAI.YA_DESCR"			,"PAIS_CLIENTE"					,"Pais Cliente"					,""		,""	,"" ,""		,""	,""	})
	
	AADD(_aCampoQry, {"C5_MENNOTA"				,"C5_MENNOTA"					,"Mensagem nota"				,""		,	, 	,""		,""	,""	})	
	AADD(_aCampoQry, {"C5_ZMENNOT"				,"C5_ZMENNOT"					,"Mensagem nota 2"				,""		,	, 	,""		,""	,""	})	
	AADD(_aCampoQry, {"C6_PEDCLI"				,"C6_PEDCLI"					,"Pedido Cliente"				,""		,	, 	,""		,""	,""	})	

	//Monta os parametros
	aAdd(_aParambox,{1,"Data Entrega Inicial"	,Ctod("")						,""		,""													,""		,""	,050,.F.})			// 01
	aAdd(_aParambox,{1,"Data Entrega Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Entrega')"	,""		,""	,050,.F.})			// 02
	aAdd(_aParambox,{1,"Data Emissao Inicial"	,Ctod("")						,""		,""													,""		,""	,050,.F.})			// 03
	aAdd(_aParambox,{1,"Data Emissao Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Data Emissao')"	,""		,""	,050,.F.})			// 04
	//Necessario adicionar o filtro DATA_FATURAMENTO_FILTRO (nao obrigatorio), e quando solecionar nao � obrigatorio a selecao de outro filtro, relatorio 	
	aAdd(_aParambox,{1,"Data Faturamento Inicial"	,Ctod("")					,""		,""														,""		,""	,050,.F.})		// 05
	aAdd(_aParambox,{1,"Data Faturamento Final"		,Ctod("")					,""		,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Data Faturamento')"	,""		,""	,050,.F.})		// 06
	aAdd(_aParambox,{1,"Cod. Produto Inicial"	,Space(tamSx3("C6_PRODUTO")[1])	,""		,""													,"SB1"	,""	,050,.F.})			// 07
	aAdd(_aParambox,{1,"Cod. Produto Final"		,Space(tamSx3("C6_PRODUTO")[1])	,""		,"U_VLFIMMAI(MV_PAR07, MV_PAR08, 'Cod. Produto')"	,"SB1"	,""	,050,.F.})			// 08
	aAdd(_aParambox,{1,"Cod. Vendedor Inicial"	,Space(tamSx3("A3_COD")[1])		,""		,""													,"SA3"	,""	,050,.F.})			// 09
	aAdd(_aParambox,{1,"Cod. Vendedor Final"	,Space(tamSx3("A3_COD")[1])		,""		,"U_VLFIMMAI(MV_PAR09, MV_PAR10, 'Cod. Vendedor')"	,"SA3"	,""	,050,.F.})			// 10
	aAdd(_aParambox,{1,"Especie Pedido"			,Space(tamSx3("C5_ZTIPPED")[1])	,"@!"	,""													,"SZJ2"	,""	,050,.F.})			// 11
	aAdd(_aParambox,{1,"Cod. Cliente Inicial"	,Space(tamSx3("A1_COD")[1])		,""		,""													,"CLI"	,""	,050,.F.})			// 12
	aAdd(_aParambox,{1,"Cod. Cliente Final"		,Space(tamSx3("A1_COD")[1])		,""		,"U_VLFIMMAI(MV_PAR12, MV_PAR13, 'Cod. Cliente')"	,"CLI"	,""	,050,.F.})			// 13
	aAdd(_aParambox,{1,"Data Embarque Inicial"	,Ctod("")						,""		,""													,""		,""	,050,.F.})			// 14
	aAdd(_aParambox,{1,"Data Embarque Final"	,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR14, MV_PAR15, 'Data Embarque')"	,""		,""	,050,.F.})			// 15
	aAdd(_aParambox,{1,"N� do Pedido"			,Space(tamSx3("C5_NUM")[1])		,"@!"	,""													,""		,""	,050,.F.})			// 16
	aAdd(_aParambox,{1,"Data Reembarque Inicial",Ctod("")						,""		,""													,""		,,050,.F.})
	aAdd(_aParambox,{1,"Data Reembarque Final"	,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR17, MV_PAR18, 'Data Reembarque')",""		,,050,.F.})
	aAdd(_aParambox,{3,"Status do Pedido"		,Iif(Set(_SET_DELETED),1,2)		, {"TODOS","FATURADO","NAO FATURADO" }								, 100,"",.F.})			// 17

	If !U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; EndIf
 
	If _aRet[19] <> 1	// 1=Todos
	   _cStatPedi	:= If(_aRet[19] == 2, "FATURADO" , "NAO FATURADO" )
	EndIf

	// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)

	If Empty(_aSelFil)
	   Return
	EndIf

	_cCODFILIA	:= U_Array_In(_aSelFil)

	If _aRet[1] > _aRet[2]
		MsgStop("A Data de Entrega Inicial, nao pode ser maior que a data de Entrega Final.")
		Return.F.
	EndIf

	If _aRet[3] > _aRet[4]
		MsgStop("A Data de Emissao Inicial, nao pode ser maior que a data de Emissao Final.")
		Return.F.
	EndIf
	
	If _aRet[5] > _aRet[6]
		MsgStop("A Data de Faturamento Inicial, nao pode ser maior que a data de Faturamento Final.")
		Return.F.
	EndIf
	
	//===		S E L E C I O N A	D I R E T O R I A
	cQryDireto	:= "SELECT ' Nao Informado' as ZBD_CODIGO, '" +SPACE(TamSx3("ZBD_DESCRI")[1])+ "' as ZBD_DESCRI FROM DUAL UNION ALL "	// Coloco um espaco no come�o de " Nao Informado" para este registro aparecer na 1� linha do Browse 
	cQryDireto	+= "SELECT DISTINCT ZBD_CODIGO, ZBD_DESCRI "

	// 31/10/2019 - Avalia o tipo de servidor
	cEnviroSrv	:= AllTrim(UPPER(GETENVSERVER()))
	
	If cEnviroSrv $ 'PRODUCAO|PRE_RELEASE'                  
    	cQryDireto += "  FROM " +   U_If_BIMFR( "PROTHEUS", RetSqlName("ZBD") ) + " TMPZBD " 
	Else
    	cQryDireto += "  FROM " + RetSqlName("ZBD") + " TMPZBD " 
	EndIf

	cQryDireto	+= "  WHERE TMPZBD.D_E_L_E_T_ = ' ' " 
	cQryDireto	+= "  ORDER BY ZBD_CODIGO, ZBD_DESCRI"
	aCpoDireto	:=	{	{ "ZBD_CODIGO"	,"Codigo"		,TamSx3("ZBD_CODIGO")[1] + 50	}	,;
						{ "ZBD_DESCRI"	,"Diretoria"	,TamSx3("ZBD_DESCRI")[1] 		}	 } 
	cTitDireto	:= "Diretorias a serem listadas: "

	nPosRetorn	:= 2		// Quero que seja retornado o primeiro campo: A6_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o Botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o Botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 

	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
	_cDiretori	:= U_Array_In( U_MarkGene(cQryDireto, aCpoDireto, cTitDireto, nPosRetorn, @_lCancProg ) )

	If _lCancProg
		Return
	EndIf
	
	//===		S E L E C I O N A 	   T A T I C O 
	cQryTatico	:= "SELECT '" +SPACE(TamSx3("ZBF_DESCRI")[1]) + "' as ZBF_DESCRI FROM DUAL UNION ALL "
	cQryTatico	+= "SELECT DISTINCT ZBF_DESCRI "
	cQryTatico  += "  FROM " +  U_If_BIMFR( "PROTHEUS", RetSqlName("ZBF") ) + " TMPZBF " 
	cQryTatico	+= "  WHERE TMPZBF.D_E_L_E_T_ = ' ' " 
	cQryTatico	+= "  ORDER BY ZBF_DESCRI  "
	aCpoTatico	:=	{	{ "ZBF_DESCRI"	,U_X3Titulo("ZBF_DESCRI")	,TamSx3("ZBF_DESCRI")[1]	}	}
	
	cTitTatico	:= "Selecao T�tico: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: ZBF_DESCRI
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o Botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o Botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 

	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
	_cTatico	:= U_Array_In( U_MarkGene(cQryTatico, aCpoTatico, cTitTatico, nPosRetorn, @_lCancProg ) )

	If _lCancProg
		Return
	EndIf

	// 31/10/2019 - Avalia o tipo de servidor
	If cEnviroSrv $ 'PRODUCAO|PRE_RELEASE'                  
    	_cQuery += "  FROM " + U_If_BIMFR( "If_BIMFR", "V_FAT_CARREGAMENTOPEDIDOS"  )
	Else
	  	_cQuery += "  FROM V_FAT_CARREGAMENTOPEDIDOS"
	EndIf

	_cQuery += U_WhereAnd( !Empty(_cCODFILIA ),   " EMPRESA IN " + _cCODFILIA	                                                )	// OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !Empty(_aRet[2] ),     " DATA_ENTREGA_FILTRO BETWEEN '"  + _aRet[1]  + "' AND '" + _aRet[2] + "'  "	)	// OBRIGATORIO, COM A VALIDACAO DE 35 DIAS
	_cQuery += U_WhereAnd( !Empty(_aRet[4] ),     " DATA_EMISSAO_FILTRO BETWEEN '"  + _aRet[3]  + "' AND '" + _aRet[4] + "'  "	)	// OBRIGATORIO, COM A VALIDACAO DE 35 DIAS
	_cQuery += U_WhereAnd( !Empty(_aRet[6] ),     " DATA_FATURAMENTO_FILTRO BETWEEN '"  + _aRet[5]  + "' AND '" + _aRet[6] + "'  "	)	// OBRIGATORIO, COM A VALIDACAO DE 35 DIAS
	_cQuery += U_WhereAnd( !Empty(_aRet[8] ),     " COD_PRODUTO BETWEEN '"          + _aRet[7]  + "' AND '" + _aRet[8] + "'  "	)	// NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !Empty(_aRet[10] ),    " CODIGO_VENDEDOR BETWEEN '"      + _aRet[9]  + "' AND '" + _aRet[10] + "'  "	)	// NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !Empty(_aRet[11] ),    " ESPECIE_PEDIDO LIKE '%"         + _aRet[11]  + "%' "	                        )	// NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !Empty(_aRet[12] ),    " COD_CLIENTE_FILTRO BETWEEN '"   + _aRet[12] + "' AND '" + _aRet[13] + "' "	)	// NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !Empty(_aRet[14] ),    " DATA_EMBARQUE_FILTRO BETWEEN '" + _aRet[14] + "' AND '" + _aRet[15] + "' "	)	// NAO OBRIGATORIO - SEM TRAVA
	_cQuery += U_WhereAnd( !Empty(_aRet[17] ),    " DATA_REEMBARQUE_FILTRO BETWEEN '" + _aRet[17] + "' AND '" + _aRet[18] + "' "	)	// NAO OBRIGATORIO - SEM TRAVA

	If Empty(_cDiretori )
		_cQuery +=  ""		// Nao incrementa a clausula Where
	ElseIf AT("' '", _cDiretori ) <> 0
		_cQuery += U_WhereAnd( .T. ,              " ( DIRETORIA IS NULL OR DIRETORIA IN " + _cDiretori + " )"              )
	Else	
		_cQuery += U_WhereAnd( .T. ,              " DIRETORIA IN " + _cDiretori	                                        )	
	EndIf

	_cQuery += U_WhereAnd( !Empty(_aRet[16] ),    " PEDIDO LIKE '%"         + _aRet[16]  + "%' "	            )	// NAO OBRIGATORIO

	If _aRet[19] <> 1	// 1=Todos
	   _cQuery += U_WhereAnd( !Empty(_cStatPedi ),    " STATUS_PEDIDO = '"          		+ _cStatPedi + "' "	)	// NAO OBRIGATORIO
	EndIf

	_cQuery += U_WhereAnd( !Empty(_cTatico ),              " TATICO IN " + _cTatico		+ " "	)	+CRLF 
		
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)

    MsgRun("Aguarde!!! Montando\Desconectando Tela",,{ ||U_MG05R03T()})

RETURN

/*
{Protheus.doc} MG05R03T
Grid de retorno do BI adaptado com funcao de excluir pedidos					

@author Josue Danich Prestes
@since 25/10/2019  
*/
User Function MG05R03T()

	Local aLinha  := {}
	Local _nI	  := ""
	Local _cBanco := AllTrim(Upper(TCGetDb()))

	Local _nAlinhamento
	Local oDlgMain

	Public _nArqName := 0
	Public _aArqName := {}
	
	Private oBrowse
    Private aRotina	:= MGF05R03M()

	Private cCadastro  := _aDefinePl[1]
	Private aSeek 	   := {}
	Private aFieFilter := {}

	If VALTYPE(_aEmailQry) == "A"
		If !Empty(_aEmailQry)
			_aEmailQry[3]	:= _aEmailQry[3] + _cQuery		// Incremento agora no corpo do e-mail que j� tinha o texto; a query do relatorio. 
			U_BIEnvEml(_aEmailQry[1]/*cTo*/, _aEmailQry[2]/*_cSubject*/, _aEmailQry[3]/*_cCorpo*/ )
		EndIf
	EndIf

	If Select(_cTmp01) > 0
		dbSelectArea(_cTmp01)
		dbCloseArea()
	EndIf

	aStruTRB	:= {}
	For _nI := 1 to Len(_aCampoQry)
		aAdd(aStruTRB,{ _aCampoQry[_nI,_nPoApeli] ,;	// Nome do Campo
						_aCampoQry[_nI,_nPoTipo],;		// Tipo
						_aCampoQry[_nI,_nPoTaman],;		// tamanho
						_aCampoQry[_nI,_nPoDecim]})		// N� de decimais
	Next
	aAdd(aStruTRB,{ 	"X" ,;	// Nome do Campo
						"C" ,;	// Tipo
						1   ,;	// tamanho
						0   })	// N� de decimais

	// A linha abaixo nao tem efeito p/ o fonte. � apenas p/ na compilacao nao aparecer a MSG "warning W0003 Local variable __LOCALDRIVER never used"
	__LocalDriver	:= __LocalDriver + ""	

	cNomeArq := CriaTrab( aStruTRB,.T. )
	
	dbUseArea(.T.,__LocalDriver,cNomeArq ,_cTmp01 ,.T. ,.F.)
	MsAguarde({|| SqlToTrb(_cQuery,aStruTRB,_cTmp01)},"Criando a tabela com os dados da Query",;
	                                                  "Criando a tabela com os dados da Query",.T.)

	cIndice1 := AllTrim(CriaTrab(,.F.))

	If File(cIndice1+OrdBagExt())
		FErase(cIndice1+OrdBagExt())
	EndIf

	dbSelectArea(_cTmp01)
	dbGoTop()

	If !Eof()

		// Faz o calculo automatico de dimensoes de objetos		
		aSize 		:= MsAdvSize()
		aObjects 	:= {}

		AADD( aObjects, { 100, 100,.T.,.T. } )
		
		aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 1, 1 }
		aPosObj := MsObjSize( aInfo, aObjects )
		
		DEFINE MSDIALOG oDlgMain TITLE _aDefinePl[1] FROM aSize[7], aSize[8] TO aSize[6],aSize[5]-10 OF oMainWnd PIXEL 
		
		oDlgMain:lEscClose :=.T.		// Permite sair do Dialog ao se pressionar a tecla ESC
			
		oBrowse := FWMBrowse():New()
		oBrowse:setDataTable()     		//--<< Indica que usa uma Tabela                      >>--
		oBrowse:SetAlias( _cTmp01 )
		oBrowse:SetDescription( cCadastro )
		oBrowse:setSeek(,aSeek)
		oBrowse:setOwner(oDlgMain)
	
		//Detalhes das colunas que serao exibidas
		For _nI	:= 1 to Len(_aCampoQry)

			If 		_aCampoQry[_ni, _nPoTipo] == "D"	
					_nAlinhamento := 0				// Campo data alinhado ao centro       (0)
			ElseIf 	_aCampoQry[_ni, _nPoTipo] == "N"	
					_nAlinhamento := 2				// Campo Numerico Alinhado a Direita   (2)
			Else
					_nAlinhamento := 1				// Campo Caracter ou outros, alinhado a esquerda  (1)
			EndIf

			oBrowse:SetColumns(MG05R03C  (_aCampoQry[_ni, _nPoApeli] ,_aCampoQry[_ni, _nPoTitul] ,_nI ,_aCampoQry[_ni, _nPoPictu] ,_nAlinhamento ,_aCampoQry[_ni ,_nPoTaman] ,_aCampoQry[_ni, _nPoDecim] ))

    	Next

		oBrowse:Refresh( .T. ) 		
		oBrowse:Activate()
		oDlgMain:Activate(	,,,.F.	,,.T.	,, )
			
    Else
		MsgStop(" Nao existem dados para os parametros informados" )
    EndIf

	If !Empty(cNomeArq)

		Ferase(cNomeArq+GetDBExtension())
		Ferase(cNomeArq+OrdBagExt())

		cNomeArq := ""

		(_cTmp01)->(dbCloseArea())

		delTabTmp(_cTmp01)
		dbClearAll()

	EndIf		

RETURN


/*
{Protheus.doc} MGF05R03M
Cria menu da tela de grid					

@author Josue Danich Prestes
@since 25/10/2019  
*/
Static Function MGF05R03M()

	Local aArea		:= GetArea()
	Local aRotina 	:= {}

	AADD(aRotina, {"Gera Planilha","U_GeraPlan",0,3,0,.F.})
	
	If __cUserID $ SuperGetMv("MG05R03U",,"000590;003906;004370")
		AADD(aRotina, {"Exclui PVS","U_MG05R03B",0,3,0,Nil})
	EndIf
	
	RestArea(aArea)

Return( aRotina )

/*
{Protheus.doc} MG05R03B
Monta colunas do grid					

@author Josue Danich Prestes
@since 25/10/2019  
*/
User Function MG05R03B()

fwmsgrun(,{|oproc| U_MG05R03E(oproc)} ,"Aguarde...","Carregando pedidos...")

/*
{Protheus.doc} MG05R03C
Monta colunas do grid					

@author Josue Danich Prestes
@since 25/10/2019  
*/
Static Function MG05R03C(cCampo,cTitulo,nArrData,cPicture,nAlign,nSize,nDecimal)
	
	Local aColumn
	Local bData 	 := {||}
	Local cTipoDado	 := "C"
	Default nAlign 	 := 1
	Default nSize 	 := 20
	Default nDecimal := 0
	Default nArrData := 0
	
	If nArrData > 0
		If 		nAlign == 0		// Campo tipo Data, que alinho ao centro.
				bData 	  := &("{|| " + cCampo +" }") 
				cTipoDado := "D"
		ElseIf 	nAlign == 2		
				bData 	  := &("{|| " + cCampo +" }") 
				cTipoDado := "N"
		Else
				bData 	  := &("{|| " + cCampo +" }") 
				cTipoDado := "C"
		EndIf
	EndIf
		
	aColumn := {cTitulo,bData,,cPicture,nAlign,nSize,nDecimal,.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},.F.,.F.,{}}
	
Return {aColumn}

/*
{Protheus.doc} MG05R03E
Abre tela com pedidos a serem excluidos					

@author Josue Danich Prestes
@since 25/10/2019  
*/
User Function MG05R03E(oproc)

	Local cQuery    := ""
	Local cFilPed   := ""
	Local cPedExc   := ""
	Local _ntot     := 0
	Local _npos     := 0

	Default oproc := nil

	Private aCab      := {}
	Private _aItensPV := {}

	(_cTmp01)->(dbGoTop())

	// Conta pedidos
	While !(_cTmp01)->(EoF())
	   _ntot++
	   (_cTmp01)->(dbSkip())
	EndDo

	//Carrega tela de visualizasao de pedidos para confirmar processamento
	_ACOLS := {}
	aheader := {"Filial",;
				"Numero",;
				"Data Entrega",;
				"Pedido Roteirizado",;
				"Nome Vendedor",;
				"Especie de Pedido",;
				"Soma de Qtde Solicitada"	}

	// pergunta sobre filiais e tipos a considerar na exclusao
	_oldpar01 := MV_PAR01
	_oldpar02 := MV_PAR02
	_oldpar03 := MV_PAR03

	If !pergunte("MGF05R03P")
		Return
	EndIf

	_CEMPS  := MV_PAR01
	_CTIPOS := MV_PAR02
	_NROTEI	:= MV_PAR03

	MV_PAR01 := _oldpar01
	MV_PAR02 := _oldpar02
	MV_PAR03 := _oldpar03

	(_cTmp01)->(dbGoTop())

	While !(_cTmp01)->(EoF())

		_npos++

		If  	!( ISINCALLSTACK("MDIEXECUTE") .OR. ISINCALLSTACK("SIGAADV") )
				U_MFCONOUT("Carregando pedido " + strzero(_npos,6) + " de " + strzero(_ntot,6) + "...") 
		ElseIf 	oproc != nil
				oproc:ccaption := "Carregando pedido " + strzero(_npos,6) + " de " + strzero(_ntot,6) + "..."
				ProcessMessages()
		EndIf
		
		SC5->(dbSetOrder(1))

		If ((_cTmp01)->EMPRESA $ _CEMPS .OR. EMPTY(_CEMPS)) .AND. ;
		    SC5->(dbSeek((_cTmp01)->EMPRESA+(_cTmp01)->PEDIDO)) 

			If (_cTmp01)->ESPECIEPED $ _CTIPOS

				If (SC5->C5_ZROAD == "S" .AND. _NROTEI == 1) .OR. ;
				   (SC5->C5_ZROAD != "S" .AND. _NROTEI == 2) .OR. ;
				   _NROTEI == 3

				   // S� preenche o array se nao foi faturado de fato
				   If Empty(SC5->C5_NOTA) .AND. Empty(SC5->C5_SERIE) 				

						_nj := Ascan(_acols,{|item| item[1] == SC5->C5_FILIAL .AND. item[2] == SC5->C5_NUM})

						If _nj == 0

							AADD(_ACOLS,{	SC5->C5_FILIAL,;
											SC5->C5_NUM,;
											IIF(EMPTY(SC5->C5_ZDTREEM),SC5->C5_ZDTEMBA,SC5->C5_ZDTREEM),;
											IIF(SC5->C5_ZROAD=="S","SIM","NAO"),;
											POSICIONE("SA3",1,XFILIAL("SA3")+SC5->C5_VEND1,"A3_NOME"),;
											SC5->C5_ZTIPPED,;
											(_cTmp01)->QTDESOLICI  } )
						Else
							_acols[_nj][7] += (_cTmp01)->QTDESOLICI
						EndIf
						
					EndIf

				EndIf

			EndIf	

		EndIf

		(_cTmp01)->(dbSkip())

	EndDo

	If Len(_ACOLS) == 0

		If  !( ISINCALLSTACK("MDIEXECUTE") .OR. ISINCALLSTACK("SIGAADV") )
			U_MFCONOUT("Nao foram localizados pedidos!")
		Else
			msgbox("Nao foram localizados pedidos!")
		EndIf

		Return
	
	EndIf

	_acols := ASORT(_acols, , , { | x,y | x[1]+x[2] > y[1]+y[2] } )

	If  !( ISINCALLSTACK("MDIEXECUTE") .OR. ISINCALLSTACK("SIGAADV") ) .OR. U_MGListBox( "Pedidos a serem excluidos" , aheader , _ACOLS , .T. , 1 )

		If  	!( ISINCALLSTACK("MDIEXECUTE") .OR. ISINCALLSTACK("SIGAADV") )
				U_MFCONOUT("Excluindo pedidos...")
		ElseIf 	oproc != nil
				oproc:ccaption := "Excluindo pedidos..."
				ProcessMessages()
		EndIf


		(_cTmp01)->(dbGoTop())
		
		_npos  := 1
		_apeds := {}

		For _nkl := 1 to Len(_acols)
			AADD(_apeds,_acols[_nkl])
		Next

		_ACOLS := {}
		aheader := {"Filial","Pedido","Dt Embarque","Dt Reembarque","Cliente","Nome cliente","Status"}

		_ntot := Len(_apeds)

		For _nkl := 1 to Len(_apeds)

			aCab 	  := {}
			_aItemPV  := {}
			_aItensPV := {}

			If  	!( ISINCALLSTACK("MDIEXECUTE") .OR. ISINCALLSTACK("SIGAADV") )
					U_MFCONOUT("Excluindo pedido "+strzero(_nkl,6)+" de "+ strzero(_ntot,6) + "...")
			ElseIf 	oproc != nil
					oproc:ccaption := "Excluindo pedido "+strzero(_nkl,6)+" de "+ strzero(_ntot,6) + "..."
					ProcessMessages()
			EndIf

			//Antes de deletar o pedido com qtde de entrega zerado verifica caso tenha mais itens faturados no mesmo pedido, nao efetua a exclusao.
			cFilPed := _apeds[_nkl][1]
			cPedExc := _apeds[_nkl][2]

			SC5->(dbSetOrder(1))
			
			If SC5->(dbSeek(cFilPed+cPedExc))

				_ddtent  := SC5->C5_ZDTEMBA
				_ddtrem  := SC5->C5_ZDTREEM
				_cclient := SC5->C5_CLIENTE
				_cloja   := SC5->C5_LOJACLI

				//Carrega Array aCab
				AADD( aCab, { "C5_FILIAL"	,SC5->C5_FILIAL  , Nil})//filial
				AADD( aCab, { "C5_NUM"    	,SC5->C5_NUM	 , Nil}) 
				AADD( aCab, { "C5_TIPO"	    ,SC5->C5_TIPO    , Nil})//Tipo de pedido
				AADD( aCab, { "C5_CLIENTE"	,SC5->C5_CLIENTE , NiL})//Codigo do cliente
				AADD( aCab, { "C5_CLIENT" 	,SC5->C5_CLIENT	 , Nil}) 
				AADD( aCab, { "C5_LOJAENT"	,SC5->C5_LOJAENT , NiL})//Loja para entrada
				AADD( aCab, { "C5_LOJACLI"	,SC5->C5_LOJACLI , NiL})//Loja do cliente
				AADD( aCab, { "C5_EMISSAO"	,SC5->C5_EMISSAO , NiL})//Data de emissao
				AADD( aCab, { "C5_TRANSP" 	,SC5->C5_TRANSP	 , Nil}) 
				AADD( aCab, { "C5_CONDPAG"	,SC5->C5_CONDPAG , NiL})//Codigo da condicao de pagamanto*
				AADD( aCab, { "C5_VEND1"  	,SC5->C5_VEND1	 , Nil}) 
				AADD( aCab, { "C5_MOEDA"    ,SC5->C5_MOEDA   , Nil})//Moeda
				AADD( aCab, { "C5_MENPAD" 	,SC5->C5_MENPAD	 , Nil}) 
				AADD( aCab, { "C5_LIBEROK"	,SC5->C5_LIBEROK , NiL})//Liberacao Total
				AADD( aCab, { "C5_TIPLIB"  	,SC5->C5_TIPLIB  , Nil})//Tipo de Liberacao
				AADD( aCab, { "C5_TIPOCLI"	,SC5->C5_TIPOCLI , NiL})//Tipo do Cliente

				//Carrega Array aItens
				SC6->(dbSeek(SC5->(C5_FILIAL + C5_NUM)))

				_aItensPV := {}
	
				While SC6->( !EOF() ) .And. SC6->(C6_FILIAL+C6_NUM) == SC5->(C5_FILIAL+C5_NUM)
		
					_aItemPV := {}
		
					AADD( _aItemPV , { "C6_FILIAL"  ,SC6->C6_FILIAL  , Nil }) // FILIAL
					AADD( _aItemPV , { "C6_NUM"    	,SC6->C6_NUM	 , Nil })
					AADD( _aItemPV , { "C6_ITEM"    ,SC6->C6_ITEM    , Nil }) // Numero do Item no Pedido
					AADD( _aItemPV , { "C6_PRODUTO" ,SC6->C6_PRODUTO , Nil }) // Codigo do Produto
					AADD( _aItemPV , { "C6_UNSVEN"  ,SC6->C6_UNSVEN  , Nil }) // Quantidade Vendida 2 un
					AADD( _aItemPV , { "C6_QTDVEN"  ,SC6->C6_QTDVEN  , Nil }) // Quantidade Vendida
					AADD( _aItemPV , { "C6_PRCVEN"  ,SC6->C6_PRCVEN  , Nil }) // Preco Unitario Liquido
					AADD( _aItemPV , { "C6_PRUNIT"  ,SC6->C6_PRUNIT  , Nil }) // Preco Unitario Liquido
					AADD( _aItemPV , { "C6_ENTREG"  ,SC6->C6_ENTREG  , Nil }) // Data da Entrega
					AADD( _aItemPV , { "C6_LOJA"   	,SC6->C6_LOJA	 , Nil })
					AADD( _aItemPV , { "C6_SUGENTR" ,SC6->C6_SUGENTR , Nil }) // Data da Entrega
					AADD( _aItemPV , { "C6_VALOR"   ,SC6->C6_VALOR   , Nil }) // valor total do item
					AADD( _aItemPV , { "C6_UM"      ,SC6->C6_UM      , Nil }) // Unidade de Medida Primar.
					AADD( _aItemPV , { "C6_TES"    	,SC6->C6_TES	 , Nil })
					AADD( _aItemPV , { "C6_LOCAL"   ,SC6->C6_LOCAL   , Nil }) // Almoxarifado
					AADD( _aItemPV , { "C6_CF"     	,SC6->C6_CF		 , Nil })
					AADD( _aItemPV , { "C6_DESCRI"  ,SC6->C6_DESCRI  , Nil }) // Descricao
					AADD( _aItemPV , { "C6_QTDLIB"  ,SC6->C6_QTDLIB  , Nil }) // Quantidade Liberada
					AADD( _aItemPV , { "C6_PEDCLI" 	,SC6->C6_PEDCLI	 , Nil })
	
					AADD( _aItensPV ,_aItemPV )
     
        			SC6->( dbSkip() )
		
				EndDo
        
				//Exclui o pedido
				_cretorno := xApagaPed(SC5->C5_FILIAL,SC5->C5_NUM,"M")

				AADD(_ACOLS,{cFilPed,cPedExc,_ddtent,_ddtrem,_cclient+"/"+_cloja,;
				POSICIONE("SA1",1,xfilial("SA1")+_cclient+_cloja,"A1_NREDUZ"),;
				_cretorno})

			Else

				AADD(_ACOLS,{cFilPed,cPedExc,_ddtent,_ddtrem,_cclient+"/"+_cloja,;
				POSICIONE("SA1",1,xfilial("SA1")+_cclient+_cloja,"A1_NREDUZ"),;
				"Nao localizou pedido de venda"})

			EndIf

		Next

		If Len(_ACOLS) > 0

			If  !( ISINCALLSTACK("MDIEXECUTE") .OR. ISINCALLSTACK("SIGAADV") )
				U_MFCONOUT("Completou exclusao de pedidos de venda nao atendidos!")
			Else
				U_MGListBox( "Resultado de exclusao de pedidos" , aheader , _ACOLS , .T. , 1 )
			EndIf

		Else

			If  !( ISINCALLSTACK("MDIEXECUTE") .OR. ISINCALLSTACK("SIGAADV") )
				U_MFCONOUT("Nenhum pedido excluido!")
			Else
				msgbox("Nenhum pedido excluido!","Atencao")	
			EndIf

		EndIf

	Else

		If  !( ISINCALLSTACK("MDIEXECUTE") .OR. ISINCALLSTACK("SIGAADV") )
			U_MFCONOUT("Processo cancelado pelo usuario!")
		Else
			msgbox("Processo cancelado pelo usuario!","Atencao")
		EndIf

	EndIf

Return Nil


/*/{Protheus.doc} xApagaPed (nome da Funcao)
@Descricao Funcao que executa a exclusao dos pedidos de vendas, via MsExecAuto

@author Fabio Costa
@since 15/08/2019

@version P12.1.017
@country Brasil
@language Portugues
@chamado/problema PRB0040215-Elimina��o-de-residuos-PV
/*/

Static Function xApagaPed(cFilPed,cPed,cSit)

	Local cQuery 	  := ""
	Local cDescMo     := ""
	Local lMsErroAuto := .F.
	Local _cretorno   := "Erro nao previsto"

	If 		cSit == "M"
	   		cDescMo := "EXCLUIDO VIA RELATORIO DE Carregamento e Pedidos"
	ElseIf 	cSit == "A"
			cDescMo := "EXCLUIDO VIA JOB - ROTINA AUTOMATICA DE PEDIDOS" 
	EndIf  

	If  !( ISINCALLSTACK("MDIEXECUTE") .OR. ISINCALLSTACK("SIGAADV") ) 
		_cusuario := "JOB"
	Else
		_cusuario := cusername
	EndIf

	cQuery := "SELECT C5_FILIAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, "+CRLF
	cQuery += "       A1_NOME, C5_EMISSAO, C5_ZDTEMBA, C5_PESOL, "+CRLF
	cQuery += "       C5_PBRUTO, C5_FECENT, C5_ZTIPPED "+CRLF
	cQuery += "FROM "+RetSqlName("SC5") + " SC5 "+CRLF
	cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND SC5.D_E_L_E_T_ <> '*' "+CRLF 
	cQuery += "WHERE SC5.D_E_L_E_T_ <> '*' "+CRLF
	cQuery += "AND C5_FILIAL =  '"+cFilPed+"' "+CRLF
	cQuery += "AND C5_NUM = '"+cPed+"' "+CRLF

	If Select("TRB02") > 0
	   TRB02->(dbCloseArea())
	EndIf   
			
	cQuery := ChangeQuery(cQuery)
			
	TCQuery cQuery New Alias "TRB02"
	
	TCSetField("TRB02","C5_EMISSAO","D")
	TCSetField("TRB02","C5_FECENT","D")
	TCSetField("TRB02","C5_ZDTEMBA","D")

	dbSelectArea("TRB02")
	TRB02->(dbGoTop())

	While !TRB02->(EoF())

		Begin Transaction

			lMsErroAuto := .F.
	
			SC5->(dbSetOrder(1))
	
			If SC5->(dbSeek(cFilPed+cPed))

				cfilori := cfilant
				cfilant := SC5->C5_FILIAL
	
				Reclock("SC5",.F.)
				MSExecAuto({|x,y,z| Mata410(x,y,z)}, aCab,_aItensPV,5)
				SC5->(Msunlock())
	
				cfilant := cfilori

			Else
				_cretorno := "Erro na exclusao do pedido - Pedido nao localizado"
			EndIf

			If lMsErroAuto
				DisarmTransaction()

				aErro := GetAutoGRLog() // Retorna erro em array
				cErro := " "

				For nX := 1 to Len(aErro)
					cErro += aErro[nX] + " "
				Next nX

				_cretorno := "Erro na exclusao do pedido - " + cErro

			Else 

				SC5->(dbSetOrder(1))
				
				If 		SC5->(dbSeek(cFilPed+cPed))
						DisarmTransaction()
						_cretorno := "Erro na exclusao do pedido"
				ElseIf 	_cretorno == "Erro nao previsto"
						_cretorno := "Pedido excluido com sucesso!"
				EndIf

			EndIf

		End Transaction

		dbSelectArea("ZEI")
		dbSetOrder(1)

		If 	!dbSeek(TRB02->C5_FILIAL+TRB02->C5_NUM)
		  	ZEI->(RecLock("ZEI",.T.))
			ZEI->ZEI_FILIAL  := TRB02->C5_FILIAL 
			ZEI->ZEI_PEDIDO  := TRB02->C5_NUM
			ZEI->ZEI_CLIENT  := TRB02->C5_CLIENTE
			ZEI->ZEI_LOJA    := TRB02->C5_LOJACLI
			ZEI->ZEI_RAZAO   := TRB02->A1_NOME
			ZEI->ZEI_EMISSA  := TRB02->C5_EMISSAO
			ZEI->ZEI_EMBARQ  := TRB02->C5_ZDTEMBA
			ZEI->ZEI_ENTREG  := TRB02->C5_FECENT 
			ZEI->ZEI_ESPECI  := TRB02->C5_ZTIPPED
			ZEI->ZEI_PESO    := TRB02->C5_PESOL
			ZEI->ZEI_PESOB   := TRB02->C5_PBRUTO
			ZEI->ZEI_DTEXCL  := Date()
			ZEI->ZEI_CODMOT  := "999999"
			ZEI->ZEI_DESCMO  := cDescMo
			ZEI->ZEI_USER    := _cusuario
			ZEI->ZEI_DATA    := DATE()
			ZEI->ZEI_HORA    := TIME()
			ZEI->ZEI_STATUS  := _cretorno
		Else
		    ZEI->(RecLock("ZEI",.F.))
			ZEI->ZEI_DTEXCL  := Date()
			ZEI->ZEI_CODMOT  := "999999"
			ZEI->ZEI_DESCMO  := cDescMo
			ZEI->ZEI_USER    := _cusuario
			ZEI->ZEI_DATA    := DATE()
			ZEI->ZEI_HORA    := TIME()
			ZEI->ZEI_STATUS  := _cretorno
		EndIf
		ZEI->(MsUnlock())
					
		TRB02->(DbSkip())

	EndDo

	dbSelectArea("TRB02")
	TRB02->(Dbclosearea())

Return _cretorno

/*
{Protheus.doc} MG05R03J
Inicia o Processo para o JOB de exclusao de pedidos					

@author Paulo Henrique Rodrigues da Mata
@since 23/03/2020
*/
User Function MG05R03J(lJob)

    Local aDadEv     := {}
	Local aTables    := {'SC5','SC6','ZG1'} 

	U_MFCONOUT("Inicio do processo do JOB para exclusao dos PV's")

	RpcSetType(3)
	RpcSetEnv( "01" , "010001" , Nil, Nil, "FAT", Nil, aTables )

	U_MFCONOUT("Criando o ARRAY na ZG1 para inicio da exclusao dos PV's")
		
	// Executa a leitura da tabela ZG1 - Especie de Pedidos
	ZG1->(dbSetOrder(1))
	While ZG1->(!Eof())
	   AADD(aDadEv,{ZG1->ZG1_UNID   ,;
	   				ZG1->ZG1_ESPEC  ,; 
					ZG1->ZG1_ROTEIR ,;
					ZG1->ZG1_DDM    ,;
					ZG1->ZG1_DTINI  ,;
					ZG1->ZG1_TATIC  ,;
					ZG1->ZG1_STATUS ,;
					ZG1->ZG1_DIRET  ,;
					ZG1->ZG1_PVBLQ  ,;
					ZG1->ZG1_BLQUN})
		ZG1->(dbSkip())
	EndDo
	
	// Processa o JOB
	U_MFCONOUT("Inicia o JOB de exclusao dos PV's")
	
	BEGIN TRANSACTION

	    fJobApPV(aDadEv)

	END TRANSACTION	

    RpcClearEnv()

	U_MFCONOUT("Termina o JOB de exclusao dos PV's")

Return

/*
{Protheus.doc} FJOBPPV
Gera ARRAY para exclusao de pedidos nao faturados					

@author Paulo Henrique Rodrigues da Mata
@since 23/03/2020
*/
Static Function fJobApPV(aDadEv)

	Local cQryEpv  := ""
	Local cQryFil  := ""
	Local cQryDir  := ""

	Local cTatic   := ""
	Local cStatP   := ""
	Local cPvBlq   := ""
	Local cBlqFl   := ""

	Local cFilPed := ""
	Local cPedExc := ""
	Local cEspcPd := ""
	Local cDiret  := ""
	Local cEnter  := Chr(13)+Chr(10)

	Local _cclient := ""
	Local _cloja   := ""
	
	Local _dDtEmi := CtoD(Space(08))
	Local _ddtent := CtoD(Space(08))
	Local _ddtrem := CtoD(Space(08))
	Local _DDDC   := CtoD(Space(08))

	Local nTot    := 0
	Local _nDDM   := 0
	Local nPos    := 1
	Local nQtdSol := 0
	Local aPeds   := {}
	Local _aCols  := {}
	Local _lOk    := .F.

	Local _cCODFILIA := ""
	Local _cCODDIRET := ""
	Local _cCODTATIC := ""
	Local _aSelFil   := {}
	Local _aSelDir   := {}
	Local _aSelTat   := {}

	Private aCab      := {}
	Private _aItensPV := {}
	
	For nPos := 1 to Len(aDadEv)

		U_MFCONOUT("Faz a leitura do ARRAY da ZG1 para a exclusao dos PV's")

		// Faz a leitura de ZG1 para execucao desta rotina
		_CEMPS  := AllTrim(aDadEv[nPos,1])
		_CTIPOS := AllTrim(aDadEv[nPos,2])
		_CROTEI	:= aDadEv[nPos,3]
		_nDDM   := aDadEv[nPos,4]
		_dDtEmi := aDadEv[nPos,5]
		cTatic  := AllTrim(aDadEv[nPos,6])
		cStatP  := aDadEv[nPos,7]
		cDiret  := AllTrim(aDadEv[nPos,8])
		cPvBlq  := AllTrim(aDadEv[nPos,9])
		cBlqFl  := AllTrim(aDadEv[nPos,10])

		// Se o usuario do ZG1 tem o acesso a todas as unidades, executa a condicao abaixo
		If !Empty(_CEMPS)

			If Select("QRYFIL") > 0
				QRYFIL->(dbCloseArea())
			EndIf

		   	cQryFil := "SELECT M0_CODIGO,M0_CODFIL "+cEnter
		   	cQryFil += "FROM SYS_COMPANY "+cEnter
		   	cQryFil += "WHERE D_E_L_E_T_ = ' ' "+cEnter
			cQryFil += "AND SUBSTR(M0_CODIGO,1,1) <> '9' "+cEnter

			cQryFil  := ChangeQuery(cQryFil)

			dbUseArea( .T. , "TOPCONN", TCGENQRY(,,cQryFil),"QRYFIL", .F. , .T. )

			dbSelectArea("QRYFIL")
			QRYFIL->(dbGoTop())

			While QRYFIL->(!Eof())

               If _cEMPS == '*' // Se forem todas as filiais cadastradas
			      If !AllTrim(QRYFIL->M0_CODFIL) $ cBlqFl
			         AADD(_aSelFil,AllTrim(QRYFIL->M0_CODFIL))
				  EndIf	 
			   Else // Se for um parte das filiais
			       If !AllTrim(QRYFIL->M0_CODFIL) $ cBlqFl
				      If AllTrim(QRYFIL->M0_CODFIL) $ _cEMPS
				 	     AADD(_aSelFil,AllTrim(QRYFIL->M0_CODFIL))
				      EndIf
				   EndIf	  
			   EndIf

			   QRYFIL->(dbSkip())
	
			EndDo   
		   
		    _cCODFILIA := U_Array_In(_aSelFil)

		EndIf

		// Verifica a diretoria envolvida no ZG1
		If !Empty(cDiret)

			If Select("QRYDIR") > 0
				QRYDIR->(dbCloseArea())
			EndIf
		       
		   	cQryDir := "SELECT ZBD_CODIGO, ZBD_DESCRI "+cEnter
   	        cQryDir += "FROM "+RetSqlName("ZBD")+" "+cEnter
			cQryDir	+= "WHERE D_E_L_E_T_ = ' ' "+cEnter

			cQryDir := ChangeQuery(cQryDir)

			dbUseArea( .T. , "TOPCONN", TCGENQRY(,,cQryDir),"QRYDIR", .F. , .T. )

			dbSelectArea("QRYDIR")
			QRYDIR->(dbGoTop())
			
			While QRYDIR->(!Eof())
			
			   If AllTrim(QRYDIR->ZBD_CODIGO) $ cDiret 
			      AADD(_aSelDir,AllTrim(QRYDIR->ZBD_DESCRI)) 
			   EndIf
			
			   QRYDIR->(dbSkip())
			
			EndDo   
		   
		    _cCODDIRET := U_Array_In(_aSelDir)
		
		EndIf

		// Data de entrega a considerar os dias descontados
		_dDDC := Date() - _nDDM 

		// Como esta em JOB, inicia busca a query da variavel privada _cQuery
		If Select("QRYEPV") > 0
			QRYEPV->(dbCloseArea())
		EndIf

		// Cria a query do JOB para exclusao dos PV's
		U_MFCONOUT("Cria a query do JOB para exclusao dos PV's")
		
		cQryEpv := "SELECT EMPRESA "+cEnter
		cQryEpv += " ,  PEDIDO "+cEnter
		cQryEpv += " ,  DATA_EMISSAO			 	AS DT_EMISSAO "+cEnter
		cQryEpv += " ,  CLIENTE "+cEnter
		cQryEpv += " ,  LOJA_CLIENTE			 	AS LJ_CLIENTE "+cEnter
		cQryEpv += " ,  LOJA_ENTREGA			 	AS LJ_ENTREGA "+cEnter
		cQryEpv += " ,  CNPJ "+cEnter
		cQryEpv += " ,  INTEGRAD_TMS 				AS INTEGRAD_T "+cEnter
		cQryEpv += " ,  STATUS "+cEnter
		cQryEpv += " ,  ESPECIE_PEDIDO				AS ESPECIEPED "+cEnter
		cQryEpv += " ,  COD_CONDICAO			 	AS CDCONDICAO "+cEnter
		cQryEpv += " ,  TABELA_PRECO			 	AS TAB_PRECO "+cEnter
		cQryEpv += " ,  DATA_ENTREGA			 	AS DT_ENTREGA "+cEnter
		cQryEpv += " ,  DATA_EMBARQUE				AS DTEMBRAQUE "+cEnter
		cQryEpv += " ,  ORDEM_EMBARQUE 				AS ORDEM_EMBA "+cEnter
		cQryEpv += " ,  COD_ENDERECO			 	AS CDENDERECO "+cEnter
		cQryEpv += " ,  ENDERECO "+cEnter
		cQryEpv += " ,  NOME_CLIENTE				AS NOM_CLIENT "+cEnter
		cQryEpv += " ,  COD_REGIAO "+cEnter
		cQryEpv += " ,  REGIAO "+cEnter
		cQryEpv += " ,  CODIGO_VENDEDOR				AS COD_VENDED "+cEnter
		cQryEpv += " ,  NOME_VENDEDOR				AS NOM_VENDED "+cEnter
		cQryEpv += " ,  CIDADE "+cEnter
		cQryEpv += " ,  ESTADO "+cEnter
		cQryEpv += " ,  COD_ROTEIRIZACAO  			AS CD_ROTEIRI "+cEnter
		cQryEpv += " ,  COD_PRODUTO					AS CD_PRODUTO "+cEnter
		cQryEpv += " ,  DESCRICAO "+cEnter
		cQryEpv += " ,  QUANT_SOLICITADA  			AS QTDESOLICI "+cEnter
		cQryEpv += " ,  PRECO_VENDA  				AS PRECOVENDA "+cEnter
		cQryEpv += " ,  PRECO_TABELA 				AS PRECOTABEL "+cEnter
		cQryEpv += " ,  VALOR "+cEnter
		cQryEpv += " ,  DESCONTO "+cEnter
		cQryEpv += " ,  DATA_FATURAMENTO  			AS DT_FATURAM "+cEnter
		cQryEpv += " ,  N_NF "+cEnter
		cQryEpv += " ,  N_SERIE "+cEnter
		cQryEpv += " ,  QUANT_ATENDIDA 				AS QTDEATENDI "+cEnter
		cQryEpv += " ,  QUANT_PECA_CAIXA 			AS QUANT_PECA "+cEnter
		cQryEpv += " ,  DATA_MINIMA					AS DT_MINIMA "+cEnter
		cQryEpv += " ,  DATA_MAXIMA					AS DT_MAXIMA "+cEnter
		cQryEpv += " ,  COD_REG_ENTREGA				AS CD_ENTREGA "+cEnter
		cQryEpv += " ,  REG_ENTREGA					AS RG_ENTREGA "+cEnter
		cQryEpv += " ,  CID_ENTREGA					AS CID_ENTREG "+cEnter
		cQryEpv += " ,  UF_ENTREGA "+cEnter
		cQryEpv += " ,  PEDIDO_ROTEIRIZADO 			AS PEDIDOROTE "+cEnter
		cQryEpv += " ,  TIPO_FRETE "+cEnter
		cQryEpv += " ,  COD_ROTEIRIZACAO_ENTREGA	AS CODROTEENT "+cEnter
		cQryEpv += " ,  PLACA "+cEnter
		cQryEpv += " ,  STATUS_PEDIDO				AS STATUSPEDI "+cEnter
		cQryEpv += " ,  DIRETORIA "+cEnter
		cQryEpv += " ,  STATUS_BLOQUEIO 			AS STATUS_BLO "+cEnter
		cQryEpv += " ,  COD_USUARIO 				AS COD_USUARI "+cEnter
		cQryEpv += " ,  NOME_USUARIO 				AS NOME_USUAR "+cEnter
		cQryEpv += " ,  DATA_REEMBARQUE 			AS DATA_REEMB "+cEnter

		cEnvSrv	:= AllTrim(UPPER(GETENVSERVER()))
		
		// 31/10/2019 - Avalia o tipo de servidor
		If cEnvSrv $ 'PRODUCAO|PRE_RELEASE'                  
    		cQryEpv += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_FAT_CARREGAMENTOPEDIDOS"  )+cEnter
		Else
    		cQryEpv += "  FROM V_FAT_CARREGAMENTOPEDIDOS"+cEnter
		EndIf

		cQryEpv += " WHERE EMPRESA IN "+If(Empty(_cCODFILIA),Formatin(_CEMPS,";"),_cCODFILIA)+" "+cEnter
		cQryEpv += " AND DATA_ENTREGA_FILTRO BETWEEN '"+DtoS(_dDtEmi)+"' AND '"+DtoS(_dDDC)+"' "+cEnter  
  		cQryEpv += " AND DIRETORIA IN "+_cCODDIRET+" "+cEnter
		cQryEpv += " AND TATICO IN "+FormatIn(cTatic,";")+" "+cEnter 
		cQryEpv += " AND ESPECIE_PEDIDO IN "+FormatIn(_CTIPOS,";")+" "+cEnter
		cQryEpv += " AND STATUS_PEDIDO = '"+If(cStatP=="T","TODOS",If(cStatP=="F","FATURADO","NAO FATURADO"))+"' "+cEnter 

		dbUseArea( .T. , "TOPCONN", TCGENQRY(,,cQryEpv),"QRYEPV", .F. , .T. )
		
		dbSelectArea("QRYEPV")
		dbGoTop()

		// Inicia a verificacao dos dados do temporario
		U_MFCONOUT("Inicia a verificacao dos dados do temporario")

		// Conta pedidos e gera o array para exclusao dos PV's
		While QRYEPV->(!Eof())

			// Antes de excluir o PV, verifica se j� esta na tabela ZEI e seu status
			ZEI->(dbSetOrder(1))

			If ZEI->(dbSeek(QRYEPV->EMPRESA+QRYEPV->PEDIDO))
				U_MFCONOUT(	"Filial : "+QRYEPV->EMPRESA+" - Pedido : "+QRYEPV->PEDIDO+;
           					" esta com o STATUS : "+AllTrim(UPPER(ZEI->ZEI_STATUS))+;
		  					" e nao foi excluido.")
				QRYEPV->(dbSkip())
				Loop
			EndIf			  
       
	   		cEspcPd := AllTrim(QRYEPV->ESPECIEPED)
			nQtdSol := QRYEPV->QTDESOLICI

			nTot++	

			U_MFCONOUT("Leitura do PV - Filial : "+QRYEPV->EMPRESA+" Pedido : "+QRYEPV->PEDIDO)

			dbSelectArea("SC5")
			SC5->(dbSetOrder(1))
		    
			If SC5->(dbSeek(QRYEPV->EMPRESA+QRYEPV->PEDIDO))
			
				If cEspcPd $ _CTIPOS
                   
					If (SC5->C5_ZROAD == "S" .AND. _CROTEI == "S") .OR. ;
					   (SC5->C5_ZROAD != "S" .AND. _CROTEI == "N") .OR. _CROTEI == "T"

					   // S� preenche o array se nao foi faturado de fato
					   If Empty(SC5->C5_NOTA) .AND. Empty(SC5->C5_SERIE) 

						  U_MFCONOUT("Verifica bloqueio dos pedidos liberados")

						  If !Empty(SC5->C5_LIBEROK)

					      	 // Verifica no SC9, se existem PV's que atendam ao campo ZG1_PVBLQ
						  	 dbSelectArea("SC9")
						  	 SC9->(dbSetOrder(1))
						  	 If SC9->(dbSeek(QRYEPV->EMPRESA+QRYEPV->PEDIDO))
						     
							    While SC9->(C9_FILIAL+C9_PEDIDO) == QRYEPV->EMPRESA+QRYEPV->PEDIDO

						            If     	cPvBlq == "C"
								           	U_MFCONOUT("Pedidos "+SC9->C9_PEDIDO+" com bloqueio de Credito")
								   	       	If SC9->C9_BLCRED == "01" 
									   	      	_lOk := .T.
									 	   	EndIf
								    ElseIf 	cPvBlq == "E"
							 	           	U_MFCONOUT("Pedidos "+SC9->C9_PEDIDO+" com bloqueio de Estoque") 	 	   
								           	If SC9->C9_BLCRED == "02"
									          	_lOk := .T.
									       	EndIf
									ElseIf  cPvBlq == "T"
								       		U_MFCONOUT("Pedidos "+SC9->C9_PEDIDO+" com bloqueio de Credito/Estoque")
							     	   		If SC9->C9_BLCRED $ "01|02" 
									       		_lOk := .T.
									   		EndIf
									ElseIf Empty(cPvBlq)
								       		U_MFCONOUT("Pedidos "+SC9->C9_PEDIDO+" sem bloqueio de Credito/Estoque")
							     	   		If Empty(SC9->C9_BLCRED) 
									       		_lOk := .T.
									   		EndIf
									EndIf
							
									SC9->(dbSkip())

							 	EndDo
							 
							 EndIf	  
						  
						  Else
						  
						     U_MFCONOUT("Pedidos "+SC9->C9_PEDIDO+" nao foi liberado e esta em exclusao.")
						  	 _lOk := .T.
						  
						  EndIf
						   
						  dbSelectArea("SC5")
						
						  If _lOk

						     U_MFCONOUT("Cria o ARRAY para exclusao dos PV's")
							
							 _nj := Ascan(_aCols,{|item| item[1] == SC5->C5_FILIAL .AND. ;
							                             item[2] == SC5->C5_NUM})
			   
							 If Empty(_nj)
							 	AADD(_aCols,{	SC5->C5_FILIAL,;
												SC5->C5_NUM,;
												If(EMPTY(SC5->C5_ZDTREEM),SC5->C5_ZDTEMBA,SC5->C5_ZDTREEM),;
												If(SC5->C5_ZROAD == "S","SIM","NAO"),;
												POSICIONE("SA3",1,XFILIAL("SA3")+SC5->C5_VEND1,"A3_NOME"),;
												SC5->C5_ZTIPPED,;
												nQtdSol  } )
							 Else
								_aCols[_nj][7] += nQtdSol
							 EndIf
						  
						  EndIf	 
					    
					   EndIf
							
					EndIf	
		
				EndIf	
			
			EndIf	

			dbSelectArea("QRYEPV")
			QRYEPV->(dbSkip())
	
		EndDo

		If Empty(Len(_aCols))
			U_MFCONOUT("Nao foram localizados pedidos para serem excluidos!")
			Return
		EndIf

		_aCols := aSort(_aCols, , , { | x,y | x[1]+x[2] > y[1]+y[2] } )

		U_MFCONOUT("Inicio da Exclusao dos PV's")

		For nkl := 1 to Len(_aCols)
			AADD(aPeds,_aCols[nkl])
		Next

		_aCols := {}
		nTot   := Len(aPeds)

		For nkl := 1 to Len(aPeds)

			aCab 	 := {}
			aItemPV  := {}
			aItensPV := {}

			cFilPed := aPeds[nkl][1]
			cPedExc := aPeds[nkl][2]

			U_MFCONOUT("Excluindo Pedido : "+cPedExc+" - Filial : "+cFilPed)

			SC5->(dbSetOrder(1))
			
			If SC5->(dbSeek(cFilPed+cPedExc))

				_ddtent  := SC5->C5_ZDTEMBA
				_ddtrem  := SC5->C5_ZDTREEM
				_cclient := SC5->C5_CLIENTE
				_cloja   := SC5->C5_LOJACLI

				// Carrega Array aCab
				AADD( aCab, { "C5_FILIAL"	,SC5->C5_FILIAL  , Nil})//filial
				AADD( aCab, { "C5_NUM"    	,SC5->C5_NUM	 , Nil}) 
				AADD( aCab, { "C5_TIPO"	    ,SC5->C5_TIPO    , Nil})//Tipo de pedido
				AADD( aCab, { "C5_CLIENTE"	,SC5->C5_CLIENTE , NiL})//Codigo do cliente
				AADD( aCab, { "C5_CLIENT" 	,SC5->C5_CLIENT	 , Nil}) 
				AADD( aCab, { "C5_LOJAENT"	,SC5->C5_LOJAENT , NiL})//Loja para entrada
				AADD( aCab, { "C5_LOJACLI"	,SC5->C5_LOJACLI , NiL})//Loja do cliente
				AADD( aCab, { "C5_EMISSAO"	,SC5->C5_EMISSAO , NiL})//Data de emissao
				AADD( aCab, { "C5_TRANSP" 	,SC5->C5_TRANSP	 , Nil}) 
				AADD( aCab, { "C5_CONDPAG"	,SC5->C5_CONDPAG , NiL})//Codigo da condicao de pagamanto*
				AADD( aCab, { "C5_VEND1"  	,SC5->C5_VEND1	 , Nil}) 
				AADD( aCab, { "C5_MOEDA"    ,SC5->C5_MOEDA   , Nil})//Moeda
				AADD( aCab, { "C5_MENPAD" 	,SC5->C5_MENPAD	 , Nil}) 
				AADD( aCab, { "C5_LIBEROK"	,SC5->C5_LIBEROK , NiL})//Liberacao Total
				AADD( aCab, { "C5_TIPLIB"  	,SC5->C5_TIPLIB  , Nil})//Tipo de Liberacao
				AADD( aCab, { "C5_TIPOCLI"	,SC5->C5_TIPOCLI , NiL})//Tipo do Cliente

				// Carrega Array aItens
				SC6->( dbSeek( SC5->C5_FILIAL + SC5->C5_NUM ) )
				_aItensPV := {}
	
				While SC6->( !EOF() ) .And. SC6->( C6_FILIAL + C6_NUM ) == SC5->(C5_FILIAL + C5_NUM)
		
					_aItemPV := {}
		
					AADD( _aItemPV , { "C6_FILIAL"  ,SC6->C6_FILIAL  , Nil }) // FILIAL
					AADD( _aItemPV , { "C6_NUM"    	,SC6->C6_NUM	 , Nil })
					AADD( _aItemPV , { "C6_ITEM"    ,SC6->C6_ITEM    , Nil }) // Numero do Item no Pedido
					AADD( _aItemPV , { "C6_PRODUTO" ,SC6->C6_PRODUTO , Nil }) // Codigo do Produto
					AADD( _aItemPV , { "C6_UNSVEN"  ,SC6->C6_UNSVEN  , Nil }) // Quantidade Vendida 2 un
					AADD( _aItemPV , { "C6_QTDVEN"  ,SC6->C6_QTDVEN  , Nil }) // Quantidade Vendida
					AADD( _aItemPV , { "C6_PRCVEN"  ,SC6->C6_PRCVEN  , Nil }) // Preco Unitario Liquido
					AADD( _aItemPV , { "C6_PRUNIT"  ,SC6->C6_PRUNIT  , Nil }) // Preco Unitario Liquido
					AADD( _aItemPV , { "C6_ENTREG"  ,SC6->C6_ENTREG  , Nil }) // Data da Entrega
					AADD( _aItemPV , { "C6_LOJA"   	,SC6->C6_LOJA	 , Nil })
					AADD( _aItemPV , { "C6_SUGENTR" ,SC6->C6_SUGENTR , Nil }) // Data da Entrega
					AADD( _aItemPV , { "C6_VALOR"   ,SC6->C6_VALOR   , Nil }) // valor total do item
					AADD( _aItemPV , { "C6_UM"      ,SC6->C6_UM      , Nil }) // Unidade de Medida Primar.
					AADD( _aItemPV , { "C6_TES"    	,SC6->C6_TES	 , Nil })
					AADD( _aItemPV , { "C6_LOCAL"   ,SC6->C6_LOCAL   , Nil }) // Almoxarifado
					AADD( _aItemPV , { "C6_CF"     	,SC6->C6_CF		 , Nil })
					AADD( _aItemPV , { "C6_DESCRI"  ,SC6->C6_DESCRI  , Nil }) // Descricao
					AADD( _aItemPV , { "C6_QTDLIB"  ,SC6->C6_QTDLIB  , Nil }) // Quantidade Liberada
					AADD( _aItemPV , { "C6_PEDCLI" 	,SC6->C6_PEDCLI	 , Nil })
	
					AADD( _aItensPV ,_aItemPV )
     
					SC6->( dbSkip() )
		
				EndDo
        
				// Exclui o pedido
				_cRetorno := xApagaPed(SC5->C5_FILIAL,SC5->C5_NUM,"A")

				AADD(_aCols,{cFilPed,cPedExc,_ddtent,_ddtrem,_cclient+"/"+_cloja,;
							 POSICIONE("SA1",1,xfilial("SA1")+_cclient+_cloja,"A1_NREDUZ"),_cRetorno})
				U_MFCONOUT(AllTrim(_cRetorno))
			Else

				AADD(_aCols,{cFilPed,cPedExc,_ddtent,_ddtrem,_cclient+"/"+_cloja,;
					 POSICIONE("SA1",1,xfilial("SA1")+_cclient+_cloja,"A1_NREDUZ"),;
					 "Nao localizou pedido de venda"})
				U_MFCONOUT("Nao localizou pedido de venda")
			EndIf

		Next

		If Len(_aCols) > 0
			U_MFCONOUT("Completou exclusao de pedidos de venda nao atendidos!")
		Else
			U_MFCONOUT("Nenhum pedido excluido!")
		EndIf
	
	Next

Return