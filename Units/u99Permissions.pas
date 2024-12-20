/////////////////////////////////////////////////////////////////////////////
{
    Unit u99Permissions
    Cria��o: 99 Coders (Heber Stein Mazutti - @99coders)
    Vers�o: 2.0
}
/////////////////////////////////////////////////////////////////////////////


unit u99Permissions;

interface

uses System.Permissions, FMX.DialogService, FMX.MediaLibrary.Actions,
     System.Types, System.SysUtils


{$IFDEF ANDROID}
,Androidapi.Helpers, Androidapi.JNI.JavaTypes, Androidapi.JNI.Os
{$ENDIF}

;

type
    TCallbackProc = procedure(Sender: TObject) of Object;

    T99Permissions = class
    private
        CurrentRequest : string;
        pCamera, pReadStorage, pWriteStorage : string; // Camera / Library
        pFineLocation, pCoarseLocation : string; // GPS
        pPhoneState : string; // Phone State
        pWakeLock : string;

        procedure PermissionRequestResult( Sender: TObject;
                    const APermissions: TClassicStringDynArray;
                    const AGrantResults: TClassicPermissionStatusDynArray);

        {$IF CompilerVersion >= 35 }
        procedure DisplayRationale(Sender: TObject;
                                  const APermissions: TClassicStringDynArray;
                                  const APostRationaleProc: TProc);
        {$ENDIF}
    public
        MyCallBack, MyCallBackError : TCallbackProc;
        MyCameraAction : TTakePhotoFromCameraAction;
        MyLibraryAction : TTakePhotoFromLibraryAction;

        constructor Create;
        function fVerifyCameraAccess(): boolean;
        procedure fCamera(ActionPhoto: TTakePhotoFromCameraAction;
                                ACallBackError: TCallbackProc = nil);
        procedure fPhotoLibrary(ActionLibrary: TTakePhotoFromLibraryAction;
                        ACallBackError: TCallbackProc = nil);
        procedure fLocation(ACallBack: TCallbackProc = nil;
                        ACallBackError: TCallbackProc = nil);
        procedure fPhoneState(ACallBack: TCallbackProc = nil;
                        ACallBackError: TCallbackProc = nil);
        function fVerifyWakeLock(): boolean;
    published

end;

implementation


function T99Permissions.fVerifyCameraAccess(): boolean;
begin
    Result := false;

    {$IFDEF ANDROID}
    Result := PermissionsService.IsEveryPermissionGranted([pCamera,
                                                           pReadStorage,
                                                           pWriteStorage]);
    {$ENDIF}
end;

constructor T99Permissions.Create();
begin
    {$IFDEF ANDROID}
    pCamera := JStringToString(TJManifest_permission.JavaClass.CAMERA);
    pReadStorage := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
    pWriteStorage := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
    pCoarseLocation := JStringToString(TJManifest_permission.JavaClass.ACCESS_COARSE_LOCATION);
    pFineLocation := JStringToString(TJManifest_permission.JavaClass.ACCESS_FINE_LOCATION);
    pPhoneState := JStringToString(TJManifest_permission.JavaClass.READ_PHONE_STATE);
    pWakeLock := JStringToString(TJManifest_permission.JavaClass.WAKE_LOCK);
    {$ENDIF}
end;

procedure T99Permissions.PermissionRequestResult( Sender: TObject;
                    const APermissions: TClassicStringDynArray;
                    const AGrantResults: TClassicPermissionStatusDynArray);
var
    ret : boolean;
begin
    ret := false;

    // CAMERA (CAMERA + READ_EXTERNAL_STORAGE + WRITE_EXTERNAL_STORAGE)
    if CurrentRequest = 'CAMERA' then
    begin
        if (Length(AGrantResults) = 3) and
           (AGrantResults[0] = TPermissionStatus.Granted) and
           (AGrantResults[1] = TPermissionStatus.Granted) and
           (AGrantResults[2] = TPermissionStatus.Granted) then
        begin
            ret := true;

            if Assigned(MyCameraAction) then
                MyCameraAction.Execute;
        end;
    end;

    // LIBRARY (READ_EXTERNAL_STORAGE + WRITE_EXTERNAL_STORAGE)
    if CurrentRequest = 'LIBRARY' then
    begin
        if (Length(AGrantResults) = 2) and
           (AGrantResults[0] = TPermissionStatus.Granted) and
           (AGrantResults[1] = TPermissionStatus.Granted) then
        begin
            ret := true;

            if Assigned(MyLibraryAction) then
                MyLibraryAction.Execute;
        end;
    end;

    // LOCATION (ACCESS_COARSE_LOCATION + ACCESS_FINE_LOCATION)
    if CurrentRequest = 'LOCATION' then
    begin
        if (Length(AGrantResults) = 2) and
           (AGrantResults[0] = TPermissionStatus.Granted) and
           (AGrantResults[1] = TPermissionStatus.Granted) then
        begin
            ret := true;

            if Assigned(MyCallBack) then
                MyCallBack(Self);
        end;
    end;

    // PHONE STATE
    if CurrentRequest = 'READ_PHONE_STATE' then
    begin
        if (Length(AGrantResults) = 1) and
           (AGrantResults[0] = TPermissionStatus.Granted) then
        begin
            ret := true;

            if Assigned(MyCallBack) then
                MyCallBack(Self);
        end;
    end;

    if NOT ret then
    begin
        if Assigned(MyCallBackError) then
            MyCallBackError(Self);
    end;
end;

{$IF CompilerVersion >= 35 }
procedure T99Permissions.DisplayRationale(Sender: TObject; const APermissions: TClassicStringDynArray; const APostRationaleProc: TProc);
begin

end;
{$ENDIF}

procedure T99Permissions.fCamera(ActionPhoto: TTakePhotoFromCameraAction;
                                ACallBackError: TCallbackProc = nil);
begin
    MyCameraAction := ActionPhoto;
    MyCallBackError := ACallBackError;
    CurrentRequest := 'CAMERA';

    {$IFDEF ANDROID}
      {$IF CompilerVersion >= 35 }
      PermissionsService.RequestPermissions([pCamera, pReadStorage, pWriteStorage],
                                             PermissionRequestResult, nil);
      {$ELSE}
      PermissionsService.RequestPermissions([pCamera, pReadStorage, pWriteStorage],
                                           PermissionRequestResult);
      {$ENDIF}
    {$ENDIF}

    {$IFDEF IOS}
    MyCameraAction.Execute;
    {$ENDIF}

    {$IFDEF MSWINDOWS}
    TDialogService.ShowMessage('N�o suportado no Windows');
    {$ENDIF}
end;

procedure T99Permissions.fPhotoLibrary(ActionLibrary: TTakePhotoFromLibraryAction;
                                      ACallBackError: TCallbackProc = nil);
begin
    MyLibraryAction := ActionLibrary;
    MyCallBackError := ACallBackError;
    CurrentRequest := 'LIBRARY';

    {$IFDEF ANDROID}
    PermissionsService.RequestPermissions([pReadStorage, pWriteStorage],
                                           PermissionRequestResult);
    {$ENDIF}

    {$IFDEF IOS}
    ActionLibrary.Execute;
    {$ENDIF}

    {$IFDEF MSWINDOWS}
    TDialogService.ShowMessage('N�o suportado no Windows');
    {$ENDIF}
end;


procedure T99Permissions.fLocation(ACallBack: TCallbackProc = nil;
                                  ACallBackError: TCallbackProc = nil);
begin
    MyCallBack := ACallBack;
    MyCallBackError := ACallBackError;
    CurrentRequest := 'LOCATION';

    {$IFDEF ANDROID}
    PermissionsService.RequestPermissions([pCoarseLocation, pFineLocation],
                                           PermissionRequestResult);
    {$ENDIF}

    {$IFDEF IOS}
    if Assigned(MyCallBack) then
        ACallBack(Self);
    {$ENDIF}

    {$IFDEF MSWINDOWS}
    TDialogService.ShowMessage('N�o suportado no Windows');
    {$ENDIF}
end;

procedure T99Permissions.fPhoneState(ACallBack: TCallbackProc = nil;
                                  ACallBackError: TCallbackProc = nil);
begin
    MyCallBack := ACallBack;
    MyCallBackError := ACallBackError;
    CurrentRequest := 'READ_PHONE_STATE';

    {$IFDEF ANDROID}
    PermissionsService.RequestPermissions([pPhoneState],
                                           PermissionRequestResult);
    {$ENDIF}

    {$IFDEF IOS}
    if Assigned(MyCallBack) then
        ACallBack(Self);
    {$ENDIF}

    {$IFDEF MSWINDOWS}
    TDialogService.ShowMessage('N�o suportado no Windows');
    {$ENDIF}
end;

function T99Permissions.fVerifyWakeLock(): boolean;
begin
    Result := false;

    {$IFDEF ANDROID}
    Result := PermissionsService.IsEveryPermissionGranted([pWakeLock]);
    {$ENDIF}

    {$IFDEF IOS}
    Result := true;
    {$ENDIF}
end;

end.
