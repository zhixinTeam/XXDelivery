{*******************************************************************************
  作者: 2019-11-06
  描述: 批量选择客户
*******************************************************************************}
unit UFormBatchGetCus;

{$I Link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, UBusinessConst, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, ComCtrls, cxListView,
  cxDropDownEdit, cxTextEdit, cxMaskEdit, cxButtonEdit, cxMCListBox,
  dxLayoutControl, StdCtrls, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, DB, cxDBData, ADODB, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, Menus, cxButtons, DateUtils, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinsdxLCPainter, dxSkinscxPCPainter,
  cxCheckBox, DBClient, Provider;

type
  TfFormBatchGetCus = class(TfFormNormal)
    cxView1: TcxGridDBTableView;
    cxLevel1: TcxGridLevel;
    GridOrders: TcxGrid;
    dxLayout1Item3: TdxLayoutItem;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    EditCus: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxView1Column1: TcxGridDBColumn;
    cxView1Column2: TcxGridDBColumn;
    dxLayout1Group2: TdxLayoutGroup;
    BtnSearch: TcxButton;
    dxLayout1Item6: TdxLayoutItem;
    cxView1Column3: TcxGridDBColumn;
    ClientDs1: TClientDataSet;
    DataSetProvider1: TDataSetProvider;
    Chk1: TcxCheckBox;
    dxlytmLayout1Item5: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);
    procedure cxView1CellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure cxView1Column1PropertiesChange(Sender: TObject);
    procedure cxView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EditCusKeyPress(Sender: TObject; var Key: Char);
  protected
    { Private declarations }
    FListA: TStrings;
    FCurrCol:Integer;
    FCusID, FCusName: string;
  private
    function  GetVal(const nRow: Integer; const nField: string): string;
    procedure InitFormData(const nWhere: string);
    //初始化
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UFormBase, UMgrControl, UDataModule, USysGrid, USysDB, USysConst,
  USysBusiness, UBusinessPacker;

class function TfFormBatchGetCus.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;
  nP := nParam;

  with TfFormBatchGetCus.Create(Application) do
  try
    InitFormData('');

    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
    nP.FParamB := Copy(FCusID, 1, Length(FCusID));
    nP.FParamC := FCusName;
  finally
    Free;
  end;
end;

class function TfFormBatchGetCus.FormID: integer;
begin
  Result := cFI_FormBatchGetCus;
end;

procedure TfFormBatchGetCus.FormCreate(Sender: TObject);
var nStr: string;
    nIdx: Integer;
begin
  FListA := TStringList.Create;
  dxGroup1.AlignVert := avClient;
  LoadFormConfig(Self);

  for nIdx:=0 to cxView1.ColumnCount-1 do
    cxView1.Columns[nIdx].Tag := nIdx;
  InitTableView(Name, cxView1);
end;

procedure TfFormBatchGetCus.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FreeAndNil(FListA);
  SaveFormConfig(Self);
  SaveUserDefineTableView(Name, cxView1);
end;

//------------------------------------------------------------------------------
//Desc: 获取nRow行nField字段的内容
function TfFormBatchGetCus.GetVal(const nRow: Integer; const nField: string): string;
var nVal: Variant;
begin
  nVal := cxView1.DataController.GetValue(
            cxView1.Controller.SelectedRows[nRow].RecordIndex,
            cxView1.GetColumnByFieldName(nField).Index);
  //xxxxx

  if VarIsNull(nVal) then
       Result := ''
  else Result := nVal;
end;

procedure TfFormBatchGetCus.InitFormData(const nWhere: string);
var nStr: string;
begin
  try
    nStr := 'Select 0 Chk, * From %s Where 1=1 ';
    nStr := Format(nStr, [sTable_Customer, sFlag_Yes]);

    if Chk1.Checked then
      nStr := nStr + ' And (IsNull(C_CustSerilaNo,'''')<>'''') ';

    if nWhere <> '' then
      nStr := nStr + ' And (' + nWhere + ') ';
    FDM.QueryData(ADOQuery1, nStr);

    ActiveControl := BtnOK;
  finally
    FCusID := '';
    ClientDs1.Data:= DataSetProvider1.Data;
  end;
end;

procedure TfFormBatchGetCus.BtnOKClick(Sender: TObject);
begin
  if FCusID='' then
  begin
    ShowMsg('请选择订单', sHint);
    Exit;
  end;
  ModalResult := mrOk;
end;

procedure TfFormBatchGetCus.BtnSearchClick(Sender: TObject);
var nStr, nCusID, nBeginDate, nEndDate: string;
begin
  nStr := 'C_Name Like ''%%%s%%'' Or C_PY Like ''%%%s%%''';
  nStr := Format(nStr, [EditCus.Text, EditCus.Text]);

  InitFormData(nStr);
end;

procedure TfFormBatchGetCus.cxView1CellClick(
  Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  FCurrCol:= ACellViewInfo.Item.Index;
end;

procedure TfFormBatchGetCus.cxView1Column1PropertiesChange(
  Sender: TObject);
begin
  inherited;
  //
end;

procedure TfFormBatchGetCus.cxView1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  nRow: Integer;
begin
  if FCurrCol = 0 then
  begin
    nRow := cxView1.DataController.FocusedRowIndex;
    if cxView1.ViewData.Records[nRow].Values[0] = '1' then
    begin
      cxView1.ViewData.Records[nRow].Values[0] := '0';
      FCusID := StringReplace(FCusID, ',' + cxView1.ViewData.Records[nRow].Values[1], '', [rfReplaceAll]);

      if FCusID='' then FCusName:= '';
    end
    else
    begin
      cxView1.ViewData.Records[nRow].Values[0] := '1';
      FCusID   := FCusID + ',' + cxView1.ViewData.Records[nRow].Values[1];
      FCusName := cxView1.ViewData.Records[nRow].Values[2] ;
    end;
  end;
end;

procedure TfFormBatchGetCus.EditCusKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = Char(VK_RETURN) then
  begin
    BtnSearch.Click;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormBatchGetCus, TfFormBatchGetCus.FormID);
end.
