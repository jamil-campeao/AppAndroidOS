object DM: TDM
  OnCreate = DataModuleCreate
  Height = 189
  Width = 286
  object Conn: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    LoginPrompt = False
    AfterConnect = ConnAfterConnect
    BeforeConnect = ConnBeforeConnect
    Left = 80
    Top = 56
  end
end
