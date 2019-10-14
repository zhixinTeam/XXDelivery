inherited fFormStockGroup: TfFormStockGroup
  Left = 696
  Top = 311
  Caption = #21697#31181#20998#32452#31649#29702
  ClientHeight = 135
  ClientWidth = 355
  Font.Height = -13
  Font.Name = #24494#36719#38597#40657
  PixelsPerInch = 96
  TextHeight = 19
  inherited dxLayout1: TdxLayoutControl
    Width = 355
    Height = 135
    inherited BtnOK: TButton
      Left = 206
      Top = 99
      TabOrder = 1
    end
    inherited BtnExit: TButton
      Left = 276
      Top = 99
      TabOrder = 2
    end
    object edt_Name: TcxTextEdit [2]
      Left = 87
      Top = 50
      ParentFont = False
      Properties.ReadOnly = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsOffice11
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -15
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      Width = 235
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxlytmLayout1Item3: TdxLayoutItem
          Caption = #20998#32452#21517#31216':'
          Control = edt_Name
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
