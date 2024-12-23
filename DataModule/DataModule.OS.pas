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
    QryOS: TFDQuery;
    QryItem: TFDQuery;
  private
    function fFiltros(pBusca: String) : String;

    { Private declarations }
  public
    procedure fListarOS(pPagina: Integer; pBusca: String);
    procedure fListarOSID(pCodPedidoLocal: Integer);
    procedure fListarItensOSID(pCodPedidoLocal, pCodItem: Integer);
    procedure fCarregaTabelaTemp(pCodPedidoLocal: Integer);

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

procedure TDMOS.fListarOSID(pCodPedidoLocal: Integer);
begin
  QryOS.SQL.Clear;

  QryOS.SQL.Text :=
                    ' SELECT                                                                                  '+
                    '     O.CLI_CODIGO_LOCAL,                                                                 '+
                    '     C.CLI_NOME,                                                                         '+
                    '     CASE                                                                                '+
                    '         WHEN (C.CLI_ENDERECO IS NOT NULL AND C.CLI_ENDERECO <> '''') THEN               '+
                    '             C.CLI_ENDERECO                                                              '+
                    '             || CASE                                                                     '+
                    '                 WHEN (C.CLI_NUMERO IS NOT NULL AND C.CLI_NUMERO <> '''') THEN           '+
                    '                     '', '' || C.CLI_NUMERO                                              '+
                    '                 ELSE                                                                    '+
                    '                     ''''                                                                '+
                    '             END                                                                         '+
                    '             || CASE                                                                     '+
                    '                 WHEN (C.CLI_COMPLEMENTO IS NOT NULL AND C.CLI_COMPLEMENTO <> '''') THEN '+
                    '                     '' - '' || C.CLI_COMPLEMENTO                                        '+
                    '                 ELSE                                                                    '+
                    '                     ''''                                                                '+
                    '             END                                                                         '+
                    '             || CASE                                                                     '+
                    '                 WHEN (C.CLI_BAIRRO IS NOT NULL AND C.CLI_BAIRRO <> '''') THEN           '+
                    '                     '', '' || C.CLI_BAIRRO                                              '+
                    '                 ELSE                                                                    '+
                    '                     ''''                                                                '+
                    '             END                                                                         '+
                    '             || CASE                                                                     '+
                    '                 WHEN (CID.CID_NOME IS NOT NULL AND CID.CID_NOME <> '''') THEN           '+
                    '                     '' - '' || CID.CID_NOME || '' - '' || CID.CID_UF                    '+
                    '                 ELSE                                                                    '+
                    '                     ''''                                                                '+
                    '             END                                                                         '+
                    '             || CASE                                                                     '+
                    '                 WHEN (C.CLI_CEP IS NOT NULL AND C.CLI_CEP <> '''') THEN                 '+
                    '                     '' - '' || C.CLI_CEP                                                '+
                    '                 ELSE                                                                    '+
                    '                     ''''                                                                '+
                    '             END                                                                         '+
                    '         ELSE                                                                            '+
                    '             NULL                                                                        '+
                    '     END AS CLI_ENDERECO_COMPLETO,                                                       '+
                    '     CASE                                                                                '+
                    '         WHEN (C.CLI_CPF IS NULL OR C.CLI_CPF = '''') THEN COALESCE(C.CLI_CNPJ, '''')    '+
                    '         ELSE COALESCE(C.CLI_CPF, '''')                                                  '+
                    '     END AS CLI_DOC,                                                                     '+
                    '                                                                                         '+
                    '     O.OS_TIPO,                                                                          '+
                    '     O.OS_DATAABERTURA,                                                                  '+
                    '     O.OS_SOLICITACAO,                                                                   '+
                    '     O.OS_OBSINTERNA,                                                                    '+
                    '     F.FUNC_NOME                                                                         '+
                    ' FROM                                                                                    '+
                    '     OS O                                                                                '+
                    ' LEFT JOIN                                                                               '+
                    '     CLIENTE C                                                                           '+
                    ' ON                                                                                      '+
                    '     O.CLI_CODIGO_LOCAL = C.CLI_CODIGO_LOCAL                                             '+
                    '                                                                                         '+
                    ' LEFT JOIN                                                                               '+
                    '     CIDADE CID                                                                          '+
                    ' ON                                                                                      '+
                    '     C.CID_CODIGO = CID.CID_CODIGO                                                       '+
                    '                                                                                         '+
                    ' LEFT JOIN                                                                               '+
                    '     FUNCIONARIO F                                                                       '+
                    ' ON                                                                                      '+
                    '     O.FUNC_CODIGO = F.FUNC_CODIGO                                                       '+
                    '                                                                                         '+
                    ' WHERE O.OS_CODIGO_LOCAL = :OS_CODIGO_LOCAL                                              ';

  QryOS.ParamByName('OS_CODIGO_LOCAL').AsInteger := pCodPedidoLocal;

  QryOS.Open;
end;

procedure TDMOS.fListarItensOSID(pCodPedidoLocal, pCodItem: Integer);
begin
  QryItem.SQL.Clear;

  QryItem.SQL.Text :=
                    ' SELECT                                                                                  '+
                    '     OSP.OSP_CODIGO,                                                                     '+
                    '     OSP.OS_CODIGO_LOCAL,                                                                '+
                    '     OSP.PROD_CODIGO_LOCAL,                                                              '+
                    '     P.PROD_DESCRICAO,                                                                   '+
                    '     OSP.OSP_QUANTIDADE,                                                                 '+
                    '     OSP.OSP_VALOR,                                                                      '+
                    '     OSP.OSP_TOTAL,                                                                      '+
                    '     P.FOTO                                                                              '+
                    ' FROM                                                                                    '+
                    '     OSPRODUTO_TEMP OSP                                                                  '+
                    '  INNER JOIN PRODUTO P                                                                   '+
                    '     ON P.PROD_CODIGO_LOCAL = OSP.PROD_CODIGO_LOCAL                                      '+
                    ' WHERE OSP.OS_CODIGO_LOCAL = :OS_CODIGO_LOCAL                                            ';

  if pCodItem > 0 then
  begin
    QryItem.SQL.Add(' AND OSP_CODIGO = :OSP_CODIGO ');
    QryItem.ParamByName('OSP_CODIGO').AsInteger := pCodItem;
  end;

  QryItem.SQL.Add('ORDER BY 1 DESC');

  QryItem.ParamByName('OS_CODIGO_LOCAL').AsInteger := pCodPedidoLocal;

  QryItem.Open;
end;

procedure TDMOS.fCarregaTabelaTemp(pCodPedidoLocal: Integer);
begin
  QryItem.SQL.Clear;

  QryItem.SQL.Text := ' DELETE FROM OSPRODUTO_TEMP ';

  QryItem.ExecSQL;

  QryItem.SQL.Clear;

  QryItem.SQL.Text := ' INSERT INTO OSPRODUTO_TEMP               '+
                      ' (OSP_CODIGO,                             '+
                      ' OS_CODIGO_LOCAL,                         '+
                      ' PROD_CODIGO_LOCAL,                       '+
                      ' OSP_QUANTIDADE,                          '+
                      ' OSP_VALOR,                               '+
                      ' OSP_TOTAL)                               '+
                      ' SELECT                                   '+
                      ' OSP_CODIGO,                              '+
                      ' OS_CODIGO_LOCAL,                         '+
                      ' PROD_CODIGO_LOCAL,                       '+
                      ' OSP_QUANTIDADE,                          '+
                      ' OSP_VALOR,                               '+
                      ' OSP_TOTAL                                '+
                      ' FROM OSPRODUTO                           '+
                      ' WHERE OS_CODIGO_LOCAL = :OS_CODIGO_LOCAL ';

  QryItem.ParamByName('OS_CODIGO_LOCAL').AsInteger := pCodPedidoLocal;

  QryItem.ExecSQL;
end;


end.
