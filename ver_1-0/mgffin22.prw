#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "DIALOG.CH"
#INCLUDE "FONT.CH" 

/*
=====================================================================================
Programa.:              MGFFIN22 - PE
Autor....:              Antonio Carlos        
Data.....:              03/10/2016
Descricao / Objetivo:   incluir informacoes de Credito da Rede
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              
Obs......:              incluir informacoes de Credito da Rede na Consulta 1a.Tela
=====================================================================================
*/
User Function MGFFIN22()
	Local aArea       := GetArea()
	Local MGF_MAXAC   := GetMV("MGF_MAXAC")  //SuperGetMV("MGF_MAXAC","20150101")
	Local cQuery      := ""
	Local cAliasQry   := ""
	LOCAL _cCodRede   := SA1->A1_ZREDE
	Local nTOTVS1 := 0
	Local nTOTVS2 := 0
	Local nTOTVS3 := 0 
	Local cRaizCNPJ := Subs(SA1->A1_CGC,1,8)
	Local cQ := ""
	Local cAliasVSA1	:= GetNextAlias()
	
	BeginSql Alias cAliasVSA1
		SELECT VSA1.*
		  FROM V_LIMITES_CLIENTE VSA1
		 WHERE VSA1.RECNO_CLIENTE = %Exp:SA1->(Recno())%
	EndSql
	
	If mv_par18 == 1
		If (Empty(SA1->A1_CGC) .and. Empty(SA1->A1_ZREDE))
			APMsgStop("Consulta por Rede nao podera ser efetuada, pois cliente pertence a situacao abaixo:"+CRLF+;
			"- CNPJ em branco e Rede em branco "+CRLF+;
			CRLF+;
			"A consulta ira prosseguir sem tratar o conceito de 'Rede'.")

			mv_par18 := 2  // forca rede = Nao
			Return(aCols)
		Endif
	Endif		

	cAliasQry := GetNextAlias()

	cQ := QueryRede(_cCodRede,cRaizCNPJ,SA1->A1_EST)

	IF MV_PAR18 = 1  //Rede
		cQuery := "SELECT A1.A1_ZREDE, MAX(F2.F2_VALMERC) MAIVENDA, SUM(F2.F2_VALMERC) MAIORAC" +Chr(10)  
		cQuery += "  FROM "+RetSqlName("SA1")+" A1 " +Chr(10)   
		cQuery += "  INNER JOIN "+RetSqlName("SF2")+" F2 " +Chr(10)    
		cQuery += " ON F2_CLIENTE = A1_COD  " +Chr(10) 
		cQuery += "   AND F2_LOJA = A1_LOJA " +Chr(10)
		cQuery += "   AND F2.D_E_L_E_T_=' ' " +Chr(10)
		cQuery += " WHERE " +Chr(10)
		cQuery += "   A1.D_E_L_E_T_=' ' " +Chr(10) 
		//cQuery += "   AND (A1.A1_ZREDE = '"+ _cCodRede +"' " +CHR(10)
		//cQuery += "   OR SUBSTR(A1_CGC,1,8) = '"+cRaizCNPJ+"') " +CHR(10)		
		cQuery += cQ
		cQuery += "   AND F2.F2_EMISSAO >= '" + DTOS(MGF_MAXAC) +"'"+Chr(10)
		cQuery += " GROUP BY A1.A1_ZREDE " +Chr(10)
	ELSE
		cQuery := "SELECT A1.A1_COD, A1.A1_LOJA, A1.A1_ZREDE, MAX(F2.F2_VALMERC) MAIVENDA, SUM(F2.F2_VALMERC) MAIORAC" +Chr(10)  
		cQuery += "  FROM "+RetSqlName("SA1")+" A1 " +Chr(10)   
		cQuery += "  INNER JOIN "+RetSqlName("SF2")+" F2 " +Chr(10)    
		cQuery += " ON F2_CLIENTE = A1_COD  " +Chr(10) 
		cQuery += "   AND F2_LOJA = A1_LOJA " +Chr(10)
		cQuery += "   AND F2.D_E_L_E_T_=' ' " +Chr(10)
		cQuery += " WHERE " +Chr(10)
		cQuery += "   A1.A1_COD = '"+ SA1->A1_COD +"'" +Chr(10)
		cQuery += "   AND A1.A1_LOJA = '"+ SA1->A1_LOJA +"'" +Chr(10)
		cQuery += "   AND A1.D_E_L_E_T_=' ' " +Chr(10) 
		cQuery += "   AND F2.F2_EMISSAO >= '" + DTOS(MGF_MAXAC) +"'"+Chr(10)
		cQuery += " GROUP BY A1.A1_COD, A1.A1_LOJA, A1.A1_ZREDE " +Chr(10)
	ENDIF
	cQuery := ChangeQuery( cQuery )
	//MemoWrite("CRE007.SQL",cQuery) 
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F., .T. )

	Do While !(cAliasQry)->( Eof() )

		nTOTVS2 := (cAliasQry)->MAIVENDA  
		nTOTVS3 := (cAliasQry)->MAIORAC

		Aadd(aCols,{"Maior Venda",;
		TRansform(nTOTVS2,PesqPict("SA1","A1_MSALDO",14,2)),;
		TRansform(Round(Noround(xMoeda(nTOTVS2, 1,2, dDataBase,MsDecimais(1)+1 ),2),MsDecimais(1)),PesqPict("SA1","A1_MSALDO",14,1)),;
		" ","Maior AC",TRansform(nTOTVS3,PesqPict("SA1","A1_MSALDO",14,2)),;
		})                                                                                      

		(cAliasQry)->( DbSkip() )

	EndDo

	//Fecha o Arquivo do usuario
	DbSelectArea(cAliasQry)
	DbCloseArea()
	Ferase( cAliasQry )

	IF MV_PAR18 = 1  //Rede
		/*cQuery := "SELECT A1.A1_ZREDE, SUM(A1.A1_LC) A1_LC" +Chr(10)  
		cQuery += "  FROM "+RetSqlName("SA1")+" A1 " +Chr(10)   
		cQuery += " WHERE " +Chr(10)
		cQuery += "   A1.A1_FILIAL = '"+ xFilial("SA1") +"'" +CHR(10)
		//cQuery += "   AND (A1.A1_ZREDE = '"+ _cCodRede +"' " +CHR(10)
		//cQuery += "   OR SUBSTR(A1_CGC,1,8) = '"+cRaizCNPJ+"') " +CHR(10)				
		cQuery += cQ
		cQuery += "   AND A1.D_E_L_E_T_=' ' " +Chr(10) 
		cQuery += " GROUP BY A1.A1_ZREDE " +Chr(10)
		
		cQuery := "*/
/*		
		
		If !Empty(_cCodRede)
			cQuery := " SELECT A1.A1_ZREDE,SUM(A1.A1_LC) A1_LC " + CHR(10) 
			cQuery += " FROM "+RetSqlName("SA1")+" A1 " +CHR(10)  
			cQuery += " WHERE  A1.A1_FILIAL = '"+ xFilial("SA1") +"'" +CHR(10) 
			cQuery += " AND A1_ZREDE = '" +  _cCodRede  + "' " + CHR(10) 
			cQuery += " AND A1_MSBLQL = '2'" + CHR(10)  
			cQuery += " AND A1.D_E_L_E_T_=' ' " + CHR(10) 
			cQuery += " GROUP BY A1.A1_ZREDE " + CHR(10) 
			
			cQuery += " UNION ALL " + CHR(10) 
			
			cQuery += " SELECT A1.A1_ZREDE,SUM(A1.A1_LC) A1_LC " + CHR(10)  
			cQuery += " FROM "+RetSqlName("SA1")+" A1 " + CHR(10)  
			cQuery += " WHERE  A1.A1_FILIAL = '"+ xFilial("SA1") +"'" + CHR(10) 
			cQuery += " AND A1_ZREDE <> '" +  _cCodRede  + "'" + CHR(10) 
			cQuery += " AND SUBSTR(A1_CGC,1,8) = '" + cRaizCNPJ + "'" + CHR(10) 
			cQuery += " AND A1_MSBLQL = '2'" + CHR(10)  
			cQuery += " AND A1.D_E_L_E_T_=' '" + CHR(10)  
			cQuery += " GROUP BY A1.A1_ZREDE "
		Else
		
			cQuery := " SELECT A1.A1_ZREDE,SUM(A1.A1_LC) A1_LC " + CHR(10)  
			cQuery += " FROM "+RetSqlName("SA1")+" A1 " + CHR(10)  
			cQuery += " WHERE  A1.A1_FILIAL = '"+ xFilial("SA1") +"'" + CHR(10) 
			cQuery += " AND SUBSTR(A1_CGC,1,8) = '" + cRaizCNPJ + "'" + CHR(10) 
			cQuery += " AND A1.D_E_L_E_T_=' '" + CHR(10)  
			cQuery += " GROUP BY A1.A1_ZREDE "
		
		EndIf
		
		cQuery := ChangeQuery( cQuery )

		//MemoWrite("CRE007_1.SQL",cQuery) 
		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F., .T. )

		Do While !(cAliasQry)->( Eof() )


			Aadd(aCols,{"LC Rede",;
			TRansform((cAliasQry)->A1_LC,PesqPict("SA1","A1_LC",14,2)),;
			" ",;
			" ","Pedido Rede"," ",;
			})                                                                                      

			(cAliasQry)->( DbSkip() )

		EndDo
		//Fecha o Arquivo do usuario
		DbSelectArea(cAliasQry)
		DbCloseArea()
		Ferase( cAliasQry )
*/		
			Aadd(aCols,{"LC Rede",;
			TRansform((cAliasVSA1)->limite_credito,PesqPict("SA1","A1_LC",14,2)),;
			" ",;
			" ","Pedido Rede"," ",;
			})                                                                                      

/*
		cQuery := "SELECT SUM(C6_VALOR) VALOR           "+CRLF
		cQuery += "FROM "+RetSqlName("SC6")+" SC6       "+CRLF
		cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 "+CRLF
		cQuery += "ON SA1.D_E_L_E_T_ = ' ' AND          "+CRLF
		cQuery += "	SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "+CRLF
		cQuery += "	SA1.A1_COD = SC6.C6_CLI AND         "+CRLF
		cQuery += "	SA1.A1_LOJA = SC6.C6_LOJA           "+CRLF
		cQuery += "INNER JOIN "+RetSqlName("SC5")+" SC5 "+CRLF
		cQuery += "ON SC5.D_E_L_E_T_ = ' ' AND          "+CRLF
		cQuery += "	SC5.C5_FILIAL = SC6.C6_FILIAL AND   "+CRLF
		cQuery += "	SC5.C5_NUM = SC6.C6_NUM             "+CRLF
		cQuery += "WHERE                                "+CRLF
		cQuery += "	SC6.D_E_L_E_T_ = ' ' AND            "+CRLF
		cQuery += "	SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND "+CRLF
		cQuery += "	SC5.C5_ZBLQRGA NOT IN ('L','B') "+CRLF
		//cQuery += "	AND (SA1.A1_ZREDE = '"+ _cCodRede +"' 	"+CRLF
		//cQuery += " OR SUBSTR(A1_CGC,1,8) = '"+cRaizCNPJ+"') " +CHR(10)		
		cQuery += cQ
		cQuery += "	AND SC5.C5_NOTA = ' '                   "+CRLF
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasQry,.T.,.T.)

		dbSelectArea(cAliasQry)
		dBGotop()
		If !(cAliasQry)->( Eof() )
			aCols[Len(aCols)][6] := TRansform((cAliasQry)->VALOR,PesqPict("SC6","C6_VALOR",14,2))
		EndIf

		//Fecha o Arquivo do usuario
		DbSelectArea(cAliasQry)
		DbCloseArea()
		Ferase( cAliasQry )
*/
		aCols[Len(aCols)][6] := TRansform((cAliasVSA1)->total_pedidos,PesqPict("SC6","C6_VALOR",14,2))
/*
		cQuery := "SELECT SUM(E1_SALDO) SALDO " +CHR(10)
		cQuery += "FROM " + RetSqlName("SE1") + " SE1, " + RetSqlName("SA1") + " SA1 " +CHR(10)
		cQuery += "WHERE " +CHR(10) 
		cQuery += "SE1.E1_FILIAL  = '" + xFilial('SE1') + "' " +CHR(10)
		cQuery += "AND SE1.E1_EMISSAO>='"+DTOS(MV_PAR01)+"' " +CHR(10)
		cQuery += "AND SE1.E1_EMISSAO<='"+DTOS(MV_PAR02)+"' " +CHR(10)
		cQuery += "AND SE1.E1_VENCREA>='"+DTOS(MV_PAR03)+"' " +CHR(10)
		cQuery += "AND SE1.E1_VENCREA<='"+DTOS(DATE())+"' " +CHR(10)
		cQuery += "AND SE1.E1_TIPO <> 'RA ' " +CHR(10)
		cQuery += "AND SE1.E1_PREFIXO>='"+MV_PAR06+"' " +CHR(10)
		cQuery += "AND SE1.E1_PREFIXO<='"+MV_PAR07+"' " +CHR(10)
		cQuery += "AND SE1.E1_SALDO > 0 " +CHR(10)
		cQuery += "AND SE1.D_E_L_E_T_<>'*' " +CHR(10)
		cQuery += "AND SE1.E1_TIPO NOT LIKE '__-' " +CHR(10) 
		//cQuery += "AND (SA1.A1_ZREDE   = '"+ _cCodRede +"' " +CHR(10)
		//cQuery += "OR SUBSTR(A1_CGC,1,8) = '"+cRaizCNPJ+"') " +CHR(10)		
		cQuery += cQ
		cQuery += "AND SA1.A1_FILIAL  = '" + xFilial('SA1') + "' " +CHR(10)          
		cQuery += "AND SE1.E1_LOJA	= SA1.A1_LOJA " +CHR(10)
		cQuery += "AND SE1.E1_CLIENTE =  SA1.A1_COD " +CHR(10) 
		cQuery += "AND SA1.D_E_L_E_T_<>'*' " +CHR(10)

		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasQry,.T.,.T.)

		dbSelectArea(cAliasQry)
		dBGotop()
		If !(cAliasQry)->( Eof() )
			Aadd(aCols,{"Vencidos Rede",;
			TRansform((cAliasQry)->SALDO,PesqPict("SE1","E1_SALDO",14,2)),;
			" ",;
			" ","A Vencer Rede"," ",;
			}) 
		EndIf

		//Fecha o Arquivo do usuario
		DbSelectArea(cAliasQry)
		DbCloseArea()
		Ferase( cAliasQry )
*/
		Aadd(aCols,{"Vencidos Rede",;
		TRansform((cAliasVSA1)->titulos_atrasados,PesqPict("SE1","E1_SALDO",14,2)),;
		" ",;
		" ","A Vencer Rede"," ",;
		}) 
/*
		cQuery := "SELECT SUM(E1_SALDO) SALDO " +CHR(10)
		cQuery += "FROM " + RetSqlName("SE1") + " SE1, " + RetSqlName("SA1") + " SA1 " +CHR(10)
		cQuery += "WHERE " +CHR(10) 
		cQuery += "SE1.E1_FILIAL  = '" + xFilial('SE1') + "' " +CHR(10)
		cQuery += "AND SE1.E1_EMISSAO>='"+DTOS(MV_PAR01)+"' " +CHR(10)
		cQuery += "AND SE1.E1_EMISSAO<='"+DTOS(MV_PAR02)+"' " +CHR(10)
		cQuery += "AND SE1.E1_VENCREA>'"+DTOS(DATE())+"' " +CHR(10)
		cQuery += "AND SE1.E1_VENCREA<='"+DTOS(MV_PAR04)+"' " +CHR(10)
		cQuery += "AND SE1.E1_TIPO <> 'RA ' " +CHR(10)
		cQuery += "AND SE1.E1_PREFIXO>='"+MV_PAR06+"' " +CHR(10)
		cQuery += "AND SE1.E1_PREFIXO<='"+MV_PAR07+"' " +CHR(10)
		cQuery += "AND SE1.E1_SALDO > 0 " +CHR(10)
		cQuery += "AND SE1.D_E_L_E_T_<>'*' " +CHR(10)
		cQuery += "AND SE1.E1_TIPO NOT LIKE '__-' " +CHR(10) 
		//cQuery += "AND (SA1.A1_ZREDE   = '"+ _cCodRede +"' " +CHR(10)
		//cQuery += "OR SUBSTR(A1_CGC,1,8) = '"+cRaizCNPJ+"') " +CHR(10)		
		cQuery += cQ
		cQuery += "AND SA1.A1_FILIAL  = '" + xFilial('SA1') + "' " +CHR(10)          
		cQuery += "AND SE1.E1_LOJA	= SA1.A1_LOJA " +CHR(10)
		cQuery += "AND SE1.E1_CLIENTE =  SA1.A1_COD " +CHR(10) 
		cQuery += "AND SA1.D_E_L_E_T_<>'*' " +CHR(10)
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasQry,.T.,.T.)

		dbSelectArea(cAliasQry)
		dBGotop()
		If !(cAliasQry)->( Eof() )
			aCols[Len(aCols)][6] := TRansform((cAliasQry)->SALDO,PesqPict("SE1","E1_SALDO",14,2))
		EndIf

		//Fecha o Arquivo do usuario
		DbSelectArea(cAliasQry)
		DbCloseArea()
		Ferase( cAliasQry )
*/
		aCols[Len(aCols)][6] := TRansform((cAliasVSA1)->titulos_abertos,PesqPict("SE1","E1_SALDO",14,2))

		cQuery := "SELECT SUM(F2_VALMERC) VALOR     "+CRLF
		cQuery += "FROM "+RetSqlName("SF2")+" SF2   "+CRLF
		cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 "+CRLF
		cQuery += "ON SA1.D_E_L_E_T_ = ' ' AND      "+CRLF
		cQuery += "	SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "+CRLF
		cQuery += "	SA1.A1_COD = SF2.F2_CLIENTE AND "+CRLF
		cQuery += "	SA1.A1_LOJA = SF2.F2_LOJA       "+CRLF
		cQuery += "WHERE                            "+CRLF
		cQuery += "	SF2.D_E_L_E_T_ = ' '         "+CRLF
		//cQuery += "	SF2.F2_FILIAL = '"+xFilial("SF2")+"' "+CRLF
		//cQuery += "	AND (SA1.A1_ZREDE = '"+_cCodRede+"' " +CHR(10)
		//cQuery += " OR SUBSTR(A1_CGC,1,8) = '"+cRaizCNPJ+"') " +CHR(10)		
		cQuery += cQ

		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasQry,.T.,.T.)

		dbSelectArea(cAliasQry)
		dBGotop()
		If !(cAliasQry)->( Eof() )
			Aadd(aCols,{"Vlr.Faturado Rede",;
			TRansform((cAliasQry)->VALOR,PesqPict("SF2","F2_VALMERC",14,2)),;
			" ",;
			" ","Saldo RA"," ",;
			}) 
		EndIf

		//Fecha o Arquivo do usuario
		DbSelectArea(cAliasQry)
		DbCloseArea()
		Ferase( cAliasQry )

	ENDIF

	If MV_PAR15 == 1 //Considera RA
		//GAP CRE028 FASE 4 -> Saldo de adiantamento Posicao de Cliente
		cQuery := "SELECT SUM(E1_SALDO) SALDO " +CHR(10)
		cQuery += "FROM " + RetSqlName("SE1") + " SE1, " + RetSqlName("SA1") + " SA1 " +CHR(10)
		cQuery += "WHERE " +CHR(10) 
		nPosAlias := FC010QFil(1,"SE1")
		cQuery += "SE1.E1_FILIAL " + aTmpFil[nPosAlias,2] + CHR(10)
		//cQuery += "SE1.E1_FILIAL  = '" + xFilial('SE1') + "' " +CHR(10)
		cQuery += "AND SE1.E1_EMISSAO>='"+DTOS(MV_PAR01)+"' " +CHR(10)
		cQuery += "AND SE1.E1_EMISSAO<='"+DTOS(MV_PAR02)+"' " +CHR(10)
		cQuery += "AND SE1.E1_VENCREA BETWEEN '"+DTOS(MV_PAR03)+"' " +CHR(10)
		cQuery += "AND '"+DTOS(MV_PAR04)+"' " +CHR(10)
		cQuery += "AND SE1.E1_TIPO = 'RA ' " +CHR(10)
		cQuery += "AND SE1.E1_PREFIXO>='"+MV_PAR06+"' " +CHR(10)
		cQuery += "AND SE1.E1_PREFIXO<='"+MV_PAR07+"' " +CHR(10)
		cQuery += "AND SE1.E1_SALDO > 0 " +CHR(10)
		cQuery += "AND SE1.D_E_L_E_T_<>'*' " +CHR(10)
		cQuery += "AND SE1.E1_TIPO NOT LIKE '__-' " +CHR(10) 
		//cQuery += "AND (SA1.A1_ZREDE   = '"+ _cCodRede +"' " +CHR(10)
		//cQuery += "OR SUBSTR(A1_CGC,1,8) = '"+cRaizCNPJ+"') " +CHR(10)		
		//cQuery += cQ
		cQuery += "AND SA1.A1_FILIAL  = '" + xFilial('SA1') + "' " +CHR(10)          
		cQuery += "AND SE1.E1_LOJA	= SA1.A1_LOJA " +CHR(10)
		cQuery += "AND SE1.E1_CLIENTE =  SA1.A1_COD " +CHR(10) 
		cQuery += "AND SE1.E1_CLIENTE = '"+SA1->A1_COD+"' " +CHR(10) 
//		cQuery += "AND SE1.E1_LOJA = '"+SA1->A1_LOJA+"' " +CHR(10) 
		cQuery += "AND SA1.D_E_L_E_T_<>'*' " +CHR(10)

		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasQry,.T.,.T.)

		dbSelectArea(cAliasQry)
		dBGotop()
		If !(cAliasQry)->( Eof() )
//			Aadd(aCols,{"Saldo RA",;
//			TRansform((cAliasQry)->SALDO,PesqPict("SE1","E1_SALDO",14,2)),;
//			" ",;
//			" "," "," ",;
//			}) 
			aCols[Len(aCols)][6] := TRansform((cAliasQry)->SALDO,PesqPict("SE1","E1_SALDO",14,2))
		EndIf

		//Fecha o Arquivo do usuario
		DbSelectArea(cAliasQry)
		DbCloseArea()
		Ferase( cAliasQry )

		If mv_par18 == 1 //Considera rede de clientes
/*			
			//GAP CRE028 FASE 4 -> Saldo de adiantamento Posicao de Cliente POR REDE
			cQuery := "SELECT SUM(E1_SALDO) SALDO " +CHR(10)
			cQuery += "FROM " + RetSqlName("SE1") + " SE1, " + RetSqlName("SA1") + " SA1 " +CHR(10)
			cQuery += "WHERE " +CHR(10) 
			nPosAlias := FC010QFil(1,"SE1")
			cQuery += "SE1.E1_FILIAL " + aTmpFil[nPosAlias,2] + CHR(10)
			//cQuery += "SE1.E1_FILIAL = '" + xFilial('SE1') + "' " +CHR(10)
			cQuery += "AND SE1.E1_EMISSAO>='"+DTOS(MV_PAR01)+"' " +CHR(10)
			cQuery += "AND SE1.E1_EMISSAO<='"+DTOS(MV_PAR02)+"' " +CHR(10)
			cQuery += "AND SE1.E1_VENCREA BETWEEN '"+DTOS(MV_PAR03)+"' " +CHR(10)
			cQuery += "AND '"+DTOS(MV_PAR04)+"' " +CHR(10)
			cQuery += "AND SE1.E1_TIPO = 'RA ' " +CHR(10)
			cQuery += "AND SE1.E1_PREFIXO>='"+MV_PAR06+"' " +CHR(10)
			cQuery += "AND SE1.E1_PREFIXO<='"+MV_PAR07+"' " +CHR(10)
			cQuery += "AND SE1.E1_SALDO > 0 " +CHR(10)
			cQuery += "AND SE1.D_E_L_E_T_<>'*' " +CHR(10)
			cQuery += "AND SE1.E1_TIPO NOT LIKE '__-' " +CHR(10) 
			//cQuery += "AND (SA1.A1_ZREDE   = '"+ _cCodRede +"' " +CHR(10)
			//cQuery += "OR SUBSTR(A1_CGC,1,8) = '"+cRaizCNPJ+"') " +CHR(10)		
			//cQuery += cQ
			cQuery += "AND SA1.A1_FILIAL  = '" + xFilial('SA1') + "' " +CHR(10)          
			cQuery += "AND SE1.E1_LOJA	= SA1.A1_LOJA " +CHR(10)
			cQuery += "AND SE1.E1_CLIENTE =  SA1.A1_COD " +CHR(10) 
			cQuery += "AND (SA1.A1_ZREDE = '"+_cCodRede+"' AND SA1.A1_ZREDE <> ' ') " +CHR(10) 
			cQuery += "AND SA1.D_E_L_E_T_<>'*' " +CHR(10)
			
			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasQry,.T.,.T.)

			dbSelectArea(cAliasQry)
			dBGotop()
			If !(cAliasQry)->( Eof() )
				Aadd(aCols,{"Saldo RA Rede",;
				TRansform((cAliasQry)->SALDO,PesqPict("SE1","E1_SALDO",14,2)),;
				" ",;
				" "," "," ",;
				}) 
			EndIf

			//Fecha o Arquivo do usuario
			DbSelectArea(cAliasQry)
			DbCloseArea()
			Ferase( cAliasQry )
*/
			Aadd(aCols,{"Saldo RA Rede",;
			TRansform((cAliasVSA1)->saldo_ra,PesqPict("SE1","E1_SALDO",14,2)),;
			" ",;
			" ","LC Disp. Rede"," ",;
			}) 

			aCols[Len(aCols)][6] := TRansform((cAliasVSA1)->limite_disponivel,PesqPict("SA1","A1_LC",14,2))
		Endif
	Endif
/*
	Aadd(aCols,{"LC Dispon�vel",;
		TRansform((cAliasVSA1)->limite_disponivel,PesqPict("SA1","A1_LC",14,2)),;
		" ",;
		" ",""," ",;
		})                                                                                      
*/
	If Select(cAliasVSA1) > 0
		(cAliasVSA1)->(dbCloseArea())
	Endif
	
Return(aCols) 


Static Function QueryRede(cCodRede,cRaizCNPJ,cEst)

	Local cQ := ""

	If cEst == "EX"
		cQ := " AND A1_ZREDE = '"+cCodRede+"' "+CHR(10) // exportacao soh trata pela rede, pois o CNPJ nao eh mandatorio
	Elseif !Empty(cCodRede) .and. !Empty(cRaizCNPJ)
//		cQ := " AND (A1_ZREDE = '"+cCodRede+"' OR SUBSTR(A1_CGC,1,9) = '"+cRaizCNPJ+"') "+CHR(10)		
		cQ := " AND SUBSTR(A1_CGC,1,8) = '"+cRaizCNPJ+"' "+CHR(10)		// for�a rede ser somente pela raiz do CNPJ		
	Elseif !Empty(cCodRede) .and. Empty(cRaizCNPJ)
		cQ := " AND A1_ZREDE = '"+cCodRede+"' "+CHR(10)		
	Elseif Empty(cCodRede) .and. !Empty(cRaizCNPJ)
		cQ := " AND SUBSTR(A1_CGC,1,8) = '"+cRaizCNPJ+"' "+CHR(10)		
	Elseif Empty(cCodRede) .and. Empty(cRaizCNPJ)
		cQ := " "+CHR(10)
		mv_par18 := 2  // forca rede = Nao		
	Endif

Return(cQ)	




