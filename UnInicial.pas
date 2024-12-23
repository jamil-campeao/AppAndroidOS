unit UnInicial;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  uFancyDialog;

type
  TfrmInicial = class(TForm)
    TabControl: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    Layout1: TLayout;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Layout2: TLayout;
    btProximo1: TSpeedButton;
    StyleBook1: TStyleBook;
    Layout3: TLayout;
    Image2: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Layout4: TLayout;
    SpeedButton2: TSpeedButton;
    btProximo2: TSpeedButton;
    Layout5: TLayout;
    Image3: TImage;
    Label5: TLabel;
    Label6: TLabel;
    Layout6: TLayout;
    SpeedButton4: TSpeedButton;
    btProximo3: TSpeedButton;
    Layout7: TLayout;
    Image4: TImage;
    Label7: TLabel;
    Layout8: TLayout;
    btCriar: TSpeedButton;
    btAcessar: TSpeedButton;
    Label8: TLabel;
    timerLoad: TTimer;
    procedure btProximo1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btAcessarClick(Sender: TObject);
    procedure btCriarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure timerLoadTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    vFancy: TFancyDialog;
    procedure fAbrirAba(pIndex: Integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmInicial: TfrmInicial;

implementation

{$R *.fmx}

uses UnLogin, DataModule.Usuario, UnPrincipal;

procedure TfrmInicial.btAcessarClick(Sender: TObject);
begin
  try
    DMUsuario.fDesativarOnboarding;
  except
    on E: Exception do
      vFancy.fShow(TIconDialog.Error, 'Erro', 'Erro ao desativar onboarding: ' + E.Message, 'OK');
  end;

  if not Assigned(frmLogin) then
    Application.CreateForm(TFrmLogin, frmLogin);

  frmLogin.TabControl.ActiveTab := frmLogin.TabLogin;

  Application.MainForm := frmLogin;
  frmInicial.Destroy;

  frmLogin.Show;
end;



procedure TfrmInicial.btCriarClick(Sender: TObject);
begin
  try
  //Desativo o onboarding
    DMUsuario.fDesativarOnboarding;
  except on e:exception do
    vFancy.fShow(TIconDialog.Error, 'Erro', 'Erro ao desativar onboarding: ' + e.Message, 'OK');
  end;

  if not Assigned(frmLogin) then
    Application.CreateForm(TFrmLogin, frmLogin);

  // Configuro o formulário de login
  frmLogin.TabControl.ActiveTab := FrmLogin.TabCriarConta;

  frmLogin.Show;

  //Escondo o formulário
  frmInicial.Hide;
end;

procedure TfrmInicial.btProximo1Click(Sender: TObject);
begin
  fAbrirAba(TSpeedButton(Sender).Tag);
end;

procedure TfrmInicial.fAbrirAba(pIndex: Integer);
begin
  TabControl.GoToVisibleTab(pIndex);
end;

procedure TfrmInicial.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FrmInicial := nil;
end;

procedure TfrmInicial.FormCreate(Sender: TObject);
begin
  vFancy := TFancyDialog(frmInicial);
  TabControl.ActiveTab := TabItem1;
end;

procedure TfrmInicial.FormDestroy(Sender: TObject);
begin
  vFancy.DisposeOf;
end;

procedure TfrmInicial.FormShow(Sender: TObject);
begin
  TimerLoad.Enabled := True;
end;

procedure TfrmInicial.timerLoadTimer(Sender: TObject);
begin
  timerLoad.Enabled := False;

  try
    if not Assigned(DMUsuario) then
      Application.CreateForm(TDMUsuario, DMUsuario);

    DmUsuario.fListarUsuarios;

    if DmUsuario.qryConsUsuario.FieldByName('IND_LOGIN').AsString = 'S' then
    begin
      if not Assigned(frmPrincipal) then
        Application.CreateForm(TfrmPrincipal, frmPrincipal);

      //Tratar a Unit de sessão do usuário

      Application.MainForm := FrmPrincipal;
      FrmPrincipal.Show;
      FrmInicial.Close;
    end
    else
    begin
      if DmUsuario.qryConsUsuario.FieldByName('IND_ONBOARDING').AsString = 'N' then
        fAbrirAba(3)
      else
        fAbrirAba(0);
    end;


  except on e:Exception do
    vFancy.fShow(TIconDialog.Error, 'Erro', 'Erro inesperado: ' + e.Message, 'OK');


  end;
end;

end.
