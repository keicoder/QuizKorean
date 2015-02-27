//
//  InspectionViewController.m
//  QuizKorean
//
//  Created by jun on 2/26/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "InspectionViewController.h"
#import "PopAnimationClearButton.h"
#import "QuizViewController.h"


@interface InspectionViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *inspectionView;

@property (weak, nonatomic) IBOutlet UIView *iconView;
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


- (IBAction)menuButtonTapped:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:^{
		
		//Post a notification when InspectionView's menu button tapped
		[[NSNotificationCenter defaultCenter] postNotificationName: @"DidTappedInspectionViewsMenuButtonNotification" object:nil userInfo:nil];
		
	}];
}


- (IBAction)nextButtonTapped:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:^{
		
		//Post a notification when InspectionView's next button tapped
		[[NSNotificationCenter defaultCenter] postNotificationName: @"DidTappedInspectionViewsNextButtonNotification" object:nil userInfo:nil];
		
	}];
}


#pragma mark - Tap Guesture

- (void)addTapGuesture
{
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextButtonTapped:)];
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
