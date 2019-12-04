#include <spawn.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
extern char **environ;

int run_cmd(char *cmd)
{
    pid_t pid;
    char *argv[] = {"sh", "-c", cmd, NULL};
    int status = posix_spawn(&pid, "/bin/sh", NULL, NULL, argv, environ);
    if (status == 0) {
        if (waitpid(pid, &status, 0) == -1) {
            perror("waitpid");
        }
    }
    return status;
}

int main()
{
    if (geteuid() != 0) {
        printf("Run this as root!\n");
        exit(1);
    }
    
    run_cmd("launchctl unload /Library/LaunchDaemons/com.openssh.sshd.plist");
    if (access("/usr/libexec/sshd-keygen-wrapper", F_OK) == 0) {
        run_cmd("plutil -key Sockets -key LocalSSHListener -dict /Library/LaunchDaemons/com.openssh.sshd.plist");
        run_cmd("plutil -key Sockets -key LocalSSHListener -key SockServiceName -string 2222 /Library/LaunchDaemons/com.openssh.sshd.plist");
    } else {
        run_cmd("sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config");
        run_cmd("sed -i '/Port 22/a\\Port 2222' /etc/ssh/sshd_config");
    }
    run_cmd("launchctl load /Library/LaunchDaemons/com.openssh.sshd.plist");
    return 0;
}
