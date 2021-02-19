//
//  WakeObserver.m
//
//  Created by Clem on 18.10.09.
//

#import "WakeObserver.h"


@implementation WakeObserver

- (void) receiveWakeNote: (NSNotification*) note
{
	[NSThread sleepForTimeInterval:10.0]; //wait 10 sec before restarting to be sure everthing is up
    NSString* path = [[NSBundle mainBundle] bundlePath];
    NSString* cmd = [NSString stringWithFormat:@"open -n %@", path];
    [self runCommand:cmd];

	[NSApp terminate:NULL];
}

    /// Temrinal  function.
    -(NSString*)runCommand:(NSString*)commandToRun;
    {
        NSTask *task;
        task = [[NSTask alloc] init];
        [task setLaunchPath: @"/bin/sh"];

        NSArray *arguments = [NSArray arrayWithObjects:
                              @"-c" ,
                              [NSString stringWithFormat:@"%@", commandToRun],
                              nil];
        NSLog(@"run command: %@",commandToRun);
        [task setArguments: arguments];

        NSPipe *pipe;
        pipe = [NSPipe pipe];
        [task setStandardOutput: pipe];

        NSFileHandle *file;
        file = [pipe fileHandleForReading];

        [task launch];

        NSData *data;
        data = [file readDataToEndOfFile];

        NSString *output;
        output = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        return output;
    }

@end
