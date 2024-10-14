#include <stdio.h>

void xorQueries(int* arr, int arrSize, int queries[][2], int queriesSize, int* result) {
    int prefix[arrSize + 1];
    prefix[0] = 0;

    for (int i = 1; i <= arrSize; i++) {
        prefix[i] = prefix[i - 1] ^ arr[i - 1];
    }

    for (int i = 0; i < queriesSize; i++) {
        int left = queries[i][0];
        int right = queries[i][1];
        result[i] = prefix[right + 1] ^ prefix[left];
    }
}

int main() {
    // Input arrays
    int arr0[] = {4, 8, 2, 10};
    int arr1[] = {1, 3, 4, 8};
    int arr2[] = {1, 2, 3, 4};

    // Queries (left, right)
    int queries[][2] = {{0, 3}, {0, 1}};
    int queriesSize = sizeof(queries) / sizeof(queries[0]);

    int result[queriesSize];

    // Testing with each array
    printf("Results for arr0:\n");
    xorQueries(arr0, 4, queries, queriesSize, result);
    for (int i = 0; i < queriesSize; i++) {
        printf("%d ", result[i]);
    }
    printf("\n");

    printf("Results for arr1:\n");
    xorQueries(arr1, 4, queries, queriesSize, result);
    for (int i = 0; i < queriesSize; i++) {
        printf("%d ", result[i]);
    }
    printf("\n");

    printf("Results for arr2:\n");
    xorQueries(arr2, 4, queries, queriesSize, result);
    for (int i = 0; i < queriesSize; i++) {
        printf("%d ", result[i]);
    }
    printf("\n");

    return 0;
}