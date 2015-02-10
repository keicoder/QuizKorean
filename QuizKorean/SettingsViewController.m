//
//  SettingsViewController.m
//  QuizKorean
//
//  Created by jun on 2/10/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "SettingsViewController.h"
#import <pop/POP.h>


@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIButton *soundEffectButton;
@property (weak, nonatomic) IBOutlet UIButton *sendMailButton;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;

@end


@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self configureUI];
}


#pragma mark - Button Action

- (IBAction)aboutButtonTapped:(id)sender
{
	[self popAnimation];
}


- (IBAction)soundEffectButtonTapped:(id)sender
{
	
}


- (IBAction)sendMailButtonTapped:(id)sender
{
	
}


- (IBAction)feedbackButtonTapped:(id)sender
{
	
}


- (IBAction)dismissButtonTapped:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Pop Animation

- (void)popAnimation
{
	POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
	scaleAnimation.duration = 0.1;
	scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
	[self.aboutButton pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
}


#pragma mark - Configure UI

- (void)configureUI
{
	float cornerRadius = self.aboutButton.bounds.size.height/2;
	self.aboutButton.layer.cornerRadius = cornerRadius;
	self.soundEffectButton.layer.cornerRadius = cornerRadius;
	self.sendMailButton.layer.cornerRadius = cornerRadius;
	self.feedbackButton.layer.cornerRadius = cornerRadius;
	
	UIColor *hightlightTextColor = [UIColor colorWithRed:0.114 green:0.873 blue:0.490 alpha:1.000];
	UIColor *backgroundColor = [UIColor colorWithRed:0.227 green:0.414 blue:0.610 alpha:1.000];
	
	[self.aboutButton setTitleColor:hightlightTextColor forState:UIControlStateHighlighted];
	[self.aboutButton setBackgroundColor:backgroundColor];
	
	[self.soundEffectButton setTitleColor:hightlightTextColor forState:UIControlStateHighlighted];
	[self.soundEffectButton setBackgroundColor:backgroundColor];
	
	[self.sendMailButton setTitleColor:hightlightTextColor forState:UIControlStateHighlighted];
	[self.sendMailButton setBackgroundColor:backgroundColor];
	
	[self.feedbackButton setTitleColor:hightlightTextColor forState:UIControlStateHighlighted];
	[self.feedbackButton setBackgroundColor:backgroundColor];
}


@end