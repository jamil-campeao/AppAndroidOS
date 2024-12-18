object DM: TDM
  OnCreate = DataModuleCreate
  Height = 138
  Width = 156
  object Conn: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    LoginPrompt = False
    AfterConnect = ConnAfterConnect
    BeforeConnect = ConnBeforeConnect
    Left = 48
    Top = 40
  end
end
