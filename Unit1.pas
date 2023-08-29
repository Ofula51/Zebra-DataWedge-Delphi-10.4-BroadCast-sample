unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  BarkodOkur,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  Androidapi.JNIBridge, Androidapi.JNI.Embarcadero,Androidapi.JNI.JavaTypes,
  Androidapi.Helpers, Androidapi.JNI.GraphicsContentViewText, FMX.StdCtrls,
  FMX.Platform,  FMX.Platform.Android,
  FMX.Controls.Presentation, FMX.Memo.Types, FMX.Memo, FMX.Edit, FMX.ScrollBox;

type

  //TScannerReceiver = class(TBarcodeReceiver) end;

  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    //FScannerReceiver1:TBarcodeReceiver;
    Memo2: TMemo;
    Button2: TButton;
    procedure ScannerReceiverIntentHandler1(Sender: TObject; const AIntent: JIntent);
    procedure ScannerReceiverIntentHandler2(Sender: TObject; const AIntent: JIntent);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  FScannerReceiver1 : TBarcodeReceiver;


implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}




{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  AIntent: JIntent;
begin

  FScannerReceiver1 := TBarcodeReceiver.Create;
  FScannerReceiver1.OnIntent := ScannerReceiverIntentHandler1;

  AIntent:= TJIntent.JavaClass.init;
  AIntent.setAction(StringToJString('com.symbol.datawedge.api.ACTION_SOFTSCANTRIGGER'));
  AIntent.putExtra(StringToJString('com.symbol.datawedge.api.EXTRA_PARAMETER'), StringtoJString('START_SCANNING'));
  TAndroidHelper.Activity.sendBroadcast(AIntent);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  AIntent: JIntent;
begin

  FScannerReceiver1 := TBarcodeReceiver.Create;
  FScannerReceiver1.OnIntent := ScannerReceiverIntentHandler2;

  AIntent:= TJIntent.JavaClass.init;
  AIntent.setAction(StringToJString('com.symbol.datawedge.api.ACTION_SOFTSCANTRIGGER'));
  AIntent.putExtra(StringToJString('com.symbol.datawedge.api.EXTRA_PARAMETER'), StringtoJString('START_SCANNING'));
  TAndroidHelper.Activity.sendBroadcast(AIntent);
end;

procedure TForm1.ScannerReceiverIntentHandler1(Sender: TObject;
  const AIntent: JIntent);
var
  donen:string;
begin
  if AIntent.getAction.Equals(StringToJString('com.dwexample.ACTION')) then
  begin
    donen:= JStringToString(AIntent.getStringExtra(StringToJString('com.symbol.datawedge.data_string')));
    Memo1.Lines.Add(donen);
  end;
  FScannerReceiver1.Destroy;
end;

procedure TForm1.ScannerReceiverIntentHandler2(Sender: TObject;
  const AIntent: JIntent);
var
  donen:string;
begin
  if AIntent.getAction.Equals(StringToJString('com.dwexample.ACTION')) then
  begin
    donen:= JStringToString(AIntent.getStringExtra(StringToJString('com.symbol.datawedge.data_string')));
    Memo2.Lines.Add(donen);
  end;
  FScannerReceiver1.Destroy;
end;
end.
