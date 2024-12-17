unit DataModule.OS;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TDMOS = class(TDataModule)
    QryConsOS: TFDQuery;
  private
    function fFiltros(pBusca: String) : String;

    { Private declarations }
  public
    procedure fListarOS(pPagina: Integer; pBusca: String);
    { Public declarations }
  end;

var
  DMOS: TDMOS;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses DMGlobal, uConstantes;

{$R *.dfm}

procedure TDMOS.fListarOS(pPagina: Integer; pBusca: String);
begin
  QryConsOS.Active := False;
  QryConsOS.SQL.Clear;

  QryConsOS.SQL.Text :=
    ' SELECT O.*, C.CLI_NOME FROM OS O                     ' +
    ' LEFT JOIN FUNCIONARIO F1                             ' +
    '  ON O.FUNC_CODIGO = F1.FUNC_CODIGO                   ' +
    ' LEFT JOIN CLIENTE C                                  ' +
    '  ON O.CLI_CODIGO_LOCAL = C.CLI_CODIGO_LOCAL          ' +
    ' LEFT JOIN FORMAPAGAMENTO FP                          ' +
    '  ON O.FPG_CODIGO = FP.FPG_CODIGO                     ' +
    ' LEFT JOIN USUARIO U1                                 ' +
    '  ON O.USU_CODIGO = U1.USU_CODIGO                     ' +
    ' LEFT JOIN EMPRESA E                                  ' +
    '  ON O.EMP_CODIGO = E.EMP_CODIGO                      ' +
    ' LEFT JOIN USUARIO U2                                 ' +
    '  ON O.USU_CODIGO_ENCERRA = U2.USU_CODIGO             ' +
    ' LEFT JOIN FUNCIONARIO F2                             ' +
    '  ON O.OS_CODRESPONSAVELABERTURA = F2.FUNC_CODIGO     ' +
    ' LEFT JOIN FUNCIONARIO F3                             ' +
    '  ON O.OS_CODRESPONSAVELENCERRAMENTO = F3.FUNC_CODIGO ' +
    ' LEFT JOIN CONTASCLASSIFICACAO CLAS                   ' +
    '  ON O.CLAS_CODIGO = CLAS.CLAS_CODIGO                 ' +
    ' LEFT JOIN OSSTATUS OSS                               ' +
    '  ON O.OSS_CODIGO = OSS.OSS_CODIGO                    ' +
    ' WHERE O.OS_CODIGO_LOCAL > 0                          ' +
    fFiltros(pBusca)                                         +
    ' ORDER BY OS_CODIGO_LOCAL DESC                         ';

  if pPagina > 0 then
  begin
    QryConsOS.SQL.Add('LIMIT :PAGINA, :QTD_REG');
    QryConsOS.ParamByName('PAGINA').AsInteger  := (pPagina - 1) * cQTD_REG_PAGINA_OS;
    QryConsOS.ParamByName('QTD_REG').AsInteger := cQTD_REG_PAGINA_OS;
  end;

  if pBusca <> '' then
  begin
    QryConsOS.ParamByName('CLI_NOME').AsString := '%' + pBusca + '%';

    try
      QryConsOS.ParamByName('OS_CODIGO_LOCAL').AsInteger := StrToInt(pBusca);
    except
      QryConsOS.ParamByName('OS_CODIGO_LOCAL').AsInteger := 0;
    end;

    try
      QryConsOS.ParamByName('OS_CODIGO_OFICIAL').AsInteger := StrToInt(pBusca);
    except
      QryConsOS.ParamByName('OS_CODIGO_OFICIAL').AsInteger := 0;
    end;
  end;

  QryConsOS.Open;
end;

function TDMOS.fFiltros(pBusca: String): String;
begin
  Result := '';
  if pBusca <> '' then
  begin
    Result := ' AND (C.CLI_NOME LIKE :CLI_NOME                ' +
              '  OR O.OS_CODIGO_LOCAL = :OS_CODIGO_LOCAL      ' +
              '  OR O.OS_CODIGO_OFICIAL = :OS_CODIGO_OFICIAL) ';
  end;
end;


end.
