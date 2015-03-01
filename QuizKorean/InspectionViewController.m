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
	[self showSuitableImageOnTheIconImageView];
}


-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self animateIconImageView];
}


#pragma mark - 애니메이션

- (void)animateIconImageView
{
	CGFloat duration = 0.15f;
	[UIView animateWithDuration:duration delay:0.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
		self.iconImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
		self.iconImageView.transform = CGAffineTransformMakeRotation(M_PI/4);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:duration delay:0.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
			self.iconImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:duration delay:0.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
				self.iconImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
				self.iconImageView.transform = CGAffineTransformMakeRotation(0.0);
			} completion:^(BOOL finished) { }];
		}];
	}];
}


#pragma mark - Show suitable image on the IconImageView

- (void)showSuitableImageOnTheIconImageView
{
	self.iconImageView.image = nil;
	
	if (self.didSelectCorrectAnswer == YES) {
		UIImage *image = [UIImage imageNamed:@"correctCircle"];
		self.iconImageView.image = image;
	} else {
		UIImage *image = [UIImage imageNamed:@"falseCircle"];
		self.iconImageView.image = image;
	}
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
