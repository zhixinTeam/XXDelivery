inherited fFormSalePlanDtl: TfFormSalePlanDtl
  Left = 870
  Top = 268
  Caption = #23458#25143#12289#21697#31181#20998#32452#38480#37327
  ClientHeight = 354
  ClientWidth = 395
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 20
  inherited dxLayout1: TdxLayoutControl
    Width = 395
    Height = 354
    object lbl_Cus: TLabel [0]
      Left = 31
      Top = 156
      Width = 65
      Height = 19
      Caption = #23458#25143#32534#21495#65306
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lbl_CusID: TLabel [1]
      Left = 101
      Top = 156
      Width = 68
      Height = 19
      Caption = '                 '
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lbl1: TLabel [2]
      Left = 31
      Top = 84
      Width = 65
      Height = 19
      Caption = #38480#37327#20998#32452#65306
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lbl2: TLabel [3]
      Left = 31
      Top = 108
      Width = 65
      Height = 19
      Caption = #24320#22987#26085#26399#65306
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lbl3: TLabel [4]
      Left = 31
      Top = 132
      Width = 65
      Height = 19
      Caption = #32467#26463#26085#26399#65306
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lbl_ETime: TLabel [5]
      Left = 101
      Top = 132
      Width = 68
      Height = 19
      Caption = '                 '
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lbl_STime: TLabel [6]
      Left = 101
      Top = 108
      Width = 68
      Height = 19
      Caption = '                 '
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lbl_GroupName: TLabel [7]
      Left = 101
      Top = 84
      Width = 68
      Height = 19
      Caption = '                 '
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lbl4: TLabel [8]
      Left = 31
      Top = 212
      Width = 350
      Height = 26
      Alignment = taCenter
      AutoSize = False
      Caption = '24'#23567#26102#20869#20801#35768#24320#21333#19978#38480
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -13
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    inherited BtnOK: TButton
      Left = 245
      Top = 317
      TabOrder = 6
    end
    inherited BtnExit: TButton
      Left = 315
      Top = 317
      TabOrder = 7
    end
    object Edt_CusName: TcxButtonEdit [11]
      Left = 95
      Top = 180
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = Edt_EditCus1PropertiesButtonClick
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 1
      Width = 319
    end
    object edt_MaxNum: TcxTextEdit [12]
      Left = 113
      Top = 275
      Enabled = False
      ParentFont = False
      Properties.ReadOnly = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsOffice11
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 5
      Width = 97
    end
    object Rb1: TcxRadioButton [13]
      Left = 31
      Top = 275
      Width = 77
      Height = 27
      Caption = #27599#26085#36710#25968#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 4
      OnClick = Rb1Click
    end
    object Rb2: TcxRadioButton [14]
      Left = 31
      Top = 243
      Width = 77
      Height = 27
      Caption = #27599#26085#21544#25968#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 2
      OnClick = Rb1Click
    end
    object edt_MaxValue: TcxTextEdit [15]
      Left = 113
      Top = 243
      Enabled = False
      ParentFont = False
      Properties.ReadOnly = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsOffice11
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 3
      Width = 97
    end
    object cbb_Plan: TcxComboBox [16]
      Left = 95
      Top = 52
      ParentFont = False
      Properties.OnChange = cbb_PlanPropertiesChange
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      Width = 299
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxlytmLayout1Item71: TdxLayoutItem
            Caption = #25152#23646#35745#21010#65306
            Control = cbb_Plan
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Group6: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxlytmLayout1Item72: TdxLayoutItem
              AutoAligns = [aaVertical]
              ShowCaption = False
              Control = lbl1
              ControlOptions.AutoColor = True
              ControlOptions.ShowBorder = False
            end
            object dxlytmLayout1Item77: TdxLayoutItem
              ShowCaption = False
              Control = lbl_GroupName
              ControlOptions.AutoColor = True
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group7: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxlytmLayout1Item73: TdxLayoutItem
              AutoAligns = [aaVertical]
              ShowCaption = False
              Control = lbl2
              ControlOptions.AutoColor = True
              ControlOptions.ShowBorder = False
            end
            object dxlytmLayout1Item76: TdxLayoutItem
              ShowCaption = False
              Control = lbl_STime
              ControlOptions.AutoColor = True
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group8: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxlytmLayout1Item74: TdxLayoutItem
              AutoAligns = [aaVertical]
              ShowCaption = False
              Control = lbl3
              ControlOptions.AutoColor = True
              ControlOptions.ShowBorder = False
            end
            object dxlytmLayout1Item75: TdxLayoutItem
              ShowCaption = False
              Control = lbl_ETime
              ControlOptions.AutoColor = True
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group5: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxlytmLayout1Item33: TdxLayoutItem
              AutoAligns = [aaVertical]
              ShowCaption = False
              Control = lbl_Cus
              ControlOptions.AutoColor = True
              ControlOptions.ShowBorder = False
            end
            object dxlytmLayout1Item7: TdxLayoutItem
              ShowCaption = False
              Control = lbl_CusID
              ControlOptions.AutoColor = True
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxlytmLayout1Item31: TdxLayoutItem
          Caption = #23458#25143#21517#31216#65306
          Control = Edt_CusName
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item78: TdxLayoutItem
          ShowCaption = False
          Control = lbl4
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item5: TdxLayoutItem
            ShowCaption = False
            Control = Rb2
            ControlOptions.AutoColor = True
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item6: TdxLayoutItem
            Control = edt_MaxValue
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item4: TdxLayoutItem
            ShowCaption = False
            Control = Rb1
            ControlOptions.AutoColor = True
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item3: TdxLayoutItem
            Control = edt_MaxNum
            ControlOptions.ShowBorder = False
          end
        end
      end
    end
  end
end
