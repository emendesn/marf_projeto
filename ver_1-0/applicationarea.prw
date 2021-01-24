#include "totvs.ch"
#include "protheus.ch"
#include "tbiconn.ch"

class componentID
	data schemeID			as string
	data schemeVersionID	as string
	data text				as string

	method new()
endclass

method new() class componentID
	::schemeID			:= "Protheus"
	::schemeVersionID	:= getBuild(.F.)
	::text				:= "TESTE"
return

//----------------------------------------------------------
//----------------------------------------------------------

class LogicalId
	data schemeID			as string
	data schemeVersionID	as string
	data text				as string

	method new()
endclass

method new() class LogicalId
	::schemeID			:= "Protheus"
	::schemeVersionID	:= getBuild(.F.)
	::text				:= "TESTE"
return

//----------------------------------------------------------
//----------------------------------------------------------

class Sender
	data logicalId		as LogicalId
	data componentID	as componentID

	method new()
endclass

method new() class Sender
	::logicalId		:= LogicalId():new()
	::componentID	:= componentID():new()
return

//----------------------------------------------------------
//----------------------------------------------------------

class ApplicationArea
	data creationDateTime	as date
	data sender				as Sender

	method new()
endclass

method new() class ApplicationArea
	::creationDateTime	:= dDataBase
	::sender			:= Sender():new()
return

//VALIDAR O JSON EM http://jsonlint.com/#

user function tstJson()
	local oAppData
	local cJson1
	local cJson2

	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01"

	oAppData := ApplicationArea():new()

	cJson1 := fwJsonSerialize(oAppData,.F.,.T.)

	conout(cJson1)

	RESET ENVIRONMENT
return
