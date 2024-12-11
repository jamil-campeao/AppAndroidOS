unit UnLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit;

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
    edCodigo: TEdit;
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
    procedure lbCriarClick(Sender: TObject);
    procedure lbLoginClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.fmx}

procedure TfrmLogin.lbCriarClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(1);
end;

procedure TfrmLogin.lbLoginClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(0);
end;

end.
