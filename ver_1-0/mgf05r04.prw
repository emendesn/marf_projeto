#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF05R04	�Autor  � Geronimo Benedito Alves																	�Data �  04/05/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: FATURAMENTO - Conferencia Roteirizacao					(Modulo 05-FAT)			���
//���			� Os dados sao obtidos e mostrados na tela atraves da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF05R04()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Faturamento - Conferencia Roteirizacao"	)	//01-  _cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Conferencia Roteirizacao"					)	//02-  _cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Conferencia Roteirizacao"}				)	//03-  _cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Conferencia Roteirizacao"}				)	//04-  _cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  										)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }								)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02									 03						 04		 05	 06		 07	 	 08	 09		
	Aadd(_aCampoQry, {"C5_FILIAL"	,"FILIAL"							,"Filial"				,""		,""	,"" 	,""		,""	,""	})
	AAdd(_aCampoQry, {"C5_NUM"		,"NUM_PEDIDO"						,"N� Pedido"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_CLIENT"	,"COD_CLIENTE		as CODCLIENTE"	,"Cod. Cliente"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_CLIENTE		as NOMECLIENT"	,"Nome do Cliente"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZP_CODREG"	,"COD_REGIAO"						,"Cod. da Regiao"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZP_DESCREG"	,"DESC_REGIAO		as DESCREGIAO"	,"Nome da Regiao"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_QTDVEN"	,"QUANTIDADE"						,"Quantidade"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_ZBLQRGA"	,"BLOQUEIO_REGRA	as BLOQUEIORE"	,"Bloqueio de Regra"	,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_ZTIPPED"	,"ESPECIE_PEDIDO	as ESPECIEPED"	,"Especie de Pedido"	,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_VEND1"	,"COD_VENDEDOR		as CODVENDEDO"	,"Cod. Vendedor"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A3_NOME"		,"NOME_VENDEDOR		as NOM_VENDED"	,"Nome Vendedor"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_ZROAD"	,"STATUS_INTEGRADO	as STATUSINTE"	,"Status Integracao"	,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_TPFRETE"	,"TIPO_FRETE"						,"Tipo do Frete" 		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_ZCROAD"	,"COD_ROADNET		as CODROADNET"	,"Cod. RoadNet" 		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_MUN"		,"MUNICIPIO"						,"Nome Municipio" 		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"XXXXCIDADE"	,"CIDADE"							,"UF/Cidade"			,"C"	,10	,0		,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_END"		,"ENDERECO"							,"Endereco"				,""		,""	,"" 	,""		,""	,""	})

	aAdd(_aParambox,{1,"Data de Entrega Inicial"	,Ctod("")						,""	,"" 												,""		,""	 ,050,.F.})
	aAdd(_aParambox,{1,"Data de Entrega Final"		,Ctod("")						,""	,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data')"			,""		,""	 ,050,.F.})
	aAdd(_aParambox,{1,"Cod. Cliente Inicial:"		,Space(tamSx3("A1_COD")[1])		,""	,""													,"CLI"	,""	 ,050,.F.})													
	aAdd(_aParambox,{1,"Cod. Cliente Final:"		,Space(tamSx3("A1_COD")[1])		,""	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Cod. Cliente')"	,"CLI"	,""	 ,050,.F.})													
	aAdd(_aParambox,{1,"N� Pedido Inicial:"			,Space(tamSx3("C5_NUM")[1])		,""	,""													,""	 	,""	 ,050,.F.})													
	aAdd(_aParambox,{1,"N� Pedido Final:"			,Space(tamSx3("C5_NUM")[1])		,""	,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'N� Pedido')"		,""	 	,""	 ,050,.F.})													
	aAdd(_aParambox,{1,"Cod. Regiao Inicial:"		,Space(tamSx3("ZP_CODREG")[1])	,""	,""													,"SZP"	,""	 ,050,.F.})													
	aAdd(_aParambox,{1,"Cod. Regiao Final:"			,Space(tamSx3("ZP_CODREG")[1])	,""	,"U_VLFIMMAI(MV_PAR07, MV_PAR08, 'Cod. Regiao')"	,"SZP"	,""	 ,050,.F.})													
	aAdd(_aParambox,{1,"Cod. Municipio Inicial:"	,Space(tamSx3("A1_COD_MUN")[1])	,""	,""													,"CC2"	,""	 ,050,.F.})													
	aAdd(_aParambox,{1,"Cod. Municipio Final:"		,Space(tamSx3("A1_COD_MUN")[1])	,""	,"U_VLFIMMAI(MV_PAR09, MV_PAR10, 'Cod. Municipio')"	,"CC2"	,""	 ,050,.F.})													

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	
	_cQuery += " FROM " + U_IF_BIMFR( "IF_BIMFR","V_FAT_CONFERENCIAROTEIRIZACAO" ) + CRLF 
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),  " FILIAL IN "                     + _cCODFILIA	                             )	// OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),    " DATA_ENTREGA_FILTRO BETWEEN '"  + _aRet[1] + "' AND '" + _aRet[2]  + "' " )	// OBRIGATORIO, COM A VALIDACAO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),    " COD_CLIENTE BETWEEN '"          + _aRet[3] + "' AND '" + _aRet[4]  + "' " )	// NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),    " NUM_PEDIDO BETWEEN '"           + _aRet[5] + "' AND '" + _aRet[6]  + "' " )	// NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[8] ),    " COD_REGIAO BETWEEN '"           + _aRet[7] + "' AND '" + _aRet[8]  + "' " )	// NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[10] ),   " SUBSTR(CIDADE,3,5) BETWEEN '"   + _aRet[9] + "' AND '" + _aRet[10] + "' " )	// NAO OBRIGATORIO

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()	})

RETURN