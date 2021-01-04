#include "totvs.ch"  
//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF29R02	�Autor  � Geronimo Benedito Alves																	�Data �  21/12/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: EEC-Easy Export Control - 29 -EXPORTACAO - Orcamento x EXP		       		   ���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																											   ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������
User Function MGF29R02()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "EXPORTACAO - Orcamento x EXP"		)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Aprovacao por Orcamento x EXP"	)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Aprovacao por Orcamento x EXP"}	)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Aprovacao por Orcamento x EXP"}	)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}									)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }						)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02						03						04	  05	06		07					08		 09	
	Aadd(_aCampoQry, {"ZZC_DTPROC"	,"DATA_PV"				,"Data Orcamento"		,""	, ""	, ""	, ""				, ""	, ""	})
	Aadd(_aCampoQry, {"ZZC_ORCAME"	,"PV"					,"Orcamento"			,""	, ""	, ""	, ""				, ""	, ""	})     
	Aadd(_aCampoQry, {"ZZC_ZANOOR"	,"PV_ANO"				,""						,""	, ""	, ""	, ""				, ""	, ""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_BUYER"			,"Nome Buyer"			,""	, ""	, ""	, ""				, ""	, ""	}) 
	Aadd(_aCampoQry, {"EEH_NOME"	,"FAMILA_PRODUTO"		,"Familia Produto"		,""	, ""	, ""	, ""				, ""	, ""	})
	Aadd(_aCampoQry, {"YA_NOIDIOM"	,"PAIS_PORTO_DESTINO"	,"Pais Porto Destino"	,""	, ""	, ""	, ""				, ""	, ""	})  
	Aadd(_aCampoQry, {"YR_CID_DES"	,"PORTO_DESTINO"		,"Porto Destino"		,""	, ""	, ""	, ""				, ""	, ""	})  
	Aadd(_aCampoQry, {"A3_NOME"		,"TRADER"				,"Trader"				,""	, ""	, ""	, ""				, ""	, ""	})
	Aadd(_aCampoQry, {"ZZC_ZREGIA"	,"REGIAO"				,""						,"C", 07	, ""	, ""				, ""	, ""	})
	Aadd(_aCampoQry, {"ZB8_DTPROC"	,"DT_EXP"				,"Data Exp"				,""	, ""	, ""	, ""				, ""	, ""	}) 
	Aadd(_aCampoQry, {"ZZG_DTAPRO"	,"DT_APROV_PCP"			,"Data Aprovacao PCP"	,""	, ""	, ""	, ""				, ""	, ""	})  
	Aadd(_aCampoQry, {"ZZG_DTAPRO"	,"ENVIO_PROFORMA"		,"Envio Proforma"		,"N", 09	, 0		, "@E 999,999,999"	, ""	, ""	})

	aAdd(_aParambox,{1,"Data do Orcamento Inicial"	,Ctod("")					,""	,"" 													,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data do Orcamento Final  "	,Ctod("")					,""	,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data do Processo')"	,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Orcamento                "	,Space(tamSx3("B1_COD")[1])	,""	,""														,""		,"",100,.F.})

	SetKey(K_CTRL_F8,{||U_BIEmlini("Bi_e_Protheus")}) ;SetKey(K_CTRL_F9,{||U_BIEmlini("Protheus")})	// CTRL+F8 (Codigo inkey -27), executa a funcao que ira alimentar a array, para o envio do email com a query do relatorio para a equipe de desenvolvimento do B.I. e do Protheus.            // CTRL+F9 (Codigo inkey -28), envia o email somente para a equipe de desenvolvimento do Protheus.
	If Len(_aParambox) > 0 ;  _lRet := ParamBox(_aParambox, _aDefinePl[2], @_aRet	,,	,,	,,	,,.T.,.T.)  ; 	Endif
	SetKey(K_CTRL_F8,{||}) ; SetKey(K_CTRL_F9,{||})	// Cancela a associacao das teclas CTRL+F8 (Codigo inkey -27) e CTRL+F9 (Codigo inkey -28)
	If ! U_ParameR2(_aParambox, _bParameRe, @_aRet ,_lRet ) ; Return ; Endif

	cQryEmpres := "			  select 'MARFRIG'  as CAMPO_01 from dual " +CRLF
	cQryEmpres += " union all select 'PAMPEANO' as CAMPO_01 from dual " +CRLF
	aCpoEmpres	:=	{	{ "CAMPO_01"	,"Empresa"	,50	} } 
	cTitEmpres	:= "Marque as empresas � serem listadas: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: CAMPO_01
	
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene
	aEmpresas	:= U_MarkGene(cQryEmpres, aCpoEmpres, cTitEmpres, nPosRetorn, @_lCancProg ) 
	If _lCancProg
		Return
	Endif 
	cEmpresas	:= U_Array_In( aEmpresas )

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR",	"V_EX_ORCAMENTO_EXP" ) +CRLF
	_cQuery += U_WhereAnd( !empty(cEmpresas ),		" FILTRO_EXP IN "			+ cEmpresas	                      		 ) //COMBO FIXO E OBRIGATORIO (IR� SUBSTITUIR O FILTRO DE EMPRESAS) 		    
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),      " DATA_PV_FILTRO BETWEEN '"	+ _aRet[1] + "' AND '" + _aRet[2] + "' " ) //NAO OBRIGATORIO/SEM TRAVA DE DATA
	_cQuery += U_WhereAnd( !empty(_aRet[3] ),      " PV LIKE '%"	+ _aRet[1] + "%' "  ) //NAO OBRIGATORIO/USUARIO DIGITA

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN
