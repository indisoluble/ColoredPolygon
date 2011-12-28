//
//  CPCreatePolygonViewController.m
//  ColoredPolygon
//
//  Created by Enrique de la Torre Fernández on 25/12/11.
//  Copyright (c) 2011 Enrique de la Torre. All rights reserved.
//

#import "CPCreatePolygonViewController.h"

#import "CPPolygonViewController.h"


@interface CPCreatePolygonViewController ()
{
    UITextField *__nameText;
    UITextField *__cyclesText;
    UITextField *__minutesText;
    
    CPPolygonViewController *__polygonViewController;
}

@property (nonatomic, retain) CPPolygonViewController *polygonViewController;

@end


@implementation CPCreatePolygonViewController

#pragma mark - Synthesize properties
@synthesize nameText = __nameText;
@synthesize cyclesText = __cyclesText;
@synthesize minutesText = __minutesText;

@synthesize polygonViewController = __polygonViewController;

#pragma mark - Init object
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.polygonViewController = nil;
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
    self.polygonViewController = nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	
	return YES;
}

#pragma mark - Public methods
- (IBAction)start
{
    NSUInteger numberOfCycles = (NSUInteger)[self.cyclesText.text integerValue];
    NSUInteger minutesPerCycle = (NSUInteger)[self.minutesText.text integerValue];
    
    if (([self.nameText.text length] <= 0) ||
        (numberOfCycles <= 0) ||
        (minutesPerCycle <= 0))
    {
        UIAlertView *alert =
            [[[UIAlertView alloc] initWithTitle:@"Complete fields"
                                        message:@"Write a name and a number of cycles and minutes per cycle greater than 0"
                                       delegate:nil
                              cancelButtonTitle:@"Continue"
                              otherButtonTitles:nil] autorelease];
        [alert show];
        
        return;
    }
    
    self.polygonViewController =
        [[[CPPolygonViewController alloc] initWithNumberOfCycles:numberOfCycles
                                                 MinutesPerCycle:minutesPerCycle
                                                         NibName:@"CPPolygonViewController"
                                                          bundle:nil] autorelease];
    self.polygonViewController.title = self.nameText.text;
    
    [self.navigationController pushViewController:self.polygonViewController animated:YES];
    
    self.nameText.text = @"";
    self.cyclesText.text = @"";
    self.minutesText.text = @"";
}
- (void)stop
{
    if (self.polygonViewController)
    {
        [self.polygonViewController stop];
    }
}

@end
