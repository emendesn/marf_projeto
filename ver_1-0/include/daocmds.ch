// ######################################################################################
// Projeto: MVC - Framework para MVC
// Modulo : Include
// Fonte  : daoCmds - Definições de comandos
// ---------+-------------------+--------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+--------------------------------------------------------
// 15.07.09 | 0548-Alan Candido | FNC ???????????/2009
// --------------------------------------------------------------------------------------

#ifndef _DAO_CMDS_CH
#  define _DAO_CMDS_CH

// **************************************************************************************
// Definição de comandos para definição de modelos
// **************************************************************************************
# command register dao <DAOName> type <type: table, xml, memory>;
  => class _d<DAOName> from IDAO<type>;;
       method _d<DAOName>();;
       method _new();;
       method _end_d<DAOName>();;
       method execCommand();;
     end class;;
     method _end_d<DAOName>() class _d<DAOName>;;
       ::_endIDAO<type>();;
     return;;
     method execCommand(acCommand, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA) class _d<DAOName>;;
       local cCmd := "{|oSelf, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA|" + acCommand + "(oSelf, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA)}";;
     return __runcb(__compstr("eval(" + cCmd + ", self, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA)"));;
     method _new() class _d<DAOName>;;
     return;;
     method _d<DAOName>(acAlias) class _d<DAOName>;;
       local _appMan := biGetApp(), _oField, _oFieldsDef, _oValidator;;
       ::IDAO<type>(nil, acAlias);;
       aAdd(::FClassesName, upper("_d"+<"DAOName">));;
       _oValidator := nil; _oFieldsDef := ::getFieldsDef()
       
# command description <text>;
  => ::setDescription(<"text">)

# command tablename <tableName>;
  => ::setTablename(<"tableName">);;
     _oFieldsDef := ::getFieldsMap()

# command add <char: character, char> field <fieldName> size <len> [label <label>] [default <xDefault>];
  => _oField := _oFieldsDef:addChar(<"fieldName">, <len> [,<label>]) ;;
     [_oField:setInitialize( {|| <xDefault>} )]

# command add date field <fieldName> [label <label>] [default <xDefault>];
  => _oField := _oFieldsDef:addDate(<"fieldName"> [,<label>]) ;;
     [_oField:setInitialize( {|| <xDefault>} )]

# command add numeric field <fieldName> size <len> decimals <dec> [label <label>] [default <xDefault>];
  => _oField := _oFieldsDef:addNumeric(<"fieldName">, <len>, <dec> [,<label>]) ;;
     [_oField:setInitialize( {|| <xDefault>} )]

# command add <bool: logical, boolean> field <fieldName> [label <label>] [default <xDefault>];
  => _oField := _oFieldsDef:addLogical(<"fieldName"> [,<label>]) ;;
     [_oField:setInitialize( {|| <xDefault>} )]

# command add memo field <fieldName> [label <label>] [default <xDefault>];
  => _oField := _oFieldsDef:addMemo(<"fieldName"> [,<label>]) ;;
     [_oField:setInitialize( {|| <xDefault>} )]
                                                 
# command paranoid mode;  
  => _oFieldsDef:addChar("P_C_T_A_T_", 10);;
     _oFieldsDef:addChar("P_C_T_B_Y_", 10);;
     _oFieldsDef:addChar("P_U_P_A_T_", 10);;
     _oFieldsDef:addChar("P_U_P_B_Y_", 10)
            
# command primary key <colN,...>;
  => ::addIndex({<"colN">}  , .t., .t., .f.)

# command unique key <colN,...> [ <emptyKey:accept empty key> ];
  => ::addIndex({<"colN">}, .t., .f., <.emptyKey.>)

# command index <colN,...>;
  => ::addIndex({<"colN">}, .f., .f., .f.)

# command event <moment:AFTER, BEFORE> <action:CREATE, OPEN, CLOSE, INSERT, UPDATE, DELETE, VALIDATE> <procName>([<params,...>]);
  => ::addEvent(<"moment">, <"action">, {|o| o:execCommand(<'procName'>, o [,<params>])})

# command end dao;
  => return

# command extend dao <daoName> from <daoFrom>;
  => function xd_<daoName>();;
       local _dao := _d<daoFrom>;;
       local _fieldDefs := _dao:getFieldsMap()

# command user dao <daoName> from <daoFrom>;
  => function ud_<daoName>();;
       local _dao := _d<daoFrom>;;
       local _fieldDefs := _dao:getFieldsMap()

#endif