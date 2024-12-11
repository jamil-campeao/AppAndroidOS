unit UnInicial;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts;

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
    procedure btProximo1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btAcessarClick(Sender: TObject);
    procedure btCriarClick(Sender: TObject);
  private
    procedure fAbrirAba(pIndex: Integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmInicial: TfrmInicial;

implementation

{$R *.fmx}

uses UnLogin;

procedure TfrmInicial.btAcessarClick(Sender: TObject);
begin
  if not Assigned(frmLogin) then
    Application.CreateForm(TFrmLogin, frmLogin);

  frmLogin.TabControl.ActiveTab := FrmLogin.TabLogin;
  frmLogin.Show;

end;

procedure TfrmInicial.btCriarClick(Sender: TObject);
begin
  if not Assigned(frmLogin) then
    Application.CreateForm(TFrmLogin, frmLogin);

  frmLogin.TabControl.ActiveTab := FrmLogin.TabCriarConta;
  frmLogin.Show;
end;

procedure TfrmInicial.btProximo1Click(Sender: TObject);
begin
  fAbrirAba(TSpeedButton(Sender).Tag);
end;

procedure TfrmInicial.fAbrirAba(pIndex: Integer);
begin
  TabControl.GoToVisibleTab(pIndex);
end;

procedure TfrmInicial.FormCreate(Sender: TObject);
begin
  TabControl.ActiveTab := TabItem1;
end;

end.
