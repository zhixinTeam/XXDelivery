inherited fFrameStockGroup: TfFrameStockGroup
  Width = 840
  Height = 445
  inherited ToolBar1: TToolBar
    Width = 840
    inherited BtnAdd: TToolButton
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      Tag = 1
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      Tag = 1
      OnClick = BtnDelClick
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 134
    Width = 840
    Height = 311
    LevelTabs.Slants.Kind = skCutCorner
    LevelTabs.Style = 9
    RootLevelOptions.DetailTabsPosition = dtpTop
    OnActiveTabChanged = cxGrid1ActiveTabChanged
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
      OnDblClick = cxView1DblClick
    end
    object cxView2: TcxGridDBTableView [1]
      NavigatorButtons.ConfirmDelete = False
      OnCellDblClick = cxView2CellDblClick
      DataController.DataSource = DataSource2
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
    end
    inherited cxLevel1: TcxGridLevel
      Caption = '  '#21697#31181#20998#32452'  '
    end
    object cxLevel2: TcxGridLevel
      Caption = '  '#21697#31181#20998#32452#26126#32454'  '
      GridView = cxView2
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 840
    Height = 67
    object Edt_GName: TcxButtonEdit [0]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = Edt_GNamePropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 155
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #20998#32452#21517#31216':'
          Control = Edt_GName
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        Visible = False
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 126
    Width = 840
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 840
    inherited TitleBar: TcxLabel
      Caption = #21697#31181#20998#32452#31649#29702
      Style.IsFontAssigned = True
      Width = 840
      AnchorX = 420
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 2
    Top = 262
  end
  inherited DataSource1: TDataSource
    Left = 30
    Top = 262
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 2
    Top = 318
    object N1: TMenuItem
      Caption = #26597#30475#20998#32452#29289#26009#26126#32454
      OnClick = N1Click
    end
    object N7: TMenuItem
      Caption = '-'
    end
  end
  object DataSource2: TDataSource
    DataSet = SQLNo1
    Left = 30
    Top = 290
  end
  object SQLNo1: TADOQuery
    Connection = FDM.ADOConn
    Parameters = <>
    Left = 2
    Top = 290
  end
  object pm1: TPopupMenu
    AutoHotkeys = maManual
    Left = 65
    Top = 316
    object N2: TMenuItem
      Caption = #26597#30475#25152#26377#29289#26009#21697#31181
      OnClick = N2Click
    end
    object MenuItem2: TMenuItem
      Caption = '-'
    end
    object MenuItem1: TMenuItem
      Caption = #35843#25972#29289#26009#20998#32452
      OnClick = MenuItem1Click
    end
  end
end
