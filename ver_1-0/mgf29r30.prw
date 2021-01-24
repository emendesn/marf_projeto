#include "totvs.ch"  

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF29R30	�Autor  � Geronimo Benedito Alves																	�Data �  25/05/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: EEC-Easy Export Control - 29 -EXPORTA��O - Aprova��o por or�amento		       ���
//���			� Os dados sao obtidos e mostrados na tela atrav�z da execu��o de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Marfrig Global Foods																											   ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF29R30()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _nInterval
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "EXPORTA��O - Aprova��o por or�amento"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Aprova��o por or�amento"				)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Aprova��o por or�amento"}			)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Aprova��o por or�amento"}			)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}										)	//05-	Array de Arrays que define quais colunas ser�o mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, ser� mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }							)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser inclu�do naquela aba  
	_nInterval	:= 35											//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma fun��o (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que ser� transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 s�o sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos ser�o preservados.
	//					01			 02									 03					 04	 05		 06	 07		 08		 09	
	Aadd(_aCampoQry, {"ZZC_ORCAME"	,"NUM_ORCAMENTO		as NUMORCAMEN"	,"N� Or�amento"		,"C",006	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"ZZC_ZANOOR"	,"ANO_ORCAMENTO		as ANOORCAMEN"	,"Ano Or�amento"	,"C",002	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"ZZC_DTPROC"	,"DATA_PROCESSO		as DATAPROCES"	,"Data do Processo"	,"D",008	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"A1_COD"		,"CODIGO_IMPORTADOR	as CODIMPORTA"	,"C�digo Importador","C",006	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_IMPORTADOR	as NOMEIMPORT"	,"Nome Iportador"	,"C",040	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"ZZC_FILIAL"	,"COD_FILIAL"						,"C�d. Filial"		,"C",006	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"M0_NOME"		,"NOME_FILIAL		as NOM_FILIAL"	,"Nome da Filial"	,"C",040	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"ZZC_ZOBSWE"	,"NOTAS_WEEK"						,"Notas Week"		,"C",090	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"YR_CID_DES"	,"PORTO_DESTINO		as PORTODESTI"	,"Porto Destino"	,"C",020	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"XXZZGSTAT1"	,"NIVEL1"							,"N�vel 1"			,"C",025	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"ZZG_DTAPRO"	,"DATA_NIVEL1		as DATANIVEL1"	,"Data N�vel 1"		,"D",008	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"XXZZGSTAT2"	,"NIVEL2"							,"N�vel 2"			,"C",025	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"ZZG_DTAPRO"	,"DATA_NIVEL2		as DATANIVEL2"	,"Data N�vel 2"		,"D",008	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"XXZZGSTAT3"	,"NIVEL3"							,"N�vel 3"			,"C",025	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"ZZG_DTAPRO"	,"DATA_NIVEL3		as DATANIVEL3"	,"Data N�vel 3"		,"D",008	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"XXZZGSTAT4"	,"NIVEL4"							,"N�vel 4"			,"C",025	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"ZZG_DTAPRO"	,"DATA_NIVEL4		as DATANIVEL4"	,"Data N�vel 4"		,"D",008	,0	,""		,""		,""	})

	aAdd(_aParambox,{1,"Data do Processo Inicial"	,Ctod("")	,""		,"" 													,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Data do Processo Final  "	,Ctod("")	,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data do Processo')"	,""		,"",050,.T.})
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_EX_APROVACAOORCAMENTO" ) + " A " +CRLF
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),      " DATA_PROCESSO_FILTRO   BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' " ) // OBRIGATORIO, SEM VALIDA��O DE INTERVALO DE DIAS
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN

