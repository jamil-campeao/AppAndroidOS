unit UnClienteCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox,
  uFancyDialog;

type
  TExecuteOnClose = procedure of object;
  TfrmClienteCad = class(TForm)
    rectToolBar: TRectangle;
    lblTitulo: TLabel;
    btVoltar: TSpeedButton;
    Image2: TImage;
    btSalvar: TSpeedButton;
    Image1: TImage;
    ListBox1: TListBox;
    lbiCPFCNPJ: TListBoxItem;
    lbiNome: TListBoxItem;
    lbiFone: TListBoxItem;
    lbiEmail: TListBoxItem;
    lbiEndereco: TListBoxItem;
    lbiNumero: TListBoxItem;
    lbiComplemento: TListBoxItem;
    lbiBairro: TListBoxItem;
    lbiCidade: TListBoxItem;
    lbiUF: TListBoxItem;
    lbiCEP: TListBoxItem;
    Label2: TLabel;
    lblCPFCNPJ: TLabel;
    Image4: TImage;
    Label1: TLabel;
    lblNome: TLabel;
    Image3: TImage;
    Label4: TLabel;
    lblFone: TLabel;
    Image5: TImage;
    Label6: TLabel;
    lblEmail: TLabel;
    Image6: TImage;
    Label8: TLabel;
    lblEndereco: TLabel;
    Image7: TImage;
    Label10: TLabel;
    lblNumero: TLabel;
    Image8: TImage;
    Label12: TLabel;
    lblComplemento: TLabel;
    Image9: TImage;
    Label14: TLabel;
    lblBairro: TLabel;
    Image10: TImage;
    Label16: TLabel;
    lblCidade: TLabel;
    Image11: TImage;
    Label18: TLabel;
    lblUF: TLabel;
    Image12: TImage;
    Label20: TLabel;
    lblCEP: TLabel;
    Image13: TImage;
    Line1: TLine;
    Line2: TLine;
    Line3: TLine;
    Line4: TLine;
    Line5: TLine;
    Line6: TLine;
    Line7: TLine;
    Line8: TLine;
    Line9: TLine;
    Line10: TLine;
    Line11: TLine;
    lbiLimite: TListBoxItem;
    Line12: TLine;
    Label22: TLabel;
    lblLimite: TLabel;
    Image14: TImage;
    Layout1: TLayout;
    btExcluir: TSpeedButton;
    Image15: TImage;
    btMapa: TSpeedButton;
    Image16: TImage;
    procedure btVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FCod_cliente: Integer;
    FModo: String;
    FExecuteOnClose: TExecuteOnClose;
    vFancy : TFancyDialog;
    { Private declarations }
  public
  property Modo: String read FModo write FModo;
  property Cod_Cliente: Integer read FCod_cliente write FCod_cliente;
  property ExecuteOnClose: TExecuteOnClose read FExecuteOnClose write FExecuteOnClose;

    { Public declarations }
  end;

var
  frmClienteCad: TfrmClienteCad;

implementation

{$R *.fmx}

uses UnPrincipal, DataModule.Cliente;

procedure TfrmClienteCad.btVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmClienteCad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmClienteCad := nil;

end;

procedure TfrmClienteCad.FormCreate(Sender: TObject);
begin
  vFancy := TFancyDialog.Create(frmClienteCad);
end;

procedure TfrmClienteCad.FormDestroy(Sender: TObject);
begin
  vFancy.DisposeOf;
end;

procedure TfrmClienteCad.FormShow(Sender: TObject);
begin
  try
    btExcluir.Visible := Modo = 'A';

    if Modo = 'A' then
    begin
      DMCliente.fListarClienteId(Cod_Cliente);

      lblCPFCNPJ.Text       := DMCliente.QryCliente.FieldByName('CLI_DOC').AsString;
      lblNome.Text          := DMCliente.QryCliente.FieldByName('CLI_NOME').AsString;
      lblFone.Text          := DMCliente.QryCliente.FieldByName('CLI_CEL').AsString;
      lblEmail.Text         := DMCliente.QryCliente.FieldByName('CLI_EMAIL').AsString;
      lblEndereco.Text      := DMCliente.QryCliente.FieldByName('CLI_ENDERECO').AsString;
      lblNumero.Text        := DMCliente.QryCliente.FieldByName('CLI_NUMERO').AsString;
      lblComplemento.Text   := DMCliente.QryCliente.FieldByName('CLI_COMPLEMENTO').AsString;
      lblBairro.Text        := DMCliente.QryCliente.FieldByName('CLI_BAIRRO').AsString;
      lblCidade.Text        := DMCliente.QryCliente.FieldByName('CID_NOME').AsString;
      lblUF.Text            := DMCliente.QryCliente.FieldByName('CID_UF').AsString;
      lblCEP.Text           := DMCliente.QryCliente.FieldByName('CID_CEP').AsString;
      lblLimite.Text        := FormatFloat('#,##0.00', DMCliente.QryCliente.FieldByName('CLI_LIMITECREDITO').AsFloat);
      lblTitulo.Text        := 'Editar Cliente'
    end;
  except on E:Exception do
    vFancy.fShow(TIconDialog.Error, 'Erro', 'Erro ao carregar dados do cliente: ' + e.Message, 'OK');

  end;
end;

end.
