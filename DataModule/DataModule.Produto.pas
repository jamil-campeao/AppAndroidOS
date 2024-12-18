unit DataModule.Produto;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Graphics;

type
  TDMProduto = class(TDataModule)
    QryConsProduto: TFDQuery;
    QryProduto: TFDQuery;
  private
    function fFiltros(pBusca: String): String;
    { Private declarations }
  public
    procedure fListarProdutos(pPagina: Integer; pBusca: String);
    procedure fListarProdutoId(pCodProdutoLocal: Integer);
    procedure fInserirProduto(pDescricao: String; pValor, pQtdEstoque: Double;
      pFoto: TBitmap);
    procedure fEditarProduto(pCodProdutoLocal: Integer; pDescricao: String;
      pValor, pQtdEstoque: Double; pFoto: TBitmap);

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
    ' P.PROD_ESTOQUE,                               '+
    ' P.FOTO                                        '+
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


procedure TDMProduto.fListarProdutoId(pCodProdutoLocal: Integer);
begin
  QryProduto.Active := False;
  QryProduto.SQL.Clear;

  QryProduto.SQL.Text :=
    ' SELECT                                         '+
    ' P.PROD_CODIGO_LOCAL,                           '+
    ' P.PROD_DESCRICAO,                              '+
    ' P.PROD_VALORVENDA,                             '+
    ' P.PROD_ESTOQUE,                                '+
    ' P.FOTO                                         '+
    ' FROM PRODUTO P                                 '+
    ' WHERE P.PROD_CODIGO_LOCAL = :PROD_CODIGO_LOCAL '+
    ' ORDER BY 1 DESC                                ';

  QryProduto.ParamByName('PROD_CODIGO_LOCAL').AsInteger := pCodProdutoLocal;

  QryProduto.Open;
end;

procedure TDMProduto.fInserirProduto(pDescricao: String; pValor, pQtdEstoque: Double; pFoto: TBitmap);
var
  vCodProdAux : Integer;
begin
  QryProduto.SQL.Clear;

  QryProduto.SQL.Text := 'SELECT MAX(PROD_CODIGO_LOCAL) AS PROD_CODIGO_LOCAL FROM PRODUTO ';
  QryProduto.Open;
  vCodProdAux := QryProduto.FieldByName('PROD_CODIGO_LOCAL').AsInteger;

  QryProduto.SQL.Clear;

  QryProduto.SQL.Text :=
    ' INSERT INTO PRODUTO                                                                             '+
    ' (PROD_CODIGO_LOCAL, PROD_DESCRICAO, PROD_VALORVENDA, PROD_ESTOQUE, FOTO, IND_SINCRONIZAR)       '+
    ' VALUES                                                                                          '+
    ' (:PROD_CODIGO_LOCAL, :PROD_DESCRICAO, :PROD_VALORVENDA, :PROD_ESTOQUE, :FOTO, :IND_SINCRONIZAR) ';

  QryProduto.ParamByName('PROD_CODIGO_LOCAL').AsInteger := vCodProdAux;
  QryProduto.ParamByName('PROD_DESCRICAO').AsString     := pDescricao;
  QryProduto.ParamByName('PROD_VALORVENDA').AsFloat     := pValor;
  QryProduto.ParamByName('PROD_ESTOQUE').AsFloat        := pQtdEstoque;
  QryProduto.ParamByName('FOTO').Assign(pFoto);
  QryProduto.ParamByName('IND_SINCRONIZAR').AsString    := 'S';

  QryProduto.ExecSQL;
end;


procedure TDMProduto.fEditarProduto(pCodProdutoLocal: Integer; pDescricao: String; pValor, pQtdEstoque: Double; pFoto: TBitmap);
begin
  QryProduto.SQL.Clear;

  QryProduto.SQL.Text :=
    ' UPDATE PRODUTO SET                                                                                  '+
    ' PROD_DESCRICAO = :PROD_DESCRICAO, PROD_VALORVENDA = :PROD_VALORVENDA, PROD_ESTOQUE = :PROD_ESTOQUE, '+
    ' FOTO = :FOTO, IND_SINCRONIZAR = :IND_SINCRONIZAR                                                    '+
    ' WHERE PROD_CODIGO_LOCAL = :PROD_CODIGO_LOCAL                                                        ';

  QryProduto.ParamByName('PROD_CODIGO_LOCAL').AsInteger := pCodProdutoLocal;
  QryProduto.ParamByName('PROD_DESCRICAO').AsString     := pDescricao;
  QryProduto.ParamByName('PROD_VALORVENDA').AsFloat     := pValor;
  QryProduto.ParamByName('PROD_ESTOQUE').AsFloat        := pQtdEstoque;
  QryProduto.ParamByName('FOTO').Assign(pFoto);
  QryProduto.ParamByName('IND_SINCRONIZAR').AsString    := 'S';

  QryProduto.ExecSQL;
end;



end.
