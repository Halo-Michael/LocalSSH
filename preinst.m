#import <Foundation/Foundation.h>

int main() {
    if (getuid() != 0) {
        printf("Run this as root!\n");
        return 1;
    }

    NSDictionary *Sockets = [[NSDictionary alloc] initWithContentsOfFile:@"/Library/LaunchDaemons/com.openssh.sshd.plist"][@"Sockets"];
    for (NSString *socket in [Sockets allKeys]) {
        if ([socket isEqual:@"LocalSSHListener"]) {
            printf("LocalSSHListener is already existed.\n");
            return 1;
        }
        if ([[Sockets[socket] allValues] containsObject:@"2222"]) {
            printf("Port 2222 is already enabled.\n");
            return 2;
        }
    }

    return 0;
}
