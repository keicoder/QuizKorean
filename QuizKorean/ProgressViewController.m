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

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet PopAnimationClearButton *dismissButton;
@property (weak, nonatomic) IBOutlet PopAnimationClearButton *settingsButton;
@property (weak, nonatomic) IBOutlet PopAnimationClearButton *menuButton;
@property (weak, nonatomic) IBOutlet PopAnimationClearButton *nextButton;

@end


@implementation ProgressViewController

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
	self.round = [defaults integerForKey:@"round"];
	NSLog (@"self.round: %ld\n", (long)self.round);
	
	self.score = [defaults integerForKey:@"score"];
	NSLog (@"self.score: %ld\n", (long)self.score);
	
	self.infoLabel.text = [NSString stringWithFormat:@"%ld / %ld", (long)self.score, (long)self.round];
	
	[self updateStarImageView];
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
	UIImage *image = [UIImage imageNamed:@"starGold"];
	
    float userScore = (float)self.score / (float)self.round;
    NSLog (@"userScore: %f\n", userScore);
    
    
    if (userScore <= 0.21) {
        self.starImage1.image = image;
    } else if (userScore <= 0.41) {
        self.starImage1.image = image;
        self.starImage2.image = image;
    } else if (userScore <= 0.61) {
        self.starImage1.image = image;
        self.starImage2.image = image;
        self.starImage3.image = image;
    } else if (userScore <= 0.81) {
        self.starImage1.image = image;
        self.starImage2.image = image;
        self.starImage3.image = image;
        self.starImage4.image = image;
    } else if (userScore > 0.81) {
        self.starImage1.image = image;
        self.starImage2.image = image;
        self.starImage3.image = image;
        self.starImage4.image = image;
        self.starImage5.image = image;
    }
}


#pragma mark - Configure UI

- (void)configureUI
{
	self.progressView.layer.cornerRadius = 10.0;
    
    UIImage *image = [UIImage imageNamed:@"starWhite"];
    self.starImage1.image = image;
    self.starImage2.image = image;
    self.starImage3.image = image;
    self.starImage4.image = image;
    self.starImage5.image = image;
}


#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}


@end