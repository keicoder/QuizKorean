//
//  Quiz.h
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


#import <Foundation/Foundation.h>

@interface Quiz : NSObject

@property (nonatomic, strong) NSMutableArray *quizArray;

@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *answer;
@property (nonatomic, strong) NSString *correct;
@property (nonatomic, strong) NSString *openDate;
@property (nonatomic, strong) NSString *questionSequenceNumber;
@property (nonatomic, strong) NSString *answerSequenceNumber;

- (void)fetchJSON;

@end
