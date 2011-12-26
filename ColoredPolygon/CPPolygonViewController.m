//
//  CPPolygonViewControllerV2.m
//  ColoredPolygon
//
//  Created by Enrique de la Torre Fernández on 25/12/11.
//  Copyright (c) 2011 Enrique de la Torre. All rights reserved.
//

#import "CPPolygonViewController.h"


#define CPPOLYGONVIEWCONTROLLER__MINUTESPERCYCLE 25

#define CPPOLYGONVIEWCONTROLLER__ASTITLE_CONTINUE "Continue"
#define CPPOLYGONVIEWCONTROLLER__ASTITLE_INTERNAL "Internal"
#define CPPOLYGONVIEWCONTROLLER__ASTITLE_EXTERNAL "External"


@interface CPPolygonViewController()
{
    UILabel *__cyclesToEndLabel;
    
    CPPolygonControl *__polygonControl;
    
    UIView *__interruptionsView;
    UILabel *__externalInterruptionLabel;
    UILabel *__internalInterruptionLabel;
    
    NSUInteger __numberOfCycles;
    BOOL __started;
    BOOL __finished;
    
    UIActionSheet *__asInterruptionType;
    NSUInteger __externalInterruptionValue;
    NSUInteger __internalInterruptionValue;
    BOOL __interruptionAnimationShowed;
}

@property (nonatomic, assign) NSUInteger numberOfCycles;
@property (nonatomic, assign) BOOL started;
@property (nonatomic, assign) BOOL finished;

@property (nonatomic, retain) UIActionSheet *asInterruptionType;
@property (nonatomic, assign) NSUInteger externalInterruptionValue;
@property (nonatomic, assign) NSUInteger internalInterruptionValue;
@property (nonatomic, assign) BOOL interruptionAnimationShowed;

- (void)askKindOfInterruption;
- (void)showInterruptionsValue;

@end


@implementation CPPolygonViewController

#pragma mark - Synthesize properties
@synthesize cyclesToEndLabel = __cyclesToEndLabel;

@synthesize polygonControl = __polygonControl;

@synthesize interruptionsView = __interruptionsView;
@synthesize externalInterruptionLabel = __externalInterruptionLabel;
@synthesize internalInterruptionLabel = __internalInterruptionLabel;

@synthesize numberOfCycles = __numberOfCycles;
@synthesize started = __started;
@synthesize finished = __finished;

@synthesize asInterruptionType = __asInterruptionType;
@synthesize externalInterruptionValue = __externalInterruptionValue;
@synthesize internalInterruptionValue = __internalInterruptionValue;
@synthesize interruptionAnimationShowed = __interruptionAnimationShowed;

#pragma mark - Init object
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithNumberOfCycles:1 NibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (id)initWithNumberOfCycles:(NSUInteger)numberOfCycles
                     NibName:(NSString *)nibNameOrNil
                      bundle:(NSBundle *)nibBundleOrNil;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.numberOfCycles = numberOfCycles;
        self.started = NO;
        self.finished = NO;
        
        self.externalInterruptionValue = 0;
        self.internalInterruptionValue = 0;
        self.interruptionAnimationShowed = NO;
    }
    return self;    
}

#pragma mark - Memory management
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    self.polygonControl = nil;
    
    self.cyclesToEndLabel = nil;
    
    self.interruptionsView = nil;
    self.externalInterruptionLabel = nil;
    self.internalInterruptionLabel = nil;
    
    self.asInterruptionType = nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.polygonControl.delegate = self;
    [self.polygonControl createPolygonWithCycles:self.numberOfCycles
                                 minutesPerCycle:CPPOLYGONVIEWCONTROLLER__MINUTESPERCYCLE];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.polygonControl stopPolygon];
}

#pragma mark - CPPolygonControlProtocol methods
- (void)cyclesToEnd:(NSUInteger)cycles
{
    self.cyclesToEndLabel.text = [[NSNumber numberWithUnsignedInteger:cycles] stringValue];
}

- (void)done
{
    self.finished = YES;
}

#pragma mark - UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet != self.asInterruptionType)
    {
        NSLog(@"Received an unknown action sheet");
        
        return;
    }
    
    NSString *title = [self.asInterruptionType buttonTitleAtIndex:buttonIndex];
    if ([title compare:@CPPOLYGONVIEWCONTROLLER__ASTITLE_INTERNAL] == NSOrderedSame)
    {
        self.internalInterruptionValue++;
        [self showInterruptionsValue];
    }
    else if ([title compare:@CPPOLYGONVIEWCONTROLLER__ASTITLE_EXTERNAL] == NSOrderedSame)
    {
        self.externalInterruptionValue++;
        [self showInterruptionsValue];
    }
    else /* CPPOLYGONVIEWCONTROLLER__ASTITLE_CONTINUE */
    {
        [self pressed];
    }
    
}

#pragma mark - Public methods
- (IBAction)pressed
{
    if (!self.finished)
    {
        if (self.started)
        {
            [self.polygonControl stopPolygon];
            [self askKindOfInterruption];
        }
        else
        {
            [self.polygonControl startPolygon];
        }
        
        self.started = !self.started;        
    }
}

#pragma mark - Private methods
- (void)askKindOfInterruption
{
    if (!self.asInterruptionType)
    {
        self.asInterruptionType = 
            [[[UIActionSheet alloc] initWithTitle: @"Kind of interruption"
                                         delegate:self
                                cancelButtonTitle:@CPPOLYGONVIEWCONTROLLER__ASTITLE_CONTINUE
                           destructiveButtonTitle:nil
                                otherButtonTitles:@CPPOLYGONVIEWCONTROLLER__ASTITLE_EXTERNAL,
                                                  @CPPOLYGONVIEWCONTROLLER__ASTITLE_INTERNAL,
                                                  nil] autorelease];
    }
    
    [self.asInterruptionType showInView:self.view];
}

- (void)showInterruptionsValue
{
    if (!self.interruptionAnimationShowed)
    {
        /* Once the view with the number of interruptions is showed,
         it remains visible. So, the animations is only done the
         first time */
        CGRect tmpFrame = self.polygonControl.frame;
        tmpFrame.size = self.interruptionsView.frame.size;
        self.interruptionsView.frame = tmpFrame;
        
        [UIView beginAnimations:@"interruptionsAnimationsShow" context:nil];
        [UIView setAnimationDuration:0.3];
        
        tmpFrame = self.polygonControl.frame;
        tmpFrame.origin.y += self.interruptionsView.frame.size.height;
        self.polygonControl.frame = tmpFrame;
        
        self.interruptionsView.alpha = 1.0;
        
        [UIView commitAnimations];
        
        self.interruptionAnimationShowed = YES;
    }
    
    self.internalInterruptionLabel.text = [[NSNumber numberWithInteger:self.internalInterruptionValue] stringValue];
    self.externalInterruptionLabel.text = [[NSNumber numberWithInteger:self.externalInterruptionValue] stringValue];
}


@end
