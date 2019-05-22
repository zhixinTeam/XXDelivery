{*******************************************************************************
  作者: dmzn@163.com 2017-09-26
  描述: 开提货单
*******************************************************************************}
unit UFormBill;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, ComCtrls, cxContainer, cxEdit, cxCheckBox,
  cxMaskEdit, cxDropDownEdit, cxTextEdit, cxListView, cxMCListBox,
  dxLayoutControl, StdCtrls, cxMemo, cxLabel, cxCalendar;

type
  TfFormBill = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    dxLayout1Item3: TdxLayoutItem;
    ListInfo: TcxMCListBox;
    EditValue: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditTruck: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditLading: TcxComboBox;
    dxLayout1Item12: TdxLayoutItem;
    dxLayout1Item6: TdxLayoutItem;
    EditType: TcxComboBox;
    PrintGLF: TcxCheckBox;
    dxLayout1Item13: TdxLayoutItem;
    dxLayout1Item14: TdxLayoutItem;
    PrintHY: TcxCheckBox;
    dxLayout1Group3: TdxLayoutGroup;
    cxLabel1: TcxLabel;
    dxLayout1Item4: TdxLayoutItem;
    EditPhone: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    EditDate: TcxDateEdit;
    dxLayout1Item15: TdxLayoutItem;
    dxLayout1Group5: TdxLayoutGroup;
    chkMaxMValue: TcxCheckBox;
    dxLayout1Item7: TdxLayoutItem;
    dxLayout1Group6: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    EditMaxMValue: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    CalYF: TcxCheckBox;
    dxLayout1Item16: TdxLayoutItem;
    EditPack: TcxComboBox;
    dxLayout1Item11: TdxLayoutItem;
    EditLine: TcxComboBox;
    dxLayout1Item17: TdxLayoutItem;
    EditHYDan: TcxComboBox;
    dxLayout1Item18: TdxLayoutItem;
    dxLayout1Group7: TdxLayoutGroup;
    dxLayout1Group8: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure EditLadingKeyPress(Sender: TObject; var Key: Char);
    procedure chkMaxMValueClick(Sender: TObject);
    procedure EditPackPropertiesChange(Sender: TObject);
  protected
    { Protected declarations }
    FMsgNo: Cardinal;
    FBuDanFlag: string;
    //补单标记
    procedure LoadFormData;
    //载入数据
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
  end;

implementation

{$R *.dfm}

uses
  ULibFun, DB, IniFiles, UMgrControl, UFormBase, UDataModule, UAdjustForm,
  UBusinessConst, USysPopedom, USysBusiness, USysDB, USysGrid, USysConst,
  UBusinessPacker, UFormWait;

var
  gBillItem: TLadingBillItem;
  //提单数据

class function TfFormBill.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nBool,nBuDan: Boolean;
    nDef: TLadingBillItem;
    nP: PFormCommandParam;
begin
  Result := nil;
  if GetSysValidDate < 1 then Exit;

  nP := nil;
  try
    if not Assigned(nParam) then
    begin
      New(nP);
      FillChar(nP^, SizeOf(TFormCommandParam), #0);
    end else nP := nParam;

    nBuDan := nPopedom = 'MAIN_D04';
    FillChar(nDef, SizeOf(nDef), #0);
    nP.FParamE := @nDef;

    CreateBaseFormItem(cFI_FormGetZhika, nPopedom, nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;
    gBillItem := nDef;
  finally
    if not Assigned(nParam) then Dispose(nP);
  end;

  with TfFormBill.Create(Application) do
  try
    Caption := '开提货单';
    FMsgNo := GetTickCount;

    if nBuDan then //补单
         FBuDanFlag := sFlag_Yes
    else FBuDanFlag := sFlag_No;

    nBool := not gPopedomManager.HasPopedom(nPopedom, sPopedom_Edit);
    EditLading.Properties.ReadOnly := nBool;
    LoadFormData;

    if Assigned(nParam) then
    with PFormCommandParam(nParam)^ do
    begin
      FCommand := cCmd_ModalResult;
      FParamA := ShowModal;

      if FParamA = mrOK then
           FParamB := gBillItem.FID
      else FParamB := '';
    end else ShowModal;
  finally
    Free;
  end;
end;

class function TfFormBill.FormID: integer;
begin
  Result := cFI_FormBill;
end;

procedure TfFormBill.FormCreate(Sender: TObject);
var nStr: string;
    nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nStr := nIni.ReadString(Name, 'FQLabel', '');
    if nStr <> '' then
      dxLayout1Item5.Caption := nStr;
    //xxxxx

    PrintHY.Checked := False;
    //随车开单
    LoadMCListBoxConfig(Name, ListInfo, nIni);
  finally
    nIni.Free;
  end;

  {$IFDEF PrintGLF}
  dxLayout1Item13.Visible := True;
  {$ELSE}
  dxLayout1Item13.Visible := False;
  PrintGLF.Checked := False;
  {$ENDIF}

  {$IFDEF PrintHYEach}
  dxLayout1Item14.Visible := True;
  {$ELSE}
  dxLayout1Item14.Visible := False;
  PrintHY.Checked := False;
  {$ENDIF}

  chkMaxMValue.OnClick(nil);

  AdjustCtrlData(Self);
end;

procedure TfFormBill.FormClose(Sender: TObject; var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nIni.WriteBool(Name, 'PrintHY', PrintHY.Checked);
    SaveMCListBoxConfig(Name, ListInfo, nIni);
  finally
    nIni.Free;
  end;

  ReleaseCtrlData(Self);
end;

//Desc: 回车键
procedure TfFormBill.EditLadingKeyPress(Sender: TObject; var Key: Char);
var nP: TFormCommandParam;
begin
  if Key = Char(VK_RETURN) then
  begin
    Key := #0;

    if Sender = EditTruck then ActiveControl := EditValue else
    //xxxxx

    if Sender = EditValue then
         ActiveControl := BtnOK
    else Perform(WM_NEXTDLGCTL, 0, 0);
  end;

  if (Sender = EditTruck) and (Key = Char(VK_SPACE)) then
  begin
    Key := #0;
    nP.FParamA := EditTruck.Text;
    CreateBaseFormItem(cFI_FormGetTruck, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and(nP.FParamA = mrOk) then
    begin
      EditTruck.Text := nP.FParamB;
      EditPhone.Text := nP.FParamD;
    end;

    EditTruck.SelectAll;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 载入界面数据
procedure TfFormBill.LoadFormData;
var nStr: string;
begin
  EditLine.Properties.Items.Clear;

  nStr := 'Select Z_ID, Z_Name From %s ' +
          'Where Z_Valid=''%s'' and Z_StockNo = ''%s'' order By Z_ID';
  nStr := Format(nStr, [sTable_ZTLines, sFlag_Yes, gBillItem.FStockNo]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        EditLine.Properties.Items.Add(Fields[0].AsString + '.' + Fields[1].AsString);
        Next;
      end;
    end;
  end;

  nStr := 'Select D_Value,D_ParamA From %s Where D_Name=''%s'' ';
  nStr := Format(nStr, [sTable_SysDict, sFlag_PackType]);

  EditPack.Properties.Items.Clear;

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount < 1 then Exit;

    First;

    while not Eof do
    begin
      EditPack.Properties.Items.Add(Fields[0].AsString);
      Next;
    end;
  end;

  dxGroup1.AlignVert := avClient;
  dxGroup2.AlignVert := avBottom;

  EditDate.Date := Now();
  dxLayout1Item15.Visible := FBuDanFlag = sFlag_Yes;
  dxLayout1Item17.Visible := FBuDanFlag = sFlag_Yes;
  dxLayout1Item18.Visible := FBuDanFlag = sFlag_Yes;

  ActiveControl := EditTruck;

  with gBillItem,ListInfo do
  begin
    Clear;
    Items.Add(Format('订单编号:%s %s', [Delimiter, FZhiKa]));
    Items.Add(Format('工厂代码:%s %s', [Delimiter, FStatus]));
    Items.Add(Format('工厂名称:%s %s', [Delimiter, FNextStatus]));

    Items.Add(Format('%s ', [Delimiter]));
    Items.Add(Format('客户编号:%s %s', [Delimiter, FCusID]));
    Items.Add(Format('客户名称:%s %s', [Delimiter, FCusName]));

    Items.Add(Format('%s ', [Delimiter]));
    Items.Add(Format('物料编号:%s %s', [Delimiter, FStockNo]));
    Items.Add(Format('物料名称:%s %s', [Delimiter, FStockName]));

    if FType = sFlag_Dai then nStr := '袋装' else nStr := '散装';
    Items.Add(Format('物料类型:%s %s', [Delimiter, nStr]));
    Items.Add(Format('可用余额:%s %.2f元', [Delimiter, FValue]));
    Items.Add(Format('运    费:%s %.2f元', [Delimiter, FYunFei]));
  end;
end;

function TfFormBill.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nMoney : Double;
begin
  Result := True;

  if Sender = EditMaxMValue then
  begin
    if chkMaxMValue.Checked then
    begin
      Result := IsNumber(EditMaxMValue.Text, True)
                and (StrToFloat(EditMaxMValue.Text)>StrToFloat(EditValue.Text));
      nHint := '请填写有效的毛重限值';
    end;
  end else

  if Sender = EditTruck then
  begin
    Result := Length(EditTruck.Text) > 2;
    nHint := '车牌号长度应大于2位';
  end else

  if Sender = EditLading then
  begin
    Result := EditLading.ItemIndex > -1;
    nHint := '请选择提货方式';
  end else

  if Sender = EditPack then
  begin
    Result := EditPack.ItemIndex > -1;
    nHint := '请选择包装类型';
  end else

  if Sender = EditValue then
  begin
    Result := IsNumber(EditValue.Text, True) and
             (StrToFloat(EditValue.Text) > 0);
    nHint := '请填写有效的办理量';
    if not Result then Exit;
  end;
end;

//Desc: 保存
procedure TfFormBill.BtnOKClick(Sender: TObject);
var nPrint: Boolean;
    nList,nStocks: TStrings;
    nHint,nStr,nHYDan: string;
    nLen: Integer;
begin
  if not OnVerifyCtrl(EditMaxMValue, nHint) then
  begin
    ShowMsg(nHint,sHint);
    Exit;
  end;
  if not OnVerifyCtrl(EditTruck, nHint) then
  begin
    ShowMsg(nHint,sHint);
    Exit;
  end;
  if not OnVerifyCtrl(EditLading, nHint) then
  begin
    ShowMsg(nHint,sHint);
    Exit;
  end;
  if not OnVerifyCtrl(EditValue, nHint) then
  begin
    ShowMsg(nHint,sHint);
    Exit;
  end;

  if gBillItem.FType = sFlag_Dai then
  if not OnVerifyCtrl(EditPack, nHint) then
  begin
    ShowMsg(nHint,sHint);
    Exit;
  end;

  if FBuDanFlag = sFlag_Yes then
  begin
    if Trim(EditLine.Text) = '' then
    begin
      ShowMsg('请选择发货通道',sHint);
      Exit;
    end;

    if gBillItem.FType = sFlag_Dai then
    if Trim(EditHYDan.Text) = '' then
    begin
      ShowMsg('请选择批次',sHint);
      Exit;
    end;
  end;

  if not CheckTruckCard(EditTruck.Text,nHint) then
  begin
    nStr := '车辆[ %s ]存在未注销磁卡的交货单[ %s ],需先处理.';
    nStr := Format(nStr, [EditTruck.Text, nHint]);
    ShowMsg(nStr,sHint);
    Exit;
  end;

  if not CheckGPSInfo(gBillItem.FStockNo,EditTruck.Text) then
  begin
    nStr := '车辆[ %s ]GPS未交费,需先处理.';
    nStr := Format(nStr, [EditTruck.Text]);
    ShowMsg(nStr,sHint);
    Exit;
  end;
  
  nStocks := TStringList.Create;
  nList := TStringList.Create;
  try
    nList.Clear;
    nPrint := False;
    LoadSysDictItem(sFlag_PrintBill, nStocks);
    //需打印品种

    with nList do
    begin
      if PrintGLF.Checked  then
           Values['PrintGLF'] := sFlag_Yes
      else Values['PrintGLF'] := sFlag_No;

      if PrintHY.Checked  then
           Values['PrintHY'] := sFlag_Yes
      else Values['PrintHY'] := sFlag_No;

      if CalYF.Checked  then
           Values['CalYF'] := sFlag_Yes
      else Values['CalYF'] := sFlag_No;

      if (not nPrint) and (FBuDanFlag <> sFlag_Yes) then
        nPrint := nStocks.IndexOf(gBillItem.FStockNo) >= 0;
      //xxxxx

      Values['ZhiKa']        := gBillItem.FZhiKa;
      Values['Truck']        := EditTruck.Text;
      Values['Value']        := EditValue.Text;

      Values['Lading']       := GetCtrlData(EditLading);
      Values['IsVIP']        := GetCtrlData(EditType);

      Values['Value']        := EditValue.Text;
      Values['BuDan']        := FBuDanFlag;
      Values['BuDanDate']    := Date2Str(EditDate.Date);

      Values['Phone']        := Trim(EditPhone.Text);

      if chkMaxMValue.Checked then
      Values['MaxMValue']    := Trim(EditMaxMValue.Text)
      else
      Values['MaxMValue']    := '0';

      Values['MsgNo']        := IntToStr(FMsgNo);
      Values['YunFei']       := FloatToStr(gBillItem.FYunFei);
      Values['Pack']         := EditPack.Text;

      nLen := Pos('.', EditLine.Text);
      Values['ZTLine']       := Copy(EditLine.Text,1, nLen - 1);
      Values['ZTLineName']   := Copy(EditLine.Text,nLen + 1,
                                Length(EditLine.Text) - nLen);
      Values['BDHYDan']      := EditHYDan.Text;
    end;

    ShowWaitForm(Self, '正在保存数据', True);
    try
      gBillItem.FID := SaveBill(PackerEncodeStr(nList.Text));
      //call mit bus
    finally
      CloseWaitForm;
    end;

    if gBillItem.FID = '' then Exit;
    //save failed
  finally
    nList.Free;
    nStocks.Free;
  end;

  if FBuDanFlag <> sFlag_Yes then
    SetBillCard(gBillItem.FID, EditTruck.Text, True);
  //办理磁卡

  if nPrint then
    PrintBillReport(gBillItem.FID, True);
  //print report

  ModalResult := mrOk;
  ShowMsg('提货单保存成功', sHint);
end;

procedure TfFormBill.chkMaxMValueClick(Sender: TObject);
begin
  if chkMaxMValue.Checked then
    dxLayout1Item5.Visible := True
  else
    dxLayout1Item5.Visible := False;
end;

procedure TfFormBill.EditPackPropertiesChange(Sender: TObject);
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
begin
  if EditPack.Text = '' then
    Exit;
  if gBillItem.FType <> sFlag_Dai then
    Exit;
  nList := TStringList.Create;

  try
    if FBuDanFlag = sFlag_Yes then
    begin
      EditHYDan.Properties.Items.Clear;
      nList.Clear;
      if not GetSealList(gBillItem.FStockName, gBillItem.FType, EditPack.Text, nStr) then
      begin
        nStr := '读取可用批次号失败';

        ShowMsg(nStr, sHint);
        Exit;
      end;

      if nStr = '' then
      begin
        nStr := '读取可用批次号失败';

        ShowMsg(nStr, sHint);
        Exit;
      end;
      nList.Text := nStr;
      for nIdx := 0 to nList.Count - 1 do
      begin
        EditHYDan.Properties.Items.Add(nList.Strings[nIdx]);
      end;
    end;
  finally
    nList.Free;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormBill, TfFormBill.FormID);
end.
