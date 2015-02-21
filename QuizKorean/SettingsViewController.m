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
#import "PopView.h"
#import "UIImage+ChangeColor.h"


#define kTURN_ON  [UIColor colorWithRed:1 green:0.73 blue:0.2 alpha:1]
#define kTURN_OFF [UIColor colorWithRed:0.227 green:0.414 blue:0.610 alpha:1.000]
#define iPad      [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad


@interface SettingsViewController () <UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet PopView *aboutView;
@property (weak, nonatomic) IBOutlet PopView *soundEffectView;
@property (weak, nonatomic) IBOutlet PopView *resetView;
@property (weak, nonatomic) IBOutlet PopView *sendMailView;
@property (weak, nonatomic) IBOutlet PopView *returnView;
@property (weak, nonatomic) IBOutlet UILabel *soundEffectLabel;

@end


@implementation SettingsViewController
{
    CGFloat _duration;
	NSString *_soundEffect;
	
	NSUserDefaults *_defaults;
	NSInteger _score;
	NSInteger _round;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _duration = 0.4;
	_defaults = [NSUserDefaults standardUserDefaults];
    
	[self configureUI];
	[self getTheSoundEffectData];
	[self getTheScoreAndRoundData];
    
    [self addTapGestureOnTheView:self.aboutView];
    [self addTapGestureOnTheView:self.soundEffectView];
    [self addTapGestureOnTheView:self.resetView];
    [self addTapGestureOnTheView:self.sendMailView];
    [self addTapGestureOnTheView:self.returnView];
}


#pragma mark - Get the stored NSUserDefaults data

- (void)getTheSoundEffectData
{
	_soundEffect = [_defaults objectForKey:@"_soundEffect"];
	NSLog (@"_soundEffect before: %@\n", _soundEffect);
	
	if (_soundEffect == nil) {
		_soundEffect = @"효과음 > 켜짐";
        self.soundEffectView.backgroundColor = kTURN_ON;
        self.soundEffectView.backgroundColorNormal = kTURN_ON;
	} else if ([_soundEffect isEqualToString: @"효과음 > 켜짐"]) {
        self.soundEffectView.backgroundColor = kTURN_ON;
		self.soundEffectView.backgroundColorNormal = kTURN_ON;
	} else if ([_soundEffect isEqualToString: @"효과음 > 꺼짐"]) {
        self.soundEffectView.backgroundColor = kTURN_OFF;
		self.soundEffectView.backgroundColorNormal = kTURN_OFF;
	}
	
	NSLog (@"_soundEffect after: %@\n", _soundEffect);
    self.soundEffectLabel.text = _soundEffect;
}



- (void)getTheScoreAndRoundData
{
	_score = [_defaults integerForKey:@"_score"];
	_round = [_defaults integerForKey:@"_round"];
	NSLog (@"score value before: %ld\n", (long)_score);
	NSLog (@"round value before: %ld\n", (long)_round);
}


#pragma mark - Tap gesture on the View

- (void)addTapGestureOnTheView:(UIView *)aView
{
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureViewTapped:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    gestureRecognizer.delegate = self;
    
    [aView addGestureRecognizer:gestureRecognizer];
}


- (void)gestureViewTapped:(UITouch *)touch
{
    if ([touch.view isEqual:(UIView *)self.aboutView]) {
        
        NSLog(@"self.aboutView Tapped");
        AboutViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
        controller.view.frame = self.view.bounds;
        [controller presentInParentViewController:self];
        
    } else if ([touch.view isEqual:(UIView *)self.soundEffectView]) {
        
        NSLog(@"self.soundEffectView Tapped");
        if ([_soundEffect isEqualToString: @"효과음 > 켜짐"]) {
            _soundEffect = @"효과음 > 꺼짐";
            self.soundEffectView.backgroundColor = kTURN_OFF;
            self.soundEffectView.backgroundColorNormal = kTURN_OFF;
            
        } else {
            _soundEffect = @"효과음 > 켜짐";
            self.soundEffectView.backgroundColor = kTURN_ON;
            self.soundEffectView.backgroundColorNormal = kTURN_ON;
        }
        
        self.soundEffectLabel.text = _soundEffect;
        
        [_defaults setObject:_soundEffect forKey:@"_soundEffect"];
        [_defaults synchronize];
        
    } else if ([touch.view isEqual:(UIView *)self.resetView]) {
        
        NSLog(@"self.resetView Tapped");
        _score = 0;
        _round = 0;
        NSLog (@"score value after reset: %ld\n", (long)_score);
        NSLog (@"round value after reset: %ld\n", (long)_round);
        
        [_defaults setInteger:_score forKey:@"_score"];
        [_defaults setInteger:_round forKey:@"_round"];
        [_defaults synchronize];
        
        NSString *title = @"초기화 성공!";
        NSString *message = @"데이터가 초기화 되었습니다.";
        
        UIAlertController *sheet = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [sheet addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^void (UIAlertAction *action) {
            NSLog(@"Tapped OK");
        }]];
        
        sheet.popoverPresentationController.sourceView = self.view;
        sheet.popoverPresentationController.sourceRect = self.view.frame;
        
        [self presentViewController:sheet animated:YES completion:nil];
        
    } else if ([touch.view isEqual:(UIView *)self.sendMailView]) {
        
        NSLog(@"self.sendMailView Tapped");
        [self sendFeedbackEmail];
        
    } else if ([touch.view isEqual:(UIView *)self.returnView]) {
        
        NSLog(@"self.returnView Tapped");
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self.aboutView || touch.view == self.soundEffectView || touch.view == self.resetView || touch.view == self.sendMailView || touch.view == self.returnView) {
        
        return YES;
    }
    
    return NO;
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
    //Corner Radius
    float cornerRadius;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        cornerRadius = 35;
    } else {
        cornerRadius = self.aboutView.bounds.size.height/2;
    }
    
    self.aboutView.layer.cornerRadius = cornerRadius;
    self.soundEffectView.layer.cornerRadius = cornerRadius;
    self.resetView.layer.cornerRadius = cornerRadius;
    self.sendMailView.layer.cornerRadius = cornerRadius;
    self.returnView.layer.cornerRadius = cornerRadius;
    
    self.aboutView.cornerRadius = cornerRadius;
    self.soundEffectView.cornerRadius = cornerRadius;
    self.resetView.cornerRadius = cornerRadius;
    self.sendMailView.cornerRadius = cornerRadius;
    self.returnView.cornerRadius = cornerRadius;
    
    
    //Color
    UIColor *colorNormal1 = [UIColor colorWithRed:0.52 green:0.85 blue:0.98 alpha:1];
    UIColor *colorNormal2 = [UIColor colorWithRed:1.000 green:0.541 blue:0.213 alpha:1.000];
    UIColor *colorHighlight = [UIColor colorWithRed:0.6 green:0.83 blue:0.84 alpha:1];
    
    self.soundEffectView.backgroundColor = kTURN_ON;
    self.resetView.backgroundColor = colorNormal1;
    self.returnView.backgroundColor = colorNormal2;
    
    self.soundEffectView.backgroundColorNormal = kTURN_ON;
    self.resetView.backgroundColorNormal = colorNormal1;
    self.returnView.backgroundColorNormal = colorNormal2;
    
    self.aboutView.backgroundColorHighlight = colorHighlight;
    self.soundEffectView.backgroundColorHighlight = colorHighlight;
    self.resetView.backgroundColorHighlight = colorHighlight;
    self.sendMailView.backgroundColorHighlight = colorHighlight;
    self.returnView.backgroundColorHighlight = colorHighlight;
    
    
    //Image View
    UIColor *color = [UIColor colorWithRed:0 green:0.83 blue:0.95 alpha:1];
    UIImage *image = [UIImage imageForChangingColor:@"gear" color:color];
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.image = image;
}


#pragma mark - Dealloc

- (void)dealloc
{
	NSLog(@"dealloc %@", self);
}


@end