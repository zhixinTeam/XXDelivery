unit UFormSealInfo;

{$I Link.Inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxLayoutControl, StdCtrls, CPort, CPortTypes,
  dxLayoutcxEditAdapters, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxLabel, dxSkinsCore, dxSkinsDefaultPainters;

type
  TfFormSealInfo = class(TfFormNormal)
    ComPort1: TComPort;
    EditCard: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditLID: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditTruck: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditStockName: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditCustomer: TcxTextEdit;
    dxLayout1Item13: TdxLayoutItem;
    EditHYDan: TcxComboBox;
    dxLayout1Item7: TdxLayoutItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FBuffer: string;
    //接收缓冲
    procedure ActionComPort(const nStop: Boolean);
    procedure GetBillInfo(const nCardNo: string); //获取交货单信息
    procedure ShowFormData;  //显示数据
    procedure ClearFormData; //清空数据
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

var
  fFormSealInfo: TfFormSealInfo;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, UDataModule, UFormBase, UFormInputbox, USysGrid,
  UFormCtrl, USysDB, UBusinessConst, USysConst ,USysLoger, USmallFunc, USysBusiness;

type
  TReaderType = (ptT800, pt8142);
  //表头类型

  TReaderItem = record
    FType: TReaderType;
    FPort: string;
    FBaud: string;
    FDataBit: Integer;
    FStopBit: Integer;
    FCheckMode: Integer;
  end;
var
  gReaderItem: TReaderItem;
  //全局使用
  gList: TStrings;
  gBills: TLadingBillItems;

class function TfFormSealInfo.FormID: integer;
begin
  Result := cFI_FormSealInfo;
end;

class function TfFormSealInfo.CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl;
begin
  Result:=nil;
  with TfFormSealInfo.Create(Application) do
  begin
    Caption := '批次信息录入';
    ActionComPort(False);
    BtnOK.Enabled:=False;
    ShowModal;
    Free;
  end;
end;

procedure TfFormSealInfo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  gList.Free;
  ActionComPort(True);
end;

procedure TfFormSealInfo.ActionComPort(const nStop: Boolean);
var nInt: Integer;
    nIni: TIniFile;
begin
  if nStop then
  begin
    ComPort1.Close;
    Exit;
  end;

  with ComPort1 do
  begin
    with Timeouts do
    begin
      ReadTotalConstant := 100;
      ReadTotalMultiplier := 10;
    end;

    nIni := TIniFile.Create(gPath + 'Reader.Ini');
    with gReaderItem do
    try
      nInt := nIni.ReadInteger('Param', 'Type', 1);
      FType := TReaderType(nInt - 1);

      FPort := nIni.ReadString('Param', 'Port', '');
      FBaud := nIni.ReadString('Param', 'Rate', '4800');
      FDataBit := nIni.ReadInteger('Param', 'DataBit', 8);
      FStopBit := nIni.ReadInteger('Param', 'StopBit', 0);
      FCheckMode := nIni.ReadInteger('Param', 'CheckMode', 0);

      Port := FPort;
      BaudRate := StrToBaudRate(FBaud);

      case FDataBit of
       5: DataBits := dbFive;
       6: DataBits := dbSix;
       7: DataBits :=  dbSeven else DataBits := dbEight;
      end;

      case FStopBit of
       2: StopBits := sbTwoStopBits;
       15: StopBits := sbOne5StopBits
       else StopBits := sbOneStopBit;
      end;
    finally
      nIni.Free;
    end;

    if ComPort1.Port <> '' then
      ComPort1.Open;
    //xxxxx
  end;
end;


procedure TfFormSealInfo.ComPort1RxChar(Sender: TObject;
  Count: Integer);
var nStr: string;
    nIdx,nLen: Integer;
    nCard:string;
begin
  ComPort1.ReadStr(nStr, Count);
  FBuffer := FBuffer + nStr;

  nLen := Length(FBuffer);
  if nLen < 7 then Exit;

  for nIdx:=1 to nLen do
  begin
    if (FBuffer[nIdx] <> #$AA) or (nLen - nIdx < 6) then Continue;
    if (FBuffer[nIdx+1] <> #$FF) or (FBuffer[nIdx+2] <> #$00) then Continue;

    nStr := Copy(FBuffer, nIdx+3, 4);
    nCard:= ParseCardNO(nStr, True);
    if nCard <> EditCard.Text then
    begin
      EditCard.Text := nCard;
      GetBillInfo(Trim(EditCard.Text));
    end;
    FBuffer := '';
    Exit;
  end;
end;

procedure TfFormSealInfo.GetBillInfo(const nCardNo: string);
var nStr,nHint: string;
    nIdx,nInt: Integer;
    nFID :string;
begin
  nFID:='';
  if GetLadingBills(nCardNo, sFlag_TruckZT, gBills) then
  begin
    nInt := 0 ;
    nHint := '';

    for nIdx:=Low(gBills) to High(gBills) do
    with gBills[nIdx] do
    begin
      FSelected := (FNextStatus = sFlag_TruckBFM) or (FNextStatus = sFlag_TruckZT);
      if FSelected then
      begin
        Inc(nInt);
        Continue;
      end;

      nStr := '※.单号:[ %s ] 状态:[ %-6s -> %-6s ]   ';
      if nIdx < High(gBills) then nStr := nStr + #13#10;

      nStr := Format(nStr, [FID,
              TruckStatusToStr(FStatus), TruckStatusToStr(FNextStatus)]);
      nHint := nHint + nStr;
    end;

    if (nHint <> '') and (nInt = 0) then
    begin
      nHint := '该车辆当前不能录入批次,详情如下: ' + #13#10#13#10 + nHint;
      ShowDlg(nHint, sHint);
      EditCard.Text := '';
      Exit;
    end;

    ShowFormData;

  end else
  begin
    nHint := '无相关数据';
    ShowDlg(nHint, sHint);
    EditCard.Text := '';
  end;
end;

procedure TfFormSealInfo.ShowFormData;
var nStr: string;
    nIdx: Integer;
begin
  with gBills[0] do
  begin
    EditLID.Text:= gBills[0].FID;
    EditCustomer.Text:= FCusName;
    EditTruck.Text:= gBills[0].FTruck;
    EditStockName.Text:= gBills[0].FStockName;
    EditHYDan.Text    := FHYDan;
  end;

  if gBills[0].FType <> sFlag_Dai then
  begin
    ShowMsg('只有袋装车辆允许此操作', sHint);
    Exit;
  end;

  EditHYDan.Properties.Items.Clear;
  gList.Clear;

  if not GetSealList(EditStockName.Text, gBills[0].FType, gBills[0].FPack, nStr) then
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

  gList.Text := nStr;

  for nIdx := 0 to gList.Count - 1 do
  begin
    EditHYDan.Properties.Items.Add(gList.Strings[nIdx]);
  end;

  BtnOK.Enabled:=True;
end;

procedure TfFormSealInfo.ClearFormData;
var i:Integer;
begin
  for i:= 0 to ComponentCount-1 do
  begin
    if Components[i] is TcxTextEdit then
      (Components[i] as TcxTextEdit).Text:='';
    if Components[i] is TcxComboBox then
      (Components[i] as TcxComboBox).Text:='';
  end;
end;

procedure TfFormSealInfo.BtnOKClick(Sender: TObject);
var nStr : string ;
    nCount, nInt: Integer;
begin
  if EditCard.Text = '' then
  begin
    ShowMsg('请刷卡', sHint);
    Exit;
  end;

  if EditHYDan.Text = '' then
  begin
    ShowMsg('请选择批次号', sHint);
    Exit;
  end;

  nStr := '确定保存吗?';
  if not QueryDlg(nStr, sAsk) then Exit;

  nStr := 'Update %s Set L_HYDan= ''%s'' Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, Trim(EditHYDan.Text), gBills[0].FID]);
  FDM.ExecuteSQL(nStr);

  ShowMsg('铅封信息录入成功', sHint);
  ClearFormData;
  ModalResult := mrOk;
end;

procedure TfFormSealInfo.FormCreate(Sender: TObject);
begin
  inherited;
  gList := TStringList.Create;
end;

initialization
  gControlManager.RegCtrl(TfFormSealInfo, TfFormSealInfo.FormID);

end.
