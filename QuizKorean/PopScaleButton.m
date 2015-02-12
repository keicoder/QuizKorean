//
//  PopScaleButton.m
//  QuizKorean
//
//  Created by jun on 2/12/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#define debug 1

#define kHightlightTextColor [UIColor colorWithRed:1.000 green:0.473 blue:0.247 alpha:1.000]
#define kNormalBgColor [UIColor colorWithRed:0.227 green:0.414 blue:0.610 alpha:1.000]
#define khighlightBgColor [UIColor colorWithRed:0.227 green:0.414 blue:0.610 alpha:1.000]

#import "PopScaleButton.h"
#import <pop/POP.h>


@interface PopScaleButton ()

@property (strong,nonatomic) CAGradientLayer *backgroundLayer;
@property (strong,nonatomic) CAGradientLayer *highlightBackgroundLayer;
@property (strong,nonatomic) CALayer *innerGlow;

@end


@implementation PopScaleButton

+ (PopScaleButton *)buttonWithType:(UIButtonType)type
{
	return [super buttonWithType:UIButtonTypeCustom];
}


- (id)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	
	if (self) {
		
		UIColor *normalBgColor = [UIColor colorWithRed:0.227 green:0.414 blue:0.610 alpha:1.000];
		UIColor *hightlightTextColor = [UIColor colorWithWhite:0.908 alpha:1.000];
		
		[self setBackgroundColor:normalBgColor];
		[self setTitleColor:hightlightTextColor forState:UIControlStateHighlighted];
	}
	
	return self;
}


- (void)layoutSubviews
{
	[super layoutSubviews];
}


#pragma mark - Handle touches with a nice interaction animations

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	POPSpringAnimation *scale = [self pop_animationForKey:@"scale"];
	//POPSpringAnimation *rotate = [self.layer pop_animationForKey:@"rotate"];
	
	CGFloat size = 0.88f;
	
	if (scale) {
		scale.toValue = [NSValue valueWithCGPoint:CGPointMake(size, size)];
	} else {
		scale = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
		scale.toValue = [NSValue valueWithCGPoint:CGPointMake(size, size)];
		scale.springBounciness = 20;
		scale.springSpeed = 18.0f;
		[self pop_addAnimation:scale forKey:@"scale"];
	}
	
//	CGFloat value = 6;
//	if (rotate) {
//		rotate.toValue = @(M_PI/value);
//	} else {
//		rotate = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
//		rotate.toValue = @(M_PI/value);
//		rotate.springBounciness = 20;
//		rotate.springSpeed = 18.0f;
//		[self.layer pop_addAnimation:rotate forKey:@"rotate"];
//	}
	
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	POPSpringAnimation *scale = [self pop_animationForKey:@"scale"];
	//POPSpringAnimation *rotate = [self pop_animationForKey:@"rotate"];
	
	CGFloat size = 1.0;
	
	if (scale) {
		scale.toValue = [NSValue valueWithCGPoint:CGPointMake(size, size)];
	} else {
		scale = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
		scale.toValue = [NSValue valueWithCGPoint:CGPointMake(size, size)];
		scale.springBounciness = 20;
		scale.springSpeed = 18.0f;
		[self pop_addAnimation:scale forKey:@"scale"];
	}
	
//	if (rotate) {
//		rotate.toValue = @(0);
//	} else {
//		rotate = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
//		rotate.toValue = @(0);
//		rotate.springBounciness = 20;
//		rotate.springSpeed = 18.0f;
//		[self.layer pop_addAnimation:rotate forKey:@"rotate"];
//	}
	
	[super touchesEnded:touches withEvent:event];
}


@end
