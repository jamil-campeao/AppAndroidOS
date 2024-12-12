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
  vSQL := ' CREATE TABLE IF NOT EXISTS USUARIO (             ' +
          ' USU_CODIGO     INTEGER NOT NULL PRIMARY KEY,     ' +
          ' USU_NOME       VARCHAR(50),                      ' +
          ' USU_LOGIN      VARCHAR(80),                      ' +
          ' USU_SENHA      VARCHAR(80),                      ' +
          ' EMP_CODIGO     INTEGER,                          ' +
          ' USU_TOKENPUSH  VARCHAR(255),                     ' +
          ' USU_SITUACAO   VARCHAR(20),                      ' +
          ' USU_TOKENJWT   VARCHAR(100),                     ' +
          ' IND_LOGIN      CHAR(1),                          ' +
          ' IND_ONBOARDING CHAR(1));                         ';
  Conn.ExecSQL(vSQL);


end;

procedure TDM.ConnBeforeConnect(Sender: TObject);
begin
  Conn.DriverName := 'SQLite';
  {$IFDEF MSWINDOWS}
  Conn.Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\OS.db';
  {$ELSE}
  Conn.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'OS.db');
  {$ENDIF}
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition      := cndLower;
  TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';
  Conn.Connected := True;
end;

end.
