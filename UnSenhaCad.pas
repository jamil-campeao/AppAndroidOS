unit UnSenhaCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, uFunctions, uFancyDialog;

type
  TfrmSenhaCad = class(TForm)
    rectToolBar: TRectangle;
    lblTitulo: TLabel;
    btVoltar: TSpeedButton;
    Image2: TImage;
    btSalvar: TSpeedButton;
    Image1: TImage;
    rectSenha: TRectangle;
    Label2: TLabel;
    Image4: TImage;
    lblSenha: TLabel;
    rectConfirmarSenha: TRectangle;
    Label1: TLabel;
    Image3: TImage;
    lblConfirmarSenha: TLabel;
    procedure btVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rectSenhaClick(Sender: TObject);
    procedure rectConfirmarSenhaClick(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    vFancy : TFancyDialog;
    procedure fFormatarCampos(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSenhaCad: TfrmSenhaCad;

implementation

{$R *.fmx}

uses UnPrincipal, UnEdicaoPadrao, DataModule.Usuario;

procedure TfrmSenhaCad.btSalvarClick(Sender: TObject);
var
  vErro: Boolean;
begin
  vErro := False;

  if lblSenha.TagString <> lblConfirmarSenha.TagString then
  begin
    vFancy.fShow(TIconDialog.Warning, 'Verificação', 'As senhas não conferem. Digite Novamente.', 'OK');
    Exit;
  end;

  try
    DMUsuario.fEditarSenha(lblSenha.TagString);

  except on e:Exception do
    begin
      vFancy.fShow(TIconDialog.Error, 'Erro', 'Erro ao atualizar senha do usuário: ' + e.Message, 'OK');
      vErro := True;
    end;
  end;

  if not vErro then
    vFancy.fShow(TIconDialog.Success, 'Sucesso', 'Senha atualizada com sucesso', 'OK');

end;

procedure TfrmSenhaCad.btVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSenhaCad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmSenhaCad := nil;
end;

procedure TfrmSenhaCad.FormCreate(Sender: TObject);
begin
  vFancy := TFancyDialog.Create(frmSenhaCad);
end;

procedure TfrmSenhaCad.FormDestroy(Sender: TObject);
begin
  vFancy.DisposeOf;
end;

procedure TfrmSenhaCad.FormShow(Sender: TObject);
begin
  try
    DmUsuario.fListarUsuarios;

    lblSenha.Text      := fFormatarSenha(DmUsuario.qryConsUsuario.FieldByName('USU_SENHA').AsString);
    lblSenha.TagString := DmUsuario.qryConsUsuario.FieldByName('USU_SENHA').AsString;

    lblConfirmarSenha.Text      := lblSenha.Text;
    lblConfirmarSenha.TagString := lblSenha.TagString;


  except on e:Exception do
      vFancy.fShow(TIconDialog.Error, 'Erro', 'Erro ao trazer dados do usuário: ' + e.Message, 'OK');
  end;
end;

procedure TfrmSenhaCad.rectConfirmarSenhaClick(Sender: TObject);
begin
  if not Assigned(frmEdicaoPadrao) then
    Application.CreateForm(TFrmEdicaoPadrao, frmEdicaoPadrao);

  FrmEdicaoPadrao.fEditar(lblConfirmarSenha,
                          TTipoCampo.Senha,
                          'Confirme a senha',
                          'Confirmar a senha',
                          lblConfirmarSenha.Text,
                          True,
                          100,
                          fFormatarCampos
                          );
end;

procedure TfrmSenhaCad.rectSenhaClick(Sender: TObject);
begin
  if not Assigned(frmEdicaoPadrao) then
    Application.CreateForm(TFrmEdicaoPadrao, frmEdicaoPadrao);

  FrmEdicaoPadrao.fEditar(lblSenha,
                          TTipoCampo.Senha,
                          'Senha do usuário',
                          'Informe a senha',
                          lblSenha.Text,
                          True,
                          100,
                          fFormatarCampos
                          );
end;

procedure TfrmSenhaCad.fFormatarCampos(Sender: TObject);
begin
  TLabel(Sender).TagString := TLabel(Sender).Text; // Jogo o texto da senha na TagString
  TLabel(Sender).Text      := fFormatarSenha(TLabel(Sender).Text); //Troco a senha por '*'

end;

end.
