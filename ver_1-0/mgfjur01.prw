#include "totvs.ch"                                                 
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "FWFILTER.CH"
#INCLUDE "FWBRWSTR.CH"
#INCLUDE "FWMVCDEF.CH"
#define CRLF chr(13) + chr(10)             

/*
=====================================================================================
Programa.:              MGFJUR01
Autor....:              Marcelo Carneiro
Data.....:              11/03/2019
Descricao / Objetivo:   Integração RH Evolution x SigaJuri
Doc. Origem:            MIT044
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WS Server para Importação de Colaboradores/Funcionarios SRA
=====================================================================================
*/

WSSTRUCT JUR01_FUNC
	WSDATA RA_FILIAL        As String
	WSDATA RA_MAT           As String
	WSDATA RA_NOME          As String
	WSDATA RA_NASC          As String
	WSDATA RA_ADMISSA       As String
	WSDATA RA_DEMISSA       As String   Optional 
	WSDATA RA_CODFUNC       As String
	WSDATA RA_DESCFUN       As String
	WSDATA RA_CARGO         As String
	WSDATA RA_DCARGO        As String
	WSDATA RA_DEPTO         As String
	WSDATA RA_DDEPTO        As String
	WSDATA RA_CIC           As String
	WSDATA RA_PIS           As String
	WSDATA RA_RG            As String
	WSDATA RA_DTRGEXP       As String Optional
	WSDATA RA_NUMCP         As String
	WSDATA RA_SERCP         As String
	WSDATA RA_UFCP          As String
	WSDATA RA_DTCPEXP       As String Optional
	WSDATA RA_ENDEREC       As String
	WSDATA RA_NUMENDE       As String
	WSDATA RA_COMPLEM       As String Optional
	WSDATA RA_BAIRRO        As String
	WSDATA RA_ESTADO        As String
	WSDATA RA_CODMUN        As String
	WSDATA RA_CEP           As String Optional
	WSDATA RA_SEXO          As String 
	WSDATA RA_ESTCIVI       As String            
	WSDATA RA_NACIONA       As String
	WSDATA RA_NATURAL       As String
ENDWSSTRUCT 

WSSTRUCT JUR01_RET
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT 

WSSERVICE MGFJUR01 DESCRIPTION "Integração RH Evolution x SigaJuri" NameSpace "http://totvs.com.br/MGFJUR01.apw"
	WSDATA WSFUNC    As JUR01_FUNC
	WSDATA WSRETORNO As JUR01_RET

	WSMETHOD IntegraFunc DESCRIPTION "Integração Evolution x SigaJuri - Funcionarios"

ENDWSSERVICE

WSMETHOD IntegraFunc WSRECEIVE WSFUNC WSSEND WSRETORNO WSSERVICE MGFJUR01

Local aRet := {}

aRet	  := JUR01GFUNC(              {	::WSFUNC:RA_FILIAL    ,;
										::WSFUNC:RA_MAT       ,;
										::WSFUNC:RA_NOME      ,;
										::WSFUNC:RA_NASC      ,;
										::WSFUNC:RA_ADMISSA   ,;
										::WSFUNC:RA_DEMISSA   ,;
										::WSFUNC:RA_CODFUNC   ,;
										::WSFUNC:RA_DESCFUN   ,;
										::WSFUNC:RA_CARGO     ,;
										::WSFUNC:RA_DCARGO    ,;
										::WSFUNC:RA_DEPTO     ,;
										::WSFUNC:RA_DDEPTO    ,;
										::WSFUNC:RA_CIC       ,;
										::WSFUNC:RA_PIS       ,;
										::WSFUNC:RA_RG        ,;
										::WSFUNC:RA_DTRGEXP   ,;
										::WSFUNC:RA_NUMCP     ,;
										::WSFUNC:RA_SERCP     ,;
										::WSFUNC:RA_UFCP      ,;
										::WSFUNC:RA_DTCPEXP   ,;
										::WSFUNC:RA_ENDEREC   ,;
										::WSFUNC:RA_NUMENDE   ,;
										::WSFUNC:RA_COMPLEM   ,;
										::WSFUNC:RA_BAIRRO    ,;
										::WSFUNC:RA_ESTADO    ,;
										::WSFUNC:RA_CODMUN    ,;
										::WSFUNC:RA_CEP       ,;
										::WSFUNC:RA_SEXO      ,;
										::WSFUNC:RA_ESTCIVI   ,;
										::WSFUNC:RA_NACIONA   ,;
										::WSFUNC:RA_NATURAL} )	
										
::WSRETORNO := WSClassNew( "JUR01_RET")
::WSRETORNO:STATUS  := aRet[1]
::WSRETORNO:MSG	    := aRet[2]
   
Return .T.

****************************************************************************************************************************************
Static Function JUR01GFUNC( aDados )

Local cRA_FILIAL    := Alltrim(aDados[01])
Local cRA_MAT       := STRZERO(VAL(aDados[02]),TamSX3("RA_MAT")[1])
Local cRA_NOME      := aDados[03]
Local cRA_NASC      := STOD(aDados[04])
Local cRA_ADMISSA   := STOD(aDados[05])
Local cRA_DEMISSA   := STOD(aDados[06])
Local cRA_CODFUNC   := STRZERO(VAL(aDados[07]),TamSX3("RJ_FUNCAO")[1])
Local cRA_DESCFUN   := aDados[08]
Local cRA_CARGO     := STRZERO(VAL(aDados[09]),TamSX3("Q3_CARGO")[1])
Local cRA_DCARGO    := aDados[10]
Local cRA_DEPTO     := STRZERO(VAL(aDados[11]),TamSX3("QB_DEPTO")[1])
Local cRA_DDEPTO    := aDados[12]
Local cRA_CIC       := aDados[13]
Local cRA_PIS       := aDados[14]
Local cRA_RG        := aDados[15]
Local cRA_DTRGEXP   := aDados[16]
Local cRA_NUMCP     := aDados[17]
Local cRA_SERCP     := aDados[18]
Local cRA_UFCP      := aDados[19]
Local cRA_DTCPEXP   := STOD(aDados[20])
Local cRA_ENDEREC   := aDados[21]
Local cRA_NUMENDE   := aDados[22]
Local cRA_COMPLEM   := aDados[23]
Local cRA_BAIRRO    := aDados[24]
Local cRA_ESTADO    := aDados[25]
Local cRA_CODMUN    := aDados[26]
Local cRA_CEP       := aDados[27]
Local cRA_SEXO      := aDados[28]                
Local cRA_ESTCIVI   := aDados[29]      
Local cRA_NACIONA   := aDados[30]       
Local cRA_NATURAL   := aDados[31]       
Local aRet          := {}                 
Local aCab          := {} 
Local aErro 		:= {}
Local cErro 		:= ""
Local nI            := 0 
Local nOper         := 3

Private aRotina         := {}
Private oModel      
Private lMsHelpAuto     := .T.
Private lMsErroAuto     := .F.
Private lAutoErrNoFile  := .T.                               
                 
cFilAnt := cRA_FILIAL
dbSelectArea('SRA')
SRA->(dbSetOrder(1)) // RA_FILIAL, RA_MAT

dbSelectArea('SQB')
SQB->(dbSetOrder(1)) // QB_FILIAL, QB_DEPTO
dbSelectArea('SRJ')
SRJ->(dbSetOrder(1)) // RJ_FILIAL, RJ_FUNCAO
dbSelectArea('SQ3')
SQ3->(dbSetOrder(1)) // Q3_FILIAL, Q3_CARGO

//Cadastra o Departamento                 
IF SQB->(!dbSeek(xFilial('SQB')+cRA_DEPTO))
	aCab := {}
	AAdd(aCab, {"QB_FILIAL",     xFilial('SQB')})
	AAdd(aCab, {"QB_DEPTO",      cRA_DEPTO})
	AAdd(aCab, {"QB_DESCRIC",    cRA_DDEPTO})
	AAdd(aCab, {"QB_CC",         ""})
	AAdd(aCab, {"QB_FILRESP",    ""})
	AAdd(aCab, {"QB_MATRESP",    ""})
	AAdd(aCab, {"QB_DEPSUP",     ""})
	AAdd(aCab, {"QB_ARELIN",     ""})
	MsExecAuto({|w, x, y, z| CSAA100(w, x, y, z)}, NIL, NIL, aCab, 3)
	IF lMsErroAuto
		aErro := GetAutoGRLog()
		cErro := ""
		For nI := 1 to Len(aErro)
			cErro += aErro[nI] + CRLF
		Next nI
		Return {"2",'Erro na inclusão do departamento: '+cErro}
	EndIF
EndIF     

//Cadastra Função
IF SRJ->(!dbSeek(xFilial('SRJ')+cRA_CODFUNC))
	aCab := {}
	//AAdd(aCab, {"RJ_FILIAL",  xFilial('SRJ'),Nil})
	AAdd(aCab, {"RJ_FUNCAO",  cRA_CODFUNC  ,Nil})
	AAdd(aCab, {"RJ_DESC",    cRA_DESCFUN  ,Nil})
	oModel  := FWLoadModel('GPEA030')
	aRotina := FWLoadMenuDef('GPEA030')
	FWMVCRotAuto(	oModel,;                        
					"SRJ",;                         
					MODEL_OPERATION_INSERT,;        
					{{'GPEA030_SRJ', aCab}})
	If lMsErroAuto
		aErro   := oModel:GetErrorMessage()
		cErro +=  AllToChar( aErro[6]  ) 
		Return  {"2",'Erro na inclusão da Função: '+cErro}
	EndIF
EndIF                               

//Cadastra Cargo
IF SQ3->(!dbSeek(xFilial('SQ3')+cRA_CARGO))
	aCab := {}
	AAdd(aCab, {"Q3_FILIAL", xFilial('SQ3')})
	AAdd(aCab, {"Q3_CARGO",  cRA_CARGO})
	AAdd(aCab, {"Q3_DESCSUM",cRA_DCARGO})
	oModel  := FWLoadModel('GPEA370')
	aRotina := FWLoadMenuDef('GPEA370')
	FWMVCRotAuto(	oModel,;                        //Model
					"SQ3",;                         //Alias
					MODEL_OPERATION_INSERT,;        //Operacao
					{{'MODELGPEA370', aCab}})
	If lMsErroAuto
		aErro   := oModel:GetErrorMessage()
		cErro +=  AllToChar( aErro[6]  ) 
		Return  {"2",'Erro na inclusão do Cargo: '+cErro}
	EndIF
EndIF                                              
dbSelectAREA('SRA')
SRA->(dbSetOrder(1))
nOper := 3
IF SRA->(dbSeek(xFilial('SRA')+cRA_MAT))
    nOper := 4
EndIF
aCab := {}
AAdd(aCab,{"RA_FILIAL"    , cRA_FILIAL   , Nil})
AAdd(aCab,{"RA_MAT"       , cRA_MAT      , Nil})
AAdd(aCab,{"RA_NOME"      , cRA_NOME     , Nil})
AAdd(aCab,{"RA_NASC"      , cRA_NASC     , Nil})
AAdd(aCab,{"RA_ADMISSA"   , cRA_ADMISSA  , Nil})
AAdd(aCab,{"RA_DEMISSA"   , cRA_DEMISSA  , Nil})
AAdd(aCab,{"RA_CODFUNC"   , cRA_CODFUNC  , Nil})
AAdd(aCab,{"RA_CARGO"     , cRA_CARGO    , Nil})
AAdd(aCab,{"RA_DEPTO"     , cRA_DEPTO    , Nil})
AAdd(aCab,{"RA_CIC"       , cRA_CIC      , Nil})
AAdd(aCab,{"RA_PIS"       , cRA_PIS      , Nil})
AAdd(aCab,{"RA_RG"        , cRA_RG       , Nil})
AAdd(aCab,{"RA_DTRGEXP"   , cRA_DTRGEXP  , Nil})
AAdd(aCab,{"RA_NUMCP"     , cRA_NUMCP    , Nil})
AAdd(aCab,{"RA_SERCP"     , cRA_SERCP    , Nil})
AAdd(aCab,{"RA_UFCP"      , cRA_UFCP     , Nil})
AAdd(aCab,{"RA_DTCPEXP"   , cRA_DTCPEXP  , Nil})
AAdd(aCab,{"RA_ENDEREC"   , cRA_ENDEREC  , Nil})
AAdd(aCab,{"RA_NUMENDE"   , cRA_NUMENDE  , Nil})
AAdd(aCab,{"RA_COMPLEM"   , cRA_COMPLEM  , Nil})
AAdd(aCab,{"RA_BAIRRO"    , cRA_BAIRRO   , Nil})
AAdd(aCab,{"RA_ESTADO"    , cRA_ESTADO   , Nil})
AAdd(aCab,{"RA_CODMUN"    , cRA_CODMUN   , Nil})
AAdd(aCab,{"RA_CEP"       , cRA_CEP      , Nil})
AAdd(aCab,{"RA_SEXO"      , cRA_SEXO     , Nil})
AAdd(aCab,{"RA_ESTCIVI"   , cRA_ESTCIVI  , Nil})
AAdd(aCab,{"RA_NACIONA"   , cRA_NACIONA  , Nil})  
AAdd(aCab,{"RA_NATURAL"   , cRA_NATURAL  , Nil})  
AAdd(aCab,{"RA_TIPOADM"   , '2100'       , Nil})   
AAdd(aCab,{"RA_OPCAO"     , cRA_ADMISSA  , Nil}) 
AAdd(aCab,{"RA_TNOTRAB"   , '01'         , Nil})   
AAdd(aCab,{"RA_HRSMES"    , 220          , Nil})     
AAdd(aCab,{"RA_PROCES"    , '00001'      , Nil}) 
AAdd(aCab,{"RA_CATFUNC"   , 'M'          , Nil}) 
AAdd(aCab,{"RA_TIPOPGT"   , 'M'          , Nil}) 
AAdd(aCab,{"RA_VIEMRAI"   , '90'         , Nil})    
AAdd(aCab,{"RA_GRINRAI"   , '55'         , Nil})    

MSExecAuto({|x,y,z,w| Gpea010(x,y,z,w)},,,aCab,nOper)
IF lMsErroAuto
	aErro := GetAutoGRLog()
	cErro := ""
	For nI := 1 to Len(aErro)
		cErro += aErro[nI] + CRLF
	Next nI
	IF nOper == 3
		Return {"2",'Erro na inclusão do funcionario: '+cErro}
	Else
		Return {"2",'Erro na Alteração do funcionario: '+cErro}
	EndIF
EndIF



Return {'1',IIF(nOper == 3, 'Inclusão','Alteação')+' efetuada com Sucesso'}

