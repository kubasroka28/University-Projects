(* # -*- mode: c; -*- *)

let with_runtime p =
  Printf.sprintf
  {|
#include <stdlib.h>
#include <stdio.h>

#define HEAP_SIZE  10000000
#define STACK_SIZE 10000
#define ENV_SIZE   10000
#define RET_SIZE   10000

int heap[HEAP_SIZE];
int heap_ptr = 0; // first free cell

int stack[STACK_SIZE];
int stack_ptr = -1; // top-most element on the stack

int env[ENV_SIZE];
int env_ptr = -1; // top-most element in env

int ret[RET_SIZE];
int ret_ptr = -1; //top-most elem on the return stack

// heap objects
#define EVAC 0 // object evacuated by gc to the other heap
#define INT  1
#define BOOL 2
#define UNIT 3
#define PAIR 4
#define CLO  100 // tag for closure is CLO + size of stored env

void print_heap_obj(int ptr)
{
  switch (heap[ptr-1])
  {
    case EVAC:
      printf("<evac>");
      break;
    case INT:
      printf("%%d", heap[ptr]);
      break;
    case BOOL:
      if (heap[ptr])
        printf("true");
      else
        printf("false");
      break;
    case UNIT:
      printf("()");
      break;
    case PAIR:
      printf("(");
      print_heap_obj(heap[ptr]);
      printf(",");
      print_heap_obj(heap[ptr+1]);
      printf(")");
      break;
    default:
      printf("<fun>");
  }
}

// garbage collection
%s

void pre_alloc(int size)
{
  if (HEAP_SIZE - heap_ptr <= size)
    collect();
}

// chcecking the size of stack each time we push is a major
// performance bottleneck, but for now we leave it like this,
// because we're too lazy to statically calculate the space
// needed for each expression.
void check_stack()
{
  if (stack_ptr >= STACK_SIZE - 1)
  {
    printf("stack overflow!\n");
    exit(-1);
  }
}

void check_env()
{
  if (env_ptr >= ENV_SIZE - 1)
  {
    printf("stack overflow!\n");
    exit(-1);
  }
}

void check_ret()
{
  if (ret_ptr >= RET_SIZE - 1)
  {
    printf("stack overflow!\n");
    exit(-1);
  }
}

#define GOTO(l) { jumpto = l; goto trampoline; }

int main()
{
  int jumpto = 0;
  trampoline:
  switch (jumpto)
  {
  case 0:
%s
  }
  print_heap_obj(stack[0]);
  printf("\n");
  print_gc_stats();
  return 0;
}
  |}
  Gc.gc
  p
