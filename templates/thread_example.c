#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

// Function executed by the thread
void *thread_function(void *arg) {
    int thread_id = *(int*)arg;
    printf("Thread %d: Hello from thread!\n", thread_id);
    pthread_exit(NULL);
}

int main() {
    pthread_t threads[5];
    int thread_ids[5];

    // Create multiple threads
    for (int i = 0; i < 5; i++) {
        thread_ids[i] = i;
        int result = pthread_create(&threads[i], NULL, thread_function, &thread_ids[i]);
        if (result != 0) {
            perror("Failed to create thread");
            return 1;
        }
    }

    // Wait for all threads to complete
    for (int i = 0; i < 5; i++) {
        pthread_join(threads[i], NULL);
    }

    printf("Main thread: All threads completed.\n");
    return 0;
}