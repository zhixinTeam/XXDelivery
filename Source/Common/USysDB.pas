{*******************************************************************************
  ����: dmzn@163.com 2008-08-07
  ����: ϵͳ���ݿⳣ������

  ��ע:
  *.�Զ�����SQL���,֧�ֱ���:$Inc,����;$Float,����;$Integer=sFlag_Integer;
    $Decimal=sFlag_Decimal;$Image,��������
*******************************************************************************}
unit USysDB;

{$I Link.inc}
interface

uses
  SysUtils, Classes;

const
  cSysDatabaseName: array[0..4] of String = (
     'Access', 'SQL', 'MySQL', 'Oracle', 'DB2');
  //db names

  cPrecision            = 100;
  {-----------------------------------------------------------------------------
   ����: ���㾫��
   *.����Ϊ�ֵļ�����,С��ֵ�Ƚϻ����������ʱ�������,���Ի��ȷŴ�,ȥ��
     С��λ������������.�Ŵ����ɾ���ֵȷ��.
  -----------------------------------------------------------------------------}

type
  TSysDatabaseType = (dtAccess, dtSQLServer, dtMySQL, dtOracle, dtDB2);
  //db types

  PSysTableItem = ^TSysTableItem;
  TSysTableItem = record
    FTable: string;
    FNewSQL: string;
  end;
  //ϵͳ����

var
  gSysTableList: TList = nil;                        //ϵͳ������
  gSysDBType: TSysDatabaseType = dtSQLServer;        //ϵͳ��������

//------------------------------------------------------------------------------
const
  //�����ֶ�
  sField_Access_AutoInc          = 'Counter';
  sField_SQLServer_AutoInc       = 'Integer IDENTITY (1,1) PRIMARY KEY';

  //С���ֶ�
  sField_Access_Decimal          = 'Float';
  sField_SQLServer_Decimal       = 'Decimal(15, 5)';

  //ͼƬ�ֶ�
  sField_Access_Image            = 'OLEObject';
  sField_SQLServer_Image         = 'Image';

  //�������
  sField_SQLServer_Now           = 'getDate()';

  {*���ݿ��ʶ*}
  sFlag_DB_HH         = 'HH_DB';                     //��Ӿ�Զ���ݿ�

  {*Ȩ����*}
  sPopedom_Read       = 'A';                         //���
  sPopedom_Add        = 'B';                         //����
  sPopedom_Edit       = 'C';                         //�޸�
  sPopedom_Delete     = 'D';                         //ɾ��
  sPopedom_Preview    = 'E';                         //Ԥ��
  sPopedom_Print      = 'F';                         //��ӡ
  sPopedom_Export     = 'G';                         //����
  sPopedom_ViewPrice  = 'H';                         //�鿴����

  {*��ر��*}
  sFlag_Yes           = 'Y';                         //��
  sFlag_No            = 'N';                         //��
  sFlag_Unknow        = 'U';                         //δ֪ 
  sFlag_Enabled       = 'Y';                         //����
  sFlag_Disabled      = 'N';                         //����
  sFlag_Null          = 'NULL';                      //��

  sFlag_Integer       = 'I';                         //����
  sFlag_Decimal       = 'D';                         //С��

  sFlag_ManualNo      = '%';                         //�ֶ�ָ��(��ϵͳ�Զ�)
  sFlag_NotMatter     = '@';                         //�޹ر��(�����Ŷ���)
  sFlag_ForceDone     = '#';                         //ǿ�����(δ���ǰ����)
  sFlag_FixedNo       = '$';                         //ָ�����(ʹ����ͬ���)

  sFlag_Provide       = 'P';                         //��Ӧ
  sFlag_Sale          = 'S';                         //����
  sFlag_Returns       = 'R';                         //�˻�
  sFlag_Other         = 'O';                         //����
  sFlag_Mul           = 'M';                         //�����Ϲ���
  sFlag_Tx            = 'T';                         //ͨ��

  sFlag_TiHuo         = 'T';                         //����
  sFlag_SongH         = 'S';                         //�ͻ�
  sFlag_XieH          = 'X';                         //��ж

  sFlag_Dai           = 'D';                         //��װˮ��
  sFlag_San           = 'S';                         //ɢװˮ��

  sFlag_BillNew       = 'N';                         //�µ�
  sFlag_BillEdit      = 'E';                         //�޸�
  sFlag_BillDel       = 'D';                         //ɾ��
  sFlag_BillLading    = 'L';                         //�����
  sFlag_BillPick      = 'P';                         //����
  sFlag_BillPost      = 'G';                         //����
  sFlag_BillReverse   = 'R';                         //����
  sFlag_BillDone      = 'O';                         //���

  sFlag_OrderNew      = 'N';                         //�µ�
  sFlag_OrderEdit     = 'E';                         //�޸�
  sFlag_OrderDel      = 'D';                         //ɾ��
  sFlag_OrderPuring   = 'L';                         //�ͻ���
  sFlag_OrderDone     = 'O';                         //���
  sFlag_OrderAbort    = 'A';                         //����
  sFlag_OrderStop     = 'S';                         //��ֹ

  sFlag_TypeShip      = 'S';                         //����
  sFlag_TypeZT        = 'Z';                         //ջ̨
  sFlag_TypeVIP       = 'V';                         //VIP
  sFlag_TypeTrain     = 'T';                         //��
  sFlag_TypeCommon    = 'C';                         //��ͨ,��������

  sFlag_CardIdle      = 'I';                         //���п�
  sFlag_CardUsed      = 'U';                         //ʹ����
  sFlag_CardLoss      = 'L';                         //��ʧ��
  sFlag_CardInvalid   = 'N';                         //ע����

  sFlag_CardLinShi    = 'L';                         //��ʱ
  sFlag_CardGuDing    = 'G';                         //�̶�

  sFlag_TruckNone     = 'N';                         //��״̬����
  sFlag_TruckIn       = 'I';                         //��������
  sFlag_TruckOut      = 'O';                         //��������
  sFlag_TruckBFP      = 'P';                         //����Ƥ�س���
  sFlag_TruckBFM      = 'M';                         //����ë�س���
  sFlag_TruckSH       = 'S';                         //�ͻ�����
  sFlag_TruckFH       = 'F';                         //�Żҳ���
  sFlag_TruckZT       = 'Z';                         //ջ̨����
  sFlag_TruckXH       = 'X';                         //���ճ���

  sFlag_PoundBZ       = 'B';                         //��׼
  sFlag_PoundPZ       = 'Z';                         //Ƥ��
  sFlag_PoundPD       = 'P';                         //���
  sFlag_PoundCC       = 'C';                         //����(����ģʽ)
  sFlag_PoundLS       = 'L';                         //��ʱ

  sFlag_BatchInUse    = 'Y';                         //���κ���Ч
  sFlag_BatchOutUse   = 'N';                         //���κ��ѷ��
  sFlag_BatchDel      = 'D';                         //���κ���ɾ��

  sFlag_ManualA       = 'A';                         //Ƥ��Ԥ��(�����¼�����)
  sFlag_ManualB       = 'B';                         //Ƥ�س�����Χ
  sFlag_ManualC       = 'C';                         //���س�����Χ
  sFlag_ManualD       = 'D';                         //�ճ�����
  sFlag_ManualE       = 'E';                         //����ʶ��
  sFlag_ManualF       = 'F';                         //������ʱ

  sFlag_PurPT         = 'PPT';                       //��ͨԭ����
  sFlag_PurND         = 'PND';                       //�ڵ�ԭ����
  sFlag_PurBP         = 'PBP';                       //��Ʒ����

  sFlag_SysParam      = 'SysParam';                  //ϵͳ����
  sFlag_FactoryID     = 'FactoryID';                 //�������
  sFlag_FactoryName   = 'FactoryName';                 //��������
  sFlag_EnableBakdb   = 'Uses_BackDB';               //���ÿ�
  sFlag_ValidDate     = 'SysValidDate';              //��Ч��
  sFlag_PrintBill     = 'PrintStockBill';            //���ӡ����
  sFlag_NFStock       = 'NoFaHuoStock';              //�ֳ����跢��
  sFlag_NFPurch       = 'NoFaHuoPurch';              //�ֳ����跢����ԭ���ϣ�
  sFlag_StockIfYS     = 'StockIfYS';                 //�ֳ��Ƿ�����
  sFlag_ViaBillCard   = 'ViaBillCard';               //ֱ���ƿ�
  sFlag_StrictSanVal  = 'StrictSanVal';              //�ϸ����ɢװ����
  sFlag_ShadowWeight  = 'ShadowWeight';              //Ӱ������
  sFlag_HYValue       = 'HYMaxValue';                //����������
  sFlag_VerifyTruckP  = 'VerifyTruckP';              //У��Ԥ��Ƥ��
  sFlag_VerifyFQValue = 'VerifyFQValue';             //��ֹ��ǩ�ų���
  sFlag_PEmpTWuCha    = 'EmpTruckWuCha';             //�ճ��������

  sFlag_WXFactory     = 'WXFactoryID';               //΢�ű�ʶ
  sFlag_WXServiceMIT  = 'WXServiceMIT';              //΢�Ź�������
  sFlag_WXSrvRemote   = 'WXServiceRemote';           //΢��Զ�̷���

  sFlag_HHJYServiceMIT= 'HHJYService';              //��Ӿ�Զ��������
  sFlag_HHJYDepotID   = 'HHJYDepotID';               //��Ӿ�Զ�����ID

  sFlag_ERPSrv        = 'ERPService';                //ERP�ӿڵ�ַ
  sFlag_PackType      = 'PackType';                  //��װ����
  sFlag_PrinterBill   = 'PrinterBill';               //СƱ��ӡ��
  sFlag_PrinterHYDan  = 'PrinterHYDan';              //���鵥��ӡ��

  sFlag_PoundIfDai    = 'PoundIFDai';                //��װ�Ƿ����
  sFlag_PoundWuCha    = 'PoundWuCha';                //����������
  sFlag_PoundPWuChaZ  = 'PoundPWuChaZ';              //Ƥ�������
  sFlag_PoundPWuChaF  = 'PoundPWuChaF';              //Ƥ�ظ����
  sFlag_PDaiWuChaZ    = 'PoundDaiWuChaZ';            //��װ�����
  sFlag_PDaiWuChaF    = 'PoundDaiWuChaF';            //��װ�����
  sFlag_PDaiPercent   = 'PoundDaiPercent';           //�������������
  sFlag_PDaiWuChaStop = 'PoundDaiWuChaStop';         //���ʱֹͣҵ��
  sFlag_PSanWuChaF    = 'PoundSanWuChaF';            //ɢװ�����
  sFlag_PTruckPWuCha  = 'PoundTruckPValue';          //�ճ�Ƥ���
  sFlag_PoundMultiM   = 'PoundMultiM';               //������ι���
  sFlag_PoundAsternM  = 'PoundAsternM';              //�����°�����
  sFlag_HhcField      = 'HhcField';                  //��ϲ��ֶ�
  sFlag_HYReportName  = 'HYReportName';              //���鵥��������

  sFlag_CommonItem    = 'CommonItem';                //������Ϣ
  sFlag_AreaItem      = 'AreaItem';                  //������Ϣ��
  sFlag_BankItem      = 'BankItem';                  //������Ϣ��
  sFlag_CustomerItem  = 'CustomerItem';              //�ͻ���Ϣ��
  sFlag_SalesmanItem  = 'SalesmanItem';              //ҵ��Ա��Ϣ��
  sFlag_CardItem      = 'CardItem';                  //�ſ���Ϣ��
  sFlag_TruckItem     = 'TruckItem';                 //������Ϣ��
  sFlag_UserLogItem   = 'UserLogItem';               //�û���¼��
  sFlag_StockItem     = 'StockItem';                 //ˮ����Ϣ��
  sFlag_BillItem      = 'BillItem';                  //�ᵥ��Ϣ��
  sFlag_TruckQueue    = 'TruckQueue';                //��������
  sFlag_LadingItem    = 'LadingItem';                //�����ʽ��Ϣ��
  sFlag_ProviderItem  = 'ProviderItem';              //��Ӧ����Ϣ��
  sFlag_MaterailsItem = 'MaterailsItem';             //ԭ������Ϣ��
  sFlag_SaleOrderItem = 'SaleOrderItem';             //���۶�����Ϣ��

  sFlag_HardSrvURL    = 'HardMonURL';
  sFlag_MITSrvURL     = 'MITServiceURL';
  sFlag_WechatSrvURL  = 'WXServiceURL';              //�����ַ

  sFlag_AutoIn        = 'Truck_AutoIn';              //�Զ�����
  sFlag_AutoOut       = 'Truck_AutoOut';             //�Զ�����
  sFlag_InTimeout     = 'InFactTimeOut';             //������ʱ(����)
  sFlag_SanMultiBill  = 'SanMultiBill';              //ɢװԤ���൥
  sFlag_NoDaiQueue    = 'NoDaiQueue';                //��װ���ö���
  sFlag_NoSanQueue    = 'NoSanQueue';                //ɢװ���ö���
  sFlag_DelayQueue    = 'DelayQueue';                //�ӳ��Ŷ�(����)
  sFlag_PoundQueue    = 'PoundQueue';                //�ӳ��Ŷ�(�������ݹ�Ƥʱ��)
  sFlag_NetPlayVoice  = 'NetPlayVoice';              //ʹ��������������
  sFlag_BatchAuto     = 'BatchAuto';                 //ʹ���Զ����κ�
  sFlag_SetPValue     = 'SetPValue';                 //Ԥ��Ƥ�ط�ֵ
  sFlag_MinNetValue   = 'MinNetValue';               //���۹���������ֵ
  sFlag_TimeOutValue  = 'TimeOutValue';              //���۳�����ʱʱ��
  sFlag_EventDept     = 'PoundEventDept';            //���۹����¼����Ͳ���
  sFlag_TruckType     = 'TruckType';                 //��������
  sFlag_TruckXzTotal  = 'TruckXzTotal';              //�����ܿ���
  sFlag_UPLS          = 'UnLodingPlaceLS';           //��ʱ����ж���ص�

  sFlag_BusGroup      = 'BusFunction';               //ҵ�������
  sFlag_BillNo        = 'Bus_Bill';                  //��������
  sFlag_PoundID       = 'Bus_Pound';                 //���ؼ�¼
  sFlag_Customer      = 'Bus_Customer';              //�ͻ����
  sFlag_SaleMan       = 'Bus_SaleMan';               //ҵ��Ա���
  sFlag_ZhiKa         = 'Bus_ZhiKa';                 //ֽ�����
  sFlag_WeiXin        = 'Bus_WeiXin';                //΢��ӳ����
  sFlag_HYDan         = 'Bus_HYDan';                 //���鵥��
  sFlag_SaleOrderOther= 'Bus_SOO';                   //��ʱ������
  sFlag_WTNo          = 'Bus_WT';                    //ί�е���
  sFlag_SaleOrderNo   = 'Bus_SaleOrder';             //���۶���

  sFlag_TruckInNeedManu = 'TruckInNeedManu';         //����ʶ����Ҫ�˹���Ԥ
  sFlag_CardGInvalid  = 'CardGInvalid';              //���ڿ��Ƿ�ʧЧ
  
  sFlag_SerialSAP     = 'SAPFunction';               //SAP������
  sFlag_SAPMsgNo      = 'SAP_MsgNo';                 //SAP��Ϣ��
  sFlag_ForceHint     = 'Bus_HintMsg';               //ǿ����ʾ

  sFlag_Departments   = 'Departments';               //�����б�
  sFlag_DepDaTing     = '����';                      //�������
  sFlag_DepJianZhuang = '��װ';                      //��װ
  sFlag_DepBangFang   = '����';                      //����
  sFlag_DepMenGang    = '�Ÿ�';                      //�Ÿ�
  sFlag_DepHauYanShi  = '������';                    //������

  sFlag_Solution_OK   = 'O=֪����';
  sFlag_Solution_YN   = 'Y=ͨ��;N=��ֹ';
  sFlag_Solution_YNI  = 'Y=ͨ��;N=��ֹ;I=����';

  {*���ݱ�*}
  sTable_Group        = 'Sys_Group';                 //�û���
  sTable_User         = 'Sys_User';                  //�û���
  sTable_Menu         = 'Sys_Menu';                  //�˵���
  sTable_Popedom      = 'Sys_Popedom';               //Ȩ�ޱ�
  sTable_PopItem      = 'Sys_PopItem';               //Ȩ����
  sTable_Entity       = 'Sys_Entity';                //�ֵ�ʵ��
  sTable_DictItem     = 'Sys_DataDict';              //�ֵ���ϸ

  sTable_SysDict      = 'Sys_Dict';                  //ϵͳ�ֵ�
  sTable_ExtInfo      = 'Sys_ExtInfo';               //������Ϣ
  sTable_SysLog       = 'Sys_EventLog';              //ϵͳ��־
  sTable_BaseInfo     = 'Sys_BaseInfo';              //������Ϣ
  sTable_SerialBase   = 'Sys_SerialBase';            //��������
  sTable_SerialStatus = 'Sys_SerialStatus';          //���״̬
  sTable_WorkePC      = 'Sys_WorkePC';               //��֤��Ȩ
  sTable_ManualEvent  = 'Sys_ManualEvent';           //�˹���Ԥ

  sTable_Customer     = 'S_Customer';                //�ͻ���Ϣ
  sTable_Salesman     = 'S_Salesman';                //ҵ����Ա
  sTable_SalesOrder   = 'S_Order';                   //���۶���

  sTable_Bill         = 'S_Bill';                    //�����
  sTable_BillBak      = 'S_BillBak';                 //��ɾ������
  sTable_Card         = 'S_Card';                    //���۴ſ�

  sTable_StockMatch   = 'S_StockMatch';              //Ʒ��ӳ��
  sTable_StockParam   = 'S_StockParam';              //Ʒ�ֲ���
  sTable_StockParamExt= 'S_StockParamExt';           //������չ
  sTable_StockRecord  = 'S_StockRecord';             //�����¼
  sTable_StockHuaYan  = 'S_StockHuaYan';             //�����鵥
  sTable_StockBatcode = 'S_Batcode';                 //���κ�
  sTable_BatRecord    = 'S_BatcodeRecord';           //���μ�¼

  sTable_Truck        = 'S_Truck';                   //������
  sTable_ZTLines      = 'S_ZTLines';                 //װ����
  sTable_ZTTrucks     = 'S_ZTTrucks';                //��������
  sTable_Unloading    = 'S_Unloading';               //ж���ص�

  sTable_Provider     = 'P_Provider';                //�ͻ���
  sTable_Materails    = 'P_Materails';               //���ϱ�

  sTable_TruckXz      = 'Sys_TruckXz';               //�������ر�

  sTable_DataTemp     = 'Sys_DataTemp';              //��ʱ����  
  sTable_PoundLog     = 'Sys_PoundLog';              //��������
  sTable_PoundBak     = 'Sys_PoundBak';              //��������
  sTable_Picture      = 'Sys_Picture';               //���ͼƬ
  sTable_PoundDaiWC   = 'Sys_PoundDaiWuCha';         //��װ���
  sTable_WebOrderMatch   = 'S_WebOrderMatch';        //�̳Ƕ���ӳ��
  sTable_HHJYUrl      = 'Sys_HHJYUrl';               //��Ӿ�Զ�ӿڵ�ַ��
  sTable_HHJYUrlBak   = 'Sys_HHJYUrlBak';            //��Ӿ�Զ�ӿڵ�ַ��
  sTable_HHJYSync     = 'Sys_HHJYSync';              //��Ӿ�Զ����ͬ����

  //��Ӿ�ԶERP���ݱ�-----------------------------------------------------------
  sTable_HH_MaterielType = 'T_Sys_MaterielType';    //���Ϸ���
  sTable_HH_Materiel     = 'T_Sys_Materiel';        //������ϸ
  sTable_HH_Customer     = 'V_SaleCustomer';        //�ͻ���Ϣ
  sTable_HH_CusInv       = 'T_SaleCustomerInvoiceInfo';//�ͻ���Ʊ��Ϣ
  sTable_HH_Provider     = 'T_SupplyProvider';      //�ͻ���Ϣ
  sTable_HH_OrderPlan    = 'V_SupplyMaterialEntryPlan_AllowExecute';//ԭ���Ͻ����ƻ�
  sTable_HH_OrderPlanT   = 'T_SupplyMaterialEntryPlan';//ԭ���Ͻ����ƻ�(��)
  sTable_HH_OrderPoundData = 'V_SupplyMaterialReceiveBill_GrossWeight';//ԭ���ϰ���
  sTable_HH_OrderPDataAudit = 'V_SupplyMaterialReceiveBill_Auditing';//ԭ���ϰ������
  sTable_HH_AuditRecord  = 'T_SupplyBusinessAuditingRecord';         //��˼�¼
  sTable_HH_OrderAccount = 'T_SupplyMaterielAccount';                //����
  sTable_HH_NdOrderPlan  = 'V_SupplyMaterialTransferPlan_AllowExecute';//�ڵ�ԭ���Ͻ����ƻ�
  sTable_HH_NdOrderPlanT = 'T_SupplyMaterialTransferPlan';//�ڵ�ԭ���Ͻ����ƻ�(��)
  sTable_HH_NdOrderPoundData = 'T_SupplyMaterialTransferBill';//�ڵ�ԭ���ϰ���
  sTable_HH_OtherOrderPoundData = 'V_SupplyWeighBill';//����ԭ���ϰ���
  sTable_HH_SysUser      = 'T_Sys_User';            //ϵͳ�û�
  sTable_HH_AuditMenu    = 'T_SupplyAuditingFlowSummary';            //��˲˵���
  sTable_HH_AuditPro     = 'T_SupplyAuditingFlowProcess';            //������̱�
  sTable_HH_SupplyMD     = 'P_SupplyMaterialDepot'; //��ȡ������ش洢����
  sTable_HH_BILLNUMBER   = 'P_SYS_BILLNUMBER';      //��ȡ��ˮ�Ŵ洢����
  sTable_HH_SysCounter   = 'T_Sys_Counter';      //������
  sTable_HH_SalePlan     = 'V_SaleValidConsignPlanBill';//���ۼƻ�
  sTable_HH_SaleDetail   = 'T_SaleConsignBill';//������ϸ
  sTable_HH_SaleWTTruck  = 'T_SaleTransportforCustomer';//����ί��

  sFlag_SMRB             = 'T_SupplyMaterialReceiveBill';//��ȡԭ���ϳ�����ˮID
  sFlag_SAFP             = 'T_SupplyAuditingFlowProcess';//��ȡԭ���������ˮID
  sFlag_SMTB             = 'T_SupplyMaterialTransferBill';//�ڵ�ԭ���ϳ�����ˮID
  sFlag_SWB              = 'T_SupplyWeighBill';//����ԭ���ϳ�����ˮID
  sFlag_SCB              = 'T_SaleConsignBill';//������ˮID
  //----------------------------------------------------------------------------

  sFlag_OrderCardL     = 'L';                        //��ʱ
  sFlag_OrderCardG     = 'G';                        //�̶�

  sTable_Order         = 'P_Order';                  //�ɹ�����
  sTable_OrderBak      = 'P_OrderBak';               //��ɾ���ɹ�����
  sTable_OrderDtl      = 'P_OrderDtl';               //�ɹ�������ϸ
  sTable_OrderDtlBak   = 'P_OrderDtlBak';            //�ɹ�������ϸ
  sTable_OrderBase     = 'P_OrderBase';              //�ɹ����붩��
  sTable_CardOther     = 'S_CardOther';              //��ʱ����
  sTable_OrderBaseMain = 'P_OrderBaseMain';          //�ɹ����붩������

    sFlag_Order         = 'Bus_Order';                 //�ɹ�����
    sFlag_OrderDtl      = 'Bus_OrderDtl';              //�ɹ�����

  {*�½���*}
  sSQL_NewSysDict = 'Create Table $Table(D_ID $Inc, D_Name varChar(15),' +
       'D_Desc varChar(30), D_Value varChar(50), D_Memo varChar(20),' +
       'D_ParamA $Float, D_ParamB varChar(50), D_ParamC varChar(50),' +
       'D_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   ϵͳ�ֵ�: SysDict
   *.D_ID: ���
   *.D_Name: ����
   *.D_Desc: ����
   *.D_Value: ȡֵ
   *.D_Memo: �����Ϣ
   *.D_ParamA: �������
   *.D_ParamB: �ַ�����
   *.D_ParamC: �ַ�����
   *.D_Index: ��ʾ����
  -----------------------------------------------------------------------------}
  
  sSQL_NewExtInfo = 'Create Table $Table(I_ID $Inc, I_Group varChar(20),' +
       'I_ItemID varChar(20), I_Item varChar(30), I_Info varChar(500),' +
       'I_ParamA $Float, I_ParamB varChar(50), I_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   ��չ��Ϣ��: ExtInfo
   *.I_ID: ���
   *.I_Group: ��Ϣ����
   *.I_ItemID: ��Ϣ��ʶ
   *.I_Item: ��Ϣ��
   *.I_Info: ��Ϣ����
   *.I_ParamA: �������
   *.I_ParamB: �ַ�����
   *.I_Memo: ��ע��Ϣ
   *.I_Index: ��ʾ����
  -----------------------------------------------------------------------------}
  
  sSQL_NewSysLog = 'Create Table $Table(L_ID $Inc, L_Date DateTime,' +
       'L_Man varChar(32),L_Group varChar(20), L_ItemID varChar(20),' +
       'L_KeyID varChar(20), L_Event varChar(220))';
  {-----------------------------------------------------------------------------
   ϵͳ��־: SysLog
   *.L_ID: ���
   *.L_Date: ��������
   *.L_Man: ������
   *.L_Group: ��Ϣ����
   *.L_ItemID: ��Ϣ��ʶ
   *.L_KeyID: ������ʶ
   *.L_Event: �¼�
  -----------------------------------------------------------------------------}

  sSQL_NewBaseInfo = 'Create Table $Table(B_ID $Inc, B_Group varChar(15),' +
       'B_Text varChar(100), B_Py varChar(25), B_Memo varChar(50),' +
       'B_PID Integer, B_Index Float)';
  {-----------------------------------------------------------------------------
   ������Ϣ��: BaseInfo
   *.B_ID: ���
   *.B_Group: ����
   *.B_Text: ����
   *.B_Py: ƴ����д
   *.B_Memo: ��ע��Ϣ
   *.B_PID: �ϼ��ڵ�
   *.B_Index: ����˳��
  -----------------------------------------------------------------------------}

  sSQL_NewSerialBase = 'Create Table $Table(R_ID $Inc, B_Group varChar(15),' +
       'B_Object varChar(32), B_Prefix varChar(25), B_IDLen Integer,' +
       'B_Base Integer, B_Date DateTime)';
  {-----------------------------------------------------------------------------
   ���б�Ż�����: SerialBase
   *.R_ID: ���
   *.B_Group: ����
   *.B_Object: ����
   *.B_Prefix: ǰ׺
   *.B_IDLen: ��ų�
   *.B_Base: ����
   *.B_Date: �ο�����
  -----------------------------------------------------------------------------}

  sSQL_NewSerialStatus = 'Create Table $Table(R_ID $Inc, S_Object varChar(32),' +
       'S_SerailID varChar(32), S_PairID varChar(32), S_Status Char(1),' +
       'S_Date DateTime)';
  {-----------------------------------------------------------------------------
   ����״̬��: SerialStatus
   *.R_ID: ���
   *.S_Object: ����
   *.S_SerailID: ���б��
   *.S_PairID: ��Ա��
   *.S_Status: ״̬(Y,N)
   *.S_Date: ����ʱ��
  -----------------------------------------------------------------------------}

  sSQL_NewWorkePC = 'Create Table $Table(R_ID $Inc, W_Name varChar(100),' +
       'W_MAC varChar(32), W_Factory varChar(32), W_Serial varChar(32),' +
       'W_Departmen varChar(32), W_ReqMan varChar(32), W_ReqTime DateTime,' +
       'W_RatifyMan varChar(32), W_RatifyTime DateTime,' +
       'W_PoundID varChar(50), W_MITUrl varChar(128), W_HardUrl varChar(128),' +
       'W_Valid Char(1))';
  {-----------------------------------------------------------------------------
   ������Ȩ: WorkPC
   *.R_ID: ���
   *.W_Name: ��������
   *.W_MAC: MAC��ַ
   *.W_Factory: �������
   *.W_Departmen: ����
   *.W_Serial: ���
   *.W_ReqMan,W_ReqTime: ��������
   *.W_RatifyMan,W_RatifyTime: ��׼
   *.W_PoundID:��վ���
   *.W_MITUrl:ҵ�����
   *.W_HardUrl:Ӳ������
   *.W_Valid: ��Ч(Y/N)
  -----------------------------------------------------------------------------}

  sSQL_NewManualEvent = 'Create Table $Table(R_ID $Inc, E_ID varChar(32),' +
       'E_From varChar(32), E_Key varChar(32), E_Event varChar(200), ' +
       'E_Solution varChar(100), E_Result varChar(12),E_Departmen varChar(32),' +
       'E_Date DateTime, E_ManDeal varChar(32), E_DateDeal DateTime, ' +
       'E_ParamA Integer, E_ParamB varChar(128), E_Memo varChar(512))';
  {-----------------------------------------------------------------------------
   �˹���Ԥ�¼�: ManualEvent
   *.R_ID: ���
   *.E_ID: ��ˮ��
   *.E_From: ��Դ
   *.E_Key: ��¼��ʶ
   *.E_Event: �¼�
   *.E_Solution: ��������(��ʽ��: Y=ͨ��;N=��ֹ) 
   *.E_Result: �������(Y/N)
   *.E_Departmen: ��������
   *.E_Date: ����ʱ��
   *.E_ManDeal,E_DateDeal: ������
   *.E_ParamA: ���Ӳ���, ����
   *.E_ParamB: ���Ӳ���, �ַ���
   *.E_Memo: ��ע��Ϣ
  -----------------------------------------------------------------------------}

  sSQL_NewStockMatch = 'Create Table $Table(R_ID $Inc, M_Group varChar(8),' +
       'M_ID varChar(20), M_Name varChar(80), M_Status Char(1))';
  {-----------------------------------------------------------------------------
   ����Ʒ��ӳ��: StockMatch
   *.R_ID: ��¼���
   *.M_Group: ����
   *.M_ID: ���Ϻ�
   *.M_Name: ��������
   *.M_Status: ״̬
  -----------------------------------------------------------------------------}

  sSQL_NewSalesMan = 'Create Table $Table(R_ID $Inc, S_ID varChar(15),' +
       'S_Name varChar(30), S_PY varChar(30), S_Phone varChar(20),' +
       'S_Area varChar(50), S_InValid Char(1), S_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   ҵ��Ա��: SalesMan
   *.R_ID: ��¼��
   *.S_ID: ���
   *.S_Name: ����
   *.S_PY: ��ƴ
   *.S_Phone: ��ϵ��ʽ
   *.S_Area:��������
   *.S_InValid: ����Ч
   *.S_Memo: ��ע
  -----------------------------------------------------------------------------}

  sSQL_NewCustomer = 'Create Table $Table(R_ID $Inc, C_ID varChar(15), ' +
       'C_Name varChar(80), C_PY varChar(80), C_Addr varChar(100), ' +
       'C_FaRen varChar(50), C_LiXiRen varChar(50), C_WeiXin varChar(32),' +
       'C_Phone varChar(15), C_Fax varChar(15), C_Tax varChar(32),' +
       'C_Bank varChar(35), C_Account varChar(18), C_SaleMan varChar(15),' +
       'C_Param varChar(32), C_Memo varChar(50), C_XuNi Char(1))';
  {-----------------------------------------------------------------------------
   �ͻ���Ϣ��: Customer
   *.R_ID: ��¼��
   *.C_ID: ���
   *.C_Name: ����
   *.C_PY: ƴ����д
   *.C_Addr: ��ַ
   *.C_FaRen: ����
   *.C_LiXiRen: ��ϵ��
   *.C_Phone: �绰
   *.C_WeiXin: ΢��
   *.C_Fax: ����
   *.C_Tax: ˰��
   *.C_Bank: ������
   *.C_Account: �ʺ�
   *.C_SaleMan: ҵ��Ա
   *.C_Param: ���ò���
   *.C_Memo: ��ע��Ϣ
   *.C_XuNi: ����(��ʱ)�ͻ�
  -----------------------------------------------------------------------------}

//  sSQL_NewSalesOrder = 'Create Table $Table(R_ID $Inc, VBELN varChar(20),' +
//       'BSTKD varChar(80), POSNR varChar(12),' +
//       'MATNR varChar(40), ARKTX varChar(200),' +
//       'KUNNR varChar(40), KUNNRDESC varChar(200), O_CusPY varChar(200),' +
//       'WERKS varChar(8), WERKSDESC varChar(80),' +
//       'VKORG varChar(8), BZIRK varChar(40), BZTXT varChar(80),' +
//       'KDGRP varChar(20), KTEXT varChar(80),' +
//       'KONDA varChar(20), VTEXTK varChar(80),' +
//       'VTWEG varChar(20), VTEXTV varChar(80),' +
//       'VTEXT varChar(40), PRSDT varChar(40),' +
//       'KWMENG varChar(20), CMPRE varChar(20), FLAG varChar(10),' +
//       'ZSUM varChar(20), ZAVA varChar(20), KBETR varChar(20),' +
//       'KNUMH varChar(40), FS_STATE varChar(1), FS_WEIGHTNO varChar(30),' +
//       'O_Valid Char(1), O_Freeze $Float, O_HasDone $Float,' +
//       'O_Create DateTime, O_ModifyNum Integer, O_Modify DateTime)';
//  {-----------------------------------------------------------------------------
//    ���۶�����: SalesOrder
//    *.VBELN: ������
//    *.BSTKD: ��ͬ��
//    *.POSNR: ��Ŀ��
//    *.MATNR: ���ϱ��
//    *.ARKTX: ��������
//    *.KUNNR: �ͻ����
//    *.KUNNRDESC: �ͻ�����
//    *.O_CusPY: �ͻ�ƴ��
//    *.WERKS: ����
//    *.WERKSDESC: ��������
//    *.VKORG: ���ۻ���
//    *.BZIRK: ��������
//    *.BZTXT: ������������
//    *.KDGRP: �۸�����
//    *.KTEXT: �۸���������
//    *.KONDA: Ƭ��
//    *.VTEXTK: Ƭ������
//    *.VTWEG: ��������
//    *.VTEXTV: ������������
//    *.VTEXT: ��װ��ʽ��31/32
//    *.PRSDT: ��������
//    *.KWMENG: ��������
//    *.CMPRE: ����
//    *.FLAG: �汾�����
//    *.ZSUM: �������
//    *.ZAVA: Ԥ�ƿ�������
//    *.KBETR: ��Ŀ���ϵ���
//    *.KNUMH: ������¼��
//    *.FS_STATE: ����״̬  0���ر�  1����
//    *.FS_WEIGHTNO: �������
//    *.O_Valid: ������Ч(y/n)
//    *.O_Freeze: ������
//    *.O_HasDone: ������
//    *.O_ModifyNum: �޸ļ���
//    *.O_Create,O_Modify: �����޸�ʱ��
//  -----------------------------------------------------------------------------}

  sSQL_NewSalesOrder = 'Create Table $Table(R_ID $Inc, O_Order varChar(30),' +
       'O_Factory varChar(80), O_CusName varChar(120),' +
       'O_StockName varChar(40), O_StockType varChar(10),' +
       'O_Lading varChar(10), O_CusPY varChar(200),' +
       'O_PlanAmount varChar(20), O_PlanDone varChar(20),' +
       'O_PlanRemain varChar(20), O_PlanBegin DateTime, O_PlanEnd DateTime,' +
       'O_Company varChar(80), O_YF $Float default 0, O_Money $Float default 0,' +
       'O_Depart varChar(20), O_SaleMan varChar(20), O_CusID varChar(30),' +
       'O_Remark varChar(200), O_Price $Float, O_CompanyID varChar(30),' +
       'O_StockID varChar(30), O_PackingID varChar(5), O_FactoryID varChar(30),' +
       'O_Valid Char(1), O_Freeze $Float, O_HasDone $Float, O_StopAmount $Float,' +
       'O_SaleArea varChar(20),' +
       'O_Create DateTime, O_ModifyNum Integer, O_Modify DateTime)';
  {-----------------------------------------------------------------------------
    ���۶�����: SalesOrder
    *.O_Order: ������
    *.O_Factory: ��������  ��ĥվ ���ƹ���  �вİ���
    *.O_CusName: �ͻ�����
    *.O_StockName: ��������
    *.O_StockType: ��װ��ʽ  ��װ ɢװ
    *.O_Lading: �����ʽ
    *.O_CusPY: �ͻ�ƴ��
    *.O_PlanAmount: �ƻ�����
    *.O_PlanDone: �������
    *.O_PlanRemain: ʣ������
    *.O_PlanBegin: ��ʼ����
    *.O_PlanEnd: ��ֹ����
    *.O_Company: ������λ
    *.O_Depart: ����
    *.O_SaleMan: ����Ա
    *.O_Remark: ��ע
    *.O_Price: ����
    *.O_Valid: ������Ч(y/n)
    *.O_Freeze: ������
    *.O_HasDone: ������
    *.O_StopAmount: ͣ����
    *.O_ModifyNum: �޸ļ���
    *.O_CusID: �ͻ����
    *.O_CompanyID: ��˾���
    *.O_StockID: ����ID
    *.O_PackingID: ��װ����ID
    *.O_FactoryID: ������ID
    *.O_Create,O_Modify: �����޸�ʱ��
    *.O_SaleArea: ��������
  -----------------------------------------------------------------------------}

  sSQL_NewBill = 'Create Table $Table(R_ID $Inc, L_ID varChar(20),' +
       'L_Card varChar(16), L_ZhiKa varChar(15), L_Order varChar(20),' +
       'L_Project varChar(100), L_Area varChar(50),' +
       'L_CusID varChar(15), L_CusName varChar(80), L_CusPY varChar(80),' +
       'L_SaleID varChar(15), L_SaleMan varChar(32),' +
       'L_Type Char(1), L_StockNo varChar(20), L_StockName varChar(80),' +
       'L_Value $Float, L_Price $Float, L_ZKMoney Char(1),' +
       'L_Truck varChar(15), L_Phone varChar(32), L_TruckEmpty varChar(1),' +
       'L_Status Char(1), L_NextStatus Char(1),' +
       'L_InTime DateTime, L_InMan varChar(32),' +
       'L_PValue $Float, L_PDate DateTime, L_PMan varChar(32),' +
       'L_MValue $Float, L_MDate DateTime, L_MMan varChar(32),' +
       'L_LadeTime DateTime, L_LadeMan varChar(32), ' +
       'L_LadeLine varChar(15), L_LineName varChar(32), ' +
       'L_DaiTotal Integer , L_DaiNormal Integer, L_DaiBuCha Integer,' +
       'L_OutFact DateTime, L_OutMan varChar(32), L_NewID varChar(20),' +
       'L_PickOk varChar(1), L_PickNum Integer Default 0,' +
       'L_PickDate DateTime, L_PickMan varchar(32), ' +
       'L_PostOk varChar(1), L_PostNum Integer Default 0,' +
       'L_PostDate DateTime, L_PostMan varchar(32), ' +
       'L_PrintGLF Char(1), L_Lading Char(1), L_IsVIP varChar(1), ' +
       'L_Seal varChar(100), L_HYDan varChar(15),' +
       'L_HYFirst DateTime, L_PrintHY Char(1),' +
       'L_Man varChar(32), L_Date DateTime, ' +
       'L_Unloading varChar(500), L_Memo varChar(200),' +
       'L_CalYF char(1), L_YunFei $Float Default 0,,' +
       'L_DelMan varChar(32), L_DelDate DateTime, L_IndentyID varChar(32),' +
       'L_BatMan varChar(15),L_BatDate DateTime,L_SaleArea varChar(20),' +
       'L_WebOrderID varChar(20))';
  {-----------------------------------------------------------------------------
   ��������: Bill
   *.R_ID: ���
   *.L_ID: �ᵥ��
   *.L_Card: �ſ���
   *.L_ZhiKa: ֽ����
   *.L_Order: ������(����)
   *.L_Area: ����
   *.L_CusID,L_CusName,L_CusPY:�ͻ�
   *.L_SaleID,L_SaleMan:ҵ��Ա
   *.L_Type: ����(��,ɢ)
   *.L_StockNo: ���ϱ��
   *.L_StockName: ��������
   *.L_Value: �����
   *.L_Price: �������
   *.L_ZKMoney: ռ��ֽ������(Y/N)
   *.L_Truck: ������
   *.L_Phone: ��ϵ�绰
   *.L_TruckEmpty: �ճ�����(Y/N)
   *.L_Status,L_NextStatus:״̬����
   *.L_InTime,L_InMan: ��������
   *.L_PValue,L_PDate,L_PMan: ��Ƥ��
   *.L_MValue,L_MDate,L_MMan: ��ë��
   *.L_LadeTime,L_LadeMan: ����ʱ��,������
   *.L_LadeLine,L_LineName: ����ͨ��
   *.L_DaiTotal,L_DaiNormal,L_DaiBuCha:��װ,����,����
   *.L_OutFact,L_OutMan: ��������
   *.L_NewID: ���䡢����ʱ�µ���
   *.L_PickOk,L_PickNum,L_PickDate,L_PickMan: ����
   *.L_PostOk,L_PostNum,L_PostDate,L_PostMan: ����
   *.L_Lading: �����ʽ(����,�ͻ�)
   *.L_IsVIP:VIP��
   *.L_PrintGLF:�Ƿ��Զ���ӡ��·��
   *.L_Seal: ��ǩ��
   *.L_HYDan: ���鵥
   *.L_HYFirst:����״�ʹ������
   *.L_PrintHY:�Զ���ӡ���鵥
   *.L_Man:������
   *.L_Date:����ʱ��
   *.L_DelMan: ������ɾ����Ա
   *.L_DelDate: ������ɾ��ʱ��
   *.L_Unloading: ж���ص�
   *.L_Memo: ������ע
   *.L_WebOrderID: �̳����뵥
   *.L_IndentyID: ˾������֤��
   *.L_BatMan: ����¼����Ա
   *.L_BatDate: ����¼��ʱ��
   *.L_SaleArea: ��������
  -----------------------------------------------------------------------------}

  sSQL_NewCard = 'Create Table $Table(R_ID $Inc, C_Card varChar(16),' +
       'C_Card2 varChar(32), C_Card3 varChar(32),' +
       'C_Owner varChar(15), C_TruckNo varChar(15), C_Status Char(1),' +
       'C_Freeze Char(1), C_Used Char(1), C_UseTime Integer Default 0,' +
       'C_Man varChar(32), C_Date DateTime, C_Memo varChar(500))';
  {-----------------------------------------------------------------------------
   �ſ���:Card
   *.R_ID:��¼���
   *.C_Card:������
   *.C_Card2,C_Card3:������
   *.C_Owner:�����˱�ʶ
   *.C_TruckNo:�������
   *.C_Used:��;(��Ӧ,����,��ʱ)
   *.C_UseTime:ʹ�ô���
   *.C_Status:״̬(����,ʹ��,ע��,��ʧ)
   *.C_Freeze:�Ƿ񶳽�
   *.C_Man:������
   *.C_Date:����ʱ��
   *.C_Memo:��ע��Ϣ
  -----------------------------------------------------------------------------}

  sSQL_NewTruck = 'Create Table $Table(R_ID $Inc, T_Truck varChar(15), ' +
       'T_PY varChar(15), T_Owner varChar(32), T_Phone varChar(15), ' +
       'T_PrePValue $Float, T_PrePMan varChar(32), T_PrePTime DateTime, ' +
       'T_PrePUse Char(1), T_MinPVal $Float, T_MaxPVal $Float, ' +
       'T_PValue $Float Default 0, T_PTime Integer Default 0,' +
       'T_PlateColor varChar(12),T_Type varChar(12), T_LastTime DateTime, ' +
       'T_PoundLastTime DateTime, T_PoundValue $Float Default 0,' +
       'T_Card varChar(32), T_CardUse Char(1), T_NoVerify Char(1),' +
       'T_MatePID varChar(32), T_MateID varChar(32), T_MateName varChar(80),' +
       'T_SrcAddr varChar(150), T_DestAddr varChar(150),' +
       'T_Valid Char(1), T_VIPTruck Char(1), T_HasGPS Char(1))';
  {-----------------------------------------------------------------------------
   ������Ϣ:Truck
   *.R_ID: ��¼��
   *.T_Truck: ���ƺ�
   *.T_PY: ����ƴ��
   *.T_Owner: ����
   *.T_Phone: ��ϵ��ʽ
   *.T_PrePValue: Ԥ��Ƥ��
   *.T_PrePMan: Ԥ��˾��
   *.T_PrePTime: Ԥ��ʱ��
   *.T_PrePUse: ʹ��Ԥ��
   *.T_MinPVal: ��ʷ��СƤ��
   *.T_MaxPVal: ��ʷ���Ƥ��
   *.T_PValue: ��ЧƤ��
   *.T_PTime: ��Ƥ����
   *.T_PlateColor: ������ɫ
   *.T_Type: ����
   *.T_LastTime: �ϴλ
   *.T_Card: ���ӱ�ǩ
   *.T_CardUse: ʹ�õ���ǩ(Y/N)
   *.T_NoVerify: ��У��ʱ��
   *.T_Valid: �Ƿ���Ч
   *.T_VIPTruck:�Ƿ�VIP
   *.T_HasGPS:��װGPS(Y/N)

   //---------------------------�̵�ҵ��������Ϣ--------------------------------
   *.T_MatePID:�ϸ����ϱ��
   *.T_MateID:���ϱ��
   *.T_MateName: ��������
   *.T_SrcAddr:������ַ
   *.T_DestAddr:�����ַ
   ---------------------------------------------------------------------------//

   ��Чƽ��Ƥ���㷨:
   T_PValue = (T_PValue * T_PTime + ��Ƥ��) / (T_PTime + 1)
  -----------------------------------------------------------------------------}

  sSQL_NewUploading = 'Create Table $Table(R_ID $Inc, U_Location varChar(500),' +
       'U_Py varChar(500), U_Man varChar(32), U_Date DateTime)';
  {-----------------------------------------------------------------------------
   ж���ص�: Uploading
   *.R_ID: ���
   *.U_Location: �ص�
   *.U_Py: ƴ����д
   *.U_Man,U_Date: ������
  -----------------------------------------------------------------------------}

  sSQL_NewPoundLog = 'Create Table $Table(R_ID $Inc, P_ID varChar(15),' +
       'P_Type varChar(1), P_Order varChar(20), P_Card varChar(16),' +
       'P_Bill varChar(20), P_Truck varChar(15), P_CusID varChar(32),' +
       'P_CusName varChar(80), P_MID varChar(32),P_MName varChar(80),' +
       'P_MType varChar(10), P_LimValue $Float,' +
       'P_PValue $Float, P_PDate DateTime, P_PMan varChar(32), ' +
       'P_MValue $Float, P_MDate DateTime, P_MMan varChar(32), ' +
       'P_FactID varChar(32), P_PStation varChar(10), P_MStation varChar(10),' +
       'P_Direction varChar(10), P_PModel varChar(10), P_Status Char(1),' +
       'P_Valid Char(1), P_PrintNum Integer Default 1, P_OrderBak varChar(20),' +
       'P_BDAX Char(1) not null default((0)),P_BDNUM int not null default((0)),'+
       'P_DelMan varChar(32), P_DelDate DateTime, P_KZValue $Float, P_PoundIdx int not null default((0)))';
  {-----------------------------------------------------------------------------
   ������¼: Materails
   *.P_ID: ���
   *.P_Type: ����(����,��Ӧ,��ʱ)
   *.P_Order: ������(��Ӧ)
   *.P_Bill: ������
   *.P_Truck: ����
   *.P_CusID: �ͻ���
   *.P_CusName: ������
   *.P_MID: ���Ϻ�
   *.P_MName: ������
   *.P_MType: ��,ɢ��
   *.P_LimValue: Ʊ��
   *.P_PValue,P_PDate,P_PMan: Ƥ��
   *.P_MValue,P_MDate,P_MMan: ë��
   *.P_FactID: �������
   *.P_PStation,P_MStation: ���ذ�վ
   *.P_Direction: ��������(��,��)
   *.P_PModel: ����ģʽ(��׼,��Ե�)
   *.P_Status: ��¼״̬
   *.P_Valid: �Ƿ���Ч
   *.P_PrintNum: ��ӡ����
   *.P_DelMan,P_DelDate: ɾ����¼
   *.P_KZValue: ��Ӧ����
   *.P_OrderBak: ������(��Ӧ)����
   *.P_BDAX: 0�ϴ�ʧ��1�ϴ��ɹ�
   *.p_BDNUM: �ϴ�����
   *.p_PoundIdx: ���ϳ���˳��
  -----------------------------------------------------------------------------}

  sSQL_NewPicture = 'Create Table $Table(R_ID $Inc, P_ID varChar(15),' +
       'P_Name varChar(32), P_Mate varChar(80), P_Date DateTime, P_Picture Image)';
  {-----------------------------------------------------------------------------
   ͼƬ: Picture
   *.P_ID: ���
   *.P_Name: ����
   *.P_Mate: ����
   *.P_Date: ʱ��
   *.P_Picture: ͼƬ
  -----------------------------------------------------------------------------}

  sSQL_NewPoundDaiWC = 'Create Table $Table(R_ID $Inc,' +
       'P_DaiWuChaZ $Float, P_DaiWuChaF $Float, P_Start $Float, P_End $Float,' +
       'P_Percent Char(1), P_Station varChar(32))';
  {-----------------------------------------------------------------------------
   ��װ��Χ: PoundDaiWuCha
   *.P_DaiWuChaZ: �����
   *.P_DaiWuChaF: �����
   *.P_Start: ��ʼ��Χ
   *.P_End: ������Χ
   *.P_Percent: �������������(Y����;��������)
   *.P_Station: ��վ���
  -----------------------------------------------------------------------------}

  sSQL_NewZTLines = 'Create Table $Table(R_ID $Inc, Z_ID varChar(15),' +
       'Z_Name varChar(32), Z_StockNo varChar(20), Z_Stock varChar(80),' +
       'Z_StockType Char(1), Z_PeerWeight Integer,' +
       'Z_QueueMax Integer, Z_VIPLine Char(1), Z_Valid Char(1), Z_Index Integer)';
  {-----------------------------------------------------------------------------
   װ��������: ZTLines
   *.R_ID: ��¼��
   *.Z_ID: ���
   *.Z_Name: ����
   *.Z_StockNo: Ʒ�ֱ��
   *.Z_Stock: Ʒ��
   *.Z_StockType: ����(��,ɢ)
   *.Z_PeerWeight: ����
   *.Z_QueueMax: ���д�С
   *.Z_VIPLine: VIPͨ��
   *.Z_Valid: �Ƿ���Ч
   *.Z_Index: ˳������
  -----------------------------------------------------------------------------}

  sSQL_NewZTTrucks = 'Create Table $Table(R_ID $Inc, T_Truck varChar(15),' +
       'T_StockNo varChar(20), T_Stock varChar(80), T_Type Char(1),' +
       'T_Line varChar(15), T_Index Integer, ' +
       'T_InTime DateTime, T_InFact DateTime, T_InQueue DateTime,' +
       'T_InLade DateTime, T_VIP Char(1), T_Valid Char(1), T_Bill varChar(15),' +
       'T_Value $Float, T_PeerWeight $Float, T_Total Integer Default 0,' +
       'T_Normal Integer Default 0, T_BuCha Integer Default 0,' +
       'T_PDate DateTime, T_IsPound Char(1),T_HKBills varChar(200))';
  {-----------------------------------------------------------------------------
   ��װ������: ZTTrucks
   *.R_ID: ��¼��
   *.T_Truck: ���ƺ�
   *.T_StockNo: Ʒ�ֱ��
   *.T_Stock: Ʒ������
   *.T_Type: Ʒ������(D,S)
   *.T_Line: ���ڵ�
   *.T_Index: ˳������
   *.T_InTime: ���ʱ��
   *.T_InFact: ����ʱ��
   *.T_InQueue: ����ʱ��
   *.T_InLade: ���ʱ��
   *.T_VIP: ��Ȩ
   *.T_Bill: �ᵥ��
   *.T_Valid: �Ƿ���Ч
   *.T_Value: �����
   *.T_PeerWeight: ����
   *.T_Total: ��װ����
   *.T_Normal: ��������
   *.T_BuCha: �������
   *.T_PDate: ����ʱ��
   *.T_IsPound: �����(Y/N)
   *.T_HKBills: �Ͽ��������б�
  -----------------------------------------------------------------------------}

  sSQL_NewDataTemp = 'Create Table $Table(T_SysID varChar(15))';
  {-----------------------------------------------------------------------------
   ��ʱ���ݱ�: DataTemp
   *.T_SysID: ϵͳ���
  -----------------------------------------------------------------------------}

  sSQL_NewProvider = 'Create Table $Table(R_ID $Inc, P_ID varChar(32),' +
       'P_Name varChar(80),P_PY varChar(80), P_Phone varChar(20),' +
       'P_Saler varChar(32),P_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   ��Ӧ��: Provider
   *.P_ID: ���
   *.P_Name: ����
   *.P_PY: ƴ����д
   *.P_Phone: ��ϵ��ʽ
   *.P_Saler: ҵ��Ա
   *.P_Memo: ��ע
  -----------------------------------------------------------------------------}

  sSQL_NewMaterails = 'Create Table $Table(R_ID $Inc, M_ID varChar(32),' +
       'M_Name varChar(80),M_PY varChar(80),M_Unit varChar(20),M_Price $Float,' +
       'M_PrePValue Char(1), M_PrePTime Integer, M_Memo varChar(50), ' +
       'M_IsSale Char(1) Default ''N'')';
  {-----------------------------------------------------------------------------
   ���ϱ�: Materails
   *.M_ID: ���
   *.M_Name: ����
   *.M_PY: ƴ����д
   *.M_Unit: ��λ
   *.M_PrePValue: Ԥ��Ƥ��
   *.M_PrePTime: Ƥ��ʱ��(��)
   *.M_Memo: ��ע
   *.M_IsSale: ����Ʒ��
  -----------------------------------------------------------------------------}

  sSQL_NewStockParam = 'Create Table $Table(P_ID varChar(15), P_Stock varChar(50),' +
       'P_Type Char(1), P_Name varChar(50), P_QLevel varChar(20), P_Memo varChar(50),' +
       'P_MgO varChar(20), P_SO3 varChar(20), P_ShaoShi varChar(20),' +
       'P_CL varChar(20), P_BiBiao varChar(20), P_ChuNing varChar(20),' +
       'P_ZhongNing varChar(20), P_AnDing varChar(20), P_XiDu varChar(20),' +
       'P_Jian varChar(20), P_ChouDu varChar(20), P_BuRong varChar(20),' +
       'P_YLiGai varChar(20), P_Water varChar(20), P_KuangWu varChar(20),' +
       'P_GaiGui varChar(20), P_3DZhe varChar(20), P_28Zhe varChar(20),' +
       'P_3DYa varChar(20), P_28Ya varChar(20))';
  {-----------------------------------------------------------------------------
   Ʒ�ֲ���:StockParam
   *.P_ID:��¼���
   *.P_Stock:Ʒ��
   *.P_Type:����(��,ɢ)
   *.P_Name:�ȼ���
   *.P_QLevel:ǿ�ȵȼ�
   *.P_Memo:��ע
   *.P_MgO:����þ
   *.P_SO3:��������
   *.P_ShaoShi:��ʧ��
   *.P_CL:������
   *.P_BiBiao:�ȱ����
   *.P_ChuNing:����ʱ��
   *.P_ZhongNing:����ʱ��
   *.P_AnDing:������
   *.P_XiDu:ϸ��
   *.P_Jian:���
   *.P_ChouDu:����
   *.P_BuRong:������
   *.P_YLiGai:�����
   *.P_Water:��ˮ��
   *.P_KuangWu:�����ο���
   *.P_GaiGui:�ƹ��
   *.P_3DZhe:3�쿹��ǿ��
   *.P_28DZhe:28����ǿ��
   *.P_3DYa:3�쿹ѹǿ��
   *.P_28DYa:28��ѹǿ��
  -----------------------------------------------------------------------------}

  sSQL_NewStockRecord = 'Create Table $Table(R_ID $Inc, R_SerialNo varChar(15),' +
       'R_PID varChar(15),' +
       'R_SGType varChar(20), R_SGValue varChar(20),' +
       'R_HHCType varChar(20), R_HHCValue varChar(20),' +
       'R_MgO varChar(20), R_SO3 varChar(20), R_ShaoShi varChar(20),' +
       'R_CL varChar(20), R_BiBiao varChar(20), R_ChuNing varChar(20),' +
       'R_ZhongNing varChar(20), R_AnDing varChar(20), R_XiDu varChar(20),' +
       'R_Jian varChar(20), R_ChouDu varChar(20), R_BuRong varChar(20),' +
       'R_YLiGai varChar(20), R_Water varChar(20), R_KuangWu varChar(20),' +
       'R_GaiGui varChar(20),' +
       'R_3DZhe1 varChar(20), R_3DZhe2 varChar(20), R_3DZhe3 varChar(20),' +
       'R_28Zhe1 varChar(20), R_28Zhe2 varChar(20), R_28Zhe3 varChar(20),' +
       'R_3DYa1 varChar(20), R_3DYa2 varChar(20), R_3DYa3 varChar(20),' +
       'R_3DYa4 varChar(20), R_3DYa5 varChar(20), R_3DYa6 varChar(20),' +
       'R_28Ya1 varChar(20), R_28Ya2 varChar(20), R_28Ya3 varChar(20),' +
       'R_28Ya4 varChar(20), R_28Ya5 varChar(20), R_28Ya6 varChar(20),' +
       'R_Date DateTime, R_Man varChar(32), R_Valid Char(1) Default ''Y'')';
  {-----------------------------------------------------------------------------
   �����¼:StockRecord
   *.R_ID:��¼���
   *.R_SerialNo:ˮ����
   *.R_PID:Ʒ�ֲ���
   *.R_SGType: ʯ������
   *.R_SGValue: ʯ�������
   *.R_HHCType: ��ϲ�����
   *.R_HHCValue: ��ϲĲ�����
   *.R_MgO:����þ
   *.R_SO3:��������
   *.R_ShaoShi:��ʧ��
   *.R_CL:������
   *.R_BiBiao:�ȱ����
   *.R_ChuNing:����ʱ��
   *.R_ZhongNing:����ʱ��
   *.R_AnDing:������
   *.R_XiDu:ϸ��
   *.R_Jian:���
   *.R_ChouDu:����
   *.R_BuRong:������
   *.R_YLiGai:�����
   *.R_Water:��ˮ��
   *.R_KuangWu:�����ο���
   *.R_GaiGui:�ƹ��
   *.R_3DZhe1:3�쿹��ǿ��1
   *.R_3DZhe2:3�쿹��ǿ��2
   *.R_3DZhe3:3�쿹��ǿ��3
   *.R_28Zhe1:28����ǿ��1
   *.R_28Zhe2:28����ǿ��2
   *.R_28Zhe3:28����ǿ��3
   *.R_3DYa1:3�쿹ѹǿ��1
   *.R_3DYa2:3�쿹ѹǿ��2
   *.R_3DYa3:3�쿹ѹǿ��3
   *.R_3DYa4:3�쿹ѹǿ��4
   *.R_3DYa5:3�쿹ѹǿ��5
   *.R_3DYa6:3�쿹ѹǿ��6
   *.R_28Ya1:28��ѹǿ��1
   *.R_28Ya2:28��ѹǿ��2
   *.R_28Ya3:28��ѹǿ��3
   *.R_28Ya4:28��ѹǿ��4
   *.R_28Ya5:28��ѹǿ��5
   *.R_28Ya6:28��ѹǿ��6
   *.R_Date:ȡ������
   *.R_Man:¼����
  -----------------------------------------------------------------------------}

  sSQL_NewStockHuaYan = 'Create Table $Table(H_ID $Inc, H_No varChar(15),' +
       'H_Custom varChar(15), H_CusName varChar(80), H_SerialNo varChar(15),' +
       'H_Truck varChar(15), H_Value $Float,' +
       'H_Bill varchar(20), H_BillDate DateTime,' +
       'H_EachTruck Char(1), H_ReportDate DateTime, H_Reporter varChar(32))';
  {-----------------------------------------------------------------------------
   �����鵥:StockHuaYan
   *.H_ID:��¼���
   *.H_No:���鵥��
   *.H_Custom:�ͻ����
   *.H_CusName:�ͻ�����
   *.H_SerialNo:ˮ����
   *.H_Truck:�������
   *.H_Value:�����
   *.H_Bill:�������
   *.H_BillDate:�������
   *.H_EachTruck: �泵����
   *.H_ReportDate:��������
   *.H_Reporter:������
  -----------------------------------------------------------------------------}

  sSQL_NewStockBatcode = 'Create Table $Table(R_ID $Inc, B_Stock varChar(32),' +
       'B_Name varChar(80), B_Prefix varChar(5), B_UseYear Char(1),' +
       'B_Base Integer, B_Incement Integer, B_Length Integer, ' +
       'B_Value $Float, B_Low $Float, B_High $Float, B_Interval Integer,' +
       'B_AutoNew Char(1), B_UseDate Char(1), B_FirstDate DateTime,' +
       'B_LastDate DateTime, B_HasUse $Float Default 0, B_Batcode varChar(32))';
  {-----------------------------------------------------------------------------
   ���α����: Batcode
   *.R_ID: ���
   *.B_Stock: ���Ϻ�
   *.B_Name: ������
   *.B_Prefix: ǰ׺
   *.B_UseYear: ǰ׺�����λ��
   *.B_Base: ��ʼ����(����)
   *.B_Incement: �������
   *.B_Length: ��ų���
   *.B_Value:�����
   *.B_Low,B_High:������(%)
   *.B_Interval: �������(��)
   *.B_AutoNew: Ԫ������(Y/N)
   *.B_UseDate: ʹ�����ڱ���
   *.B_FirstDate: �״�ʹ��ʱ��
   *.B_LastDate: �ϴλ�������ʱ��
   *.B_HasUse: ��ʹ��
   *.B_Batcode: ��ǰ���κ�
  -----------------------------------------------------------------------------}

  sSQL_NewBatRecord = 'Create Table $Table(R_ID $Inc, R_Batcode varChar(32),' +
       'R_Stock varChar(32), R_Name varChar(80),' +
       'R_Value $Float, R_Used $Float,' +
       'R_FirstDate DateTime, R_LastDate DateTime)';
  {-----------------------------------------------------------------------------
   ���μ�¼��: BatcodeRecord
   *.R_ID: ���
   *.R_Batcode: ���κ�
   *.R_Stock: ���Ϻ�
   *.R_Name: ������
   *.R_Value: �����
   *.R_Used: ʹ����
   *.R_FirstDate: ����ʱ��
   *.R_LastDate: ���ʱ��
  -----------------------------------------------------------------------------}

//------------------------------------------------------------------------------
// ���ݲ�ѯ
//------------------------------------------------------------------------------
  sQuery_SysDict = 'Select D_ID, D_Value, D_Memo, D_ParamA, ' +
         'D_ParamB From $Table Where D_Name=''$Name'' Order By D_Index ASC';
  {-----------------------------------------------------------------------------
   �������ֵ��ȡ����
   *.$Table:�����ֵ��
   *.$Name:�ֵ�������
  -----------------------------------------------------------------------------}

  sQuery_ExtInfo = 'Select I_ID, I_Item, I_Info From $Table Where ' +
         'I_Group=''$Group'' and I_ItemID=''$ID'' Order By I_Index Desc';
  {-----------------------------------------------------------------------------
   ����չ��Ϣ����ȡ����
   *.$Table:��չ��Ϣ��
   *.$Group:��������
   *.$ID:��Ϣ��ʶ
  -----------------------------------------------------------------------------}

  sSQL_NewOrderBase = 'Create Table $Table(R_ID $Inc, B_ID varChar(20),' +
       'B_Value $Float, B_SentValue $Float,B_RestValue $Float,' +
       'B_LimValue $Float, B_WarnValue $Float,B_FreezeValue $Float,' +
       'B_BStatus Char(1),B_Area varChar(50), B_Project varChar(100),' +
       'B_ProID varChar(32), B_ProName varChar(80), B_ProPY varChar(80),' +
       'B_SaleID varChar(32), B_SaleMan varChar(80), B_SalePY varChar(80),' +
       'B_StockType Char(1), B_StockNo varChar(32), B_StockName varChar(80),' +
       'B_Man varChar(32), B_Date DateTime, DATAAREAID varChar(3),' +
       'B_DelMan varChar(32), B_DelDate DateTime, B_Memo varChar(500),'+
       'B_RecID bigint not null default ((0)), B_Blocked int not null default((0)))';
  {-----------------------------------------------------------------------------
   �ɹ����뵥��: Order
   *.R_ID: ���
   *.B_ID: �ᵥ��
   *.B_Value,B_SentValue,B_RestValue:���������ѷ�����ʣ����
   *.B_LimValue,B_WarnValue,B_FreezeValue:������������;����Ԥ����,����������
   *.B_BStatus: ����״̬
   *.B_Area,B_Project: ����,��Ŀ
   *.B_ProID,B_ProName,B_ProPY:��Ӧ��
   *.B_SaleID,B_SaleMan,B_SalePY:ҵ��Ա
   *.B_StockType: ����(��,ɢ)
   *.B_StockNo: ԭ���ϱ��
   *.B_StockName: ԭ��������
   *.B_Man:������
   *.B_Date:����ʱ��
   *.B_DelMan: �ɹ����뵥ɾ����Ա
   *.B_DelDate: �ɹ����뵥ɾ��ʱ��
   *.B_Memo: ������ע
   *.B_RecID: �б���
   *.B_Blocked: ��ֹͣ
   *.DATAAREAID������
  -----------------------------------------------------------------------------}

    sSQL_NewOrder = 'Create Table $Table(R_ID $Inc, O_ID varChar(20),' +
       'O_BID varChar(20),O_Card varChar(16), O_CType varChar(1),' +
       'O_Value $Float,O_OppositeValue $Float,O_Area varChar(50), O_Project varChar(100),' +
       'O_ProID varChar(32), O_ProName varChar(80), O_ProPY varChar(80),' +
       'O_SaleID varChar(32), O_SaleMan varChar(80), O_SalePY varChar(80),' +
       'O_Type Char(1), O_StockNo varChar(32), O_StockName varChar(80),' +
       'O_Truck varChar(15), O_OStatus Char(1),' +
       'O_Man varChar(32), O_Date DateTime, O_PrintBD Char(1) Default ''N'',' +
       'O_DelMan varChar(32), O_DelDate DateTime, O_Memo varChar(500),'+
       'O_BRecID bigint not null default ((0)),O_IfNeiDao Char(1),'+
       'O_Model varChar(15),O_KD varChar(100),'+
       'O_YSTDno varchar(32),O_expiretime DateTime,O_Ship varChar(32))';
  {-----------------------------------------------------------------------------
   �ɹ�������: Order
   *.R_ID: ���
   *.O_ID: �ᵥ��
   *.O_BID: �ɹ����뵥�ݺ�
   *.O_Card,O_CType: �ſ���,�ſ�����(L����ʱ��;G���̶���)
   *.O_Value:��������
   *.O_OppositeValue:�Է�������
   *.O_OStatus: ����״̬
   *.O_Area,O_Project: ����,��Ŀ
   *.O_ProID,O_ProName,O_ProPY:��Ӧ��
   *.O_SaleID,O_SaleMan:ҵ��Ա
   *.O_Type: ����(��,ɢ)
   *.O_StockNo: ԭ���ϱ��
   *.O_StockName: ԭ��������
   *.O_Truck: ������
   *.O_Man:������
   *.O_Date:����ʱ��
   *.O_DelMan: �ɹ���ɾ����Ա
   *.O_DelDate: �ɹ���ɾ��ʱ��
   *.O_Memo: ������ע
   *.O_BRecID: �б���
   *.O_IfNeiDao: �ڵ���Y: ��  N: ��
   *.O_YSTDno:����ͨ����
   *.O_expiretime:����ʱ�䣨��Գ��ڿ���Ч��
   *.O_Ship:��ͷ����
   *.O_PrintBD:��ӡ����
   *.O_Model:�ͺ�
   *.O_KD:���
  -----------------------------------------------------------------------------}

  sSQL_NewOrderDtl = 'Create Table $Table(R_ID $Inc, D_ID varChar(20),' +
       'D_OID varChar(20), D_PID varChar(20), D_Card varChar(16), ' +
       'D_Area varChar(50), D_Project varChar(100),D_Truck varChar(15), ' +
       'D_ProID varChar(32), D_ProName varChar(80), D_ProPY varChar(80),' +
       'D_SaleID varChar(32), D_SaleMan varChar(80), D_SalePY varChar(80),' +
       'D_Type Char(1), D_StockNo varChar(32), D_StockName varChar(80),' +
       'D_DStatus Char(1), D_Status Char(1), D_NextStatus Char(1),' +
       'D_InTime DateTime, D_InMan varChar(32),' +
       'D_PValue $Float, D_PDate DateTime, D_PMan varChar(32),' +
       'D_MValue $Float, D_MDate DateTime, D_MMan varChar(32),' +
       'D_YTime DateTime, D_YMan varChar(32), ' +
       'D_Value $Float,D_KZValue $Float, D_AKValue $Float,' +
       'D_YLine varChar(15), D_YLineName varChar(32), ' +
       'D_DelMan varChar(32), D_DelDate DateTime, D_YSResult Char(1), ' +
       'D_OutFact DateTime, D_OutMan varChar(32), D_Memo varChar(500),'+
       'D_BDAX Char(1) not null default((0)),D_BDNUM int not null default((0)),'+
       'D_RecID bigint not null default ((0)))';
  {-----------------------------------------------------------------------------
   �ɹ�������ϸ��: OrderDetail
   *.R_ID: ���
   *.D_ID: �ɹ���ϸ��
   *.D_OID: �ɹ�����
   *.D_PID: ������
   *.D_Card: �ɹ��ſ���
   *.D_DStatus: ����״̬
   *.D_Area,D_Project: ����,��Ŀ
   *.D_ProID,D_ProName,D_ProPY:��Ӧ��
   *.D_SaleID,D_SaleMan:ҵ��Ա
   *.D_Type: ����(��,ɢ)
   *.D_StockNo: ԭ���ϱ��
   *.D_StockName: ԭ��������
   *.D_Truck: ������
   *.D_Status,D_NextStatus: ״̬
   *.D_InTime,D_InMan: ��������
   *.D_PValue,D_PDate,D_PMan: ��Ƥ��
   *.D_MValue,D_MDate,D_MMan: ��ë��
   *.D_YTime,D_YMan: �ջ�ʱ��,������,
   *.D_Value,D_KZValue,D_AKValue: �ջ���,���տ۳�(����),����
   *.D_YLine,D_YLineName: �ջ�ͨ��
   *.D_YSResult: ���ս��
   *.D_OutFact,D_OutMan: ��������
   *.D_BDAX: �Ƿ��ϴ�
   *.D_BDNUM: �ϴ�����
   *.D_RecID: �����б���
  -----------------------------------------------------------------------------}

  sSQL_NewCardOther = 'Create Table $Table(R_ID $Inc, O_Card varChar(16),' +
       'O_Truck varChar(15), O_CusID varChar(32), O_CusName varChar(800),' +
       'O_MID varChar(32), O_MName varChar(800), ' +
       'O_MType varChar(10), O_LimVal $Float, ' +
       'O_Status Char(1), O_NextStatus Char(1),' +
       'O_InTime DateTime, O_InMan varChar(32),' +
       'O_OutTime DateTime, O_OutMan varChar(32),' +
       'O_BFPTime DateTime, O_BFPMan varChar(32), O_BFPValue $Float Default 0,' +
       'O_BFMTime DateTime, O_BFMMan varChar(32), O_BFMValue $Float Default 0,' +
       'O_KeepCard varChar(1), O_Man varChar(32), O_Date DateTime,' +
       'O_UsePValue Char(1) Default ''N'', O_OneDoor Char(1) Default ''N'', ' +
       'O_PoundIdx int not null default((1)), O_RevName varChar(32), ' +
       'O_CusNameUse varChar(800), O_MNameUse varChar(800), ' +
       'O_ManDel varChar(32), O_DateDel DateTime,O_YSTDno varchar(32))';
  {-----------------------------------------------------------------------------
   ��ʱ�ſ�:CardOther
   *.R_ID:��¼���
   *.O_Card:����
   *.O_Truck: ����
   *.O_CusID,O_CusName:��Ӧ��
   *.O_MID,O_MName:����
   *.O_MType:��,ɢ��
   *.O_LimVal:Ʊ��
   *.O_Status,O_NextStatus: �г�״̬
   *.O_InTime,O_InMan:����ʱ��,������
   *.O_OutTime,O_OutMan:����ʱ��,������
   *.O_BFPTime,O_BFPMan,O_BFPValue:Ƥ��ʱ��,������,Ƥ��
   *.O_BFMTime,O_BFMMan,O_BFMValue:ë��ʱ��,������,ë��
   *.O_KeepCard: ˾����(Y/N),����ʱ������
   *.O_Man,O_Date:�ƿ���
   *.O_UsePValue: �Կճ�ΪƤ��
   *.O_OneDoor: �������
   *.O_ManDel,O_DateDel: ɾ����
   *.O_YSTDno: ����ͨ�����
   *.O_PoundIdx: ����˳��
   *.O_RevName: ���ϵ�λ
   *.O_MNameUse: ���ϸ�ʽ
   *.O_CusNameUse �ͻ���ʽ
  -----------------------------------------------------------------------------}

  sSQL_NewOrdBaseMain = 'Create Table $Table(R_ID $Inc, M_ID varChar(20),' +
       'M_CID varChar(50), M_BStatus Char(1), ' +
       'M_ProID varChar(32), M_ProName varChar(80), M_ProPY varChar(80),' +
       'M_TriangleTrade Char(1), M_IntComOriSalesId varChar(20), M_PurchType Char(1),' +
       'M_Man varChar(32), M_Date DateTime, ' +
       'M_DelMan varChar(32), M_DelDate DateTime, M_Memo varChar(500),'+
       'DATAAREAID varChar(3),M_DState varChar(10))';
  {-----------------------------------------------------------------------------
   �ɹ����뵥����: OrderBaseMain
   *.R_ID: ���
   *.M_ID: ���뵥��
   *.M_CID: ��ͬ��
   *.M_BStatus: ����״̬
   *.M_ProID,M_ProName,M_ProPY:��Ӧ��
   *.M_TriangleTrade: ����ó��
   *.M_IntComOriSalesId�����۶����ţ��ڲ��ɹ�������ó��ʹ�ã�
   *.M_PurchType: �ɹ�����
   *.M_Man:������
   *.M_Date:����ʱ��
   *.M_DelMan: �ɹ����뵥ɾ����Ա
   *.M_DelDate: �ɹ����뵥ɾ��ʱ��
   *.M_Memo: ������ע
   *.DATAAREAID������
   *.M_DState: ���״̬(30,40��Ч) 0  �ݸ� 10 ������� 20 �Ѿܾ�  30 ����׼ 35 ���ڽ����ⲿ��� 50 ���� 40 ��ȷ��
  -----------------------------------------------------------------------------}

  sSQL_NewWebOrderMatch = 'Create Table $Table(R_ID $Inc,'
      +'WOM_WebOrderID varchar(32) null,'
      +'WOM_LID varchar(20) null,'
      +'WOM_StatusType Integer,'
      +'WOM_MsgType Integer,'
      +'WOM_BillType char(1),'
      +'WOM_SyncNum Integer default 0,'
      +'WOM_deleted char(1) default ''N'')';
  {-----------------------------------------------------------------------------
   �̳Ƕ�������������ձ�: WebOrderMatch
   *.R_ID: ��¼���
   *.WOM_WebOrderID: �̳Ƕ���
   *.WOM_LID: �����
   *.WOM_StatusType: ����״̬ 0.����  1.���
   *.WOM_MsgType: ��Ϣ���� ����  ����  ���� ɾ��
   *.WOM_SyncNum: ���ʹ���
   *.WOM_BillType: ҵ������  �ɹ� ����
  -----------------------------------------------------------------------------}

  sSQL_NewHHJYURL = 'Create Table $Table(R_ID $Inc,'
      +'U_CID varchar(20) null,'
      +'U_Url varchar(100) null,'
      +'U_Password varchar(30) null,'
      +'U_DefWhere varchar(200) null)';
  {-----------------------------------------------------------------------------
   ��Ӿ�Զ�ӿڵ�ַ��:
   *.R_ID: ��¼���
   *.U_CID: ������
   *.U_Url: ��ַ
   *.U_Password: ����
   *.U_DefWhere: ȱʡ����
  -----------------------------------------------------------------------------}

  sSQL_NewHHJYSync = 'Create Table $Table(R_ID $Inc,'
      +'H_ID varchar(20) null,'
      +'H_Order varchar(20) null,'
      +'H_Status Integer,'
      +'H_SyncNum Integer default 0,'
      +'H_BillType char(1),'
      +'H_PurType varchar(5),'
      +'H_Deleted char(1) default ''N'')';
  {-----------------------------------------------------------------------------
   ����ͬ����:
   *.R_ID: ��¼���
   *.H_ID: ���ݺ�
   *.H_Order: ������
   *.H_Status: ����״̬ 0.����  1.���
   *.H_SyncNum: ���ʹ���
   *.H_BillType: ҵ������  �ɹ� ����
   *.H_PurType: �ɹ��������� ��ͨ �ڵ� ��ʱ
  -----------------------------------------------------------------------------}

  sSQL_NewXzInfo = 'Create Table $Table(R_ID $Inc, X_CusID varChar(32),' +
       'X_CusName varChar(150), X_XzValue $Float Default 0, X_BeginTime varChar(10),' +
       'X_EndTime varChar(10), X_Valid char(1) default ''Y'', X_Memo varchar(200))';
  {-----------------------------------------------------------------------------
   ������Ϣ��: BaseInfo
   *.R_ID: ���
   *.X_CusID: �ͻ����
   *.X_CusName: �ͻ�����
   *.X_XzValue: �����趨
   *.X_BeginTime: ��ʼʱ��
   *.X_EndTime: ����ʱ��
   *.X_Valid: �Ƿ���Ч
   *.X_Memo: ��ע
  -----------------------------------------------------------------------------}

function CardStatusToStr(const nStatus: string): string;
//�ſ�״̬
function TruckStatusToStr(const nStatus: string): string;
//����״̬
function BillTypeToStr(const nType: string): string;
//��������
function PostTypeToStr(const nPost: string): string;
//��λ����

implementation

//Desc: ��nStatusתΪ�ɶ�����
function CardStatusToStr(const nStatus: string): string;
begin
  if nStatus = sFlag_CardIdle then Result := '����' else
  if nStatus = sFlag_CardUsed then Result := '����' else
  if nStatus = sFlag_CardLoss then Result := '��ʧ' else
  if nStatus = sFlag_CardInvalid then Result := 'ע��' else Result := 'δ֪';
end;

//Desc: ��nStatusתΪ��ʶ�������
function TruckStatusToStr(const nStatus: string): string;
begin
  if nStatus = sFlag_TruckIn then Result := '����' else
  if nStatus = sFlag_TruckOut then Result := '����' else
  if nStatus = sFlag_TruckBFP then Result := '��Ƥ��' else
  if nStatus = sFlag_TruckBFM then Result := '��ë��' else
  if nStatus = sFlag_TruckSH then Result := '�ͻ���' else
  if nStatus = sFlag_TruckXH then Result := '���մ�' else
  if nStatus = sFlag_TruckFH then Result := '�ŻҴ�' else
  if nStatus = sFlag_TruckZT then Result := 'ջ̨' else Result := 'δ����';
end;

//Desc: ����������תΪ��ʶ������
function BillTypeToStr(const nType: string): string;
begin
  if nType = sFlag_TypeShip then Result := '����' else
  if nType = sFlag_TypeZT   then Result := 'ջ̨' else
  if nType = sFlag_TypeVIP  then Result := 'VIP' else Result := '��ͨ';
end;

//Desc: ����λתΪ��ʶ������
function PostTypeToStr(const nPost: string): string;
begin
  if nPost = sFlag_TruckIn   then Result := '��������' else
  if nPost = sFlag_TruckOut  then Result := '��������' else
  if nPost = sFlag_TruckBFP  then Result := '������Ƥ' else
  if nPost = sFlag_TruckBFM  then Result := '��������' else
  if nPost = sFlag_TruckFH   then Result := 'ɢװ�Ż�' else
  if nPost = sFlag_TruckZT   then Result := '��װջ̨' else Result := '����';
end;

//------------------------------------------------------------------------------
//Desc: ����ϵͳ����
procedure AddSysTableItem(const nTable,nNewSQL: string);
var nP: PSysTableItem;
begin
  New(nP);
  gSysTableList.Add(nP);

  nP.FTable := nTable;
  nP.FNewSQL := nNewSQL;
end;

//Desc: ϵͳ��
procedure InitSysTableList;
begin
  gSysTableList := TList.Create;

  AddSysTableItem(sTable_SysDict, sSQL_NewSysDict);
  AddSysTableItem(sTable_ExtInfo, sSQL_NewExtInfo);
  AddSysTableItem(sTable_SysLog, sSQL_NewSysLog);

  AddSysTableItem(sTable_BaseInfo, sSQL_NewBaseInfo);
  AddSysTableItem(sTable_SerialBase, sSQL_NewSerialBase);
  AddSysTableItem(sTable_SerialStatus, sSQL_NewSerialStatus);
  AddSysTableItem(sTable_StockMatch, sSQL_NewStockMatch);
  AddSysTableItem(sTable_WorkePC, sSQL_NewWorkePC);
  AddSysTableItem(sTable_ManualEvent, sSQL_NewManualEvent);
  AddSysTableItem(sTable_DataTemp, sSQL_NewDataTemp);

  AddSysTableItem(sTable_Customer, sSQL_NewCustomer);
  AddSysTableItem(sTable_Salesman, sSQL_NewSalesMan);
  AddSysTableItem(sTable_SalesOrder, sSQL_NewSalesOrder);
  AddSysTableItem(sTable_Bill, sSQL_NewBill);
  AddSysTableItem(sTable_BillBak, sSQL_NewBill);
  AddSysTableItem(sTable_Card, sSQL_NewCard);

  AddSysTableItem(sTable_Truck, sSQL_NewTruck);
  AddSysTableItem(sTable_Unloading, sSQL_NewUploading);
  AddSysTableItem(sTable_ZTLines, sSQL_NewZTLines);
  AddSysTableItem(sTable_ZTTrucks, sSQL_NewZTTrucks);
  AddSysTableItem(sTable_PoundLog, sSQL_NewPoundLog);
  AddSysTableItem(sTable_PoundBak, sSQL_NewPoundLog);
  AddSysTableItem(sTable_Picture, sSQL_NewPicture);
  AddSysTableItem(sTable_PoundDaiWC, sSQL_NewPoundDaiWC);
  AddSysTableItem(sTable_Provider, sSQL_NewProvider);
  AddSysTableItem(sTable_Materails, sSQL_NewMaterails);

  AddSysTableItem(sTable_StockParam, sSQL_NewStockParam);
  AddSysTableItem(sTable_StockParamExt, sSQL_NewStockRecord);
  AddSysTableItem(sTable_StockRecord, sSQL_NewStockRecord);
  AddSysTableItem(sTable_StockHuaYan, sSQL_NewStockHuaYan);
  AddSysTableItem(sTable_StockBatcode, sSQL_NewStockBatcode);
  AddSysTableItem(sTable_BatRecord, sSQL_NewBatRecord);

  AddSysTableItem(sTable_Order, sSQL_NewOrder);
  AddSysTableItem(sTable_OrderBak, sSQL_NewOrder);
  AddSysTableItem(sTable_OrderDtl, sSQL_NewOrderDtl);
  AddSysTableItem(sTable_OrderDtlBak, sSQL_NewOrderDtl);
  AddSysTableItem(sTable_OrderBase, sSQL_NewOrderBase);
  AddSysTableItem(sTable_CardOther, sSQL_NewCardOther);
  AddSysTableItem(sTable_OrderBaseMain, sSQL_NewOrdBaseMain);

  AddSysTableItem(sTable_WebOrderMatch,sSQL_NewWebOrderMatch);

  AddSysTableItem(sTable_HHJYUrl,sSQL_NewHHJYURL);
  AddSysTableItem(sTable_HHJYUrlBak,sSQL_NewHHJYURL);
  AddSysTableItem(sTable_HHJYSync,sSQL_NewHHJYSync);

  AddSysTableItem(sTable_TruckXz,sSQL_NewXzInfo);
end;

//Desc: ����ϵͳ��
procedure ClearSysTableList;
var nIdx: integer;
begin
  for nIdx:= gSysTableList.Count - 1 downto 0 do
  begin
    Dispose(PSysTableItem(gSysTableList[nIdx]));
    gSysTableList.Delete(nIdx);
  end;

  FreeAndNil(gSysTableList);
end;

initialization
  InitSysTableList;
finalization
  ClearSysTableList;
end.

