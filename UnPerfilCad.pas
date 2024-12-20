unit UnPerfilCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation;

type
  TfrmPerfilCad = class(TForm)
    rectToolBar: TRectangle;
    lblTitulo: TLabel;
    btVoltar: TSpeedButton;
    Image2: TImage;
    btSalvar: TSpeedButton;
    Image1: TImage;
    rectNome: TRectangle;
    Label2: TLabel;
    Image4: TImage;
    lblNome: TLabel;
    rectEmail: TRectangle;
    Label3: TLabel;
    Image3: TImage;
    lblLogin: TLabel;
    procedure rectNomeClick(Sender: TObject);
    procedure rectEmailClick(Sender: TObject);
    procedure btVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPerfilCad: TfrmPerfilCad;

implementation

{$R *.fmx}

uses UnPrincipal, UnEdicaoPadrao;

procedure TfrmPerfilCad.btVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPerfilCad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  frmPerfilCad := nil;
end;

procedure TfrmPerfilCad.rectEmailClick(Sender: TObject);
begin
  if not Assigned(frmEdicaoPadrao) then
    Application.CreateForm(TFrmEdicaoPadrao, frmEdicaoPadrao);

  FrmEdicaoPadrao.fEditar(lblLogin,
                          TTipoCampo.Edit,
                          'Login',
                          'Informe o login',
                          lblLogin.Text,
                          True,
                          100
                          );

end;

procedure TfrmPerfilCad.rectNomeClick(Sender: TObject);
begin
  if not Assigned(frmEdicaoPadrao) then
    Application.CreateForm(TFrmEdicaoPadrao, frmEdicaoPadrao);

  FrmEdicaoPadrao.fEditar(lblNome,
                          TTipoCampo.Edit,
                          'Nome do Usu�rio',
                          'Informe o nome',
                          lblNome.Text,
                          True,
                          100
                          );

end;

end.
