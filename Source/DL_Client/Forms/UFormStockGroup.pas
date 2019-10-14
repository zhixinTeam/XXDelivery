unit UFormStockGroup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels, UFormBase,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinsdxLCPainter, dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  cxTextEdit;

type

  TfFormStockGroup = class(TfFormNormal)
    dxlytmLayout1Item3: TdxLayoutItem;
    edt_Name: TcxTextEdit;
    procedure BtnOKClick(Sender: TObject);
  private
    FID : string;
  public
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

var
  fFormStockGroup: TfFormStockGroup;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun,UMgrControl, USysBusiness, USmallFunc, USysConst, USysDB,
  UDataModule;

  
class function TfFormStockGroup.FormID: integer;
begin
  Result := cFI_FormStockGroup;
end;

class function TfFormStockGroup.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP : PFormCommandParam;
begin
  Result := nil;

  if not Assigned(nParam) then
  begin
    New(nP);
    FillChar(nP^, SizeOf(TFormCommandParam), #0);
  end
  else nP := nParam;

  with TfFormStockGroup.Create(Application) do
  try
    case nP.FCommand of

       cCmd_AddData:
         begin
            FID := '';
            edt_Name.Text:= '';
         end;

       cCmd_EditData:
         begin
            FID:= nP.FParamA;
            edt_Name.Text:= nP.FParamB;
         end;
    end;

    nP.FCommand:= ShowModal;
  finally
    Free;
  end;
end;

procedure TfFormStockGroup.BtnOKClick(Sender: TObject);
var nStr, nSql : string;
begin
  if Trim(edt_Name.Text)='' then Exit;

  try
    nStr := Trim(edt_Name.Text);
    if FID='' then
    begin
      nSql := 'Insert into %s(G_Name) Select ''%s''';
    end
    else nSql := ' UPDate %s Set G_Name=''%s'' Where R_ID=%s ';

    nSql := Format(nSql, [sTable_StockGroup, nStr, FID]);
    FDM.ExecuteSQL(nSql);
    ModalResult := mrOk;
    ShowMsg('操作成功', '提示');
  except
    ShowMsg('操作失败', '提示');
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormStockGroup, TfFormStockGroup.FormID);

end.
