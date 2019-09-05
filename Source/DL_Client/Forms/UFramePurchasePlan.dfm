inherited fFramePurchasePlan: TfFramePurchasePlan
  Width = 685
  Height = 359
  inherited ToolBar1: TToolBar
    Width = 685
    inherited BtnAdd: TToolButton
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      OnClick = BtnDelClick
    end
  end
  inherited cxGrid1: TcxGrid
    Width = 685
    Height = 192
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 685
    object EditName: TcxButtonEdit [0]
      Left = 99
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = Edt_EditNamePropertiesButtonClick
      TabOrder = 0
      Width = 188
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxlytmLayout1Item1: TdxLayoutItem
          Caption = #20379#24212#21830#21517#31216#65306
          Control = EditName
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        Visible = False
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Width = 685
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 685
    inherited TitleBar: TcxLabel
      Caption = #37319#36141#38480#37327#25511#21046
      Style.IsFontAssigned = True
      Width = 685
      AnchorX = 343
      AnchorY = 11
    end
  end
end
