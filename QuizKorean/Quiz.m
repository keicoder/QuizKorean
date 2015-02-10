//
//  Quiz.m
//  FetchingCitydata
//
//  Created by jun on 2/6/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

/*
 JSON
 {
 "A_CORRECT" = "";
 "A_NAME" = "(\Uc2dc\Uc557) \Uc2f8\Uc6c0\Uc5d0 \Uc694\Uac15 \Uc7a5\Uc218: \Uc2dc\Uc5b4\Uba38\Ub2c8\Uc640 \Uba70\Ub290\Ub9ac";
 "A_SEQ" = 3554;
 "Q_NAME" = "\Ub2e4\Uc74c \Uc911 ( )\Uc18d\Uc758 \Ub2e8\Uc5b4\Uc758 \Uc758\Ubbf8\Uac00 \Uc633\Uc740 \Uac83\Uc740?";
 "Q_OPEN" = 20141215;
 "Q_SEQ" = 609;
 }
 */


#import "Quiz.h"
#import "AFNetworking.h"

@implementation Quiz
{
	NSOperationQueue *_queue;
}


#pragma mark - Fetch JSON

- (void)fetchJSON
{
	if (_queue == nil) {
		_queue = [[NSOperationQueue alloc] init];
	}
	[_queue cancelAllOperations];
	
	if (self.quizArray == nil) {
		self.quizArray = [NSMutableArray arrayWithCapacity:10];
	}
	[self.quizArray removeAllObjects];
	
	NSURL *url = [self searchURLAndText];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	operation.responseSerializer = [AFJSONResponseSerializer serializer];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
		
		//Parse JSON Dictionary
		[self parseJSONDictionary:response];
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (operation.isCancelled) {
			NSLog(@"AFHTTPRequestOperation Cancelled");
			return;
		}
		NSLog(@"NSError: %@",error.localizedDescription);
	}];
	
	[_queue addOperation:operation];
}


#pragma mark - Parse JSON Dictionary

- (void)parseJSONDictionary:(NSDictionary *)response
{
	NSArray *array = response[@"KoreanAnswerInfo"][@"row"];
	
	if (array == nil) {
		
		NSLog(@"No Data > Try again!");
		[self fetchJSON];
		
	} else {
		
		for (NSDictionary *result in array) {
			
			Quiz *quiz = [[Quiz alloc] init];
			
			quiz.question = result[@"Q_NAME"];
			quiz.answer = result[@"A_NAME"];
			quiz.correct = result[@"A_CORRECT"];
			quiz.openDate = result[@"Q_OPEN"];
			quiz.questionSequenceNumber = result[@"Q_SEQ"];
			quiz.answerSequenceNumber = result[@"A_SEQ"];
			
			[self.quizArray addObject:quiz];
		}
		
		//Post a notification when success
		[[NSNotificationCenter defaultCenter] postNotificationName: @"ParseJSONDictionaryFinishedNotification" object:nil userInfo:nil];
	}
}


#pragma mark - Search URL and Text

- (NSURL *)searchURLAndText
{
	int year = arc4random() % 4 + 1;
	int month = arc4random() % 12 + 1;
	int day = arc4random() % 31 + 1;
	NSString *stringMonth;
	NSString *stringDay;
	
	if (year == 1) {
		year = 2012;
	} else if (year == 2) {
		year = 2013;
	} else if (year == 3) {
		year = 2014;
	} else if (year == 4) {
		year = 2015;
	}
	
	if (month < 10) {
		stringMonth = [NSString stringWithFormat:@"0%d", month];
	} else {
		stringMonth = [NSString stringWithFormat:@"%d", month];
	}
	
	if (day < 10) {
		stringDay = [NSString stringWithFormat:@"0%d", day];
	} else {
		stringDay = [NSString stringWithFormat:@"%d", day];
	}
	
	NSString *searchText = [NSString stringWithFormat:@"%d%@%@", year, stringMonth, stringDay];
	NSLog (@"searchText: %@\n", searchText);
	NSString *urlString = [NSString stringWithFormat:@"http://openapi.seoul.go.kr:8088/78416c5a486c6f7637305959657250/json/KoreanAnswerInfo/1/5/%@", searchText];
	NSURL *url = [NSURL URLWithString:urlString];
	
	return url;
}


@end
