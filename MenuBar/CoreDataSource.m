#import "CoreDataSource.h"

@implementation CoreDataSource

- (NSManagedObjectContext *)context
{
    return nil;
}

- (NSManagedObject *)newObjectOfEntity:(NSString *)name
{
    NSManagedObjectContext *context = self.context;
    
    if (!context)
        return nil;
    
    return [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:name inManagedObjectContext:context] insertIntoManagedObjectContext:context];
}

- (NSArray *)objectsOfEntity:(NSString *)name withPredicate:(NSPredicate *)predicate andSortDecriptors:(NSArray *)sortDescriptors
{
    NSManagedObjectContext *context = self.context;
    
    if (!context)
        return nil;
    
    NSFetchRequest *request = NSFetchRequest.new;
    
    request.entity = [NSEntityDescription entityForName:name inManagedObjectContext:context]; 
    request.predicate = predicate;
    
    if (sortDescriptors)
        [request setSortDescriptors:sortDescriptors];
        
    return [context executeFetchRequest:request error:nil];
}

- (void)deleteObjectsOfEntity:(NSString *)name withPredicate:(NSPredicate *)predicate andSortDecriptors:(NSArray *)sortDescriptors
{
    NSManagedObjectContext *context = self.context;
    
    if (!context)
        return;
    @try
    {
        NSArray *toRemove = [self objectsOfEntity:name withPredicate:predicate andSortDecriptors:sortDescriptors];

        for (NSManagedObject *object in toRemove)    
            [context deleteObject:object];
    }
    @catch (NSException *exception)
    {}
}

- (NSArray *)validObjectsWithObjects:(NSArray *)objects
{
    NSMutableArray *validObjects = NSMutableArray.new;

    for (NSManagedObject *object in objects)
    {
        NSManagedObject *validObject = [self.context objectWithID:object.objectID];
        
        if (validObject)
            [validObjects addObject:validObject];
    }
    
    return validObjects;
}

@end
