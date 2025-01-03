unit DMGlobal;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, DataSet.Serialize.Config, System.IOUtils;

type
  TDM = class(TDataModule)
    Conn: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
    procedure ConnBeforeConnect(Sender: TObject);
    procedure ConnAfterConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDM.ConnAfterConnect(Sender: TObject);
var
  vSQL : String;
begin
  {$REGION 'SQL CRIACAO TABELAS'}
  vSQL := ' CREATE TABLE IF NOT EXISTS CIDADE (                                                                                   '+
          '     CID_CODIGO         INTEGER NOT NULL PRIMARY KEY,                                                                  '+
          '     CID_NOME           VARCHAR(50),                                                                                   '+
          '     CID_UF             VARCHAR(2),                                                                                    '+
          '     CID_CEP            VARCHAR(9),                                                                                    '+
          '     MIB_CODIGO         INTEGER,                                                                                       '+
          '     CID_CODIGOIBGE     VARCHAR(20),                                                                                   '+
          '     CID_CODIGOUF       INTEGER,                                                                                       '+
          '     RE_CODIGO          INTEGER,                                                                                       '+
          '     PBA_CODIGO         INTEGER,                                                                                       '+
          '     CID_SITUACAO       VARCHAR(10),                                                                                   '+
          '     CID_DEDUCAO        DECIMAL(18,2),                                                                                 '+
          '     CID_ALIQUOTA       DECIMAL(18,2),                                                                                 '+
          '     CID_CODIGORECEITA  VARCHAR(6)                                                                                     '+
          ' );                                                                                                                    '+
          ' CREATE TABLE IF NOT EXISTS EMPRESA (                                                                                  '+
          '     EMP_CODIGO            INTEGER NOT NULL PRIMARY KEY,                                                               '+
          '     CID_CODIGO            INTEGER,                                                                                    '+
          '     EMP_NOME              VARCHAR(50),                                                                                '+
          '     EMP_RUA               VARCHAR(50),                                                                                '+
          '     EMP_NUMERO            CHAR(15),                                                                                   '+
          '     EMP_COMPLEMENTO       VARCHAR(50),                                                                                '+
          '     EMP_BAIRRO            VARCHAR(50),                                                                                '+
          '     EMP_FONE              VARCHAR(20),                                                                                '+
          '     EMP_FAX               VARCHAR(20),                                                                                '+
          '     EMP_EMAIL             VARCHAR(50),                                                                                '+
          '     EMP_CNPJ              VARCHAR(20),                                                                                '+
          '     EMP_IE                VARCHAR(20),                                                                                '+
          '     EMP_IM                VARCHAR(20),                                                                                '+
          '     EMP_CEP               VARCHAR(9),                                                                                 '+
          '     EMP_RAZAOSOCIAL       VARCHAR(80),                                                                                '+
          '     EMP_REGIMETRIBUTARIO  CHAR(1),                                                                                    '+
          '     FOREIGN KEY (CID_CODIGO) REFERENCES CIDADE (CID_CODIGO)                                                           '+
          ' );                                                                                                                    '+
          '                                                                                                                       '+
          ' CREATE TABLE IF NOT EXISTS USUARIO (                                                                                  '+
          '   USU_CODIGO     INTEGER NOT NULL PRIMARY KEY,                                                                        '+
          '   USU_NOME       VARCHAR(50),                                                                                         '+
          '   USU_LOGIN      VARCHAR(80),                                                                                         '+
          '   USU_SENHA      VARCHAR(80),                                                                                         '+
          '   EMP_CODIGO     INTEGER,                                                                                             '+
          '   USU_TOKENPUSH  VARCHAR(255),                                                                                        '+
          '   USU_SITUACAO   VARCHAR(20),                                                                                         '+
          '   USU_TOKENJWT   VARCHAR(100),                                                                                        '+
          '   IND_LOGIN      CHAR(1),                                                                                             '+
          '   IND_ONBOARDING CHAR(1),                                                                                             '+
          '   FOREIGN KEY (EMP_CODIGO) REFERENCES EMPRESA (EMP_CODIGO)                                                            '+
          ' );                                                                                                                    '+
          '                                                                                                                       '+
          ' CREATE TABLE IF NOT EXISTS CLIENTE (                                                                                  '+
          '     CLI_CODIGO_LOCAL        INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,                                               '+
          '     CID_CODIGO              INTEGER,                                                                                  '+
          '     CLI_NOME                VARCHAR(50),                                                                              '+
          '     CLI_ENDERECO            VARCHAR(50),                                                                              '+
          '     CLI_NUMERO              CHAR(15),                                                                                 '+
          '     CLI_BAIRRO              VARCHAR(50),                                                                              '+
          '     CLI_COMPLEMENTO         VARCHAR(50),                                                                              '+
          '     CLI_EMAIL               VARCHAR(1000),                                                                            '+
          '     CLI_TELEFONE            VARCHAR(20),                                                                              '+
          '     CLI_CEL                 VARCHAR(20),                                                                              '+
          '     CLI_CPF                 VARCHAR(20),                                                                              '+
          '     CLI_DATA_ULT_ALTERACAO  DATE,                                                                                     '+
          '     CLI_RG                  VARCHAR(50),                                                                              '+
          '     CLI_CNPJ                VARCHAR(20),                                                                              '+
          '     CLI_IE                  VARCHAR(20),                                                                              '+
          '     CLI_IM                  VARCHAR(20),                                                                              '+
          '     CLI_DATA_NASC           DATE,                                                                                     '+
          '     CLI_CEP                 VARCHAR(9),                                                                               '+
          '     CLI_RAZAOSOCIAL         VARCHAR(80),                                                                              '+
          '     CLI_EMPRESA             VARCHAR(50),                                                                              '+
          '     CLI_EMPRESAFONE         VARCHAR(20),                                                                              '+
          '     CLI_EMPRESAENDER        VARCHAR(50),                                                                              '+
          '     CLI_EMPRESANUMERO       VARCHAR(10),                                                                              '+
          '     CLI_EMPRESABAIRRO       VARCHAR(50),                                                                              '+
          '     CLI_EMRPESACOMPLE       VARCHAR(50),                                                                              '+
          '     CID_EMPRESA             INTEGER,                                                                                  '+
          '     CLI_TIPOPESSOA          CHAR(1),                                                                                  '+
          '     CLI_SITUACAORECEITA     VARCHAR(20),                                                                              '+
          '     CLI_DATASITUACAO        DATE,                                                                                     '+
          '     CLI_CLASSIFICACAO       CHAR(1),                                                                                  '+
          '     CLI_DATACADASTRO        DATE,                                                                                     '+
          '     USU_CODIGO_CADASTRO     INTEGER,                                                                                  '+
          '     CLI_SITUACAO            VARCHAR(10),                                                                              '+
          '     CLI_REGIMETRIBUTARIO    CHAR(1),                                                                                  '+
          '     CLI_OBS                 VARCHAR(5000),                                                                            '+
          '     CLI_SEXO                CHAR(1),                                                                                  '+
          '     CLI_CODIGO_OFICIAL      INTEGER,                                                                                  '+
          '     CLI_LIMITECREDITO      NUMERIC (12, 4),                                                                           '+
          '     CLI_IND_SINCRONIZAR    CHAR(1),                                                                                   '+
          ' FOREIGN KEY (CID_CODIGO) REFERENCES CIDADE (CID_CODIGO),                                                              '+
          ' FOREIGN KEY (CID_EMPRESA) REFERENCES CIDADE (CID_CODIGO),                                                             '+
          ' FOREIGN KEY (USU_CODIGO_CADASTRO) REFERENCES USUARIO (USU_CODIGO)                                                     '+
          ' );                                                                                                                    '+
          '                                                                                                                       '+
          '   CREATE TABLE IF NOT EXISTS FUNCIONARIO (                                                                            '+
          '       FUNC_CODIGO    INTEGER NOT NULL PRIMARY KEY,                                                                    '+
          '       FUNC_NOME      VARCHAR(50),                                                                                     '+
          '       FUNC_TELEFONE  VARCHAR(20),                                                                                     '+
          '       FUNC_CELULAR   VARCHAR(20),                                                                                     '+
          '       FUNC_RG        VARCHAR(20),                                                                                     '+
          '       FUNC_CPF       VARCHAR(20),                                                                                     '+
          '       FUNC_EMAIL     VARCHAR(80),                                                                                     '+
          '       USU_CODIGO     INTEGER,                                                                                         '+
          '       EMP_CODIGO     INTEGER,                                                                                         '+
          '       FUNC_SITUACAO  VARCHAR(10),                                                                                     '+
          '       FUNC_SEXO      CHAR(1),                                                                                         '+
          '   FOREIGN KEY (USU_CODIGO) REFERENCES USUARIO (USU_CODIGO),                                                           '+
          '   FOREIGN KEY (EMP_CODIGO) REFERENCES EMPRESA (EMP_CODIGO)                                                            '+
          ');                                                                                                                     '+
          '   CREATE TABLE IF NOT EXISTS CONTASCLASSIFICACAO (                                                                    '+
          '   CLAS_CODIGO     INTEGER NOT NULL PRIMARY KEY,                                                                       '+
          '   CLAS_DESCRICAO  VARCHAR(80)                                                                                         '+
          ' );                                                                                                                    '+
          '                                                                                                                       '+
          '                                                                                                                       '+
          ' CREATE TABLE IF NOT EXISTS OSSTATUS (                                                                                 '+
          '     OSS_CODIGO     INTEGER NOT NULL PRIMARY KEY,                                                                      '+
          '     OSS_DESCRICAO  VARCHAR(150),                                                                                      '+
          '     OSS_SITUACAO   VARCHAR(20)                                                                                        '+
          ' );                                                                                                                    '+
          '                                                                                                                       '+
          '                                                                                                                       '+
          ' CREATE TABLE IF NOT EXISTS OS (                                                                                       '+
          '     OS_CODIGO_LOCAL                INTEGER NOT NULL PRIMARY KEY,                                                      '+
          '     FUNC_CODIGO                    INTEGER,                                                                           '+
          '     CLI_CODIGO_LOCAL               INTEGER,                                                                           '+
          '     OS_DATAABERTURA                DATE,                                                                              '+
          '     OS_HORAABERTURA                TIME,                                                                              '+
          '     OS_SOLICITACAO                 VARCHAR(5000),                                                                     '+
          '     OS_SITUACAO                    VARCHAR(50),                                                                       '+
          '     OS_DATAENCERRAMENTO            DATE,                                                                              '+
          '     FPG_CODIGO                     INTEGER,                                                                           '+
          '     OS_HORARETIRADA                TIME,                                                                              '+
          '     OS_TOTALSERVICOS               DECIMAL(18,2),                                                                     '+
          '     OS_DESCONTOPRODUTO             DECIMAL(18,2),                                                                     '+
          '     OS_DESCONTOSERVICO             DECIMAL(18,2),                                                                     '+
          '     USU_CODIGO                     INTEGER,                                                                           '+
          '     OS_TIPO                        CHAR(1),                                                                           '+
          '     OS_TOTALPRODUTOS               DECIMAL(18,2),                                                                     '+
          '     OS_TOTALGERAL                  DECIMAL(18,2),                                                                     '+
          '     EMP_CODIGO                     INTEGER,                                                                           '+
          '     OS_CODIGOLOCAL                 INTEGER,                                                                           '+
          '     OS_TOTSERVICOSTERC             DECIMAL(18,2),                                                                     '+
          '     OS_DESCONTOSERVICOSTERC        DECIMAL(18,2),                                                                     '+
          '     OS_OBSINTERNA                  VARCHAR(5000),                                                                     '+
          '     USU_CODIGO_ENCERRA             INTEGER,                                                                           '+
          '     OS_CODRESPONSAVELABERTURA      INTEGER,                                                                           '+
          '     OS_CODRESPONSAVELENCERRAMENTO  INTEGER,                                                                           '+
          '     CLAS_CODIGO                    INTEGER,                                                                           '+
          '     OSS_CODIGO                     INTEGER,                                                                           '+
          '     OS_DATAULTIMAALTERACAO         DATE,                                                                              '+
          '     OS_CODIGO_OFICIAL              INTEGER,                                                                           '+
          ' FOREIGN KEY (FPG_CODIGO) REFERENCES FORMAPAGAMENTO (FPG_CODIGO),                                                      '+
          ' FOREIGN KEY (USU_CODIGO_ENCERRA) REFERENCES USUARIO (USU_CODIGO),                                                     '+
          ' FOREIGN KEY (OS_CODRESPONSAVELABERTURA) REFERENCES FUNCIONARIO (FUNC_CODIGO),                                         '+
          ' FOREIGN KEY (OS_CODRESPONSAVELENCERRAMENTO) REFERENCES FUNCIONARIO (FUNC_CODIGO),                                     '+
          ' FOREIGN KEY (CLAS_CODIGO) REFERENCES CONTASCLASSIFICACAO (CLAS_CODIGO),                                               '+
          ' FOREIGN KEY (OSS_CODIGO) REFERENCES OSSTATUS (OSS_CODIGO),                                                            '+
          ' FOREIGN KEY (FUNC_CODIGO) REFERENCES FUNCIONARIO (FUNC_CODIGO),                                                       '+
          ' FOREIGN KEY (USU_CODIGO) REFERENCES USUARIO (USU_CODIGO),                                                             '+
          ' FOREIGN KEY (CLI_CODIGO_LOCAL) REFERENCES CLIENTE (CLI_CODIGO_LOCAL),                                                 '+
          ' FOREIGN KEY (EMP_CODIGO) REFERENCES EMPRESA (EMP_CODIGO)                                                              '+
          ' );                                                                                                                    '+
          '                                                                                                                       '+
          ' CREATE TABLE IF NOT EXISTS PRODUTOUNIDADE (                                                                           '+
          '     UNI_SIGLA      VARCHAR(6) NOT NULL PRIMARY KEY,                                                                   '+
          '     UNI_DESCRICAO  VARCHAR(50),                                                                                       '+
          '     UNI_SIGLASPED  VARCHAR(6),                                                                                        '+
          '     UNI_CODIGOWEB  INTEGER,                                                                                           '+
          '     UNI_MGZ_ID     INTEGER                                                                                            '+
          ' );                                                                                                                    '+
          '                                                                                                                       '+
          ' CREATE TABLE IF NOT EXISTS PRODUTOFABRICANTE (                                                                        '+
          '     FAB_CODIGO  INTEGER NOT NULL PRIMARY KEY,                                                                         '+
          '     FAB_NOME    VARCHAR(50)                                                                                           '+
          ' );                                                                                                                    '+
          '                                                                                                                       '+
          ' CREATE TABLE IF NOT EXISTS PRODUTOGRUPO (                                                                             '+
          '     GRU_CODIGO     INTEGER NOT NULL PRIMARY KEY,                                                                      '+
          '     GRU_DESCRICAO  VARCHAR(50)                                                                                        '+
          ' );                                                                                                                    '+
          '                                                                                                                       '+
          ' CREATE TABLE IF NOT EXISTS PRODUTO (                                                                                  '+
          '     PROD_CODIGO_LOCAL       INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,                                               '+
          '     GRU_CODIGO              INTEGER,                                                                                  '+
          '     FAB_CODIGO              INTEGER,                                                                                  '+
          '     PROD_ESTOQUE            DECIMAL(18,4),                                                                            '+
          '     UNI_SIGLA               VARCHAR(6),                                                                               '+
          '     PROD_CODIGO_BARRA       VARCHAR(50),                                                                              '+
          '     PROD_REFERENCIA         VARCHAR(50),                                                                              '+
          '     PROD_DESCRICAO          VARCHAR(120),                                                                             '+
          '     PROD_VALORCUSTO         DECIMAL(18,4),                                                                            '+
          '     PROD_LUCRO              DECIMAL(18,2),                                                                            '+
          '     PROD_VALORVENDA         DECIMAL(18,4),                                                                            '+
          '     PROD_SITUACAO           VARCHAR(10),                                                                              '+
          '     PROD_VALORCOMPRA        DECIMAL(18,4),                                                                            '+
          '     UNI_SIGLACOMPRA         VARCHAR(6),                                                                               '+
          '     PROD_NCM                VARCHAR(10),                                                                              '+
          '     PROD_PESOLIQUIDO        DECIMAL(18,4),                                                                            '+
          '     PROD_PESOBRUTO          DECIMAL(18,4),                                                                            '+
          '     PROD_DTULTIMAOS         DATE,                                                                                     '+
          '     PTIPO_CODIGO            INTEGER,                                                                                  '+
          '     PROD_DTULTIMAALTERACAO  DATE,                                                                                     '+
          '     PROD_INFADICIONAIS      VARCHAR(5000),                                                                            '+
          '     PROD_OBS                VARCHAR(5000),                                                                            '+
          '     PROD_CEST               VARCHAR(7),                                                                               '+
          '     FOTO                    BLOB,                                                                                     '+
          '     PROD_IND_SINCRONIZAR    CHAR(1),                                                                                  '+
          ' FOREIGN KEY (GRU_CODIGO) REFERENCES PRODUTOGRUPO (GRU_CODIGO),                                                        '+
          ' FOREIGN KEY (FAB_CODIGO) REFERENCES PRODUTOFABRICANTE (FAB_CODIGO),                                                   '+
          ' FOREIGN KEY (UNI_SIGLA) REFERENCES PRODUTOUNIDADE (UNI_SIGLA),                                                        '+
          ' FOREIGN KEY (UNI_SIGLACOMPRA) REFERENCES PRODUTOUNIDADE (UNI_SIGLA)                                                   '+
          ');                                                                                                                     '+
          '                                                                                                                       '+
          ' CREATE TABLE IF NOT EXISTS FORMAPAGAMENTO (                                                                           '+
          '     FPG_CODIGO               INTEGER NOT NULL PRIMARY KEY,                                                            '+
          '     FPG_DESCRICAO            VARCHAR(50),                                                                             '+
          '     FPG_INTERVALOENTREDIAS   INTEGER,                                                                                 '+
          '     FPG_NUMEROPARCELAS       INTEGER,                                                                                 '+
          '     FPG_PRIMERIROVENCIMENTO  INTEGER,                                                                                 '+
          '     FPG_CODPGTOECF           VARCHAR(10),                                                                             '+
          '     FPG_PERCJURO             DECIMAL(18,2),                                                                           '+
          '     FPG_CODIGOMATRIZ         INTEGER,                                                                                 '+
          '     FPG_SITUACAO             VARCHAR(10),                                                                             '+
          '     FPG_DIAVENCIMENTO        VARCHAR(3),                                                                              '+
          '     FPG_CODIGOWEB            INTEGER,                                                                                 '+
          '     FPG_ATUALIZAWEB          CHAR(1),                                                                                 '+
          '     FPG_DATAFIXA             CHAR(1),                                                                                 '+
          '     FPG_DATAFIXAFORMATO      DATE,                                                                                    '+
          '     MPG_CODIGO               INTEGER,                                                                                 '+
          '     FPG_ACRESRENEGOCIACAO    DECIMAL(18,2),                                                                           '+
          '     FPG_MGZ_ID               INTEGER                                                                                  '+
          ' );                                                                                                                    '+
          '                                                                                                                       '+
          ' CREATE TABLE IF NOT EXISTS OSPRODUTO (                                                                                '+
          '     OS_CODIGO_LOCAL      INTEGER NOT NULL,                                                                            '+
          '     PROD_CODIGO          INTEGER NOT NULL,                                                                            '+
          '     PROD_CODIGO_BARRA    VARCHAR(50),                                                                                 '+
          '     PROD_DESCRICAO       VARCHAR(150),                                                                                '+
          '     OSP_QUANTIDADE       DECIMAL(18,4),                                                                               '+
          '     OSP_VALOR            DECIMAL(18,4),                                                                               '+
          '     OSP_DESCONTO         DECIMAL(18,4),                                                                               '+
          '     OSP_CUSTO            DECIMAL(18,2),                                                                               '+
          '     OSP_DATA             DATE,                                                                                        '+
          '     OSP_CODIGO           INTEGER NOT NULL,                                                                            '+
          '     OSP_QUANTIDADEDEV    DECIMAL(18,4),                                                                               '+
          '     OSP_FABRICANTE       VARCHAR(50),                                                                                 '+
          '     OSP_TIPO             VARCHAR(20),                                                                                 '+
          '     OSP_ACRESCIMO        DECIMAL(18,4),                                                                               '+
          '     OSP_VLRCOMACRESCIMO  DECIMAL(18,4),                                                                               '+
          '     OSP_VFRETE           DECIMAL(18,2),                                                                               '+
          '     OSP_UNI_SIGLA        VARCHAR(6),                                                                                  '+
          '     OSP_DESCONTOTOTAL    DECIMAL(18,2),                                                                               '+
          '     OSP_ACRESCIMOTOTAL   DECIMAL(18,2),                                                                               '+
          '     OSP_TOTAL            DECIMAL(18,2),                                                                               '+
          '     PRIMARY KEY (OS_CODIGO_LOCAL, PROD_CODIGO, OSP_CODIGO),                                                           '+
          '     FOREIGN KEY (OS_CODIGO_LOCAL) REFERENCES OS (OS_CODIGO_LOCAL)                                                     '+
          ' );                                                                                                                    '+
          '                                                                                                                       '+
          ' CREATE TABLE IF NOT EXISTS OSSERVICO (                                                                                '+
          '     OSS_CODIGO                  INTEGER NOT NULL,                                                                     '+
          '     OS_CODIGO_LOCAL             INTEGER NOT NULL,                                                                     '+
          '     SE_CODIGO                   INTEGER,                                                                              '+
          '     OSS_DESCRICAO               VARCHAR(150),                                                                         '+
          '     OSS_VALOR                   DECIMAL(18,2),                                                                        '+
          '     OSS_DESCONTO                DECIMAL(18,4),                                                                        '+
          '     OSS_QUANTIDADE              DECIMAL(18,4),                                                                        '+
          '     OSS_DATA                    DATE,                                                                                 '+
          '     FUNC_CODIGO                 INTEGER,                                                                              '+
          '     OSS_OBS                     VARCHAR(5000),                                                                        '+
          '     OSS_UNI_SIGLA               VARCHAR(6),                                                                           '+
          '     OSS_DESCONTOTOTAL           DECIMAL(18,2),                                                                        '+
          '     OSS_TOTAL                   DECIMAL(18,2),                                                                        '+
          '     OSS_NOMETECNICORESPONSAVEL  VARCHAR(50),                                                                          '+
          '     PRIMARY KEY (OSS_CODIGO, OS_CODIGO_LOCAL),                                                                        '+
          '     FOREIGN KEY (OS_CODIGO_LOCAL) REFERENCES OS (OS_CODIGO_LOCAL),                                                    '+
          '     FOREIGN KEY (FUNC_CODIGO) REFERENCES FUNCIONARIO (FUNC_CODIGO)                                                    '+
          ' );                                                                                                                    '+
          '                                                                                                                       '+
          ' CREATE TABLE IF NOT EXISTS OSSERVICOTERCEIROS (                                                                       '+
          '     OSST_CODIGO                 INTEGER NOT NULL,                                                                     '+
          '     OS_CODIGO_LOCAL             INTEGER NOT NULL,                                                                     '+
          '     SE_CODIGO                   INTEGER,                                                                              '+
          '     OSST_DESCRICAO              VARCHAR(150),                                                                         '+
          '     OSST_VALOR                  DECIMAL(18,2),                                                                        '+
          '     OSST_DESCONTO               DECIMAL(18,4),                                                                        '+
          '     OSST_QUANTIDADE             DECIMAL(18,4),                                                                        '+
          '     OSST_DATA                   DATE,                                                                                 '+
          '     OSST_CUSTO                  DECIMAL(18,2),                                                                        '+
          '     FUNC_CODIGO                 INTEGER,                                                                              '+
          '     OSST_OBS                    VARCHAR(5000),                                                                        '+
          '     OSST_UN_MEDIDA              VARCHAR(3),                                                                           '+
          '     OSST_DESCONTOTOTAL          DECIMAL(18,2),                                                                        '+
          '     OSST_TOTAL                  DECIMAL(18,2),                                                                        '+
          '     OSS_NOMETECNICORESPONSAVEL  VARCHAR(50),                                                                          '+
          '     PRIMARY KEY (OSST_CODIGO, OS_CODIGO_LOCAL),                                                                       '+
          '     FOREIGN KEY (OS_CODIGO_LOCAL) REFERENCES OS (OS_CODIGO_LOCAL),                                                    '+
          '     FOREIGN KEY (FUNC_CODIGO) REFERENCES FUNCIONARIO (FUNC_CODIGO)                                                    '+
          ' );                                                                                                                    '+
          '                                                                                                                       '+
          ' CREATE TABLE IF NOT EXISTS NOTIFICACAO (                                                                              '+
          '     NOT_CODIGO    INTEGER NOT NULL PRIMARY KEY,                                                                       '+
          '     NOT_DATA      TIMESTAMP,                                                                                          '+
          '     NOT_TITULO    VARCHAR(100),                                                                                       '+
          '     NOT_TEXTO     VARCHAR(500),                                                                                       '+
          '     NOT_IND_LIDO  CHAR(1)                                                                                             '+
          ' );                                                                                                                    '+
          '                                                                                                                       '+
          '     CREATE TABLE IF NOT EXISTS TAB_CONFIG (                                                                           '+
          '     CAMPO VARCHAR (50)  PRIMARY KEY NOT NULL,                                                                         '+
          '     VALOR VARCHAR (200)                                                                                               '+
          ' );                                                                                                                    '+
          '                                                                                                                       '+
          ' CREATE TABLE IF NOT EXISTS OSPRODUTO_TEMP (                                                                           '+
          '     OSP_CODIGO         INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,                                                    '+
          '     PROD_CODIGO_LOCAL  INTEGER,                                                                                       '+
          '     OSP_QUANTIDADE     INTEGER,                                                                                       '+
          '     OSP_VALOR          DECIMAL (12, 2),                                                                               '+
          '     OSP_TOTAL          DECIMAL (12, 2),                                                                               '+
          ' FOREIGN KEY (PROD_CODIGO_LOCAL) REFERENCES PRODUTO (PROD_CODIGO_LOCAL)                                                '+
          ');                                                                                                                     '+
          '                                                                                                                       '+
          ' CREATE TABLE IF NOT EXISTS OSSERVICO_TEMP (                                                                           '+
          '     OSS_CODIGO       INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,                                                      '+
          '     OS_CODIGO_LOCAL  INTEGER NOT NULL,                                                                                '+
          '     SE_CODIGO_LOCAL  INTEGER,                                                                                         '+
          '     OSS_QUANTIDADE   INTEGER,                                                                                         '+
          '     OSS_VALOR        DECIMAL (12, 2),                                                                                 '+
          '     OSS_TOTAL        DECIMAL (12, 2)                                                                                  '+
          ');                                                                                                                     '+
          '                                                                                                                       '+
          ' CREATE TABLE IF NOT EXISTS OSSERVICOTERCEIROS_TEMP (                                                                  '+
          '     OSST_CODIGO      INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,                                                      '+
          '     OS_CODIGO_LOCAL  INTEGER NOT NULL,                                                                                '+
          '     SE_CODIGO_LOCAL  INTEGER,                                                                                         '+
          '     OSST_QUANTIDADE  INTEGER,                                                                                         '+
          '     OSST_VALOR       DECIMAL (12, 2),                                                                                 '+
          '     OSST_TOTAL       DECIMAL (12, 2)                                                                                  '+
          ');                                                                                                                     ';
  {$ENDREGION}

  Conn.ExecSQL(vSQL);


end;

procedure TDM.ConnBeforeConnect(Sender: TObject);
begin
  Conn.DriverName := 'SQLite';
  {$IFDEF MSWINDOWS}
  Conn.Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\APPOS.db';
  {$ELSE}
  Conn.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'APPOS.db');
  {$ENDIF}
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition      := cndLower;
  TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';
  Conn.Connected := True;
end;

end.
