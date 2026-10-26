#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

static void doMacosInit() {
    @autoreleasepool {
        switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio]) {
            case AVAuthorizationStatusAuthorized:
                NSLog(@"MACOS: Application already has been granted audio recording permission!");
                break;

            case AVAuthorizationStatusNotDetermined:
            {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                    if (granted) {
                        NSLog(@"User has granted audio permission to the application: requestAccessForMediaType:true");
                    } else {
                        NSLog(@"User has denied audio permission to the application: : requestAccessForMediaType:false");
                    }
                }];
                break;
            }

            case AVAuthorizationStatusDenied:
                NSLog(@"User has just denied audio permission to the application: AVAuthorizationStatusDenied");
                break;

            case AVAuthorizationStatusRestricted:
                NSLog(@"Apppication does not have access to media capture devices: AVAuthorizationStatusRestricted");
                break;

            default:
                break;
        }

        // The rest of your code
//        NSLog(@"Hello, World!");
    }
}

// SoapySDR modules bundled in the .app (e.g. MSi2500 driver), must be set before SoapySDR loads its modules
static void setBundledSoapyPath() {
    @autoreleasepool {
        NSString* soapyDir = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/Plugins/SoapySDR"];
        if (getenv("SOAPY_SDR_PLUGIN_PATH") == NULL && [[NSFileManager defaultManager] fileExistsAtPath:soapyDir]) {
            setenv("SOAPY_SDR_PLUGIN_PATH", [soapyDir fileSystemRepresentation], 1);
        }
    }
}

void macosInit() {
    setBundledSoapyPath();
    doMacosInit();
}
