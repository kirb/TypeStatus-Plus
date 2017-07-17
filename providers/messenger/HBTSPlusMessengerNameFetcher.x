#import "HBTSPlusMessengerNameFetcher.h"
#import "Messenger.h"

static NSMutableDictionary *cachedNames;

@implementation HBTSPlusMessengerNameFetcher {
	HBTSPlusMessengerNameFetcherCompletion _completion;
	NSMutableDictionary *_cachedNames;
}

- (void)userDisplayNameForID:(NSString *)userID completion:(HBTSPlusMessengerNameFetcherCompletion)completion {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		cachedNames = [NSMutableDictionary dictionary];
	});

	if (cachedNames[userID]) {
		completion(cachedNames[userID]);
	}

	_completion = [completion copy];

	MNAppDelegate *appDelegate = (MNAppDelegate *)[[UIApplication sharedApplication] delegate];

	FBMUserFetcher *fetcher = [[%c(FBMUserFetcher) alloc] initWithDependencyProvider:[appDelegate valueForKey:@"_providerMap"]];
	[fetcher configureAndFetchUserWithWithUserId:userID delegate:self];
}

- (void)fetcher:(FBMUserFetcher *)fetcher didFetchUser:(FBMUser *)user {
	// store the value in our cache, and return our copied value
	cachedNames[user.userId] = [user.name.displayName copy];
	_completion(cachedNames[user.userId]);
}

- (void)fetcher:(FBMUserFetcher *)fetcher couldNotFetchUser:(NSError *)error {
	HBLogError(@"error getting user display name: %@", error);
	// don't pass through to the completion, because all we can show is an ugly number
}

@end
