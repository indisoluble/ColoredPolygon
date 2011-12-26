//
//  CPPolygonControl.h
//  ColoredPolygon
//
//  Created by Enrique de la Torre Fernández on 25/12/11.
//  Copyright (c) 2011 Enrique de la Torre. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CPPolygonControlProtocol

- (void)cyclesToEnd:(NSUInteger)cycles;
- (void)done;

@end

@interface CPPolygonControl : UIControl

@property (nonatomic, assign) id<CPPolygonControlProtocol> delegate;

- (void)createPolygonWithCycles:(NSUInteger)cycles minutesPerCycle:(NSUInteger)minutes;
- (void)startPolygon;
- (void)stopPolygon;

@end
