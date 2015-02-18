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
#import "PopCustomScaleButton.h"


#define debug 1


@interface QuizViewController ()

@property (nonatomic, strong) Quiz *quiz;

@property (weak, nonatomic) IBOutlet UIView *questionContainerView;
@property (weak, nonatomic) IBOutlet UIView *answerContainerView;

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIScrollView *questionScrollView;

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel1;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel2;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel3;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel4;

@property (weak, nonatomic) IBOutlet PopCustomScaleButton *answerButton1;
@property (weak, nonatomic) IBOutlet PopCustomScaleButton *answerButton2;
@property (weak, nonatomic) IBOutlet PopCustomScaleButton *answerButton3;
@property (weak, nonatomic) IBOutlet PopCustomScaleButton *answerButton4;

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *roundLabel;
@property (weak, nonatomic) IBOutlet UILabel *slashLabel;

@end


@implementation QuizViewController
{
	NSOperationQueue *_queue;
	
	Quiz *_quiz1;
	Quiz *_quiz2;
	Quiz *_quiz3;
	Quiz *_quiz4;
	
	NSString *_soundEffect;
	
    NSInteger _currentAttempt;
	NSInteger _score;
	NSInteger _round;
}


#pragma mark - View life cycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self configureUI];
	[self addObserverForParseJSONDictionaryNotification];
	[self fetchJSONData];
    _currentAttempt = 1; //첫시도에 바로 맞춰야 득점으로 인정
	[self getScoreAndRoundDataFromNSUserDefaults];
}


#pragma mark - Get the stored NSUserDefaults data

- (void)getScoreAndRoundDataFromNSUserDefaults
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger round = [defaults integerForKey:@"_round"];
	NSLog (@"round: %ld\n", (long)round);
    
    NSInteger score = [defaults integerForKey:@"_score"];
    NSLog (@"score: %ld\n", (long)score);
	
	if (round <= 0) {
		_round = 0;
	} else if (round > 0) {
		_round = (int)round - 1;
	}
    
    if (score <= 0) {
        _score = 0;
    } else if (score > 0) {
        _score = (int)score;
    }
}


#pragma mark - Game Logic

- (void)startNewRound
{
	_round += 1;
    _currentAttempt = 1; //시도 횟수 초기화
}


- (void)startNewQuiz
{
	_score = 0;
	_round = 0;
	[self startNewRound];
}


- (void)increaseCurrentAttempt
{
    _currentAttempt += 1; //오답이면 시도 횟수 증가시킴
}


- (void)increaseScore
{
    _score += 1; //스코어 1점 증가
}


- (void)updateLabels
{
	self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)_score];
	self.slashLabel.text = @"/";
	self.roundLabel.text = [NSString stringWithFormat:@"%ld", (long)_round];
}


#pragma mark - Fetch JSON Data

- (void)fetchJSONData
{
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

- (void)addObserverForParseJSONDictionaryNotification
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveParseJSONDictionaryFinishedNotification:) name:@"ParseJSONDictionaryFinishedNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveParseJSONDictionaryFailedNotification:) name:@"ParseJSONDictionaryFailedNotification" object:nil];
}


- (void)didReceiveParseJSONDictionaryFinishedNotification:(NSNotification *)notification
{
	if ([[notification name] isEqualToString:@"ParseJSONDictionaryFinishedNotification"])
	{
		if ([_quiz1 isKindOfClass:[NSNull class]] || [_quiz2 isKindOfClass:[NSNull class]] || [_quiz3 isKindOfClass:[NSNull class]] || [_quiz4 isKindOfClass:[NSNull class]]) {
			
			[self fetchJSONData];
			
		} else {
			
			_quiz1 = self.quiz.quizArray[0];
			_quiz2 = self.quiz.quizArray[1];
			_quiz3 = self.quiz.quizArray[2];
			_quiz4 = self.quiz.quizArray[3];
			
			POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
			sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
			sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(4, 4)];
			sprintAnimation.springBounciness = 20.f;
			[self.questionLabel pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
			
			
			CGFloat duration = 0.2f;
			CGFloat alpha = 1.0f;
			
			[UIView animateWithDuration:duration animations:^{
				self.questionLabel.alpha = alpha;
				self.questionLabel.text = _quiz1.question;
			}completion:^(BOOL finished) {
				[UIView animateWithDuration:duration animations:^{
					self.answerLabel1.alpha = alpha;
					self.answerLabel1.text = _quiz1.answer;
//                    self.answerButton1.titleLabel.text = _quiz1.answer;
					NSLog (@"quiz1.correct: %@\n", _quiz1.correct);
				}completion:^(BOOL finished) {
					[UIView animateWithDuration:duration animations:^{
						self.answerLabel2.alpha = alpha;
						self.answerLabel2.text = _quiz2.answer;
//                        self.answerButton3.titleLabel.text = _quiz2.answer;
						NSLog (@"quiz2.correct: %@\n", _quiz2.correct);
					}completion:^(BOOL finished) {
						[UIView animateWithDuration:duration animations:^{
							self.answerLabel3.alpha = alpha;
							self.answerLabel3.text = _quiz3.answer;
//                            self.answerButton3.titleLabel.text = _quiz3.answer;
							NSLog (@"quiz3.correct: %@\n", _quiz3.correct);
						}completion:^(BOOL finished) {
							[UIView animateWithDuration:duration animations:^{
								self.answerLabel4.alpha = alpha;
								self.answerLabel4.text = _quiz4.answer;
//                                self.answerButton4.titleLabel.text = _quiz4.answer;
								NSLog (@"quiz4.correct: %@\n", _quiz4.correct);
							}completion:^(BOOL finished) {
								
								[self startNewRound];
								[self updateLabels];
								
								[UIView animateWithDuration:duration animations:^{
									self.scoreLabel.alpha = alpha;
									self.slashLabel.alpha = alpha;
									self.roundLabel.alpha = alpha;
								}completion:^(BOOL finished) { }];
								
								NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
								[defaults setInteger:_round forKey:@"_round"];
                                [defaults setInteger:_score forKey:@"_score"];
								[defaults synchronize];
							
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


#pragma mark - Button Action

- (IBAction)answerButtonPressed:(id)sender
{
	NSString *correct = @"정답";
	
	//정답일 때: POP Sprint Animation
	POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
	sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(10, 10)];
	sprintAnimation.springBounciness = 20.f;
	
	
	//POP Rotate Animation
	POPSpringAnimation *rotateAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
	rotateAnimation.fromValue = @(0); //@(M_PI / 4);
	rotateAnimation.toValue = @(M_PI / 4); //@(0);
	rotateAnimation.springBounciness = 20;
	rotateAnimation.velocity = @(10);
	
	
	//오답일 때: POP Shake Animation
	POPSpringAnimation *shakeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
	shakeAnimation.springBounciness = 20;
	shakeAnimation.velocity = @(1000);
	
	CGFloat delay = 1.5;
	
	if (sender == self.answerButton1) {
		if ([_quiz1.correct isEqualToString:correct]) {
			//[self.answerLabel1 pop_addAnimation:rotateAnimation forKey:@"rotateAnimation"];
			[self.answerLabel1 pop_addAnimation:sprintAnimation forKey:@"sprintAnimation"];
			[self checkToPlaySoundEffect:sender];
			[self performSelector:@selector(fetchJSONData) withObject:nil afterDelay:delay];
            if (_currentAttempt == 1) {
                [self increaseScore];
            }
		} else {
			[self.answerLabel1.layer pop_addAnimation:shakeAnimation forKey:@"shakeAnimation"];
            [self increaseCurrentAttempt];
		}
	} else if (sender == self.answerButton2) {
		if ([_quiz2.correct isEqualToString:correct]) {
			//[self.answerLabel2 pop_addAnimation:rotateAnimation forKey:@"rotateAnimation"];
			[self.answerLabel2 pop_addAnimation:sprintAnimation forKey:@"sprintAnimation"];
			[self checkToPlaySoundEffect:sender];
			[self performSelector:@selector(fetchJSONData) withObject:nil afterDelay:delay];
            if (_currentAttempt == 1) {
                [self increaseScore];
            }
		} else {
			[self.answerLabel2.layer pop_addAnimation:shakeAnimation forKey:@"shakeAnimation"];
            [self increaseCurrentAttempt];
		}
	}
	else if (sender == self.answerButton3) {
		if ([_quiz3.correct isEqualToString:correct]) {
			//[self.answerLabel3 pop_addAnimation:rotateAnimation forKey:@"rotateAnimation"];
			[self.answerLabel3 pop_addAnimation:sprintAnimation forKey:@"sprintAnimation"];
			[self checkToPlaySoundEffect:sender];
			[self performSelector:@selector(fetchJSONData) withObject:nil afterDelay:delay];
            if (_currentAttempt == 1) {
                [self increaseScore];
            }
		} else {
			[self.answerLabel3.layer pop_addAnimation:shakeAnimation forKey:@"shakeAnimation"];
            [self increaseCurrentAttempt];
		}
	}else if (sender == self.answerButton4) {
		if ([_quiz4.correct isEqualToString:correct]) {
			//[self.answerLabel4 pop_addAnimation:rotateAnimation forKey:@"rotateAnimation"];
			[self.answerLabel4 pop_addAnimation:sprintAnimation forKey:@"sprintAnimation"];
			[self checkToPlaySoundEffect:sender];
			[self performSelector:@selector(fetchJSONData) withObject:nil afterDelay:delay];
            if (_currentAttempt == 1) {
                [self increaseScore];
            }
		} else {
			[self.answerLabel4.layer pop_addAnimation:shakeAnimation forKey:@"shakeAnimation"];
            [self increaseCurrentAttempt];
		}
	}
}


#pragma mark - Get the stored NSUserDefaults data and check to play SoundEffect

- (void)checkToPlaySoundEffect:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	_soundEffect = [defaults objectForKey:@"_soundEffect"];
	NSLog (@"_soundEffect: %@\n", _soundEffect);
	
	if (_soundEffect == nil) {
		_soundEffect = @"효과음 > 켜짐";
		[self playCorrectSound:sender];
	} else if ([_soundEffect isEqualToString: @"효과음 > 켜짐"]) {
		[self playCorrectSound:sender];
	} else if ([_soundEffect isEqualToString: @"효과음 > 꺼짐"]) {
		NSLog(@"No SoundEffect");
	}
	
	NSLog (@"_soundEffect: %@\n", _soundEffect);
}


- (void)playCorrectSound:(id)sender
{
	NSString *correctPath = [[NSBundle mainBundle] pathForResource:@"correct" ofType:@"caf"];
	NSURL *correctURL = [NSURL fileURLWithPath:correctPath];
	SystemSoundID correctSoundID;
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)correctURL, &correctSoundID);
	AudioServicesPlaySystemSound(correctSoundID);
}


#pragma mark - Menu Button Action

- (IBAction)homeButtonTapped:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)nextButtonTapped:(id)sender
{
	_round -= 1;
	[self fetchJSONData];
}


#pragma mark - ConfigureUI

- (void)configureUI
{
	NSString *blank = @"";
	
	//Text
	[self.answerButton1 setTitle:blank forState:UIControlStateNormal];
	[self.answerButton2 setTitle:blank forState:UIControlStateNormal];
	[self.answerButton3 setTitle:blank forState:UIControlStateNormal];
	[self.answerButton4 setTitle:blank forState:UIControlStateNormal];
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
	UIColor *deepDarkGray = [UIColor colorWithWhite:0.090 alpha:1.000];
	UIColor *lightRed = [UIColor colorWithRed:0.993 green:0.391 blue:0.279 alpha:1.000];
	UIColor *darkBrown = [UIColor colorWithWhite:0.149 alpha:1.000];
	
	//View
	self.view.backgroundColor = whiteColor;
	self.questionContainerView.backgroundColor = whiteColor;
	self.answerContainerView.backgroundColor = whiteColor;
	self.infoView.backgroundColor = whiteColor; //[UIColor colorWithRed:0.98 green:0.97 blue:0.95 alpha:1];
	self.questionScrollView.backgroundColor = whiteColor; //[UIColor colorWithRed:0.98 green:0.97 blue:0.95 alpha:1];
	
	//Label
	self.questionLabel.textColor = deepDarkGray;
	
	self.answerLabel1.textColor = darkBrown; //whiteColor; //deepDarkGray;
	self.answerLabel2.textColor = darkBrown; //whiteColor; //deepDarkGray;
	self.answerLabel3.textColor = darkBrown; //deepDarkGray;
	self.answerLabel4.textColor = darkBrown; //deepDarkGray;
	
	self.answerLabel1.backgroundColor = clearColor;
	self.answerLabel2.backgroundColor = clearColor;
	self.answerLabel3.backgroundColor = clearColor;
	self.answerLabel4.backgroundColor = clearColor;
	
	//Button
	UIColor *colorNormal1 = [UIColor colorWithRed:0.72 green:0.93 blue:1 alpha:1];
	UIColor *colorNormal2 = [UIColor colorWithRed:0.52 green:0.85 blue:0.98 alpha:1];
	UIColor *colorNormal3 = [UIColor colorWithRed:0.2 green:0.69 blue:0.86 alpha:1];
	UIColor *colorNormal4 = [UIColor colorWithRed:0.16 green:0.55 blue:0.69 alpha:1];
	UIColor *colorHighlight = [UIColor colorWithRed:0.6 green:0.83 blue:0.84 alpha:1]; //[UIColor colorWithRed:1 green:0.73 blue:0.12 alpha:1];
	
	self.answerButton1.backgroundColor = colorNormal1;
	self.answerButton2.backgroundColor = colorNormal2;
	self.answerButton3.backgroundColor = colorNormal3;
	self.answerButton4.backgroundColor = colorNormal4;
	
	self.answerButton1.backgroundColorNormal = colorNormal1;
	self.answerButton1.backgroundColorHighlight = colorHighlight;
	self.answerButton2.backgroundColorNormal = colorNormal2;
	self.answerButton2.backgroundColorHighlight = colorHighlight;
	self.answerButton3.backgroundColorNormal = colorNormal3;
	self.answerButton3.backgroundColorHighlight = colorHighlight;
	self.answerButton4.backgroundColorNormal = colorNormal4;
	self.answerButton4.backgroundColorHighlight = colorHighlight;
	
	
	//Info View Buttons
	UIImage *menuImageNormal = [UIImage imageForChangingColor:@"menu" color:darkBrown];
	UIImage *menuImageHighlight = [UIImage imageForChangingColor:@"menu" color:lightRed];
	[self.menuButton setImage:menuImageNormal forState:UIControlStateNormal];
	[self.menuButton setImage:menuImageHighlight forState:UIControlStateHighlighted];
	
	UIImage *settingsImageNormal = [UIImage imageForChangingColor:@"arrow-right" color:darkBrown];
	UIImage *settingsImageHighlight = [UIImage imageForChangingColor:@"arrow-right" color:lightRed];
	[self.nextButton setImage:settingsImageNormal forState:UIControlStateNormal];
	[self.nextButton setImage:settingsImageHighlight forState:UIControlStateHighlighted];
}


#pragma mark - Dealloc

- (void)dealloc
{
	NSLog(@"dealloc %@", self);
}


















@end
