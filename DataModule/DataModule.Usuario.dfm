object DmUsuario: TDmUsuario
  OnCreate = DataModuleCreate
  Height = 480
  Width = 369
  object qryUsuario: TFDQuery
    Connection = DM.Conn
    Left = 168
    Top = 64
  end
  object qryConsUsuario: TFDQuery
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
    Left = 64
    Top = 168
  end
end
