#INCLUDE "PROTHEUS.CH"

#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} MGFGFE43
Validação de cancelamento de documento de saída com carga no multiembarcador
Chamado pelo PE MS520VLD

@type function
@author Rafael Garcia
@since 01/04/2019
/*/
user function MGFGFE43()

Local lret := .T.
Local ocarga := nil
Local _cmensagem := ""
Local _csolucao := ""
Private _cProtoco := ""
Private _cUrlPost	:= ""
Private oObjRet 	:= nil
Private oCarga 		:= nil
Private oWSGFE61 	:= nil

//-----| Verifica existência de parâmetros e caso não exista cria. |-----\\
If !ExisteSx6("MGF_GFE61C")
	CriarSX6("MGF_GFE61C", "C", "API Status da carga no Multi Embarcador"	, "http://spdwvapl203:1337/multiembarcador/api/v1/verificaStatusCarga" )	
EndIf

If !ExisteSx6("MGF_GFE61D")
	CriarSX6("MGF_GFE61D", "C", "Situacao da carga no Multi Embarcador"		, "EmTransporte|Encerrada" )	
EndIf

_cURLPost :=GetMV('MGF_GFE61C',.F.,"http://spdwvapl203:1337/multiembarcador/api/v1/verificaStatusCarga")


//Localiza DAI para verificar se é carga enviada ao MultiEmbarcador
DAI->(Dbsetorder(6)) //DAI_FILIAL+DAI_NFISCA+DAI_SDOC+DAI_CLIENT+DAI_LOJA

If DAI->(Dbseek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE)) .AND. !(EMPTY(DAI->DAI_XPROTO) .and. empty(DAI->DAI_XRETWS))

	If empty(alltrim(DAI->DAI_XPROTO))
		_cProtoco	:= ALLTRIM(DAI->DAI_XRETWS) 
	Else
		_cProtoco	:= ALLTRIM(DAI->DAI_XPROTO)
	Endif

	ocarga := GFE43CARGA():new()
	ocarga:setDados()

	oWSGFE43 := MGFINT23():new(_cURLPost, ocarga,0, "", "", "", "","","", .T. )
	oWSGFE43:lLogInCons := .T.

	_cSavcInt	:= Nil
	_cSavcInt	:= __cInternet    
	__cInternet	:= "AUTOMATICO"
	oWSGFE43:SendByHttpPost()
	__cInternet := _cSavcInt

						
	If oWSGFE43:lOk
		If fwJsonDeserialize(oWSGFE43:cPostRet , @oObjRet)	//Deserealiza gerando um objeto
	
			_cSitCarg := oObjRet:SituacaoCarga	//Guardo o retorno em variavel.
		
			If valtype(_cSitCarg) == "C" .and. !(_cSitCarg $ ALLTRIM(SuperGetMV("MGF_GFE6F",.F.,"Cancelada")))

				//Carga não está cancelada, não permite cancelamento
				_cmensagem := "Documento de saída " + alltrim(SF2->F2_DOC)  +  "/" + ALLTRIM(SF2->F2_SERIE)  
				_cmensagem += " pertence a carga " + alltrim(DAI->DAI_COD) + " que não está cancelada no Multiembarcador!" 
				_csolucao := "Realize o cancelamento da carga " + alltrim(DAI->DAI_COD) + " no Multiembarcador antes de cancelar "
				_csolucao += " o documento de saida " +  alltrim(SF2->F2_DOC)  +  "/" + ALLTRIM(SF2->F2_SERIE) + "."
			
				u_MGFmsg( _cmensagem,"Cancelamento não efetuado!",_csolucao,1 )

				lret := .F.

			Endif

		Endif

	Endif

Endif

return lRet

/*/
{Protheus.doc} GFE43CARGA
Faz comunicação com o Barramento via HTTP Post.

@author Marcos Cesar Donizeti Vieira
@since 18/02/2020

@type Class
@param	
@return
/*/
Class GFE43CARGA
	Data applicationArea   			as ApplicationArea
	Data ProtocoloIntegracaoCarga   as String

	Method New()
	Method setDados()
EndClass



/*/
{Protheus.doc} GFE43CARGA->new
Contrutor de Classe.

@author Marcos Cesar Donizeti Vieira
@since 18/02/2020

@type Method
@param	
@return
/*/
Method new() Class GFE43CARGA
	self:applicationArea := ApplicationArea():new()
return



/*/
{Protheus.doc} GFE43CARGA->setDados
Metodo para pegar Protocolo de integração de carga.

@author Marcos Cesar Donizeti Vieira
@since 18/02/2020

@type Method
@param	
@return
/*/
Method SetDados() Class GFE43CARGA
	Self:ProtocoloIntegracaoCarga := Alltrim(_cProtoco)
Return