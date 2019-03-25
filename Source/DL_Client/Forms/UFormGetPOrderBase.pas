{*******************************************************************************
  作者: fendou116688@163.com 2015/9/19
  描述: 选择采购申请单
*******************************************************************************}
unit UFormGetPOrderBase;

{$I Link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, dxLayoutControl, StdCtrls, cxControls,
  ComCtrls, cxListView, cxButtonEdit, cxLabel, cxLookAndFeels,
  cxLookAndFeelPainters, dxLayoutcxEditAdapters, Menus, cxButtons;

type
  TOrderBaseParam = record
    FID :string;

    FProvID: string;
    FProvName: string;

    FSaleID: string;
    FSaleName: string;

    FArea: string;
    FProject: string;

    FStockNO: string;
    FStockName: string;
    FStockModel: string;
    FRestValue: string;
    FRecID: string;
    FMemo:string;
    FKD:string;
    FYear:string;
    FPurchType: string;
  end;
  TOrderBaseParams = array of TOrderBaseParam;

  TfFormGetPOrderBase = class(TfFormNormal)
    ListQuery: TcxListView;
    dxLayout1Item6: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item7: TdxLayoutItem;
    EditOrderType: TcxComboBox;
    dxLayout1Item8: TdxLayoutItem;
    EditProvider: TcxComboBox;
    dxLayout1Item3: TdxLayoutItem;
    BtnSearch: TcxButton;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure ListQueryKeyPress(Sender: TObject; var Key: Char);
    procedure ListQueryDblClick(Sender: TObject);
    procedure orderange(Sender: TObject);
    procedure EditProviderPropertiesChange(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);
  private
    { Private declarations }
    FResults: TStrings;
    //查询类型
    FOrderData: string;
    //申请单信息
    FOrderItems: TOrderBaseParams;
    procedure GetResult;
    //获取结果
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UMgrControl, UFormCtrl, UFormBase, USysGrid, USysDB,
  USysConst, UDataModule, UBusinessPacker, DateUtils, USysBusiness;

class function TfFormGetPOrderBase.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormGetPOrderBase.Create(Application) do
  begin
    Caption := '选择申请单';
    FResults.Clear;
    SetLength(FOrderItems, 0);

    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;

    if nP.FParamA = mrOK then
    begin
      nP.FParamB := PackerEncodeStr(FOrderData);
    end;
    Free;
  end;
end;

class function TfFormGetPOrderBase.FormID: integer;
begin
  Result := cFI_FormGetPOrderBase;
end;

procedure TfFormGetPOrderBase.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadcxListViewConfig(Name, ListQuery, nIni);
  finally
    nIni.Free;
  end;
  FResults := TStringList.Create;
end;

procedure TfFormGetPOrderBase.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SavecxListViewConfig(Name, ListQuery, nIni);
  finally
    nIni.Free;
  end;

  FResults.Free;
end;

//Desc: 获取结果
procedure TfFormGetPOrderBase.GetResult;
var nIdx: Integer;
begin
  with ListQuery.Selected do
  begin
    nIdx := ListQuery.Selected.Index;
    //for nIdx:=Low(FOrderItems) to High(FOrderItems) do
    with FOrderItems[nIdx], FResults do
    begin
      //if CompareText(FID, Caption)=0 then
      if CompareText(FRecID, SubItems[6])=0 then
      begin
        Values['SQ_ID']       := FID;
        Values['SQ_ProID']    := FProvID;
        Values['SQ_ProName']  := FProvName;
        Values['SQ_SaleID']   := FSaleID;
        Values['SQ_SaleName'] := FSaleName;
        Values['SQ_StockNO']  := FStockNO;
        Values['SQ_StockName']:= FStockName;
        Values['SQ_Area']     := FArea;
        Values['SQ_Project']  := FProject;
        Values['SQ_RestValue']:= FRestValue;
        Values['SQ_RecID']    := FRecID;
        Values['SQ_PurchType']:= FPurchType;
        Values['SQ_Memo']     := FMemo;
        Values['SQ_Model']    := FStockModel;
        Values['SQ_KD']       := FKD;
        Values['SQ_Year']     := FYear;
        //Break;
      end;
    end;
  end;

  FOrderData := FResults.Text;
end;

procedure TfFormGetPOrderBase.ListQueryKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    if ListQuery.ItemIndex > -1 then
    begin
      GetResult;
      if (StrToFloat(FResults.Values['SQ_RestValue'])<=0) and (FResults.Values['SQ_PurchType']<>'0')  then
      begin
        if not QueryDlg('订单剩余量不足,是否继续开单?', sHint) then Exit;
      end;
      ModalResult := mrOk;
    end;
  end;
end;

procedure TfFormGetPOrderBase.ListQueryDblClick(Sender: TObject);
begin
  if ListQuery.ItemIndex > -1 then
  begin
    GetResult;
    if (StrToFloat(FResults.Values['SQ_RestValue'])<=0) and (FResults.Values['SQ_PurchType']<>'0')  then
    begin
      if not QueryDlg('订单剩余量不足,是否继续开单?', sHint) then Exit;
    end;
    ModalResult := mrOk;
  end;
end;

procedure TfFormGetPOrderBase.BtnOKClick(Sender: TObject);
begin
  if ListQuery.ItemIndex > -1 then
  begin
    GetResult;
    if (StrToFloat(FResults.Values['SQ_RestValue'])<=0) and (FResults.Values['SQ_PurchType']<>'0')  then
    begin
      if not QueryDlg('订单剩余量不足,是否继续开单?', sHint) then Exit;
    end;
    ModalResult := mrOk;
  end else ShowMsg('请在查询结果中选择', sHint);
end;

procedure TfFormGetPOrderBase.orderange(
  Sender: TObject);
begin
  ListQuery.Items.Clear;
end;

procedure TfFormGetPOrderBase.EditProviderPropertiesChange(
  Sender: TObject);
var nIdx : Integer;
    nStr : string;
begin
  EditProvider.Properties.Items.Clear;
  nStr := 'Select P_Name From %s Where P_Name Like ''%%%s%%'' or P_PY Like ''%%%s%%'' ';
  nStr := Format(nStr, [sTable_Provider, EditProvider.Text, EditProvider.Text]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      try
        EditProvider.Properties.BeginUpdate;

        First;

        while not Eof do
        begin
          EditProvider.Properties.Items.Add(Fields[0].AsString);
          Next;
        end;
      finally
        EditProvider.Properties.EndUpdate;
      end;
    end;
  end;
  for nIdx := 0 to EditProvider.Properties.Items.Count - 1 do
  begin;
    if Pos(EditProvider.Text,EditProvider.Properties.Items.Strings[nIdx]) > 0 then
    begin
      EditProvider.SelectedItem := nIdx;
      Break;
    end;
  end;
end;

procedure TfFormGetPOrderBase.BtnSearchClick(Sender: TObject);
var nStr, nQuery, nData, nProviderID: string;
    nIdx, nOrderCount: Integer;
    nListA, nListB: TStrings;
begin
  if EditProvider.Text = '' then
  begin
    nStr := '请选择客户';
    EditProvider.SetFocus;
    ShowMsg(nStr, sHint);
    Exit;
  end;
  nProviderID := GetProviderID(EditProvider.Text);
  if nProviderID = '' then
  begin
    nStr := '未找到[ %s ]对应的供应商ID';
    nStr := Format(nStr, [EditProvider.Text]);
    ShowMsg(nStr, sHint);
    Exit;
  end;
  ListQuery.Items.Clear;

  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    nListA.Clear;

    nListA.Values['ProviderNo'] := nProviderID;
    nListA.Values['ProviderName'] := EditProvider.Text;

    nStr := PackerEncodeStr(nListA.Text);

    nData := GetHhOrderPlanWSDL(nStr);

    if nData = '' then
    begin
      ShowMsg('未查询到相关信息',sHint);
      Exit;
    end;

    nListA.Text := PackerDecodeStr(nData);
    nOrderCount := nListA.Count;
    SetLength(FOrderItems,nOrderCount);
    for nIdx := 0 to nOrderCount-1 do
    with FOrderItems[nIdx] do
    begin
      nListB.Text := PackerDecodeStr(nListA.Strings[nIdx]);
      FID       := nListB.Values['Order'];
      FProvID   := nListB.Values['ProID'];
      FProvName := nListB.Values['ProName'];
      FSaleID   := '';
      FSaleName := '';
      FStockNO  := nListB.Values['StockNo'];
      FStockName:= nListB.Values['StockName'];
      FStockModel:= nListB.Values['Model'];
      FKD       := nListB.Values['KD'];
      FArea     := '';
      FProject  := '';
      FRecID    := nListB.Values['Order'];
      FPurchType:= EditOrderType.Text;
      FMemo     := '';
      FRestValue := nListB.Values['Value'];

      with ListQuery.Items.Add do
      begin
        Caption := FID;
        SubItems.Add(FStockName);
        SubItems.Add(FStockModel);
        SubItems.Add(FProvName);
        SubItems.Add(FKD);
        SubItems.Add(FRestValue);
        SubItems.Add(FMemo);
        SubItems.Add(FRecID);
        ImageIndex := cItemIconIndex;
      end;
    end;
    if ListQuery.Items.Count>0 then
      ListQuery.ItemIndex := 0;
  finally
    nListA.Free;
    nListB.Free;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormGetPOrderBase, TfFormGetPOrderBase.FormID);
end.
