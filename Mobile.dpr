program Mobile;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnInicial in 'UnInicial.pas' {frmInicial},
  UnLogin in 'UnLogin.pas' {frmLogin},
  UnPrincipal in 'UnPrincipal.pas' {frmPrincipal},
  DMGlobal in 'DataModule\DMGlobal.pas' {DM: TDataModule},
  uConstantes in 'Units\uConstantes.pas',
  uFunctions in 'Units\uFunctions.pas',
  uLoading in 'Units\uLoading.pas',
  uSession in 'Units\uSession.pas',
  uSuperChart in 'Units\uSuperChart.pas',
  DataModule.Usuario in 'DataModule\DataModule.Usuario.pas' {DmUsuario: TDataModule},
  DataModule.OS in 'DataModule\DataModule.OS.pas' {DMOS: TDataModule},
  DataModule.Cliente in 'DataModule\DataModule.Cliente.pas' {DMCliente: TDataModule},
  DataModule.Notificacao in 'DataModule\DataModule.Notificacao.pas' {DMNotificacao: TDataModule},
  UnProduto in 'UnProduto.pas' {frmProduto},
  DataModule.Produto in 'DataModule\DataModule.Produto.pas' {DMProduto: TDataModule},
  UnProdutoCad in 'UnProdutoCad.pas' {frmProdutoCad},
  uActionSheet in 'Units\uActionSheet.pas',
  u99Permissions in 'Units\u99Permissions.pas',
  UnEdicaoPadrao in 'UnEdicaoPadrao.pas' {FrmEdicaoPadrao},
  uFancyDialog in 'Units\uFancyDialog.pas',
  UnClienteCad in 'UnClienteCad.pas' {frmClienteCad},
  UnCidade in 'UnCidade.pas' {frmCidade},
  DataModule.Cidade in 'DataModule\DataModule.Cidade.pas' {DMCidade: TDataModule},
  uCombobox in 'Units\uCombobox.pas',
  uFormat in 'Units\uFormat.pas',
  UnPerfilCad in 'UnPerfilCad.pas' {frmPerfilCad},
  UnSenhaCad in 'UnSenhaCad.pas' {frmSenhaCad};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmInicial, frmInicial);
  Application.Run;
end.
