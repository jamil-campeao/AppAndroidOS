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
    procedure fEditarCliente(pCodClienteLocal: Integer; pCPFCNPJ, pNome, pFone, pEmail, pEndereco, pNumero, pComplemento, pBairro, pCliCEP: String;
pCidadeCodigo: Integer; pLimite: Double);
    procedure fExcluirCliente(pCodClienteLocal: Integer);
    procedure fInserirCliente(pCPFCNPJ, pNome, pFone, pEmail, pEndereco, pNumero, pComplemento, pBairro, pCliCEP: String;
pCidadeCodigo: Integer; pLimite: Double);
    procedure fListarClienteId(pCodClienteLocal: Integer);
    function fRetornaCidadeCliente(pCodCliente: Integer): Integer;

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

procedure TDMCliente.fInserirCliente(pCPFCNPJ, pNome, pFone, pEmail, pEndereco, pNumero, pComplemento, pBairro, pCliCEP: String;
pCidadeCodigo: Integer; pLimite: Double);
begin
  QryCliente.SQL.Clear;

  QryCliente.SQL.Text :=
    ' INSERT INTO CLIENTE                                                                          '+
    ' (CLI_CPF, CLI_NOME, CLI_EMAIL, CLI_ENDERECO, CLI_NUMERO, CLI_COMPLEMENTO, CLI_BAIRRO,        '+
    ' CID_CODIGO, CLI_CEP, CLI_LIMITECREDITO, CLI_IND_SINCRONIZAR)                                 '+
    ' VALUES                                                                                       '+
    ' (:CLI_CPF, :CLI_NOME, :CLI_EMAIL, :CLI_ENDERECO, :CLI_NUMERO, :CLI_COMPLEMENTO, :CLI_BAIRRO, '+
    ' :CID_CODIGO, :CLI_CEP, :CLI_LIMITECREDITO, :CLI_IND_SINCRONIZAR)                             ';

  QryCliente.ParamByName('CLI_CPF').AsString             := pCPFCNPJ;
  QryCliente.ParamByName('CLI_NOME').AsString            := pNome;
  QryCliente.ParamByName('CLI_EMAIL').AsString           := pEmail;
  QryCliente.ParamByName('CLI_ENDERECO').AsString        := pEndereco;
  QryCliente.ParamByName('CLI_NUMERO').AsString          := pNumero;
  QryCliente.ParamByName('CLI_COMPLEMENTO').AsString     := pComplemento;
  QryCliente.ParamByName('CLI_BAIRRO').AsString          := pBairro;

  if pCidadeCodigo > 0 then
    QryCliente.ParamByName('CID_CODIGO').AsInteger         := pCidadeCodigo
  else
  begin
    QryCliente.ParamByName('CID_CODIGO').DataType := ftInteger;
    QryCliente.ParamByName('CID_CODIGO').Clear;
  end;


  QryCliente.ParamByName('CLI_CEP').AsString             := pCliCEP;
  QryCliente.ParamByName('CLI_LIMITECREDITO').AsFloat    := pLimite;
  QryCliente.ParamByName('CLI_IND_SINCRONIZAR').AsString := 'S';

  QryCliente.ExecSQL;
end;


procedure TDMCliente.fEditarCliente(pCodClienteLocal: Integer; pCPFCNPJ, pNome, pFone, pEmail, pEndereco, pNumero, pComplemento, pBairro, pCliCEP: String;
pCidadeCodigo: Integer; pLimite: Double);
begin
  QryCliente.SQL.Clear;

  QryCliente.SQL.Text :=
    ' UPDATE CLIENTE SET                                                                              '+
    ' CLI_CPF = :CLI_CPF, CLI_NOME = :CLI_NOME, CLI_EMAIL = :CLI_EMAIL, CLI_ENDERECO = :CLI_ENDERECO, '+
    ' CLI_NUMERO = :CLI_NUMERO, CLI_COMPLEMENTO = :CLI_COMPLEMENTO, CLI_BAIRRO = :CLI_BAIRRO,         '+
    ' CID_CODIGO = :CID_CODIGO, CLI_CEP = :CLI_CEP, CLI_LIMITECREDITO = :CLI_LIMITECREDITO            '+
    ' WHERE CLI_CODIGO_LOCAL = :CLI_CODIGO_LOCAL                                                      ';

  QryCliente.ParamByName('CLI_CODIGO_LOCAL').AsInteger   := pCodClienteLocal;
  QryCliente.ParamByName('CLI_CPF').AsString             := pCPFCNPJ;
  QryCliente.ParamByName('CLI_NOME').AsString            := pNome;
  QryCliente.ParamByName('CLI_EMAIL').AsString           := pEmail;
  QryCliente.ParamByName('CLI_ENDERECO').AsString        := pEndereco;
  QryCliente.ParamByName('CLI_NUMERO').AsString          := pNumero;
  QryCliente.ParamByName('CLI_COMPLEMENTO').AsString     := pComplemento;
  QryCliente.ParamByName('CLI_BAIRRO').AsString          := pBairro;
  QryCliente.ParamByName('CID_CODIGO').AsInteger         := pCidadeCodigo;
  QryCliente.ParamByName('CLI_CEP').AsString             := pCliCEP;
  QryCliente.ParamByName('CLI_LIMITECREDITO').AsFloat    := pLimite;
  QryCliente.ExecSQL;
end;

procedure TDMCliente.fExcluirCliente(pCodClienteLocal: Integer);
begin
  {$REGION 'VALIDAÇÕES'}
  QryCliente.SQL.Clear;

  QryCliente.SQL.Text := ' SELECT CLI_CODIGO FROM OS WHERE CLI_CODIGO_LOCAL = :CLI_CODIGO_LOCAL ';
  QryCliente.ParamByName('CLI_CODIGO_LOCAL').AsInteger   := pCodClienteLocal;
  QryCliente.Open;

  if not QryCliente.IsEmpty then
    raise Exception.Create('Cliente já um uso no banco de dados, não é possível realizar a exclusão');
  {$ENDREGION}

  QryCliente.SQL.Clear;

  QryCliente.SQL.Text := ' DELETE FROM CLIENTE WHERE CLI_CODIGO_LOCAL = :CLI_CODIGO_LOCAL ';

  QryCliente.ParamByName('CLI_CODIGO_LOCAL').AsInteger   := pCodClienteLocal;

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

function TDMCliente.fRetornaCidadeCliente(pCodCliente: Integer): Integer;
begin
  Result := 0;
  QryConsCliente.SQL.Clear;

  QryConsCliente.SQL.Text :=
    ' SELECT CID_CODIGO                           '+
    ' FROM CLIENTE                                '+
    ' WHERE CLI_CODIGO_LOCAL = :CLI_CODIGO_LOCAL  ';

  QryConsCliente.ParamByName('CLI_CODIGO_LOCAL').AsInteger := pCodCliente;

  QryConsCliente.Open;

  if not QryConsCliente.IsEmpty then
    Result := QryConsCliente.FieldByName('CID_CODIGO').AsInteger;
  
end;




end.
