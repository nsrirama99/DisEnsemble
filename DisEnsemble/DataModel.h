//
//  DataModel.h
//  MSL-Assignment-One
//
//  Created by UbiComp on 9/9/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataModel : NSObject

+(DataModel*)sharedInstance;

-(int)loadNames;

-(UIImage*)getImageWithName:(NSString*)name;

//-(NSArray*)getAllChars;
-(NSArray*)getAllInstruments;

//-(NSInteger)numberOfChars;
//-(NSInteger)numberOfStages;
//-(NSInteger)numberOfMusic;

-(NSInteger)numberOfInstruments;

//-(NSString*)getCharNameForIndex:(NSInteger)index;
//-(NSString*)getStageNameForIndex:(NSInteger)index;
//-(NSString*)getMusicNameForIndex:(NSInteger)index;

-(NSString*)getInstrumentNameForIndex:(NSInteger)index;


@property (nonatomic, strong) NSArray* charNames;
@property (nonatomic, strong) NSArray* stageNames;
@property (nonatomic, strong) NSArray* musicNames;
@property (nonatomic, strong) NSArray* instrumentNames;

@end

NS_ASSUME_NONNULL_END
