#include "totvs.ch"   

/*
=====================================================================================
Programa.:              MGF29R35
Autor....:              Marcelo Carneiro
Data.....:              08/10/2019
Descricao / Objetivo:   Relatorio BI Orcamento Aprovado - Exportacao
Doc. Origem:            RTASK0010177 Chamado RITM0029817
Uso......:              
Obs......:              View : V_EX_ORCAMENTO
=====================================================================================
*/
User Function MGF29R35()

Local _aCpoExce	 := {}
Local _cTmp01	 := ""
Local cEnviroSrv := ''


Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery

Private _aEmailQry , _cWhereAnd
_aEmailQry	:= {}  ; _cWhereAnd	:= ""

Aadd(_aDefinePl, "Orcamento Aprovado"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
Aadd(_aDefinePl, "Orcamento Aprovado"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
Aadd(_aDefinePl, {"Orcamento Aprovado"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
Aadd(_aDefinePl, {"Orcamento Aprovado"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
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
Aadd(_aCampoQry, {"ZZC_ORCAME"        , "ZZC_ORCAME"		 ,"NUM_PV"		       ,"C"	,TamSx3("ZZC_ORCAME")[1]	 ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"NOME_TRADING"      , "NOME_TRADING" 	     ,"TRADING"	           ,"C"	,TamSx3("A1_NOME")[1]    ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"NOME_BUYER"        , "NOME_BUYER"    	 ,"BUYER"    	   	   ,"C"	,TamSx3("A1_NOME")[1]    ,0 ,""	,""	,""	})
Aadd(_aCampoQry, {"NOME_CLIENTE_FINAL", "NOME_CLIENTE_FINAL" ,"CLIENTE_FINAL"	   ,"C"	,TamSx3("A1_NOME"    )[1],0	,""	,""	,""	})
Aadd(_aCampoQry, {"NOME_CONSIGNEE"    , "NOME_CONSIGNEE"	 ,"CONSIGNEE"	   	   ,"C"	,TamSx3("A1_NOME")[1]    ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"PAIS_DESTINO"      , "PAIS_DESTINO"	     ,"PAIS_DESTINO"	   ,"C"	,TamSx3("YA_NOIDIOM" )[1],0	,""	,""	,""	})
Aadd(_aCampoQry, {"PYMT_TERMS"        , "PYMT_TERMS"	     ,"PYMT_TERMS"	   	   ,"C"	,TamSx3("YP_TEXTO")[1]   ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"SALES_TERMS"       , "SALES_TERMS"	     ,"SALES_TERMS"        ,"C"	,TamSx3("ZZC_INCO2")[1]  ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"TIPO_PGTO_FRETE"   , "TIPO_PGTO_FRETE"	 ,"TIPO_FRETE"	       ,"C"	,20                      ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"BOOKING"           , "BOOKING"	         ,"BOOKING_FEITO_POR"  ,"C"	,20                      ,0 ,""	,""	,""	})
Aadd(_aCampoQry, {"FAMILIA_PRODUTO"   , "FAMILIA_PRODUTO"	 ,"FAMILIA"	   	       ,"C"	,TamSx3("EEH_NOME")[1]   ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"TIPO_PRODUTO"      , "TIPO_PRODUTO"	     ,"TIPO_PRODUTO"	   ,"C"	,TamSx3("YC_NOME"  )[1]  ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"ZZC_ZTEMPE"        , "ZZC_ZTEMPE"         ,"TEMPERATURA"        ,"C"	,TamSx3("ZZC_ZTEMPE")[1] ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EYG_DESCON"        , "EYG_DESCON"	     ,"TIPO_CONTAINER"	   ,"C"	,TamSx3("EYG_DESCON")[1] ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"TIPO_TRANSPORTE"	  , "TIPO_TRANSPORTE"  	 ,"MODAL"          	   ,"C"	,TamSx3("YQ_DESCR"	)[1] ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"FLG_HILTON"        , "FLG_HILTON"	     ,"HILTON_NAO_HILTON"  ,"C"	,03                      ,0	,""	,""	,""	})


aAdd(_aParambox,{1,"Orcamento"		,Space(TamSx3("ZZC_ORCAME")[1])				,""		,,""		,"",050,.F.})
aAdd(_aParambox,{1,"Data Emissao Inicial"   ,Ctod("")						,""		,""												,""		,"",050,.F.})
aAdd(_aParambox,{1,"Data Emissao Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR02, MV_PAR03	,'Data')" 		,""		,"",050,.F.})
		
If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

cEnviroSrv	:= AllTrim(UPPER(GETENVSERVER()))
IF cEnviroSrv == 'PRODUCAO'                  
    _cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_EX_ORCAMENTO"  )         + CRLF
Else
    _cQuery += "  FROM V_EX_ORCAMENTO" + CRLF
EndIF

_cQuery += U_WhereAnd(!empty(_aRet[1]), " ZZC_ORCAME Like '%"+_aRet[1]+"%'") +CRLF //OBRIGATORIO (SELE��O DO COMBO)  CAMPO FILIAL(06 posicoes)
_cQuery += U_WhereAnd(!empty(_aRet[3] )," DATA_PV BETWEEN '" + _aRet[2] + "' AND '" + _aRet[3] + "' " 	 ) +CRLF //NAO OBRIGATORIO


MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN

