//
//  MenuViewController.m
//  QuizKorean
//
//  Created by jun on 2/10/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "MenuViewController.h"
#import "QuizViewController.h"
#import "SettingsViewController.h"
#import "AboutViewController.h"


@interface MenuViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;

@end


@implementation MenuViewController
{
	CGFloat _duration;
}


- (void)viewDidLoad
{
	[super viewDidLoad];
	_duration = 0.4;
	[self configureUI];
}


#pragma mark - Button Action

- (IBAction)startButtonTapped:(id)sender
{
	[self performSelector:@selector(showViewController:) withObject:sender afterDelay:_duration];
}


- (IBAction)settingsButtonTapped:(id)sender
{
	[self performSelector:@selector(showViewController:) withObject:sender afterDelay:_duration];
}


- (IBAction)aboutButtonTapped:(id)sender
{
	[self performSelector:@selector(showViewController:) withObject:sender afterDelay:_duration];
}


#pragma mark - Show ViewController

- (void)showViewController:(id)sender
{
	if (sender == self.startButton)
	{
		QuizViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"QuizViewController"];
		[self showViewController:controller sender:sender];
	}
	else if (sender == self.settingsButton)
	{
		SettingsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
		[self presentViewController:controller animated:YES completion:^{ }];
	}
	else if (sender == self.aboutButton)
	{
		AboutViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
		controller.view.frame = self.view.bounds;
		[controller presentInParentViewController:self];
	}
}


- (void)configureUI
{
	self.view.backgroundColor = [UIColor colorWithRed:0.05 green:0.32 blue:0.41 alpha:1];
	
	float cornerRadius = self.startButton.bounds.size.height/2;
	self.startButton.layer.cornerRadius = cornerRadius;
	self.settingsButton.layer.cornerRadius = cornerRadius;
	self.aboutButton.layer.cornerRadius = cornerRadius;
}


#pragma mark - Dealloc

- (void)dealloc
{
	NSLog(@"dealloc %@", self);
}


@end