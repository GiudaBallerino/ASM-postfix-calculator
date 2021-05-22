// Stack
int _index = 0;
int stack[50] = {0};

int pop() {
  return stack[--_index];
}

void push(int value) {
  stack[_index++] = value;
}
// ----
#include <stdio.h>


void postfix(char[], char[]);

int main() {

  // char input[10] = "2 3 + 4 *";
  char input[10] = "2 3 +";
  char output[10];

  postfix(input, output);

  printf("%s", output);

  return 0;
}

void postfix(char input[], char output[]) {

  int number = 0;
  int negative = 0;
  int before = '\0';

  for(int i=0; input[i] != '\0'; i++) {
    char c = input[i];

    if (c == '+') { // somma
      int n1 = pop();
      int n2 = pop();
      printf("%i %i \n", n1, n2);
      int result = n1 + n2;
      push(result);
    }
    else if (c == '-') {
      negative = 1; // negativo!?
    }
    else if (c == '*') { // moltiplicazione
      int n1 = pop();
      int n2 = pop();
      int result = n1 * n2;
      push(result);
    }
    else if (c == '/') { // divisione
      int n1 = pop();
      int n2 = pop();
      int result = n1 / n2;
      push(result);
    }
    else if (c >= '0' && c <= '9') {
      int n = c - '0';
      number = number * 10 + n;
    }
    else if (c == ' ') {
      if (before == '-') {
        int n1 = pop();
        int n2 = pop();
        int result = n1 - n2;
        push(result);
      }
      else {
        if (negative == 1) {
          number *= -1;
          negative = 0;
        }
        printf("save %i \n", number);
        push(number);
        number = 0;
      }
    }

    before = c;
  }

  if (before == '-') {
    int n1 = pop();
    int n2 = pop();
    int result = n1 - n2;
    push(result);
  }

  int result = pop();
  printf("%i\n", result);
  
}
