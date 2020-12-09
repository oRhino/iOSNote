//
//  Semaphore.h
//  iOS
//
//  Created by cyzone on 2020/12/9.
//  Copyright © 2020 CYZone. All rights reserved.
//

#ifndef Semaphore_h
#define Semaphore_h

#include <stdio.h>

//信号量
typedef struct z_semaphore {
    pthread_cond_t cond;   //条件
    pthread_mutex_t mutex; //互斥锁
    int volatile value;    //信号量的值
}z_semaphore_t;


int dispatch_semaphore_init(z_semaphore_t *semaphore,int value);

void dispatch_semaphore_signal_z(z_semaphore_t *semaphore);

void dispatch_semaphore_signal_all(z_semaphore_t *semaphore);

void dispatch_semaphore_wait_z(z_semaphore_t *semaphore);

int dispatch_semaphore_wait_timeout(z_semaphore_t *semaphore,long sec);


#endif /* Semaphore_h */

