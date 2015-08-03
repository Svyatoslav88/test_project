
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BaseDBManager : NSObject

@property (nonatomic, strong) NSOperationQueue* saveQueue;

+ (instancetype) shared;

// get main context
+ (NSManagedObjectContext*) getMainContext;
// get new nested context
+ (NSManagedObjectContext*) getNewDBContext;
// save context sync
+ (void) saveContextSync: (NSManagedObjectContext*) context;
// save context async
+ (void) saveContextAsync: (NSManagedObjectContext*) context;
// save context async with complition block
+ (void) saveContextAsync: (NSManagedObjectContext*) context completionBlock: (void (^)(void)) block;
// delete object from custom context
+ (void) deleteObject: (NSManagedObject*) object context: (NSManagedObjectContext*) context;
// return object by objectID from background context if it exists in database
+ (id) existingObjectWithObjectID: (NSManagedObjectID*) managedObjectID context: (NSManagedObjectContext*) moc;
// erase db
+ (void) deleteAllObjectsInCoreData;
// creates new object with entity name in context
+ (id) newObjectForEntityName: (NSString*) entityName context: (NSManagedObjectContext*) context;


@end
