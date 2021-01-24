#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)


/*
=====================================================================================
Programa.:              MGFWSC75V
Autor....:              Josué Danich Prestes
Data.....:              18/11/2019
Descricao / Objetivo:   Envio de consulta de estoque assincrona na tabela ZFP
=====================================================================================
*/
User Function MGFWSC75()

Local oObjRet := nil

U_MFCONOUT(' Iniciando envio de consulta de estoque assincrona para o Taura...') 

//Carrega filiais a verificar
_afiliais := FWAllFilial('01')
_cfiliais := supergetmv("ZMFGFILIN3",,'010007|010015|010016|010041|010044|010050|010054|010056|010059|010066')

    For _nj := 1 to len(_afiliais)

        If _afiliais[_nj] $ _cfiliais

            _cfilori := cfilant
            cfilant := "01" + _afiliais[_nj]

            U_MFCONOUT(' Iniciando filial ' + cfilant + '...' )
            //Carrega produtos a consultar
            MFWSC75G() //Seleciona produtos em estoque do ecommerce

            _ntot := 0
            _nni := 0
	        //Conta produtos
	        while !QRYSB2->(EOF())
		        _ntot++
		        QRYSB2->(Dbskip())
	        End
	        QRYSB2->(Dbgotop())

	        while !QRYSB2->(EOF())

				U_MFCONOUT(' Processando produto ' + cfilant + "/" + alltrim(QRYSB2->idproduto) + " - " + strzero(_nni,6) + ' de ' + strzero(_ntot,6) + '...' )
				_nni++

        	    if QRYSB2->ZJ_FEFO <> 'S'
		    	    // Para o tipo VE as datas nao importam na consulta ao Taura, mas na conta para debitar Pedidos do Protheus sim
			        dDataMin := CTOD("  /  /  ")
			        dDataMax := CTOD("  /  /  ")
		        elseif QRYSB2->ZJ_FEFO == 'S'
			        dDataMin := dDataBase + QRYSB2->ZJ_MINIMO
			        dDataMax := dDataBase + QRYSB2->ZJ_MAXIMO
		        endif

                //Verifica se tem resposta válida nos últimos 10 minutos
                cQryZFQ := " select R_E_C_N_O_ AS REC FROM " + retsqlname("ZFQ") + " where d_e_l_e_t_ <> '*' and "
	            cQryZFQ += " ZFQ_PROD   = '" + alltrim(QRYSB2->idproduto) + "' AND ZFQ_FILIAL = '" + cfilant + "' and "
                cQryZFQ += " ZFQ_STATUS = 'C' AND ZFQ_TIPOCO = '" + QRYSB2->ZJ_FEFO + "' and " 
                cQryZFQ += " ZFQ_DTRESP = '" + dtos(date()) + "' AND ZFQ_SECMID >= " + alltrim(str(seconds() - 600)) 

                If QRYSB2->ZJ_FEFO == 'S'

                    cQryZFQ += " AND ZFQ_DTVALI = '" + dtos(dDataMin) + "' AND ZFQ_DTVALF = '" + dtos(dDataMax) + "'"

                Endif

	            TcQuery cQryZFQ New Alias "QRYZFQ"


                If QRYZFQ->(EOF())

                    //Envia consulta

					oSaldo := nil
        		    IF QRYSB2->ZJ_FEFO == 'S'
			            cURLPost :=GetMV('MGF_TAE76',.F.,"http://spdwvapl203:1337/taura-estoque-async/consulta-por-fefo")
						oSaldo := WS75_ESTOQUEFEFO():new()
		            Else 
			            cURLPost :=GetMV('MGF_TAE75',.F.,"http://spdwvapl203:1337/taura-estoque-async/consulta")
						oSaldo := WS75_ESTOQUE():new()
		            EndIF
		
		            oSaldo:setDados()
		            oWSWSC75 := nil
		            oWSWSC75 := MGFINT23():new(cURLPost, oSaldo,0, "", "", "", "","","", .T. )

        		    // tratamento para funcao padrao do frame, httpPost(), nao apresentar mensagem de "DATA COMMAND ERRO" quando executada em tela,	
        		    // forca funcao padrao IsBlind() a retornar .T.
        		    cSavcInternet	:= Nil
        		    cSavcInternet	:= __cInternet	
        		    __cInternet		:= "AUTOMATICO"
        		    oWSWSC75:SendByHttpPost()
        		    __cInternet := cSavcInternet

        		    IF oWSWSC75:lOk

                        //Grava envio
    		            IF fwJsonDeserialize(oWSWSC75:cPostRet, @oObjRet)
						
                            Reclock("ZFQ",.T.)
                            ZFQ_FILIAL := cfilant
                            ZFQ_PROD   := alltrim(QRYSB2->idproduto)
                            ZFQ_DATAE  := date()
                            ZFQ_HORAE  := time()
                            ZFQ_UUID   := oObjRet:UUID
                            ZFQ_STATUS := "A"
                            ZFQ_SOLENV := fwJsonSerialize(oWSWSC75:oObjToJson, .T., .T.)
                            ZFQ_SOLRES := oWSWSC75:cPostRet
							
                            If QRYSB2->ZJ_FEFO == 'S'

                                ZFQ_DTVALI := dDataMin
                                ZFQ_DTVALF := dDataMax
                                ZFQ_TIPOCO := "F"

                            Else

                                ZFQ_TIPOCO := "N"

                            Endif

                            ZFQ->(Msunlock())
	
                        Endif

                    Else

                        //Grava falha de envio
                        Reclock("ZFQ",.T.)
                        ZFQ_FILIAL := cfilant
                        ZFQ_PROD   := alltrim(QRYSB2->idproduto)
                        ZFQ_DATAE  := date()
                        ZFQ_HORAE  := time()
                        ZFQ_STATUS := "E"
                        ZFQ_SOLENV := fwJsonSerialize(oWSWSC75:oObjToJson, .T., .T.)
                    
                        If QRYSB2->ZJ_FEFO == 'S'

                            ZFQ_DTVALI := dDataMin
                            ZFQ_DTVALF := dDataMax
                            ZFQ_TIPOCO := "F"

                        Else

                            ZFQ_TIPOCO := "N"

                        Endif

                        ZFQ->(Msunlock())
	                
                    Endif

                Endif

                Dbselectarea("QRYZFQ")
                Dbclosearea()

				 QRYSB2->(Dbskip())

            Enddo

			Dbselectarea("QRYSB2")
			Dbclosearea()

			U_MFCONOUT(' Completou filial ' + _afiliais[_nj] + '...' )

        Endif

    Next

Return

/*
=====================================================================================
Programa.:              MFWSC75G
Autor....:              Josué Danich Prestes
Data.....:              27/09/2016
Descricao / Objetivo:   Seleciona produtos em estoque
=====================================================================================
*/
static function MFWSC75G()  

local cQrySB2		:= ""
local cFilSFA		:= allTrim( getMv( "MGF_SFASZJ" ) ) // 'VE','FF','PR'
  

	cQrySB2 := " SELECT DISTINCT DA1_CODPRO IDPRODUTO, 'EC' idtipopedi, 'N' ZJ_FEFO, 0 ZJ_MINIMO, 0 ZJ_MAXIMO "		+ CRLF					
	cQrySB2 += "  FROM 			" + retSQLName("DA0") + "   DA0	"		+ CRLF				
	cQrySB2 += "  INNER JOIN 	" + retSQLName("DA1") + "   DA1	"		+ CRLF				
	cQrySB2 += "  ON "		+ CRLF															
	cQrySB2 += "  		DA1.DA1_CODTAB	=	DA0.DA0_CODTAB	"		+ CRLF 					
	cQrySB2 += "  	AND	DA1.DA1_CODPRO	<=	'500000' "		+ CRLF							
	cQrySB2 += "  	AND	DA1.DA1_FILIAL	=	'" + xfilial("DA1") + "' "		+ CRLF					
	cQrySB2 += "  	AND	DA1.D_E_L_E_T_	<>	'*'	 "		+ CRLF							
	cQrySB2 += "  INNER JOIN 	" + retSQLName("SB1") + "   SB1 "		+ CRLF					
	cQrySB2 += "  ON "		+ CRLF															
	cQrySB2 += "  		DA1.DA1_CODPRO	=	SB1.B1_COD	"		+ CRLF						
	cQrySB2 += "  	AND	SB1.B1_ZPESMED	>	0 "		+ CRLF									
	cQrySB2 += "  	AND	SB1.B1_COD		<=	'500000' "		+ CRLF							
	cQrySB2 += "  	AND	SB1.B1_FILIAL	=	'" + xfilial("SB1") + "' "		+ CRLF	
	cQrySB2 += "  	AND	DA1.D_E_L_E_T_	<>	'*'	"		+ CRLF							
	cQrySB2 += "  WHERE															
	cQrySB2 += "  		DA0.DA0_XENVEC	=	'1' "		+ CRLF								 
	cQrySB2 += "  	AND	DA0.DA0_ATIVO	=	'1' "		+ CRLF								 
	cQrySB2 += "  	AND	DA1.DA1_PRCVEN	>	1  "		+ CRLF  								
	cQrySB2 += "  	AND	DA0.DA0_FILIAL	=	'" + xfilial("DA0") + "' "		+ CRLF			
	cQrySB2 += "  	AND	DA0.D_E_L_E_T_	<>	'*'		 "		+ CRLF
	 	
	cQrySB2 += "  order by idproduto, idtipopedi desc "		+ CRLF	

	TcQuery cQrySB2 New Alias "QRYSB2"

return

******************************************************************************************************************
CLASS WS75_ESTOQUE
Data applicationArea   as ApplicationArea
Data Produto	       as String
Data Filial		       as String

Method New()
Method setDados()

EndClass
******************************************************************************************************************
Method new() Class WS75_ESTOQUE
self:applicationArea	:= ApplicationArea():new()
Return
******************************************************************************************************************
Method setDados() Class WS75_ESTOQUE

Self:Produto  := alltrim(QRYSB2->idproduto)
Self:Filial   := cfilant

Return
******************************************************************************************************************
CLASS WS75_ESTOQUEFEFO
Data applicationArea	  as ApplicationArea
Data Produto	          as String
Data Filial		          as String
Data DataValidadeInicial  as String
Data DataValidadeFinal    as String

Method New()
Method setDados()
endclass
Return
******************************************************************************************************************
Method new() Class WS75_ESTOQUEFEFO
self:applicationArea	:= ApplicationArea():new()
Return
******************************************************************************************************************
Method setDados() Class WS75_ESTOQUEFEFO

Self:Produto             := alltrim(QRYSB2->idproduto)
Self:Filial              := cfilant
Self:DataValidadeInicial := SUBSTR(DTOS(dDataMin),1,4)+'-'+SUBSTR(DTOS(dDataMin),5,2)+'-'+SUBSTR(DTOS(dDataMin),7,2)
Self:DataValidadeFinal   := SUBSTR(DTOS(dDataMax),1,4)+'-'+SUBSTR(DTOS(dDataMax),5,2)+'-'+SUBSTR(DTOS(dDataMax),7,2)

Return
