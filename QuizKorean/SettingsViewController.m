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
#import <MessageUI/MessageUI.h>
#import "iRate.h"


#define kTURN_ON  [UIColor colorWithRed:1 green:0.73 blue:0.2 alpha:1]
#define kTURN_OFF [UIColor colorWithRed:0.227 green:0.414 blue:0.610 alpha:1.000]
#define iPad      [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad


@interface SettingsViewController () <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIButton *soundEffectButton;
@property (weak, nonatomic) IBOutlet UIButton *sendMailButton;
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
	[self sendFeedbackEmail];
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


#pragma mark - Show ViewController

- (void)showViewController:(id)sender
{
    if (sender == self.aboutButton)
    {
        AboutViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
        controller.view.frame = self.view.bounds;
        [controller presentInParentViewController:self];
    }
}


#pragma mark 이메일 공유
#pragma mark 메일 컴포즈 컨트롤러

- (void)sendFeedbackEmail
{
	if (![MFMailComposeViewController canSendMail])
	{
		NSLog(@"Can't send email");
		return;
	}
	
	MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
	mailViewController.mailComposeDelegate = self;
	[mailViewController setToRecipients:@[@"lovejun.soft@gmail.com"]];
	
	
	NSString *versionString = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
	NSString *buildNumberString = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
	
	NSString *messageSubject = @"QuizKorean iOS Feedback";
	NSString *messageBody = [NSString stringWithFormat:@"QuizKorean iOS Version %@ (Build %@)\n\n\n", versionString, buildNumberString];
	[mailViewController setSubject:NSLocalizedString(messageSubject, messageSubject)];
	[mailViewController setMessageBody:NSLocalizedString(messageBody, messageBody) isHTML:NO];
	
	[self setupMailComposeViewModalTransitionStyle:mailViewController];
	mailViewController.modalPresentationCapturesStatusBarAppearance = YES;
	
	[self presentViewController:mailViewController animated:YES completion:^{ }];
}


#pragma mark 이메일 공유 (Mail ComposeView Modal Transition Style)

- (void)setupMailComposeViewModalTransitionStyle:(MFMailComposeViewController *)mailViewController
{
	if (iPad) {
		mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
	} else {
		mailViewController.modalPresentationStyle = UIModalPresentationPageSheet;
	}
}


#pragma mark 델리게이트 메소드 (MFMailComposeViewControllerDelegate)

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"mail composer cancelled");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"mail composer saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"mail composer sent");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"mail composer failed");
			break;
	}
	[controller dismissViewControllerAnimated:YES completion:^{
		
	}];
}


#pragma mark - Configure UI

- (void)configureUI
{
	float cornerRadius = self.aboutButton.bounds.size.height/2;
	self.aboutButton.layer.cornerRadius = cornerRadius;
	self.soundEffectButton.layer.cornerRadius = cornerRadius;
	self.sendMailButton.layer.cornerRadius = cornerRadius;
	self.returnButton.layer.cornerRadius = cornerRadius;
	[self.returnButton setBackgroundColor: [UIColor colorWithRed:1.000 green:0.541 blue:0.213 alpha:1.000]];
}


@end