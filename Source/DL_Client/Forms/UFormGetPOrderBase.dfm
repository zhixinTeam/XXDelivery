inherited fFormGetPOrderBase: TfFormGetPOrderBase
  Left = 401
  Top = 134
  Width = 765
  Height = 542
  BorderStyle = bsSizeable
  Constraints.MinHeight = 300
  Constraints.MinWidth = 445
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 749
    Height = 504
    inherited BtnOK: TButton
      Left = 603
      Top = 471
      Caption = #30830#23450
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 673
      Top = 471
      TabOrder = 6
    end
    object ListQuery: TcxListView [2]
      Left = 23
      Top = 112
      Width = 417
      Height = 145
      Columns = <
        item
          Caption = #30003#35831#21333#32534#21495
          Width = 1
        end
        item
          Caption = #21407#26448#26009
          Width = 150
        end
        item
          Caption = #22411#21495
          Width = 1
        end
        item
          Caption = #20379#24212#21830
          Width = 200
        end
        item
          Caption = #30719#28857
          Width = 1
        end
        item
          Caption = #35746#21333#21097#20313
          Width = 80
        end
        item
          Caption = #22791#27880
          Width = 80
        end
        item
          Caption = #35746#21333#34892
          Width = 1
        end>
      HideSelection = False
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      SmallImages = FDM.ImageBar
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 4
      ViewStyle = vsReport
      OnDblClick = ListQueryDblClick
      OnKeyPress = ListQueryKeyPress
    end
    object cxLabel1: TcxLabel [3]
      Left = 23
      Top = 91
      Caption = #26597#35810#32467#26524':'
      ParentFont = False
      Transparent = True
    end
    object EditOrderType: TcxComboBox [4]
      Left = 81
      Top = 36
      Enabled = False
      ParentFont = False
      Properties.DropDownListStyle = lsFixedList
      Properties.Items.Strings = (
        #26222#36890#21407#26448#26009
        #20869#20498#21407#26448#26009)
      Properties.ReadOnly = False
      Properties.OnChange = orderange
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 0
      Text = #26222#36890#21407#26448#26009
      Width = 644
    end
    object EditProvider: TcxComboBox [5]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.OnChange = EditProviderPropertiesChange
      TabOrder = 1
      Width = 541
    end
    object BtnSearch: TcxButton [6]
      Left = 627
      Top = 61
      Width = 97
      Height = 25
      Caption = #26597#35810
      TabOrder = 2
      OnClick = BtnSearchClick
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #26597#35810#26465#20214
        object dxLayout1Item8: TdxLayoutItem
          Caption = #35746#21333#31867#22411':'
          Control = EditOrderType
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item3: TdxLayoutItem
            Caption = #20379' '#24212' '#21830':'
            Control = EditProvider
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item4: TdxLayoutItem
            Caption = 'cxButton1'
            ShowCaption = False
            Control = BtnSearch
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item7: TdxLayoutItem
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Control = ListQuery
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
