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


#define debug 1

#define kIconImageForCorrectAnswer [UIImage imageNamed:@"correctSimple"]
#define kIconImageForFalseAnswer   [UIImage imageNamed:@"falseSimple"]


@interface QuizViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) Quiz *quiz;
@property (nonatomic, assign) NSUInteger indexOfCorrectAnswer;

@property (weak, nonatomic) IBOutlet UIView *questionContainerView;

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
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

@property (weak, nonatomic) IBOutlet UIView *iconView1;
@property (weak, nonatomic) IBOutlet UIView *iconView2;
@property (weak, nonatomic) IBOutlet UIView *iconView3;
@property (weak, nonatomic) IBOutlet UIView *iconView4;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView4;

@end


@implementation QuizViewController
{
	NSOperationQueue *_queue;
	
	Quiz *_quiz1;
	Quiz *_quiz2;
	Quiz *_quiz3;
	Quiz *_quiz4;
	
	NSString *_soundEffect;
    
	NSInteger _score;
	NSInteger _round;
}


#pragma mark - View life cycle

- (void)viewDidLoad
{
	[super viewDidLoad];
    [self allowUserInteraction:YES];
    [self configureUI];
	[self addObserverForParseJSONDictionaryNotification];
	[self fetchJSONData];
	[self getScoreAndRoundDataFromNSUserDefaults];
    [self addTapGestureOnTheView:self.answerView1];
    [self addTapGestureOnTheView:self.answerView2];
    [self addTapGestureOnTheView:self.answerView3];
    [self addTapGestureOnTheView:self.answerView4];
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
		_round = -1;
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
    [self setDefaultIcon:NO];
    
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
			
        } else if (!(self.quiz.quizArray[0] || self.quiz.quizArray[1] || self.quiz.quizArray[2] || self.quiz.quizArray[3])) {
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
                                
                                [self setDefaultIcon:YES];
							
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

- (void)checkToPlaySoundEffect
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	_soundEffect = [defaults objectForKey:@"_soundEffect"];
	NSLog (@"_soundEffect: %@\n", _soundEffect);
	
	if (_soundEffect == nil) {
		_soundEffect = @"효과음 > 켜짐";
		[self playCorrectSound];
	} else if ([_soundEffect isEqualToString: @"효과음 > 켜짐"]) {
		[self playCorrectSound];
	} else if ([_soundEffect isEqualToString: @"효과음 > 꺼짐"]) {
		NSLog(@"No SoundEffect");
	}
	
	NSLog (@"_soundEffect: %@\n", _soundEffect);
}


- (void)playCorrectSound
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


#pragma mark - Tap gesture on the View

- (void)addTapGestureOnTheView:(UIView *)aView
{
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureViewTapped:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    gestureRecognizer.delegate = self;
    
    [aView addGestureRecognizer:gestureRecognizer];
}


#pragma mark 정답/오답 버튼 액션

- (void)gestureViewTapped:(UITouch *)touch
{
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
    
    CGFloat delay = 1.0;
    CGFloat duration = 1.0;
    
    if ([touch.view isEqual:(UIView *)self.answerView1]) {
        NSLog(@"self.answerView1 Tapped");
        
        if ([_quiz1.correct isEqualToString:correct]) {
            
            [self checkToPlaySoundEffect];
            [self increaseScore];
            NSLog(@"Correct : You earned score");
            [self showIconAtIndex:self.indexOfCorrectAnswer delay:delay duration:duration];
            [self updateLabels];
            
        } else {
            
            NSLog(@"No, try again");
            [self showIconAtIndex:self.indexOfCorrectAnswer delay:delay duration:duration];
        }
        
    } else if ([touch.view isEqual:(UIView *)self.answerView2]) {
        
        NSLog(@"self.answerView2 Tapped");
        
        if ([_quiz2.correct isEqualToString:correct]) {
            
            [self checkToPlaySoundEffect];
            [self increaseScore];
            NSLog(@"Correct : You earned score");
            [self showIconAtIndex:self.indexOfCorrectAnswer delay:delay duration:duration];
            [self updateLabels];
            
        } else {
            
            NSLog(@"No, try again");
            [self showIconAtIndex:self.indexOfCorrectAnswer delay:delay duration:duration];
        }
        
    } else if ([touch.view isEqual:(UIView *)self.answerView3]) {
        NSLog(@"self.answerView3 Tapped");
        
        if ([_quiz3.correct isEqualToString:correct]) {
            
            [self checkToPlaySoundEffect];
            [self increaseScore];
            NSLog(@"Correct : You earned score");
            [self showIconAtIndex:self.indexOfCorrectAnswer delay:delay duration:duration];
            [self updateLabels];
            
        } else {
            
            NSLog(@"No, try again");
            [self showIconAtIndex:self.indexOfCorrectAnswer delay:delay duration:duration];
        }
        
    } else if ([touch.view isEqual:(UIView *)self.answerView4]) {
        NSLog(@"self.answerView4 Tapped");
        
        if ([_quiz4.correct isEqualToString:correct]) {
            
            [self checkToPlaySoundEffect];
            [self increaseScore];
            NSLog(@"Correct : You earned score");
            [self showIconAtIndex:self.indexOfCorrectAnswer delay:delay duration:duration];
            [self updateLabels];
            
        } else {
            
            NSLog(@"No, try again");
            [self showIconAtIndex:self.indexOfCorrectAnswer delay:delay duration:duration];
        }
    }
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self.answerView1 || touch.view == self.answerView2 || touch.view == self.answerView3 || touch.view == self.answerView4) {
        return YES;
    }
    
    return NO;
}


#pragma mark - Show icon when user touches answer

- (void)showIconAtIndex:(NSUInteger)index delay:(CGFloat)delay duration:(CGFloat)duration
{
    [self allowUserInteraction:NO];
    
    index = self.indexOfCorrectAnswer;
    
    switch (index) {
        case 1: {
            [UIView animateWithDuration:duration delay:delay options: UIViewAnimationOptionCurveEaseInOut animations:^{
                self.iconImageView1.image = kIconImageForCorrectAnswer;
                self.iconImageView2.image = kIconImageForFalseAnswer;
                self.iconImageView3.image = kIconImageForFalseAnswer;
                self.iconImageView4.image = kIconImageForFalseAnswer;
            }completion:^(BOOL finished) { }]; }
            break;
            
        case 2: {
            [UIView animateWithDuration:duration delay:delay options: UIViewAnimationOptionCurveEaseInOut animations:^{
                self.iconImageView1.image = kIconImageForFalseAnswer;
                self.iconImageView2.image = kIconImageForCorrectAnswer;
                self.iconImageView3.image = kIconImageForFalseAnswer;
                self.iconImageView4.image = kIconImageForFalseAnswer;
            }completion:^(BOOL finished) {
                
                [UIView animateWithDuration:duration animations:^{
                    
                }completion:^(BOOL finished) { }];
                
            }]; }
            break;
            
        case 3: {
            [UIView animateWithDuration:duration delay:delay options: UIViewAnimationOptionCurveEaseInOut animations:^{
                self.iconImageView1.image = kIconImageForFalseAnswer;
                self.iconImageView2.image = kIconImageForFalseAnswer;
                self.iconImageView3.image = kIconImageForCorrectAnswer;
                self.iconImageView4.image = kIconImageForFalseAnswer;
            }completion:^(BOOL finished) {
                
                [UIView animateWithDuration:duration animations:^{
                    
                }completion:^(BOOL finished) { }];
                
            }]; }
            break;
            
        case 4: {
            [UIView animateWithDuration:duration delay:delay options: UIViewAnimationOptionCurveEaseInOut animations:^{
                self.iconImageView1.image = kIconImageForFalseAnswer;
                self.iconImageView2.image = kIconImageForFalseAnswer;
                self.iconImageView3.image = kIconImageForFalseAnswer;
                self.iconImageView4.image = kIconImageForCorrectAnswer;
            }completion:^(BOOL finished) {
                
                [UIView animateWithDuration:duration animations:^{
                    
                }completion:^(BOOL finished) { }];
                
            }]; }
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


- (void)setDefaultIcon:(BOOL)deFaultIcon
{
    UIColor *color = [UIColor whiteColor]; //[UIColor colorWithRed:0.3 green:0.58 blue:0.75 alpha:1];
    UIImage *image = [UIImage imageForChangingColor:@"polygon" color:color];
    
    if (deFaultIcon == YES) {
        self.iconImageView1.image = image;
        self.iconImageView2.image = image;
        self.iconImageView3.image = image;
        self.iconImageView4.image = image;
    } else {
        self.iconImageView1.image = nil;
        self.iconImageView2.image = nil;
        self.iconImageView3.image = nil;
        self.iconImageView4.image = nil;
    }
}


#pragma mark - ConfigureUI

- (void)configureUI
{
	NSString *blank = @"";
	
    //Label
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
    
    CGFloat cornerRadius = 12.0;
    
	self.view.backgroundColor = whiteColor;
    self.questionContainerView.backgroundColor = whiteColor;
    
    self.questionView.backgroundColor = whiteColor; //[UIColor colorWithRed:0.44 green:0.76 blue:0.25 alpha:1];
    self.questionView.layer.cornerRadius = cornerRadius;
    
    self.answerContainerView.backgroundColor = whiteColor; //[UIColor colorWithRed:0.204 green:0.596 blue:0.859 alpha:1]; //whiteColor;
    self.infoView.backgroundColor = self.answerContainerView.backgroundColor; //whiteColor;
    self.questionScrollView.backgroundColor = [UIColor colorWithRed:0.655 green:0.824 blue:0.863 alpha:1];; //whiteColor;
	
	//Label
    self.questionLabel.textColor = darkBrown; //whiteColor;
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
    UIColor *colorNormal = [UIColor colorWithRed:0.3 green:0.58 blue:0.75 alpha:1];
	UIColor *colorHighlight = [UIColor colorWithRed:0.6 green:0.83 blue:0.84 alpha:1];
	
	self.answerView1.backgroundColor = colorNormal;
    self.answerView2.backgroundColor = colorNormal;
    self.answerView3.backgroundColor = colorNormal;
    self.answerView4.backgroundColor = colorNormal;
    
    self.answerView1.backgroundColorNormal = colorNormal;
    self.answerView1.backgroundColorHighlight = colorHighlight;
    self.answerView2.backgroundColorNormal = colorNormal;
    self.answerView2.backgroundColorHighlight = colorHighlight;
    self.answerView3.backgroundColorNormal = colorNormal;
    self.answerView3.backgroundColorHighlight = colorHighlight;
    self.answerView4.backgroundColorNormal = colorNormal;
    self.answerView4.backgroundColorHighlight = colorHighlight;
	
    CGFloat answerViewCornerRadius = 3.0;
    self.answerView1.layer.cornerRadius = answerViewCornerRadius;
    self.answerView2.layer.cornerRadius = answerViewCornerRadius;
    self.answerView3.layer.cornerRadius = answerViewCornerRadius;
    self.answerView4.layer.cornerRadius = answerViewCornerRadius;
    
    //Icon View Color
    //UIColor *iconViewColorNormal = self.questionScrollView.backgroundColor; //[UIColor colorWithRed:0.245 green:0.473 blue:0.614 alpha:1.000];
    
    self.iconView1.backgroundColor = colorNormal;
    self.iconView2.backgroundColor = colorNormal;
    self.iconView3.backgroundColor = colorNormal;
    self.iconView4.backgroundColor = colorNormal;
    
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