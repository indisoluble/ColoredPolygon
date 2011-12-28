//
//  CPPolygonViewControllerV2.h
//  ColoredPolygon
//
//  Created by Enrique de la Torre Fernández on 25/12/11.
//  Copyright (c) 2011 Enrique de la Torre. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CPPolygonControl.h"

@interface CPPolygonViewController : UIViewController <CPPolygonControlProtocol, UIActionSheetDelegate>

@property (nonatomic, retain) IBOutlet UILabel *cyclesToEndLabel;

@property (nonatomic, retain) IBOutlet CPPolygonControl *polygonControl;

@property (nonatomic, retain) IBOutlet UIView *interruptionsView;
@property (nonatomic, retain) IBOutlet UILabel *externalInterruptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *internalInterruptionLabel;

- (id)initWithNumberOfCycles:(NSUInteger)numberOfCycles
             MinutesPerCycle:(NSUInteger)minutesPerCycle
                     NibName:(NSString *)nibNameOrNil
                      bundle:(NSBundle *)nibBundleOrNil;

- (IBAction)pressed;
- (void)stop;

@end
