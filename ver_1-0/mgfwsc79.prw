#Include 'Protheus.ch'
#include "totvs.ch"
#include "tbiconn.ch"
#include "topconn.ch"
#include "fileio.ch"

/*/{Protheus.doc} MGFWSC79 - Job de monitor de integrações
	@author Josué Danich
	@since 30/12/2019
/*/
User Function MGFWSC79()

Local _nni := 0
Local _ntimeout := 0

U_MFCONOUT(' Iniciando processamento...') 

_ntimeout := getMv("MGF_SFATO")

cQry := " select   R_E_C_N_O_ REC
cQry += " FROM " + retsqlname("ZFR") + " where d_e_l_e_t_ <> '*'   and "
cQry += " ( ZFR_ATIVO = '1' or ZFR_ATIVO = '2')"
    
TcQuery cQry New Alias "TMPZFR"

Do while !(TMPZFR->(EOF()))
   
   aRet := U_WSC79E(  _nni,;
                        TMPZFR->REC,;
                            _ntimeout) 

    TMPZFR->(Dbskip())

Enddo

TMPZFR->(Dbclosearea())

U_MFCONOUT(' Encerrando monitoramento...' )

Return


/*/{Protheus.doc} MGFWSC79E - Monitora Regra
	@author Josué Danich
	@since 30/12/2019
/*/
User Function WSC79E (_nni,;
                        _nrec,;
                        _ntimeout) 

    Local oWS
    Local oDlg
    Local oGet
    Local cIdEnt     := ""
    Local cURL       := ""
    Local cStatus    := ""
    Local cAuditoria := ""
    Local aSize      := {}
    Local aXML       := {}
    Local aheader    := {}
    Local nX         := 0
    Local odetret    := nil

    ZFR->(Dbgoto(_nrec))

    U_MFCONOUT('Monitorando regra ' + alltrim(ZFR->ZFR_CODIGO) + " - " + alltrim(ZFR->ZFR_DESCRI) + '...' )

    //Tipo Y só faz uma vez a cada 3 horas
    If alltrim(ZFR->ZFR_TIPO) == 'Y'
        
        _chora := strZERO(val(SUBSTR(TIME(),1,2))-3,2)

        cQuery := " SELECT  r_e_c_n_o_ "
	    cQuery += " FROM " + RetSqlName("ZFS")
	    cQuery += "  WHERE zfs_codigo = '" + alltrim(ZFR->ZFR_CODIGO)  + "' and zfs_data = '" + DTOS(DATE())  + "' "
        cQuery += "  and zfs_hora > '" + _chora + ":00:00' "'
	    cQuery += "  AND D_E_L_E_T_= ' ' "

	    If select("ZHLTMP") > 0
		    ZHLTMP->(Dbclosearea())
	    Endif

	    dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"ZHLTMP", .F., .T.)
    
        If !ZHLTMP->(Eof())

            Return
        
        Endif

    Endif
    
    If alltrim(ZFR->ZFR_TIPO) == 'J' .OR. alltrim(ZFR->ZFR_TIPO) == 'G' .or. alltrim(ZFR->ZFR_TIPO) == 'T';
                     .OR.  alltrim(ZFR->ZFR_TIPO) == 'K' .OR.  alltrim(ZFR->ZFR_TIPO) == 'Y' 
    
        //Monitoramento de serviço via Json

        _cHeadRet		:= ""
	    _aHeadOut		:= {}

	    aadd(_aHeadOut,'Content-Type: application/json')
        //Adiciona autenticação se estiver no ZFR_VALOR
        If !empty(alltrim(ZFR->ZFR_VALOR))
            aAdd(_aHeadOut,"Authorization: Basic "+Encode64(alltrim(ZFR->ZFR_VALOR)) )
        Endif

	    _nTimeIni		:= seconds()
	    
        If alltrim(ZFR->ZFR_TIPO) == 'J'  //METODO POST
            _cPostRet		:= httpPost(alltrim(ZFR->ZFR_URL),, alltrim(ZFR->ZFR_PAYLOA), _ntimeout, _aHeadOut, @_cHeadRet)
        Elseif alltrim(ZFR->ZFR_TIPO) == 'G' .or.  alltrim(ZFR->ZFR_TIPO) == 'T'    //METODO GET
           aHeadStr := {}
           cHeaderRet := ""
            aadd( aHeadStr, 'Content-Type: application/json')
   			_ni := 1
            Do While _ni <= 5
            
                _cPostRet := httpQuote( alltrim(ZFR->ZFR_URL) , "GET", alltrim(ZFR->ZFR_PAYLOA),  , _nTimeOut , aHeadStr , @cHeaderRet  )
                _nStatuHttp	:= httpGetStatus()

                If valtype(_cpostret) == "C" .and. _nStatuHttp >= 200 .and. _nStatuHttp <= 299
                    _ni := 99
                Else
                    _ni++
                Endif
            
            Enddo
        Elseif alltrim(ZFR->ZFR_TIPO) == 'K' .or. alltrim(ZFR->ZFR_TIPO) == 'Y'
             _cPostRet		:= httpget(alltrim(ZFR->ZFR_URL))       
        Endif
	    _nTimeFin		:= seconds()
	    _nTimeProc		:= _ntimefin - _ntimeini
	
	    _nStatuHttp	:= httpGetStatus()
 
        If valtype(_cpostret) == "U"
            _cpostret := "Falha de conexão"
        Endif

        If alltrim(ZFR->ZFR_TIPO) == 'T' 

            If ALLTRIM(ZFR->ZFR_PAYLOA) $ _cPostRet

                 fwJsonDeserialize( _cPostRet, @oDetRet )

                if valtype(oDetRet:ITENPENDENTES) == "N"
                    _cpostret := alltrim(str(oDetRet:ITENPENDENTES))
   
                    _cstatus := "ALERTA"
                    _ntot := oDetRet:ITENPENDENTES

                     If _ntot >=  ZFR->ZFR_MIN .and. _ntot <= ZFR->ZFR_ALERT
                        _cstatus := "OK"
                    Elseif _ntot >=  ZFR->ZFR_MIN .and. _ntot <= ZFR->ZFR_MAN
                        _cstatus := "ALERTA"
                    Elseif _ntot <=  ZFR->ZFR_MIN .or. _ntot >= ZFR->ZFR_MAN
                        _cstatus := "FALHA"
                    Endif

                else
                    _cpostret := "FALHA"
                    _cstatus := "FALHA"
                Endif

            elseif "{" $ _cPostRet
                
                _cpostret := "0"
                _cstatus := "OK"

            else
                
                _cpostret := "FALHA" 
                _cstatus := "FALHA"   

            Endif

        elseif alltrim(ZFR->ZFR_TIPO) == 'Y'

            oobjr := nil
            _ntot := 0

			If fwJsonDeserialize(_cPostRet , @oobjr)

                If AttIsMemberOf( oobjr, "data") .and. AttIsMemberOf( oobjr:data, "realizadas") .and. VALTYPE(oobjr:data:realizadas) == "N"
                
                    _ntot := oobjr:data:realizadas

                Endif

            Endif
            
            _cstatus := "ALERTA"
            
            If _ntot >=  ZFR->ZFR_MIN .and. _ntot <= ZFR->ZFR_ALERT
                _cstatus := "OK"
            Elseif _ntot >=  ZFR->ZFR_MIN .and. _ntot <= ZFR->ZFR_MAN
                _cstatus := "ALERTA"
            Elseif _ntot <=  ZFR->ZFR_MIN .or. _ntot >= ZFR->ZFR_MAN
                _cstatus := "FALHA"
            Endif

             _cPostRet := alltrim(str(_ntot))

                
        elseIF   alltrim(ZFR->ZFR_TIPO) == 'K'

            //PEGA SO OS NUMEROS DO RETORNO
            _cret := ""

            For _nnj := 1 to len(_cPostRet)

                If val(substr(_cpostret,_nnj,1)) > 0 .or. (substr(_cpostret,_nnj,1)) == '0'
                    _cret += substr(_cpostret,_nnj,1)
                Endif
            
            Next

            _cstatus := "ALERTA"
            _ntot := val(_cret)
            _cPostRet := alltrim(str(_ntot))

            If _ntot >=  ZFR->ZFR_MIN .and. _ntot <= ZFR->ZFR_ALERT
                _cstatus := "OK"
            Elseif _ntot >=  ZFR->ZFR_MIN .and. _ntot <= ZFR->ZFR_MAN
                _cstatus := "ALERTA"
            Elseif _ntot <=  ZFR->ZFR_MIN .or. _ntot >= ZFR->ZFR_MAN
                _cstatus := "FALHA"
            Endif

        ELSE
            

            _cstatus := IIF(_nStatuHttp >=200 .AND. _nStatuHttp <= 299, "OK","FALHA")

            If _cstatus == "FALHA"

                //Valida se já teve falhas seguidas
                cQry := " select   ZFS_STATUS  "
                cQry += " FROM " + retsqlname("ZFS") + " where d_e_l_e_t_ <> '*' and "
                cQry += " ZFS_CODIGO = '" + alltrim(ZFR->ZFR_CODIGO) + "' "
                cQry += " AND ZFS_DATA = '" + DTOS(DATE())  + "' ORDER BY R_E_C_N_O_ DESC"
    
                If select("TMPZFS") > 0
                    TMPZFS->(Dbclosearea())
                Endif

                TcQuery cQry New Alias "TMPZFS"

                If !(TMPZFS->(EOF()))
                    _cstatus := "TEMPF"
                    _nni := 1
                    Do while !(TMPZFS->(EOF())) .and. _nni <= getmv("MGFWSC79N",,3)
                       _nni++
                        If alltrim(TMPZFS->ZFS_STATUS) == "TEMPF" .OR. alltrim(TMPZFS->ZFS_STATUS) == "FALHA"
                            _cstatus := "FALHA"
                        Endif
                     TMPZFS->(Dbskip())
                  Enddo
                Endif

            Endif

        Endif
	
		U_MFCONOUT('Gravando Resultado da consulta json: ' + allTrim( str( _nStatuHttp ) ) + " - " + _cPostRet)

        Dbselectarea("ZFS")
        Reclock("ZFS",.T.)
        ZFS->ZFS_CODIGO     := ALLTRIM(ZFR->ZFR_CODIGO)
        ZFS->ZFS_DATA       := date()
        ZFS->ZFS_HORA       := time()
        ZFS->ZFS_REQUIS     := ALLTRIM(ZFR->ZFR_PAYLOA)
        ZFS->ZFS_RESPOS     := _cPostRet
        ZFS->ZFS_TEMPO      := _nTimeProc
        ZFS->ZFS_STATUS     := _cstatus
        ZFS->(Msunlock())


    Endif
 
    If alltrim(ZFR->ZFR_TIPO) == 'Q' //Monitoramento de serviço query
    
        If Select("TMPQRY") > 0
            TMPQRY->(Dbclosearea())
        Endif

        U_MFCONOUT('Executando query da regra ' + " - " + alltrim(ZFR->ZFR_DESCRI) + '...' )

        _CPAYLOA := alltrim(ZFR->ZFR_PAYLOA)

        _CPAYLOA := strtran(ZFR->ZFR_PAYLOA,chr(13)," ")
        _CPAYLOA := strtran(ZFR->ZFR_PAYLOA,chr(10)," ")

        _cqry := &(_CPAYLOA)    

        TcQuery _cqry New Alias "TMPQRY"

        If !TMPQRY->(Eof())
            _ntot := TMPQRY->TOT
        Else
            _ntot := 0
        Endif

        //Monitor de pedidos ecommerce
        If ALLTRIM(ZFR->ZFR_CODIGO) == '000000001'

            U_MFCONOUT('Ajustando arquivo de consulta da regra ' + " - " + alltrim(ZFR->ZFR_DESCRI) + '...' )
            //Ajusta arquivo de execução de consulta
            _larq := .F.
            _carqexe := getmv("MGFWSC79E",,"\\spdwvhml016\Consulta\executa.bat")
            nHandle := FT_FUse(_carqexe)
            _cdt := dtos(date()-10)
            _cdt := substr(_cdt,1,4) + "-" + substr(_cdt,5,2) + "-" + substr(_cdt,7,2)


            If nHandle = -1
                _larq := .T.
            Else
                FT_FGoTop()
                cLine  := alltrim(FT_FReadLn())
 
                If _cdt != substr(cline,51,10)
                    _larq := .T.
                Endif

            Endif

            If _larq //não tem arquivo ou precisa mudar
            
                FT_FUSE()
                _nresult := ferase(_carqexe)

                If file(_carqexe)
                    _ntot := 9999
                Else
                         
                    nHandle := fcreate(_carqexe)

                    If nHandle = -1
                        _ntot := 9999   
                    Else
                        _ctexto := 'c:\ConsultaeCommerce\ConsultaPedidosCommerce.exe "'
                        _ctexto += _cdt 
                        _ctexto += 'T00:00:00.000Z"'
                         _ctexto += "> c:\consultaecommerce\consulta.txt"
                        FWrite(nHandle, _ctexto, len(_ctexto)) // Insere texto no arquivo
                        fclose(nHandle)                     
                    Endif
                Endif
            Endif
                

            //Lê arquivo de consulta para array
            If _ntot != 9999
            
                _carqcon := getmv("MGFWSC79C",,"\\spdwvhml016\Consulta\CONSULTA.TXT")
                nHandle := FT_FUse(_carqcon)
                
                If nHandle = -1
                    _ntot := 9999   
                Else

                    _nLast := FT_FLastRec()
                    FT_FGoTop()
                    _nni := 1
                    _lfalha := .F.
                
                    Do while !FT_FEOF()

                        U_MFCONOUT('Validando pedido ' + strzero(_nni,6) + ' de ' + strzero(_nlast,6) + ' da regra ' + " - " + alltrim(ZFR->ZFR_DESCRI) + '...' )
                        
                        cLine  := alltrim(FT_FReadLn())   
                        
                        If substr(cline,1,19) == '{"lastModifiedDate"'
                        
                            oJson := JsonObject():New()
                            ret := oJson:FromJson(cLine)
                            _nId := oJson['id']
                            _cstatus := oJson['state']
                            
                            XC5->(Dbsetorder(5)) //XC5->IDECOM

                            If _cstatus == "SUBMITTED" .AND. !(XC5->(Dbseek(_nId)))
                                _ntot++
                                If _lfalha
                                    _cqry += _nId + " - "
                                Else
                                    _lfalha := .T.
                                     _cqry := _nId + " - "
                                Endif
                            Endif

                            FreeObj(oJson)

                        Endif

                        FT_FSKIP()
                        _nni++

                    Enddo

                    FT_FUSE()

                Endif

            Endif                 

        Endif

        U_MFCONOUT('Gravando resultado da regra ' + " - " + alltrim(ZFR->ZFR_DESCRI) + ' - ' + alltrim(str(_ntot)) + "..." )

        _cstatus := "ALERTA"

        If _ntot >=  ZFR->ZFR_MIN .and. _ntot <= ZFR->ZFR_ALERT
            _cstatus := "OK"
        Elseif _ntot >=  ZFR->ZFR_MIN .and. _ntot <= ZFR->ZFR_MAN
            _cstatus := "ALERTA"
        Elseif _ntot <=  ZFR->ZFR_MIN .or. _ntot >= ZFR->ZFR_MAN
            _cstatus := "FALHA"
        Endif


        Dbselectarea("ZFS")
        Reclock("ZFS",.T.)
        ZFS->ZFS_CODIGO     := ALLTRIM(ZFR->ZFR_CODIGO)
        ZFS->ZFS_DATA       := date()
        ZFS->ZFS_HORA       := time()
        ZFS->ZFS_REQUIS     := _cqry
        ZFS->ZFS_RESPOS     := alltrim(str(_ntot))
        ZFS->ZFS_TEMPO      := 0
        ZFS->ZFS_STATUS     := _cstatus
        ZFS->(Msunlock())

    Endif

    If ALLTRIM(ZFR->ZFR_TIPO) == 'S' //TSS

        _asefaz := {}
        _nni := 1
        _cerr := ""
        _nerr := 0

 
        //Busca filiais e estados da tabela syscompany
        cQry := " select m0_estent,min(m0_codfil) filial from sys_company where d_e_l_e_t_ <> '*'and m0_estent <> ' '  "
        cQry += " and m0_estent <> 'EX' group by m0_estent order by m0_estent"
    

        If select("TMPSYS") > 0
            dbselectarea("TMPSYS")
            TMPSYS->(Dbclosearea())
        Endif

        TcQuery cQry New Alias "TMPSYS"

        Do while !(TMPSYS->(EOF()))

            aadd(_asefaz,{TMPSYS->m0_estent,TMPSYS->FILIAL,"FALHA"})

            TMPSYS->(Dbskip())

        Enddo
  
        For _nni := 1 to len(_asefaz)

            cfilant := _asefaz[_nni,2]

            U_MFCONOUT('Consultando TSS da regra ' + " - " + alltrim(ZFR->ZFR_DESCRI) + ' para o estado de ' + _asefaz[_nni,1] + '...' )

            cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
    	    cIdEnt :=  getCfgEntidade()
	    
		    If !Empty(cIdEnt)
			    oWS:= WSNFeSBRA():New()
			    oWS:cUSERTOKEN := "TOTVS"
			    oWS:cID_ENT    := cIdEnt
			    oWS:_URL       := AllTrim(cURL)+"/NFeSBRA.apw"
			    If oWS:MONITORSEFAZMODELO()
				    aSize := MsAdvSize()
				    aXML := oWS:oWsMonitorSefazModeloResult:OWSMONITORSTATUSSEFAZMODELO
 				    For nX := 1 To Len(aXML)
		
        			    If aXML[nX]:cModelo == "55"
		
                            If aXML[nX]:cStatusCodigo == "107"
                                _asefaz[_nni,3] := "OK"
                            Endif

                        Endif

                    Next

                Endif
        
            Endif

            If _asefaz[_nni,3] == "FALHA"
                _cerr += _asefaz[_nni,1] + "/"
                _nerr++
            Endif

        Next

        if _nerr == 0
            _cstatus := 'OK'
        elseif _nerr < 4
            _cstatus := 'ALERTA'
            _cerr := "FALHA SEFAZ - " + _cerr
        Else
            _cstatus := 'FALHA'
            _cerr := "FALHA TSS - " + _cerr
        Endif

        _cerr := substr(_cerr,1,len(_cerr)-1)

        U_MFCONOUT('Gravando resultado da regra ' + " - " + alltrim(ZFR->ZFR_DESCRI) + ' - ' + _cstatus + "..." )

        Dbselectarea("ZFS")
        Reclock("ZFS",.T.)
        ZFS->ZFS_CODIGO     := ALLTRIM(ZFR->ZFR_CODIGO)
        ZFS->ZFS_DATA       := date()
        ZFS->ZFS_HORA       := time()
        ZFS->ZFS_REQUIS     := " "
        ZFS->ZFS_RESPOS     := _cerr
        ZFS->ZFS_TEMPO      := 0
        ZFS->ZFS_STATUS     := _cstatus
        ZFS->(Msunlock())  


    Endif
    
    U_MFCONOUT('Completou monitoramento da regra ' + " - " + alltrim(ZFR->ZFR_DESCRI) + '...' )

Return

