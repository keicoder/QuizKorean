//
//  ViewController.m
//  QuizKorean
//
//  Created by jun on 2/10/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "QuizViewController.h"
#import "AFNetworking.h"
#import "Quiz.h"
#import "MenuViewController.h"
#import "POP.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIImage+ChangeColor.h"
#import "PopView.h"
#import "CustomDraggableModalTransitionAnimator.h"
#import "ProgressViewController.h"
#import "InspectionViewController.h"
#import "SettingsViewController.h"


#define debug 1

#define kIconImageForCorrectAnswer		[UIImage imageNamed:@"correctSimple"]
#define kIconImageForFalseAnswer		[UIImage imageNamed:@"falseSimple"]

#define kColorForViewNormal				[UIColor colorWithRed:0.3 green:0.58 blue:0.75 alpha:1]
#define kColorforViewHighlight			[UIColor colorWithRed:0.6 green:0.83 blue:0.84 alpha:1]

#define kColorForIconViewNormal1		[UIColor colorWithRed:0.57 green:0.77 blue:0.47 alpha:1]
#define kColorForIconViewNormal2		[UIColor colorWithRed:0.45 green:0.78 blue:0.82 alpha:1]
#define kColorForIconViewNormal3		[UIColor colorWithRed:0.87 green:0.86 blue:0.42 alpha:1]
#define kColorForIconViewNormal4		[UIColor colorWithRed:0.4 green:0.67 blue:0.82 alpha:1]
#define kColorForIconViewHighlight		[UIColor colorWithRed:0.465 green:0.641 blue:0.653 alpha:1.000]

#define kColorForImageViewWhenCorrect	[UIColor colorWithRed:0.127 green:0.456 blue:0.147 alpha:1.000]
#define kColorForViewWhenCorrect		[UIColor colorWithRed:0.19 green:0.67 blue:0.22 alpha:1]

#define kIconViewWidthIpadNormal	30
#define kIconViewWidthIpadExpand	80
#define kIconViewWidthIphoneNormal	10
#define kIconViewWidthIphoneExpand	50


@interface QuizViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) Quiz *quiz;
@property (nonatomic, assign) NSUInteger indexOfCorrectAnswer;
@property (nonatomic, assign) BOOL didSelectCorrectAnswer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UIView *questionContainerView;

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *roundLabel;
@property (weak, nonatomic) IBOutlet UILabel *slashLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *questionScrollView;
@property (weak, nonatomic) IBOutlet UIView *questionView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@property (weak, nonatomic) IBOutlet UIView *answerContainerView;

@property (weak, nonatomic) IBOutlet PopView *answerView1;
@property (weak, nonatomic) IBOutlet PopView *answerView2;
@property (weak, nonatomic) IBOutlet PopView *answerView3;
@property (weak, nonatomic) IBOutlet PopView *answerView4;

@property (weak, nonatomic) IBOutlet UILabel *answerLabel1;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel2;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel3;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel4;

@property (weak, nonatomic) IBOutlet PopView *iconView1;
@property (weak, nonatomic) IBOutlet PopView *iconView2;
@property (weak, nonatomic) IBOutlet PopView *iconView3;
@property (weak, nonatomic) IBOutlet PopView *iconView4;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView4;

@property (nonatomic, strong) CustomDraggableModalTransitionAnimator *animator;

@end


@implementation QuizViewController
{
	NSOperationQueue *_queue;
	
	Quiz *_quiz1;
	Quiz *_quiz2;
	Quiz *_quiz3;
	Quiz *_quiz4;
	
	NSString *_soundEffect;
    BOOL _canPlaySoundEffect;
}


#pragma mark - View life cycle

- (void)viewDidLoad
{
	[super viewDidLoad];
    [self allowUserInteraction:YES];
    [self configureUI];
	[self addNotificationObserverForParseJSONAndAdjustIconViewWidth];
	[self fetchJSONData];
    [self addTapGestureOnTheView:self.answerView1];
    [self addTapGestureOnTheView:self.answerView2];
    [self addTapGestureOnTheView:self.answerView3];
    [self addTapGestureOnTheView:self.answerView4];
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self setIconViewImageToNil];
	[self getScoreAndRoundDataFromNSUserDefaults];
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		[self adjustIconViewWidth:kIconViewWidthIpadNormal];
	} else {
		[self adjustIconViewWidth:kIconViewWidthIphoneNormal];
	}
}


#pragma mark - Get the stored NSUserDefaults data

- (void)getScoreAndRoundDataFromNSUserDefaults
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	self.round = [defaults integerForKey:@"round"];
	NSLog (@"self.round: %ld\n", (long)self.round);
	
	self.score = [defaults integerForKey:@"score"];
	NSLog (@"self.score: %ld\n", (long)self.score);
}


#pragma mark - Game Logic

- (void)updateUIAndFetchJSONData
{
	[self setIconViewImageToNil];
	[self changeColorOfViewToNormal];
	[self fetchJSONData];
}


- (void)updateRoundAndScore
{
	self.round += 1;
	
	if (self.didSelectCorrectAnswer == YES) {
		self.score += 1;
    }
}


#pragma mark - Fetch JSON Data

- (void)fetchJSONData
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		[self adjustIconViewWidth:kIconViewWidthIpadNormal];
	} else {
		[self adjustIconViewWidth:kIconViewWidthIphoneNormal];
	}
	
    [self allowUserInteraction:YES];
    
	self.quiz = [[Quiz alloc] init];
	
	CGFloat duration = 0.1f;
	CGFloat alpha = 0.0f;
	
	[UIView animateWithDuration:duration animations:^{
		
		self.questionLabel.alpha = alpha;
		self.answerLabel1.alpha = alpha;
		self.answerLabel2.alpha = alpha;
		self.answerLabel3.alpha = alpha;
		self.answerLabel4.alpha = alpha;
		
		self.scoreLabel.alpha = alpha;
		self.slashLabel.alpha = alpha;
		self.roundLabel.alpha = alpha;
		
	}completion:^(BOOL finished) {
		
		[self.quiz fetchJSON];
	}];
	
}


#pragma mark - Listening Notification

- (void)addNotificationObserverForParseJSONAndAdjustIconViewWidth
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveParseJSONDictionaryFinishedNotification:) name:@"ParseJSONDictionaryFinishedNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveParseJSONDictionaryFailedNotification:) name:@"ParseJSONDictionaryFailedNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAdjustIconViewWidth:) name:@"DidAdjustIconViewWidthNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTappedDismissButton:) name:@"DidTappedDismissButtonNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTappedSettingsButton:) name:@"DidTappedSettingsButtonNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTappedMenuButton:) name:@"DidTappedMenuButtonNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTappedNextButton:) name:@"DidTappedNextButtonNotification" object:nil];
}


- (void)didReceiveParseJSONDictionaryFinishedNotification:(NSNotification *)notification
{
	if ([[notification name] isEqualToString:@"ParseJSONDictionaryFinishedNotification"])
	{
		if ([_quiz1 isKindOfClass:[NSNull class]] || [_quiz2 isKindOfClass:[NSNull class]] || [_quiz3 isKindOfClass:[NSNull class]] || [_quiz4 isKindOfClass:[NSNull class]]) {
			[self fetchJSONData];
			
        } else if (!(self.quiz.quizArray[0] || !self.quiz.quizArray[1] || !self.quiz.quizArray[2] || !self.quiz.quizArray[3])) {
            [self fetchJSONData];
        
		} else if (![self.quiz.quizArray[0] isKindOfClass:[Quiz class]] || ![self.quiz.quizArray[1] isKindOfClass:[Quiz class]] || ![self.quiz.quizArray[2] isKindOfClass:[Quiz class]] || ![self.quiz.quizArray[3] isKindOfClass:[Quiz class]]){
                [self fetchJSONData];
        } else {
			_quiz1 = self.quiz.quizArray[0];
			_quiz2 = self.quiz.quizArray[1];
			_quiz3 = self.quiz.quizArray[2];
			_quiz4 = self.quiz.quizArray[3];
			
			POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
			sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
			sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(7, 7)];
			sprintAnimation.springBounciness = 20.0f;
			[self.questionScrollView pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
			
			
			CGFloat duration = 0.2f;
			CGFloat alpha = 1.0f;
			
			[UIView animateWithDuration:duration animations:^{
				
				self.questionLabel.alpha = alpha;
				self.questionLabel.text = _quiz1.question;
				
			}completion:^(BOOL finished) {
				
				[UIView animateWithDuration:duration animations:^{
					
					self.answerLabel1.alpha = alpha;
					self.answerLabel1.text = _quiz1.answer;
					NSLog (@"quiz1.correct: %@\n", _quiz1.correct);
					
				}completion:^(BOOL finished) {
					
					[UIView animateWithDuration:duration animations:^{
						
						self.answerLabel2.alpha = alpha;
						self.answerLabel2.text = _quiz2.answer;
						NSLog (@"quiz2.correct: %@\n", _quiz2.correct);
						
					}completion:^(BOOL finished) {
						
						[UIView animateWithDuration:duration animations:^{
							
							self.answerLabel3.alpha = alpha;
							self.answerLabel3.text = _quiz3.answer;
							NSLog (@"quiz3.correct: %@\n", _quiz3.correct);
							
						}completion:^(BOOL finished) {
							
							[UIView animateWithDuration:duration animations:^{
								
								self.answerLabel4.alpha = alpha;
								self.answerLabel4.text = _quiz4.answer;
								NSLog (@"quiz4.correct: %@\n", _quiz4.correct);
								
							}completion:^(BOOL finished) {
								
								[UIView animateWithDuration:duration animations:^{
									
									self.scoreLabel.alpha = alpha;
									self.slashLabel.alpha = alpha;
									self.roundLabel.alpha = alpha;
									
								}completion:^(BOOL finished) { }];
							}];
						}];
					}];
				}];
			}];
		}
	}
}


- (void)didReceiveParseJSONDictionaryFailedNotification:(NSNotification *)notification
{
	if ([[notification name] isEqualToString:@"ParseJSONDictionaryFailedNotification"])
	{
		NSString *title = @"접속 오류";
		NSString *message = @"인터넷 연결을 확인해 주세요.";
		
		UIAlertController *sheet = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
		[sheet addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^void (UIAlertAction *action) {
			NSLog(@"Tapped OK");
		}]];
		
		sheet.popoverPresentationController.sourceView = self.view;
		sheet.popoverPresentationController.sourceRect = self.view.frame;
		
		[self presentViewController:sheet animated:YES completion:nil];
	}
}



#pragma mark - Get the stored NSUserDefaults data and check to play SoundEffect

- (BOOL)checkToCanPlaySoundEffect
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	_soundEffect = [defaults objectForKey:@"_soundEffect"];
	
	if (_soundEffect == nil) {
		
		_soundEffect = @"효과음 > 켜짐";
		_canPlaySoundEffect = YES;
		
	} else if ([_soundEffect isEqualToString: @"효과음 > 켜짐"]) {
		
		_canPlaySoundEffect = YES;
		
	} else if ([_soundEffect isEqualToString: @"효과음 > 꺼짐"]) {
		
		_canPlaySoundEffect = NO;
	}
	
	return _canPlaySoundEffect;
}


- (void)playSound
{
	if (_canPlaySoundEffect == YES) {
		
		if (self.didSelectCorrectAnswer == YES) {
			NSString *path = [[NSBundle mainBundle] pathForResource:@"correct" ofType:@"caf"];
			NSURL *URL = [NSURL fileURLWithPath:path];
			SystemSoundID soundID;
			AudioServicesCreateSystemSoundID((__bridge CFURLRef)URL, &soundID);
			AudioServicesPlaySystemSound(soundID);
			
		} else {
			
			NSString *path = [[NSBundle mainBundle] pathForResource:@"ding" ofType:@"caf"];
			NSURL *URL = [NSURL fileURLWithPath:path];
			SystemSoundID soundID;
			AudioServicesCreateSystemSoundID((__bridge CFURLRef)URL, &soundID);
			AudioServicesPlaySystemSound(soundID);
		}
	}
}


#pragma mark - Menu Button Action

- (IBAction)homeButtonTapped:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)settingsButtonTapped:(id)sender
{
	SettingsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
	[self showViewController:controller sender:nil];
}


#pragma mark - Tap gesture on the View

- (void)addTapGestureOnTheView:(UIView *)aView
{
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureViewTapped:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    gestureRecognizer.delegate = self;
    
    [aView addGestureRecognizer:gestureRecognizer];
}


#pragma mark - 정답/오답 버튼 액션

- (void)gestureViewTapped:(UITouch *)touch
{
	[self allowUserInteraction:NO];
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		[self adjustIconViewWidth:kIconViewWidthIpadExpand];
	} else {
		[self adjustIconViewWidth:kIconViewWidthIphoneExpand];
	}
	
    NSString *correct = @"정답";
    
    self.indexOfCorrectAnswer = 0;
	
    if ([_quiz1.correct isEqualToString:correct]) {
        self.indexOfCorrectAnswer = 1;
    } else if ([_quiz2.correct isEqualToString:correct]) {
        self.indexOfCorrectAnswer = 2;
    } else if ([_quiz3.correct isEqualToString:correct]) {
        self.indexOfCorrectAnswer = 3;
    } else if ([_quiz4.correct isEqualToString:correct]) {
        self.indexOfCorrectAnswer = 4;
    }
    
    NSLog (@"self.indexOfCorrectAnswer: %ld\n", (unsigned long)self.indexOfCorrectAnswer);
	
	self.didSelectCorrectAnswer = NO; //초기화
	
	[self checkToCanPlaySoundEffect]; //Return BOOL value _canPlaySoundEffect
	
	if ([touch.view isEqual:(UIView *)self.answerView1]) {
		NSLog(@"self.answerView1 Tapped");
		
		if ([_quiz1.correct isEqualToString:correct]) {
			self.didSelectCorrectAnswer = YES;
		}
		
	} else if ([touch.view isEqual:(UIView *)self.answerView2]) {
		
		NSLog(@"self.answerView2 Tapped");
		
		if ([_quiz2.correct isEqualToString:correct]) {
			self.didSelectCorrectAnswer = YES;
		}
		
	} else if ([touch.view isEqual:(UIView *)self.answerView3]) {
		NSLog(@"self.answerView3 Tapped");
		
		if ([_quiz3.correct isEqualToString:correct]) {
			self.didSelectCorrectAnswer = YES;
		}
		
	} else if ([touch.view isEqual:(UIView *)self.answerView4]) {
		NSLog(@"self.answerView4 Tapped");
		
		if ([_quiz4.correct isEqualToString:correct]) {
			self.didSelectCorrectAnswer = YES;
		}
	}
	
	[self updateRoundAndScore];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:self.round forKey:@"round"];
	[defaults setInteger:self.score forKey:@"score"];
	[defaults synchronize];
	
	[self performSelector:@selector(playSound) withObject:nil afterDelay:0.7];
	[self performSelector:@selector(showInspectionOrProgressView) withObject:nil afterDelay:0.5];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self.answerView1 || touch.view == self.answerView2 || touch.view == self.answerView3 || touch.view == self.answerView4) {
        return YES;
    }
    
    return NO;
}


#pragma mark - 중간 점검 화면

- (void)showInspectionOrProgressView
{
	if (self.round % 5 == 0) {
		
		ProgressViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ProgressViewController"];
		
		controller.modalPresentationStyle = UIModalPresentationCustom;
		
		self.animator = [[CustomDraggableModalTransitionAnimator alloc] initWithModalViewController:controller];
		self.animator.dragable = NO;
		self.animator.bounces = YES;
		self.animator.behindViewAlpha = 0.88f;
		self.animator.behindViewScale = 1.0f; //0.92f;
		self.animator.transitionDuration = 0.5f;
		self.animator.direction = ModalTransitonDirectionBottom;
		
		controller.transitioningDelegate = self.animator;
		
		[self presentViewController:controller animated:YES completion:nil];
		
	} else {
		
		InspectionViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"InspectionViewController"];
		
		controller.modalPresentationStyle = UIModalPresentationCustom;
		
		self.animator = [[CustomDraggableModalTransitionAnimator alloc] initWithModalViewController:controller];
		self.animator.dragable = NO;
		self.animator.bounces = YES;
		self.animator.behindViewAlpha = 0.88f;
		self.animator.behindViewScale = 1.0f; //0.92f;
		self.animator.transitionDuration = 0.5f;
		self.animator.direction = ModalTransitonDirectionLeft;
		
		controller.transitioningDelegate = self.animator;
		
		controller.didSelectCorrectAnswer = self.didSelectCorrectAnswer;
		
		[self presentViewController:controller animated:YES completion:^{ }];
	}
}


#pragma mark notification call-back action

- (void)didTappedDismissButton:(NSNotification *)notification
{
	if ([[notification name] isEqualToString:@"DidTappedDismissButtonNotification"])
	{
		[self updateUIAndFetchJSONData];
	}
}


- (void)didTappedSettingsButton:(NSNotification *)notification
{
	if ([[notification name] isEqualToString:@"DidTappedSettingsButtonNotification"])
	{
		[self updateUIAndFetchJSONData];
		[self settingsButtonTapped:self];
	}
}


- (void)didTappedMenuButton:(NSNotification *)notification
{
	if ([[notification name] isEqualToString:@"DidTappedMenuButtonNotification"])
	{
		[self updateUIAndFetchJSONData];
		[self homeButtonTapped:self];
	}
}


- (void)didTappedNextButton:(NSNotification *)notification
{
	if ([[notification name] isEqualToString:@"DidTappedNextButtonNotification"])
	{
		[self updateUIAndFetchJSONData];
	}
}


#pragma mark - Show icon when user touches answer

- (void)adjustIconViewWidth:(CGFloat)width
{
	self.iconViewWidthConstraint.constant = width;
	
	CGFloat duration = 0.3f;
	CGFloat delay = 0.3f;
	[UIView animateWithDuration:duration delay:delay options: UIViewAnimationOptionCurveEaseInOut animations:^{
		
		[self.view layoutIfNeeded];
		
	} completion:^(BOOL finished) {
	
		if (self.iconViewWidthConstraint.constant >= kIconViewWidthIphoneExpand) {
			
			//Post a notification when done adjusting icon view width
			[[NSNotificationCenter defaultCenter] postNotificationName: @"DidAdjustIconViewWidthNotification" object:nil userInfo:nil];
		}
	}];
}


- (void)didAdjustIconViewWidth:(NSNotification *)notification
{
	if ([[notification name] isEqualToString:@"DidAdjustIconViewWidthNotification"])
	{
		CGFloat duration = 0.25f;
		
		[UIView animateWithDuration:duration delay:0.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
			
			[self showIconImageAtIndexAndChangeColorOfView:self.indexOfCorrectAnswer];
			
		} completion:^(BOOL finished) { }];
	}
}


- (void)showIconImageAtIndexAndChangeColorOfView:(NSUInteger)index
{
    switch (index) {
        case 1:
			self.iconImageView1.image = kIconImageForCorrectAnswer;
//			self.iconImageView2.image = kIconImageForFalseAnswer;
//			self.iconImageView3.image = kIconImageForFalseAnswer;
//			self.iconImageView4.image = kIconImageForFalseAnswer;
			[self changeColorOfViewWhenCorrect:self.iconView1 withColor:kColorForImageViewWhenCorrect];
			[self changeColorOfViewWhenCorrect:self.answerView1 withColor:kColorForViewWhenCorrect];
            break;
			
        case 2:
//			self.iconImageView1.image = kIconImageForFalseAnswer;
			self.iconImageView2.image = kIconImageForCorrectAnswer;
//			self.iconImageView3.image = kIconImageForFalseAnswer;
//			self.iconImageView4.image = kIconImageForFalseAnswer;
			[self changeColorOfViewWhenCorrect:self.iconView2 withColor:kColorForImageViewWhenCorrect];
			[self changeColorOfViewWhenCorrect:self.answerView2 withColor:kColorForViewWhenCorrect];
            break;
            
        case 3:
//			self.iconImageView1.image = kIconImageForFalseAnswer;
//			self.iconImageView2.image = kIconImageForFalseAnswer;
			self.iconImageView3.image = kIconImageForCorrectAnswer;
//			self.iconImageView4.image = kIconImageForFalseAnswer;
			[self changeColorOfViewWhenCorrect:self.iconView3 withColor:kColorForImageViewWhenCorrect];
			[self changeColorOfViewWhenCorrect:self.answerView3 withColor:kColorForViewWhenCorrect];
            break;
			
        case 4:
//			self.iconImageView1.image = kIconImageForFalseAnswer;
//			self.iconImageView2.image = kIconImageForFalseAnswer;
//			self.iconImageView3.image = kIconImageForFalseAnswer;
			self.iconImageView4.image = kIconImageForCorrectAnswer;
			[self changeColorOfViewWhenCorrect:self.iconView4 withColor:kColorForImageViewWhenCorrect];
			[self changeColorOfViewWhenCorrect:self.answerView4 withColor:kColorForViewWhenCorrect];
            break;
			
        default:
            break;
    }
}


- (void)allowUserInteraction:(BOOL)userInteraction
{
    self.answerView1.userInteractionEnabled = userInteraction;
    self.answerView2.userInteractionEnabled = userInteraction;
    self.answerView3.userInteractionEnabled = userInteraction;
    self.answerView4.userInteractionEnabled = userInteraction;
}


- (void)setIconViewImageToNil
{
	self.iconImageView1.image = nil;
	self.iconImageView2.image = nil;
	self.iconImageView3.image = nil;
	self.iconImageView4.image = nil;
}


#pragma mark - Change color of view when correct or start new round

- (void)changeColorOfViewWhenCorrect:(PopView *)view withColor:(UIColor *)color
{
	view.backgroundColor = color;
	view.backgroundColorNormal = color;
}


- (void)changeColorOfViewToNormal
{
	[self changeColorOfViewWhenCorrect:self.iconView1 withColor:kColorForIconViewNormal1];
	[self changeColorOfViewWhenCorrect:self.answerView1 withColor:kColorForViewNormal];
	[self changeColorOfViewWhenCorrect:self.iconView2 withColor:kColorForIconViewNormal2];
	[self changeColorOfViewWhenCorrect:self.answerView2 withColor:kColorForViewNormal];
	[self changeColorOfViewWhenCorrect:self.iconView3 withColor:kColorForIconViewNormal3];
	[self changeColorOfViewWhenCorrect:self.answerView3 withColor:kColorForViewNormal];
	[self changeColorOfViewWhenCorrect:self.iconView4 withColor:kColorForIconViewNormal4];
	[self changeColorOfViewWhenCorrect:self.answerView4 withColor:kColorForViewNormal];
}


#pragma mark - ConfigureUI

- (void)configureUI
{	
	NSString *blank = @"";
	
    //Label Text
    self.questionLabel.text = blank;
	
    self.answerLabel1.text = blank;
	self.answerLabel2.text = blank;
	self.answerLabel3.text = blank;
	self.answerLabel4.text = blank;
	
	self.scoreLabel.text = blank;
	self.slashLabel.text = blank;
	self.roundLabel.text = blank;
	
	//Color
	UIColor *whiteColor = [UIColor whiteColor];
	UIColor *clearColor = [UIColor clearColor];
	UIColor *lightRed = [UIColor colorWithRed:0.993 green:0.391 blue:0.279 alpha:1.000];
	UIColor *darkBrown = [UIColor colorWithWhite:0.149 alpha:1.000];
	
	//View
    CGFloat questionViewCornerRadius = 12.0;
    
	self.view.backgroundColor = whiteColor;
    self.questionContainerView.backgroundColor = [UIColor colorWithRed:1 green:0.96 blue:0.93 alpha:1];
	self.answerContainerView.backgroundColor = clearColor;
	
	self.infoView.backgroundColor = self.answerContainerView.backgroundColor;
	
	self.questionScrollView.backgroundColor = clearColor;
	self.questionView.backgroundColor = clearColor;
    self.questionView.layer.cornerRadius = questionViewCornerRadius;
	
	//Label
	self.questionLabel.textColor = darkBrown; //whiteColor; //darkBrown;
	self.answerLabel1.textColor = whiteColor;
	self.answerLabel2.textColor = whiteColor;
	self.answerLabel3.textColor = whiteColor;
	self.answerLabel4.textColor = whiteColor;
	
    self.questionLabel.backgroundColor = clearColor;
	self.answerLabel1.backgroundColor = clearColor;
	self.answerLabel2.backgroundColor = clearColor;
	self.answerLabel3.backgroundColor = clearColor;
	self.answerLabel4.backgroundColor = clearColor;
	
	//Answer View Color
	self.answerView1.backgroundColor = kColorForViewNormal;
    self.answerView2.backgroundColor = kColorForViewNormal;
    self.answerView3.backgroundColor = kColorForViewNormal;
    self.answerView4.backgroundColor = kColorForViewNormal;
    
    self.answerView1.backgroundColorNormal = kColorForViewNormal;
    self.answerView1.backgroundColorHighlight = kColorforViewHighlight;
    self.answerView2.backgroundColorNormal = kColorForViewNormal;
    self.answerView2.backgroundColorHighlight = kColorforViewHighlight;
    self.answerView3.backgroundColorNormal = kColorForViewNormal;
    self.answerView3.backgroundColorHighlight = kColorforViewHighlight;
    self.answerView4.backgroundColorNormal = kColorForViewNormal;
    self.answerView4.backgroundColorHighlight = kColorforViewHighlight;
	
    CGFloat answerViewCornerRadius = 7.0;
    self.answerView1.layer.cornerRadius = answerViewCornerRadius;
    self.answerView2.layer.cornerRadius = answerViewCornerRadius;
    self.answerView3.layer.cornerRadius = answerViewCornerRadius;
    self.answerView4.layer.cornerRadius = answerViewCornerRadius;
	
    //Icon View Color
	self.iconView1.backgroundColor = kColorForIconViewNormal1;
    self.iconView2.backgroundColor = kColorForIconViewNormal2;
    self.iconView3.backgroundColor = kColorForIconViewNormal3;
    self.iconView4.backgroundColor = kColorForIconViewNormal4;
	
	self.iconView1.backgroundColorNormal = kColorForIconViewNormal1;
	self.iconView1.backgroundColorHighlight = kColorForIconViewHighlight;
	self.iconView2.backgroundColorNormal = kColorForIconViewNormal2;
	self.iconView2.backgroundColorHighlight = kColorForIconViewHighlight;
	self.iconView3.backgroundColorNormal = kColorForIconViewNormal3;
	self.iconView3.backgroundColorHighlight = kColorForIconViewHighlight;
	self.iconView4.backgroundColorNormal = kColorForIconViewNormal4;
	self.iconView4.backgroundColorHighlight = kColorForIconViewHighlight;
	
	//Info View Buttons
	UIImage *menuImageNormal = [UIImage imageForChangingColor:@"menu" color:darkBrown];
	UIImage *menuImageHighlight = [UIImage imageForChangingColor:@"menu" color:lightRed];
	[self.menuButton setImage:menuImageNormal forState:UIControlStateNormal];
	[self.menuButton setImage:menuImageHighlight forState:UIControlStateHighlighted];
	
	UIImage *settingsImageNormal = [UIImage imageForChangingColor:@"settings" color:darkBrown];
	UIImage *settingsImageHighlight = [UIImage imageForChangingColor:@"settings" color:lightRed];
	[self.settingsButton setImage:settingsImageNormal forState:UIControlStateNormal];
	[self.settingsButton setImage:settingsImageHighlight forState:UIControlStateHighlighted];
}


#pragma mark - Dealloc

- (void)dealloc
{
	NSLog(@"dealloc %@", self);
}


@end