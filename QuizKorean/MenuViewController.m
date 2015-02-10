//
//  MenuViewController.m
//  QuizKorean
//
//  Created by jun on 2/10/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "MenuViewController.h"
#import "AboutViewController.h"

@interface MenuViewController ()

@property (weak, nonatomic) IBOutlet UIButton *aboutButton;

@end


@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (IBAction)aboutButtonTapped:(id)sender
{
	AboutViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
	controller.view.frame = self.view.bounds;
	[controller presentInParentViewController:self];
}


@end
