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


#define kTURN_ON [UIColor colorWithRed:1 green:0.73 blue:0.2 alpha:1]
#define kTURN_OFF [UIColor colorWithRed:0.227 green:0.414 blue:0.610 alpha:1.000]


@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIButton *soundEffectButton;
@property (weak, nonatomic) IBOutlet UIButton *sendMailButton;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;

@end


@implementation SettingsViewController
{
    CGFloat _duration;
	NSString *_soundEffect;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _duration = 0.4;
	[self configureUI];
	[self getSoundEffectData];
}


#pragma mark - Button Action

- (IBAction)aboutButtonTapped:(id)sender
{
	[self performSelector:@selector(showViewController:) withObject:sender afterDelay:_duration];
}


- (IBAction)soundEffectButtonTapped:(id)sender
{
	if ([_soundEffect isEqualToString: @"효과음 > 켜짐"]) {
		_soundEffect = @"효과음 > 꺼짐";
		[self.soundEffectButton setBackgroundColor:kTURN_OFF];
		
	} else {
		_soundEffect = @"효과음 > 켜짐";
		[self.soundEffectButton setBackgroundColor:kTURN_ON];
	}
	
	[self.soundEffectButton setTitle:_soundEffect forState:UIControlStateNormal];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:_soundEffect forKey:@"_soundEffect"];
	[defaults synchronize];
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


#pragma mark - Get the stored NSUserDefaults data

- (void)getSoundEffectData
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	_soundEffect = [defaults objectForKey:@"_soundEffect"];
	NSLog (@"_soundEffect: %@\n", _soundEffect);
	
	if (_soundEffect == nil) {
		_soundEffect = @"효과음 > 켜짐";
		[self.soundEffectButton setBackgroundColor:kTURN_ON];
	} else if ([_soundEffect isEqualToString: @"효과음 > 켜짐"]) {
		[self.soundEffectButton setBackgroundColor:kTURN_ON];
	} else if ([_soundEffect isEqualToString: @"효과음 > 꺼짐"]) {
		[self.soundEffectButton setBackgroundColor:kTURN_OFF];
	}
	
	NSLog (@"_soundEffect: %@\n", _soundEffect);
	[self.soundEffectButton setTitle:_soundEffect forState:UIControlStateNormal];
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
	self.returnButton.layer.cornerRadius = cornerRadius;
	[self.returnButton setBackgroundColor: [UIColor colorWithRed:1.000 green:0.541 blue:0.213 alpha:1.000]];
}


@end