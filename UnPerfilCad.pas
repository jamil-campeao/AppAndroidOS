unit UnPerfilCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, uFancyDialog;

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
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
  private
  vFancy: TFancyDialog;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPerfilCad: TfrmPerfilCad;

implementation

{$R *.fmx}

uses UnPrincipal, UnEdicaoPadrao, DataModule.Cidade, DataModule.Usuario;

procedure TfrmPerfilCad.btSalvarClick(Sender: TObject);
var
  vErro: Boolean;
begin
  vErro := False;
  try
    DMUsuario.fEditarUsuario(Trim(lblNome.Text), Trim(lblLogin.Text));
  except on e:Exception do
    begin
      vFancy.fShow(TIconDialog.Error, 'Erro', 'Erro ao salvar dados do usuário: ' + e.Message, 'OK');
      vErro := True;
    end;
  end;

  if not vErro then
    vFancy.fShow(TIconDialog.Success, 'Sucesso', 'Dados do usuário atualizados com sucesso', 'OK');
end;

procedure TfrmPerfilCad.btVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPerfilCad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  frmPerfilCad := nil;
end;

procedure TfrmPerfilCad.FormCreate(Sender: TObject);
begin
  vFancy := TFancyDialog.Create(frmPerfilCad);
end;

procedure TfrmPerfilCad.FormDestroy(Sender: TObject);
begin
  vFancy.DisposeOf;
end;

procedure TfrmPerfilCad.FormShow(Sender: TObject);
begin
  try
    DMUsuario.fListarUsuarios;

    lblNome.Text  := DMusuario.qryConsUsuario.FieldByName('USU_NOME').AsString;
    lblLogin.Text := DMusuario.qryConsUsuario.FieldByName('USU_LOGIN').AsString;
  except on e:Exception do
    vFancy.fShow(TIconDialog.Error, 'Erro', e.Message, 'OK');

  end;
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
                          'Nome do Usuário',
                          'Informe o nome',
                          lblNome.Text,
                          True,
                          100
                          );

end;

end.
