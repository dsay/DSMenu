#import "DSDataMenager.h"
#import "UIApplication+Utils.h"

@interface DSDataMenager ()

@property (readonly) NSManagedObjectModel *model;
@property (readonly) NSPersistentStoreCoordinator *coordinator;

@end

@implementation DSDataMenager

@synthesize model = _model;
@synthesize coordinator = _coordinator;

+(DSDataMenager *)shared
{
    static DSDataMenager *dataMenager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        dataMenager = [[DSDataMenager alloc] init];
    });
    
    return dataMenager;
}

- (BOOL)save
{
    NSError *error = nil;
    NSManagedObjectContext *context = self.context;
    
    if ([context hasChanges] && ![context save:&error])
        return NO;
    
    return YES;
}


- (NSManagedObjectContext *)context
{
    NSMutableDictionary *threadDictionary = NSThread.currentThread.threadDictionary;
	NSManagedObjectContext *context = [threadDictionary objectForKey:@"kCurrentManagedObjectContext"];
    
	if (!context)
    {
		context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        context.persistentStoreCoordinator = self.coordinator;
        
        [threadDictionary setObject:context forKey:@"kCurrentManagedObjectContext"];
	}
    
	return context;
}

- (NSManagedObjectModel *)model
{
    if (!_model)
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
    return _model;
}

- (NSPersistentStoreCoordinator *)coordinator
{
    if (!_coordinator)
    {
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        
        NSError *error = nil;
        NSURL *storeURL = [UIApplication.documentsDirectoryURL URLByAppendingPathComponent:[UIApplication.bundleName stringByAppendingString:@".sqlite"]];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        if (![_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
        {
            if (NSCocoaErrorDomain == error.domain)
            {
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                if ([fileManager removeItemAtURL:UIApplication.documentsDirectoryURL error:&error])
                    if ([_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
                        NSLog(@"Created a new NSPersistentStoreCoordinator");
                    else
                    {
                        abort();
                    }
                    else
                    {
                        abort();
                    }
            }
            else
                abort();
        }
    }
    return _coordinator;
}

@end
