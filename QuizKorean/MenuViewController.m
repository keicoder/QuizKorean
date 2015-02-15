//
//  MenuViewController.m
//  QuizKorean
//
//  Created by jun on 2/10/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#define debug 1


#import "MenuViewController.h"
#import "QuizViewController.h"
#import "SettingsViewController.h"
#import "AboutViewController.h"


@interface MenuViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
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
	_duration = 0.2;
	[self configureUI];
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self changeButtonsAlphaToZero];
	[self changeTitleLabelsAlphaToOpaque];
}


-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self moveButtonsOutOfTheView];
}


#pragma mark - Animation

- (void)moveButtonsOutOfTheView
{
	CGFloat originX = 2;
	
	CGRect startButtonFrame = self.startButton.frame;
	startButtonFrame.origin.x -= self.view.bounds.size.width/originX;
	self.startButton.frame = startButtonFrame;
	
	CGRect settingsButtonFrame = self.settingsButton.frame;
	settingsButtonFrame.origin.x -= self.view.bounds.size.width/originX;
	self.settingsButton.frame = settingsButtonFrame;
	
	CGRect aboutButtonFrame = self.aboutButton.frame;
	aboutButtonFrame.origin.x -= self.view.bounds.size.width/originX;
	self.aboutButton.frame = aboutButtonFrame;
	
	[self performSelector:@selector(moveButtonsInTheViewWithAnimation) withObject:nil afterDelay:0.1];
}


- (void)moveButtonsInTheViewWithAnimation
{
	CGFloat alpha = 1.0;
	
	CGFloat duration = 0.2;
	CGFloat initialDelay = 0.0;
	CGFloat additionalDelay = 0.0;
	NSUInteger options = UIViewAnimationOptionCurveEaseIn; //from slow to fast
	
	[UIView animateWithDuration:duration delay:initialDelay options: options animations:^{
		
		self.startButton.alpha = alpha;
		self.startButton.frame = CGRectMake(self.view.bounds.size.width/2 - self.startButton.bounds.size.width/2, self.startButton.frame.origin.y, self.startButton.bounds.size.width, self.startButton.bounds.size.height);
		
	} completion:^(BOOL finished) {
		
		[UIView animateWithDuration:duration delay:additionalDelay options: options animations:^{
			
			self.settingsButton.alpha = alpha;
			self.settingsButton.frame = CGRectMake(self.view.bounds.size.width/2 - self.settingsButton.bounds.size.width/2, self.settingsButton.frame.origin.y, self.settingsButton.bounds.size.width, self.settingsButton.bounds.size.height);
			
		} completion:^(BOOL finished) {
			
			[UIView animateWithDuration:duration delay:additionalDelay options: options animations:^{
				
				self.aboutButton.alpha = alpha;
				self.aboutButton.frame = CGRectMake(self.view.bounds.size.width/2 - self.aboutButton.bounds.size.width/2, self.aboutButton.frame.origin.y, self.aboutButton.bounds.size.width, self.aboutButton.bounds.size.height);
				
			} completion:^(BOOL finished) {
				
			}];
		}];
	}];
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


#pragma mark - Configure UI

- (void)configureUI
{
	float cornerRadius = self.startButton.bounds.size.height/2;
	self.startButton.layer.cornerRadius = cornerRadius;
	self.settingsButton.layer.cornerRadius = cornerRadius;
	self.aboutButton.layer.cornerRadius = cornerRadius;
}


- (void)changeButtonsAlphaToZero
{
	CGFloat alpha = 0.0;
	self.titleLabel.alpha = alpha;
	self.startButton.alpha = alpha;
	self.settingsButton.alpha = alpha;
	self.aboutButton.alpha = alpha;
	
	[self.startButton setBackgroundColor: [UIColor colorWithRed:1.000 green:0.541 blue:0.213 alpha:1.000]];
}


- (void)changeTitleLabelsAlphaToOpaque
{
	CGFloat labelAnimationDuration = 0.7;
	[UIView animateWithDuration:labelAnimationDuration delay:0.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
		
		CGFloat alpha = 1.0;
		self.titleLabel.alpha = alpha;
		
	} completion:^(BOOL finished) { }];
}


#pragma mark - Dealloc

- (void)dealloc
{
	NSLog(@"dealloc %@", self);
}


@end