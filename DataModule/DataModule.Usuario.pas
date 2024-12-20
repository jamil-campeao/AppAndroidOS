unit DataModule.Usuario;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, RESTRequest4D, System.JSON,
  uConstantes, uSession;

type
  TDmUsuario = class(TDataModule)
    qryUsuario: TFDQuery;
    qryConsUsuario: TFDQuery;
    TabUsuario: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure fEditarUsuario(pNome, pLogin: string);
    procedure fListarUsuarios;
    procedure fInserirUsuario(pCodUsuario: integer;
                                    pNome, pLogin, pSenha, pTokenJWT: string);
    procedure fExcluirUsuario;
    procedure fEditarSenha(pSenha: string);
    procedure fLogout;
    procedure fDesativarOnboarding;
    procedure fLoginWeb(pLogin, pSenha: string);
    procedure fNovaContaWeb(pNome, pLogin, pSenha: string);
    procedure fEditarUsuarioWeb(nome, email: string);
    procedure fEditarSenhaWeb(senha: string);
    function fObterDataServidor: string;
    procedure fExcluirContaWeb;
  end;

var
  DmUsuario: TDmUsuario;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses DMGlobal;

{$R *.dfm}

procedure TDmUsuario.fListarUsuarios;
begin
    qryConsUsuario.SQL.Clear;
    qryConsUsuario.SQL.Add('select * from USUARIO');
    qryConsUsuario.Open;
end;

procedure TDmUsuario.fInserirUsuario(pCodUsuario: integer;
                                    pNome, pLogin, pSenha, pTokenJWT: string);
begin
    qryUsuario.SQL.Clear;
    qryUsuario.SQL.Text := ' insert into USUARIO(USU_CODIGO, USU_NOME, USU_LOGIN, USU_SENHA, USU_TOKENJWT, IND_LOGIN, IND_ONBOARDING) '+
                           ' values(:USU_CODIGO, :USU_NOME, :USU_LOGIN, :USU_SENHA, :USU_TOKENJWT, :IND_LOGIN, :IND_ONBOARDING)       ';

    qryUsuario.ParamByName('USU_CODIGO').Value     := pCodUsuario;
    qryUsuario.ParamByName('USU_NOME').Value       := pNome;
    qryUsuario.ParamByName('USU_LOGIN').Value      := pLogin;
    qryUsuario.ParamByName('USU_SENHA').Value      := pSenha;
    qryUsuario.ParamByName('USU_TOKENJWT').Value   := pTokenJWT;
    qryUsuario.ParamByName('IND_LOGIN').Value      := 'S';
    qryUsuario.ParamByName('IND_ONBOARDING').Value := 'N';

    qryUsuario.ExecSQL;
end;

procedure TDmUsuario.fEditarUsuario(pNome, pLogin: string);
begin
    qryUsuario.SQL.Clear;
    qryUsuario.SQL.Text := 'UPDATE USUARIO SET USU_NOME = :USU_NOME, USU_LOGIN= :USU_LOGIN';

    qryUsuario.ParamByName('USU_NOME').Value  := pNome;
    qryUsuario.ParamByName('USU_LOGIN').Value := pLogin;

    qryUsuario.ExecSQL;
end;

procedure TDmUsuario.fExcluirUsuario;
begin
    qryUsuario.Active   := false;
    qryUsuario.SQL.Clear;
    qryUsuario.SQL.Text := 'DELETE FROM USUARIO';
    qryUsuario.ExecSQL;
end;

procedure TDmUsuario.fEditarSenha(pSenha: string);
begin
    qryUsuario.SQL.Clear;
    qryUsuario.SQL.Text := 'UPDATE USUARIO SET USU_SENHA =:USU_SENHA';

    qryUsuario.ParamByName('USU_SENHA').AsString := pSenha;

    qryUsuario.ExecSQL;
end;

procedure TDmUsuario.fLogout;
begin
    qryUsuario.SQL.Clear;
    qryUsuario.SQL.Text := ' UPDATE USUARIO SET IND_LOGIN =:IND_LOGIN, IND_ONBOARDING=:IND_ONBOARDING ';
    qryUsuario.ParamByName('IND_LOGIN').AsString      := 'N';
    qryUsuario.ParamByName('IND_ONBOARDING').AsString := 'N';
    qryUsuario.ExecSQL;


    qryUsuario.SQL.Clear;
    qryUsuario.SQL.Add('DELETE FROM OSPRODUTO');
    qryUsuario.ExecSQL;

    qryUsuario.SQL.Clear;
    qryUsuario.SQL.Add('DELETE FROM OSPRODUTO_TEMP');
    qryUsuario.ExecSQL;

    qryUsuario.SQL.Clear;
    qryUsuario.SQL.Add('DELETE FROM OSSERVICO');
    qryUsuario.ExecSQL;

    qryUsuario.SQL.Clear;
    qryUsuario.SQL.Add('DELETE FROM OSSERVICOTERCEIROS');
    qryUsuario.ExecSQL;

    qryUsuario.SQL.Clear;
    qryUsuario.SQL.Add('DELETE FROM OSSERVICO_TEMP');
    qryUsuario.ExecSQL;

    qryUsuario.SQL.Clear;
    qryUsuario.SQL.Add('DELETE FROM OSSERVICOTERCEIROS_TEMP');
    qryUsuario.ExecSQL;

    qryUsuario.SQL.Clear;
    qryUsuario.SQL.Add('DELETE FROM OS');
    qryUsuario.ExecSQL;

    qryUsuario.SQL.Clear;
    qryUsuario.SQL.Add('DELETE FROM NOTIFICACAO');
    qryUsuario.ExecSQL;

    qryUsuario.SQL.Clear;
    qryUsuario.SQL.Add('DELETE FROM PRODUTO');
    qryUsuario.ExecSQL;

    qryUsuario.SQL.Clear;
    qryUsuario.SQL.Add('DELETE FROM CLIENTE');
    qryUsuario.ExecSQL;

    qryUsuario.SQL.Clear;
    qryUsuario.SQL.Add('DELETE FROM FORMAPAGAMENTO');
    qryUsuario.ExecSQL;

    qryUsuario.SQL.Clear;
    qryUsuario.SQL.Add('DELETE FROM TAB_CONFIG WHERE CAMPO <> ''VERSAO'' ');
    qryUsuario.ExecSQL;
end;

procedure TDmUsuario.DataModuleCreate(Sender: TObject);
begin
  qryUsuario.ConnectionName
end;

procedure TDmUsuario.fDesativarOnboarding;
begin
    qryUsuario.SQL.Clear;
    qryUsuario.SQL.Add('UPDATE USUARIO SET IND_ONBOARDING = :IND_ONBOARDING');

    qryUsuario.ParamByName('IND_ONBOARDING').AsString := 'N';

    qryUsuario.ExecSQL;
end;

procedure TDmUsuario.fLoginWeb(pLogin, pSenha: string);
var
    vResp: IResponse;
    vJson: TJsonObject;
begin
    TabUsuario.FieldDefs.Clear;

    try
        vJson := TJsonObject.Create;
        vJson.AddPair('login', pLogin);
        vJson.AddPair('senha', pSenha);

        vResp := TRequest.New.BaseURL(cBASE_URL)
                .Resource('usuarios/login')
                .AddBody(vJson.ToJSON)
                .Accept('application/json')
                .DataSetAdapter(TabUsuario)
                .Post;

        if vResp.StatusCode <> 200 then
            raise Exception.Create(vResp.Content);

    finally
        vJson.DisposeOf;
    end;
end;

procedure TDmUsuario.fNovaContaWeb(pNome, pLogin, pSenha: string);
var
    resp: IResponse;
    json: TJsonObject;
begin
    TabUsuario.FieldDefs.Clear;

    try
        json := TJsonObject.Create;
        json.AddPair('nome_usuario', pNome);
        json.AddPair('login', pLogin);
        json.AddPair('senha', pSenha);

        resp := TRequest.New.BaseURL(cBASE_URL)
                .Resource('usuarios')
                .AddBody(json.ToJSON)
                .Accept('application/json')
                .DataSetAdapter(TabUsuario)
                .Post;

        if resp.StatusCode <> 201 then
            raise Exception.Create(resp.Content);

    finally
        json.DisposeOf;
    end;
end;

procedure TDmUsuario.fEditarUsuarioWeb(nome, email: string);
var
    resp: IResponse;
    json: TJsonObject;
begin
    TabUsuario.FieldDefs.Clear;

    try
        json := TJsonObject.Create;
        json.AddPair('nome', nome);
        json.AddPair('email', email);

        resp := TRequest.New.BaseURL(cBASE_URL)
                .Resource('usuarios')
                .TokenBearer(TSession.TOKEN_JWT)
                .AddBody(json.ToJSON)
                .Accept('application/json')
                .DataSetAdapter(TabUsuario)
                .Put;

        if resp.StatusCode <> 200 then
            raise Exception.Create(resp.Content);

    finally
        json.DisposeOf;
    end;
end;

procedure TDmUsuario.fEditarSenhaWeb(senha: string);
var
    resp: IResponse;
    json: TJsonObject;
begin
    TabUsuario.FieldDefs.Clear;

    try
        json := TJsonObject.Create;
        json.AddPair('senha', senha);

        resp := TRequest.New.BaseURL(cBASE_URL)
                .Resource('usuarios/senha')
                .TokenBearer(TSession.TOKEN_JWT)
                .AddBody(json.ToJSON)
                .Accept('application/json')
                .Put;

        if resp.StatusCode <> 200 then
            raise Exception.Create(resp.Content);

    finally
        json.DisposeOf;
    end;
end;

function TDmUsuario.fObterDataServidor(): string;
var
    resp: IResponse;
begin

    resp := TRequest.New.BaseURL(cBASE_URL)
            .Resource('usuarios/horario')
            .TokenBearer(TSession.TOKEN_JWT)
            .Accept('application/json')
            .Get;

    if resp.StatusCode <> 200 then
        raise Exception.Create(resp.Content)
    else
        Result := resp.Content;  // 2022-11-11 17:20:11
end;

procedure TDmUsuario.fExcluirContaWeb;
var
    vResp: IResponse;
begin
    vResp := TRequest.New.BaseURL(cBASE_URL)
            .Resource('usuarios')  // Horse
            .ResourceSuffix(TSession.COD_USUARIO.ToString) // Horse

            //.Resource('usuarios/perfil')   // RDW
            //.ResourceSuffix(TSession.COD_USUARIO.ToString + '/0')  // RDW

            .TokenBearer(TSession.TOKEN_JWT)
            .Accept('application/json')
            .Delete;

    if vResp.StatusCode <> 200 then
        raise Exception.Create(vResp.Content);

end;

end.
