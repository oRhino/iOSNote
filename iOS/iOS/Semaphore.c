//
//  Semaphore.c
//  iOS
//
//  Created by cyzone on 2020/12/9.
//  Copyright © 2020 CYZone. All rights reserved.
//

#include "Semaphore.h"
#include <pthread/pthread.h>
#include <stdlib.h>

int dispatch_semaphore_init(z_semaphore_t *semaphore,int value){
    if (value < 0){
        printf("value must be >= 0 \n");
        return -1;
    }
    pthread_mutex_init(&(semaphore->mutex), NULL);
    pthread_cond_init(&(semaphore->cond), NULL);
    semaphore->value = value;
    return 0;
}

void dispatch_semaphore_signal_z(z_semaphore_t *semaphore){
    pthread_mutex_lock(&(semaphore->mutex));
    if (semaphore->value <= 0) {
        pthread_cond_signal(&(semaphore->cond));
    }
    semaphore->value ++;
    pthread_mutex_unlock(&(semaphore->mutex));
}

void dispatch_semaphore_signal_all(z_semaphore_t *semaphore){
    pthread_mutex_lock(&(semaphore->mutex));
    semaphore->value = 0;
    pthread_cond_broadcast(&(semaphore->cond));
    pthread_mutex_unlock(&(semaphore->mutex));
}

void dispatch_semaphore_wait_z(z_semaphore_t *semaphore){
    pthread_mutex_lock(&(semaphore->mutex));
    if (semaphore->value == 0) {
        pthread_cond_wait(&(semaphore->cond), &(semaphore->mutex));
    }
    semaphore->value --;
    pthread_mutex_unlock(&(semaphore->mutex));
}

int dispatch_semaphore_wait_timeout(z_semaphore_t *semaphore,long sec){
    
    pthread_mutex_lock(&(semaphore->mutex));
    int res = 0 ;
    if (semaphore->value == 0) {
        struct  timespec timep;
        clock_gettime(CLOCK_MONOTONIC, &timep);
        timep.tv_sec += sec;
        res = pthread_cond_timedwait(&(semaphore->cond), &(semaphore->mutex), &timep);
        pthread_cond_wait(&(semaphore->cond), &(semaphore->mutex));
    }
    semaphore->value --;
    pthread_mutex_unlock(&(semaphore->mutex));
    return res;
}

