//
//  QRCodeReader.h
//  QRCodeReader
//
//  Created by KMJ on 2017. 3. 15..
//  Copyright © 2017년 KMJ. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AVMetadataMachineReadableCodeObject;

@protocol QRCodeReaderDelegate <NSObject>
- (void)didDetectQRCode:(AVMetadataMachineReadableCodeObject *)qrCode;
@end

@interface QRCodeReader : UIViewController

@property (nonatomic, weak) id<QRCodeReaderDelegate> delegate;

+ (instancetype)sharedReader;

- (void)startReaderOnView:(UIView *)view;
- (void)stopReader;
@end
