#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataSource : NSObject

@property (readonly) NSManagedObjectContext *context;  

- (NSManagedObject *)newObjectOfEntity:(NSString *)name; 
- (NSArray *)objectsOfEntity:(NSString *)name withPredicate:(NSPredicate *)predicate andSortDecriptors:(NSArray *)sortDescriptors; 
- (void)deleteObjectsOfEntity:(NSString *)name withPredicate:(NSPredicate *)predicate andSortDecriptors:(NSArray *)sortDescriptors;
- (NSArray *)validObjectsWithObjects:(NSArray *)objects;

@end
