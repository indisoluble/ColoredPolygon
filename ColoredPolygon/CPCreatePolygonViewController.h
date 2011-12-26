//
//  CPCreatePolygonViewController.h
//  ColoredPolygon
//
//  Created by Enrique de la Torre Fernández on 25/12/11.
//  Copyright (c) 2011 Enrique de la Torre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPCreatePolygonViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField *nameText;
@property (nonatomic, retain) IBOutlet UITextField *cyclesText;

- (IBAction)start;

@end
