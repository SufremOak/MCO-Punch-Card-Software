#include <stdio.h>
#include <conio.h>

#define ROWS 6
#define COLS 3

char grid[ROWS][COLS];

void clearGrid() {
    for (int r = 0; r < ROWS; r++)
        for (int c = 0; c < COLS; c++)
            grid[r][c] = '.';
}

void displayGrid() {
    clrscr();
    printf("MCO Flipent - Apple IIc\n\n");

    for (int r = 0; r < ROWS; r++) {
        for (int c = 0; c < COLS; c++) {
            printf(" %c ", grid[r][c]);
        }
        printf("\n");
    }
    printf("\nEnter resume-pattern: ");
}

void parsePattern(const char* pattern) {
    clearGrid();
    int len = strlen(pattern);
    int index = 0;

    for (int r = 0; r < ROWS && index < len; r++) {
        for (int c = 0; c < COLS && index < len; c++) {
            grid[r][c] = (pattern[index] == '1') ? '#' : '.';
            index++;
        }
    }
}

int main() {
    char pattern[20];

    clearGrid();
    displayGrid();

    gets(pattern); // Read input from user
    parsePattern(pattern);

    displayGrid();

    while (1); // Keep program running
    return 0;
}
