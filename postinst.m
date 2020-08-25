#import <Foundation/Foundation.h>

bool modifyPlist(NSString *filename, void (^function)(id)) {
    NSData *data = [NSData dataWithContentsOfFile:filename];
    if (data == nil) {
        return false;
    }
    NSPropertyListFormat format = 0;
    id plist = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:&format error:nil];
    if (plist == nil) {
        return false;
    }
    if (function) {
        function(plist);
    }
    NSData *newData = [NSPropertyListSerialization dataWithPropertyList:plist format:format options:0 error:nil];
    if (newData == nil) {
        return false;
    }
    if (![data isEqual:newData]) {
        if (![newData writeToFile:filename atomically:YES]) {
            return false;
        }
    }
    return true;
}

void run_system(const char *cmd) {
    int status = system(cmd);
    if (WEXITSTATUS(status) != 0) {
        printf("Error in command: \"%s\"\n", cmd);
        exit(WEXITSTATUS(status));
    }
}

int main() {
    if (getuid() != 0) {
        printf("Run this as root!\n");
        return 1;
    }

    run_system("launchctl unload /Library/LaunchDaemons/com.openssh.sshd.plist");
    NSMutableDictionary *LocalSSHListener = [NSMutableDictionary new];
    LocalSSHListener[@"SockNodeName"] = @"localhost";
    LocalSSHListener[@"SockServiceName"] = @"2222";
    NSString *const plist = @"/Library/LaunchDaemons/com.openssh.sshd.plist";
    modifyPlist(plist, ^(id plist) {
        plist[@"Sockets"][@"LocalSSHListener"] = LocalSSHListener;
    });
    run_system("launchctl load /Library/LaunchDaemons/com.openssh.sshd.plist");
    return 0;
}
