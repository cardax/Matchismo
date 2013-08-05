//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Giuseppe Cardace on 01.04.13.
//  Copyright (c) 2013 Giuseppe Cardace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

-(id)initWithCardCount:(NSUInteger)cardCount
             usingDeck:(Deck *)deck
      withMatchingMode:(NSUInteger)matchingMode;

-(void)flipCardAtIndex:(NSUInteger)index;

-(Card *)cardAtIndex:(NSUInteger) index;
- (int)countPlayableFaceUpCards:(NSMutableArray*) cards;

@property (nonatomic, readonly)int score;
@property (nonatomic, readonly)NSString *status;
@property (nonatomic, readonly)int chosenMatchingMode;
@end
