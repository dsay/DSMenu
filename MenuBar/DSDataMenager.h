#import <Foundation/Foundation.h>
#import "CoreDataSource.h"

@interface DSDataMenager : CoreDataSource

+(DSDataMenager *)shared;
- (BOOL)save;

@end
