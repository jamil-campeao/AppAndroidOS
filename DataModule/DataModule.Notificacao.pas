unit DataModule.Notificacao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TDMNotificacao = class(TDataModule)
    QryConsNotificacao: TFDQuery;
    QryNotificacao: TFDQuery;
  private
    { Private declarations }
  public
  procedure fListarNotificacoes(pPagina: Integer);
  procedure fMarcarNotificacaoLida(pCodigoNotificao: Integer);
  procedure fMarcarNotificacaoNaoLida(pCodigoNotificao: Integer);
  procedure fExcluirNotificacao(pCodigoNotificao: Integer);

    { Public declarations }
  end;

var
  DMNotificacao: TDMNotificacao;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses DMGlobal, uConstantes;

{$R *.dfm}

procedure TDMNotificacao.fListarNotificacoes(pPagina: Integer);
begin
  QryConsNotificacao.Active := False;
  QryConsNotificacao.SQL.Clear;

  QryConsNotificacao.SQL.Text :=
    ' SELECT N.* FROM NOTIFICACAO N    ' +
    ' WHERE N.NOT_CODIGO > 0           ' +
    ' ORDER BY N.NOT_CODIGO DESC       ';

  if pPagina > 0 then
  begin
    QryConsNotificacao.SQL.Add('LIMIT :PAGINA, :QTD_REG');
    QryConsNotificacao.ParamByName('PAGINA').AsInteger  := (pPagina - 1) * cQTD_REG_PAGINA_NOTIFICACAO;
    QryConsNotificacao.ParamByName('QTD_REG').AsInteger := cQTD_REG_PAGINA_NOTIFICACAO;
  end;

  QryConsNotificacao.Open;
end;

procedure TDMNotificacao.fMarcarNotificacaoLida(pCodigoNotificao: Integer);
begin
  QryNotificacao.SQL.Clear;

  QryNotificacao.SQL.Text := ' UPDATE NOTIFICACAO SET          ' +
                             ' NOT_IND_LIDO = :NOT_IND_LIDO    ' +
                             ' WHERE NOT_CODIGO = :NOT_CODIGO  ';

  QryNotificacao.ParamByName('NOT_IND_LIDO').AsString := 'S';
  QryNotificacao.ParamByName('NOT_CODIGO').AsInteger  := pCodigoNotificao;

  QryNotificacao.ExecSQL;
end;

procedure TDMNotificacao.fMarcarNotificacaoNaoLida(pCodigoNotificao: Integer);
begin
  QryNotificacao.SQL.Clear;

  QryNotificacao.SQL.Text := ' UPDATE NOTIFICACAO SET          ' +
                             ' NOT_IND_LIDO = :NOT_IND_LIDO    ' +
                             ' WHERE NOT_CODIGO = :NOT_CODIGO  ';

  QryNotificacao.ParamByName('NOT_IND_LIDO').AsString := 'N';
  QryNotificacao.ParamByName('NOT_CODIGO').AsInteger  := pCodigoNotificao;

  QryNotificacao.ExecSQL;
end;

procedure TDMNotificacao.fExcluirNotificacao(pCodigoNotificao: Integer);
begin
  QryNotificacao.SQL.Clear;

  QryNotificacao.SQL.Text := ' DELETE FROM NOTIFICACAO         ' +
                             ' WHERE NOT_CODIGO = :NOT_CODIGO  ';

  QryNotificacao.ParamByName('NOT_CODIGO').AsInteger  := pCodigoNotificao;

  QryNotificacao.ExecSQL;
end;


end.
