//
//  PlayingCard.m
//  Matchismo
//
//  Created by Giuseppe Cardace on 01.04.13.
//  Copyright (c) 2013 Giuseppe Cardace. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard
-(NSString* )contents{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *)rankStrings{
    return @[@"?",@"A",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSArray*)validSuits{
    return @[@"♥",@"♦",@"♠",@"♣"];
}

@synthesize suit=_suit;

//SETTER FOR SUIT
-(void) setSuit:(NSString *)suit{
    if([[PlayingCard validSuits] containsObject:suit]){
        _suit=suit;
    }
}

//GETTER FOR SUIT
-(NSString*)suit{
    return _suit ? _suit : @"?";
}

+ (NSUInteger)maxRank{
    return [self rankStrings].count-1;
}

-(void)setRank:(NSUInteger)rank{
    if (rank<= [PlayingCard maxRank]){
        _rank=rank;
    }
}

-(int)match:(NSArray *)otherCards{
    int score=0;

    if (otherCards.count==1) {
        PlayingCard *otherCard=[otherCards lastObject];
        if ([otherCard.suit isEqualToString:self.suit]) {
            score=1;
        } else if (otherCard.rank==self.rank){
            score=4;
        }
    }

    return score;
}

@end
