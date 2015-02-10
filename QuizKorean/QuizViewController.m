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


@interface QuizViewController ()

@end


@implementation QuizViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
}


- (IBAction)dismissButtonTapped:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}


@end
