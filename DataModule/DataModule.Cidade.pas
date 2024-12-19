unit DataModule.Cidade;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TDMCidade = class(TDataModule)
    QryConsCidade: TFDQuery;
  private
    function fFiltros(pBusca: String): String;
    { Private declarations }
  public
    procedure fListarCidades(pPagina: Integer; pBusca: String);
    procedure fListarCidadeID(pCodCidade: Integer);

    { Public declarations }
  end;

var
  DMCidade: TDMCidade;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses DMGlobal, uConstantes;

{$R *.dfm}

procedure TDMCidade.fListarCidades(pPagina: Integer; pBusca: String);
begin
  QryConsCidade.Active := False;
  QryConsCidade.SQL.Clear;

  QryConsCidade.SQL.Text :=
    ' SELECT                       ' +
    ' CID_CODIGO,                  ' +
    ' CID_NOME,                    ' +
    ' CID_UF,                      ' +
    ' CID_CEP                      ' +
    ' FROM CIDADE                  ' +
    ' WHERE CID_CODIGO > 0         ' +
    fFiltros(pBusca)                 +
    ' ORDER BY CID_NOME DESC       ';

  if pPagina > 0 then
  begin
    QryConsCidade.SQL.Add('LIMIT :PAGINA, :QTD_REG');
    QryConsCidade.ParamByName('PAGINA').AsInteger  := (pPagina - 1) * cQTD_REG_PAGINA_CIDADE;
    QryConsCidade.ParamByName('QTD_REG').AsInteger := cQTD_REG_PAGINA_CIDADE;
  end;

  if pBusca <> '' then
  begin
    QryConsCidade.ParamByName('CID_NOME').AsString := '%' + pBusca + '%';
  end;

  QryConsCidade.Open;
end;

function TDMCidade.fFiltros(pBusca: String): String;
begin
  Result := '';
  if pBusca <> '' then
  begin
    Result := ' AND (CID_NOME LIKE :CID_NOME) ';
  end;
end;

procedure TDMCidade.fListarCidadeID(pCodCidade: Integer);
begin
  QryConsCidade.SQL.Clear;

  QryConsCidade.SQL.Text :=
    ' SELECT                         ' +
    ' CID_CODIGO,                    ' +
    ' CID_NOME,                      ' +
    ' CID_UF,                        ' +
    ' CID_CEP                        ' +
    ' FROM CIDADE                    ' +
    ' WHERE CID_CODIGO = :CID_CODIGO ';

  QryConsCidade.ParamByName('CID_CODIGO').AsInteger := pCodCidade;

  QryConsCidade.Open;
end;



end.
