inherited fFormBatchGetCus: TfFormBatchGetCus
  Left = 685
  Top = 226
  Width = 679
  Height = 432
  BorderStyle = bsSizeable
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 663
    Height = 393
    inherited BtnOK: TButton
      Left = 517
      Top = 360
      Caption = #30830#23450
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      ParentFont = False
      TabOrder = 4
    end
    inherited BtnExit: TButton
      Left = 587
      Top = 360
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      ParentFont = False
      TabOrder = 5
    end
    object GridOrders: TcxGrid [2]
      Left = 23
      Top = 68
      Width = 250
      Height = 200
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      object cxView1: TcxGridDBTableView
        OnMouseDown = cxView1MouseDown
        NavigatorButtons.ConfirmDelete = False
        OnCellClick = cxView1CellClick
        DataController.DataSource = DataSource1
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsSelection.CellMultiSelect = True
        object cxView1Column1: TcxGridDBColumn
          Caption = #36873#25321
          DataBinding.FieldName = 'Chk'
          PropertiesClassName = 'TcxCheckBoxProperties'
          Properties.NullStyle = nssUnchecked
          Properties.ValueChecked = 1
          Properties.ValueUnchecked = 0
          Properties.OnChange = cxView1Column1PropertiesChange
          Options.Editing = False
          Options.Filtering = False
          Options.IncSearch = False
          Width = 49
        end
        object cxView1Column2: TcxGridDBColumn
          Caption = #23458#25143#32534#21495
          DataBinding.FieldName = 'C_ID'
          Width = 98
        end
        object cxView1Column3: TcxGridDBColumn
          Caption = #23458#25143#21517#31216
          DataBinding.FieldName = 'C_Name'
          Width = 429
        end
      end
      object cxLevel1: TcxGridLevel
        GridView = cxView1
      end
    end
    object EditCus: TcxButtonEdit [3]
      Left = 81
      Top = 36
      ParentFont = False
      ParentShowHint = False
      Properties.Buttons = <>
      ShowHint = True
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      OnKeyPress = EditCusKeyPress
      Width = 228
    end
    object BtnSearch: TcxButton [4]
      Left = 440
      Top = 36
      Width = 75
      Height = 25
      Caption = #26597#35810
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = BtnSearchClick
    end
    object Chk1: TcxCheckBox [5]
      Left = 314
      Top = 36
      Caption = #32465#23450#24494#20449#23458#25143
      ParentColor = False
      ParentFont = False
      Style.Color = clWhite
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clWhite
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.TextStyle = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 1
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #35746#21333#21015#34920
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item4: TdxLayoutItem
            AutoAligns = [aaVertical]
            Caption = #23458#25143#21517#31216':'
            Control = EditCus
            ControlOptions.ShowBorder = False
          end
          object dxlytmLayout1Item5: TdxLayoutItem
            Caption = 'cxCheckBox1'
            ShowCaption = False
            Control = Chk1
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item6: TdxLayoutItem
            Caption = 'cxButton1'
            ShowCaption = False
            Control = BtnSearch
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'cxGrid1'
          ShowCaption = False
          Control = GridOrders
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object ADOQuery1: TADOQuery
    Parameters = <>
    Left = 33
    Top = 143
  end
  object DataSource1: TDataSource
    DataSet = ClientDs1
    Left = 134
    Top = 143
  end
  object ClientDs1: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProvider1'
    Left = 101
    Top = 143
  end
  object DataSetProvider1: TDataSetProvider
    DataSet = ADOQuery1
    Left = 66
    Top = 144
  end
end
