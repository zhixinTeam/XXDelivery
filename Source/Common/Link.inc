//----------------------------------- ͨ�� -------------------------------------
{.$DEFINE DEBUG}
//����ģʽ

{.$DEFINE TrialVersion}
//���ð汾

{$DEFINE UseReport}
//����֧��

{.$DEFINE RandomID}
//ʹ��������

{$DEFINE cxLibrary42}
//Ver4.2���뻷��

{.$DEFINE EnableBackupDB}
//�������ݿ�֧��
{.$DEFINE EnableDoubleDB}
//˫���ݿ�֧��

//---------------------------------- �м�� ------------------------------------
{.$DEFINE ClientMon}
//�����ػ��ͻ���

{$DEFINE HardMon}
//����Ӳ���ػ�

{.$DEFINE GenRODL}
//����RODL��Դ

{$DEFINE COM_MIT}
//����ϵͳģʽ

//ͨ���м��
{$IFDEF COM_MIT}
  {$DEFINE DBPool}
  //�������ݿ�֧��
  {.$DEFINE BusLog}
  //��ӡҵ����־
  {$DEFINE ChannelPool}
  //����ͨ��֧��
  {.$DEFINE AutoChannel}
  //����ͨ��ƽ��
  {.$DEFINE SAP}
  //����SAP֧��
  {.$DEFINE ClientMon}
  //֧���ػ�����
{$ENDIF}

//--------------------------------- �ض�ϵͳ -----------------------------------
{.$DEFINE COMMON}
//ͨ�ð汾

{$DEFINE XXXX}
//�ض�ϵͳ

//�����в�
{$IFDEF AHZC}
  {$DEFINE HYRFID201}
  //�����ͷ
  {$DEFINE AppAtTaskBar}
  //״̬����ʾ
  {.$DEFINE MITTruckProber}
  //�������м������
  {$DEFINE TruckProberEx}
  //�����ж�Ex
  {$DEFINE MultiReplay}
  //������Ӧ��ģʽ
  {.$DEFINE DaiStepWuCha}
  //��װ�������
  {.$DEFINE DaiOpenBackWhenError}
  //��װ����̧���
  {$DEFINE BatchInHYOfBill}
  //���α����ڻ��鵥�ֶ�
  {$DEFINE PrintHYEach}
  //�泵�����鵥
  {$DEFINE HeGeZhengOnly}
  //�泵����ʱֻ��ϸ�֤
  {$DEFINE HeGeZhengSimpleData}
  //ʹ�ü򵥺ϸ�֤����(�޼�����)
  {$DEFINE JSTruck}
  //��ʽ������������
  {$DEFINE SyncRemote}
  //Զ��ͬ��
  {$DEFINE MicroMsg}
  //΢��
  {$DEFINE GetTruckNoFromERP}
  //��ERPί�е���ȡ����
  {$DEFINE SyncDataByDataBase}
  //ͨ���������ݿ�������ݽ���
  {$DEFINE TruckOutTimeOut}
  //����������ʱ
{$ENDIF}

//��������
{$IFDEF XXXX}
  {$DEFINE HYRFID201}
  //�����ͷ
  {$DEFINE AppAtTaskBar}
  //״̬����ʾ
  {$DEFINE MITTruckProber}
  //�������м������
  {.$DEFINE TruckProberEx}
  //�����ж�Ex
  {$DEFINE MultiReplay}
  //������Ӧ��ģʽ
  {.$DEFINE DaiStepWuCha}
  //��װ�������
  {$DEFINE DaiStepDz}
  //��װ���ݴ���
  {$DEFINE OpenBackWhenError}
  //�����쳣̧���
  {$DEFINE BatchInHYOfBill}
  //���α����ڻ��鵥�ֶ�
  {$DEFINE PrintHYEach}
  //�泵�����鵥
  {.$DEFINE HeGeZhengOnly}
  //�泵����ʱֻ��ϸ�֤
  {.$DEFINE HeGeZhengSimpleData}
  //ʹ�ü򵥺ϸ�֤����(�޼�����)
  {$DEFINE JSTruck}
  //��ʽ������������
  {$DEFINE SyncRemote}
  //Զ��ͬ��
  {$DEFINE MicroMsg}
  //΢��
  {$DEFINE GetTruckNoFromERP}
  //��ERPί�е���ȡ����
  {$DEFINE SyncDataByWSDL}
  //ͨ���ӿڽ������ݽ���
  {$DEFINE AutoTruckIn}
  //�����Զ�����
  {$DEFINE SaleOpenBackWhenError}
  //�����쳣����̧���
  {$DEFINE AICMGetTruckTunnel}
  //��������ѯ����ͨ��
  {$DEFINE FixLoad}
  //����װ��
  {$DEFINE SanLed}
  //ɢװ����С��(������)
{$ENDIF}
