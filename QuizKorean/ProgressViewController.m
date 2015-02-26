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


@interface ProgressViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *progressView;

@property (weak, nonatomic) IBOutlet UIImageView *starImage1;
@property (weak, nonatomic) IBOutlet UIImageView *starImage2;
@property (weak, nonatomic) IBOutlet UIImageView *starImage3;
@property (weak, nonatomic) IBOutlet UIImageView *starImage4;
@property (weak, nonatomic) IBOutlet UIImageView *starImage5;

@property (weak, nonatomic) IBOutlet PopAnimationClearButton *dismissButton;
@property (weak, nonatomic) IBOutlet PopAnimationClearButton *settingsButton;
@property (weak, nonatomic) IBOutlet PopAnimationClearButton *nextButton;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end


@implementation ProgressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self configureUI];
	[self addTapGuesture];
}


#pragma mark - Button and Touch Action

- (IBAction)dismissButtonTapped:(id)sender
{
	NSLog(@"self.popView did receive touch");
	[self dismissViewControllerAnimated:YES completion:^{
		NSLog(@"Progress view dismissed");
	}];
}

- (IBAction)settingsButtonTapped:(id)sender
{
	SettingsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
	[self showViewController:controller sender:sender];
}


- (IBAction)nextButtonTapped:(id)sender
{
	
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