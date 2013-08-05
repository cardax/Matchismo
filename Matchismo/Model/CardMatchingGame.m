//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Giuseppe Cardace on 01.04.13.
//  Copyright (c) 2013 Giuseppe Cardace. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (nonatomic, readwrite)int score;
@property (nonatomic, strong) NSMutableArray *cards; //of Card
@property (nonatomic, readwrite)NSString *status; //Contains a short sentence describing the game status to be displayed
@property (nonatomic, readwrite)int chosenMatchingMode;
@end

@implementation CardMatchingGame

#define _2CARDSMATCHING 0
#define _3CARDSMATCHING 1
#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

-(NSMutableArray *)cards{
    if (!_cards) _cards=[[NSMutableArray alloc]init];
    return _cards;
}
-(id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck withMatchingMode:(NSUInteger)matchingMode{
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
    self.chosenMatchingMode=matchingMode;
    NSLog(@"Game initialised with %d random cards.",cardCount);
    switch (self.chosenMatchingMode) {
        case _2CARDSMATCHING:
            NSLog(@"2-cards matching mode selected!");
            break;
        case _3CARDSMATCHING:
            NSLog(@"3-cards matching mode selected!");
            break;
        default:
            NSLog(@"Error with identifying playing mode!");
            break;
    }
    return self;
}
-(Card *)cardAtIndex:(NSUInteger)index{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

-(void)flipCardAtIndex:(NSUInteger)index{
    Card *card = [self cardAtIndex:index];
    int faceUpCards = [self countPlayableFaceUpCards:self.cards];
    NSLog([NSString stringWithFormat:@"%d cards are currently faced up",faceUpCards]);
    if (!card.isUnplayable) {
        if(!card.isFaceUp){
            //see if flipping this card up creates a match
            self.status = [NSString stringWithFormat:@"Flipped up %@",card.contents];
            //NSLog(@"Current cards:\n%@",[self.cards componentsJoinedByString:@"\n"]);
            for (Card *otherCard in self.cards) {

                if (otherCard.isFaceUp && !otherCard.isUnplayable && faceUpCards==(self.chosenMatchingMode+1)) {
                    int matchScore = 0;
                    if (self.chosenMatchingMode==_2CARDSMATCHING){
                        NSLog(@"Matching 2 cards");
                        matchScore = [card match:@[otherCard]];
                    } else {
                        NSLog(@"Matching 3 cards");
                        NSMutableArray *matchingCards;
                        for (Card *matchingCard in self.cards) {
                            
                        }
                    }


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

-(int)countPlayableFaceUpCards:(NSMutableArray *)cards
{
    int faceUpCards = 0;
    for (Card *card in cards){
        if (card.isFaceUp && !card.isUnplayable) faceUpCards++;
    }
    return faceUpCards;
}
@end
