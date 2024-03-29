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

-(NSString*)description{
    NSString *strFaceUp = self.isFaceUp ? @"Face Up" : @"Face Down";
    NSString *strPlayable = self.isUnplayable ? @"Unplayable" : @"Playable";

    return [NSString stringWithFormat:@"Card: %@ - %@ - %@",self.contents,strFaceUp,strPlayable];
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
        id otherCard=[otherCards lastObject];
        if ([otherCard isKindOfClass:[PlayingCard class]]){
            PlayingCard *otherPlayingCard=(PlayingCard *)otherCard;
            if ([otherPlayingCard.suit isEqualToString:self.suit]) {
                score=1;
            } else if (otherPlayingCard.rank==self.rank){
                score=4;
            }
        }
    }
    else if (otherCards.count==2){
        for (PlayingCard *otherCard in otherCards) {
            if ([otherCard.suit isEqualToString:self.suit]) {
                score+=1;
            } else if (otherCard.rank==self.rank){
                score+=4;
            }
        }
    }

    return score;
}

@end
