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
  private
    { Private declarations }
  public
  procedure fListarNotificacoes(pPagina: Integer);

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


end.
