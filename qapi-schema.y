%{
package main


%}

// QAPI tokens:

%token STR NUMBER SIZE BOOL NULL ANY QTYPE STRUCT
%token INT INT8 INT32 INT64
%token UINT8 UINT16 UINT32 UINT64
%token INCLUDE PRAGMA
%token ENUM STRUCT UNION ALTERNATE COMMAND EVENT



%%

specification
    : directive_list
    | definition_list
    ;

value
    : IDENTIFIER
    | CONSTANT
    ;

directive_list
    : directive ';'
    | directive ';' directive_list
    ;

directive
    : include
    | pragma
    ;


definition_list
    : definition ';'
    | definition ';' definition_list
    ;

definition
    : enum
    | struct
    | union
    | alternate
    | command
    | event
    ;

include
    : 
    ;

pragma
    : PRAGMA 
    { 'pragma': {
               '*doc-required': BOOL,
               '*command-name-exceptions': [ STRING, ... ],
               '*command-returns-exceptions': [ STRING, ... ],
               '*member-name-exceptions': [ STRING, ... ] } }
    ;

enum
   :{ 'enum': STRING,
         'data': [ ENUM-VALUE, ... ],
         '*prefix': STRING,
         '*if': COND,
         '*features': FEATURES }
   ;

struct
   :{ 'struct': STRING,
           'data': MEMBERS,
           '*base': STRING,
           '*if': COND,
           '*features': FEATURES }  
   ;

union
   :{ 'union': STRING,
          'data': BRANCHES,
          '*if': COND,
          '*features': FEATURES }
      | { 'union': STRING,
          'data': BRANCHES,
          'base': ( MEMBERS | STRING ),
          'discriminator': STRING,
          '*if': COND,
          '*features': FEATURES }
   ;

alternate
   :{ 'alternate': STRING,
              'data': ALTERNATIVES,
              '*if': COND,
              '*features': FEATURES }
   ;

command
   :{ 'command': STRING,
            (
            '*data': ( MEMBERS | STRING ),
            |
            'data': STRING,
            'boxed': true,
            )
            '*returns': TYPE-REF,
            '*success-response': false,
            '*gen': false,
            '*allow-oob': true,
            '*allow-preconfig': true,
            '*coroutine': true,
            '*if': COND,
            '*features': FEATURES }
   ;

event
   :{ 'event': STRING,
          (
          '*data': ( MEMBERS | STRING ),
          |
          'data': STRING,
          'boxed': true,
          )
          '*if': COND,
          '*features': FEATURES }
   ;

%%



