# QRCodeReader
ios QRCodeReader

## Usage

###Example usage: *.h

```objc
import "QRCodeReader.h"

@interface ViewController : UIViewController<QRCodeReaderDelegate>

@property (nonatomic, weak)    IBOutlet UIView *cameraView;
@property (nonatomic, weak)    IBOutlet UILabel *lbl_result;

@end

```

###Example usage: *.m

```objc
#import <AVFoundation/AVMetadataObject.h>
#import <AVFoundation/AVFoundation.h>

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[QRCodeReader sharedReader] setDelegate:self];
        [[QRCodeReader sharedReader] startReaderOnView:self.cameraView];
    });
}

- (void)didDetectQRCode:(AVMetadataMachineReadableCodeObject *)qrCode {
    
    NSString *msg = [NSString stringWithFormat:@"%@", qrCode.stringValue];
    [[QRCodeReader sharedReader] stopReader];
    [lbl_result setText:msg];
}
```

### Example Usage : *.xib

link view-cameraView
link lable-lbl_result

## Author

minjoongkim, kmj6773@gmail.com

## License

MJCircleCounter is available under the MIT license. See the LICENSE file for more info.
