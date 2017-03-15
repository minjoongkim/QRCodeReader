//
//  QRCodeReader.m
//  QRCodeReader
//
//  Created by KMJ on 2017. 3. 15..
//  Copyright © 2017년 KMJ. All rights reserved.
//

#import "QRCodeReader.h"
@import AVFoundation;


@interface QRCodeReader ()
<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureMetadataOutput *captureMetadataOutput;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@end


@implementation QRCodeReader

+ (instancetype)sharedReader {
    
    static id instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}


// =============================================================================
#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)       captureOutput:(AVCaptureOutput *)captureOutput
    didOutputMetadataObjects:(NSArray *)metadataObjects
              fromConnection:(AVCaptureConnection *)connection
{
    for (AVMetadataObject *metadataObject in metadataObjects) {
        
        if (![metadataObject isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            continue;
        }
        
        AVMetadataMachineReadableCodeObject *machineReadableCode = (AVMetadataMachineReadableCodeObject *)metadataObject;
        if ([self.delegate respondsToSelector:@selector(didDetectQRCode:)]) {
            [self.delegate didDetectQRCode:machineReadableCode];
        }
    }
    
    
    
}
// =============================================================================
#pragma mark - Public

- (void)startReaderOnView:(UIView *)view {
    
    // AVCaptureDevice 카메라 검색.
    NSError *error;
    AVCaptureDevice *captureDevice;
    for (AVCaptureDevice *aCaptureDevice in [AVCaptureDevice devices]) {
        if (aCaptureDevice.position == AVCaptureDevicePositionBack) {
            captureDevice = aCaptureDevice;
        }
    }
    if (!captureDevice) {
        NSLog(@"Can't find camera.");
        return;
    }
    
    // AVCaptureDeviceInput 생성.
    AVCaptureDeviceInput *captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"error:%@", error);
        return;
    }
    
    // AVCaptureSession 생성 및 AVCaptureDeviceInput addInput.
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    if ([self.captureSession canAddInput:captureDeviceInput]) {
        [self.captureSession addInput:captureDeviceInput];
    }
    
    // AVCaptureMetadataOutput 생성 및 AVCaptureMetadataOutput addOutput.
    self.captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    if ([self.captureSession canAddOutput:self.captureMetadataOutput]) {
        [self.captureSession addOutput:self.captureMetadataOutput];
    }
    
    // metadataObjectTypes을 AVMetadataObjectTypeQRCode로 설정.
    self.captureMetadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    // Setup preview layer
    self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;// AVLayerVideoGravityResizeAspect is default.
    self.captureVideoPreviewLayer.frame = view.bounds;
    
    [view.layer addSublayer:self.captureVideoPreviewLayer];
    
    [self.captureSession startRunning];
}

- (void)stopReader {
    
    [self.captureSession stopRunning];
    [self.captureVideoPreviewLayer removeFromSuperlayer];
    self.captureVideoPreviewLayer = nil;
    self.captureSession = nil;
    
}

@end
