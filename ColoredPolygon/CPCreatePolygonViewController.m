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
}

@end


@implementation CPCreatePolygonViewController

#pragma mark - Synthesize properties
@synthesize nameText = __nameText;
@synthesize cyclesText = __cyclesText;

#pragma mark - Init object
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    if (([self.nameText.text length] <= 0) ||
        (numberOfCycles <= 0))
    {
        UIAlertView *alert =
            [[[UIAlertView alloc] initWithTitle:@"Complete fields"
                                        message:@"Write a name and a number of cycles greater than 0"
                                       delegate:nil
                              cancelButtonTitle:@"Continue"
                              otherButtonTitles:nil] autorelease];
        [alert show];
        
        return;
    }
    
    CPPolygonViewController *polygonViewController =
        [[[CPPolygonViewController alloc] initWithNumberOfCycles:numberOfCycles
                                                         NibName:@"CPPolygonViewController"
                                                          bundle:nil] autorelease];
    polygonViewController.title = self.nameText.text;
    
    [self.navigationController pushViewController:polygonViewController animated:YES];
    
    self.nameText.text = @"";
    self.cyclesText.text = @"";
}

@end
