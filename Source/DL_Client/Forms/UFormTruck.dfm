inherited fFormTruck: TfFormTruck
  Left = 513
  Top = 187
  ClientHeight = 376
  ClientWidth = 375
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 375
    Height = 376
    inherited BtnOK: TButton
      Left = 229
      Top = 343
      TabOrder = 12
    end
    inherited BtnExit: TButton
      Left = 299
      Top = 343
      TabOrder = 13
    end
    object EditTruck: TcxTextEdit [2]
      Left = 99
      Top = 36
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 0
      Width = 116
    end
    object EditOwner: TcxTextEdit [3]
      Left = 99
      Top = 61
      ParentFont = False
      Properties.MaxLength = 100
      TabOrder = 1
      Width = 125
    end
    object EditPhone: TcxTextEdit [4]
      Left = 99
      Top = 86
      ParentFont = False
      TabOrder = 2
      Width = 121
    end
    object CheckValid: TcxCheckBox [5]
      Left = 23
      Top = 258
      Caption = #36710#36742#20801#35768#24320#21333'.'
      ParentFont = False
      TabOrder = 7
      Transparent = True
      Width = 80
    end
    object CheckVerify: TcxCheckBox [6]
      Left = 23
      Top = 310
      Caption = #39564#35777#36710#36742#24050#21040#20572#36710#22330'.'
      ParentFont = False
      TabOrder = 10
      Transparent = True
      Width = 165
    end
    object CheckUserP: TcxCheckBox [7]
      Left = 23
      Top = 284
      Caption = #36710#36742#20351#29992#39044#32622#30382#37325'.'
      ParentFont = False
      TabOrder = 8
      Transparent = True
      Width = 165
    end
    object CheckVip: TcxCheckBox [8]
      Left = 193
      Top = 284
      Caption = 'VIP'#36710#36742
      ParentFont = False
      TabOrder = 9
      Transparent = True
      Width = 100
    end
    object CheckGPS: TcxCheckBox [9]
      Left = 193
      Top = 310
      Caption = #24050#23433#35013'GPS'
      ParentFont = False
      TabOrder = 11
      Transparent = True
      Width = 100
    end
    object EditValue: TcxTextEdit [10]
      Left = 99
      Top = 111
      ParentFont = False
      TabOrder = 3
      Text = '0.00'
      Width = 121
    end
    object EditMaxXz: TcxTextEdit [11]
      Left = 99
      Top = 161
      ParentFont = False
      TabOrder = 5
      Width = 121
    end
    object EditType: TcxComboBox [12]
      Left = 99
      Top = 136
      ParentFont = False
      Properties.DropDownListStyle = lsFixedList
      TabOrder = 4
      Width = 121
    end
    object EditDate: TcxDateEdit [13]
      Left = 99
      Top = 186
      Hint = 'E.R_Date'
      ParentFont = False
      Properties.Kind = ckDateTime
      TabOrder = 6
      Width = 336
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item9: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item5: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #36710#20027#22995#21517':'
            Control = EditOwner
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item3: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #32852#31995#26041#24335':'
            Control = EditPhone
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item11: TdxLayoutItem
            Caption = #39044#32622#30382#37325':'
            Control = EditValue
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item13: TdxLayoutItem
          Caption = #36710#36742#31867#22411':'
          Control = EditType
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item12: TdxLayoutItem
          Caption = #38480#36733#21544#20301':'
          Control = EditMaxXz
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item14: TdxLayoutItem
          Caption = 'GPS'#26377#25928#26085#26399':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        Caption = #36710#36742#21442#25968
        object dxLayout1Item4: TdxLayoutItem
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = CheckValid
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item6: TdxLayoutItem
            ShowCaption = False
            Control = CheckUserP
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            Caption = 'cxCheckBox1'
            ShowCaption = False
            Control = CheckVip
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item7: TdxLayoutItem
            Caption = 'cxCheckBox2'
            ShowCaption = False
            Control = CheckVerify
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item10: TdxLayoutItem
            Caption = 'cxCheckBox1'
            ShowCaption = False
            Control = CheckGPS
            ControlOptions.ShowBorder = False
          end
        end
      end
    end
  end
end
