unit uSession;

interface

type
  TSession = class
  private
    class var FCOD_USUARIO: integer;
    class var FLOGIN: string;
    class var FNOME: string;
    class var FTOKEN_JWT: string;

  public
    class property COD_USUARIO: integer read FCOD_USUARIO write FCOD_USUARIO;
    class property NOME: string read FNOME write FNOME;
    class property LOGIN: string read FLOGIN write FLOGIN;
    class property TOKEN_JWT: string read FTOKEN_JWT write FTOKEN_JWT;
  end;

implementation

end.
