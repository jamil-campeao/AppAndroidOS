object DmUsuario: TDmUsuario
  OnCreate = DataModuleCreate
  Height = 199
  Width = 237
  object qryUsuario: TFDQuery
    Connection = DM.Conn
    Left = 168
    Top = 64
  end
  object qryConsUsuario: TFDQuery
    Connection = DM.Conn
    Left = 64
    Top = 64
  end
  object TabUsuario: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 104
    Top = 128
  end
end
