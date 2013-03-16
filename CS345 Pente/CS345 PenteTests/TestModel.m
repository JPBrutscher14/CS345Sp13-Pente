/**
 @file TestModel.m
 @brief Part of CS345 Pente
 @author Bryant Adams
 @date 3/15/13
 @copyright GNU Public License v3 or later, 2013
 @version 0.1
*/

    // Class under test
#import "CSPGollumInTheCloset.h"

    // Collaborators
#import "CSPPenteGameModelInterface.h"
#import "CSPMove.h"

// Test support
#import <SenTestingKit/SenTestingKit.h>

// Comment the next two lines to disable OCHamcrest (for test assertions)
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

// Comment the next two lines to disable OCMockito (for mock objects)
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

/**
 @brief For testing Gollum in the Closet model
 */
@interface TestModel : SenTestCase
@end

@implementation TestModel
{
    // test fixture ivars go here
    id<CSPPenteGameModelInterface> sut;
}

- (void)setUp
{
    [super setUp];
    sut = [[CSPGollumInTheCloset alloc] init];
    
}

- (void)tearDown
{
    sut = nil;
    [super tearDown];
}

#pragma mark Tests

- (void)testBoardSizeIsReasonable
{
    // given
    // when
    NSUInteger boardsize = [sut boardWidth];
    // then
    assertThatUnsignedInteger(boardsize, is(closeTo(19, 5)));
}

- (void)testWhitesSecondMoveIsAllowedRightOfCenterSeven
{
    // given
    [self makeMoveFor:CSPID_PlayerWhite atX:9 andY:9];
    [self makeMoveFor:CSPID_PlayerBlack atX:7 andY:8];
    // when
    // then
    [self testMoveFor:CSPID_PlayerWhite atX:13 andY:9 isLegal:YES];
}

- (void)testWhitesSecondMoveIsAllowedLeftOfCenterSeven
{
    // given
    [self makeMoveFor:CSPID_PlayerWhite atX:9 andY:9];
    [self makeMoveFor:CSPID_PlayerBlack atX:7 andY:8];
    // when
    // then
    [self testMoveFor:CSPID_PlayerWhite atX:4 andY:9 isLegal:YES];
}

- (void)testWhitesSecondMoveIsAllowedAboveOfCenterSeven
{
    // given
    [self makeMoveFor:CSPID_PlayerWhite atX:9 andY:9];
    [self makeMoveFor:CSPID_PlayerBlack atX:7 andY:8];
    // when
    // then
    [self testMoveFor:CSPID_PlayerWhite atX:9 andY:13 isLegal:YES];
}

- (void)testWhitesSecondMoveIsAllowedBelowCenterSeven
{
    // given
    [self makeMoveFor:CSPID_PlayerWhite atX:9 andY:9];
    [self makeMoveFor:CSPID_PlayerBlack atX:7 andY:8];
    // when
    // then
    [self testMoveFor:CSPID_PlayerWhite atX:9 andY:4 isLegal:YES];
}

- (void)testWhitesSecondMoveIsRestrictedInsideCenterSeven
{
    // given
    [self makeMoveFor:CSPID_PlayerWhite atX:9 andY:9];
    [self makeMoveFor:CSPID_PlayerBlack atX:7 andY:8];
    // when
    // then
    [self testMoveFor:CSPID_PlayerWhite atX:9 andY:12 isLegal:NO];
}

- (void)testBlackDoesNotMoveFirst
{
    // given
    // when
    // then
    [self testMoveFor:CSPID_PlayerBlack atX:9 andY:9 isLegal:NO];
}
- (void)testWhiteDoesMoveFirst
{
    // given
    // when
    // then
    [self testMoveFor:CSPID_PlayerWhite atX:9 andY:9 isLegal:YES];
}

- (void)testBlackDoesMoveSecond
{
    // given
    [self makeMoveFor:CSPID_PlayerWhite atX:9 andY:8];
    // when
    // then
    [self testMoveFor:CSPID_PlayerBlack atX:9 andY:9 isLegal:YES];
}
- (void)testWhiteDoesNotMoveSecond
{
    // given
    [self makeMoveFor:CSPID_PlayerBlack atX:7 andY:8];
    // when
    // then
    [self testMoveFor:CSPID_PlayerWhite atX:9 andY:9 isLegal:NO];
}

- (void)testCannotImmediatelyRepeatAMove
{
    // given
    [self makeMoveFor:CSPID_PlayerBlack atX:7 andY:8];
    // when
    // then
    [self testMoveFor:CSPID_PlayerBlack atX:7 andY:8 isLegal:NO];
}

- (void)testCannotPlaceOnPreviousStone
{
    // given
    [self makeMoveFor:CSPID_PlayerWhite atX:7 andY:8];
    [self makeMoveFor:CSPID_PlayerBlack atX:6 andY:8];
    [self makeMoveFor:CSPID_PlayerWhite atX:5 andY:8];
    [self makeMoveFor:CSPID_PlayerBlack atX:4 andY:8];
    // when
    // then
    [self testMoveFor:CSPID_PlayerWhite atX:7 andY:8 isLegal:NO];
}
- (void)testGameBeginsWithNobodyHavingWon
{
    // given
    // when
    // then
    assertThatUnsignedInteger([sut gameOverState], is(equalToInt(CSPGO_GameNotOver)));
}
- (void)testChainSizeStartsAtOne
{
    // given
    [self makeMoveFor:CSPID_PlayerWhite atX:7 andY:8];
    
    // when
    NSUInteger chainSize =[sut longestChainForStoneAt:[CSPLocation coordinateWithX:7 andY:8]];
    
    // then
    assertThatUnsignedInteger(chainSize, is(equalToInt(1)));
}
//- (void)testCapturing
//{
//    // given
//    [self makeMoveFor:CSPID_PlayerBlack atX:6 andY:8];
//    [self makeMoveFor:CSPID_PlayerWhite atX:7 andY:8];
//    [self makeMoveFor:CSPID_PlayerWhite atX:8 andY:8];
//    // when
//    [self makeMoveFor:CSPID_PlayerBlack atX:9 andY:8]; //Capture!
//    
//    // then
//    [self testMoveFor:CSPID_PlayerWhite atX:7 andY:8 isLegal:YES];
//}
//Test capture removes pieces
//Test can repeat after capture
//Test making straight five sets gameover
//Test making middle five sets gameover
//Test making multifive sets gameover
//Test making more than five sets gameover
//Test capture game over
//Test game over matches winning player
//Test making a move also adds neighbor links
//Test making a move also captures pieces

#pragma mark Helper Methods

-(void) makeMoveFor:(CSPPlayerID)player atX:(int)x andY:(int)y
{
    CSPMove* theMove = [CSPMove moveWithPlayer:player
                                           atX:x
                                          andY:y];
    [sut makeMove:theMove];
}
-(void) testMoveFor:(CSPPlayerID)player
                atX:(int)x andY:(int)y
            isLegal:(BOOL) legality;
{
    CSPMove* theMove = [CSPMove moveWithPlayer:player
                                           atX:x
                                          andY:y];
    assertThatBool([sut isLegalMove:theMove], is(equalToBool(legality)));

}
@end
