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
	NSInteger _inspectionRound;
	NSInteger _inspectionScore;
}


#pragma mark - View life cycle

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
	
	_inspectionRound = 5;
	
	_inspectionScore = [defaults integerForKey:@"_inspectionScore"];
	NSLog (@"_inspectionScore: %ld\n", (long)_inspectionScore);
	
	//Label 엡데이트
	self.inspectionScoreLabel.text = [NSString stringWithFormat:@"최근 %ld문제중 %ld문제를 맞혔습니다.", (long)_inspectionRound, (long)_inspectionScore];
	self.inspectionDescriptionLabel.text = [NSString stringWithFormat:@"(총 %ld문제중 %ld문제를 맞혔습니다.)", (long)totalRound  ,(long)totalScore];
	
	[self updateStarImageView];
}


- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self setNSUserDefaultsValueToZero];
	NSLog (@"viewWillDisappear > _inspectionRound: %ld\n", (long)_inspectionRound);
	NSLog (@"viewWillDisappear > _inspectionScore: %ld\n", (long)_inspectionScore);
}


#pragma mark - Set Stored Score For ProgressView's Lable Value to Zero

- (void)setNSUserDefaultsValueToZero
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	_inspectionRound = 0;
	_inspectionScore = 0;
	
	[defaults setInteger:_inspectionRound forKey:@"_inspectionRound"];
	[defaults setInteger:_inspectionScore forKey:@"_inspectionScore"];
	
	[defaults synchronize];
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


#pragma mark - Update Star Image View

- (void)updateStarImageView
{
	UIImage *starGold = [UIImage imageNamed:@"starGold"];
	
	switch (_inspectionScore) {
		
		case 1:
			self.starImage1.image = starGold;
			break;
			
		case 2:
			self.starImage1.image = starGold;
			self.starImage2.image = starGold;
			break;
			
		case 3:
			self.starImage1.image = starGold;
			self.starImage2.image = starGold;
			self.starImage3.image = starGold;
			break;
			
		case 4:
			self.starImage1.image = starGold;
			self.starImage2.image = starGold;
			self.starImage3.image = starGold;
			self.starImage4.image = starGold;
			break;
			
		case 5:
			self.starImage1.image = starGold;
			self.starImage2.image = starGold;
			self.starImage3.image = starGold;
			self.starImage4.image = starGold;
			self.starImage5.image = starGold;
			break;
			
		default:
			break;
	}
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