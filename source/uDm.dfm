object Dm: TDm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 268
  Width = 387
  object FDConn: TFDConnection
    Params.Strings = (
      'Database=vendaswk'
      'User_Name=root'
      'Server=localhost'
      'Password=root'
      'DriverID=MySQL')
    TxOptions.AutoStop = False
    TxOptions.DisconnectAction = xdNone
    LoginPrompt = False
    Left = 72
    Top = 24
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    ScreenCursor = gcrNone
    Left = 72
    Top = 80
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 'C:\Softwares\WK\source\libmysql.dll'
    Left = 72
    Top = 136
  end
end
