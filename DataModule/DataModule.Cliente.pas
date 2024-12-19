unit DataModule.Cliente;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Graphics;

type
  TDMCliente = class(TDataModule)
    QryConsCliente: TFDQuery;
    QryCliente: TFDQuery;
  private
    function fFiltros(pBusca: String): String;
    { Private declarations }
  public
    procedure fListarClientes(pPagina: Integer; pBusca: String);
    procedure fEditarCliente(pCodProdutoLocal: Integer; pDescricao: String;
      pValor, pQtdEstoque: Double; pFoto: TBitmap);
    procedure fExcluirCliente(pCodProdutoLocal: Integer);
    procedure fInserirCliente(pDescricao: String; pValor, pQtdEstoque: Double;
      pFoto: TBitmap);
    procedure fListarClienteId(pCodClienteLocal: Integer);

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

procedure TDMCliente.fInserirCliente(pDescricao: String; pValor, pQtdEstoque: Double; pFoto: TBitmap);
begin
  QryCliente.SQL.Clear;

  QryCliente.SQL.Text :=
    ' INSERT INTO PRODUTO                                                               '+
    ' (PROD_DESCRICAO, PROD_VALORVENDA, PROD_ESTOQUE, FOTO, PROD_IND_SINCRONIZAR)       '+
    ' VALUES                                                                            '+
    ' (:PROD_DESCRICAO, :PROD_VALORVENDA, :PROD_ESTOQUE, :FOTO, :PROD_IND_SINCRONIZAR)  ';

  QryCliente.ParamByName('PROD_DESCRICAO').AsString       := pDescricao;
  QryCliente.ParamByName('PROD_VALORVENDA').AsFloat       := pValor;
  QryCliente.ParamByName('PROD_ESTOQUE').AsFloat          := pQtdEstoque;
  QryCliente.ParamByName('FOTO').Assign(pFoto);
  QryCliente.ParamByName('PROD_IND_SINCRONIZAR').AsString := 'S';

  QryCliente.ExecSQL;
end;


procedure TDMCliente.fEditarCliente(pCodProdutoLocal: Integer; pDescricao: String; pValor, pQtdEstoque: Double; pFoto: TBitmap);
begin
  QryCliente.SQL.Clear;

  QryCliente.SQL.Text :=
    ' UPDATE PRODUTO SET                                                                                  '+
    ' PROD_DESCRICAO = :PROD_DESCRICAO, PROD_VALORVENDA = :PROD_VALORVENDA, PROD_ESTOQUE = :PROD_ESTOQUE, '+
    ' FOTO = :FOTO, PROD_IND_SINCRONIZAR = :PROD_IND_SINCRONIZAR                                          '+
    ' WHERE PROD_CODIGO_LOCAL = :PROD_CODIGO_LOCAL                                                        ';

  QryCliente.ParamByName('PROD_CODIGO_LOCAL').AsInteger   := pCodProdutoLocal;
  QryCliente.ParamByName('PROD_DESCRICAO').AsString       := pDescricao;
  QryCliente.ParamByName('PROD_VALORVENDA').AsFloat       := pValor;
  QryCliente.ParamByName('PROD_ESTOQUE').AsFloat          := pQtdEstoque;
  QryCliente.ParamByName('FOTO').Assign(pFoto);
  QryCliente.ParamByName('PROD_IND_SINCRONIZAR').AsString := 'S';

  QryCliente.ExecSQL;
end;

procedure TDMCliente.fExcluirCliente(pCodProdutoLocal: Integer);
begin
  {$REGION 'VALIDAÇÕES'}
  QryCliente.SQL.Clear;

  QryCliente.SQL.Text := ' SELECT PROD_CODIGO FROM OSPRODUTO WHERE PROD_CODIGO = :PROD_CODIGO ';
  QryCliente.ParamByName('PROD_CODIGO').AsInteger   := pCodProdutoLocal;
  QryCliente.Open;

  if not QryCliente.IsEmpty then
    raise Exception.Create('Produto já um uso no banco de dados, não é possível realizar a exclusão');
  {$ENDREGION}

  QryCliente.SQL.Clear;

  QryCliente.SQL.Text := ' DELETE FROM PRODUTO WHERE PROD_CODIGO_LOCAL = :PROD_CODIGO_LOCAL ';

  QryCliente.ParamByName('PROD_CODIGO_LOCAL').AsInteger   := pCodProdutoLocal;

  QryCliente.ExecSQL;
end;

procedure TDMCliente.fListarClienteId(pCodClienteLocal: Integer);
begin
  QryCliente.SQL.Clear;

  QryCliente.SQL.Text := ' SELECT                                                                              '+
                         ' C.CLI_CODIGO_LOCAL,                                                                 '+
                         ' C.CLI_NOME,                                                                         '+
                         ' CASE                                                                                '+
                         '         WHEN C.CLI_CPF = '''' OR C.CLI_CPF IS NULL THEN COALESCE(C.CLI_CNPJ, '''')  '+
                         '         WHEN C.CLI_CNPJ = '''' OR C.CLI_CNPJ IS NULL THEN COALESCE(C.CLI_CPF, '''') '+
                         '     END AS CLI_DOC,                                                                 '+
                         '                                                                                     '+
                         ' C.CLI_CEL,                                                                          '+
                         ' C.CLI_EMAIL,                                                                        '+
                         ' C.CLI_ENDERECO,                                                                     '+
                         ' C.CLI_NUMERO,                                                                       '+
                         ' C.CLI_BAIRRO,                                                                       '+
                         ' C.CLI_COMPLEMENTO,                                                                  '+
                         ' CID.CID_NOME,                                                                       '+
                         ' CID.CID_UF,                                                                         '+
                         ' CID.CID_CEP,                                                                        '+
                         ' COALESCE(C.CLI_LIMITECREDITO,0) AS CLI_LIMITECREDITO                                '+
                         ' FROM CLIENTE C                                                                      '+
                         ' LEFT JOIN CIDADE CID                                                                '+
                         '  ON CID.CID_CODIGO = C.CID_CODIGO                                                   '+
                         ' WHERE C.CLI_CODIGO_LOCAL = :CLI_CODIGO_LOCAL                                        ';

  QryCliente.ParamByName('CLI_CODIGO_LOCAL').AsInteger := pCodClienteLocal;

  QryCliente.Open;
end;




end.
