#include "totvs.ch"   

/*
=====================================================================================
Programa.:              MGF06R29
Autor....:              Marcelo Carneiro
Data.....:              07/10/2019
Descricao / Objetivo:   Relatorio BI CONTAS  RECEBER - RECEBIVEIS ME
Doc. Origem:            RITM0030765 Chamado RTASK0010181
Uso......:              
Obs......:              View : IF_BIMFR.V_CR_RECEBIVEIS_ME
=====================================================================================
*/
User Function MGF06R29()

Local cNatureza  := ''
Local cTipo      := ''
Local cQuery     := ''
Local aCampos    := {}
Local nPosRetorn := 1
Local _lCancProg := .T.
Local cEnviroSrv := ''

Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
Private _aSelFil		:= {}
Private _aEmailQry , _cWhereAnd
_aEmailQry	:= {}  ; _cWhereAnd	:= ""

Aadd(_aDefinePl, "CONTAS  RECEBER - RECEBIVEIS ME"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
Aadd(_aDefinePl, "RECEBIVEIS ME"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
Aadd(_aDefinePl, {"RECEBIVEIS ME"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
Aadd(_aDefinePl, {"RECEBIVEIS ME"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
Aadd(_aDefinePl, {}									)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
Aadd(_aDefinePl, { {||.T.} }						)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  

_aCpoExce	:= {}
_cTmp01		:= ""

//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
//pela clausula "as" que sera transportado para o elemento 8.
//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
//					01			02					03					04		 05		 06	 07	08 09		
Aadd(_aCampoQry, {"E1_FILIAL"     , "FILIAL"		     ,"FILIAL"		       ,"C"	,006	,0	,""	,""	,""	})
Aadd(_aCampoQry, {"E1_HIST"	      , "HISTORICO" 	     ,"HISTORICO"	       ,"C"	,TamSx3("E1_HIST"	)[1],0	,""	,""	,""	})
Aadd(_aCampoQry, {"E1_PREFIXO"    , "PREFIXO"    	     ,"PREFIXO"    	   	   ,"C"	,TamSx3("E1_PREFIXO")[1],0	,""	,""	,""	}) // 31/10/2019
Aadd(_aCampoQry, {"E1_NUM"        , "NUM_TITULO"	     ,"NUM_TITULO"	   	   ,"C"	,TamSx3("E1_NUM"    )[1],0	,""	,""	,""	})
Aadd(_aCampoQry, {"E1_CLIENTE"    , "COD_CLIENTE"	     ,"COD_CLIENTE"	   	   ,"C"	,TamSx3("E1_CLIENTE")[1],0	,""	,""	,""	})
Aadd(_aCampoQry, {"E1_NOMCLI"     , "NOME_CLENTE"	     ,"NOME_CLENTE"	   	   ,"C"	,TamSx3("E1_NOMCLI" )[1],0	,""	,""	,""	})
Aadd(_aCampoQry, {"E1_EMISSAO"    , "DT_EMISSAO"	     ,"DT_EMISSAO"	   	   ,"D"	,TamSx3("E1_EMISSAO")[1],0	,""	,""	,""	}) // 31/10/2019
//Aadd(_aCampoQry, {"E1_EMIS"       , "DT_EMISSAO_FILTRO"	 ,"DT_EMISSAO_FILTRO"  ,"C"	,TamSx3("E1_EMISSAO")[1],0	,""	,""	,""	})
Aadd(_aCampoQry, {"E1_VENCTO"     , "DATA_VENCIMENTO"	 ,"DATA_VENCIMENTO"	   ,"D"	,TamSx3("E1_VENCTO" )[1],0	,""	,""	,""	}) // 31/10/2019
Aadd(_aCampoQry, {"E1_VALOR"      , "VLR_TITULO"	     ,"VLR_TITULO"	   	   ,"N"	,TamSx3("E1_VALOR"  )[1],2	,""	,""	,""	})
Aadd(_aCampoQry, {"E1_TXMOEDA"    , "TAXA_MOEDA"	     ,"TAXA_MOEDA"	   	   ,"N"	,TamSx3("E1_TXMOEDA")[1],4	,""	,""	,""	})
Aadd(_aCampoQry, {"E1_SALDO"      , "SALDO"	             ,"SALDO"	           ,"N"	,TamSx3("E1_SALDO"  )[1],2	,""	,""	,""	})
Aadd(_aCampoQry, {"E1_MOEDA"      , "MOEDA"              ,"MOEDA"              ,"N"	,TamSx3("E1_MOEDA"  )[1],0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEM_TXTB"       , "TX_EMIS_NF"	     ,"TX_EMIS_NF"	   	   ,"N"	,TamSx3("EEM_TXTB"  )[1],7	,""	,""	,""	})
Aadd(_aCampoQry, {"E1_TIPO"	      , "TIPO"          	 ,"TIPO"          	   ,"C"	,TamSx3("E1_TIPO"	)[1],0	,""	,""	,""	})
Aadd(_aCampoQry, {"E1_NATUREZ"    , "COD_NATUREZA"	     ,"COD_NATUREZA"	   ,"C"	,TamSx3("E1_NATUREZ")[1],0	,""	,""	,""	})
Aadd(_aCampoQry, {"STATUS_TITULO" , "STATUS_TITULO"	     ,"STATUS_TITULO"	   ,"C"	,040	,0	,""	,""	,""	})


aAdd(_aParambox,{1,"Data Emissao Inicial"   ,Ctod("")						,""		,""												,""		,"",050,.T.})
aAdd(_aParambox,{1,"Data Emissao Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02	,'Data')" 		,""		,"",050,.T.})
		
If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
If Empty(_aSelFil) ; Return ; Endif
_cCODFILIA	:= U_Array_In(_aSelFil)

//===		S E L E C I O N A 	   C O D I G O   D A   N A T U R E Z A
cQuery	:= "SELECT Distinct E1_NATUREZ "
cQuery 	+= "  FROM  "+ RetSqlName("SE1") 
cQuery	+= "  WHERE E1_NATUREZ <> ' ' " 
cQuery	+= "    AND D_E_L_E_T_ = ' '  "
cQuery	+= "  ORDER BY E1_NATUREZ  "
aCampos	:=	{	{ "E1_NATUREZ"		,U_X3Titulo("E1_NATUREZ")		,TamSx3("E1_NATUREZ")[1]	}}
					
nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: ZQ_COD
_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
cNatureza	:= U_Array_In( U_MarkGene(cQuery, aCampos, "Selecao das Naturezas: ", nPosRetorn, @_lCancProg ) )
If _lCancProg
	Return
Endif
//===		S E L E C I O N A  T I P O  D O  T I T U L O
cQuery	:= "SELECT DISTINCT  E1_TIPO  "
cQuery 	+= "  FROM "+RetSqlName("SE1")  
cQuery	+= "  WHERE D_E_L_E_T_ = ' '  "
cQuery	+= "  ORDER BY E1_TIPO  "
aCampos	:=	{	{ "E1_TIPO"		,U_X3Titulo("E1_TIPO")		,TamSx3("E1_TIPO")[1]	}}
					
nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: ZQ_COD
_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
cTipo	:= U_Array_In( U_MarkGene(cQuery, aCampos, "Selecao dos tipo de documentos: ", nPosRetorn, @_lCancProg ) )
If _lCancProg
	Return
Endif
                    
cEnviroSrv	:= AllTrim(UPPER(GETENVSERVER()))
IF cEnviroSrv == 'PRODUCAO'                  
    _cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CR_RECEBIVEIS_ME"  )         + CRLF
Else
    _cQuery += "  FROM V_CR_RECEBIVEIS_ME" + CRLF
EndIF
_cQuery += U_WhereAnd(!empty(_cCODFILIA ),     " FILIAL IN "               + _cCODFILIA                             	 ) +CRLF //OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
_cQuery += U_WhereAnd(!empty(_aRet[2] ),       " DT_EMISSAO_FILTRO BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' " 	 ) +CRLF //NAO OBRIGATORIO
_cQuery += U_WhereAnd(!empty(cNatureza ),      " COD_NATUREZA IN " + cNatureza		+ " "								 ) +CRLF 
_cQuery += U_WhereAnd(!empty(cTipo     ),      " TIPO IN " + cTipo		+ " "								 ) +CRLF 


MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN

