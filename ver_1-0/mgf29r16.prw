#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF29R16	�Autor  �Geronimo Benedito Alves																	�Data �22/05/18    ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: EEC-Easy Export Control - 29 -EXPORTACAO - Seguro Internacional				   ���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																											   ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF29R16()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Exportacao - Seguro Internacional")	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl,  "Seguro Internacional"			)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Seguro Internacional"}			)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Seguro Internacional"}			)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}							 		)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }				 		)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_nInterval	:= 35										//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02											 03						 04	 05	  	 06	 07		 08		 09	
	Aadd(_aCampoQry, {"EEC_ZEXP"	,"NUMERO_EXP"								,"Numero Exportacao"	,"C",013	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"EEC_ZANOEX"	,"ANO"										,"Ano Exportacao"		,"C",002	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"EEC_ZSUBEX"	,"ITEM_SUB"									,"Item Sub"				,"C",003	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"EEC_REFIMP"	,"PO"										,"PO#"					,"C",040	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"M0_FILIAL"	,"UNIDADE_FATUROU		as UNIDADEFAT"		,"Unidade Faturamento"	,"C",040	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"D2_DOC"		,"NF"										,"#NF"					,"C",009	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"D2_EMISSAO"	,"DATA					as DATAEMISSA"		,"Data #"				,"D",008	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"TRADING"									,"Trading"				,"C",040	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"IMPORTADOR"								,"Importador"			,"C",040	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"BUYER"									,"Buyer"				,"C",040	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"ZZR_DTESTU"	,"DATA_ESTUFAGEM		as DATAESTUFA"		,"Data Estufagem"		,"D",008	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"EX9_CONTNR"	,"NUMERO_CNTR"								,"Numero Cntr"			,"C",020	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"YR_CID_DES"	,"PORTO_DESTINO			as PORTO_DESTINO"	,"Porto Destino"		,"C",020	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"EE9_PRCINC"	,"TOTAL_INVOICE			as TOTALINVOI"		,"Total Invoice"		,"N",015	,2	,""		,""		,""	})
	Aadd(_aCampoQry, {"EEC_INCOTE"	,"SALES_TERMS			as SALESTERMS"		,"Sales Terms"			,"C",003	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"EE9_PSLQTO"	,"NET_WEIGHT"								,"Peso Liquido"			,"N",015	,2	,""		,""		,""	})
	Aadd(_aCampoQry, {"YC_NOME"		,"TIPO_PRODUTO			as TIPOPRODUT"		,"Tipo de Produto"		,"C",045	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"EEC_ZTRANS"	,"TRANSPORTADORA		as TRANSPORTA"		,"Transportadora"		,"C",040	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"EEC_DTEMBA"	,"DATA_BL"									,"Data Embarque"		,"D",008	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"YQ_DESCR"	,"VIA"										,"Via"					,"C",030	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"EEC_DTEMBA"	,"DATA_BL_TRANSPORTE"						,"Data BL Transporte"	,"D",008	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"EE6_NOME"	,"NAVIO"									,"Navio"				,"C",040	,0	,""		,""		,""	})

	aAdd(_aParambox,{1,"Nome do Administrador"		,Space(tamSx3("EEC_RESPON")[1])	,"@!"	,""													,""		,"",100,.F.})
	aAdd(_aParambox,{1,"C�d. Buyer Inicial"			,Space(tamSx3("A1_COD")[1])		,""		,""													,"CLI"	,"",050,.F.}) 
	aAdd(_aParambox,{1,"C�d. Buyer Final"			,Space(tamSx3("A1_COD")[1])		,""		,"U_VLFIMMAI(MV_PAR02, MV_PAR03,'Cod. Buyer')"		,"CLI"	,"",050,.F.})	
	aAdd(_aParambox,{1,"Data Emissao NF Inicial"	,Ctod("")						,""		,""													,""		,"",050,.F.}) 
	aAdd(_aParambox,{1,"Data Emissao NF Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR04, MV_PAR05,'Data Emissao')"	,""		,"",050,.F.})	
	aAdd(_aParambox,{1,"Data Estufagem Inicial"		,Ctod("")						,""		,""													,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Estufagem Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR06, MV_PAR07,'Data Estufagem')"	,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data BL Inicial"			,Ctod("")						,""		,""													,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data BL Final"				,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR08, MV_PAR09,'Data BL Final')"	,""		,"",050,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	//===		S E L E C I O N A	P A I S   D O     P O R T O     D E S T I N O
	cQryPaisde	:= "SELECT ' ' as YA_NOIDIOM, '  Nao  Informado' as YA_DESCR, ' ' as YA_CODGI FROM DUAL UNION ALL " +CRLF
	cQryPaisde	+= "SELECT DISTINCT YA_NOIDIOM, YA_DESCR, YA_CODGI " +CRLF
	cQryPaisde  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SYA") ) + " TMPSYA "  +CRLF
	cQryPaisde	+= "  WHERE TMPSYA.D_E_L_E_T_ = ' ' "  +CRLF
	cQryPaisde	+= "  ORDER BY YA_NOIDIOM, YA_DESCR " +CRLF
	aCpoPaisde	:=	{	{ "YA_NOIDIOM"	,"Pa�s porto Destino (no idioma)"		,TamSx3("YA_NOIDIOM")[1] + 80	}	,;
						{ "YA_DESCR"	,"Pa�s porto Destino"		,TamSx3("YA_DESCR")[1] + 80	}	,;
						{ "YA_CODGI"	,U_X3Titulo("YA_CODGI")	,TamSx3("YA_DESCR")[1] 		}	 } 
	cTituPaisd	:= "Pa�ses dos portos de Destinos a serem listados: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: A6_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene
	_cPaisDest	:= U_Array_In( U_MarkGene(cQryPaisde, aCpoPaisde, cTituPaisd, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif


	//=============================================== S E L E C I O N A     V I A 
	cQryVia	:= " SELECT '" +SPACE(TamSx3("YQ_DESCR")[1])+ "' as YQ_DESCR, 'Nao  Informado' as YQ_COD_DI, '  ' as YQ_VIA FROM DUAL UNION ALL " +CRLF
	cQryVia	+= " SELECT DISTINCT YQ_DESCR, YQ_COD_DI, YQ_VIA " +CRLF
	cQryVia  	+= "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SYQ") ) + " TMPSYQ "  +CRLF
	cQryVia	+= "  WHERE TMPSYQ.D_E_L_E_T_ = ' ' "  +CRLF
	cQryVia	+= "  ORDER BY YQ_DESCR " +CRLF
	aCpoVia	:=	{	{ "YQ_DESCR"		,"Via de Transporte"	,TamSx3("YQ_DESCR")[1] + 40	}  ,; 
					{ "YQ_COD_DI"		,"Codigo"				,TamSx3("YQ_COD_DI")[1] + 30 }  ,; 
					{ "YQ_VIA"			,"Via"					,TamSx3("YQ_VIA")[1] 		}   } 
	cTituVia	:= "Vias de transportes � serem listadas: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: YQ_COD_DI
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene
	_cVia	:= U_Array_In( U_MarkGene(cQryVia, aCpoVia, cTituVia, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 

	_cQuery += " FROM " + U_IF_BIMFR( "IF_BIMFR", "V_EX_SEGUROINTERNACIONAL"  )       + CRLF
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),   " FILIAL_FILTRO IN "                + _cCODFILIA                               ) //OBRIGATORIO (SELE��O DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[1] ),     " ADMINISTRADOR LIKE '%"            + _aRet[1] + "%' "                         ) //NAO � OBRIGATORIO, USU�RIO DIGITA
	_cQuery += U_WhereAnd( !empty(_aRet[3] ),     " CODIGO_BUYER BETWEEN '"           + _aRet[2] + "' AND '" + _aRet[3] + "' "   ) //NAO OBRIGATORIO --SELE��O POR RANGE  **NOVO FILTRO**
	If Empty( _cPaisDest)	// YA_DESCR
		_cQuery += ""
	ElseIF AT("' '", _cPaisDest ) <> 0
			_cQuery += U_WhereAnd( .T. ,          " ( PAIS_PORTO_DESTINO IS NULL OR PAIS_PORTO_DESTINO IN " + _cPaisDest + " )"  ) 
	Else	
			_cQuery += U_WhereAnd( .T. ,          " PAIS_PORTO_DESTINO IN " + _cPaisDest                                         ) 	
	Endif
	
	_cQuery += U_WhereAnd( !empty(_aRet[5] ),     " NF_FILTRO BETWEEN '" + _aRet[4]   + "' AND '" + _aRet[5] + "' "              ) //NAO OBRIGATORIO, PODE VIR EM BRANCO --SEM TRAVA
	_cQuery += U_WhereAnd( !empty(_aRet[7] ),     " DATA_ESTUFAGEM_FILTRO BETWEEN '"  + _aRet[6] + "' AND '" + _aRet[7] + "' "   ) //NAO OBRIGATORIO, PODE VIR EM BRANCO --SEM TRAVA
	_cQuery += U_WhereAnd( !empty(_aRet[9] ),     " DATA_BL_FILTRO BETWEEN '"         + _aRet[8] + "' AND '" + _aRet[9] + "' "   ) //NAO OBRIGATORIO, PODE VIR EM BRANCO --SEM TRAVA
	If Empty( _cVia )
		_cQuery += ""
	ElseIF AT("' '", _cVia ) <> 0
		_cQuery += U_WhereAnd( .T. ,          " ( VIA IS NULL OR VIA IN " + _cVia + " )"                                     ) 
	Else	
		_cQuery += U_WhereAnd( .T. ,          " VIA IN "                  + _cVia                                            ) 	
	Endif
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN

