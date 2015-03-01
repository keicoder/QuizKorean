//
//  ProgressViewController.m
//  QuizKorean
//
//  Created by jun on 2015. 2. 24..
//  Copyright (c) 2015년 jun. All rights reserved.
//

#import "ProgressViewController.h"
#import "PopAnimationClearButton.h"
#import "SettingsViewController.h"
#import "MenuViewController.h"


@interface ProgressViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *progressView;

@property (weak, nonatomic) IBOutlet UIImageView *starImage1;
@property (weak, nonatomic) IBOutlet UIImageView *starImage2;
@property (weak, nonatomic) IBOutlet UIImageView *starImage3;
@property (weak, nonatomic) IBOutlet UIImageView *starImage4;
@property (weak, nonatomic) IBOutlet UIImageView *starImage5;

@property (weak, nonatomic) IBOutlet UILabel *inspectionScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *inspectionDescriptionLabel;

@property (weak, nonatomic) IBOutlet PopAnimationClearButton *dismissButton;
@property (weak, nonatomic) IBOutlet PopAnimationClearButton *settingsButton;
@property (weak, nonatomic) IBOutlet PopAnimationClearButton *menuButton;
@property (weak, nonatomic) IBOutlet PopAnimationClearButton *nextButton;

@end


@implementation ProgressViewController
{
	NSInteger _storedScoreForProgressViewsLable;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self configureUI];
	[self addTapGuesture];
	[self showQuizData];
}


#pragma mark - 퀴즈 데이터 보여주기

- (void)showQuizData
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger totalRound = [defaults integerForKey:@"_totalRound"];
	NSLog (@"totalRound: %ld\n", (long)totalRound);
	
	NSInteger totalScore = [defaults integerForKey:@"_totalScore"];
	NSLog (@"totalScore: %ld\n", (long)totalScore);
	
	NSInteger inspectionRound = 5;
	
	NSInteger inspectionScore = [defaults integerForKey:@"_inspectionScore"];
	NSLog (@"inspectionScore: %ld\n", (long)inspectionScore);
	
	_storedScoreForProgressViewsLable = [defaults integerForKey:@"_storedScoreForProgressViewsLable"];
	NSLog (@"_storedScoreForProgressViewsLable: %ld\n", (long)_storedScoreForProgressViewsLable);
	
	//Label 엡데이트
	self.inspectionScoreLabel.text = [NSString stringWithFormat:@"최근 %ld문제중 %ld문제를 맞혔습니다.", (long)inspectionRound, (long)_storedScoreForProgressViewsLable];
	self.inspectionDescriptionLabel.text = [NSString stringWithFormat:@"(총 %ld문제중 %ld문제를 맞혔습니다.)", (long)totalRound  ,(long)totalScore];
	
	[self updateStarImageView];
}


- (void)updateStarImageView
{
	NSLog (@"_storedScoreForProgressViewsLable: %ld\n", (long)_storedScoreForProgressViewsLable);
	
	if (_storedScoreForProgressViewsLable == 1) {
		self.starImage2.image = nil;
		self.starImage3.image = nil;
		self.starImage4.image = nil;
		self.starImage5.image = nil;
	} else if (_storedScoreForProgressViewsLable == 2) {
		self.starImage3.image = nil;
		self.starImage4.image = nil;
		self.starImage5.image = nil;
	} else if (_storedScoreForProgressViewsLable == 3) {
		self.starImage4.image = nil;
		self.starImage5.image = nil;
	} else if (_storedScoreForProgressViewsLable == 4) {
		self.starImage5.image = nil;
	} else if (_storedScoreForProgressViewsLable == 5) {
		
	} else {
		self.starImage1.image = nil;
		self.starImage2.image = nil;
		self.starImage3.image = nil;
		self.starImage4.image = nil;
		self.starImage5.image = nil;
	}
}


#pragma mark - Button and Touch Action

- (IBAction)dismissButtonTapped:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:^{
		
		[[NSNotificationCenter defaultCenter] postNotificationName: @"DidTappedDismissButtonNotification" object:nil userInfo:nil];
	}];
}


- (IBAction)settingsButtonTapped:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:^{
		
		[[NSNotificationCenter defaultCenter] postNotificationName: @"DidTappedSettingsButtonNotification" object:nil userInfo:nil];
	}];
}


- (IBAction)menuButtonTapped:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:^{
		
		[[NSNotificationCenter defaultCenter] postNotificationName: @"DidTappedMenuButtonNotification" object:nil userInfo:nil];
	}];
}


- (IBAction)nextButtonTapped:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:^{
		
		[[NSNotificationCenter defaultCenter] postNotificationName: @"DidTappedNextButtonNotification" object:nil userInfo:nil];
		[[NSNotificationCenter defaultCenter] postNotificationName: @"ResetStoredScoreNotification" object:nil userInfo:nil];
	}];
	
}


#pragma mark - Tap Guesture

- (void)addTapGuesture
{
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissButtonTapped:)];
	gestureRecognizer.cancelsTouchesInView = NO;
	gestureRecognizer.delegate = self;
	
	[self.progressView addGestureRecognizer:gestureRecognizer];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	return (touch.view == self.progressView);
}


#pragma mark - Configure UI

- (void)configureUI
{
	self.progressView.layer.cornerRadius = 10.0;
}


#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}


@end