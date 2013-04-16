//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Giuseppe Cardace on 01.04.13.
//  Copyright (c) 2013 Giuseppe Cardace. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (nonatomic,readwrite)int score;
@property (strong, nonatomic) NSMutableArray *cards; //of Card
@property (nonatomic,readwrite)NSString *status; //Contains a short sentence describing the game status to be displayed

@end

@implementation CardMatchingGame
-(NSMutableArray *)cards{
    if (!_cards) _cards=[[NSMutableArray alloc]init];
    return _cards;
}
-(id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck{
    self = [super init];
    if (self){
        for (int i=0; i<cardCount; i++) {
            Card *card=[deck drawRandomCard];
            if (!card) {
                self=nil;
            } else {
                self.cards[i]=card;
            }
        }
    }
    self.score=0;
    self.status=@"New game! Flip a card!";
    return self;
}
-(Card *)cardAtIndex:(NSUInteger)index{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}


#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1


-(void)flipCardAtIndex:(NSUInteger)index{
    Card *card = [self cardAtIndex:index];
    if (!card.isUnplayable) {
        if(!card.isFaceUp){
            //see if flipping this card up creates a match
            self.status = [NSString stringWithFormat:@"Flipped up %@",card.contents];
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        otherCard.unplayable=YES;
                        card.unplayable=YES;
                        self.score += matchScore * MATCH_BONUS;
                        self.status = [NSString stringWithFormat:@"Matched %@ & %@\nfor %d points",card.contents,otherCard.contents,matchScore*MATCH_BONUS];
                    } else {
                        otherCard.faceUp=NO;
                        self.score -= matchScore * MISMATCH_PENALTY;
                        self.status = [NSString stringWithFormat:@"%@ & %@ don't match!\n%d points penalty!",card.contents,otherCard.contents,matchScore * MISMATCH_PENALTY];
                    }
                }
            }
            self.score -= FLIP_COST;
        }
        card.faceUp=!card.faceUp;
    }
}
@end
