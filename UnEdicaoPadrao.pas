unit UnEdicaoPadrao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.Calendar,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.Layouts, uFancyDialog;

type
  TTipoCampo = (Edit, Data, Senha, Memo, Valor, Inteiro);

  TExecuteOnClose = procedure(Sender: TObject) of Object;

  TFrmEdicaoPadrao = class(TForm)
    edTexto: TEdit;
    rectToolBar: TRectangle;
    lblTitulo: TLabel;
    btVoltar: TSpeedButton;
    Image2: TImage;
    btSalvar: TSpeedButton;
    Image1: TImage;
    edSenha: TEdit;
    calendar: TCalendar;
    memo: TMemo;
    StyleBook1: TStyleBook;
    lytValor: TLayout;
    lblValor: TLabel;
    Layout1: TLayout;
    Label2: TLabel;
    Layout2: TLayout;
    Label3: TLabel;
    Layout3: TLayout;
    Label4: TLabel;
    Layout4: TLayout;
    Label5: TLabel;
    Layout5: TLayout;
    Label6: TLabel;
    Layout6: TLayout;
    Label7: TLabel;
    Layout7: TLayout;
    Label8: TLabel;
    Layout8: TLayout;
    Label9: TLabel;
    Layout9: TLayout;
    Label10: TLabel;
    Layout10: TLayout;
    Label11: TLabel;
    Layout11: TLayout;
    Label12: TLabel;
    Layout12: TLayout;
    imgBackspace: TImage;
    procedure btVoltarClick(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure imgBackspaceClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    vFancy : TFancyDialog;
    vObjeto: TObject;
    vProcExecuteOnClose: TExecuteOnClose;
    vIndObrigatorio: Boolean;
    vTipo: TTipoCampo;
    procedure fTeclaNumero(pLbl: TLabel);
    procedure fTeclaBackspace;
    { Private declarations }
  public
    procedure fEditar(pObj: TObject; pTipoCampo: TTipoCampo;
pTitulo, pTextPrompt, pTextoPadrao: String; pIndObrigatorio: Boolean;
pTamanhoMaximo: Integer; pExecuteOnClose: TExecuteOnClose = nil);

    { Public declarations }
  end;

var
  FrmEdicaoPadrao: TFrmEdicaoPadrao;

implementation

{$R *.fmx}

procedure TFrmEdicaoPadrao.btVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmEdicaoPadrao.fEditar(pObj: TObject; pTipoCampo: TTipoCampo;
pTitulo, pTextPrompt, pTextoPadrao: String; pIndObrigatorio: Boolean;
pTamanhoMaximo: Integer; pExecuteOnClose: TExecuteOnClose = nil);
var
  vDia, vMes, vAno : Integer;
begin
  lblTitulo.Text  := pTitulo;
  vObjeto         := pObj;
  vIndObrigatorio := pIndObrigatorio;
  vTipo           := pTipoCampo;

  //Se o campo for Edit, esconde ou Habilita o edTexto
  edTexto.Visible  := pTipoCampo = TTipoCampo.Edit;

  //Se o campo for Senha, esconde ou habilita o edSenha
  edSenha.Visible  := pTipoCampo = TTipoCampo.Senha;

  //Se o campo for Data, esconde ou habilita o calendar
  calendar.Visible := pTipoCampo = TTipoCampo.Data;

  //Se o campo for Memo, esconde ou habilita o Memo
  memo.Visible     := pTipoCampo = TTipoCampo.Memo;

  //Se o campo for Valor ou Inteiro, esconde ou habilita o layout
  lytValor.Visible := (pTipoCampo = TTipoCampo.Valor) or (pTipoCampo = TTipoCampo.Inteiro);

  vProcExecuteOnClose := pExecuteOnClose;

  if pTipoCampo = TTipoCampo.Edit then
  begin
    edTexto.TextPrompt := pTextPrompt;
    edTexto.MaxLength  := pTamanhoMaximo;
    edTexto.Text       := pTextoPadrao;
  end;

  if pTipoCampo = TTipoCampo.Edit then
  begin
    edSenha.TextPrompt := pTextPrompt;
    edSenha.MaxLength  := pTamanhoMaximo;
    edSenha.Text       := pTextoPadrao;
  end;

  if pTipoCampo = TTipoCampo.Data then
  begin
   if pTextoPadrao <> '' then //dd/mm/yyyy
   begin
    vDia := Copy(pTextoPadrao, 1, 2).ToInteger;
    vMes := Copy(pTextoPadrao, 4, 2).ToInteger;
    vAno := Copy(pTextoPadrao, 7, 4).ToInteger;

    calendar.Date := EncodeDate(vAno, vMes, vDia);
   end
   else
    calendar.Date := Date;

  end;

  if pTipoCampo = TTipoCampo.Memo then
  begin
    memo.MaxLength  := pTamanhoMaximo;
    memo.Text       := pTextoPadrao;
  end;

  if pTipoCampo = TTipoCampo.Valor then
    lblValor.Text := pTextoPadrao;

  if pTipoCampo = TTipoCampo.Inteiro then
    lblValor.Text := pTextoPadrao;

  FrmEdicaoPadrao.Show;

end;

procedure TFrmEdicaoPadrao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action          := TCloseAction.caFree;
  FrmEdicaoPadrao := nil;
end;

procedure TFrmEdicaoPadrao.FormCreate(Sender: TObject);
begin
  vFancy := TFancyDialog.Create(FrmEdicaoPadrao);
end;

procedure TFrmEdicaoPadrao.FormDestroy(Sender: TObject);
begin
  vFancy.DisposeOf;
end;

procedure TFrmEdicaoPadrao.btSalvarClick(Sender: TObject);
var
  vRet: String;
begin
  if edTexto.Visible then
    vRet := edTexto.Text
  else
  if edSenha.Visible then
    vRet := edSenha.Text
  else
  if calendar.Visible then
    vRet := FormatDateTime('dd/mm/yyyy', calendar.Date)
  else
  if memo.Visible then
    vRet := memo.Text
  else
  if lytValor.Visible then
    vRet := lblValor.Text;

  if (vIndObrigatorio) and (vRet = '') then
  begin
    vFancy.fShow(TIconDialog.Warning, 'Aviso', 'Campo obrigatório', 'OK');
    Exit;
  end;

  if vObjeto is TLabel then
    TLabel(vObjeto).Text := vRet;

  if Assigned(vProcExecuteOnClose) then
    vProcExecuteOnClose(vObjeto);

  Close;

end;

procedure TFrmEdicaoPadrao.Label2Click(Sender: TObject);
begin
  fTeclaNumero(TLabel(Sender));
end;


procedure TFrmEdicaoPadrao.fTeclaNumero(pLbl: TLabel);
var
  vValor : String;
begin
  vValor := lblValor.Text;

  //removo a formatação do numero
  vValor := vValor.Replace('.', '');
  vValor := vValor.Replace(',', '');

  vValor        := vValor + pLbl.Text;

  if vTipo = TTipoCampo.Valor then
    lblValor.Text := FormatFloat('#,##0.00', vValor.ToDouble / 100)
  else
    lblValor.Text := FormatFloat('#,##', vValor.ToDouble);

end;

procedure TFrmEdicaoPadrao.imgBackspaceClick(Sender: TObject);
begin
  fTeclaBackspace;
end;

procedure TFrmEdicaoPadrao.fTeclaBackspace();
var
  vValor : String;
begin
  vValor := lblValor.Text;

  //removo a formatação do numero
  vValor := vValor.Replace('.', '');
  vValor := vValor.Replace(',', '');

  if vValor.Length > 1 then
    vValor := Copy(vValor, 1, vValor.Length - 1)
  else
    vValor := '0';

  if vTipo = TTipoCampo.Valor then
    lblValor.Text := FormatFloat('#,##0.00', vValor.ToDouble / 100)
  else
    lblValor.Text := FormatFloat('#,##0', vValor.ToDouble);

end;

end.
