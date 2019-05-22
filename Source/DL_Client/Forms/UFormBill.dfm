inherited fFormBill: TfFormBill
  Left = 448
  Top = 32
  ClientHeight = 568
  ClientWidth = 507
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 507
    Height = 568
    AutoControlTabOrders = False
    inherited BtnOK: TButton
      Left = 361
      Top = 535
      Caption = #24320#21333
      TabOrder = 8
    end
    inherited BtnExit: TButton
      Left = 431
      Top = 535
      TabOrder = 13
    end
    object ListInfo: TcxMCListBox [2]
      Left = 23
      Top = 36
      Width = 368
      Height = 224
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 74
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 290
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
    end
    object EditValue: TcxTextEdit [3]
      Left = 289
      Top = 389
      ParentFont = False
      TabOrder = 4
      OnKeyPress = EditLadingKeyPress
      Width = 120
    end
    object EditTruck: TcxTextEdit [4]
      Left = 289
      Top = 364
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 3
      OnKeyPress = EditLadingKeyPress
      Width = 116
    end
    object EditLading: TcxComboBox [5]
      Left = 81
      Top = 389
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        'T=T'#12289#33258#25552
        'S=S'#12289#36865#36135
        'X=X'#12289#36816#21368)
      TabOrder = 2
      OnKeyPress = EditLadingKeyPress
      Width = 145
    end
    object EditType: TcxComboBox [6]
      Left = 81
      Top = 364
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        'C=C'#12289#26222#36890
        'Z=Z'#12289#26632#21488
        'V=V'#12289'VIP'
        'S=S'#12289#33337#36816)
      TabOrder = 1
      OnKeyPress = EditLadingKeyPress
      Width = 145
    end
    object PrintGLF: TcxCheckBox [7]
      Left = 11
      Top = 535
      Caption = #25171#21360#36807#36335#36153
      ParentFont = False
      TabOrder = 6
      Transparent = True
      Width = 95
    end
    object PrintHY: TcxCheckBox [8]
      Left = 111
      Top = 535
      Caption = #25171#21360#36136#37327#25215#35834#20070
      ParentFont = False
      TabOrder = 7
      Transparent = True
      Width = 111
    end
    object cxLabel1: TcxLabel [9]
      Left = 23
      Top = 465
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 8
      Width = 370
    end
    object EditPhone: TcxTextEdit [10]
      Left = 289
      Top = 478
      AutoSize = False
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 5
      Height = 20
      Width = 342
    end
    object EditDate: TcxDateEdit [11]
      Left = 81
      Top = 478
      ParentFont = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 14
      Width = 145
    end
    object chkMaxMValue: TcxCheckBox [12]
      Left = 23
      Top = 414
      Caption = #27611#37325#38480#20540#35774#23450':'
      ParentFont = False
      TabOrder = 15
      OnClick = chkMaxMValueClick
      Width = 202
    end
    object EditMaxMValue: TcxTextEdit [13]
      Left = 288
      Top = 414
      ParentFont = False
      TabOrder = 16
      Text = '70'
      Width = 191
    end
    object CalYF: TcxCheckBox [14]
      Left = 227
      Top = 535
      Caption = #35745#31639#36816#36153
      ParentFont = False
      TabOrder = 17
      Width = 121
    end
    object EditPack: TcxComboBox [15]
      Left = 81
      Top = 440
      ParentFont = False
      Properties.DropDownListStyle = lsFixedList
      Properties.ReadOnly = False
      Properties.OnChange = EditPackPropertiesChange
      TabOrder = 18
      Width = 144
    end
    object EditLine: TcxComboBox [16]
      Left = 81
      Top = 503
      AutoSize = False
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      TabOrder = 19
      Height = 20
      Width = 145
    end
    object EditHYDan: TcxComboBox [17]
      Left = 289
      Top = 503
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      TabOrder = 20
      Width = 191
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avBottom
        Caption = #25552#21333#26126#32454
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group4: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item6: TdxLayoutItem
              AutoAligns = [aaVertical]
              Caption = #25552#36135#36890#36947':'
              Control = EditType
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item9: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #25552#36135#36710#36742':'
              Control = EditTruck
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group6: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item12: TdxLayoutItem
              AutoAligns = [aaVertical]
              Caption = #25552#36135#26041#24335':'
              Control = EditLading
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item8: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #21150#29702#21544#25968':'
              Control = EditValue
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item7: TdxLayoutItem
            Caption = 'cxCheckBox1'
            ShowCaption = False
            Control = chkMaxMValue
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            Caption = #35774#23450#38480#20540':'
            Control = EditMaxMValue
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item11: TdxLayoutItem
          Caption = #21253#35013#31867#22411':'
          Control = EditPack
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group5: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group8: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item15: TdxLayoutItem
              AutoAligns = [aaVertical]
              Caption = #34917#21333#26102#38388
              Control = EditDate
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item10: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #21496#26426#30005#35805':'
              Control = EditPhone
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group7: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item17: TdxLayoutItem
              Caption = #21457#36135#36890#36947':'
              Control = EditLine
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item18: TdxLayoutItem
              Caption = #36873#25321#25209#27425':'
              Control = EditHYDan
              ControlOptions.ShowBorder = False
            end
          end
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        object dxLayout1Item13: TdxLayoutItem [0]
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Visible = False
          Control = PrintGLF
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item14: TdxLayoutItem [1]
          ShowCaption = False
          Control = PrintHY
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item16: TdxLayoutItem [2]
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = CalYF
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
