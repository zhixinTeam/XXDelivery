inherited fFormPurchasePlan: TfFormPurchasePlan
  Left = 686
  Top = 274
  Caption = 'fFormPurchasePlan'
  ClientHeight = 248
  ClientWidth = 445
  Font.Height = -13
  PixelsPerInch = 96
  TextHeight = 13
  inherited dxLayout1: TdxLayoutControl
    Width = 445
    Height = 248
    object lbl1: TLabel [0]
      Left = 192
      Top = 161
      Width = 33
      Height = 13
      Caption = #36710'/'#22825'    '
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    object lbl2: TLabel [1]
      Left = 230
      Top = 161
      Width = 154
      Height = 13
      Caption = #65288#19981#36755#20837#20540#34920#31034#19981#38480#21046#65289
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    object lbl3: TLabel [2]
      Left = 25
      Top = 39
      Width = 336
      Height = 13
      Caption = #21697#31181#21517#31216#12289#20379#24212#21830#21517#31216#36755#20837#20851#38190#23383#22238#36710#21487#26816#32034#30456#20851#20449#24687
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    inherited BtnOK: TButton
      Left = 272
      Top = 208
      Width = 78
      Height = 28
      Font.Height = -15
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
    end
    inherited BtnExit: TButton
      Left = 355
      Top = 208
      Width = 78
      Height = 28
      Font.Height = -15
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
    end
    object cbbProvider: TcxComboBox [5]
      Left = 95
      Top = 135
      Hint = 'T.P_PrvName'
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.MaxLength = 30
      Properties.OnCloseUp = cbbProviderPropertiesCloseUp
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 3
      OnKeyPress = cbbProviderKeyPress
      Width = 198
    end
    object cbbMaterials: TcxComboBox [6]
      Left = 95
      Top = 83
      Hint = 'T.P_MName'
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.MaxLength = 30
      Properties.OnCloseUp = cbbMaterialsPropertiesCloseUp
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 1
      OnKeyPress = cbbMaterialsKeyPress
      Width = 198
    end
    object edt_MaxNum: TcxTextEdit [7]
      Left = 95
      Top = 161
      Hint = 'T.P_MaxNum'
      ParentFont = False
      Properties.MaxLength = 18
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 4
      Width = 92
    end
    object edt_Provider: TcxTextEdit [8]
      Left = 95
      Top = 109
      Hint = 'T.P_PrvID'
      ParentFont = False
      Properties.MaxLength = 18
      Properties.ReadOnly = True
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 2
      Width = 198
    end
    object edt_Materials: TcxTextEdit [9]
      Left = 95
      Top = 57
      Hint = 'T.P_MID'
      ParentFont = False
      Properties.MaxLength = 18
      Properties.ReadOnly = True
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      Width = 198
    end
    object Chk1: TcxCheckBox [10]
      Left = 12
      Top = 208
      Caption = #25209#37327#28155#21152#65288#20445#23384#21518#19981#20851#38381#31383#21475#65289
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 5
      Width = 200
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxlytmLayout1Item37: TdxLayoutItem
          ShowCaption = False
          Control = lbl3
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item35: TdxLayoutItem
          AutoAligns = [aaVertical]
          Caption = #21697#31181#32534#21495':'
          Control = edt_Materials
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item31: TdxLayoutItem
          Caption = #21697#31181#21517#31216':'
          Control = cbbMaterials
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item34: TdxLayoutItem
          AutoAligns = [aaVertical]
          Caption = #20379#24212#21830#32534#21495':'
          Control = edt_Provider
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item3: TdxLayoutItem
          Caption = #20379#24212#21830#21517#31216':'
          Control = cbbProvider
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxlytmLayout1Item32: TdxLayoutItem
            AutoAligns = [aaVertical]
            Caption = #27599#26085#38480#37327':'
            Control = edt_MaxNum
            ControlOptions.ShowBorder = False
          end
          object dxlytmLayout1Item33: TdxLayoutItem
            ShowCaption = False
            Control = lbl1
            ControlOptions.AutoColor = True
            ControlOptions.ShowBorder = False
          end
          object dxlytmLayout1Item36: TdxLayoutItem
            ShowCaption = False
            Control = lbl2
            ControlOptions.AutoColor = True
            ControlOptions.ShowBorder = False
          end
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        object dxlytmLayout1Item38: TdxLayoutItem [0]
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = Chk1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
