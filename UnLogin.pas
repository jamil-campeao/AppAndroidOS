unit UnLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit,
  uSession, uLoading, uFancyDialog;

type
  TfrmLogin = class(TForm)
    TabControl: TTabControl;
    TabLogin: TTabItem;
    TabCriarConta: TTabItem;
    Rectangle1: TRectangle;
    Layout7: TLayout;
    Image4: TImage;
    Label7: TLabel;
    Layout1: TLayout;
    lbCriar: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edLogin: TEdit;
    edSenha: TEdit;
    StyleBook1: TStyleBook;
    btLogin: TSpeedButton;
    lbLogin: TLabel;
    Layout2: TLayout;
    Label5: TLabel;
    Label6: TLabel;
    edContaSenha: TEdit;
    btCriarConta: TSpeedButton;
    Rectangle2: TRectangle;
    Layout3: TLayout;
    Image1: TImage;
    Label8: TLabel;
    edContaNome: TEdit;
    edContaLogin: TEdit;
    Label1: TLabel;
    procedure lbCriarClick(Sender: TObject);
    procedure lbLoginClick(Sender: TObject);
    procedure btLoginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btCriarContaClick(Sender: TObject);
  private
    aFancy: TFancyDialog;
    procedure fThreadLoginTerminated(Sender: TObject);
    procedure fOpenFormPrincipal;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.fmx}

uses UnPrincipal, DataModule.Usuario;

procedure TfrmLogin.fOpenFormPrincipal;
begin
  if not Assigned(FrmPrincipal) then
    Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    //Sessão
    TSession.COD_USUARIO := DmUsuario.TabUsuario.FieldByName('usu_codigo').AsInteger;
    TSession.NOME        := DmUsuario.TabUsuario.FieldByName('usu_nome').AsString;
    TSession.LOGIN       := DmUsuario.TabUsuario.FieldByName('usu_login').AsString;
    TSession.TOKEN_JWT   := DmUsuario.TabUsuario.FieldByName('token').AsString;

  Application.MainForm := frmPrincipal;
  FrmPrincipal.Show;
  FrmLogin.Close;

end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  aFancy := TFancyDialog.Create(FrmLogin);
end;

procedure TfrmLogin.FormDestroy(Sender: TObject);
begin
  aFancy.DisposeOf;
end;

procedure TfrmLogin.fThreadLoginTerminated(Sender: TObject);
begin
  TLoading.Hide;

  if Sender is TThread then
    if Assigned(TThread(Sender).FatalException) then
    begin
      aFancy.Show(TIconDialog.Error, '', Exception(TThread(sender).FatalException).Message, 'OK');
      Exit;
    end;

    fOpenFormPrincipal;
end;

procedure TfrmLogin.btCriarContaClick(Sender: TObject);
var
  T: TThread;
begin
  TLoading.Show(FrmLogin, '');

  t := TThread.CreateAnonymousThread(procedure
  begin
    DmUsuario.fNovaContaWeb(Trim(edContaNome.Text), Trim(edContaLogin.Text), edContaSenha.Text);

    with DmUsuario.TabUsuario do
    begin
      DMUsuario.fLogout;
      DmUsuario.fExcluirUsuario;

      DmUsuario.fInserirUsuario(FieldByName('usu_codigo').AsInteger,
                                FieldByName('usu_nome').AsString,
                                FieldByName('usu_login').AsString,
                                edContaSenha.Text,
                                FieldByName('token').AsString);
    end;
  end);

  t.OnTerminate := fThreadLoginTerminated;
  t.Start;
end;

procedure TfrmLogin.btLoginClick(Sender: TObject);
var
  T: TThread;
begin
  TLoading.Show(FrmLogin, '');

  t := TThread.CreateAnonymousThread(procedure
  begin
    DmUsuario.fLoginWeb(Trim(edLogin.Text), edSenha.Text);

    with DmUsuario.TabUsuario do
    begin
      DMUsuario.fLogout;
      DmUsuario.fExcluirUsuario;

      DmUsuario.fInserirUsuario(FieldByName('usu_codigo').AsInteger,
                                FieldByName('usu_nome').AsString,
                                FieldByName('usu_login').AsString,
                                edSenha.Text,
                                FieldByName('token').AsString);
    end;
  end);

  t.OnTerminate := fThreadLoginTerminated;
  t.Start;
end;

procedure TfrmLogin.lbCriarClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(1);
end;

procedure TfrmLogin.lbLoginClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(0);
end;

end.
