unit DataModule.Cliente;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TDMCliente = class(TDataModule)
    QryConsCliente: TFDQuery;
  private
    function fFiltros(pBusca: String): String;
    { Private declarations }
  public
    procedure fListarClientes(pPagina: Integer; pBusca: String);

    { Public declarations }
  end;

var
  DMCliente: TDMCliente;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses DMGlobal, uConstantes;

{$R *.dfm}

procedure TDMCliente.fListarClientes(pPagina: Integer; pBusca: String);
begin
  QryConsCliente.Active := False;
  QryConsCliente.SQL.Clear;

  QryConsCliente.SQL.Text :=
    ' SELECT C.*, CID.CID_NOME, CID.CID_UF FROM CLIENTE C    ' +
    ' LEFT JOIN CIDADE CID                                   ' +
    '  ON C.CID_CODIGO = CID.CID_CODIGO                      ' +
    ' LEFT JOIN CIDADE CID2                                  ' +
    '  ON C.CID_EMPRESA = CID2.CID_CODIGO                    ' +
    ' LEFT JOIN USUARIO U                                    ' +
    '  ON C.USU_CODIGO_CADASTRO = U.USU_CODIGO               ' +
    ' WHERE C.CLI_CODIGO_LOCAL > 0                           ' +
    fFiltros(pBusca)                                           +
    ' ORDER BY C.CLI_CODIGO_LOCAL DESC           ';

  if pPagina > 0 then
  begin
    QryConsCliente.SQL.Add('LIMIT :PAGINA, :QTD_REG');
    QryConsCliente.ParamByName('PAGINA').AsInteger  := (pPagina - 1) * cQTD_REG_PAGINA_CLIENTE;
    QryConsCliente.ParamByName('QTD_REG').AsInteger := cQTD_REG_PAGINA_CLIENTE;
  end;

  if pBusca <> '' then
  begin
    QryConsCliente.ParamByName('CLI_NOME').AsString := '%' + pBusca + '%';

    try
      QryConsCliente.ParamByName('CLI_CODIGO_LOCAL').AsInteger := StrToInt(pBusca);
    except
      QryConsCliente.ParamByName('CLI_CODIGO_LOCAL').AsInteger := 0;
    end;
  end;

  QryConsCliente.Open;
end;

function TDMCliente.fFiltros(pBusca: String): String;
begin
  Result := '';
  if pBusca <> '' then
  begin
    Result := ' AND (C.CLI_NOME LIKE :CLI_NOME              ' +
              '  OR C.CLI_CODIGO_LOCAL = :CLI_CODIGO_LOCAL) ';
  end;
end;



end.
