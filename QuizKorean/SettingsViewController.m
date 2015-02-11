//
//  SettingsViewController.m
//  QuizKorean
//
//  Created by jun on 2/10/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "SettingsViewController.h"
#import "POP.h"
#import "AboutViewController.h"


@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIButton *soundEffectButton;
@property (weak, nonatomic) IBOutlet UIButton *sendMailButton;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;

@end


@implementation SettingsViewController
{
    CGFloat _duration;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _duration = 0.5;
	[self configureUI];
}


#pragma mark - Button Action

- (IBAction)aboutButtonTapped:(id)sender
{
	[self popAnimation:sender];
	[self performSelector:@selector(showViewController:) withObject:sender afterDelay:_duration];
}


- (IBAction)soundEffectButtonTapped:(id)sender
{
	[self popAnimation:sender];
	[self performSelector:@selector(showViewController:) withObject:sender afterDelay:_duration];
}


- (IBAction)sendMailButtonTapped:(id)sender
{
	[self popAnimation:sender];
}


- (IBAction)feedbackButtonTapped:(id)sender
{
	[self popAnimation:sender];
}


- (IBAction)dismissButtonTapped:(id)sender
{
	[self popAnimation:sender];
	[self performSelector:@selector(dismissView) withObject:self afterDelay:0.3];
	
}


- (void)dismissView
{
	[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Pop Animation: Sprint

- (void)popAnimation:(id)sender
{
	POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
	sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
	sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
	sprintAnimation.springBounciness = 20.f;
	[sender pop_addAnimation:sprintAnimation forKey:@"sprintAnimation"];
}


#pragma mark - Show ViewController

- (void)showViewController:(id)sender
{
    if (sender == self.aboutButton)
    {
        AboutViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
        controller.view.frame = self.view.bounds;
        [controller presentInParentViewController:self];
    }
    else if (sender == self.soundEffectButton)
    {
        SettingsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        [self presentViewController:controller animated:YES completion:^{ }];
    }
    else if (sender == self.sendMailButton)
    {
        NSLog(@"senaMail button tapped");
    }
    else if (sender == self.feedbackButton)
    {
        NSLog(@"feedback button tapped");
    }
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