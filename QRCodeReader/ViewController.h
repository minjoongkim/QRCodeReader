//
//  ViewController.h
//  QRCodeReader
//
//  Created by KMJ on 2017. 3. 15..
//  Copyright © 2017년 KMJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeReader.h"

@interface ViewController : UIViewController<QRCodeReaderDelegate>

@property (nonatomic, weak)    IBOutlet UIView *cameraView;
@property (nonatomic, weak)    IBOutlet UILabel *lbl_result;

@end

