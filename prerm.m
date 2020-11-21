#import <Foundation/Foundation.h>

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
    NSString *plistFile = @"/Library/LaunchDaemons/com.openssh.sshd.plist";
    NSMutableDictionary *plist = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFile];
    plist[@"Sockets"][@"LocalSSHListener"] = nil;
    [[NSPropertyListSerialization dataWithPropertyList:plist format:NSPropertyListBinaryFormat_v1_0 options:0 error:nil] writeToFile:plistFile atomically:YES];
    run_system("launchctl load /Library/LaunchDaemons/com.openssh.sshd.plist");
    return 0;
}
