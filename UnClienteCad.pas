unit UnClienteCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox,
  uFancyDialog, uFunctions, UnEdicaoPadrao, u99Permissions, System.Sensors,
  System.Sensors.Components, uLoading, uFormat;

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
    LocationSensor: TLocationSensor;
    procedure btVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure ListBox1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure btExcluirClick(Sender: TObject);
    procedure btMapaClick(Sender: TObject);
    procedure LocationSensorLocationChanged(Sender: TObject; const OldLocation,
      NewLocation: TLocationCoord2D);
  private
    vGeoCoder : TGeocoder;
    FCod_cliente: Integer;
    FModo: String;
    FExecuteOnClose: TExecuteOnClose;
    vFancy : TFancyDialog;
    FUF: String;
    FCod_cidade: Integer;
    FNome_cidade: String;
    FCEP: String;
    vPermissao: T99Permissions;
    procedure fClickDelete(Sender: TObject);
    procedure fErroLocalizacao(Sender: TObject);
    procedure fObterLocalizacao(Sender: TObject);
    procedure fOnGeocodeReverse(const Address: TCivicAddress);
    procedure fFormatarCampos(Sender: TObject);
    { Private declarations }
  public
  property Modo: String read FModo write FModo;
  property Cod_Cliente: Integer read FCod_cliente write FCod_cliente;
  property Cod_Cidade: Integer read FCod_cidade write FCod_cidade;
  property Nome_Cidade: String read FNome_cidade write FNome_cidade;
  property UF: String read FUF write FUF;
  property CEP: String read FCEP write FCEP;
  property ExecuteOnClose: TExecuteOnClose read FExecuteOnClose write FExecuteOnClose;

    { Public declarations }
  end;

var
  frmClienteCad: TfrmClienteCad;

implementation

{$R *.fmx}

uses UnPrincipal, DataModule.Cliente, UnCidade;

procedure TfrmClienteCad.btExcluirClick(Sender: TObject);
begin
  vFancy.fShow(TIconDialog.Question, 'Confirmação', 'Confirma a exclusão do cliente?',
              'Sim', fClickDelete, 'Não');
end;

procedure TfrmClienteCad.btSalvarClick(Sender: TObject);
begin
  if lblCPFCNPJ.Text = '' then
  begin
    vFancy.fShow(TIconDialog.Warning, 'Aviso', 'Informe o CNPJ/CPF do Cliente', 'OK');
    Exit;
  end;

  if lblNome.Text = '' then
  begin
    vFancy.fShow(TIconDialog.Warning, 'Aviso', 'Informe o Nome do Cliente', 'OK');
    Exit;
  end;

  if lblEndereco.Text = '' then
  begin
    vFancy.fShow(TIconDialog.Warning, 'Aviso', 'Informe o Endereço do Cliente', 'OK');
    Exit;
  end;

  if lblCidade.Text = '' then
  begin
    vFancy.fShow(TIconDialog.Warning, 'Aviso', 'Informe a Cidade do Cliente', 'OK');
    Exit;
  end;

  try
    if Modo = 'I' then
      DMCliente.fInserirCliente(Trim(lblCPFCNPJ.Text),
                                Trim(lblNome.Text),
                                Trim(lblFone.Text),
                                Trim(lblEmail.Text),
                                Trim(lblEndereco.Text),
                                Trim(lblNumero.Text),
                                Trim(lblComplemento.Text),
                                Trim(lblBairro.Text),
                                Trim(lblCEP.Text),
                                Cod_Cidade,
                                fStringToFloat(lblLimite.Text)
                                )
    else
      DMCliente.fEditarCliente( Cod_Cliente,
                                Trim(lblCPFCNPJ.Text),
                                Trim(lblNome.Text),
                                Trim(lblFone.Text),
                                Trim(lblEmail.Text),
                                Trim(lblEndereco.Text),
                                Trim(lblNumero.Text),
                                Trim(lblComplemento.Text),
                                Trim(lblBairro.Text),
                                Trim(lblCEP.Text),
                                Cod_Cidade,
                                fStringToFloat(lblLimite.Text)
                                );

      if Assigned(ExecuteOnClose) then
        ExecuteOnClose;

      Close;
  except on E:Exception do
    vFancy.fShow(TIconDialog.Error, 'Erro', 'Erro ao salvar dados do cliente: ' + e.Message, 'OK');

  end;
end;


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
  vPermissao := T99Permissions.Create;
end;

procedure TfrmClienteCad.FormDestroy(Sender: TObject);
begin
  vFancy.DisposeOf;
  vPermissao.DisposeOf;

  if Assigned(vGeoCoder) then
    vGeoCoder.DisposeOf;
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

procedure TfrmClienteCad.ListBox1ItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  if not Assigned(frmEdicaoPadrao) then
    Application.CreateForm(TfrmEdicaoPadrao, frmEdicaoPadrao);

  if Item.Name = 'lbiCPFCNPJ' then
    FrmEdicaoPadrao.fEditar(lblCPFCNPJ,
                          TTipoCampo.Edit,
                          'CNPJ/CPF',
                          'Informe o CNPJ/CPF',
                          lblCPFCNPJ.Text,
                          True,
                          20,
                          fFormatarCampos
                          )
  else
  if Item.Name = 'lbiNome' then
    FrmEdicaoPadrao.fEditar(lblNome,
                          TTipoCampo.Edit,
                          'Nome do Cliente',
                          'Informe o nome do cliente',
                          lblNome.Text,
                          True,
                          50
                          )
  else
  if Item.Name = 'lbiFone' then
    FrmEdicaoPadrao.fEditar(lblFone,
                          TTipoCampo.Edit,
                          'Fone do Cliente',
                          'Informe o fone do cliente',
                          lblFone.Text,
                          False,
                          20,
                          fFormatarCampos
                          )
  else
  if Item.Name = 'lbiEmail' then
    FrmEdicaoPadrao.fEditar(lblEmail,
                          TTipoCampo.Edit,
                          'E-mail do Cliente',
                          'Informe o e-mail do cliente',
                          lblEmail.Text,
                          False,
                          20
                          )
  else
  if Item.Name = 'lbiEndereco' then
    FrmEdicaoPadrao.fEditar(lblEndereco,
                          TTipoCampo.Edit,
                          'Endereço do Cliente',
                          'Informe o endereço do cliente',
                          lblEndereco.Text,
                          True,
                          50
                          )
  else
  if Item.Name = 'lbiNumero' then
    FrmEdicaoPadrao.fEditar(lblNumero,
                          TTipoCampo.Edit,
                          'Número do Endereço',
                          'Informe o número do endereço',
                          lblNumero.Text,
                          False,
                          15
                          )
  else
  if Item.Name = 'lbiComplemento' then
    FrmEdicaoPadrao.fEditar(lblComplemento,
                          TTipoCampo.Edit,
                          'Completo do Cliente',
                          'Informe o complemento do cliente',
                          lblComplemento.Text,
                          False,
                          50
                          )
  else
  if Item.Name = 'lbiBairro' then
    FrmEdicaoPadrao.fEditar(lblBairro,
                          TTipoCampo.Edit,
                          'Bairro do Cliente',
                          'Informe o bairro do cliente',
                          lblBairro.Text,
                          False,
                          50
                          )
  else
  if Item.Name = 'lbiCidade' then
  begin
  if not Assigned(FrmCidade) then
    Application.CreateForm(TFrmCidade, FrmCidade);

  // Chama o formulário de cidades com o callback configurado
  FrmCidade.fShow(
    procedure(ASelected: Boolean; ACodCidade: Integer; ANomeCidade, AUF, ACEP: String)
    begin
      if ASelected then
      begin
        lblCidade.Text := ANomeCidade;
        lblUF.Text     := AUF;
        lblCEP.Text    := ACEP;
      end;
    end
  );
  end
  else
  if Item.Name = 'lbiCEP' then
    FrmEdicaoPadrao.fEditar(lblCEP,
                          TTipoCampo.Edit,
                          'CEP do Cliente',
                          'Informe o CEP do cliente',
                          lblCEP.Text,
                          True,
                          9,
                          fFormatarCampos
                          )
  else
  if Item.Name = 'lbiLimite' then
    FrmEdicaoPadrao.fEditar(lblLimite,
                          TTipoCampo.Valor,
                          'Limite do Cliente',
                          'Informe o limite do cliente',
                          lblLimite.Text,
                          False,
                          20
                          )




end;

procedure TfrmClienteCad.fFormatarCampos(Sender: TObject);
begin
  if TLabel(Sender).Name = 'lblCPFCNPJ' then
    fFormatar(Sender, TFormato.CNPJorCPF)
  else
  if TLabel(Sender).Name = 'lblFone' then
    fFormatar(Sender, TFormato.Celular)
  else
  if TLabel(Sender).Name = 'lblCEP' then
    fFormatar(Sender, TFormato.CEP);





end;


procedure TfrmClienteCad.LocationSensorLocationChanged(Sender: TObject;
  const OldLocation, NewLocation: TLocationCoord2D);
begin
  LocationSensor.Active := False;

  try
    if not Assigned(vGeoCoder) then
    begin
      if Assigned(TGeoCoder.Current) then
        vGeoCoder := tGeoCoder.Current.Create;

      if Assigned(vGeoCoder) then
        vGeoCoder.OnGeocodeReverse := fOnGeocodeReverse;
    end;

    if Assigned(vGeoCoder) and not (vGeoCoder.Geocoding) then
      vGeoCoder.GeocodeReverse(NewLocation);


  except on E:Exception do
    vFancy.fShow(TIconDialog.Error, 'Erro', 'Erro ao coletar dados de geolocalização: ' + e.Message, 'OK');

  end;

end;

procedure TfrmClienteCad.fClickDelete(Sender: TObject);
begin
  try
    DMCliente.fExcluirCliente(Cod_Cliente);

    if Assigned(ExecuteOnClose) then
      ExecuteOnClose;

    Close;
  except on E:Exception do
    vFancy.fShow(TIconDialog.Warning, 'Aviso', e.Message, 'OK');
  end;
end;

procedure TfrmClienteCad.btMapaClick(Sender: TObject);
begin
  TLoading.Show(FrmClienteCad, 'Coletando geolocalização');
  vPermissao.fLocation(fObterLocalizacao, fErroLocalizacao);
  TLoading.Hide;
end;

procedure TfrmClienteCad.fObterLocalizacao(Sender: TObject);
begin
  LocationSensor.Active := True;

end;

procedure TfrmClienteCad.fErroLocalizacao(Sender: TObject);
begin
  vFancy.fShow(TIconDialog.Error, 'Permissão', 'Você não possui acesso ao GPS do aparelho', 'OK')
end;

procedure TfrmClienteCad.fOnGeocodeReverse(const Address: TCivicAddress);
begin
  lblEndereco.Text := Address.Thoroughfare;
  lblNumero.Text   := Address.SubThoroughfare;
  lblUf.Text       := fObterUF(Address.AdminArea);
  lblCidade.Text   := Address.Locality;
  lblCEP.Text      := Address.PostalCode;
  lblBairro.Text   := Address.SubLocality;


end;


end.
