//
//  CPPolygonControl.m
//  ColoredPolygon
//
//  Created by Enrique de la Torre Fernández on 25/12/11.
//  Copyright (c) 2011 Enrique de la Torre. All rights reserved.
//

#import "CPPolygonControl.h"

#import <AudioToolbox/AudioToolbox.h>


#define CPPOLYGONCONTROL__TIMEINTERVAL 1.0
#define CPPOLYGONCONTROL__INTERVALSPERMINUTE 60

#define CPPOLYGONCONTROL__EQUALCGRECT(A,B) (A.origin.x == B.origin.x && A.origin.y == B.origin.y && \
                                            A.size.width == B.size.width && A.size.height == B.size.height)


@interface CPPolygonControl()
{
    id<CPPolygonControlProtocol> __delegate;
    
    NSUInteger __cycles;

    NSInteger __currentSubPath;
    NSUInteger __numberOfSubPaths;
    NSArray *__subPaths;
    CGRect __lastRect;
    
    NSTimer *__timer;
    SystemSoundID __tickSound;
}

@property (nonatomic, assign) NSUInteger cycles;

@property (nonatomic, assign) NSInteger currentSubPath;
@property (nonatomic, assign) NSUInteger numberOfSubPaths;
@property (nonatomic, retain) NSArray *subPaths;
@property (nonatomic, assign) CGRect lastRect;

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign) SystemSoundID tickSound;

- (void)prepareInitValues;

- (void)refresh;

+ (NSArray *)createSubPaths:(NSUInteger)numberOfSubPaths
                 withCenter:(CGPoint)center
                      radio:(float)radio
                      angle:(double)angle;

@end


@implementation CPPolygonControl

#pragma mark - Synthesize properties
@synthesize delegate = __delegate;

@synthesize cycles = __cycles;

@synthesize currentSubPath = __currentSubPath;
@synthesize numberOfSubPaths = __numberOfSubPaths;
@synthesize subPaths = __subPaths;
@synthesize lastRect = __lastRect;

@synthesize timer = __timer;
@synthesize tickSound = __tickSound;

#pragma mark - Init object
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self prepareInitValues];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self prepareInitValues];
    }
    return self;    
}

#pragma mark - Memory management
- (void)dealloc
{
    [self stopPolygon];
    
    self.subPaths = nil;
    
    AudioServicesDisposeSystemSoundID(self.tickSound);
    
    [super dealloc];
}

#pragma mark - Inherited methods
- (void)drawRect:(CGRect)rect
{
    if (!self.subPaths || !CPPOLYGONCONTROL__EQUALCGRECT(self.lastRect, rect))
    {
        /* Calculate basic points */
        CGPoint center = {rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2};
        float radio =
            (((rect.size.width < rect.size.height) ? rect.size.width : rect.size.height) / 2) - 10;
        double angle = (2 * M_PI) / self.numberOfSubPaths;

        /* Create sub-paths */ 
        self.subPaths = [CPPolygonControl createSubPaths:self.numberOfSubPaths
                                              withCenter:center
                                                   radio:radio
                                                   angle:angle];
        
        self.lastRect = rect;
    }
    
    /* Draw */
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CFArrayRef subPathsRef = (CFArrayRef)self.subPaths;
    CGPathRef onePath = NULL;
    for (CFIndex i = 0; i < CFArrayGetCount(subPathsRef); i++)
    {
        onePath = (CGPathRef)CFArrayGetValueAtIndex(subPathsRef, i);
        
        CGContextAddPath(context, onePath);
        if (i <= self.currentSubPath)
        {
            [[UIColor orangeColor] setFill];
        }
        else
        {
            [[UIColor brownColor] setFill];
        }
        CGContextDrawPath(context, kCGPathFill);
    }
}

#pragma mark - Public methods
- (void)createPolygonWithCycles:(NSUInteger)cycles minutesPerCycle:(NSUInteger)minutes
{
    [self stopPolygon];
    
    self.cycles = cycles;
    
    self.currentSubPath = -1;
    self.numberOfSubPaths = minutes * CPPOLYGONCONTROL__INTERVALSPERMINUTE;
    self.subPaths = nil;
    
    [self setNeedsDisplay];
}

- (void)startPolygon
{
    if (!self.timer && (self.cycles > 0))
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:CPPOLYGONCONTROL__TIMEINTERVAL
                                                      target:self
                                                    selector:@selector(refresh)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void)stopPolygon
{
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - Private methods
- (void)prepareInitValues
{
    self.cycles = 0;
    
    self.currentSubPath = -1;
    self.numberOfSubPaths = 0;
    self.subPaths = nil;
    
    self.timer = nil;
    
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef soundFileURLRef = CFBundleCopyResourceURL(mainBundle,
                                                       CFSTR("14071__adcbicycle__18"),
                                                       CFSTR("caf"),
                                                       NULL);
    
    AudioServicesCreateSystemSoundID(soundFileURLRef, &__tickSound);
    CFRelease(soundFileURLRef);
    
    /* Redisplays the view when the bounds change */
    self.contentMode = UIViewContentModeRedraw;
}

- (void)refresh
{
    /* Calculate next sub-path to fill and the current cycle */
    self.currentSubPath++;
    if (self.currentSubPath >= [self.subPaths count])
    {
        self.currentSubPath = 0;
        
        self.cycles = (self.cycles > 1 ? self.cycles - 1 : 0);
    }
    
    /* Inform to delegate when starts a new cycle */
    if (self.currentSubPath == 0)
    {
        if (self.delegate)
        {
            [self.delegate cyclesToEnd:self.cycles];
        }
    }
    
    /* Before drawing, check if all cycles were completed */
    if (self.cycles <= 0)
    {
        [self stopPolygon];
        
        if (self.delegate)
        {
            [self.delegate done];
        }
        
        return;
    }
    
    /* Draw polygon and play sound */
    [self setNeedsDisplay];
    AudioServicesPlaySystemSound(self.tickSound);
}

#pragma mark - Private class methods
+ (NSArray *)createSubPaths:(NSUInteger)numberOfSubPaths
                 withCenter:(CGPoint)center
                      radio:(float)radio
                      angle:(double)angle
{
    CGPoint first = {center.x , center.y - radio};
    CGPoint second = first;
    CGPoint third = {0.0, 0.0};
    
    CFMutableArrayRef subPaths =
        CFArrayCreateMutable(kCFAllocatorDefault, (CFIndex)numberOfSubPaths, &kCFTypeArrayCallBacks);
    CGMutablePathRef pathRef = NULL;
    for (NSUInteger i = 1; i <= numberOfSubPaths; i++)
    {
        /* Get third vertex */
        if (i < numberOfSubPaths)
        {
            third.x = center.x + radio * (float)sin(i * angle);
            third.y = center.y - radio * (float)cos(i * angle);
        }
        else
        {
            third = first;
        }
        
        /* Create sub-path */
        pathRef = CGPathCreateMutable();
        
        CGPathMoveToPoint(pathRef, NULL, center.x, center.y);    
        CGPathAddLineToPoint(pathRef, NULL, second.x, second.y);
        CGPathAddLineToPoint(pathRef, NULL, third.x, third.y);
        CGPathCloseSubpath(pathRef);
        
        CFArrayAppendValue(subPaths, pathRef);
        CGPathRelease(pathRef);
                
        /* Set second vertex for next triangle */
        second = third;
    }
    
    return [(NSArray *)subPaths autorelease];

}

@end
