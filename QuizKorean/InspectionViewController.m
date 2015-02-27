//
//  InspectionViewController.m
//  QuizKorean
//
//  Created by jun on 2/26/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "InspectionViewController.h"
#import "PopAnimationClearButton.h"
#import "SettingsViewController.h"
#import "PopAnimationImageView.h"


@interface InspectionViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *inspectionView;
@property (weak, nonatomic) IBOutlet UIView *iconView;
@property (weak, nonatomic) IBOutlet PopAnimationImageView *iconImageView;
@property (weak, nonatomic) IBOutlet PopAnimationClearButton *menuButton;
@property (weak, nonatomic) IBOutlet PopAnimationClearButton *nextButton;

@end


@implementation InspectionViewController

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
	
	[self.inspectionView addGestureRecognizer:gestureRecognizer];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	return (touch.view == self.inspectionView);
}


#pragma mark - Configure UI

- (void)configureUI
{
	CGFloat cornerRadius = CGRectGetHeight(self.iconView.bounds)/2;
	self.iconView.layer.cornerRadius = cornerRadius;
	self.inspectionView.layer.cornerRadius = 10.0;
}


#pragma mark - Dealloc

- (void)dealloc
{
	NSLog(@"dealloc %@", self);
}


@end
