
#import "BaseDBManager.h"

#define APPLICATION_NAME @"TestProject"

@interface BaseDBManager ()

@property (nonatomic, strong) NSManagedObjectContext *persistentStoreContext;
@property (nonatomic, strong) NSManagedObjectContext *mainContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation BaseDBManager

#pragma mark -
#pragma mark Lifecycle

+ (instancetype) shared
{
    static BaseDBManager* sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[BaseDBManager alloc] init];
    });
    return sharedManager;
}

- (instancetype) init
{
    self = [super init];
    if(self)
    {
        [self setupDBManager];
        self.saveQueue = [[NSOperationQueue alloc] init];
        self.saveQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void) setupDBManager
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource: APPLICATION_NAME withExtension: @"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL: modelURL];
    
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: self.managedObjectModel];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent: [NSString stringWithFormat:@"%@.sqlite", APPLICATION_NAME]];
    NSError *error = nil;
    
    NSPersistentStore* store = [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration: nil URL: storeURL options: nil error: &error];
    NSAssert(store != nil, @"Failed to initialize the application's saved data");
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (!coordinator)
    {
        return;
    }
    
    self.persistentStoreContext = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSPrivateQueueConcurrencyType];
    [self.persistentStoreContext setPersistentStoreCoordinator: coordinator];
    
    self.mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSMainQueueConcurrencyType];
    [self.mainContext setParentContext: self.persistentStoreContext];
    
    self.saveQueue = [[NSOperationQueue alloc] init];
    self.saveQueue.maxConcurrentOperationCount = 1;
}

- (NSURL*) applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory: NSDocumentDirectory inDomains: NSUserDomainMask] lastObject];
}

+ (void) deleteObject: (NSManagedObject*) object context: (NSManagedObjectContext*) context
{
    if(!object)
    {
        NSLog(@"attemp to delete nil object from context %@", context);
        return;
    }
    
    if(!context)
    {
        NSLog(@"attemp to delete object from nil context %@", object);
        return;
    }
    
    if([object managedObjectContext] != context)
    {
        NSLog(@"attemp to delete object from other context %@", object);
        return;
    }
    
    NSLog(@"Will delete object from context %@", object);
    [context performBlockAndWait:^{
        [context deleteObject:object];
    }];
}

+ (NSManagedObject*) existingObjectWithObjectID: (NSManagedObjectID*) managedObjectID context: (NSManagedObjectContext*) moc
{
    if (!managedObjectID)
    {
        NSAssert3(NO, @"%@ - %@ : %@", NSStringFromSelector(_cmd), NSStringFromClass([self class]), @"objectID can't be nil");
    }
    
    __block NSError *error;
    
    NSManagedObject *managedObject = [moc existingObjectWithID: managedObjectID error: &error];
    
    if (error)
    {
        return nil;
    }
    
    return managedObject;
}



#pragma mark -
#pragma mark Setters/Getters

+ (NSManagedObjectContext*) getMainContext
{
    return [[BaseDBManager shared] mainContext];
}

+ (NSManagedObjectContext*) getNewDBContext
{
    NSManagedObjectContext* newDBContext = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSPrivateQueueConcurrencyType];
    [newDBContext setParentContext: [[BaseDBManager shared] mainContext]];
    return newDBContext;
}

#pragma mark -
#pragma mark Saving

+ (void) saveContextSync: (NSManagedObjectContext*) context
{
    [[BaseDBManager shared] saveContextSync: context obtainPermanentIds: YES];
}

+ (void) saveContextAsync: (NSManagedObjectContext*) context
{
    [[BaseDBManager shared] saveContextAsync: context obtainPermanentIds: YES completionBlock: nil];
}

+ (void) saveContextAsync: (NSManagedObjectContext*) context completionBlock: (void (^)(void)) block
{
    [[BaseDBManager shared] saveContextAsync: context obtainPermanentIds: YES completionBlock: block];
}

- (void) saveContextSync: (NSManagedObjectContext*) context obtainPermanentIds: (BOOL) obtain
{
    [context performBlockAndWait: ^{
        __autoreleasing NSError* error;
        if(obtain)
        {
            [context obtainPermanentIDsForObjects: context.insertedObjects.allObjects error: &error];
            if(error)
                NSLog(@"Failed to obtain permanent id's");
        }
        
        [context save: &error];
        
        if(error)
            NSLog(@"Failed to save context");
        
        if(context.parentContext)
        {
            
            [self saveContextSync: context.parentContext obtainPermanentIds: NO];
            
        }
    }];
}

- (void) saveContextAsync: (NSManagedObjectContext*) context obtainPermanentIds: (BOOL) obtain completionBlock: (void (^)(void)) block
{
    [context performBlock: ^{
        __autoreleasing NSError* error;
        if(obtain)
        {
            [context obtainPermanentIDsForObjects: context.insertedObjects.allObjects error: &error];
            if(error)
                NSLog(@"Failed to obtain permanent id's");
        }
        
        [context save: &error];
        
        if(error)
            NSLog(@"Failed to save context");
        
        if(context.parentContext)
        {
            if(block)
                [self saveContextAsync: context.parentContext obtainPermanentIds: NO completionBlock: block];
            else
                [self saveContextSync: context.parentContext obtainPermanentIds: NO];
        }
        else
        {
            if(block)
                block();
        }
    }];
}

#pragma mark -
#pragma mark Helpers

+ (id) newObjectForEntityName: (NSString*) entityName context: (NSManagedObjectContext*) context
{
    if (!entityName || entityName.length == 0)
    {
        NSLog(@"No entity name for context %@", context);
        
        return nil;
    }
    
    if (!context)
    {
        NSLog(@"No context for entity name %@", entityName);
        
        return nil;
    }
    
    if (context == [self getMainContext])
    {
        NSLog(@"Attempt to insert entity into main context %@", entityName);
    }
    id newObject;
    @try {
        newObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];;
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exeption:: %@", exception);
    }
    
    
    return newObject;
}

+ (void) deleteAllObjectsInCoreData
{
    [[BaseDBManager shared] deleteAllObjectsInCoreData];
}

- (void) deleteAllObjectsInCoreData
{
    NSArray *allEntities = self.managedObjectModel.entities;
    for (NSEntityDescription *entityDescription in allEntities)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entityDescription];
        
        fetchRequest.includesPropertyValues = NO;
        fetchRequest.includesSubentities = NO;
        
        NSManagedObjectContext* context = [BaseDBManager getNewDBContext];
        
        NSError *error;
        NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
        
        if (error) {
            NSLog(@"Error requesting items from Core Data: %@", [error localizedDescription]);
        }
        
        for (NSManagedObject *managedObject in items) {
            [context deleteObject:managedObject];
        }
        
        [self saveContextSync: context obtainPermanentIds: YES];
    }
}


@end
