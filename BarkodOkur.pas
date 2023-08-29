unit BarkodOkur;

interface
uses
  Androidapi.JNIBridge, Androidapi.JNI.JavaTypes, Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.Embarcadero;

Type
  TBarcodeReceiver = class;

  TBarcodeReceiverListener = class(TJavaLocal, JFMXBroadcastReceiverListener)
  private
    FBarcodeReceiver: TBarcodeReceiver;
  public
    { JFMXBroadcastReceiverListener }
    procedure onReceive(context: JContext; intent: JIntent); cdecl;
  public
    constructor Create(const ABarcodeReceiver: TBarcodeReceiver);
  end;

  TIntentEvent = procedure(Sender: TObject; const Intent: JIntent) of object;

  TBarcodeReceiver = class(TObject)
  private
    FBroadcastReceiver: JFMXBroadcastReceiver;
    FIntentFilter: JIntentFilter;
    FReceiverListener: TBarcodeReceiverListener;
    FOnIntent: TIntentEvent;
  protected
    procedure Receive(context: JContext; intent: JIntent); virtual;
    property IntentFilter: JIntentFilter read FIntentFilter;
  public
    constructor Create;
    destructor Destroy; override;
    property OnIntent: TIntentEvent read FOnIntent write FOnIntent;
  end;
implementation

uses
  Androidapi.Helpers;


{ TBarcodeReceiverListener }

constructor TBarcodeReceiverListener.Create(
  const ABarcodeReceiver: TBarcodeReceiver);
begin
  inherited Create;
  FBarcodeReceiver:= ABarcodeReceiver;
end;

procedure TBarcodeReceiverListener.onReceive(context: JContext;
  intent: JIntent);
begin
  FBarcodeReceiver.Receive(context,intent);
end;

{ TBarcodeReceiver }

constructor TBarcodeReceiver.Create;
begin
  inherited Create;
  FReceiverListener := TBarcodeReceiverListener.Create(Self);
  FBroadcastReceiver := TJFMXBroadcastReceiver.JavaClass.init(FReceiverListener);
  FIntentFilter := TJIntentFilter.JavaClass.init;
  FIntentFilter.addCategory(TJIntent.JavaClass.CATEGORY_DEFAULT);
  FIntentFilter.addAction(StringToJString('com.dwexample.ACTION'));
  TAndroidHelper.Context.registerReceiver(FBroadcastReceiver, FIntentFilter)

end;

destructor TBarcodeReceiver.Destroy;
begin
  TAndroidHelper.Context.unregisterReceiver(FBroadcastReceiver);
end;

procedure TBarcodeReceiver.Receive(context: JContext; intent: JIntent);
begin
  if Assigned(FOnIntent) then
    FOnIntent(Self, intent);
end;

end.
