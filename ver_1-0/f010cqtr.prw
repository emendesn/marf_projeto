#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"   

/*
=====================================================================================
Programa.:              F010CQTR - PE
Autor....:              Antonio Carlos        
Data.....:              03/10/2016                                                                                                            
Descricao / Objetivo:   incluir informacoes de Titulos Recebidos por Rede 
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              
Obs......:              Titulos Recebidos por Rede na Posicao do Cliente
=====================================================================================
*/
User Function  F010CQTR()
	LOCAL cQueryori := PARAMIXB[1]

	If findfunction("U_MGFFIN32")
		cQuery := U_MGFFIN32(cQueryori)
	Endif

	/*   IF MsgNoYes("Titulos Recebidos por Rede ?") 
	cQuery := "SELECT E1_FILORIG,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_NFELETR,E1_MOEDA,E1_EMISSAO,E1_VENCTO,E1_VENCREA,E5_DATA,E5_DTDISPO,E1_VALOR,E1_VLCRUZ, " +CHR(10)
	cQuery += "E5_VLJUROS,E5_VLMULTA,E5_VLCORRE,E5_VLDESCO,E5_VALOR,E5_VLMOED2,E5_TXMOEDA,E1_NATUREZ,E1_NUMLIQ,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_HISTOR,E5_MOTBX, " +CHR(10)
	cQuery += "E5_CNABOC,E5_TIPODOC,E1_VALJUR,E1_MULTA,E1_TXMOEDA,E1_ORIGEM,SE5.R_E_C_N_O_ SE5RECNO , SE5.E5_DOCUMEN E5_DOCUMEN " +CHR(10)
	cQuery += "FROM " + RetSqlName("SE1") + " SE1, " + RetSqlName("SE5") + " SE5, " + RetSqlName("SA1") + " SA1 " +CHR(10)
	cQuery += "WHERE SA1.A1_LOJA = SE1.E1_LOJA AND SA1.A1_COD = SE1.E1_CLIENTE " +CHR(10)
	cQuery += "AND SE1.E1_FILIAL  = '" + xFilial("SE1") + "' AND SA1.A1_ZREDE = '" + _cCodRede + "'    --AND SE1.E1_CLIENTE='000001' AND SE1.E1_LOJA='01'  " +CHR(10)
	cQuery += "AND SE1.E1_EMISSAO>='"+DTOS(MV_PAR01)+"' AND SE1.E1_EMISSAO<='"+DTOS(MV_PAR02)+"'  " +CHR(10)
	cQuery += "AND SE1.E1_VENCREA>='"+DTOS(MV_PAR01)+"' AND SE1.E1_VENCREA<='"+DTOS(MV_PAR01)+"'  " +CHR(10)
	cQuery += "AND SE1.E1_TIPO<>'RA ' AND SE1.E1_PREFIXO>='"+MV_PAR06+"' " +CHR(10)
	cQuery += "AND SE1.E1_PREFIXO<='"+MV_PAR06+"'  AND SE1.E1_ORIGEM <> 'FINA087A' " +CHR(10)
	cQuery += "AND SE1.E1_TIPO NOT LIKE '__-'  " +CHR(10)
	cQuery += "AND SE1.E1_TIPO NOT IN ('RA ','PA ','NCC','NDF')  " +CHR(10)
	cQuery += "AND SE1.D_E_L_E_T_ = ' ' AND SE5.E5_FILIAL  = '01'  " +CHR(10) 
	cQuery += "AND SE5.E5_NATUREZ=SE1.E1_NATUREZ AND SE5.E5_PREFIXO=SE1.E1_PREFIXO  " +CHR(10)
	cQuery += "AND SE5.E5_NUMERO=SE1.E1_NUM AND SE5.E5_PARCELA=SE1.E1_PARCELA  " +CHR(10)
	cQuery += "AND SE5.E5_TIPO=SE1.E1_TIPO AND SE5.E5_CLIFOR=SE1.E1_CLIENTE  " +CHR(10)
	cQuery += "AND SE5.E5_LOJA=SE1.E1_LOJA AND SE5.E5_RECPAG='R'  " +CHR(10)
	cQuery += "AND SE5.E5_SITUACA<>'C' AND SE5.D_E_L_E_T_ = ' '  " +CHR(10)
	cQuery += "AND NOT EXISTS  " +CHR(10)
	cQuery += "(SELECT A.E5_NUMERO  " +CHR(10)
	cQuery += "FROM " + RetSqlName("SE5") + " A " +CHR(10)
	cQuery += "WHERE A.E5_FILIAL  = '" + xFilial("SE5") + "' AND A.E5_NATUREZ=SE5.E5_NATUREZ  " +CHR(10)
	cQuery += "AND A.E5_PREFIXO=SE5.E5_PREFIXO AND A.E5_NUMERO=SE5.E5_NUMERO  " +CHR(10)
	cQuery += "AND A.E5_PARCELA=SE5.E5_PARCELA AND A.E5_TIPO=SE5.E5_TIPO  " +CHR(10)
	cQuery += "AND A.E5_CLIFOR=SE5.E5_CLIFOR AND A.E5_LOJA=SE5.E5_LOJA  " +CHR(10)
	cQuery += "AND A.E5_SEQ=SE5.E5_SEQ AND A.E5_TIPODOC='ES'  " +CHR(10)
	cQuery += "AND A.E5_RECPAG<>'R' AND A.D_E_L_E_T_= ' ') " +CHR(10)

	cQuery := "SELECT E1_LOJA,E1_FILORIG,E1_PREFIXO ,E1_NUM,E1_PARCELA,E1_TIPO,E1_NFELETR,E1_CLIENTE,E1_EMISSAO,E1_VENCTO,E1_BAIXA,E1_VENCREA,E1_VALOR,E1_VLCRUZ,E1_SDACRES,E1_SDDECRE,E1_VALJUR,E1_SALDO,E1_NATUREZ,E1_PORTADO,E1_NUMBCO,E1_NUMLIQ,E1_HIST,E1_CHQDEV,E1_SITUACA,E1_PORCJUR,E1_MOEDA,E1_VALOR,E1_TXMOEDA,SE1.R_E_C_N_O_ SE1RECNO,FRV.FRV_DESCRI " +CHR(10)
	cQuery += "FROM SE1990 SE1,FRV990 FRV, SA1990 SA1 " +CHR(10)
	cQuery += "WHERE " +CHR(10) 
	cQuery += "SE1.E1_FILIAL  = '" + xFilial('SE1') + "' " +CHR(10)
	cQuery += "--AND SE1.E1_CLIENTE=' "+ SA1->A1_COD +"' AND SE1.E1_LOJA='" +SA1->A1_LOJA+ "'" +CHR(10)
	cQuery += "AND SE1.E1_EMISSAO>='"+DTOS(MV_PAR01)+"' AND SE1.E1_EMISSAO<='"+DTOS(MV_PAR02)+"' " +CHR(10)
	cQuery += "AND SE1.E1_VENCREA>='"+DTOS(MV_PAR03)+"' AND SE1.E1_VENCREA<='"+DTOS(MV_PAR04)+"' " +CHR(10)
	cQuery += "AND SE1.E1_TIPO<>'RA ' AND SE1.E1_PREFIXO>='"+MV_PAR06+"' " +CHR(10)
	cQuery += "AND SE1.E1_PREFIXO<='"+MV_PAR07+"' AND SE1.E1_SALDO > 0 " +CHR(10)
	cQuery += "AND SE1.D_E_L_E_T_<>'*' AND FRV.FRV_FILIAL = '  ' " +CHR(10)
	cQuery += "AND FRV.FRV_CODIGO = SE1.E1_SITUACA " +CHR(10)
	cQuery += "AND FRV.D_E_L_E_T_<>'*' AND SE1.E1_TIPO NOT LIKE '__-' " +CHR(10) 
	cQuery += "AND SE1.E1_LOJA	   = '" +SA1->A1_LOJA+ "'" +CHR(10)
	cQuery += "AND SE1.E1_CLIENTE = '"+ SA1->A1_COD +"' " +CHR(10)
	cQuery += "AND SA1.A1_ZREDE   = '"+ _cCodRede +"'" +CHR(10)
	cQuery += "UNION ALL SELECT E1_LOJA,E1_FILORIG,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_NFELETR,E1_CLIENTE,E1_EMISSAO,E1_VENCTO,E1_BAIXA,E1_VENCREA,E1_VALOR,E1_VLCRUZ,E1_SDACRES,E1_SDDECRE,E1_VALJUR,E1_SALDO,E1_NATUREZ,E1_PORTADO,E1_NUMBCO,E1_NUMLIQ,E1_HIST,E1_CHQDEV,E1_SITUACA,E1_PORCJUR,E1_MOEDA,E1_VALOR,E1_TXMOEDA,SE1.R_E_C_N_O_ SE1RECNO,FRV.FRV_DESCRI " +CHR(10)
	cQuery += "FROM SE1990 SE1,FRV990 FRV , SA1990 SA1 " +CHR(10)
	cQuery += "WHERE " +CHR(10)
	cQuery += "SE1.E1_FILIAL  = '01'" +CHR(10) 
	cQuery += "SE1.E1_FILIAL  = '" + xFilial('SE1') + "' " +CHR(10)
	cQuery += "--AND SE1.E1_CLIENTE=' "+ SA1->A1_COD +"' AND SE1.E1_LOJA='" +SA1->A1_LOJA+ "'" +CHR(10)
	cQuery += "AND SE1.E1_EMISSAO>='"+DTOS(MV_PAR01)+"' AND SE1.E1_EMISSAO<='"+DTOS(MV_PAR02)+"' " +CHR(10)
	cQuery += "AND SE1.E1_VENCREA>='"+DTOS(MV_PAR03)+"' AND SE1.E1_VENCREA<='"+DTOS(MV_PAR04)+"' " +CHR(10)
	cQuery += "AND SE1.E1_TIPO<>'RA ' AND SE1.E1_PREFIXO>='"+MV_PAR06+"' " +CHR(10)
	cQuery += "AND SE1.E1_PREFIXO<='"+MV_PAR07+"' AND SE1.E1_SALDO > 0 " +CHR(10)
	cQuery += "AND SE1.D_E_L_E_T_<>'*' AND FRV.FRV_FILIAL = '  ' " +CHR(10)
	cQuery += "AND FRV.FRV_CODIGO = SE1.E1_SITUACA " +CHR(10)
	cQuery += "AND FRV.D_E_L_E_T_<>'*' AND SE1.E1_TIPO NOT LIKE '__-' " +CHR(10) 
	cQuery += "AND SE1.E1_LOJA	   = '" +SA1->A1_LOJA+ "'" +CHR(10)
	cQuery += "AND SE1.E1_CLIENTE = '"+ SA1->A1_COD +"' " +CHR(10)
	cQuery += "AND SA1.A1_ZREDE   = '"+ _cCodRede +"'" +CHR(10)
	cQuery += "ORDER BY  E1_CLIENTE,E1_LOJA,E1_PREFIXO,E1_NUM,E1_PARCELA,SE1RECNO " +CHR(10)
	cQuery := ChangeQuery( cQuery )
	ELSE

	cQuery := cQueryori
	ENDIF
	*/     
Return (cQuery)