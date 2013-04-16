//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Giuseppe Cardace on 01.04.13.
//  Copyright (c) 2013 Giuseppe Cardace. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property  (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchingModeCtrl;
@property (weak, nonatomic) UIImage *cardBack;

@end

@implementation CardGameViewController

-(CardMatchingGame*)game{
    if (!_game) {
        _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count] usingDeck:[[PlayingCardDeck alloc]init]];
        self.cardBack = [UIImage imageNamed:@"card-back.jpg"];

    }
    return _game;
}



-(void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons=cardButtons;
    [self updateUI];
}
- (IBAction)changeMatchMode:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.statusLabel.text=@"Two cards matching mode selected!";
            break;
        case 1:
            self.statusLabel.text=@"Three cards matching mode selected!";
            break;
        default:
            break;
    }
}

-(void)updateUI{

    if (self.matchingModeCtrl.enabled && self.flipCount>0) {
        self.matchingModeCtrl.enabled=NO;
    } else if (!self.matchingModeCtrl.enabled && self.flipCount==0){
        self.matchingModeCtrl.enabled=YES;
    }
    for (UIButton *cardButton in self.cardButtons) {
        cardButton.imageEdgeInsets= UIEdgeInsetsMake(5, 5, 5, 5);
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        if (!card.isFaceUp) {
            [cardButton setImage:self.cardBack forState:UIControlStateNormal];
        } else {
            [cardButton setImage:nil forState:UIControlStateNormal];
        }

        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];

        cardButton.selected=card.isFaceUp;
        cardButton.enabled=!card.isUnplayable;
        cardButton.alpha=card.isUnplayable ? 0.3 : 1;
    }
    self.scoreLabel.text=[NSString stringWithFormat:@"Score: %d", self.game.score];
    self.statusLabel.text=self.game.status;
}

- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex: [self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
    /*
     sender.selected = YES;
     Card *card = [self.deck drawRandomCard];
     //NSLog(card.contents);

     if (card) {
     [sender setTitle:card.contents forState:UIControlStateSelected];
     self.flipCount++;

     } else {
     NSLog(@"End of deck reached!");
     }
     */

}

-(void)setFlipCount:(int)flipCount  {
    _flipCount=flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"Flips updated to %d",self.flipCount);
}
- (IBAction)dealCards:(UIButton *)sender {
    self.game = [self.game initWithCardCount:[self.cardButtons count] usingDeck:[[PlayingCardDeck alloc]init]];
    self.flipCount=0;
    [self updateUI];
}


@end
