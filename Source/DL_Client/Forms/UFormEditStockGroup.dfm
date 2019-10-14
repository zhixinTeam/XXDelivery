inherited fFormEditStockGroup: TfFormEditStockGroup
  Left = 688
  Top = 302
  Caption = #21697#31181#20998#32452#35843#25972
  ClientHeight = 156
  ClientWidth = 335
  Font.Height = -13
  Font.Name = #24494#36719#38597#40657
  PixelsPerInch = 96
  TextHeight = 19
  inherited dxLayout1: TdxLayoutControl
    Width = 335
    Height = 156
    object lbl1: TLabel [0]
      Left = 29
      Top = 50
      Width = 65
      Height = 19
      Caption = #21697#31181#21517#31216#65306
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    inherited BtnOK: TButton
      Left = 186
      Top = 120
      TabOrder = 1
    end
    inherited BtnExit: TButton
      Left = 256
      Top = 120
      TabOrder = 2
    end
    object cbb_Group: TcxComboBox [3]
      Left = 93
      Top = 74
      Hint = 'T.C_SaleMan'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.ItemHeight = 20
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      Width = 213
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxlytmLayout1Item3: TdxLayoutItem
          ShowCaption = False
          Control = lbl1
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item31: TdxLayoutItem
          Caption = #38582#23646#20998#32452#65306
          Control = cbb_Group
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
