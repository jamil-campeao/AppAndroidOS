unit DataModule.Produto;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TDMProduto = class(TDataModule)
    QryConsProduto: TFDQuery;
  private
    function fFiltros(pBusca: String): String;
    { Private declarations }
  public
    procedure fListarProdutos(pPagina: Integer; pBusca: String);

    { Public declarations }
  end;

var
  DMProduto: TDMProduto;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses DMGlobal, uConstantes;

{$R *.dfm}

procedure TDMProduto.fListarProdutos(pPagina: Integer; pBusca: String);
begin
  QryConsProduto.Active := False;
  QryConsProduto.SQL.Clear;

  QryConsProduto.SQL.Text :=
    ' SELECT                                        '+
    ' P.PROD_CODIGO_LOCAL,                          '+
    ' P.PROD_DESCRICAO,                             '+
    ' P.PROD_VALORVENDA,                            '+
    ' P.PROD_ESTOQUE                                '+
    ' FROM PRODUTO P                                '+
    ' WHERE P.PROD_CODIGO_LOCAL > 0                 '+
    fFiltros(pBusca)                                 +
    ' ORDER BY 1 DESC                               ';

  if pPagina > 0 then
  begin
    QryConsProduto.SQL.Add('LIMIT :PAGINA, :QTD_REG');
    QryConsProduto.ParamByName('PAGINA').AsInteger  := (pPagina - 1) * cQTD_REG_PAGINA_PRODUTO;
    QryConsProduto.ParamByName('QTD_REG').AsInteger := cQTD_REG_PAGINA_PRODUTO;
  end;

  if pBusca <> '' then
    QryConsProduto.ParamByName('PROD_DESCRICAO').AsString := '%' + pBusca + '%';

  QryConsProduto.Open;
end;

function TDMProduto.fFiltros(pBusca: String): String;
begin
  Result := '';
  if pBusca <> '' then
    Result := ' AND (P.PROD_DESCRICAO LIKE :PROD_DESCRICAO)';
end;


end.
