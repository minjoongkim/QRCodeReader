//
//  ViewController.m
//  QRCodeReader
//
//  Created by KMJ on 2017. 3. 15..
//  Copyright © 2017년 KMJ. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVMetadataObject.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController
@synthesize cameraView, lbl_result;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[QRCodeReader sharedReader] setDelegate:self];
        [[QRCodeReader sharedReader] startReaderOnView:self.cameraView];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didDetectQRCode:(AVMetadataMachineReadableCodeObject *)qrCode {
    
    NSString *msg = [NSString stringWithFormat:@"%@", qrCode.stringValue];
    [[QRCodeReader sharedReader] stopReader];
    [lbl_result setText:msg];
}


@end
