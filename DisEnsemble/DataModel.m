//
//  DataModel.m
//  MSL-Assignment-One
//
//  Created by UbiComp on 9/9/21.
//

#import "DataModel.h"

@implementation DataModel

@synthesize instrumentNames = _instrumentNames;

+(DataModel*)sharedInstance {
    static DataModel* _sharedInstance = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        _sharedInstance = [[DataModel alloc] init];
    });
    return _sharedInstance;
}


-(NSArray*)instrumentNames {
    if(!_instrumentNames) {
        [self loadNames];
    }
    
    return _instrumentNames;
}


-(int)loadNames {
    NSDictionary* fileDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Names" ofType:@"plist"]];
    
//    _charNames = [fileDict objectForKey:@"Characters"];
//    _stageNames = [fileDict objectForKey:@"Stages"];
//    _musicNames = [fileDict objectForKey:@"Music"];

    _instrumentNames = [fileDict objectForKey:@"Instruments"];
    
    return 1;
}

-(UIImage*)getImageWithName:(NSString*)name {
    UIImage* image = nil;
    
    image = [UIImage imageNamed:name];
    
    return image;
}

-(NSArray*)getAllInstruments {
    //[self loadNames];
    return _instrumentNames;
}

//-(NSInteger)numberOfChars { return self.charNames.count; }
//-(NSInteger)numberOfStages { return self.stageNames.count; }
//-(NSInteger)numberOfMusic { return self.musicNames.count; }

-(NSInteger)numberOfInstruments { return self.instrumentNames.count; }

//-(NSString*)getCharNameForIndex:(NSInteger)index {
//    return self.charNames[index]; //_charNames[index];
//}
//-(NSString*)getStageNameForIndex:(NSInteger)index {
//    return self.stageNames[index]; //_stageNames[index];
//}
//-(NSString*)getMusicNameForIndex:(NSInteger)index {
//    return self.musicNames[index]; //_musicNames[index];
//}

-(NSString*)getInstrumentNameForIndex:(NSInteger)index {
    return self.instrumentNames[index]; //_musicNames[index];
}



@end

